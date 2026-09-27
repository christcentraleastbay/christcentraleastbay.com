#!/usr/bin/env bash
# Render a sermon audio recording into a YouTube-ready MP4:
# static background artwork + animated gold waveform + loudness-normalized audio.
#
# Usage:
#   render-sermon-video.sh <input-audio> <background-image> <output.mp4> [work-dir]
#
# Requires: ffmpeg and ffprobe (7.x) on PATH.
#
# Audio pipeline (speech-oriented, no pumping):
#   pass 1  measure the source (EBU R128 integrated loudness + true peak)
#   pass 2  high-pass -> gain -> gentle top-only compressor -> peak limiter,
#           measured again (up to three quick iterations) to calibrate the
#           gain so the result lands on the target loudness
#   pass 3  same chain with the calibrated gain, encoded with the video
#
# Video: 1920x1080 H.264 (yuv420p), 30 fps, AAC 192 kbps 48 kHz, faststart.

set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "usage: $0 <input-audio> <background-image> <output.mp4> [work-dir]" >&2
  exit 2
fi

INPUT="$1"
BACKGROUND="$2"
OUTPUT="$3"
WORK="${4:-$(mktemp -d)}"
mkdir -p "$WORK"

# Tunables (override via environment).
TARGET_I="${TARGET_I:--14}"        # integrated loudness target (LUFS); YouTube normalizes to about -14
LIMIT_DB="${LIMIT_DB:--2}"         # sample-peak limiter ceiling (dB), leaves margin for inter-sample peaks
COMP="${COMP:-acompressor=threshold=-6dB:ratio=3:attack=2:release=100:knee=3}" # only tames the loudest peaks
CAL_TOLERANCE="${CAL_TOLERANCE:-0.3}" # stop calibrating within this many LU of target
WAVE_COLOR="${WAVE_COLOR:-#F7C15E}" # gold from the artwork
WAVE_HEIGHT="${WAVE_HEIGHT:-230}"
WAVE_Y="${WAVE_Y:-845}"
WAVE_GAIN="${WAVE_GAIN:-1.25}"     # visual-only amplitude boost for the waveform
VIDEO_PRESET="${VIDEO_PRESET:-veryfast}"
VIDEO_CRF="${VIDEO_CRF:-21}"
FPS="${FPS:-30}"

log() { printf '[%s] %s\n' "$(date +%H:%M:%S)" "$*" >&2; }

# Pull a value out of an ebur128 summary block: ebur_value <log> <label>
ebur_value() { awk -v k="$2" '$1 == k { v = $2 } END { print v }' "$1"; }

LIMIT_LIN=$(awk -v db="$LIMIT_DB" 'BEGIN { printf "%.4f", 10 ^ (db / 20) }')
chain() { # chain <gain-dB>
  printf 'highpass=f=80,volume=%sdB,%s,alimiter=limit=%s:attack=5:release=50:level=false' "$1" "$COMP" "$LIMIT_LIN"
}
MEASURE="ebur128=peak=true:framelog=quiet"

# --- Pass 1: measure the source -------------------------------------------
log "pass 1/3: measuring source loudness"
ffmpeg -hide_banner -nostats -y -i "$INPUT" -af "$MEASURE" -f null - 2> "$WORK/measure1.log"
IN_I=$(ebur_value "$WORK/measure1.log" "I:")
IN_TP=$(ebur_value "$WORK/measure1.log" "Peak:")
IN_LRA=$(ebur_value "$WORK/measure1.log" "LRA:")
log "source: integrated ${IN_I} LUFS, true peak ${IN_TP} dBTP, LRA ${IN_LRA} LU"

# --- Pass 2: calibrate the gain through the processing chain ---------------
# First guess: straight gain to target. Each iteration measures the chain's
# output and corrects the gain (secant step once two points are known).
G=$(awk -v t="$TARGET_I" -v i="$IN_I" 'BEGIN { printf "%.2f", t - i }')
PREV_G=""; PREV_I=""
for iter in 1 2 3; do
  log "pass 2/3: calibrating, iteration ${iter} (gain ${G} dB)"
  ffmpeg -hide_banner -nostats -y -i "$INPUT" -af "$(chain "$G"),$MEASURE" -f null - 2> "$WORK/measure2-${iter}.log"
  TRIAL_I=$(ebur_value "$WORK/measure2-${iter}.log" "I:")
  TRIAL_LRA=$(ebur_value "$WORK/measure2-${iter}.log" "LRA:")
  log "  -> ${TRIAL_I} LUFS, LRA ${TRIAL_LRA} LU"
  if awk -v t="$TARGET_I" -v i="$TRIAL_I" -v tol="$CAL_TOLERANCE" 'BEGIN { d = t - i; if (d < 0) d = -d; exit !(d <= tol) }'; then
    break
  fi
  NEXT_G=$(awk -v g="$G" -v i="$TRIAL_I" -v pg="$PREV_G" -v pi="$PREV_I" -v t="$TARGET_I" 'BEGIN {
    slope = 1
    if (pg != "" && i != pi) { slope = (i - pi) / (g - pg); if (slope < 0.25) slope = 0.25; if (slope > 1) slope = 1 }
    printf "%.2f", g + (t - i) / slope }')
  PREV_G="$G"; PREV_I="$TRIAL_I"; G="$NEXT_G"
done
G1="$G"
log "final gain ${G1} dB"

# --- Pass 3: encode the video ---------------------------------------------
log "pass 3/3: encoding video -> $OUTPUT"
WAVE="volume=${WAVE_GAIN},showwaves=s=137x${WAVE_HEIGHT}:mode=cline:rate=${FPS}:scale=sqrt:colors=${WAVE_COLOR}@0.95,tmix=frames=3,scale=1920:${WAVE_HEIGHT}:flags=neighbor,drawgrid=w=14:h=0:t=5:c=black@0:replace=1,format=yuva420p"
ffmpeg -hide_banner -nostats -y \
  -i "$INPUT" \
  -loop 1 -framerate "$FPS" -i "$BACKGROUND" \
  -filter_complex "[0:a]$(chain "$G1"),asplit=3[a_out][a_vis][a_meas];[a_meas]${MEASURE},anullsink;[a_vis]${WAVE}[wave];[1:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1,format=yuv420p[bg];[bg][wave]overlay=0:${WAVE_Y}:format=yuv420:shortest=1[v_out]" \
  -map "[v_out]" -map "[a_out]" \
  -c:v libx264 -preset "$VIDEO_PRESET" -crf "$VIDEO_CRF" -profile:v high -pix_fmt yuv420p -r "$FPS" -g 60 \
  -c:a aac -b:a 192k -ar 48000 \
  -movflags +faststart -shortest \
  -progress "$WORK/progress.log" \
  "$OUTPUT" 2> "$WORK/encode.log"

OUT_I=$(ebur_value "$WORK/encode.log" "I:")
OUT_TP=$(ebur_value "$WORK/encode.log" "Peak:")
OUT_LRA=$(ebur_value "$WORK/encode.log" "LRA:")
log "output audio: integrated ${OUT_I} LUFS, true peak ${OUT_TP} dBTP, LRA ${OUT_LRA} LU"
log "done: $OUTPUT"

# Sermon video renderer

Turns a sermon audio recording into a 1080p MP4 for YouTube: the series
artwork as a static background, an animated gold waveform along the bottom,
and audio normalized to YouTube's loudness target.

## Requirements

- `ffmpeg` and `ffprobe` 7.x on `PATH` (a static build from
  https://johnvansickle.com/ffmpeg/ works).
- A 1920x1080 background image (other sizes are letterboxed to fit).

## Usage

One recording:

```sh
scripts/sermon-video/render-sermon-video.sh sermon.wav background.jpg sermon.mp4
```

A whole folder (outputs named after the source files; already-rendered files
are skipped, so re-running after an interruption picks up where it left off):

```sh
scripts/sermon-video/render-folder.sh recordings/ background.jpg videos/
```

## What it does

Audio, tuned for speech. Service recordings often mix loud worship music
with a much quieter sermon, so the chain levels sections as well as
normalizing the whole file:

1. Measures the source with the EBU R128 meter.
2. High-pass at 80 Hz (removes rumble and handling noise), pre-gain so the
   source's peaks sit at -3 dB, a 3:1 compressor that tames speech peaks
   (threshold -30 dB), a section leveler (`dynaudnorm`, 7.5 s window, up to
   30 dB of lift) that evens out quiet and loud passages, a calibration trim,
   and a peak limiter at -2 dB.
3. Calibrates the trim in up to three quick measurement passes so the
   result lands on -14 LUFS integrated (YouTube's reference level) with
   true peaks under -1 dBTP. Expect a loudness range of roughly 5 to 10 LU.

Video: H.264 high profile, 1920x1080, 30 fps, CRF 21, AAC 192 kbps at
48 kHz, `faststart` for streaming. An hour-long sermon renders in roughly
half an hour on four cores and produces a file of about 200 MB.

Tunables are environment variables at the top of `render-sermon-video.sh`
(target loudness, limiter ceiling, waveform color, height, position, encoder
preset and CRF).

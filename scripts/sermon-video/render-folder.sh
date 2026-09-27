#!/usr/bin/env bash
# Render every audio recording in a folder to a YouTube-ready MP4.
#
# Usage:
#   render-folder.sh <input-dir> <background-image> <output-dir>
#
# Processes .wav/.mp3/.m4a/.flac files one at a time, names each output after
# the source file, and skips files whose MP4 already exists in <output-dir>,
# so an interrupted run can simply be started again.

set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "usage: $0 <input-dir> <background-image> <output-dir>" >&2
  exit 2
fi

INPUT_DIR="$1"
BACKGROUND="$2"
OUTPUT_DIR="$3"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$OUTPUT_DIR"

shopt -s nullglob nocaseglob
files=("$INPUT_DIR"/*.wav "$INPUT_DIR"/*.mp3 "$INPUT_DIR"/*.m4a "$INPUT_DIR"/*.flac)
shopt -u nullglob nocaseglob

if [[ ${#files[@]} -eq 0 ]]; then
  echo "no audio files found in $INPUT_DIR" >&2
  exit 1
fi

done_count=0; skipped=0; failed=()
for src in "${files[@]}"; do
  name="$(basename "${src%.*}")"
  out="$OUTPUT_DIR/$name.mp4"
  if [[ -s "$out" ]]; then
    echo "skip (exists): $out" >&2
    skipped=$((skipped + 1))
    continue
  fi
  echo "=== $name" >&2
  work="$OUTPUT_DIR/.work/$name"
  if "$HERE/render-sermon-video.sh" "$src" "$BACKGROUND" "$out.partial.mp4" "$work"; then
    mv "$out.partial.mp4" "$out"
    rm -rf "$work"
    done_count=$((done_count + 1))
  else
    echo "FAILED: $name (logs in $work)" >&2
    rm -f "$out.partial.mp4"
    failed+=("$name")
  fi
done

echo "rendered: $done_count, skipped: $skipped, failed: ${#failed[@]}" >&2
if [[ ${#failed[@]} -gt 0 ]]; then
  printf '  %s\n' "${failed[@]}" >&2
  exit 1
fi

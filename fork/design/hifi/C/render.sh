#!/bin/sh
# Render states of concept.html at 1920x1080 and 1280x720. Usage: render.sh 3 [1 2 ...]
# One headless Chromium at a time; profile in a scratch dir, deleted after.
set -e
D="$(cd "$(dirname "$0")" && pwd)"
H=$(ls -d ~/.cache/ms-playwright/chromium_headless_shell-1254/*/chrome-headless-shell)
SCR="${SCRATCH:-/tmp/hifi-C-$$}"; mkdir -p "$SCR"
[ -e ~/.disk-low ] && { echo "disk low: not rendering"; rm -rf "$SCR"; exit 1; }
for s in "$@"; do
  "$H" --no-sandbox --headless --disable-gpu --hide-scrollbars --window-size=1920,1080 --virtual-time-budget=8000 \
    --user-data-dir="$SCR/prof" --screenshot="$D/s$s.png" "file://$D/concept.html?state=$s" 2>/dev/null
  "$H" --no-sandbox --headless --disable-gpu --hide-scrollbars --window-size=1280,720 --virtual-time-budget=8000 \
    --user-data-dir="$SCR/prof" --screenshot="$D/s$s-720.png" "file://$D/concept.html?state=$s" 2>/dev/null
  "$H" --no-sandbox --headless --disable-gpu --window-size=1920,1080 --virtual-time-budget=8000 \
    --user-data-dir="$SCR/prof" --dump-dom "file://$D/concept.html?state=$s&check=1" 2>/dev/null | sed -n '/<pre id="chk">/,/<\/pre>/p' | sed 's/<[^>]*>//g' > "$SCR/chk$s.txt" || true
  echo "state $s:"; cat "$SCR/chk$s.txt"
done
rm -rf "$SCR"

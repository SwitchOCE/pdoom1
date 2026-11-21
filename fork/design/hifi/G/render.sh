#!/bin/bash
# Render G's states: full-size PNGs (uncommitted), 720p checks, WebP showcase images,
# and the in-page layout check. Usage: ./render.sh 3 [1 2 ...]
cd "$(dirname "$0")"
[ -e ~/.disk-low ] && { echo "disk low, stopping"; exit 1; }
H=$(ls -d ~/.cache/ms-playwright/chromium_headless_shell-1254/*/chrome-headless-shell)
SCR=/tmp/claude-1000/gscratch; mkdir -p "$SCR"
shot(){ "$H" --no-sandbox --headless --disable-gpu --hide-scrollbars --window-size=$1 --virtual-time-budget=5000 \
  --user-data-dir="$SCR/prof" --screenshot="$PWD/$2" "file://$PWD/concept.html?$3" >/dev/null 2>&1; }
for s in "$@"; do
  shot 1920,1080 s$s.png "state=$s"
  shot 1280,720 s$s-720.png "state=$s"
  "$H" --no-sandbox --headless --disable-gpu --window-size=1920,1080 --virtual-time-budget=5000 \
    --user-data-dir="$SCR/prof" --dump-dom "file://$PWD/concept.html?state=$s&check=1" 2>/dev/null \
    | grep -o 'data-check="[^"]*"' | sed "s/^/state $s: /"
  python3 -c "from PIL import Image;Image.open('s$s.png').convert('RGB').save('s$s.webp',quality=88,method=6)"
done
rm -rf "$SCR/prof"
ls -la s*.png s*.webp

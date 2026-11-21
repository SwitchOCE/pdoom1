#!/bin/sh
# Render states of concept.html (?still=1) at 1920x1080 and 1280x720, run the layout
# check (?check=1) and measure text contrast on the rendered pixels (measure.py).
# Usage: SCRATCH=<dir> sh render.sh 1 [2 ...]. One headless Chromium at a time; scratch deleted.
set -e
D="$(cd "$(dirname "$0")" && pwd)"
H=$(ls -d ~/.cache/ms-playwright/chromium_headless_shell-1254/*/chrome-headless-shell)
SCR="${SCRATCH:-/tmp/hifi3-C-$$}"; mkdir -p "$SCR"
[ -e ~/.disk-low ] && { echo "disk low: not rendering"; rm -rf "$SCR"; exit 1; }
run(){ "$H" --no-sandbox --headless --disable-gpu --hide-scrollbars --virtual-time-budget=9000 --user-data-dir="$SCR/prof" "$@" 2>/dev/null; }
for s in "$@"; do
  run --window-size=1920,1080 --screenshot="$D/s$s.png" "file://$D/concept.html?state=$s&still=1"
  run --window-size=1280,720 --screenshot="$D/s$s-720.png" "file://$D/concept.html?state=$s&still=1"
  run --window-size=1920,1080 --dump-dom "file://$D/concept.html?state=$s&check=1" | sed -n '/<pre id="check">/,/CHECK-END/p' | sed 's/<[^>]*>//g;s/&amp;/\&/g;s/&gt;/>/g;s/&lt;/</g' > "$SCR/chk$s.txt" || true
  echo "== state $s"; grep -v '^TXT ' "$SCR/chk$s.txt" | grep -v 'CHECK-'
  python3 "$D/measure.py" "$SCR/chk$s.txt" "$D/s$s.png" "$D/s$s-720.png"
done
rm -rf "$SCR"

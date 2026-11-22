#!/bin/bash
# Render H-HF: sN.png (1920x1080) and sN-720.png (1280x720), uncommitted; sN.webp (committed);
# the layout check; and the pixel contrast measure (contrast.py). Usage: ./render.sh 1 4 5
# Extra: BAND=n ./render.sh 1 renders band-n.png with ?band=n (for checking the layer only).
# One headless Chromium at a time; its profile and the scratch are deleted at the end.
cd "$(dirname "$0")"
[ -e ~/.disk-low ] && { echo "disk low, stopping"; exit 1; }
H=$(ls -d ~/.cache/ms-playwright/chromium_headless_shell-*/*/chrome-headless-shell | tail -1)
SCR=/tmp/claude-1000/hhfscratch; mkdir -p "$SCR"
run(){ "$H" --no-sandbox --headless --disable-gpu --hide-scrollbars --virtual-time-budget=8000 --user-data-dir="$SCR/prof" "$@" 2>/dev/null; }
for s in "$@"; do
  if [ -n "$BAND" ]; then run --window-size=1920,1080 --screenshot="$PWD/band-$BAND.png" "file://$PWD/concept.html?state=$s&still=1&band=$BAND" >/dev/null; continue; fi
  run --window-size=1920,1080 --screenshot="$PWD/s$s.png" "file://$PWD/concept.html?state=$s&still=1" >/dev/null
  run --window-size=1280,720 --screenshot="$PWD/s$s-720.png" "file://$PWD/concept.html?state=$s&still=1" >/dev/null
  run --window-size=1920,1080 --dump-dom "file://$PWD/concept.html?state=$s&check=1" > "$SCR/dom$s.html"
  python3 -c "
import sys,re,html
d=open(sys.argv[1]).read();m=re.search(r'CHECK-BEGIN\n(.*?)\nCHECK-END',d,re.S)
lines=html.unescape(m.group(1)).split('\n') if m else ['NO CHECK OUTPUT']
open(sys.argv[2],'w').write('\n'.join(l[4:] for l in lines if l.startswith('TXT ')))
print('state '+sys.argv[3]+': '+(' | '.join(l for l in lines if not l.startswith('TXT ')) or 'CLEAN'))" "$SCR/dom$s.html" "$SCR/txt$s.csv" "$s"
  python3 contrast.py "$SCR/txt$s.csv" "s$s.png" "s$s-720.png"
  python3 -c "
from PIL import Image;import os
im=Image.open('s$s.png').convert('RGB')
for q in (99,98,97,96,95,92,90,88,85,80):
    im.save('s$s.webp',quality=q,method=6)
    if os.path.getsize('s$s.webp')<=310000: break
print('  webp q',q,os.path.getsize('s$s.webp')//1024,'KB')"
done
rm -rf "$SCR"

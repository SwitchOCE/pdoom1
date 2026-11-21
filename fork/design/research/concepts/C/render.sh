#!/bin/sh
# Render all views of concept.html to PNG with headless Edge.
D="$(cd "$(dirname "$0")" && pwd -W)"
EDGE="/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
for v in ${@:-m1 m5 watch place2 door}; do
  "$EDGE" --headless=new --disable-gpu --hide-scrollbars --window-size=1920,1080 --virtual-time-budget=6000 \
    --user-data-dir="$LOCALAPPDATA/Temp/edge-C" --screenshot="$D/$v.png" "file:///$D/concept.html?view=$v" 2>/dev/null
done

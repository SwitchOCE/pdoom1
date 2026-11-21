#!/bin/bash
# usage: bash render.sh [view ...]
D="$(cd "$(dirname "$0")" && pwd -W)"
EDGE="/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
for v in "${@:-home home-m1 actions plan door upgrades watch}"; do
  for vv in $v; do
    "$EDGE" --headless=new --disable-gpu --hide-scrollbars --window-size=1920,1080 --virtual-time-budget=5000 \
      --user-data-dir="$LOCALAPPDATA/Temp/edge-A" --screenshot="$D/$vv.png" "file:///$D/concept.html?view=$vv" 2>/dev/null
  done
done

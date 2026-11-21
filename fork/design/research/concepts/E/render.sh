#!/bin/bash
# Renders views of concept.html to PNG with headless Edge. Usage: bash render.sh [view ...]
E="C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E"
VIEWS="$*"; [ -z "$VIEWS" ] && VIEWS="home home-m1 actions plan door watch"
for v in $VIEWS; do
  OUT="$(cygpath -w "$E/$v.png")"
  "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" --headless=new --disable-gpu --hide-scrollbars \
    --window-size=1920,1080 --virtual-time-budget=4000 --user-data-dir="$LOCALAPPDATA/Temp/edge-E" \
    --screenshot="$OUT" "file:///$E/concept.html?view=$v" 2>&1 | grep -o "bytes written.*"
done

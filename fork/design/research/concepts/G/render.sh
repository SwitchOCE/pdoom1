#!/bin/bash
# Render every view of concept.html with headless Edge (Git Bash).
cd "$(dirname "$0")"
WIN=$(cygpath -w "$PWD")
for v in home-m1 home actions plan upgrades watch; do
  "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" --headless=new --disable-gpu --window-size=1920,1080 --virtual-time-budget=4000 --user-data-dir="$LOCALAPPDATA/Temp/edge-G-$v" --screenshot="$WIN/$v.png" "file:///C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/G/concept.html?view=$v" >/dev/null 2>&1
done
ls -la *.png

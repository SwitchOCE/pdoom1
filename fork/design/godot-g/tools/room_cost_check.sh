#!/bin/bash
# G 3a room cost check for Alex's PC (spec 5.14 "Cost"). Git Bash, from the checkout root of a
# worktree that has ui/g-room (or lean once 3a is merged). Takes about a minute.
#
# What it does: boots the real game into the G desk in a throwaway profile (never the real
# one), holds the room at band 3, turns VSync off, and times frames: plain room (today's dim
# room, room effects "off") against the graded room (room effects "full", the shader), same UI,
# in the order plain, graded, graded, plain (45 warm-up frames, then 240 timed frames each).
#
# What to read: the last three G_CAPTURE ROOMCOST lines, e.g.
#   G_CAPTURE ROOMCOST plain  mean 4.100 ms ...
#   G_CAPTURE ROOMCOST graded mean 4.600 ms ...
#   G_CAPTURE ROOMCOST delta 0.500 ms per frame; budget 2.0 ms: WITHIN
# The number that matters is "delta": the graded room's extra cost per frame. Budget 2 ms.
# Over 2 ms -> room effects "simple" becomes the default (one constant in g_prefs.gd).
# Also note the "renderer ... adapter ..." line: it should name the real GPU, not llvmpipe.
#
# Run the game window at 1920x1080 (the --resolution below); keep it on screen, do not
# minimise it while it runs.
set -u
: "${PDOOM1_GODOT:?set PDOOM1_GODOT to the Godot 4.5.1 console exe}"
ISO="$LOCALAPPDATA/Temp/godot-iso-roomcost"
rm -rf "$ISO"; mkdir -p "$ISO"
APPDATA="$LOCALAPPDATA/Temp/godot-iso-cache" python tools/check_class_cache.py --repair > /dev/null
APPDATA="$ISO" "$PDOOM1_GODOT" --path godot --windowed --resolution 1920x1080 --position 0,0 \
  res://tests/visual/g_capture.tscn -- --mode=roomcost --layout=g 2>&1 | tee "$ISO/roomcost.log" \
  | grep "G_CAPTURE ROOMCOST\|G_CAPTURE FAIL\|G_CAPTURE result"
# Optional second run on the fallback renderer: add  --rendering-method gl_compatibility
# after --path godot above.

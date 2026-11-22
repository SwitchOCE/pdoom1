#!/bin/bash
# Same-seed check for the G desk: plays the same month with the same seed and the same inputs
# once per layout, each in a fresh Godot process with its own empty profile, and prints the
# sha256 of GameManager.state.to_dict() at the start of month 2. Equal hashes = the run played
# out the same. The fixture is godot/tests/visual/g_capture.tscn (see its header).
#
# usage (Git Bash on Windows, or Linux), from the repo root:
#   GODOT=/path/to/Godot_v4.5.1 bash fork/design/godot-g/tools/same_seed.sh [LAYOUTS...]
#   LAYOUTS default to "classic g". On a checkout without G (today's game), copy
#   godot/tests/visual/g_capture.gd and g_capture.tscn in first and run with "classic" only.
#   MODE=shots OUT=/abs/dir ... saves the fixture's screenshots (PNG + JSON) instead; the
#   run still prints its hash.
#
# Profiles go under ${SAME_SEED_DIR:-$PWD/.same-seed} and are removed first. On Linux,
# xvfb-run is used when present (a 1920x1080 virtual screen). Tested on Linux (Godot 4.5.1); not yet on Windows.
set -u
GODOT=${GODOT:-${PDOOM1_GODOT:-godot}}
LAYOUTS=${*:-classic g}
ROOT=$(pwd)
BASE=${SAME_SEED_DIR:-$ROOT/.same-seed}
SEED=g-parity-1
MODE=${MODE:-parity}
ARGS="--mode=$MODE"
[ -n "${OUT:-}" ] && { mkdir -p "$OUT"; ARGS="$ARGS --out=$OUT"; }
[ -f godot/tests/visual/g_capture.tscn ] || { echo "no godot/tests/visual/g_capture.tscn here"; exit 2; }
if [ -f tools/check_class_cache.py ]; then
  APPDATA="$BASE/class-cache" python tools/check_class_cache.py --repair > /dev/null 2>&1 \
    || { echo "class cache repair failed"; exit 2; }
fi
WRAP=""
if [ "$(uname -s)" = "Linux" ] && command -v xvfb-run > /dev/null; then
  WRAP=1
fi
declare -A HASH
for L in $LAYOUTS; do
  P="$BASE/$L"
  rm -rf "$P"; mkdir -p "$P"
  # Godot's user:// for this project: %APPDATA%/Godot/app_userdata/P(Doom) on Windows,
  # $XDG_DATA_HOME/godot/app_userdata/P(Doom) on Linux. Both point into $P.
  case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) U="$P/appdata/Godot/app_userdata/P(Doom)" ;;
    *) U="$P/data/godot/app_userdata/P(Doom)" ;;
  esac
  mkdir -p "$U" "$P/home" "$P/config" "$P/cache"
  printf '[game]\n\nlast_seed="%s"\n' "$SEED" > "$U/config.cfg"
  if [ "$L" = "g" ]; then D=true; else D=false; fi
  printf '[g]\n\ndesk=%s\n' "$D" > "$U/g_ui.cfg"
  LOG="$P/run.log"
  if [ -n "$WRAP" ]; then
    APPDATA="$P/appdata" HOME="$P/home" XDG_DATA_HOME="$P/data" XDG_CONFIG_HOME="$P/config" \
      XDG_CACHE_HOME="$P/cache" timeout 600 xvfb-run -a -s "-screen 0 1920x1080x24" "$GODOT" \
      --path godot --windowed --resolution 1920x1080 res://tests/visual/g_capture.tscn \
      -- $ARGS --layout=$L > "$LOG" 2>&1
  else
    APPDATA="$P/appdata" HOME="$P/home" XDG_DATA_HOME="$P/data" XDG_CONFIG_HOME="$P/config" \
      XDG_CACHE_HOME="$P/cache" timeout 600 "$GODOT" \
      --path godot --windowed --resolution 1920x1080 res://tests/visual/g_capture.tscn \
      -- $ARGS --layout=$L > "$LOG" 2>&1
  fi
  echo "[$L] exit $?  $(grep '^G_CAPTURE result' "$LOG")  log $LOG"
  HASH[$L]=$(grep "^G_CAPTURE HASH" "$LOG" | awk '{print $NF}')
done
for L in $LAYOUTS; do echo "HASH $L ${HASH[$L]:-<none>}"; done

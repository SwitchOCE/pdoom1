#!/usr/bin/env bash
set -euo pipefail

sources="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo="$(cd -- "$sources/../../../.." && pwd)"
work=/data/pdoom1-spikes
project="$work/project"
godot=/data/godot-4.5.1/Godot_v4.5.1-stable_linux.x86_64
mode="${1:-all}"

case "$mode" in
    all|prepare|shader|shader-compat|font|dateline) ;;
    *) printf 'Usage: %s [all|prepare|shader|shader-compat|font|dateline]\n' "$0" >&2; exit 2 ;;
esac

mkdir -p "$work"/{home,xdg/data,xdg/config,xdg/cache,tmp,logs,movies,shots,inputs/fonts} \
    "$project/assets/"{fonts,sfx}
export TMPDIR="$work/tmp"
touch "$TMPDIR/Xauthority"

run_godot() {
    env HOME="$work/home" XDG_DATA_HOME="$work/xdg/data" \
        XDG_CONFIG_HOME="$work/xdg/config" XDG_CACHE_HOME="$work/xdg/cache" \
        PDOOM_SPIKE_SHOTS="${PDOOM_SPIKE_SHOTS:-$work/shots}" timeout 150s \
        xvfb-run -a -f "$TMPDIR/Xauthority" -s '-screen 0 1920x1080x24' \
        "$godot" --path "$project" --audio-driver Dummy "$@"
}

logged_godot() {
    local log="$work/logs/$1.log"
    shift
    if ! run_godot "$@" > "$log" 2>&1; then
        tail -40 "$log" >&2
        return 1
    fi
    if rg -n '(^| )(SCRIPT ERROR|ERROR):' "$log"; then
        return 1
    fi
    rg '^(ENV|FONT|SIZE|AUDIO_DRIVER|CHECK|SKIP|FRAME|BAND|TWEEN|SHOT|Movie Maker|Vulkan|OpenGL)' "$log" || true
}

prepare() {
    cp -- "$sources/"*.{godot,tscn,tres,gd,gdshader} "$project/"
    cp -- "$repo/godot/assets/images/backgrounds/office_wide_day.webp" "$project/assets/"
    while read -r path expected url; do
        if ! printf '%s  %s\n' "$expected" "$work/inputs/$path" | sha256sum -c --status; then
            curl --fail --silent --show-error --location --max-time 30 \
                --output "$work/inputs/$path" "$url"
        fi
        printf '%s  %s\n' "$expected" "$work/inputs/$path" | sha256sum -c --status
        cp -- "$work/inputs/$path" "$project/assets/$path"
    done < "$sources/assets.tsv"
    python3 "$sources/synthesize.py" "$project/assets/sfx" \
        "$repo/fork/design/hifi3/H/dateline-sound.wav" > "$work/logs/synthesis.log"
    logged_godot import --headless --editor --import
}

prepare
if [[ "$mode" == all || "$mode" == shader ]]; then
    logged_godot shader --verbose --resolution 1920x1080 --position 0,0 -- shader
fi
if [[ "$mode" == all || "$mode" == shader-compat ]]; then
    logged_godot shader-compat --verbose --rendering-method gl_compatibility \
        --resolution 1920x1080 --position 0,0 -- shader quick
fi
if [[ "$mode" == all || "$mode" == font ]]; then
    for size in 1920x1080 1280x720; do
        logged_godot "font-$size" --resolution "$size" --position 0,0 -- font
    done
fi
if [[ "$mode" == all || "$mode" == dateline ]]; then
    for clip in dateline dateline-skip; do
        logged_godot "$clip" --resolution 960x540 --fixed-fps 60 \
            --write-movie "$work/movies/$clip.avi" -- "$clip"
    done
    logged_godot dateline-new-date --resolution 960x540 --fixed-fps 60 -- dateline-new-date
    python3 "$sources/measure_sync.py" "$work" | tee "$work/logs/sync.csv"
fi

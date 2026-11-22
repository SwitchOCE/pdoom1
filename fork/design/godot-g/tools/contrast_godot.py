"""Pixel contrast of every text box in a Godot G capture (spec.md 4.5).

Adapted from fork/design/hifi3/G/contrast.py. Same method as H (H spec 2.8):
background = median luminance of the box; text = the stroke core, the k-th
pixel farthest from the background, k = max(4, 0.5% of the box).

Input: pairs of (PNG, JSON) written by tests/visual/g_capture.gd. The JSON is
either a list of boxes or {"boxes": [...]}; each box is
{"x": .., "y": .., "w": .., "h": .., "text": ..} (or "rect": [x, y, w, h]),
in the PNG's own pixel space (the harness saves boxes at the capture size).

Usage: contrast_godot.py [--floor 4.5] [--show N] shot.png boxes.json [shot2.png boxes2.json ...]
Exit 0 if every box reaches the floor, 1 if any is under it, 2 on bad input.
"""
import json
import sys
from pathlib import Path

from PIL import Image


def lum(p):
    def c(v):
        v /= 255.0
        return v / 12.92 if v <= 0.03928 else ((v + 0.055) / 1.055) ** 2.4
    return 0.2126 * c(p[0]) + 0.7152 * c(p[1]) + 0.0722 * c(p[2])


def measure(img, box):
    x, y, w, h = [int(round(v)) for v in box]
    x0, y0 = max(0, x), max(0, y)
    x1, y1 = min(img.width, x + w), min(img.height, y + h)
    if x1 - x0 < 2 or y1 - y0 < 2:
        return None
    crop = img.crop((x0, y0, x1, y1))
    data = crop.get_flattened_data() if hasattr(crop, "get_flattened_data") else crop.getdata()
    px = [lum(p) for p in data]
    bg = sorted(px)[len(px) // 2]
    k = max(4, int(len(px) * 0.005))
    far = sorted(px, key=lambda v: -abs(v - bg))[min(k, len(px)) - 1]
    hi, lo = max(bg, far), min(bg, far)
    return (hi + 0.05) / (lo + 0.05)


def load_boxes(path):
    raw = json.loads(Path(path).read_text(encoding="utf-8"))
    items = raw.get("boxes", []) if isinstance(raw, dict) else raw
    out = []
    for it in items:
        if "rect" in it:
            r = it["rect"]
        else:
            r = [it["x"], it["y"], it["w"], it["h"]]
        text = str(it.get("text", "")).replace("\n", " ").strip()
        if not text:
            continue
        out.append(([float(v) for v in r], text[:40], it.get("node", "")))
    return out


def main(argv):
    floor, show = 4.5, 12
    args = list(argv)
    while args and args[0].startswith("--"):
        flag = args.pop(0)
        if flag == "--floor":
            floor = float(args.pop(0))
        elif flag == "--show":
            show = int(args.pop(0))
        else:
            print("unknown flag " + flag)
            return 2
    if not args or len(args) % 2:
        print(__doc__)
        return 2
    worst_all = None
    failed = False
    for png, boxes_path in zip(args[0::2], args[1::2]):
        img = Image.open(png).convert("RGB")
        boxes = load_boxes(boxes_path)
        res = []
        for rect, text, node in boxes:
            r = measure(img, rect)
            if r is not None:
                res.append((r, text, node))
        if not res:
            print("%s: no measurable boxes" % png)
            failed = True
            continue
        res.sort(key=lambda t: t[0])
        under = [r for r in res if r[0] < floor]
        print("%s (%dx%d): %d boxes, lowest %.2f (%s), under %.1f: %d" % (
            Path(png).name, img.width, img.height, len(res), res[0][0], res[0][1], floor, len(under)))
        for r, text, node in under[:show]:
            print("  %.2f  %s  %s" % (r, text, node))
        if under:
            failed = True
        if worst_all is None or res[0][0] < worst_all:
            worst_all = res[0][0]
    if worst_all is not None:
        print("overall lowest %.2f" % worst_all)
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

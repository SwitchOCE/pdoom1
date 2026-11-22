"""Cut Sol's paper sheet into G's shipped 9-slice paper (spec.md 4.3, 11.2, 11.2a).

The recipe's centre square crop would cut away the scorched top and bottom edges of a
portrait sheet, so this keeps the whole sheet instead:
  1. find each side's dark backing strip: within the outer SCAN px, the darkest line
     (mean luminance over the middle 80% of that side) is the sheet's own burnt outline;
     everything outside it is the backing, and is trimmed;
  2. resize the whole trimmed sheet to 1024x1024 (Lanczos, one step), so all four worn
     edges and corners survive (the 9-slice stretches the middle back at any size);
  3. save PNG RGB, 8-bit, no metadata;
  4. a seam check: the 9-slice (margins 64, middle stretched as Godot's NinePatch and
     StyleBoxTexture do by default) drawn at 700x900 and 600x450, plus the middle tiled
     twice each way, side by side, into CHECK.png.
The original is never changed.

Usage: cut_paper.py SRC.png OUT.png CHECK.png
"""
import sys

import numpy as np
from PIL import Image

SIZE = 1024
MARGIN = 64
SCAN = 16


def side_trims(rgb):
    lum = np.asarray(rgb, dtype=np.float64).mean(axis=2)
    h, w = lum.shape
    y0, y1 = int(h * 0.1), int(h * 0.9)
    x0, x1 = int(w * 0.1), int(w * 0.9)
    left = lum[y0:y1, :SCAN].mean(axis=0)
    right = lum[y0:y1, w - SCAN:].mean(axis=0)[::-1]
    top = lum[:SCAN, x0:x1].mean(axis=1)
    bottom = lum[h - SCAN:, x0:x1].mean(axis=1)[::-1]

    def innermost_min(profile):
        m = profile.min()
        return int(max(i for i, v in enumerate(profile) if v <= m + 0.5))

    return {"left": innermost_min(left), "top": innermost_min(top),
            "right": innermost_min(right), "bottom": innermost_min(bottom)}


def nine_slice(tex, w, h, m, tile=False):
    """Godot's default 9-slice: corners 1:1, edges and middle stretched (or tiled)."""
    tw, th = tex.size
    out = Image.new("RGB", (w, h))
    xs = [(0, m, 0, m), (m, w - m, m, tw - m), (w - m, w, tw - m, tw)]
    ys = [(0, m, 0, m), (m, h - m, m, th - m), (h - m, h, th - m, th)]
    for dy0, dy1, sy0, sy1 in ys:
        for dx0, dx1, sx0, sx1 in xs:
            src = tex.crop((sx0, sy0, sx1, sy1))
            dw, dh = dx1 - dx0, dy1 - dy0
            if dw <= 0 or dh <= 0:
                continue
            if tile and ((sx1 - sx0) < dw or (sy1 - sy0) < dh):
                part = Image.new("RGB", (dw, dh))
                for ty in range(0, dh, sy1 - sy0):
                    for tx in range(0, dw, sx1 - sx0):
                        part.paste(src, (tx, ty))
            else:
                part = src.resize((dw, dh), Image.LANCZOS)
            out.paste(part, (dx0, dy0))
    return out


def main(argv):
    if len(argv) != 3:
        print(__doc__)
        return 2
    src, out_path, check_path = argv
    rgb = Image.open(src).convert("RGB")
    t = side_trims(rgb)
    w, h = rgb.size
    box = (t["left"], t["top"], w - t["right"], h - t["bottom"])
    sheet = rgb.crop(box).resize((SIZE, SIZE), Image.LANCZOS)
    sheet.save(out_path, "PNG", optimize=True)
    print("source %dx%d, trimmed left %d top %d right %d bottom %d -> crop %s -> %dx%d %s"
          % (w, h, t["left"], t["top"], t["right"], t["bottom"], box, SIZE, SIZE, out_path))
    a = nine_slice(sheet, 700, 900, MARGIN)
    b = nine_slice(sheet, 600, 450, MARGIN)
    c = nine_slice(sheet, 2 * (SIZE - 2 * MARGIN) + 2 * MARGIN, 900, MARGIN, tile=True)
    check = Image.new("RGB", (a.width + b.width + c.width + 80, 900), (9, 8, 7))
    check.paste(a, (20, 0))
    check.paste(b, (40 + a.width, 0))
    check.paste(c, (60 + a.width + b.width, 0))
    check.save(check_path)
    print("seam check " + check_path)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

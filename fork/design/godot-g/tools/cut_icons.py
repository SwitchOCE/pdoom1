"""Cut Sol's icon pictures into G's shipped 128x128 icons (spec.md 11.1).

Originals are never changed. Steps:
  1. if the picture has no transparency (alpha all 255), key flat black to alpha;
  2. trim to the alpha bounding box (alpha > 16);
  3. scale so the longer side is a share of the canvas (tier ladder, or one
     share for action icons), capped at 0.90 of the canvas height; Lanczos,
     one step from the original;
  4. tiers: centred horizontally, bottom-aligned on a baseline 6% above the
     canvas bottom; action icons: centred both ways;
  5. save 128x128 PNG RGBA, 8-bit, no metadata;
  6. a check sheet: each output at 32 and 40 px on the G `well` plate colour,
     beside a reference icon (Pip's resource_money_64.png by default).

Usage:
  cut_icons.py tiers  OUT_DIR SHEET.png --ref REF.png name-0=src0.png ... name-4=src4.png
  cut_icons.py action OUT_DIR SHEET.png --ref REF.png name=src.png ...
Tier is read from the trailing "-N" of each output name.

Shares used (tune once per resource from the check sheet and record here):
  default tiers: 0=0.74 1=0.50 2=0.64 3=0.78 4=0.88; action: 0.88.
"""
import sys
from pathlib import Path

from PIL import Image

CANVAS = 128
TIER_SHARE = {0: 0.74, 1: 0.50, 2: 0.64, 3: 0.78, 4: 0.88}
ACTION_SHARE = 0.88
HEIGHT_CAP = 0.90
BASELINE = 0.06
WELL = (13, 11, 10)  # #0d0b0a


def key_black(img):
    img = img.convert("RGBA")
    alpha = img.getchannel("A")
    if alpha.getextrema()[0] < 255:
        return img
    px = img.load()
    for y in range(img.height):
        for x in range(img.width):
            r, g, b, _ = px[x, y]
            m = max(r, g, b)
            # flat black -> transparent, with a soft ramp so edges stay smooth
            a = 0 if m <= 8 else (255 if m >= 40 else int((m - 8) * 255 / 32))
            px[x, y] = (r, g, b, a)
    return img


def trim(img):
    mask = img.getchannel("A").point(lambda a: 255 if a > 16 else 0)
    box = mask.getbbox()
    return img.crop(box) if box else img


def cut(src, share, bottom):
    img = trim(key_black(Image.open(src)))
    longer = max(img.width, img.height)
    scale = share * CANVAS / longer
    if img.height * scale > HEIGHT_CAP * CANVAS:
        scale = HEIGHT_CAP * CANVAS / img.height
    w = max(1, round(img.width * scale))
    h = max(1, round(img.height * scale))
    img = img.resize((w, h), Image.LANCZOS)
    out = Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))
    x = (CANVAS - w) // 2
    if bottom:
        y = CANVAS - round(BASELINE * CANVAS) - h
    else:
        y = (CANVAS - h) // 2
    out.alpha_composite(img, (x, max(0, y)))
    return out


def sheet(outputs, ref, path):
    pad, cell = 12, 48
    cols = len(outputs) + (1 if ref else 0)
    img = Image.new("RGB", (pad + cols * (cell * 2 + pad), cell + 2 * pad), WELL)
    x = pad
    items = ([("ref", Image.open(ref).convert("RGBA"))] if ref else []) + outputs
    for _, icon in items:
        for size in (32, 40):
            small = icon.resize((size, size), Image.LANCZOS)
            img.paste(small, (x + (cell - size) // 2, pad + (cell - size) // 2), small)
            x += cell
        x += pad
    img.save(path)


def main(argv):
    if len(argv) < 4 or argv[0] not in ("tiers", "action"):
        print(__doc__)
        return 2
    mode, out_dir, sheet_path = argv[0], Path(argv[1]), argv[2]
    rest = argv[3:]
    ref = None
    if rest and rest[0] == "--ref":
        ref = rest[1]
        rest = rest[2:]
    out_dir.mkdir(parents=True, exist_ok=True)
    outputs = []
    for pair in rest:
        name, src = pair.split("=", 1)
        if mode == "tiers":
            tier = int(name.rsplit("-", 1)[1])
            icon = cut(src, TIER_SHARE[tier], bottom=True)
        else:
            icon = cut(src, ACTION_SHARE, bottom=False)
        dest = out_dir / (name + ".png")
        icon.save(dest, "PNG", optimize=True)
        outputs.append((name, icon))
        print("%s <- %s" % (dest, src))
    sheet(outputs, ref, sheet_path)
    print("check sheet " + sheet_path)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

"""Cut Sol's floor smoke into G's shipped smoke_floor.png (spec.md 5.14, 11.2, 11.2a).

Recipe (11.2a): take the densest full-width band at 4:1, feather the left and right 10% and
the top 20% to alpha, resize to 2048x512. Deterministic; the original is never changed.

  1. band: full source width W, height H = round(W / 4). Over every window y0..y0+H, sum the
     alpha. The densest is the largest sum; windows within 0.1% of it hold the same smoke
     (the rows around the smoke are empty), so the first of them (the highest) is taken:
     the smoke then sits on the band's bottom edge, which G anchors to the bottom of the
     screen (the floor).
  2. feather: alpha x smoothstep ramp, 0 at the edge to 1 at 10% in from the left and right,
     and at 20% down from the top. The bottom is not feathered (the recipe; it is the floor).
  3. resize to 2048x512, Lanczos, in premultiplied alpha (so the source's colour under zero
     alpha - red and magenta specks along the smoke's top - cannot bleed into the edges),
     then un-premultiply.
  4. fully transparent pixels take the smoke's alpha-weighted mean colour (clean edges for
     linear filtering); PNG RGBA 8-bit, no metadata.
  5. CHECK.png: the source with the band marked (top) and the cut (bottom), both over a dark
     room-like violet-black and over mid grey, side by side.

Usage: cut_smoke.py SRC.png OUT.png CHECK.png
"""
import sys

import numpy as np
from PIL import Image, ImageDraw

OUT_W, OUT_H = 2048, 512
FEATHER_SIDE = 0.10
FEATHER_TOP = 0.20
TIE = 0.001


def smoothstep(x):
    x = np.clip(x, 0.0, 1.0)
    return x * x * (3.0 - 2.0 * x)


def densest_band(alpha, h):
    rows = alpha.sum(axis=1)
    csum = np.concatenate([[0.0], np.cumsum(rows)])
    sums = csum[h:] - csum[:-h]
    best = sums.max()
    y0 = int(np.nonzero(sums >= best * (1.0 - TIE))[0][0])
    return y0, float(sums[y0]), float(best), float(rows.sum())


def cut(src):
    im = Image.open(src).convert("RGBA")
    a = np.asarray(im, dtype=np.float64) / 255.0
    h_src, w = a.shape[:2]
    h = int(round(w / 4.0))
    y0, got, best, total = densest_band(a[..., 3], h)
    band = a[y0:y0 + h].copy()
    hh, ww = band.shape[:2]
    xs = np.arange(ww) + 0.5
    ys = np.arange(hh) + 0.5
    fx = smoothstep(np.minimum(xs, ww - xs) / (FEATHER_SIDE * ww))
    fy = smoothstep(ys / (FEATHER_TOP * hh))
    band[..., 3] *= fy[:, None] * fx[None, :]
    # premultiplied resize
    pre = band.copy()
    pre[..., :3] *= pre[..., 3:4]
    chans = []
    for c in range(4):
        ch = Image.fromarray(pre[..., c].astype(np.float32), mode="F")
        chans.append(np.asarray(ch.resize((OUT_W, OUT_H), Image.LANCZOS), dtype=np.float64))
    out = np.clip(np.stack(chans, axis=2), 0.0, 1.0)
    al = out[..., 3]
    rgb = np.zeros_like(out[..., :3])
    nz = al > 1e-6
    rgb[nz] = out[..., :3][nz] / al[nz][:, None]
    mean = (out[..., :3].sum(axis=(0, 1)) / max(al.sum(), 1e-9))
    rgb[~nz] = mean
    out8 = np.empty((OUT_H, OUT_W, 4), dtype=np.uint8)
    out8[..., :3] = np.round(np.clip(rgb, 0.0, 1.0) * 255.0)
    out8[..., 3] = np.round(al * 255.0)
    # a pixel whose alpha rounds to 0 takes the mean colour too
    z = out8[..., 3] == 0
    out8[..., :3][z] = np.round(np.clip(mean, 0.0, 1.0) * 255.0).astype(np.uint8)
    info = {"src": (w, h_src), "band": (0, y0, w, y0 + h), "alpha_in_band": got / total,
            "best": best / total, "mean_rgb": tuple(int(round(v * 255)) for v in mean),
            "mean_alpha": float(out8[..., 3].mean() / 255.0)}
    return im, Image.fromarray(out8, "RGBA"), info


def over(img, bg):
    base = Image.new("RGBA", img.size, bg)
    return Image.alpha_composite(base, img).convert("RGB")


def check(src_im, out_im, info, path):
    sw = 1024
    s = src_im.resize((sw, int(round(src_im.height * sw / src_im.width))), Image.LANCZOS)
    o = out_im.resize((sw, sw // 4), Image.LANCZOS)
    dark, grey = (14, 9, 16, 255), (128, 128, 128, 255)
    k = sw / src_im.width
    x0, y0, x1, y1 = info["band"]
    tiles = []
    for bg in (dark, grey):
        top = over(s, bg)
        d = ImageDraw.Draw(top)
        d.rectangle([x0 * k, y0 * k, x1 * k - 1, y1 * k - 1], outline=(255, 200, 0), width=2)
        tiles.append((top, over(o, bg)))
    gap = 12
    W = sw * 2 + gap
    H = tiles[0][0].height + gap + tiles[0][1].height
    sheet = Image.new("RGB", (W, H), (40, 40, 40))
    for i, (t, b) in enumerate(tiles):
        sheet.paste(t, (i * (sw + gap), 0))
        sheet.paste(b, (i * (sw + gap), t.height + gap))
    sheet.save(path)


def main():
    if len(sys.argv) != 4:
        print(__doc__)
        return 2
    src_im, out_im, info = cut(sys.argv[1])
    out_im.save(sys.argv[2], format="PNG", optimize=False)
    check(src_im, out_im, info, sys.argv[3])
    print(info)
    return 0


if __name__ == "__main__":
    sys.exit(main())

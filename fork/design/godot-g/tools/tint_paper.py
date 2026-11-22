#!/usr/bin/env python3
"""Recolour G's paper sheet to the paper tokens (spec 4.1: #c3b79c -> #afa286).

The picked Sol sheet (paper-run1/paper-sheet-b.png, cut by cut_paper.py) came out about twice
as saturated as the tokens and more orange (hue 35 vs 42). Alex, 2026-11-22: "Why can't we
get paper that matches the plan? It's far too yellow". This keeps only the sheet's light and
shade (each pixel's luminance: stains, creases, the scorched edges) and colours it with the
tokens' mid colour #b9ac91, scaled so the middle of the sheet averages exactly #b9ac91.

usage: tint_paper.py IN.png OUT.png
"""
import sys
import numpy as np
from PIL import Image

TOKEN_MID = np.array([0xB9, 0xAC, 0x91], dtype=np.float32) / 255.0
LUMA = np.array([0.299, 0.587, 0.114], dtype=np.float32)


def main(src, dst):
    a = np.asarray(Image.open(src).convert("RGB")).astype(np.float32) / 255.0
    lum = (a * LUMA).sum(axis=2, keepdims=True)
    h, w = lum.shape[:2]
    mid = float(lum[h // 4:3 * h // 4, w // 4:3 * w // 4].mean())
    t_lum = float((TOKEN_MID * LUMA).sum())
    out = TOKEN_MID / t_lum * lum * (t_lum / mid)
    Image.fromarray((np.clip(out, 0, 1) * 255 + 0.5).astype(np.uint8)).save(dst, "PNG", optimize=True)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(2)
    main(sys.argv[1], sys.argv[2])

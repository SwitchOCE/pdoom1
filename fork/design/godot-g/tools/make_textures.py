#!/usr/bin/env python3
"""Script-made textures for the G desk (fork/design/godot-g/spec.md 4.3, 11.2).

Fork tool: it lives in fork/design/godot-g/tools/ on lean, never on a ui/g-* branch.
Only its output PNGs go on the branch, under godot/assets/textures/g/.

Makes, deterministically (fixed seeds, no clock, no network):

  panel_grime_9.png  256x256 RGBA, a 9-slice (margins 24) panel fill:
      the panel colour rgb(16,14,12), opaque (the theme's GPanel stylebox modulates it to
      the token's .95; the sheets keep it opaque so nothing reads through them);
      soot baked into the inner edge (CSS inset 0 0 26px rgba(0,0,0,.42) plus a heavier
      band along the bottom, inset 0 -14px 22px -10px rgba(0,0,0,.4)), faded to nothing
      inside the 24 px margin so the stretched/tiled middle carries none;
      low-frequency smut and fine grain at 16%;
      Pip's textures/surfaces/tex_painted_metal_panel_512.png mixed in at 5% (screen).
      Every noise layer and the metal are periodic over the 208 px middle (256 - 2*24),
      phase-aligned at x,y = 24, so the StyleBoxTexture can TILE_FIT its middle and edges
      without seams.
  hatch_16.png  16x16 RGBA, tileable: the disabled hatch, 2 px diagonal strokes of the
      frame colour at 6% every 8 px (x + y), on the panel colour.

usage: make_textures.py GODOT_DIR
  GODOT_DIR is the worktree's godot/ folder (reads the metal texture from it, writes
  assets/textures/g/*.png into it).
"""
import sys
from pathlib import Path

import numpy as np
from PIL import Image

SIZE = 256
MARGIN = 24
PERIOD = SIZE - 2 * MARGIN          # 208: the 9-slice middle
PANEL = np.array([16, 14, 12], dtype=np.float64) / 255.0
PANEL_ALPHA = 0.95
FRAME = np.array([196, 176, 138], dtype=np.float64) / 255.0
GRAIN_RGB = np.array([0.5, 0.45, 0.4])   # the mock-up's grain colour (concept.html --grain)
SEED = 20261122


def periodic_noise(rng, n, sigma):
    """White noise on an n x n torus, Gaussian-filtered in Fourier space (so it wraps),
    normalised to 0..1."""
    w = rng.standard_normal((n, n))
    f = np.fft.fftfreq(n)
    fx, fy = np.meshgrid(f, f)
    g = np.exp(-2.0 * (np.pi ** 2) * (sigma ** 2) * (fx ** 2 + fy ** 2))
    out = np.real(np.fft.ifft2(np.fft.fft2(w) * g))
    out -= out.min()
    out /= max(out.max(), 1e-9)
    return out


def periodic_from(src, t):
    """A t x t tile that wraps, cut from a 2t x 2t source by a linear cross-fade
    P(u) = (1 - u/t) * S(u + t) + (u/t) * S(u), so P(0) = S(t) = P(t). Done on x then y."""
    w = (np.arange(t) / t)[None, :, None]
    a = (1.0 - w) * src[:, t:2 * t] + w * src[:, 0:t]          # (2t, t, c)
    w = (np.arange(t) / t)[:, None, None]
    return (1.0 - w) * a[t:2 * t] + w * a[0:t]                  # (t, t, c)


def to_canvas(tile):
    """Map a PERIOD-periodic tile onto the 256 canvas, phase 0 at x, y = MARGIN."""
    idx = (np.arange(SIZE) - MARGIN) % PERIOD
    return tile[np.ix_(idx, idx)]


def screen(base, top):
    return 1.0 - (1.0 - base) * (1.0 - top)


def make_grime(godot_dir: Path) -> Image.Image:
    rng = np.random.default_rng(SEED)
    # Pip's painted metal, made periodic over the middle.
    metal_path = godot_dir / "assets/textures/surfaces/tex_painted_metal_panel_512.png"
    metal = np.asarray(Image.open(metal_path).convert("RGB"), dtype=np.float64) / 255.0
    metal_tile = periodic_from(metal[: 2 * PERIOD, : 2 * PERIOD], PERIOD)
    metal_c = to_canvas(metal_tile)

    grain = to_canvas(periodic_noise(rng, PERIOD, 0.7))          # fine grain
    smut = to_canvas(periodic_noise(rng, PERIOD, 22.0))          # low-frequency smut

    base = np.broadcast_to(PANEL, (SIZE, SIZE, 3)).copy()
    # Pip's metal at 5%, screen (concept.html .pnl:after).
    out = base + 0.05 * (screen(base, metal_c) - base)
    # Grain at 16%, screen: the grain colour at the noise's alpha (concept.html --grain).
    g_alpha = (0.55 * grain)[..., None]
    out = out + 0.16 * (screen(out, GRAIN_RGB * g_alpha) - out)
    # Smut at 16%: low-frequency darkening blotches.
    s = np.clip((smut - 0.45) / 0.55, 0.0, 1.0)[..., None]
    out = out * (1.0 - 0.16 * s)

    # Soot in the inner edge (inset shadow), faded out inside the margin.
    y, x = np.mgrid[0:SIZE, 0:SIZE].astype(np.float64)
    d = {"l": x, "r": SIZE - 1 - x, "t": y, "b": SIZE - 1 - y}

    def falloff(dist, reach):
        f = np.exp(-((dist / reach) ** 2))
        f[dist >= MARGIN] = 0.0
        return f

    keep = np.ones((SIZE, SIZE))
    for side in "lrtb":
        keep *= 1.0 - 0.42 * 0.55 * falloff(d[side], 9.0)
    keep *= 1.0 - 0.40 * falloff(d["b"], 11.0)                  # heavier along the bottom
    out = out * keep[..., None]

    rgba = np.zeros((SIZE, SIZE, 4))
    rgba[..., :3] = np.clip(out, 0.0, 1.0)
    rgba[..., 3] = 1.0
    return Image.fromarray(np.round(rgba * 255.0).astype(np.uint8), "RGBA")


def make_hatch() -> Image.Image:
    n, ss, period, width, strength = 16, 8, 8, 2.0, 0.06
    # Supersampled coverage of the strokes (x + y) mod period < width.
    off = (np.arange(ss) + 0.5) / ss
    cov = np.zeros((n, n))
    for oy in off:
        for ox in off:
            yy, xx = np.mgrid[0:n, 0:n].astype(np.float64)
            cov += (((xx + ox) + (yy + oy)) % period) < width
    cov /= ss * ss
    out = PANEL[None, None, :] * (1.0 - strength * cov[..., None]) + FRAME[None, None, :] * (strength * cov[..., None])
    rgba = np.zeros((n, n, 4))
    rgba[..., :3] = out
    rgba[..., 3] = PANEL_ALPHA
    return Image.fromarray(np.round(rgba * 255.0).astype(np.uint8), "RGBA")


def main() -> int:
    if len(sys.argv) != 2:
        print(__doc__)
        return 2
    godot_dir = Path(sys.argv[1]).resolve()
    out_dir = godot_dir / "assets/textures/g"
    out_dir.mkdir(parents=True, exist_ok=True)
    grime = make_grime(godot_dir)
    grime.save(out_dir / "panel_grime_9.png", optimize=True)
    hatch = make_hatch()
    hatch.save(out_dir / "hatch_16.png", optimize=True)
    for name, im in (("panel_grime_9.png", grime), ("hatch_16.png", hatch)):
        a = np.asarray(im, dtype=np.float64)
        mid = a[MARGIN:SIZE - MARGIN, MARGIN:SIZE - MARGIN] if name.startswith("panel") else a
        print("%s %dx%d mean rgb %s (middle %s)" % (name, im.width, im.height,
              np.round(a[..., :3].mean(axis=(0, 1)), 1), np.round(mid[..., :3].mean(axis=(0, 1)), 1)))
    return 0


if __name__ == "__main__":
    sys.exit(main())

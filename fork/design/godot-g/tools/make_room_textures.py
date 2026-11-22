"""G 3a room textures (spec 5.14, 11.2 rows "Window mask for office_wide_day" and "Room noise").

Fork tool, not committed on the ui/g-* branch. Deterministic (fixed numpy seed).

    python3 make_room_textures.py <worktree>/godot [overlay_dir]

Writes into <godot>/assets/textures/g/:
  room_window_mask.png  1536x1024 L8, white = window pane of office_wide_day.webp
  room_noise_lo.png     256x256 L8, tileable, low-frequency smut
  room_noise_hi.png     256x256 L8, tileable, fine grain
and, if overlay_dir is given, the hand-check overlay (mask in red over the backdrop).

Window mask method:
  1. luma (Rec. 709 weights on the sRGB values) of the backdrop;
  2. inside the hand-picked box of the far windows (x 936..1222, y 360..482 in texture
     pixels, read off a 3x crop of the art), a pane is luma >= 0.61; the soft ramp
     0.56 -> 0.66 keeps the mullions and the plant leaves partly out;
  3. outside the box the mask is 0 (the ceiling and wall near the windows are as light as
     the panes, so a global threshold would catch them);
  4. a 3x3 box blur, three passes, softens the edge so the sky blend has no hard line;
  5. hand check: the overlay shows the mask in red over the art.
"""
import sys
from pathlib import Path

import numpy as np
from PIL import Image

SEED = 20261122
WIN_BOX = (936, 360, 1222, 482)      # x0, y0, x1, y1 in texture pixels
RAMP = (0.56, 0.66)


def box_blur(a, passes=3):
    for _ in range(passes):
        p = np.pad(a, 1, mode="edge")
        a = sum(p[1 + dy:1 + dy + a.shape[0], 1 + dx:1 + dx + a.shape[1]]
                for dy in (-1, 0, 1) for dx in (-1, 0, 1)) / 9.0
    return a


def window_mask(art_rgb):
    a = art_rgb.astype(np.float64) / 255.0
    luma = 0.2126 * a[:, :, 0] + 0.7152 * a[:, :, 1] + 0.0722 * a[:, :, 2]
    m = np.clip((luma - RAMP[0]) / (RAMP[1] - RAMP[0]), 0.0, 1.0)
    keep = np.zeros_like(m)
    x0, y0, x1, y1 = WIN_BOX
    keep[y0:y1, x0:x1] = 1.0
    m *= keep
    m = box_blur(m, 3)
    return (np.clip(m, 0, 1) * 255.0 + 0.5).astype(np.uint8)


def periodic_noise(rng, size, sigma_px):
    """White noise low-passed on the torus (FFT), so it tiles exactly."""
    white = rng.standard_normal((size, size))
    f = np.fft.fft2(white)
    k = np.fft.fftfreq(size)
    kx, ky = np.meshgrid(k, k)
    g = np.exp(-2.0 * (np.pi ** 2) * (sigma_px ** 2) * (kx ** 2 + ky ** 2))
    out = np.real(np.fft.ifft2(f * g))
    out -= out.mean()
    return out / (out.std() + 1e-12)


def to_l8(z, spread):
    """Map a unit-variance field to 0..255 around mid grey; spread = std in 0..1 units."""
    v = np.clip(0.5 + z * spread, 0.0, 1.0)
    return (v * 255.0 + 0.5).astype(np.uint8)


def main():
    godot = Path(sys.argv[1])
    overlay_dir = Path(sys.argv[2]) if len(sys.argv) > 2 else None
    out = godot / "assets/textures/g"
    out.mkdir(parents=True, exist_ok=True)
    art = np.asarray(Image.open(godot / "assets/images/backgrounds/office_wide_day.webp").convert("RGB"))
    assert art.shape[:2] == (1024, 1536), art.shape
    mask = window_mask(art)
    Image.fromarray(mask, "L").save(out / "room_window_mask.png", optimize=True)

    rng = np.random.default_rng(SEED)
    lo = 0.65 * periodic_noise(rng, 256, 14.0) + 0.35 * periodic_noise(rng, 256, 5.0)
    lo /= lo.std()
    Image.fromarray(to_l8(lo, 0.18), "L").save(out / "room_noise_lo.png", optimize=True)
    hi = periodic_noise(rng, 256, 0.6)
    Image.fromarray(to_l8(hi, 0.16), "L").save(out / "room_noise_hi.png", optimize=True)

    if overlay_dir is not None:
        overlay_dir.mkdir(parents=True, exist_ok=True)
        base = art.astype(np.float64)
        m = mask.astype(np.float64)[:, :, None] / 255.0
        red = np.array([255.0, 30.0, 30.0])
        ov = base * (1 - 0.6 * m) + red * 0.6 * m
        x0, y0, x1, y1 = WIN_BOX
        ov[y0, x0:x1] = ov[y1 - 1, x0:x1] = (255, 255, 0)
        ov[y0:y1, x0] = ov[y0:y1, x1 - 1] = (255, 255, 0)
        Image.fromarray(ov.astype(np.uint8)).save(overlay_dir / "window_mask_overlay.png")
        Image.fromarray(ov.astype(np.uint8)).crop((880, 300, 1280, 520)).resize(
            (1200, 660), Image.NEAREST).save(overlay_dir / "window_mask_overlay_crop.png")
        tile = np.tile(np.asarray(Image.open(out / "room_noise_lo.png")), (2, 2))
        Image.fromarray(tile, "L").save(overlay_dir / "noise_lo_2x2.png")
        tile = np.tile(np.asarray(Image.open(out / "room_noise_hi.png")), (2, 2))
        Image.fromarray(tile, "L").save(overlay_dir / "noise_hi_2x2.png")
    print("mask coverage %.4f, panes (>=0.5) %d px" % (mask.mean() / 255.0, int((mask >= 128).sum())))


if __name__ == "__main__":
    main()

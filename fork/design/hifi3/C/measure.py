"""Text contrast on composited rendered pixels (H's method, fork/design/hifi3/H/notes.md).
For each TXT box from ?check=1: background = median luminance of the box; text = the
k-th pixel farthest from it (k = max(4, 0.5% of the box)). No CSS colour is used, so
dim layers, grain, paper grime and antialiasing all count.
Usage: python3 measure.py check.txt s1.png s1-720.png"""
import sys
import numpy as np
from PIL import Image

def lum(a):
    a = a / 255.0
    a = np.where(a <= 0.03928, a / 12.92, ((a + 0.055) / 1.055) ** 2.4)
    return 0.2126 * a[..., 0] + 0.7152 * a[..., 1] + 0.0722 * a[..., 2]

boxes = []
for line in open(sys.argv[1]):
    if line.startswith("TXT "):
        p = line.split(" ", 7)
        boxes.append((float(p[1]), float(p[2]), float(p[3]), float(p[4]), p[7].strip()))

for path in sys.argv[2:]:
    img = np.asarray(Image.open(path).convert("RGB")).astype(float)
    s = img.shape[1] / 1920.0
    L = lum(img)
    res = []
    for x, y, w, h, t in boxes:
        x0, y0 = int(np.floor(x * s)), int(np.floor(y * s))
        x1, y1 = int(np.ceil((x + w) * s)), int(np.ceil((y + h) * s))
        x0, y0 = max(0, x0), max(0, y0)
        x1, y1 = min(L.shape[1], x1), min(L.shape[0], y1)
        if x1 - x0 < 2 or y1 - y0 < 2:
            continue
        b = L[y0:y1, x0:x1].ravel()
        bg = np.median(b)
        k = max(4, int(0.005 * b.size))
        far = np.sort(np.abs(b - bg))[::-1]
        d = far[min(k, far.size) - 1]
        tl = bg + d if np.any(b >= bg + d - 1e-9) and (np.sum(b >= bg + d - 1e-9) >= np.sum(b <= bg - d + 1e-9)) else bg - d
        hi, lo = max(tl, bg), min(tl, bg)
        res.append(((hi + 0.05) / (lo + 0.05), t, x, y))
    res.sort()
    under = [r for r in res if r[0] < 4.5]
    lo = res[0] if res else None
    print("  %s: %d boxes, min %.2f %s, under 4.5: %d" % (path.split("/")[-1], len(res), lo[0], lo[1], len(under)))
    for r in under[:12]:
        print("    %.2f %s at %.0f,%.0f" % r)

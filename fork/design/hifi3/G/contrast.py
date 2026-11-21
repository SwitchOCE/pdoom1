"""Pixel contrast of every text box, read from the rendered PNGs (not CSS colours), so the
doom layer, grain, paper grime and antialiasing all count. Same method as H:
background = median luminance of the box; text = the stroke core, the k-th pixel farthest
from the background (k = max(4, 0.5% of the box)). Boxes come from concept.html?check=1
(x,y,w,h at 1920). Usage: contrast.py boxes.csv s1.png s1-720.png"""
import sys
from PIL import Image

def lum(p):
    def c(v):
        v /= 255.0
        return v / 12.92 if v <= 0.03928 else ((v + 0.055) / 1.055) ** 2.4
    return 0.2126 * c(p[0]) + 0.7152 * c(p[1]) + 0.0722 * c(p[2])

def measure(img, box, sc):
    x, y, w, h = [int(round(v * sc)) for v in box]
    x0, y0, x1, y1 = max(0, x), max(0, y), min(img.width, x + w), min(img.height, y + h)
    if x1 - x0 < 2 or y1 - y0 < 2:
        return None
    px = [lum(p) for p in (lambda im: im.get_flattened_data() if hasattr(im, 'get_flattened_data') else im.getdata())(img.crop((x0, y0, x1, y1)))]
    bg = sorted(px)[len(px) // 2]
    k = max(4, int(len(px) * 0.005))
    far = sorted(px, key=lambda v: -abs(v - bg))[k - 1]
    hi, lo = max(bg, far), min(bg, far)
    return (hi + 0.05) / (lo + 0.05)

rows = []
for line in open(sys.argv[1]):
    parts = line.strip().split(',', 4)
    if len(parts) == 5:
        rows.append(([float(v) for v in parts[:4]], parts[4]))
out = []
for path, sc in ((sys.argv[2], 1.0), (sys.argv[3], 2 / 3)):
    img = Image.open(path).convert('RGB')
    res = [(measure(img, b, sc), t) for b, t in rows]
    res = [r for r in res if r[0] is not None]
    res.sort()
    under = [r for r in res if r[0] < 4.5]
    out.append('%s: %d boxes, lowest %.2f (%s), under 4.5: %d%s' % (
        'at 1920' if sc == 1 else 'at 720', len(res), res[0][0], res[0][1], len(under),
        (' -> ' + '; '.join('%.2f %s' % u for u in under[:8])) if under else ''))
print('  ' + '\n  '.join(out))

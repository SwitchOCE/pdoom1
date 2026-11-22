"""Remove the red warning glow from a G tier-0 icon (build E, Alex: no warnings at a 0 start).
Deterministic: a pixel's glow weight is how far its red exceeds its green/blue; semi-transparent
glow pixels lose alpha by that weight, and red-tinted pixels have their red pulled back to the
object's own brown ratio. Usage: deglow.py IN OUT"""
import sys
from PIL import Image
src = Image.open(sys.argv[1]).convert("RGBA")
px = src.load(); w, h = src.size
out = Image.new("RGBA", (w, h)); po = out.load()
for y in range(h):
    for x in range(w):
        r, g, b, a = px[x, y]
        if a == 0:
            po[x, y] = (0, 0, 0, 0); continue
        m = max(g, b)
        ratio = r / (m + 4.0)
        wgt = min(1.0, max(0.0, (ratio - 2.2) / 2.0))
        if wgt > 0.0:
            r = round(r * (1 - wgt) + min(r, m * 1.6 + 6) * wgt)
            if a < 255:
                a = round(a * (1 - wgt) ** 2)
        po[x, y] = (r, g, b, a)
out.save(sys.argv[2])

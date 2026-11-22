#!/usr/bin/env python3
"""Pixel check: the mixer's reset against H's own render of state 3.

Renders H/concept.html?state=3&still=1 (the mock-up's sound button hidden) and the mixer
after Reset, both at 1920x1080 in headless Chromium, and prints how far apart they are.
  MIXER_SCRATCH=<scratch dir> python3 tools/pixelcheck.py [diff.png]
"""
import os, sys, shutil
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cut import stage_copy, chrome, SCRATCH
from PIL import Image, ImageChops

MIX = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def mixer_png(out):
    work = os.path.join(SCRATCH, "work", "mixer"); os.makedirs(work, exist_ok=True)
    t = open(os.path.join(MIX, "index.html"), encoding="utf-8").read()
    t = t.replace("<head>", '<head><base href="file://%s/">' % MIX, 1)
    t = t.replace("</head>", "<style>body{margin:0}header,aside,footer,.below{display:none!important}"
                  ".mx{display:block!important;padding:0!important;margin:0!important;max-width:none!important}"
                  ".vp{width:1920px!important;height:1080px!important;border:0!important;border-radius:0!important}</style></head>", 1)
    t = t.replace("</body>", '<script>document.getElementById("reset").click();</script></body>', 1)
    page = os.path.join(work, "index.html"); open(page, "w", encoding="utf-8").write(t)
    chrome(["--allow-file-access-from-files", "--screenshot=" + out, "file://" + page])

def h_png(out):
    url = stage_copy("H", "<style>.mock-snd,#check{display:none!important}</style>") + "?state=3&still=1"
    chrome(["--screenshot=" + out, url])

def main():
    a, b = os.path.join(SCRATCH, "h3.png"), os.path.join(SCRATCH, "mix3.png")
    h_png(a); mixer_png(b)
    A = Image.open(a).convert("RGB"); B = Image.open(b).convert("RGB")
    d = ImageChops.difference(A, B)
    px = list(d.getdata()); n = len(px)
    m = [max(p) for p in px]
    mean = sum(sum(p) for p in px) / (3.0 * n)
    over = lambda k: 100.0 * sum(1 for v in m if v > k) / n
    print("size %sx%s" % A.size)
    print("mean abs diff per channel %.3f (0-255)" % mean)
    print("pixels off by more than 2: %.2f%%, 8: %.2f%%, 16: %.2f%%, 32: %.3f%%; largest %d" % (over(2), over(8), over(16), over(32), max(m)))
    if len(sys.argv) > 1:
        heat = d.convert("L").point(lambda v: min(255, v * 8))
        heat.save(sys.argv[1])
        bb = d.convert("L").point(lambda v: 255 if v > 16 else 0).getbbox(); print("box of pixels off by more than 16:", bb)

if __name__ == "__main__":
    main()

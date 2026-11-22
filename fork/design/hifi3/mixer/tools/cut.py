#!/usr/bin/env python3
"""Cut-out renders for the mixer, from each design's own concept.html.

The design files are never edited: each run copies concept.html to a scratch
folder (with a link to the design's assets), appends a style and script
before </body>, and renders it in headless Chromium (one browser at a time).

  cut.py probe  <design> <query>               list the stage's top-level elements and boxes
  cut.py cut    <design> <query> <css> <out>   render only the elements matching <css> on a
                                               transparent stage, crop to their pixels, write
                                               <out>.webp and print the box (x y w h, stage px)
"""
import json, os, re, shutil, subprocess, sys, glob, html
from PIL import Image

HIFI3 = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SCRATCH = os.environ.get("MIXER_SCRATCH", "/tmp/mixer-scratch")
CH = sorted(glob.glob(os.path.expanduser("~/.cache/ms-playwright/chromium_headless_shell-1254/*/chrome-headless-shell")))[0]

def stage_copy(design, inject):
    src = os.path.join(HIFI3, design)
    work = os.path.join(SCRATCH, "work", design)
    os.makedirs(work, exist_ok=True)
    link = os.path.join(work, "assets")
    if not os.path.islink(link): os.symlink(os.path.join(src, "assets"), link)
    t = open(os.path.join(src, "concept.html"), encoding="utf-8").read()
    i = t.rindex("</body>")
    open(os.path.join(work, "concept.html"), "w", encoding="utf-8").write(t[:i] + inject + t[i:])
    return "file://" + os.path.join(work, "concept.html")

def chrome(args):
    prof = os.path.join(SCRATCH, "prof")
    try:
        return subprocess.run([CH, "--no-sandbox", "--headless", "--hide-scrollbars", "--user-data-dir=" + prof,
                               "--virtual-time-budget=6000", "--window-size=1920,1080"] + args,
                              capture_output=True, text=True, timeout=90).stdout
    finally:
        shutil.rmtree(prof, ignore_errors=True)

PROBE = """<script>document.fonts.ready.then(function(){setTimeout(function(){
var S=document.getElementById('stage'),o=[];Array.prototype.forEach.call(S.children,function(e){var r=e.getBoundingClientRect();
o.push([e.tagName.toLowerCase()+'.'+String(e.className).trim().split(/\\s+/).join('.'),Math.round(r.left),Math.round(r.top),Math.round(r.width),Math.round(r.height)]);});
var p=document.createElement('pre');p.id='probe';p.textContent=JSON.stringify(o);document.body.appendChild(p);},300);});</script>"""

def probe(design, query, sel=None):
    inj = PROBE if not sel else PROBE.replace("Array.prototype.forEach.call(S.children", "Array.prototype.forEach.call(document.querySelector('" + sel + "').querySelectorAll(':scope > *, :scope > * > *')")
    url = stage_copy(design, inj) + "?" + query
    out = chrome(["--dump-dom", url])
    m = re.search(r'<pre id="probe">(.*?)</pre>', out, re.S)
    for row in json.loads(html.unescape(m.group(1))): print(*row)

def cut(design, query, show, out, hide="", crop=None, opaque=False, quality=92):
    css = "<style>"
    if not opaque:
        css += ("html,body,#stage{background:transparent!important}#stage *{visibility:hidden!important}"
                + ",".join("#stage " + s + ",#stage " + s + " *" for s in show.split("|")) + "{visibility:visible!important}")
    if hide:
        css += ",".join("#stage " + s + ",#stage " + s + " *" for s in hide.split("|")) + "{visibility:hidden!important}"
    css += ".mock-snd,#check{display:none!important}</style>"
    url = stage_copy(design, css) + "?" + query
    png = os.path.join(SCRATCH, "cut.png")
    if os.path.exists(png): os.remove(png)
    chrome((["--default-background-color=00000000"] if not opaque else []) + ["--screenshot=" + png, url])
    im = Image.open(png).convert("RGBA")
    if crop: box = (crop[0], crop[1], crop[0] + crop[2], crop[1] + crop[3])
    else: box = im.getchannel("A").point(lambda a: 255 if a > 3 else 0).getbbox()
    if not box: print("EMPTY", design, query, show); return None
    piece = im.crop(box)
    if opaque: piece = piece.convert("RGB")
    piece.save(out + ".webp", "WEBP", quality=quality, method=6)
    x, y, x2, y2 = box
    return {"x": x, "y": y, "w": x2 - x, "h": y2 - y}

if __name__ == "__main__":
    a = sys.argv[1:]
    if a[0] == "probe": probe(a[1], a[2], a[3] if len(a) > 3 else None)
    elif a[0] == "cut": print(json.dumps(cut(a[1], a[2], a[3], a[4])))

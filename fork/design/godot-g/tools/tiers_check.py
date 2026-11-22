"""Contact sheet for Alex (Q16): the 25 G tier icons at 32 and 40 px on the G plate
(GTile: #0b0a09 with a hairline frame) beside Pip's resource icons, on the panel colour."""
import sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

WT = Path(sys.argv[1]); OUT = Path(sys.argv[2])
G = WT / "godot/assets/icons/g_tiers"; R = WT / "godot/assets/icons/resources"
PANEL = (16, 14, 12); PLATE = (11, 10, 9); FRAME = (39, 36, 30)
ROWS = [("money", "money", "resource_money_64.png"), ("compute", "compute", "resource_compute_64.png"),
        ("research", "research", "resource_research_points_64.png"),
        ("papers", "papers", "resource_papers_small_64.png"), ("reputation", "rep", "resource_reputation_64.png")]
try:
    font = ImageFont.truetype(str(WT / "godot/assets/fonts/ibm_plex_mono/IBMPlexMono-Medium.ttf"), 13)
except Exception:
    font = ImageFont.load_default()
LW, CELL, GAP = 110, 40, 10
pair_w = 32 + 6 + 40
W = LW + 2 * (pair_w + 3 * GAP) + 5 * (pair_w + 2 * GAP)
H = 34 + len(ROWS) * (CELL + 20)
img = Image.new("RGB", (W, H), PANEL); d = ImageDraw.Draw(img)

def plate(x, y, px, src):
    d.rectangle([x, y, x + px - 1, y + px - 1], fill=PLATE, outline=FRAME)
    ic = Image.open(src).convert("RGBA").resize((px, px), Image.LANCZOS)
    img.paste(ic, (x, y), ic)

x0 = LW
d.text((x0, 8), "Pip's", fill=(170, 160, 142), font=font)
for t in range(5):
    d.text((x0 + 2 * (pair_w + 3 * GAP) + t * (pair_w + 2 * GAP), 8), "tier %d" % t, fill=(170, 160, 142), font=font)
for r, (label, prefix, pip) in enumerate(ROWS):
    y = 34 + r * (CELL + 20)
    d.text((8, y + 12), label.upper(), fill=(150, 141, 124), font=font)
    x = LW
    for px in (32, 40):
        plate(x, y + (40 - px), px, R / pip); x += px + 6
    x = LW + 2 * (pair_w + 3 * GAP)
    for t in range(5):
        for px in (32, 40):
            plate(x, y + (40 - px), px, G / ("%s-%d.png" % (prefix, t))); x += px + 6
        x += 2 * GAP - 6 + 6
img.save(OUT); print(OUT, img.size)

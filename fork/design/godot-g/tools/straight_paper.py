"""Build E: G's paper with clean straight edges (Alex: no torn edges on paper).
Crops the sheet's inside, past the torn edges and curled corners (INSET px from each side
of the 1024x1024 sheet), and scales it back to 1024x1024 with Lanczos. Colour and texture
are the sheet's own. Deterministic. Usage: straight_paper.py IN OUT"""
import sys
from PIL import Image
INSET = 72
src = Image.open(sys.argv[1]).convert("RGB")
w, h = src.size
out = src.crop((INSET, INSET, w - INSET, h - INSET)).resize((w, h), Image.LANCZOS)
out.save(sys.argv[2], optimize=True)

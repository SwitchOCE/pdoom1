#!/usr/bin/env python3
"""Build the mixer's cut-outs (cut/*.webp), backgrounds (bg/*.webp) and pieces.js.

Every piece is rendered from its own design's concept.html (see cut.py); nothing is
redrawn. Desk pieces come from state 3 (November 2017), the action menu from state 2,
the event card and the feed from state 4, the month review from state 5.
Run:  MIXER_SCRATCH=<scratch dir> python3 tools/build.py [design ...]
"""
import json, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cut import cut

MIX = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
Q = lambda n, extra="": "state=%d&still=1%s" % (n, extra)
RACK_HF = int(os.environ.get("RACK_HF", "5"))   # see notes.md

# G's top bar holds its dateline, the four resources and reputation, in this order of children:
# .dl(1) .tb-res(2..5 resources, 6 reputation) .tb-sp(7) .tb-menu(8)
G_RES = "|".join(".topbar>.tb-res:nth-child(%d)" % i for i in (2, 3, 4, 5))
G_REP = ".topbar>.tb-res:nth-child(6)"

# [slot, option key, design folder, state, show, hide, crop]
SPEC = [
  # --- C (earlier texture)
  ["doom","C","C",3,".doomw","",None], ["rep","C","C",3,".repw","",None], ["res","C","C",3,".acc","",None],
  ["date","C","C",3,".dl","",None], ["rack","C","C",3,".box|.sc","",None], ["att","C","C",3,".clipb","",None],
  ["plan","C","C",3,".board","",None], ["commit","C","C",3,".held|.cmt","",None], ["menu","C","C",2,".mn","",None],
  ["event","C","C",4,".memo","",None], ["review","C","C",5,".rcpt","",None], ["feed","C","C",4,".tape","",None],
  # --- E (earlier texture); E's dock is not drawn in state 3, so it comes from state 6 (it carries no data)
  ["doom","E","E",3,".doomw","",None], ["rep","E","E",3,".repw","",None], ["date","E","E",3,".dl","",None],
  ["rack","E","E",6,".dock","",None], ["plan","E","E",3,".sheet|.tape","",None], ["commit","E","E",3,".held|.cmt","",None],
  ["menu","E","E",2,".cf","",None], ["event","E","E",4,".ev","",None], ["review","E","E",5,".rv","",None], ["feed","E","E",4,".mc","",None],
  # --- G (earlier texture); its top-bar items keep the bar behind them
  ["doom","G","G",3,".doom","",None],
  ["rep","G","G",3,".topbar",".topbar>.dl|.topbar>.tb-menu|"+G_RES,[1359,0,260,56]],
  ["res","G","G",3,".topbar",".topbar>.dl|.topbar>.tb-menu|"+G_REP,[444,0,915,56]],
  ["date","G","G",3,".topbar",".topbar>.tb-res|.topbar>.tb-menu",[0,0,444,56]],
  ["rack","G","G",3,".rail|.banner","",None], ["att","G","G",3,".attn","",None], ["plan","G","G",3,".pmenu","",None],
  ["commit","G","G",3,".bottombar|.heldb|.cmt",".bb-q",[1260,1016,660,64]],
  ["menu","G","G",2,".amenu|.detail|.conn","",None], ["event","G","G",4,".slip","",None],
  ["review","G","G",5,".review","",None], ["feed","G","G",4,".feed","",None],
  # --- H (the revised H; its elements carry data-el and an id). Desk pieces from state 3.
  # H draws its desk terminal (Attention and the plan at a glance) only when no sheet covers the desk,
  # so for state 3 the terminal is drawn by H's own terminal() with state 3's book (NOV_PLAN).
  ["att","H","H",3,"#plan","",None,{"extra":"<script>terminal(NOV_PLAN);</script>"}],
  ["doom","H","H",3,"#doom","",None,{}], ["res","H","H",3,"#resources","",None,{}],
  ["res","Hb","H",3,"#resources","",None,{"q":"&res=trace"}],
  ["rep","Hd","H",3,"#rep-dial","",None,{"q":"&rep=dial"}],
  ["date","H","H",3,"#dateline","",None,{}], ["rack","H","H",3,"#rack","",None,{}],
  ["plan","H","H",3,"#plan-sheet","",None,{}], ["commit","H","H",3,"#held|#commit","",None,{}],
  ["menu","H","H",2,"#actions","",None,{}], ["event","H","H",4,"#event","",None,{}],
  ["feed","H","H",4,"#feed","",None,{}], ["review","H","H",5,"#review","",None,{}],
  ["adv","H","H",1,"#advisor","",None,{}], ["cat","H","H",4,"#cat","",None,{}],
  # --- H-HF (H in painted steel): states 1, 4 and 5 only. Its November state is 4 (14 Nov), so its desk
  # pieces come from there; Attention is its terminal() with state 3's book, as for H. No action menu,
  # plan sheet or reputation dial.
  ["att","HF","H-HF",4,"#plan","",None,{"extra":"<script>terminal(book(NOV, NOV_QUEUE));</script>"}],
  ["doom","HF","H-HF",4,"#doom","",None,{}], ["res","HF","H-HF",4,"#resources","",None,{}],
  ["date","HF","H-HF",4,"#dateline","",None,{}], ["rack","HF","H-HF",RACK_HF,"#rack","",None,{}],
  ["commit","HF","H-HF",4,"#held|#commit","",None,{}], ["feed","HF","H-HF",4,"#feed","",None,{}],
  ["event","HF","H-HF",4,"#event","",None,{}], ["cat","HF","H-HF",4,"#cat","",None,{}],
  ["review","HF","H-HF",5,"#review","",None,{}], ["adv","HF","H-HF",1,"#advisor","",None,{}],
]
# The office art through H's own doom layer (room(), ?band=0..6), state 3, everything but the room hidden.
# The other offices' photos are put under the same layer by swapping the room photo.
HIFI3 = os.path.dirname(MIX)
ROOM_HIDE = "#doom|#resources|#rack|#held|#commit|#dateline|#plan-sheet|.dim|.grain"
BG = [
  ["dawn", "Wide office, dawn (H)", None, ""],
  ["day", "Wide office, day (G's photo)", "G/assets/office_wide_day.webp", ""],
  ["mezz", "Mezzanine office (E's photo)", "E/assets/office_mezzanine.webp", ""],
]
BANDS = 7
NATIVE = {1: 1, 2: 2, 3: 2, 4: 2, 5: 3, 6: 5}   # H's band per state (notes.md Addendum)

def grain_css():
    import re
    t = open(os.path.join(HIFI3, "H", "concept.html"), encoding="utf-8").read()
    g = re.search(r"--grain:(url\(\"data:[^\n]*?\"\));", t).group(1)
    rule = re.search(r"\n\.grain\{([^}]*)\}", t).group(1)
    return {"grain": g, "grainRule": rule.replace("var(--grain)", g)}

def main(only):
    os.makedirs(os.path.join(MIX, "cut"), exist_ok=True); os.makedirs(os.path.join(MIX, "bg"), exist_ok=True)
    man_path = os.path.join(MIX, "tools", "manifest.json")
    man = json.load(open(man_path)) if os.path.exists(man_path) else {"pieces": {}, "bg": {}}
    if not only or "H" in only:   # the trial H pieces and the old backgrounds go
        for slot in list(man["pieces"]):
            for k in list(man["pieces"][slot]):
                if k.startswith("H"): del man["pieces"][slot][k]
    for row in SPEC:
        slot, key, d, st, show, hide, crop = row[:7]; o = row[7] if len(row) > 7 else {}
        if only and d not in only: continue
        hq = d == "H"
        box = cut(d, Q(st, o.get("q", "")), show, os.path.join(MIX, "cut", slot + "-" + key), hide=hide, crop=crop,
                  extra=o.get("extra", ""), thresh=0 if hq else 3, quality=92, lossless=hq)
        if box: man["pieces"].setdefault(slot, {})[key] = dict(box, src="cut/%s-%s.webp" % (slot, key), state=st)
        print(slot, key, box, flush=True)
    if not only or "bg" in only:
        man["bg"] = {}
        for key, label, photo, _ in BG:
            extra = ""
            if photo: extra = "<style>#stage .room-bg{background-image:url(file://%s)!important}</style>" % os.path.join(HIFI3, photo)
            srcs = []
            for band in range(BANDS):
                name = "%s-b%d" % (key, band)
                cut("H", Q(3, "&band=%d" % band), "", os.path.join(MIX, "bg", name), hide=ROOM_HIDE,
                    crop=[0, 0, 1920, 1080], opaque=True, quality=92, extra=extra)
                srcs.append("bg/%s.webp" % name); print("bg", name, flush=True)
            man["bg"][key] = {"label": label, "bands": srcs}
    man["layers"] = grain_css()
    man["native"] = {"band": NATIVE[3]}
    json.dump(man, open(man_path, "w"), indent=1, sort_keys=True)
    open(os.path.join(MIX, "pieces.js"), "w").write("/* generated by tools/build.py: cut-out pieces and backgrounds */\nwindow.MIX_DATA = " + json.dumps(man, sort_keys=True) + ";\n")

if __name__ == "__main__":
    main(sys.argv[1:])

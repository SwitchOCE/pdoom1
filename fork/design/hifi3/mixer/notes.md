# The mixer -- notes

Open `index.html` (self-contained, relative paths; Google Fonts only).

## What is here

- `index.html` -- the page. One 1920x1080 stage scaled to the column; controls
  beside it on wide screens, below it under 1100 px, rows stacked under 520 px.
- `pieces.js` -- generated: every piece's file, native stage position, size and
  source state; the office backgrounds.
- `cut/<slot>-<design>.webp` -- transparent cut-outs (60: C, E, G and H-HF lossy; H lossless).
- `bg/<photo>-b<band>.webp` -- the three office photos through H's doom layer, bands 0-6 (21).
- `tools/cut.py` -- renders one design's concept.html in headless Chromium with
  CSS injected into a temporary copy (the design files are never edited), keeps
  only the chosen elements visible, crops to the visible pixels. The crop's
  top-left is the piece's native position, shadow included.
- `tools/build.py` -- the list of pieces (slot, design, state, selectors) and the
  build. Rerun: `MIXER_SCRATCH=<scratch dir> python3 tools/build.py [designs...]`
  (merges into `tools/manifest.json`; `H` rebuilds H's pieces, `bg` the backgrounds).
- `tools/pixelcheck.py` -- renders H's own state 3 and the mixer after Reset and
  prints the difference.

## Choices made in step 1 (some replaced in step 2, see below)

- **Extra slot, Attention.** C's clipboard and G's attention panel are their own
  element in those designs, so they get a slot. E has none; H's will be cut
  from the revised H if it has one.
- **Data used.** Desk pieces from state 3 (November 2017, plan with plays
  queued); action menu from state 2; event card and feed from state 4
  (14 November); month review from state 5. One exception: **E's menu rack**
  comes from state 6, because E does not draw its dock in state 3; the dock
  carries no numbers, so nothing from the late-game fixture leaks in.
- **G's top bar** is one element in G. It is cut three ways by crop: dateline
  (x 0-444), resources (444-1359), reputation (1359-1619). G's commit is its
  bottom-bar right end (held hours and the commit button), without the queue.
- **C's menu rack** is the cabinet box plus the four station cards, so the
  piece's box spans the bottom of the desk with empty space between.
- **Picking a design for a slot** puts the piece where that design draws it;
  drag or nudge from there.
- **Drawing order is fixed by slot.** Replaced in step 2 (below).
- **Dim toggle.** H's dim (the same radial gradient as H's `.dim`) between the
  office and the pieces. Reset turns it on, as H's state 3 has it.
- **Band slider.** Replaced in step 2 (below).
- **Code.** base64 of JSON `{v, bg, band, dim, s:{slot:[design, x, y, on]}}`.
  Unknown designs or bad values in a pasted code fall back to the default for
  that slot. Saved in localStorage under `pdoom1-mixer-v1` (wrapped in
  try/catch; the page works without it).

## Checked (headless Chromium, step 1)

- All 44 images load; every option in every slot (52) draws its piece.
- A code copied, reset, then pasted back loads the same arrangement; a broken
  code shows an error and changes nothing.
- Arrow nudges 1 px, Shift+arrow 10 px; focus ring visible on pieces and
  controls; localStorage matches the code box.
- Layout at 1600 and 390 px wide.

## Step 2: the revised H

- **H's pieces** are cut by their `data-el` ids from the revised H: P(Doom),
  resources (tier icons, and `?res=trace` as "H, trace windows"), dateline,
  menu rack, plan sheet, commit (held + Commit) from state 3; action menu from
  state 2; event card, feed and the office cat from state 4; month review from
  state 5; advisor note from state 1 (new slot). H draws reputation once, in
  the resource strip; its old dial (`?rep=dial`) is offered under Reputation as
  "H, old dial (for comparison)", off after Reset.
- **H's Attention** is its desk terminal. In state 3 the plan sheet covers the
  desk, so H does not draw it; the piece is H's own `terminal()` run with
  state 3's book (`NOV_PLAN`) in the render copy. Same code, same data, no
  redrawing.
- **Band slider = H's doom layer.** Each background is H's state 3 rendered at
  `?band=0..6` with everything but the room hidden (room photo, sky, grade,
  glow, soot, grain, vignette, desk, and the late layer at 5-6). As in H, the
  layer changes the room only; the panels keep their colours. The first brief
  said "over everything"; keeping H's rule (room only, panels unchanged) was
  agreed after step 2.
- **Other photos.** The day and mezzanine photos (G's and E's) are put under the
  same layer by swapping the room photo in the render copy. H's window-sky tint
  and the band 5-6 glows are placed for the dawn photo's window, so on the
  mezzanine photo they land mid-room. C's drawn desk and the earlier
  backgrounds are gone; C's desk pieces sit on H's desk strip.
- **Drawing order follows H's stack**, back to front: office cat, attention,
  feed, the dim (toggle), menu rack, resources, commit, P(Doom), reputation,
  H's grain (its `.grain` rule, copied from H at build time), dateline, plan,
  action menu, month review, event card, advisor note.
- **Reset** = the dawn photo at band 2, the dim on, H's dateline, P(Doom),
  resources (tier icons), plan sheet, commit and menu rack at H's positions,
  everything else off. Old codes from step 1 load with defaults for anything
  that no longer exists (storage key is now `pdoom1-mixer-v2`).

### Pixel check (tools/pixelcheck.py)

H `concept.html?state=3&still=1` (mock-up sound button hidden) against the mixer
after Reset, both 1920x1080 in headless Chromium:

| H pieces | Mean diff per channel (0-255) | Pixels off by more than 2 | More than 8 | Largest |
|---|---|---|---|---|
| lossy WebP q95 | 1.26 | 23.45% | 1.77% | 84 (text edges) |
| lossless WebP (kept) | 0.50 | 0.04% | 0.00% | 16 |

The rest is the room background's lossy WebP (q92) in dark areas. H's pieces
are lossless because of this (4.9 MB of cut-outs; the page is 5.8 MB in all).

### Checked (step 2)

- 70 images load (49 pieces, 21 backgrounds); all 63 slot options draw.
- The band slider swaps the background for every band.
- Code copy, reset, paste round-trips (524 characters with a mixed
  arrangement); a broken code is refused; nudges 1 and 10 px.

## Step 3: H-HF

- **H-HF draws states 1, 4 and 5 only**, with the same ids as H; the pieces
  render the whole page, so its second `:root` block (the `--hf-*` tokens) and
  its stencil font come with them (the font is checked loaded before each cut).
- **Its November state is 4 (14 November)**, so its desk parts come from there:
  dateline, P(Doom), resources ($37,400 and reputation 34, after Commit), the
  office cat, and Commit, which in state 4 is the paused month clock with the
  held hours and "month in play". Feed and event card are state 4 too; the
  month review is state 5; the advisor note is state 1.
- **Menu rack from state 5:** state 1 lights the first-month hint on ACTIONS and
  state 4 is the WATCH rack with its keys locked; state 5's is the plain one. It
  carries no numbers.
- **Attention** is H-HF's own `terminal()` with the 1 November book, as for H.
- **No H-HF option** for the action menu, plan sheet or reputation (H-HF has no
  state 2 or 3 and no dial); those slots offer H, C, E, G or none.
- H-HF's pieces are lossy WebP (q92), like C, E and G; only H's are lossless,
  for the Reset match.

### Checked (step 3)

- 81 images load (60 pieces, 21 backgrounds); all 74 slot options draw; H-HF
  is offered in 11 slots.
- Band slider, code round-trip (520 characters), broken code refused, nudges
  1 and 10 px, localStorage: all as before.
- Pixel check unchanged: mean 0.50, 0.04% of pixels off by more than 2,
  largest 16.

## Open questions

- Should Attention stay its own slot? In H it is the desk terminal, which the
  plan sheet covers during planning.
- H's sky tint and late glows are placed for the dawn photo; a real build with
  other office art would need them placed per photo.

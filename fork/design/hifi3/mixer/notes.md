# The mixer -- notes

Open `index.html` (self-contained, relative paths; Google Fonts only).

## What is here

- `index.html` -- the page. One 1920x1080 stage scaled to the column; controls
  beside it on wide screens, below it under 1100 px, rows stacked under 520 px.
- `pieces.js` -- generated: every piece's file, native stage position, size and
  source state; the office backgrounds.
- `cut/<slot>-<design>.webp` -- transparent cut-outs (40 so far).
- `bg/<design>.webp` -- office art with the interface hidden (4).
- `tools/cut.py` -- renders one design's concept.html in headless Chromium with
  CSS injected into a temporary copy (the design files are never edited), keeps
  only the chosen elements visible, crops to the visible pixels. The crop's
  top-left is the piece's native position, shadow included.
- `tools/build.py` -- the list of pieces (slot, design, state, selectors) and the
  build. Rerun: `MIXER_SCRATCH=<scratch dir> python3 tools/build.py [designs...]`
  (merges into `tools/manifest.json`).

## Choices made in step 1

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
- **Drawing order is fixed by slot** (back to front): attention, rack, feed,
  resources, plan, action menu, month review, event card, commit, P(Doom),
  reputation, dateline. The band layer sits over everything.
- **Dim toggle.** H's dim (the same radial gradient as H's `.dim`) between the
  office and the pieces. Reset turns it on, as H's state 3 has it.
- **Band slider.** Bands 0-6; November is band 2 (HIGH, 40.2%). The layer is a
  placeholder grade (warm lift below 2, colder, redder and darker above 2) until
  the revised H's `?band=` layer is cut in.
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

## Left for steps 2 and 3

- H's pieces now are a trial from the current H (doom, rep, dateline, rack,
  plan, commit). Recut all from the revised H: add H's resources (tier icons and
  `?res=trace` as the "H, trace window" option), H's feed/attention/menu/event/
  review if the revised H has them.
- Band layer: per-band backgrounds or H's own layer from `?band=0..6`.
- Reset must reproduce H's state 3: pixel compare and report. Expected small
  differences: H's grain sits in the background under the pieces here, and the
  pieces are WebP.
- H-HF pieces (states 1, 4, 5).

## Open questions

- Should Attention stay as its own slot once H's design is known, or fold into
  the plan panel?
- The placeholder band grade is mine, not H's; it goes when H's layer arrives.

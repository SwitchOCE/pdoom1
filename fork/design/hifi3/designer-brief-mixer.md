# hifi3 addendum: brief for the mixer

You built concept E. This is the last design round. Alex wants an
interactive page where he picks elements from the designs and overlays
them on one screen. Work in /home/alex/code/pdoom1 (branch
`design/ui-concepts`), only in fork/design/hifi3/mixer/.

## Alex's words (verbatim)

> "... if we could build an interactive artifact that lets me pick
> specific elements from these designs and overlay them and stuff. After
> these passes, then I think we're good to go"

(Fuller quote and context: fork/design/hifi3/brief.md, "## Addendum
(2026-11-22)", item 3. Read that item in full; it is the spec for this
page. The outside reviewer's message is private: never quote or commit
it.)

## What to build: fork/design/hifi3/mixer/index.html

From the addendum, item 3 (all of it binds you):
- One 1920x1080 stage, scaled uniformly to the window.
- Slots: P(Doom) meter, reputation, resources (tier icons / trace window
  / the plain numbers), dateline, menu rack, plan panel, Commit and
  held-for-events, action menu, event card, month review, feed. Each slot
  offers that element from H, H-HF, C, E and G where the design has one,
  or "none". C, E and G are labelled "earlier texture" in the slot list.
- A background picker (the office art from the designs) and a doom-band
  slider (bands 0-6) that applies the band colour layer over everything.
- Drag to move, toggle on/off, a reset button that restores H's layout.
- Built from cut-out renders: transparent WebP of each element, rendered
  from each design's concept.html in isolation (inject CSS in your render
  script to hide everything else and make the background transparent; do
  not edit other designs' files). Honest to the designs, not redrawn.
- Data: desk pieces from state 3 (November 2017); the event card from
  state 4; the month review from state 5. The tier-icon and trace-window
  resource pieces come from H.
- Keyboard: Tab selects an element, arrow keys nudge 1 px, Shift+arrow
  10 px; every control has a visible focus.
- The arrangement is saved in localStorage (with try/catch) and shown as a
  short code: base64 of JSON with each slot's design, x, y and on/off,
  plus the background and band. A paste box loads a code back in.
- Page rules: self-contained, relative paths, under 16 MB in all, Google
  Fonts only, works at phone width (the stage may scroll or shrink; the
  controls must stay usable), no internal jargon (no "council", agent
  names or dictated words), ASCII.
- Done when: every slot loads; reset reproduces H's own render of state 3
  (compare the pixels and report the difference); a code round-trips
  through copy and paste.

## Order of work

H is being revised now by its designer (hierarchy, colour by band,
resources as tier icons and a trace window), and H-HF (a heavier-texture
H) comes after it. So:
1. **Now:** build the page frame, the slot system, drag/keyboard, the code
   save/load, the band slider plumbing, and the cut-outs from C, E and G
   (fork/design/hifi3/<C|E|G>/concept.html?state=3, 4, 5). Use the
   current H only to try the pipeline; do not finish H's pieces yet.
2. **When I say H is ready:** cut out H's pieces (from the revised
   fork/design/hifi3/H/concept.html, which will have stable ids or
   classes per element, and `?band=0..6` for the band layer, and
   `?res=trace` for take b), make reset match H's state 3, and run the
   pixel check.
3. **When I say H-HF is ready:** add its pieces
   (fork/design/hifi3/H-HF/concept.html, states 1, 4, 5 only; use what
   matches the slots).

Reply "MIXER FRAME DONE" after step 1 (what works, what is left, a disk
report), and "MIXER DONE" after step 3 with the pixel-check result, the
page size, how to use it in 3 lines, and a disk report.

## Rules

Write only in fork/design/hifi3/mixer/ (render scripts may live there);
no git; no subagents; ASCII only in text you write; do not ask questions
(carry them to mixer/notes.md). Rendering: headless Chromium with
--no-sandbox, one at a time (other designers share the box), scratch
deleted. Every reply ends with a disk report.

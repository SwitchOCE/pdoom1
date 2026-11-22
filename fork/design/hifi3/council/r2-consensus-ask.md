# hifi3 council round 2: consensus

Read the other two answers in this folder: r2-opus.md, r2-sol.md,
r2-neon.md. Opus: GOOD TO GO. Sol and neon: CHANGES NEEDED.

Blocking items raised (one member each):

- S1 (sol) Mixer: drag picks a piece by its box, so a transparent area of
  an upper cut-out steals the drag from a visible piece under it. Fix:
  hit-test the visible pixels (alpha) of each cut-out; keep keyboard focus.
- S2 (sol) Mixer: a piece can be dragged (or loaded from a code) wholly
  off the stage, losing its focus ring and its grab area. Fix: clamp so
  enough of each piece stays on the stage, also when loading a code.
- S3 (sol) H and H-HF: the resource number rounds to a whole unit but the
  tier icon uses the raw value (60.25 shows "60" with tier 4; 0.25 shows
  "0" with tier 1 and the loss note). Fix: derive tier and number from the
  same shown amount at the game's display precision; trace samples too;
  spec says so.
- N1 (neon) H take b: the "TRACE since Jul 2017" tab hangs below the
  resource strip and the plan sheet (top 88 px) cuts it in half in state
  3, at both sizes, on the page and in the mixer. Fix: move the caption
  out of the sheet zone, re-render s3/s5/s6-trace, re-cut the mixer piece.

Non-blocking items I plan to fold in anyway (cheap, same files):
opus 1 (gap between the reputation number and "0 ends the run"), opus 2 /
sol 2 / neon 3 (band strip caption: the P(Doom) meter stays at 20% so
only the room changes; "the newer hierarchy" not "this round's
hierarchy"), opus 3 (spec 2.4: game band to palette-doc art band
mapping), sol 1 (spec 7.1: AFTER COSTS strip is state 3 only), sol 3
(mark the late trace as a projected example on the page), neon 1 (H-HF
reputation cell right padding at 720), neon 2 (H event badge ink to
#e4dac4 as in H-HF).

For each of S1, S2, S3, N1: AGREE (blocking, fix it) or DISAGREE
(why, in one line). Object to any planned non-blocking change if it is
wrong. Say whether, with these done, you would answer GOOD TO GO.

Reply in this format and write it to
fork/design/hifi3/council/r2-consensus-<your name>.md. Read-only
otherwise; close any Chromium you start.

```
S1: AGREE | DISAGREE -- why
S2: ...
S3: ...
N1: ...
Non-blocking objections: none | ...
With these fixed: GOOD TO GO | still CHANGES NEEDED -- why
```

# hifi3 council round 2: agreed fixes

Round 2: opus GOOD TO GO; sol and neon CHANGES NEEDED. Consensus
(r2-consensus-*.md): opus and sol AGREE all four blocking items, no
objections to the planned non-blocking changes, and both say GOOD TO GO
once they are done. Majority settled.

## Blocking (fix all)

- **S1 Mixer, transparent drag.** A drag picks a piece by its box, so a
  transparent part of an upper cut-out takes the drag from a visible piece
  under it. Pointer targeting uses each cut-out's visible pixels (alpha);
  pieces stay keyboard-focusable (Tab, arrows).
- **S2 Mixer, offstage.** Clamp every piece so a grab area and its focus
  ring stay on the 1920x1080 stage: on drag, on arrow nudges and when
  loading a code.
- **S3 H and H-HF, tier precision.** The tier icon and the number both come
  from the same shown amount at the game's display precision (the number as
  printed); trace samples too. The "0 ends the run" note follows the shown
  amount for the mock-up; the real loss rule stays game state. Spec 3.2
  says so.
- **N1 H take b, clipped caption.** The "TRACE since ..." caption must not
  sit under the plan sheet (top 88 px) or the actions sheet. Move it clear,
  check states 2, 3, 5, 6 with ?res=trace, re-render s3/s5/s6-trace, spec
  updated if the position changes.

## Non-blocking, folded in

- opus 1: reputation cell, a clear gap between the number and "0 ends the
  run" (H and H-HF).
- opus 2 / sol 2 / neon 3: page captions (done by the orchestrator).
- opus 3: spec 2.4, the mapping from game bands to the palette doc's art
  bands, as H's layer actually uses it.
- sol 1: spec 7.1, the strip and AFTER COSTS comparison is state 3 only.
- sol 3: page, the late trace marked as a projected example (done by the
  orchestrator).
- neon 1: H-HF reputation cell, 4-6 px more right padding at 720.
- neon 2: H event option badge ink #c9bc9f -> #e4dac4, as in H-HF.

## Re-check asks

Re-measure contrast on every changed render. Re-cut the mixer's changed H
and H-HF pieces and re-run the Reset pixel check against H state 3.
Re-check: transparent drag targeting, offstage coordinates, tier
boundaries (60 / 60.25 / 0.25), caption clearance at both sizes and in the
mixer.

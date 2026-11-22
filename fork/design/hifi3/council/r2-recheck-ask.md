# hifi3 council round 2: re-check

The fix round is done and pushed (design/ui-concepts, commits 8a3a51d5
and 3349471f). The agreed list is fork/design/hifi3/council/r2-agreed.md.

What each designer reports (check it, do not take it on trust):

- **S1 / S2 (mixer/index.html, pieces.js):** pieces are picked by their
  visible pixels (alpha masks built with the cut-outs, in pieces.js); every
  piece is clamped to the 1920x1080 stage on drag, nudge and code load;
  the focus ring is drawn inside the piece. H and H-HF pieces re-cut;
  Reset vs H state 3: mean 0.496/255, 0.04% of pixels off by more than 2,
  largest 16.
- **S3 (H/concept.html, H-HF/concept.html, spec.md 3.2):** number, tier
  icon, warn colour and trace samples all use the amount the game prints
  (whole units, halves away from zero, sign from the raw value). Reported:
  rep 60 and 60.25 -> "60", tier 3; 60.5 -> "61", tier 4; 0.25 -> "0",
  tier 0. One difference: for -0.4, H prints "-0" (as the game does) and
  H-HF prints "0".
- **N1 (H take b):** the TRACE caption is now the strip's first cell
  (`.rc.cap` inside #resources, y 16-76), clear of the sheets (top 88) and
  the event card (93). Trace windows are smaller. s3/s5/s6-trace
  re-rendered; mixer piece res-Hb re-cut.
- **Non-blocking folded in:** the reputation gap and rule (H, H-HF); H's
  event badge ink #e4dac4; H-HF reputation cell padding; spec 2.4 band to
  art-band table; spec 7.1 screen 3 only; page captions (band strip at
  20%, projected late trace, "the newer hierarchy").
- All H renders changed (the reputation cell is in every shot). Reported
  contrast minimum at 720: H 4.53 (s4 4.93), H-HF 4.76. Full-size PNGs are
  on disk, uncommitted, in H/ and H-HF/.
- The page was rebuilt (index.html).

Check that each blocking item is fixed and that the fixes broke nothing
(re-measure 4.5:1 on what changed; the run's data and the agreed rules).
Only new blocking problems count; redesigns are out of scope.

Answer format, written to fork/design/hifi3/council/r2-recheck-<your
name>.md, and the same text in your reply:

```
VERDICT: GOOD TO GO | CHANGES NEEDED
S1: done | not done -- evidence
S2: ...
S3: ...
N1: ...
Non-blocking folds: ok | problem -- what
Scores (/10): hierarchy . colour . resources . H-HF . mixer . spec . page
New blocking items: none | [where] what -- the fix
```

Read-only otherwise. Close any Chromium you start.

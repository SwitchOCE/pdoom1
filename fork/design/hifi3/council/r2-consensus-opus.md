S1: AGREE -- The mixer's `pointerdown` handler sits on each piece's box (mixer/index.html:237), so the top box takes the drag even where the cut-out is transparent. Alex can't drag the piece he can see, which fails "drag works". Keep the fallback of focusing the piece and nudging it with the arrow keys.
S2: AGREE -- `move()` (mixer/index.html:228) has no clamp. Pasted codes are not clamped either, so a piece can end up off the stage and unreachable by pointer. Apply the same clamp on drag, on arrow nudges and when loading a code.
S3: AGREE -- H/concept.html:833 shows `Math.round(v)`, but :835 takes the tier from the raw `v`. Reputation is a float in the game, so "60" can show the tier-4 medal, and "0" can show tier 1 next to "0 ends the run". That is one display contradicting another. Take the tier from the shown amount, and say so in spec 3.2.
N1: AGREE -- I checked H/s3-trace.png and s3-trace-720.png. The plan sheet's top edge cuts "TRACE since Jul 2017" through the middle of its letters at both sizes. I missed this in round 2.
Non-blocking objections: none. Three notes on how to do them:
- Opus 3: write the band mapping H's layer actually uses. My example was only a shape.
- The planned changes alter the s4 badge ink and the s3/s5/s6 traces. Re-measure contrast on those new renders.
- Re-cut the mixer's res piece. Then re-run the Reset pixel check against s3, because the trace tab sits in the H piece set.
With these fixed: GOOD TO GO

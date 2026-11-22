VERDICT: GOOD TO GO
S1: done
- I tested it in headless Chromium at 1600 and 390 px by sending real pointer events to the stage.
- I found a point (1345,30) where doom's box is on top but its pixels are transparent and res shows underneath.
  - A press-drag there of +20,+10 moved res from 446,0 to 466,10. Doom did not move.
  - Focus went to res's button, and res was selected.
- The press now goes through `pieceAt`, which reads the alpha masks in pieces.js (mixer/index.html, the `hits`/`pieceAt` functions).
- The pieces are still buttons, so focus and arrow nudges still work from the keyboard.
S2: done
- `clampXY` is applied in `move()` (drag and nudge) and in `valid()` (loading a code and reading localStorage).
- Results:
  - dragging doom +5000/-5000 left it at 1351,0, with its box's right edge at 1920;
  - ten shift-nudges to the right kept it there;
  - a pasted code with plan at -9999/99999 loaded at 0,57, with its box bottom at 1080;
  - rack x "abc" loaded at 0.
- The focus ring is 6px solid, offset -6px, so it sits inside the piece.
- Reset puts H's pieces back.
- My Reset vs H/s3.png check found the same content, with differences only in sub-pixel text antialiasing:
  - mean 2.7, the same as my round 2 figure;
  - no shift improves it;
  - side-by-side crops of the strip match.
S3: done
- H/concept.html now has `shownAmount` (whole units, halves away from zero, sign from the raw value).
- It feeds the tier, every trace sample and the "now" point. The number comes from `shownText`.
- This matches `format_grouped` and `format_scalar` in game_config.gd, including "-0" for -0.4 in H.
- Spec 3.2 states the rule and says the loss check stays on the raw state (game_state.gd:791).
N1: done
- In H/s3-trace.png and s3-trace-720.png, "TRACE / since Jul 2017" is now the strip's first cell, inside the strip.
- The plan sheet starts clear below it at both sizes.
- The cell clears the dateline ("...2017" ends about 80 px to its left).
- The mixer's res-Hb piece was re-cut.
Non-blocking folds: ok
- The reputation cell now reads "50 | 0 ends the run" (H at 1920, H-HF at 720, with padding).
- Spec 2.4 has the art-band table, with violet from game band 5, which agrees with the palette doc's "purple for band 3+".
- Spec 7.1 says screen 3 only.
- H's event badge ink is #e4dac4.
- The page captions are in:
  - the 20.0% meter;
  - the projected late trace, worded plainly;
  - "the newer hierarchy".
- The page has 21/21 images and no page scroll at 1440, 390 or 320 (1425/1425, 375/375, 305/305) with every `<details>` open.
- Two small notes, neither blocking:
  - H-HF's `shownAmount` prints "0" where H and the game print "-0" (for -0.4). Copy H's function so the two stay data-identical, as spec 8 says.
  - The mixer's hint still says "before the latest round of changes". "Before the newer hierarchy and colour changes" would drop the process word, as the page now does.
- Contrast re-measured on the new renders (box median vs stroke core):
  - H s1, s2, s3, s4, s6, the three traces and bands 0/3/6: 1920 min 4.88 (the 81.4% in s6).
  - At 720 the min is 4.52-4.53, on the held note in every shot except s4 (4.96).
  - H-HF s1/s4/s5 at 720: 4.74 / 5.25 / 4.74.
  - My fresh s5 check again reads the review paper at about 1.1. That is my fallback fonts shifting the line wraps, the same artefact as round 2. On the committed s5.png that paper is dark ink on light paper and reads clearly.
- The data and the rules hold: $140,000, compute 65, research -12, papers 0, rep 32, and the band and pool figures as before.
Scores (/10): hierarchy 9 . colour 9 . resources 9 . H-HF 8.5 . mixer 9 . spec 9 . page 9
New blocking items: none

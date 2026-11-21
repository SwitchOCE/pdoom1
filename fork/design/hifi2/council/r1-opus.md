VERDICT: GOOD TO GO

## Score (/10)
H 8.5/10 . belongs beside the grim gallery: yes, average to better

It sits with frostpunk-menu-3 (the Archives: an aged sepia sheet in a dark
frame), frostpunk-3 (the starvation event panel) and papers-please-1/2
(one lit document on a dark desk). The paper-on-dark rule is carried out
more strictly than in most of the gallery. The chrome is flatter and more
"software" than Frostpunk's smoky, bevelled frames, so it does not quite
match the best of the gallery.

Checked: H s1-s6 at 1920, and s2 and s3 at 1280x720; notes.md;
concept.html's tokens and the reduced-motion rule; the showcase
(index.html and before/). Contrast was measured on the renders with a WCAG
luminance script, and thin paper text was cross-checked against its true
ink colour.

## Alex's items (a)
1. Palette and meter from G -- met -- P(Doom) is G's 270-degree arc with
   the band ladder and "band 2 of 7". Rep uses the same arc style as a
   half-circle ("0 ends the run"). Band colours run green (s1),
   amber/orange (s2-s5), magenta (s6).
2. Layout from A -- met -- rack, desk, office and Commit sit in A's
   places. The s2/s3 stations open over the same frame. No damage against
   A (see e below).
3. A smaller, quieter Commit -- met -- 296x60 at bottom right with a
   muted fill. It hides Enter whenever a station or event is on top
   (s2, s3, s4). In WATCH it becomes a dashed "MONTH RUNNING".
4. E's action menu, dark -- met -- s2 is E's card file on a dark ground
   with hatched blocked cards and "1 queued" / "2 queued" tags. Enter
   appears only in the detail strip.
5. Paper the only light thing, and aged -- met -- the advisor note (s1),
   event (s4) and review sheet (s5) are the only light surfaces (#bfb39a
   with stains and torn edges). Everything else is dark.
6. Typewriter dateline, date only -- partly -- "JULY 4, 2017" in Courier
   Prime bold, with no "turn 1" or speech. It types in, and reduced motion
   turns that off (concept.html:83). At 28px with wide tracking it reads
   small and thin next to the meter, not the "chunky vibe" Alex asked for.
7. Not cartoony -- partly -- the chrome, panels and type are no longer
   cartoony. Some of Pip's icons still look like toys: the cat, the
   money-bag, the knight and the glowing eye. The notes list them as
   needing grim art, which is the right handling for a texture pass.
8. Bleaker without damaging the UI, room for state 6 -- met -- the room
   dims in steps by art band (.62/.55/.46/.36). s6 still has room to get
   worse (near-black office, violet window, magenta meter, "Very close to
   game over"). Purple appears only in s6. Operational text stays readable
   throughout.

## Blocking items
None.

(b) Belongs: yes (references above).
(c) No layout defects at 1920 or 720; s2 and s3 scale cleanly at 720.
Measured contrast: most text 4.8-7.8:1. Lowest operational text: s1 rep
scale "0/100" 4.91, s6 "CATASTROPHIC" 4.82, s6 "Very close to game over"
4.91, s5 red "Talent Opportunity" 4.98. The s2 rack under the dim is 3.38,
but that is dimmed background, not operational. The s4 paper footer is the
weak spot: see non-blocking 1.
(d) Data agree with run-state. Jul $245,000 / rep 50 / 20.0%; Nov $140,000,
11 plays at $102,600 + 6 rep, after costs $37,400 / rep 26; held 7 = 1
used + 6 evaporated; both hires $25,000 + 1 held hr; Dec 56.7% SEVERE;
Apr 81.4% CATASTROPHIC / rep 21. The agreed rules hold:
- no doom deltas;
- the spill is drawn operating->planning only (s3 SPILL 1);
- the reserve is live and untyped (0 hr stepper);
- no NEW chips;
- attention bars are filled for hours left;
- only the top layer shows Enter/Esc.
(e) No layout damage against hifi A.

## Non-blocking (at most 3)
1. s4 paper text is borderline. The option effects and the footer are
   16px Courier 400 in --ink-soft #30281d on grimy paper. That is about
   4.6:1 against the paper's median colour, but only 3.9-4.4:1 sampled on
   the antialiased strokes where the stains are darkest. Fix: use --ink
   #1e1810 or weight 700 for paper text at 16px.
2. s4 is busier than it needs to be. The date appears three times:
   dateline, month clock and event header. The rack keeps its letter
   keycaps while the event owns the keys (the same note as A in the hifi
   round). Fix: drop the clock's date line in WATCH, and hide the rack
   keycaps under an event.
3. Texture finish. The s5 review sheet's grime reads as soft cloudy
   blotches, not wear (no fold lines, edge darkening or fibre). The
   panels' frames are flat compared with Frostpunk's. In s6 the office art
   goes almost black, so the room is lost, not grim. Fix: give the paper
   creases and edge burn, give the frames a little bevel and soot, and set
   s6's floor brightness to about .42.

Staff/Hire icons (open question): Pip's `ui_staff_management` silhouettes
and the Hire Staff head-and-shoulders remain; no new person is drawn. Not
blocking, as asked.

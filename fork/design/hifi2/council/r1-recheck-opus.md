VERDICT: GOOD TO GO

## Score (/10)
H 8.5/10 . belongs beside the grim gallery: yes, average to better
(frostpunk-menu-3, frostpunk-3, papers-please-1/2; unchanged from round 1)

Checked against commit 4a13877f. I viewed the new renders at 1920 (s3, s4,
s5) and at 1280x720 (s2, s4, s5); the PNGs and WebPs were exported
together at 09:16. I read concept.html (dateline(), home(), commit(), the
.dim calls, the .ev-* styles), the notes' fix-round section and
index.html's tab(). Contrast was re-measured on the composited PNGs. Each
result gives two numbers: the stroke core (k-th farthest pixel, the
designer's method) and the median of all stroke pixels (stricter; thin
antialiased type always scores lower on it).

## Agreed items: done or not

1. Dim layer order -- **done.** .dim now follows room() (concept.html:618,
   766) and, in state 5, the room, terminal and cat (home(), :694). On the
   renders the instruments are at full strength. Results (stroke core /
   stroke median):

   | Text | 1920 | 720 | Round 1 |
   |---|---|---|---|
   | s2/s3 "40.2%" | 7.39 / 7.28 | 7.33 | 2.7 |
   | s2/s3 HIGH | 7.33 | 7.34 | |
   | s2/s3 "band 3 of 7" | 5.51 | 5.50 | |
   | Reputation "32" | 11.1 | | |
   | "0 ends the run" | 5.84 | 5.38 | |
   | held note | 5.44 | 4.72 | 2.2 |
   | COMMIT THE MONTH | 7.94 | | 2.8 |
   | rack labels | 12.0 | | |
   | lit ACTIONS / PLAN plates | 12.8 | | |
   | s5 "56.7%" | 4.90 / 4.85 | | 2.0 |
   | s5 SEVERE | 4.87 / 4.84 | | 2.0 |
   | s5 "band 4 of 7" | 5.51 | | |

   Everything is at or above 4.5:1 on the stroke core at both sizes.
2. Dateline -- **done.** dateline(d, entry) types only when entry is true:
   home() for states 1, 5 and 6 (:698); states 2, 3 and 4 pass false (:621,
   :769, :794). STILL and reduced motion are unchanged (:514, :83). s4
   reads "NOVEMBER 14, 2017", matching the clock's TUE 14 NOV.
3. WATCH Commit slot -- **done.** "MONTH IN PLAY", dashed and inert
   (:589). The clock keeps "PAUSED FOR YOU". Checked in s4 at both sizes.
4. s4 paper text in --ink -- **done.** .ev-f and .ev-o span use --ink
   #1a140d (:320, :324). "no change" is --ink 700 (:323). Sampled stroke
   pixels reach (26,20,13) on paper (173,161,136), about 7:1. Stroke cores
   on the 1920 render: "no change" 7.33, footer 6.3-6.6, "free" 6.39.
5. Rack keycaps -- **done.** In s4 there are no keycaps on FEED, STAFF,
   LEDGER and GUIDE, nor on the hatched ACTIONS, PLAN and UPGRADES, and
   the terminal's "Feed and results" has no F. The event's Enter is the
   only key on screen. Other states keep the rack's letters, as in A.
6. Showcase focus (orchestrator) -- **done.** tab() rebuilds the view and
   then focuses the button with the same label (index.html:113). I read
   the code and did not try it in a browser.

Nothing nearby broke:
- Layout is unchanged against round 1 at both sizes.
- The numbers still agree: $140,000 -> $37,400, rep 32 -> 26 / 34, held
  17 (s2) / 7 (s3, s4), $102,600 + 6 rep, both hires $25,000 + 1 held hr,
  $12,400, HIGH -> SEVERE with no delta, 7 = 1 + 6.
- The hifi rules hold:
  - filled pips = hours left;
  - one row target per play;
  - Enter/Esc only on the top layer (s3 "P Esc" with Commit bare; s5 the
    review's Enter only);
  - no NEW chips.

The designer's extras are not a problem:
- Bold paper labels are one weight step, still typewriter.
- The inverted paper keycap (Enter on Fast-Track) is a dark ink block on
  paper. It reads as a typed key, not a light surface, so "paper is the
  only light thing" still holds.
- The solid reserve -/+ bars read cleanly at 720.
- Dropping the terminal's F under the event follows item 5's reasoning.

## Majority items
- Item 3, "MONTH IN PLAY" (opus, sol): accept (I proposed it).
- Item 5, live plates without keycaps under the event (opus, neon):
  accept.
- "LAB TERMINAL 1" carried to the report (sol, neon): accept.

## Blocking items
None.

## Non-blocking (at most 3)
1. s4: the option costs ("$25,000 + 1 held hr", "free") are the only
   16px paper text still at weight 400. The colour passes (about 7:1 at
   the stroke core), but at 720 they are the thinnest text on the slip:
   the stroke median for Standard's cost is 2.5. Fix: set them in 700
   like the footer.
2. s5: Commit now sits above the dim at full strength ("COMMIT THE
   MONTH", 7.9:1) while the review owns the screen. It has no Enter, so
   rule 2 holds, but it looks pressable. A could do the same, so this is
   a note for the report, not a fix.
3. Carried to the report as agreed:
   - "LAB TERMINAL 1" and the green LED;
   - the calendar "17" PLAN glyph;
   - the date shown three times in s4;
   - paper creases, frame soot and the s6 floor brightness;
   - Pip's Staff/Hire icons (the open question).

VERDICT: GOOD TO GO

## Scores (showcase-ready, /10; not a ranking)
A 9/10 . C 9/10 . E 9/10 . G 8.5/10

Checked against commit 6f30d591. I looked at the changed states at 1920
(the .webp files the page shows) and spot-checked 1280x720 (C s5, G s3).
None of the .webp files is older than its .png. I read the index.html
diff, run-state.md REVISION 3 and each notes.md.

## Agreed items: done or not

All four
1. Standard Hiring is "$25,000 + 1 held hr" in A, C, E and G s4. Decline
   is free. State 5 is unchanged (7 held, 1 used, 6 evaporated). This is
   in run-state REVISION 3, and every notes.md files the old open question
   as settled. **Done.**

A
1. s2: no NEW clips on Safety Audit or Strategic. **Done.**
2. s4: "+1 safety researcher" on both hiring rows and "no change" on
   Decline. Costs and Enter still align on the top line of each row, and
   the slip still fits above the dial. **Done.**
3. s5: a "1 NOV -- AT COMMIT" header over rows 01-11, and a separate
   "14 NOV" header over Talent Opportunity (no number). The sheet still
   fits, and the Enter button is unclipped. **Done.**

C
1. The P(Doom) counter sits above the dim: "40.2% RISING / HIGH" (s2) and
   "56.7% / SEVERE" (s5) are at full brightness, as is the rest of the
   wall strip. **Done.**
2. s1: the Advisor closes with a plain "Got it", no Esc keycap. **Done.**
3. s2: the dotted empty frames are gone and the slots are plain. **Done.**
4. s4 teleprinter and s5 sheet print "Reached out through your network --
   a pre-vetted lead may surface shortly." The s5 sheet now runs to about
   y 1030, still inside its perforated edge at 1920 and at 720. **Done.**

E
1. s2: no NEW on Strategic, and no "new this month". Enter shows once, in
   the detail strip ("[Enter] Add to plan"); the focused card shows "+".
   **Done.**
2. s3: Commit shows no Enter while the CRT is open. **Done.**
3. s3: the printout is titled "AFTER COSTS" and reads "Research (now)
   -12". **Done.**

G
1. s2: no NEW chips. **Done.**
2. s3: "Reserved, up to 7 hr -- none yet", and "Reserve hours [R]" is
   live. The main_ui-vs-core mismatch stays in the notes. **Done.**
3. s3: Read the Literature is two rows (2, 3). All 11 plays show, with
   Order Office Supplies and its "1 from plan" spill above Total, at 1920
   and at 720. **Done.**
4. --held is neutral: the s4 pips are pale grey and the "7 hr" values are
   neutral. Purple appears only in s6. **Done.**
5. s4 and s5 show the same four Wed 1 Nov lines, word for word, as a
   queue-order subsequence (plays 5, 8, 10, 11). **Done.**

Showcase (orchestrator)
- E's caption now names Actions, Plan, Lab Floor, Procurement, Records.
- The state 4 caption gives both hires "$25,000 + 1 held hour".
- The state 3 caption says today's pre-check refuses the spill.
- The lightbox image is capped at calc(100vh - 64px).
- Thumbnails are buttons with aria-labels; focus moves to Close on open
  and back to the thumbnail on close.
- The concept view names fork/design/hifi/<L>/concept.html as "an HTML
  mock-up".
- The 2/3-scale line is present. No relative links remain.
**Done** (lightbox fit read from the CSS, not tried in a live browser).

Nothing nearby broke. November numbers still agree across states 2-5:
$140,000 / $37,400 / $12,400, rep 32 / 26 after costs / 34, research -12
/ -6, held 17 / 7 / 7 = 1 + 6.

## Majority items
- C3, the dotted frames (opus, sol): accept.
- C4, Work Your Connections' message (opus, neon): accept.
- G3, two Read the Literature rows (sol, neon): accept. I voted against it
  as blocking, but the fix is clean and costs nothing.
- Publish Safety Paper icon stays non-blocking (opus, neon): accept.

## Blocking items
### A
None.
### C
None.
### E
None.
### G
None.
### Showcase page (index.html)
None.

## Non-blocking (at most 3)
1. G s4/s5: "+ 7 more lines from Wed 1 Nov" sits at the top of the feed,
   but the four lines shown are plays 5, 8, 10 and 11, so plays 6, 7 and 9
   fall between them. "+ 7 other lines" would be exact.
2. A s4: the rack keeps its letter keycaps (F, E, L, F1) while the event
   owns the keys. Rule 2 covers only Enter and Esc, but C, E and G hide
   every background key here.
3. Showcase: once published, open one lightbox at 1280x720 to confirm the
   bottom of the screen (Commit) is in view.

# Grim pass council round 1: settle one list

You are one of three members (opus, sol, neon). All three round 1 answers
are in this folder, verbatim: r1-opus.md, r1-sol.md, r1-neon.md. Read the
other two members' answers in full.

Alex's words are quoted in full in round1-ask.md. In short: a texture and
feel pass ("changing the texture of it ... rather than the layouts so
much"), bleaker "without damaging the UI". Redesign, new features and
mechanics are out of scope: mark anything like that non-blocking. One fix
round follows this; prefer items the designer can fix in that round.

## Scores in round 1

opus 8.5 GOOD TO GO; sol 8 CHANGES NEEDED; neon 8.5 CHANGES NEEDED.

## Blocking items raised (as written by the member who raised it)

1. (sol, neon) The full-stage .dim layer covers the P(Doom) and reputation
   meters, the shortcut rack, Held for events and Commit in states 2, 3 and
   5, and drops their text to about 2.0-3.7:1. Fix proposed: put .dim
   directly after the room (in state 5 also after the left terminal and the
   cat print), so the instruments sit above it as in hifi A, then re-measure
   on composited pixels. (opus measured the s2 rack at 3.38 and called it
   dimmed background, not blocking.)
2. (sol) The dateline types in again within November (states 2, 3, 4 all
   call the strike animation; WATCH's Nov 14 types every character). Fix
   proposed: animate only on a month's entry; show the date already set in
   in-month states; keep December's and the reduced-motion handling.
3. (sol) State 4: the clock says "PAUSED FOR YOU" while the Commit slot
   says "MONTH RUNNING". Fix proposed: "MONTH IN PLAY" (as in G) or
   "AWAITING REPLY".

## Factual context from the orchestrator (checked in the code; labelled as mine)

- H/concept.html adds `el("div","dim")` at lines 616 (plan), 762 (hand) and
  805 (review), after the meters, rack and Commit are added.
- dateline() is called at lines 618, 693, 763, 787 and 806, once per
  state screen, with no check for whether the month changed.
- Line 586 renders "MONTH RUNNING" in the inert Commit slot in WATCH.
- Non-blocking items from all three overlap: s4 paper footer in
  --ink-soft near 4.5:1 (opus 1, neon 2); keycaps on the rack under an
  event (opus 2, neon 1); calendar PLAN glyph and "LAB TERMINAL 1" (sol,
  neon). The showcase focus item (sol) is the orchestrator's to fix.

## What to do

For every blocking item raised by another member: agree, disagree, or agree
with a different fix, with evidence. Say whether any non-blocking item
should be in the fix round anyway (it is cheap to include). End with your
proposed joint list: blocking items, and the cheap non-blocking items to
include. Keep your score or revise it (say which).

Write to fork/design/hifi2/council/r1-consensus-<your name>.md and reply
with the same text. Read-only otherwise.

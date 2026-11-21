# hifi3 council round 1: settle one list

You are one of three members (opus, sol, neon). All three round 1 answers
are in this folder, verbatim: r1-opus.md, r1-sol.md, r1-neon.md (if a file
is missing, the member's reply text was the same). Read the other two in
full. Alex's words and decisions: round1-ask.md and ../brief.md. One fix
round follows; prefer items fixable in it.

## Round 1

| Member | Verdict | H | C | E | G | spec | page | sound |
|---|---|---|---|---|---|---|---|---|
| opus | GOOD TO GO | 9 | 8 | 8.5 | 8.5 | 9 | 9 | 8 |
| sol | CHANGES NEEDED | 9 | 9 | 9 | 9 | 8 | 8 | 8 |
| neon | CHANGES NEEDED | 9 | 8 | 9 | 9 | 8 | 8 | 7 |

## Blocking items raised (short form; the member's file has the detail)

1. (sol 1; opus non-blocking 2) Sound replays overlap: each play makes its
   own compressor into the same output; three quick presses peak at 1.14
   (clips). Gate replay until the previous tail ends, both motion settings,
   in H, C, E, G and the page demo.
2. (sol 2) Page at 320 px with the spec open: long inline code paths widen
   the layout to 369 px. Let inline code wrap in the spec; keep scrolling
   local to wide tables and code blocks.
3. (sol 3) Spec 1.2 Attention rule: "billed in queue order" is imprecise
   (self-charging plays debit at execution); describe the spill marker as
   a queue-order estimate; scope the no-spill exception to conference
   travel (ADR-0011).
4. (sol 4) Spec 7.2: Strategic also needs reputation >= 30, not only the
   workday gate.
5. (neon 1) Page converter: a bold phrase wrapped across lines inside a
   list item renders as raw `**...**` (spec 462-463). Join a list item's
   continuation lines before inline formatting; check no raw `**` or
   backticks remain.
6. (neon 2) Spec contradicts H's screens: (a) the spill tag is "SPILL 1" in
   H, not "1 from plan" (spec 430-431); (b) spec 567 on where Money,
   Compute, Research and Papers live when the card file is closed.

## Non-blocking raised

- opus 1: spec citation game_state.gd:617 should be :791 (and
  death_attribution.gd:46); main_ui.gd :1009/:1010. neon 3: the same kind
  of drift (main_ui.gd:1010, screen_mode.gd:101).
- opus 2: render the reference WAV at 44.1 kHz (spec 6.3 asks for it).
- opus 3 / neon Listening and non-blocking 1: the sound could be closer to
  the trope: slower, harder keys (opus: 120-160 ms); a sharper metallic
  contact transient, shorter and less pitched thump (narrower pitch
  spread), a later escapement ping, a more audible carriage-return slide,
  a slightly bigger dark room (neon).
- neon 2: C state 3, the schedule board's clamp touches the P(DOOM) panel
  at 720p.
- sol: spec 3.9, scope "hide every background keycap" to the WATCH event.

## Factual context from the orchestrator (labelled as mine)

- Items 2 and 5 are in the page and its build script, which I own; I will
  fix them. The page demo (demo.js) guards against a second click only on
  the animated path; on the reduced-motion path it does not, which matches
  sol's three-press test.
- Alex's brief: "If Neon asks for sound changes, they go through the
  normal agreed list and fix round." So say whether the sound tuning
  (opus 3, neon's Listening notes) belongs in this fix round, and which
  changes. The designer can re-render the WAV and neon can listen again in
  the re-check.

## What to do

For every blocking item raised by another member: agree, disagree, or
agree with a different fix, with evidence. Say which non-blocking items to
include anyway (cheap), and whether the sound tuning goes in, with which
concrete changes. End with your proposed joint list. Keep or revise your
scores (say which).

Write to fork/design/hifi3/council/r1-consensus-<your name>.md and reply
with the same text. Read-only otherwise.

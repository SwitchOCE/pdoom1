# Council, high-fidelity showcase: review (round 1)

You are one of three council members (low sensitivity: Claude Opus 5.5,
GPT Sol 6.2, Gemini Neon 4). The orchestrator names you ("opus", "sol" or
"neon"). Work in /home/alex/code/pdoom1 (branch design/ui-concepts). This is
a review: read only. Write nothing except your answer file. Scratch renders
are fine under /tmp in a folder of your own; delete it when done.

## Alex's words (verbatim)

> "I just want to be able to show pip like a full artifact something that he
> can look at that shows some of the states for these UIs. Can we take them to
> more fully fleshed out, higher fidelity stuff?"

Earlier steers that still hold:

> "vastly more negative space to show the art ... individual menu systems
> handle state ... way less detail on one screen ... make a complex game
> simpler, not overwhelm the player."

> "I don't like the humanoid kind of outline ... less eerie than the empty
> office, and that eeriness is the kind of vibe the game's going for."

Icons similar to Pip's own (godot/assets/icons/); every icon matches the
button it sits on. Alex rejected an earlier mock-up for icons not matching
buttons, inconsistent alignment, inconsistent font sizes, things overlapping
and overflowing, and lost diegetic flavour.

## What to review

- The showcase: fork/design/hifi/index.html (open it; it loads
  <L>/s1.webp .. s6.webp).
- Four concepts, all in contention -- A. The Desk, C. The Paperwork Desk,
  E. Rooms and Stations, G. The Existing UI, Modernised. For each, in
  fork/design/hifi/<L>/: s1..s6.png (1920x1080), s1-720..s6-720.png
  (1280x720), concept.html (?state=1..6), notes.md.
- The run's brief: fork/design/hifi/brief.md. The one game state every
  concept draws: fork/design/hifi/run-state.md (with its Corrections).
- The game for checking facts: godot/data/ (actions, events, balance),
  godot/scripts/, godot/assets/ (icons, art), and
  docs/game-design/decisions/ADR-0001, ADR-0011, ADR-0015,
  docs/art/PALETTE_AND_DOOM_INTENSITY.md.
- Rules the council agreed in earlier rounds:
  fork/design/research/council/concepts/r2s-agreed.md and r3x-agreed.md
  (Attention bars filled = hours left; only the topmost layer shows
  Enter/Esc; operational text >= 16px; every repeated play has its own edit
  target).

## Check, for each concept and each of the six states

a. Visual defects, at 1920x1080 AND 1280x720: one type scale, aligned
   grids, consistent spacing; no overflow, overlap, clipped or placeholder
   text; icons the same size and placement within a group.
b. Real data and rules: names, costs, hours and descriptions match
   godot/data/ and run-state.md; numbers agree across the six states; no
   doom deltas (ADR-0015), nothing the game hides (ADR-0001); the Attention
   spill rule drawn per ADR-0011 (operating may spill into planning, never
   the reverse).
c. No person or operator silhouette anywhere; the office reads as empty and
   eerie. (Event pictures with people and Pip's Staff/Hire icons are an
   open question for Alex: note where they appear, do not block on them.)
d. Icons match their buttons and read as one set with Pip's.
e. Is it clear, faithful to Pip's game, and worth Pip's time as a showcase?

Scope: this run is about fidelity and showing states, not redesign. Do not
pick a winner or ask to cut a concept. Anything outside Alex's request (new
features, structural redesign, mechanics changes) is non-blocking at most.
Check claims against the files and the game source; quote evidence (file,
state, what you saw).

## Answer format

Write your answer to fork/design/hifi/council/r1-<your name>.md, and reply
with the same text:

```
VERDICT: GOOD TO GO | CHANGES NEEDED

## Scores (showcase-ready, /10; not a ranking)
A x/10 . C x/10 . E x/10 . G x/10

## Blocking items
### A
1. [state N, size] what is wrong -- evidence -- the fix
### C ...
### E ...
### G ...
### Showcase page (index.html)

## Non-blocking (at most 3 per concept)

## People seen (for Alex's open question)
```

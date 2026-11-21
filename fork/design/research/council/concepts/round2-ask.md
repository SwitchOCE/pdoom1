# Council Round 2: simplify -- review the reworked A, C, E

Alex saw the shortlisted concepts A, C and E and asked for a second round.

## Alex's words (verbatim)

> "I think all of the designs need vastly more negative space to show the art, and we have individual menu systems handle state. I feel like they're trying to cram far too much onto the screen. The buttons do need to serve as shortcuts, but there needs to be way more negative space. There needs to be way more, way less detail on one screen. This needs to be simple. It needs to make the goal of this UI is to make a complex game simpler, not overwhelm the player."

The designers were given his words and this reading (the orchestrating
session's proposal, not Alex's words; designers could push back):
research/concepts/round2-designer.md. Read it.

## Inputs

- Each concept: research/concepts/<A|C|E>/concept.html (views home, actions,
  plan, one more menu, optional home-m1 and watch), renders home.png,
  actions.png, plan.png, <other>.png, notes.md (with an element count for the
  home screen).
- Round-1 versions for comparison: research/concepts/<A|C|E>/r1/ (m5.png is
  the old home screen).
- The original designer brief (Must-hold list, states to draw):
  research/concepts/brief.md. Game facts settled last round:
  research/council/concepts/r1-agreed.md ("Shared game facts").

## What to do

1. Visual-defect pass on every new render, as before (alignment, icon match,
   16px/14px floors, overlap, overflow, clipping, spacing, dead space vs.
   intended negative space, near-black backgrounds).
2. For each home screen: estimate the share that is art and empty space
   versus UI (a percentage), and count the separate things it asks the
   player to read.
3. Does the flow (home -> menus -> commit) make the game feel simpler, as
   Alex asked? Is every Must-hold still met across the flow (every action
   reachable via a menu, costs readable before commit, one Commit in a fixed
   place, no permanent teaching text, no mechanics changes)?
4. Score each concept /10 overall, rank A, C, E, and give a numbered
   blocking fix list per concept (only what keeps it from meeting Alex's ask
   or the Must-hold list, plus visual defects). Mark everything else
   non-blocking.

## Answer format

- First line: `VERDICT: GOOD TO GO` or `VERDICT: CHANGES NEEDED`.
- Table: concept, art+empty %, things to read on home, simpler (yes/partly/no), score /10.
- Ranking with one line each.
- Per concept: blocking fixes (view + location + fix).
- At most 3 non-blocking notes. Disk report.

Write r2s-<your name>.md in research/council/concepts/ and reply with it.

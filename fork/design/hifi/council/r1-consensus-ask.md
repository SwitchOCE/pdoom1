# Council round 1: settle one list

You are one of three members (opus, sol, neon). All three answers for round 1
are in this folder, verbatim: r1-opus.md, r1-sol.md, r1-neon.md. Read the
other two members' answers in full.

Alex's request (verbatim), to keep scope tight:

> "I just want to be able to show pip like a full artifact something that he
> can look at that shows some of the states for these UIs. Can we take them to
> more fully fleshed out, higher fidelity stuff?"

This is a showcase of fidelity and states. Redesign, new features and
mechanics are out of scope: mark anything like that non-blocking. One fix
round follows this; prefer items a designer can fix in that round.

## Factual context from the orchestrator (checked in the code; labelled as mine)

1. **Standard Hiring's hour (Sol's cross-concept item).** Confirmed in the
   code: godot/scripts/ui/event_dialog.gd (~lines 100-112) folds the
   window's Attention price into any handled option that does not declare
   its own `attention` cost; the window's free option (Decline) shows none.
   So the game shows Standard Hiring as $25,000 + 1 Attention. run-state.md
   (written by the orchestrator) was wrong to say it has no hour cost.
2. **NEW chips on Safety Audit / Strategic (state 2).** run-state.md said
   "New this month: Safety Audit and Strategic are unlocked"; that was the
   orchestrator's reading of the month-5 screenshot (which shows the
   "STRATEGIC MOVES UNLOCKED" popup) and the round-1 brief. The data gates
   are turn_min 5 / 10 in workdays (+ reputation_min 30 for Strategic), as
   G and Sol say. The run-state claim is unsupported by the code.
3. **720p text size (Sol's per-concept item 1).** godot/project.godot sets
   stretch mode canvas_items, aspect expand: the game itself scales its
   1920x1080 canvas uniformly, so a 16px label is about 10.7px at 1280x720
   in today's game. The designer brief told designers to scale the stage
   uniformly "the way the game does". Whether the 16px floor applies at 720p
   is for you to settle.
4. **Showcase page items (index.html)** are the orchestrator's to fix
   (E's caption, lightbox fit, keyboard focus, link labels, the report.md
   link, which ships at the end). They need no vote unless you disagree.

## What to do

For every blocking item raised by another member: agree, disagree, or agree
with a different fix, with evidence. Then end with your proposed joint list:
the blocking items per concept (A, C, E, G, showcase) that you think all
three should accept, and any item you think should drop to non-blocking.
Keep your scores or revise them (say which).

Write to fork/design/hifi/council/r1-consensus-<your name>.md and reply with
the same text. Read-only otherwise.

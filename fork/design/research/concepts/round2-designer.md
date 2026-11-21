# Round 2 designer brief: simplify (concepts A, C, E)

Alex has seen your concept (with the other two shortlisted ones) and wants a
second round. Keep your concept's style, fiction and materials; rework the
layout and flow.

## Alex's words (verbatim)

> "I think all of the designs need vastly more negative space to show the art, and we have individual menu systems handle state. I feel like they're trying to cram far too much onto the screen. The buttons do need to serve as shortcuts, but there needs to be way more negative space. There needs to be way more, way less detail on one screen. This needs to be simple. It needs to make the goal of this UI is to make a complex game simpler, not overwhelm the player."

## What this means (the orchestrating session's reading -- a proposal; push back with reasons if your concept needs something different)

- The home screen shows the art: Pip's office (and the operator) is the largest thing on screen, not a strip behind panels.
- The home screen carries only what the player needs at a glance: the month, P(Doom), reputation, the Attention left, a short view of the month's plan, and Commit. Everything else (the full action list, costs and reasons, upgrades, staff, ledger, research quality, the full queue) lives in its own menu or place, opened by a clearly labelled shortcut button (and its key).
- Each menu owns its own state: the action menu shows costs and why something is blocked; the queue menu shows order and costs; and so on. The home screen does not repeat them.
- Fewer, larger elements; generous margins; no panel touching another panel unless they belong together.
- The must-hold list in research/concepts/brief.md still applies, read against the whole flow rather than one screen: every action reachable (now via a menu), costs readable before commit, one Commit in a fixed place, no permanent teaching text, no mechanics changes. The game facts the council settled last round still hold: research/council/concepts/r1-agreed.md ("Shared game facts").

## Deliverables (in your own folder; same rules as before)

Your round-1 files are copied to <your folder>/r1/ for before/after; leave that folder alone.

1. concept.html with these views at 1920x1080 (month 5, November 2017 state from brief.md unless noted):
   - `?view=home` -- the month-5 home screen.
   - `?view=actions` -- the action menu open (all 17 top-level actions reachable, costs and blockers readable).
   - `?view=plan` -- the month's plan/queue menu open (order, costs, Attention).
   - at least one other menu or place a player opens to plan month 5 (your choice, e.g. a door opened from the action menu, staff, upgrades, ledger) as `?view=<name>`.
   - `?view=home-m1` (month 1 home) and `?view=watch` are welcome but optional.
2. Renders of every view: `home.png`, `actions.png`, `plan.png`, `<name>.png` (and `home-m1.png`, `watch.png` if made). Old m1/m5/door/place2/watch renders at the folder top can be replaced or removed; the r1/ copies stay.
3. notes.md, rewritten for round 2 (under 350 words): the flow in two sentences, the menus and how the player opens and closes each (button + key), **a count of the separate elements on the home screen** (list them), a rough share of the home screen that is art or empty space, what you kept from round 1, and the weakest point.

Finish with the visual quality pass from brief.md on every new render (alignment, icon match, 16px/14px floors, overlap, overflow, clipping, spacing, dead space vs. intended negative space, near-black backgrounds), list in notes.md what you checked, and a disk report (what you wrote inside and outside your folder, sizes, what can be deleted). Do the work yourself; start no subagents; pdoom1 stays read-only.

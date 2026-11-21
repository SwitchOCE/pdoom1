# Designer brief: concept G, the existing UI modernised

You are a new designer joining a design round already in progress. Read
C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/brief.md first:
it is the base brief (game, states to draw, Must-hold list, Pip's intent and
assets, visual quality pass). Your letter is G and your folder is
C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/G/ (write only
there; C:/Users/keech/Documents/pdoom1 is read-only).

## Alex's words (verbatim)

> "Have an agent work on modernizing the existing UIs spirit without overhauling it too drastically and add that into the process"

> "I think all of the designs need vastly more negative space to show the art, and we have individual menu systems handle state. I feel like they're trying to cram far too much onto the screen. The buttons do need to serve as shortcuts, but there needs to be way more negative space. There needs to be way more, way less detail on one screen. This needs to be simple. It needs to make the goal of this UI is to make a complex game simpler, not overwhelm the player."

## Your assignment (the orchestrating session's proposal; adjust with reasons)

**G. The Existing UI, Modernised.** Three other concepts are diegetic
redesigns; yours is the opposite bet: today's game, recognisable at once,
made cleaner.

- Start from today's game, not a blank page: screenshots main.png (month 1),
  m5_plan_queued.png (month 5), m1_event1.png (WATCH), and Pip's hidden
  "proposed" layout prop_m4_plan_queued.png (and the other prop_*.png), all in
  C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/1475796a-3fb6-4331-a9c6-354740c87b80/scratchpad/shots/ ;
  and the scene C:/Users/keech/Documents/pdoom1/godot/scenes/main.tscn
  (with docs/MAIN_UI_SEAM_MAP.md for main_ui.gd).
- Keep its spirit and broad layout: the office backdrop, the top resource
  bar, the `## PLAN` terminal banner register, the icon action hand, the doom
  instrument, the action queue, the PLAN/WATCH switch, the bottom command
  bar. A player of today's build should recognise it at once.
- Modernise it:
  - the critique's findings in C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/critique.md (names on tiles, one commit, upgrades out of the main area, the month not "Turn N", no permanent teaching lines, Attention split shown once);
  - Pip's play notes (`git -C C:/Users/keech/Documents/pdoom1 show HEAD:docs/game-design/UI_PASS_NOTES_2026-07-20.md`: left-bound buttons, ABBBCCC menus opening out from the clicked button, coloured zones, no default black);
  - the 16px/14px type floors, consistent alignment and icons (omit an icon rather than use a wrong one);
  - Alex's Round 2 steer above: more negative space so the office art shows, less on one screen, menus that hold their own state, buttons as shortcuts.
- Aim for something a Godot build could reach in small steps from today's
  main.tscn; in notes.md say which existing nodes each change touches.
- No mechanics changes; the game facts the council settled are in
  C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r1-agreed.md ("Shared game facts") -- read them.
- Do not look at the other concepts' folders (A-F); variety matters.

## Deliverables (in G/)

1. concept.html at 1920x1080 with views: `?view=home-m1` (month 1),
   `?view=home` (month 5), `?view=actions` (action menu open; all 17
   month-5 actions reachable with costs and blockers), `?view=plan` (the
   month's plan/queue with order, costs, Attention), and optionally
   `?view=watch` and one more menu (e.g. a door opened, upgrades).
2. Renders of every view (home-m1.png, home.png, actions.png, plan.png, ...)
   with headless Edge as brief.md describes.
3. Before/after: also save `before-m5.png`, a copy of today's
   m5_plan_queued.png, so reviewers can compare.
4. notes.md (under 350 words): the concept in two sentences; what you kept
   and what you changed from today's UI; the menus and how each opens and
   closes (button + key); a count of the separate elements on the home
   screen (list them) and a rough share of the screen that is art or empty
   space; the Godot nodes each change touches; the weakest point; and what
   you checked in the visual quality pass.

Finish with the visual quality pass from brief.md on every render and a disk
report (what you wrote inside and outside G/, sizes, what can be deleted).
Do the work yourself; start no subagents.

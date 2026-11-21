# Design brief: one PLAN-screen concept for P(Doom)1 (you are one of six designers)

You make ONE concept, in the style and layout assigned to you at the end of your task message. Five other designers each make a different one; a council will compare all six and Alex (the owner) picks. Variety is the point: commit fully to your assigned style. Do not drift toward a generic dashboard.

Write only inside your own folder: C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/<your-letter>/ . Do not edit anything in C:/Users/keech/Documents/pdoom1 (read-only) or in other folders.

## Alex's words (quoted)

> "I want you to find clever diegetic designs. Obviously, every diegetic design is going to be different because of how delicate and custom they need to be to their topic. But if you look at a game like Papers Please or a game where you play basically driving a CRT monitor and you're on Windows 98 ... finding a way to blend flavor together and have it still feel good? Clever diegetic UI design is what we're we need to find a way of striking. The concept art Pip has in the background is not perfect, right? But the feel of being in an office with a bunch of computers with Doom approaching, right? Is something that we need to try and capture"

> "all of the flavor from the diegetic aspects are lost. Done in a smart way, the diegetic aspect could be recaptured. It may need to be a longer process that's, you know, with more screens and more flows rather than one control board. You have different aspects that you go to, and you know, parts of the thing change."

> On the last mock-up: "the icons no longer match the buttons ... the layout on the icons is very inconsistent. Some are centralized and some are left-aligned ... Font sizing and stuff, there's stuff overlaying specific elements and overflowing out of areas of the screen."

## The game

P(Doom)1, Pip Foweraker's game: you run an AI-safety lab; one turn = one month. PLAN: spend the founder's monthly Attention (20 hours: 12 planning, 8 operating; operating work may spill into planning hours, never the reverse; a separate untyped reserve can be set aside) on actions, buy upgrades, then Commit the month. WATCH: the month plays out day by day; events interrupt with choices; a feed scrolls; a month review closes it. Readouts: money, compute, research, papers, reputation (lose at 0), P(Doom) % (only rises; lose at 100%; you cannot win, only buy time), staff. When you commit, unspent hours are held for events automatically.

Today's 15 top-level actions in month 1 (keep every one reachable; do not hide or merge any): Fundraising (door, 4 choices), Hire Staff (door, 7 roles, 1 planning hr each), Advertise a Role (shown as coming soon), Work Your Connections (2 hr, 6 reputation), Onboard New Hires (unavailable: nobody hired), Safety Research (1 planning hr, 10 research; unaffordable at research 0), Capability Research (same), Publish Safety Paper (1 planning hr, 20 research), Travel & Conferences (door, 4), Purchase Compute ($50,000, no hours), Operations (door, 3), Office (door, 4), Publicity (door, 5), Financing (door, 7), Scouting (door, 3: Read the Literature, Go to Meetups, Post Online). Month 5 adds Safety Audit (2 operating hr, $40,000) and Strategic (door, 4). Upgrades (7, $0-$800,000), Research Quality (Rushed/Standard/Thorough), Employees, Liability Ledger and a Player Guide are also reachable.

States to draw:
- Month 1 (July 2017): $245,000, compute 100, research 0, papers 0, reputation 50, P(Doom) 20.0%, nothing queued, no staff.
- Month 5 (November 2017): $140,000, compute 65, research -12 (flag it), papers 0, reputation 32, P(Doom) 40.2% rising, 1 hire, a queue (e.g. Go to Meetups 1 op hr $300; Hire: Safety Researcher 1 plan hr $60,000; Read the Literature 1 plan hr; plus more) with planning hours used up and operating hours left, so a planning-hour action is blocked ("no planning hours left") while operating actions stay available; two items already under way with dates (e.g. candidate interview lands mid-Dec 2017; paper submission decision ~Jan 2018).

## Must hold (the bar, in short)

1. Every action shows its name and cost; doors are marked as doors; unavailable ones say why; never hover-only.
2. Attention shown once, planning and operating distinct, with the reserve.
3. The month's plan is the main thing on the PLAN screen; work under way shows dates (never "Turn N", which counts workdays).
4. One Commit control, always in the same place.
5. P(Doom) and reputation readable at a glance, with no doom deltas per action (ADR-0015) and no information the player hasn't earned (no forecasts, no hidden causes).
6. No permanent teaching sentences on the main screen (a tutorial will come later). Short labels are fine.
7. No mechanics changes: everything you draw is a view of existing state.

## Pip's intent and assets (use them)

- `git -C C:/Users/keech/Documents/pdoom1 show HEAD:docs/game-design/BUILD_BRIEF_PLAN_WATCH_UI.md` -- "deal the cards from the hand you've got"; the silhouetted operator at the desk is "the CORE UI image -- never lose it"; terminal/mainframe pastiche, lightly modernised (amber/green CRT, scanlines, boxes and rules); office floor with staff; gantt-style duration bars ("exceptional").
- C:/Users/keech/Documents/pdoom1/docs/game-design/WORKSHOP_2_BACKLOG.md lines 685-780 (office as phase visual: garage -> warehouse -> startup office -> gilded office -> villain lair; earned instrumentation; things arriving "across your desk on slips of paper / as inbox items").
- `git -C C:/Users/keech/Documents/pdoom1 show HEAD:docs/game-design/UI_PASS_NOTES_2026-07-20.md` -- Pip's play notes: ABBBCCC menus that open out from the clicked button, left-bound buttons, coloured zones, no default black backgrounds, no permanent screen-purpose text.
- Palette: C:/Users/keech/Documents/pdoom1/docs/art/PALETTE_AND_DOOM_INTENSITY.md and godot/UI_STYLE_GUIDE.md (warm grime and aubergine grounds, amber resting accent, doom as a colour layer; 16px floor for anything read to operate a control, 14px for secondary prose).
- Art (copy what you use into your folder): godot/assets/images/backgrounds/ (office_wide_dawn.webp, office_wide_day.webp, office_lab_aisle.webp, office_mezzanine.webp, office_scene.png, records/), godot/assets/images/office_cat.png, godot/assets/cats/, godot/assets/office_floor/, godot/assets/portraits/, godot/assets/images/events/, godot/assets/textures/ (e.g. amber scanlines, aged graph paper, painted metal), action icons in godot/assets/icons/ (mapping: godot/data/icon_mapping.json -- note some icons are shared or mismatched; if an icon does not fit its action, use none rather than a wrong one).
- Diegetic UI research (games that blend flavour and usability, with techniques and pitfalls): C:/Users/keech/Documents/pdoom1-lean-setup/research/diegetic/findings.md and shots/. Read it.
- The previous, rejected mock-up (do not copy it): research/ui-pass/mockups/view-m5.png.

## Deliverables (in your folder)

1. `concept.html`, self-contained except for copied assets and Google Fonts, rendering at exactly 1920x1080 with `?view=m1` and `?view=m5`. A third view `?view=watch` showing how PLAN hands over to WATCH (one event arriving) is welcome if your concept has more than one screen or place; if your concept has several places (rooms, apps, stations), show at least one other place as `?view=place2`.
2. Renders: `m1.png`, `m5.png` (and `watch.png` / `place2.png` if made). Render with headless Edge, for example (Git Bash):
   `"/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" --headless=new --disable-gpu --hide-scrollbars --window-size=1920,1080 --virtual-time-budget=4000 --user-data-dir="$LOCALAPPDATA/Temp/edge-<letter>" --screenshot="<windows path to png>" "file:///<windows path to concept.html>?view=m1"`
   If a render comes out blank, check the script with `node --check`.
3. `notes.md` (under 300 words): the concept in two sentences, the places/screens and how the player moves between them, which games it borrows from, what it does especially well, its weakest point.

## Visual quality pass (required before you finish)

Open each render and fix every one of these before you report: consistent alignment within each group (no mix of centred and left-aligned siblings); every icon matches its action or is omitted; no text below 14px, and nothing a player operates below 16px; no text overlapping anything; nothing overflowing or clipped; consistent spacing; no large dead areas without purpose; no near-black flat backgrounds. Watch for CSS class-name collisions between components. List in notes.md what you checked and anything you could not fix.

Finish with a disk report: what you wrote, total size, what can be deleted.

# Critique: PLAN screen, month 1 and month 5 (2026-11-21)

Method: the fork's game-ui skill. Screenshots at 1920x1080 from the running game (lean@e1c58e55), taken with a throwaway script in the scratchpad:
- month 1, empty queue: scratchpad/shots/main.png
- month 5 (Nov 2017), after four scripted months: scratchpad/shots/m5_plan_queued.png
- WATCH with an event window: scratchpad/shots/m1_event1.png
(scratchpad = C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/1475796a-3fb6-4331-a9c6-354740c87b80/scratchpad)

Builds on Pip's own teardown, `docs/design/FRESH_EYES_TEARDOWN_2026-08-06.md` (hidden by the sparse checkout; read with `git show`). Its Part C lists what must survive a redesign; noted below.

Not scored against the bar yet: the bar is still being agreed.

## Decisions this phase (PLAN)

1. Which actions to queue this month, and in what order (15 tiles; 9 of them open submenus).
2. Which upgrades to buy.
3. Research Quality (Rushed / Standard / Thorough). Pip ruled it moves off the PLAN screen to project level (#1090); not built yet.
4. How much Attention to hold back for events.
5. Commit the month.

What the player must know for them: what each action is and does (in words), its cost in Attention (planning or operating hours) and money, whether it can be afforded and why not, what is already queued, Attention left by hour type, money and the resources the actions touch, and the state of the two lose conditions (doom, reputation).

## Every element, sorted into tiers (proposal)

| Element today | Tier proposed | Note |
|---|---|---|
| Month and date | Glance | Today shows "Turn 87", a workday count. Show the month. |
| Money, compute, research, reputation | Glance | Reputation is a lose condition. |
| Papers | Reach | Not needed for any PLAN decision on most months. |
| Doom % and gauge | Glance | Lose condition. Today a small arc in a corner. |
| Attention left, split into planning and operating hours | Glance | Today one pip row with no split; actions are refused on hour type with Attention showing (Pip teardown finding 5). |
| Action tiles (15) | Glance, with name, cost and affordable state on each | Today unlabelled icons with digit overlays; costs only on hover (Pip finding 6). |
| The queue, in order, with costs | Glance | Today bottom-right, small. It is the plan itself. |
| Commit | Glance, one button | Today two buttons ("COMMIT THE MONTH >" and "Plan (Enter)") plus "Do Nothing" (Pip finding 3). |
| Reserve Attention | Glance, next to the queue | Today a small text button bottom-left. |
| Action detail (what it does, why it can't be afforded) | Reach, by selection or focus | Today a hover-only info bar. A tile click queues, so detail needs focus, a panel or an info control. |
| Upgrades (7 rows) | Reach: one "Upgrades" door | Today the largest block on the screen. |
| Research Quality | Reach, or off the screen per #1090 | Open question for Alex. |
| Employees, staff roster | Reach; roster Not yet while 0 staff | |
| Liability Ledger | Reach; Not yet while clean | |
| Doom trend sparkline | Glance once it has data | |
| "Doom this turn: Panic +0.5, Momentum +0.3, Baseline +0.1" | Hidden by design? Flag | Per-stream doom numbers, shown free. ADR-0001/0004 say finer doom detail is earned. Pip's call; not changed by the UI pass. |
| Mode banner sentence "lay out the month, then COMMIT THE MONTH >" | Short mode label on the main screen; the sentence moves to the tutorial | Pip's teardown (Part C 1) calls this sentence what makes the loop self-teaching. Alex's rule says teaching text belongs to the tutorial. Design call for Alex. |
| Getting-started hint, "Buy time -- survival is the score / Lose: P(Doom) = 100%", phase label "SELECT ACTIONS - click actions or press 1-9", info-bar prompt | Tutorial (temporary) | Teaching text on the main screen. The lose line also omits reputation 0. |
| Title "P(Doom)" in the top bar, "Command" label, DEV BUILD badge | Remove / dev only | |
| Send Feedback (N) | Keep, quiet | |

Glance tier: about 55 items today on month 1 (about 60 mid-run with the doom breakdown). The proposal above has about 15 kinds of glance item: month, 4 resources, doom, Attention split, the tiles (one group), queue, reserve, commit, mode label.

## Findings

| # | Finding | Severity | Fix |
|---|---|---|---|
| 1 | The 15 verbs are unlabelled icons; a new player cannot say what they can do (Pip finding 6, Part D 4). | Blocks play | Name, cost and affordable state on every tile. |
| 2 | Affordability is hover-only and ignores the planning/operating split, so actions are refused while Attention shows free (Pip finding 5). | Blocks play | Split the Attention readout; mark unaffordable tiles with the reason in reach. |
| 3 | Upgrades take the biggest area while the plan (the queue) is small and the middle is empty (#1043). | Slows play | Upgrades behind one door; give the middle to the plan. |
| 4 | Two commit buttons and "Do Nothing" do overlapping things with different side effects (Pip finding 3). | Slows play | One Commit; committing an empty queue reserves all, as today. |
| 5 | Errors print raw ids: "Cannot afford action: safety_research" (month 5), and some rejections go to a feed hidden in PLAN (Pip finding 7). | Bug | Use the action's name; show rejections in PLAN. |
| 6 | Popups stack: "Strategic moves unlocked" opened over an open Scouting submenu (month 5). | Bug / slows play | Queue milestone popups until submenus close. |
| 7 | The Scouting submenu shows missing-texture placeholder icons (month 5). | Bug | Assign the icons. |
| 8 | Research shows -12 with no warning (month 5); negative resources need an alert (Pip backlog). | Slows play | Mark negative values. |
| 9 | "Turn 87" counts workdays; the player thinks in months. | Display bug | Show the month. |
| 10 | The lose line omits reputation 0. | Display bug | Name both lose conditions, or neither on the main screen. |
| 11 | Per-stream doom numbers are shown free, against ADR-0001/0004. | Flag for Pip | Not changed in this pass. |

Not judged from stills: motion, hover jitter (#577), the feel of WATCH playback, other resolutions.

What works and must survive (Pip's teardown Part C): the PLAN/WATCH mode idea and a mode label; "You can't win. You can only buy time." as the game's thesis; cost honesty at the point of choice (costs on submenu buttons, "(Free)" marked, event dialogs that say why a choice failed, Q/W/E choice keys); the month review's movement-not-levels discipline; feed filters.

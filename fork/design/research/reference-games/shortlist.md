# Reference games for the P(Doom)1 UI redesign ("the bar")

Fetched 2026-11-21. Screenshots in `shots/` (Steam store screenshots, 1920x1080
or the largest Steam serves).

## How the reception numbers were taken

- **Steam**: the "All Reviews" row of each game's English Steam store page,
  `https://store.steampowered.com/app/<appid>/`. Steam now shows English-language
  reviews in that row, so the counts are English reviews, not all languages.
  Format: percent positive of N reviews.
- **MC**: Metacritic PC critic score as returned by Steam's own
  `store.steampowered.com/api/appdetails?appids=<appid>` (links to
  `metacritic.com/game/pc/<slug>`). A dash means Steam lists no Metacritic score.
- Selection follows Alex's rule: look for games people like, not games praised
  for UI, then judge the UI from screenshots.

Fit flags (P(Doom)1 structure):
B = budgeted period planning, W = plan-then-watch, T = rising global threat meter,
E = interrupting events with choices, S = staff roster, R = many resources,
X = repeated runs.

## 1. Longlist

| Game (Steam appid) | Steam | MC | Decision structure, one line | Fit | Verdict |
|---|---|---|---|---|---|
| XCOM 2 (268500) | 85% of 45,512 | 88 | On the geoscape pick a scan/contact/research with limited supplies, intel and staff; time runs until a mission or event stops it; Avatar Project bar fills toward loss. | B W T E S R | **Shortlist** |
| Frostpunk (323190) | 92% of 39,412 | 84 | Assign workers, build, sign laws; days run at 1x-3x while the temperature drops; events demand a choice; Discontent/Hope bars. | B W T E S R X | **Shortlist** |
| Against the Storm (1336490) | 95% of 19,338 | 91 | Build a settlement while Reputation races Queen's Impatience on one bar; glade events with timers; storm-season clock; roguelite runs. | W T E S R X | **Shortlist** |
| Into the Breach (590380) | 93% of 12,759 | 90 | Enemies telegraph attacks; spend each mech's one move; End Turn; turn resolves in a shown order; Power Grid bar is the loss meter; runs. | B W T S X | **Shortlist** |
| FTL: Faster Than Light (212680) | 95% of 47,173 | 84 | Spend reactor power bars across systems and scrap on upgrades; jump; text events with numbered choices; rebel fleet advances; runs. | B W T E S R X | **Shortlist** |
| Football Manager 2024 (2252570) | 92% of 11,705 | - (PC Gamer 83) | Set squad, tactics and training, answer the inbox, press Continue; watch the match at chosen speed; very large staff and data. | B W E S R | **Shortlist** (complex but loved) |
| Suzerain (1207650) | 93% of 7,313 | 81 | Turn-based presidency told through dialogue; each scene ends in numbered choices; occasional budget allocation; very small HUD. | B E S R | **Shortlist** (events) |
| Terra Invicta (1176470) | 82% of 6,698 | 83 | Assign councilor missions each mission phase, then time runs at speeds until the next phase; alien threat; dozens of resources. | B W T E S R | **Contrast**: loved by its audience, widely called hard to read (sources below) |
| Democracy 4 (1410710) | 83% of 4,008 | - | Spend political capital on policies each turn; turn resolves; dilemmas interrupt; every simulated variable on one web screen. | B W E S R X | **Contrast**: dense screen; useful for "what if everything is visible" |
| This War of Mine (282070) | 92% of 23,154 | 83 | By day assign survivors to craft, rest, guard; by night send one to scavenge; morning report; events; roster. | B W E S R X | Backup (plan-then-watch, roster) |
| Darkest Dungeon (262060) | 90% of 57,489 | 84 | Between expeditions spend gold in the hamlet on heroes, stress relief, upgrades; roster of expendable staff. | B S R X | Reject: hub screen, no watch phase; roster idea covered by FTL/ItB |
| Plague Inc: Evolved (246620) | 93% of 27,395 | - | Spend DNA points on traits; watch the world infect; the cure % rises against you; news ticker. | B W T R X | Reject: events are a ticker, not choices; threat-meter idea covered by XCOM 2 |
| Rebel Inc: Escalation (1088790) | 82% of 2,739 | - | Spend budget on civil/military initiatives per region; insurgency grows; stability meter; events. | B W T E R X | Backup (very close, smaller and less loved) |
| Game Dev Tycoon (239820) | 94% of 22,262 | 68 | Pick topic/genre, set focus sliders per phase, watch development, get reviews; staff and research points. | B W S R X | Reject: weak critic score; note its sliders as an analog for the research-quality slider |
| Papers, Please (239030) | 97% of 39,897 | 85 | Inspect papers through the day; end-of-day ledger spends wages on rent, food, heat. | B E X | Reject for PLAN; its end-of-day ledger is a reference for the month review |
| Slay the Spire (646570) | 97% of 77,570 | 89 | Spend 3 energy per turn on cards against shown enemy intents; End Turn; runs. | B W X | Reject: no global threat, resources or staff; Into the Breach covers the turn budget |
| Crusader Kings III (1158310) | 90% of 50,717 | 91 | Real-time pausable dynasty play with constant event choices and a council. | E S R | Reject: no budgeted period, no single threat |
| Motorsport Manager (415200) | 90% of 5,210 | 81 | Set car, drivers and strategy, then watch the race at speeds with pit decisions. | B W E S R | Backup to FM (same frame, smaller) |
| This Is the Police (443810) | 73% of 2,903 | - | Pick the day's shift roster, then watch the day as calls interrupt with dispatch choices. | B W E S R | Reject: reception (Mixed recent / 73%) |
| Reigns (474750) | 84% of 2,640 | 77 | Swipe left/right on each request; four meters must stay off both ends. | T E X | Reject: no budget; note the four-meter strip |

Also checked and dropped: Frostpunk 2 (1601580, 77% of 9,854, MC 85: weaker
player reception than the first game), XCOM: Enemy Unknown (200510, 92% of
25,180, MC 89: panic per country, XCOM 2's single bar is the cleaner reference),
Two Point Hospital (535930, 93% of 12,764, MC 83: real-time, no plan/watch split),
Cultist Simulator (718670, 78% of 5,357, MC 71: deliberately opaque), Mini Metro
(287980, 95% of 7,136, MC 77: too few resources), Loop Hero (1282730, 91% of
16,147, MC 82), Shadow Empire (1154840, 82% of 1,469, MC 78: very complex,
small), Crisis in the Kremlin (599750, 83% of 1,376), RimWorld (294100, MC 87;
the Steam figure did not load: real-time, no plan/watch split), Universal
Paperclips (browser game, no store score; a text incremental with no period plan).

## 2. Shortlist (7) and why

Each covers a part of P(Doom)1's screen. Together they cover all seven fit flags.

1. **XCOM 2**: 85% of 45,512 (Steam), MC 88. Closest whole-loop match: a global
   doom bar you cannot reverse for long, a resource strip, staff counts, time
   that runs until an event stops it. Reference for the **threat meter** and the
   **resource bar**.
2. **Frostpunk**: 92% of 39,412, MC 84. Managing a growing city under a rising
   global threat (the cold), with full-screen event choices and labour
   allocation. Reference for **threat plus clock** and **event interruptions**.
3. **Against the Storm**: 95% of 19,338, MC 91. Best-loved game on the list;
   win and lose are one bar (Reputation vs Impatience); events open in a side
   panel without stopping the view; repeated runs. Reference for **one bar for
   win/lose** and **events in a side panel**.
4. **Into the Breach**: 93% of 12,759, MC 90. The clearest plan-then-resolve
   turn: a few actions, a big End Turn, the loss meter at the top-left.
   Reference for **planning with a budget** and **the commit button**. Caveat:
   it shows exact outcomes; P(Doom)1 hides doom deltas on purpose (ADR-0015,
   ADR-0001), so copy its layout, not its disclosure.
5. **FTL: Faster Than Light**: 95% of 47,173, MC 84. A visible pool of power
   bars spent onto systems is the nearest thing to spending Attention hours;
   crew list; text events with numbered choices that say why an option is
   unlocked. Reference for **budget as visible units** and **event choices**.
6. **Football Manager 2024**: 92% of 11,705, PC Gamer 83. The "complex but
   loved" pick: dozens of screens and hundreds of numbers held in a fixed frame
   (navigation left, date and Continue top-right). Plan the week, Continue,
   watch the match at speed. Reference for **a fixed frame around complexity**
   and **plan-then-watch**.
7. **Suzerain**: 93% of 7,313, MC 81. Decisions arrive as interruptions in a
   centre column with numbered choices and almost no HUD. Reference for **event
   interruptions** and how little HUD a decision screen needs.

**Contrast (well loved, widely called hard to read): Terra Invicta** (82% of
6,698, MC 83). Turn Based Lovers: "Terra Invicta's UI is less a tool and more a
stress test." and "Information exists, but it's buried, minimized, or whispered
when it should be screaming." (https://turnbasedlovers.com/review/terra-invicta-1-0-impressions/ ;
the same page says 1.0 eased this). The Game Slayer also names "interface
bloat" (https://thegameslayer.com/reviews/terra-invicta-review/). Structurally it
is close to P(Doom)1 (assign missions per phase, then watch), which makes it the
right warning.

Second contrast, **Democracy 4** (83% of 4,008): loved by its audience, puts
the whole simulation on one screen; useful to show what "everything visible"
costs.

## 3. Screen notes (from the images)

### XCOM 2: `shots/xcom2-1.jpg` (geoscape), `shots/xcom2-2.jpg` (research pick)
- **At a glance**: about 6 regions. Objectives list (3 lines) top-left; Avatar
  Project bar top-centre; resource strip top-right; map with about 6 labelled
  points, each with its own action ("Make Contact", "Supply Drop", "Black
  Market"); Resistance HQ dock bottom-centre (Scanning Sites, Missions); clock
  bottom-right.
- **Primary decision**: on the map. Pick what to scan or contact, then time
  runs.
- **Budget**: one strip top-right, 9 items, icon-free short labels over numbers:
  POWER 14/15, CONTACTS 2/3, ENG 1, SCI 2, ALLOYS 58, ELERIUM 29, INTEL 23,
  SUPPLIES 186, INCOME (+155). Costs sit on each map label.
- **Threat and clock**: Avatar Project is a row of red pip slots top-centre with
  "Dark Events" under it; no number, no per-action delta. Clock bottom-right
  ("1:50 AM, April 14, 2035") with the next scheduled event next to it
  ("SUPPLY DROP 14 days").
- **Events**: time stops and a briefing card opens over the map (left card with
  objective text, Launch/Ignore on the right; seen in the store set).
- **Behind a click**: the base rooms. xcom2-2 shows Choose Research: a 2-item
  list left, detail centre with cost and "EST. TIME 4 days", current research
  progress bottom-right. The same resource strip stays top-right on this screen.

### Frostpunk: `shots/frostpunk-1.jpg` (main), `-2.jpg` (building/workers), `-3.jpg` (event)
- **At a glance**: about 5 HUD groups; the city fills the rest. Top bar:
  resources (coal 10113, wood 3000 FULL, steel 2100 FULL, cores 4, food 339,
  rations 924), speed controls (pause, 1x, 2x, 3x), "RESTING TIME 06:07".
- **Threat and clock**: a large temperature dial top-centre (-110C) and a
  forecast strip to its right (DAY 38 then the coming days with cold markers).
  The threat is the most prominent thing on screen.
- **Mood meters**: Discontent (red) and Hope (blue) stacked bottom-centre
  between four round menu buttons (tech, build, laws, list). Sick/hungry counts
  float above them as red badges.
- **Goals**: two objective cards bottom-left ("Convince people to trust you
  again: raise hope to 15%", "Survive the storm").
- **Budget**: people are the budget: "47/568" bottom-right (free workers /
  population). frostpunk-2: the building panel opens on the right with rows for
  workers, engineers, children, each with -1 / +1 / MAX and "10/10"; the HUD
  stays visible.
- **Events**: frostpunk-3 is full-screen: a category ("Protest"), a headline
  ("Facing starvation"), 3 lines of text, 3 stacked choices. One choice makes a
  promise with a deadline.

### Against the Storm: `shots/against-the-storm-1.jpg` (main), `-2.jpg` (event panel)
- **At a glance**: about 6 groups. Top-centre: 6 goods with counts (582, 215,
  369, 713, 468, 350), a clock dial for the season with pause, play, x1.5, x2,
  x3, the year (III), and hostility level plus active effects to its right.
  Left: 3 species portraits with population/worker/homeless counts and resolve
  ("30 > 40"). Bottom-centre: about 12 round build-category buttons.
- **Threat**: one segmented bar along the bottom edge: Reputation fills blue
  from the left, Queen's Impatience fills red toward a skull on the right. Win
  and lose read off the same bar.
- **Events**: against-the-storm-2. The event opens as a right side panel and
  the settlement stays visible and running: title and one line of flavour;
  THREATS with a countdown (00:13) and the icon of what happens; REQUIREMENTS
  (goods 30, working effects +200 / -20), TIME 04:30 with a progress bar;
  REWARDS as two options (Keep goods / Send to the Citadel); one button
  (INVESTIGATE). An Alerts list sits mid-left ("Herb Garden has no farm fields
  nearby").
- **Behind a click**: building details and recipes (right panel), the world map
  between settlements.

### Into the Breach: `shots/into-the-breach-1.jpg` (turn), `-2.jpg` (mission pick)
- **At a glance**: about 6 elements. Top-left: POWER GRID as 7 segments (4
  full) and GRID DEFENSE 19%; RESET TURN; a large END TURN with UNDO MOVE
  beside it. Left column: 3 pilot portraits with health pips. Bottom-left:
  selected mech and its weapon. Top-right: "Victory in 3 turns" and bonus
  objectives. Bottom-right: tile tooltip.
- **Primary decision**: on the board. Each mech has one move and one action;
  enemy attacks are shown as tinted tiles numbered 1 to 5 in attack order.
- **Budget**: the actions themselves (three mechs), shown as the portraits;
  spent units grey out.
- **Commit**: END TURN is the largest button and never moves.
- **Between missions**: into-the-breach-2. A persistent top strip (stars,
  cores, POWER GRID, GRID DEFENSE, score) over an island map; a mission card
  with name, "Vek Threat Detected!", bonus objectives and a WARNING line, and a
  one-line advisor quote with portrait.

### FTL: `shots/ftl-1.jpg` (main), `-2.jpg` (event)
- **At a glance**: about 7 groups. Top-left: HULL as a long segmented bar,
  scrap 7, shield pips, fuel 16, missiles 8, drones 0, EVADE 25%, OXYGEN 74%.
  Left: 6 crew names with health bars. Top-centre: JUMP (FTL drive "READY!")
  and SHIP. Right: the enemy ship panel. Bottom: weapons and drones as cards,
  AUTOFIRE, subsystems.
- **Budget**: bottom-left, a vertical stack of unspent reactor bars; each
  system has its own short column of bars above its icon. Spending moves a bar
  from the stack to the system. You can read total, spent and free without a
  number.
- **Threat**: the rebel fleet's advance is on the sector map, one click away
  (JUMP), not on this screen.
- **Events**: ftl-2. A centred text box, numbered choices 1 to 4; the game says
  PAUSED ("Press SPACE to resume") and the HUD stays visible around it. Choices
  3 and 4 are blue and say why they are available ("(Eng. Crew)", "(Adv.
  Medbay)").
- **Behind a click**: upgrades (scrap costs per system bar), crew, equipment.

### Football Manager 2024: `shots/football-manager-2024-1.jpg` (tactics), `-2.jpg` (match)
- **At a glance**: many items (about 60 controls on the tactics shot), held in a
  fixed frame: navigation column left (20 entries: Home, Inbox, Squad, Tactics,
  Staff, Training, Finances, ...); top bar with screen title and the next fixture
  ("5th in English Premier Division - Next Match: ... (Tomorrow 20:00)"); date
  top-right ("Mon 09:00, 3 Jul 2023"); CONTINUE top-right, purple, same place on
  every screen.
- **Primary decision**: the content area changes per screen; the commit
  (CONTINUE) does not.
- **Budget**: finances and staff live behind the nav; the frame shows only date
  and next fixture.
- **Events**: arrive in the Inbox (nav item). From the game, not visible in
  these shots: Continue is held up by items that need a reply.
- **Watch phase**: football-manager-2024-2. Score and match clock top-left
  ("13:46, BRE 0-2 BHA"), a goal banner in the middle, a bottom strip with
  tactics/subs, mentality and each player's card with rating and condition.

### Suzerain: `shots/suzerain-1.jpg` (decision), `-2.jpg` (overview)
- **At a glance**: about 5 HUD items. Top-left: emblem, ECONOMY "UNSTABLE" as a
  word, two counters (8 and 0). Bottom-left: the player's portrait. Right edge:
  News count (0) and 4 round buttons (government, relations, codex, notes).
- **Primary decision**: centre column: dialogue, speaker portraits on its left
  edge, then 4 numbered choices.
- **Budget and threat**: shown as a state word ("UNSTABLE") rather than a
  number; detail behind a click.
- **Behind a click**: suzerain-2. An Overview panel on the right with tabs
  (Policies / Situations), a colour-coded list of active situations, and a
  description box under it; the map stays visible on the left.

### Contrast, Terra Invicta: `shots/terra-invicta-1.jpg`, `-2.jpg`
- **At a glance**: top strip of about 16 resource readouts, each a value plus a
  rate ("30.3K+81.4", "138.8+3.3", ...), then date, time, PAUSED and speed
  controls; a second row of 9 screen buttons and 6 faction icons; a nation
  panel with about 25 small numbers and red/green arrows; a councilor card with
  8 abbreviated stats (PER INV ESP CMD ADM SCI SEC LOY) and "Awaiting Next Mission
  Phase".
- **Threat**: no single meter on screen; the alien threat is spread over panels.
- **What goes wrong**: everything is visible at the same weight, so nothing is
  first. This is the failure the bar below guards against.

### Contrast, Democracy 4: `shots/democracy-4-1.jpg` (main), `-2.jpg` (policy dialog)
- Main: 4 money figures top-left (income, expenditure, deficit, debt), a turn
  progress bar with a clock icon, 11 category tabs; popularity list of about 20
  voter groups left; about 60 labelled icons joined by red and green lines.
  Hover shows a minister card ("Political capital: 1.2").
- Policy dialog: description, a slider with Cost and Income, effect bars per
  group, Apply / Cancel / Revert.

## 4. Draft bar for the redesigned PLAN screen

Each line is checkable from a screenshot or a short play session.

1. **The budget is visible units at the point of spending.** Without opening
   anything, the player can read Attention left, split into planning and
   operating hours, and each queued action visibly takes units from that pool.
   (FTL reactor stack moving onto systems; Into the Breach's three mechs that
   grey out once used; XCOM 2 ENG/SCI counts.)
2. **One commit button, largest on the screen, in a fixed place, with a key.**
   It never moves between PLAN states or submenus, and when commit is blocked
   it says why. (Into the Breach END TURN top-left; FM CONTINUE top-right on
   every screen; FTL JUMP.)
3. **P(Doom) is one meter in a fixed spot, visible on PLAN and WATCH, readable
   in under a second, with no printed delta.** It shows level, not per-action
   change (ADR-0015). (XCOM 2 Avatar Project pips top-centre; Against the Storm
   Impatience bar ending in a skull; Into the Breach Power Grid segments.)
4. **All global readouts sit in one strip at one edge, about 10 items or fewer,
   each a label plus a number, with detail in a tooltip.** No readout appears
   twice with different values. (XCOM 2 top-right strip of 9; Against the Storm
   6 goods; Frostpunk top bar. Terra Invicta's 16 value+rate readouts is the
   failure case.)
5. **The month and the next known event sit together.** PLAN shows which month
   it is and what is coming next and when. (XCOM 2 clock plus "SUPPLY DROP 14
   days"; Frostpunk DAY 38 plus temperature forecast; Against the Storm season
   dial.)
6. **The main view holds only what can be acted on this phase; detail opens in
   a side panel that keeps the budget, the meter and the commit button
   visible.** Opening Hire, Fundraise or Travel does not hide them. (Against the
   Storm and Frostpunk right-side panels over a live view; FM's fixed frame;
   Suzerain overview panel beside the map.)
7. **An event stops the clock, takes the centre, and offers numbered choices
   that show their cost in the same units as the resource strip; choices that
   need something the player has are marked with the reason.** Keys 1 to 4
   pick. (FTL numbered choices with "(Eng. Crew)"; Suzerain numbered choices;
   Against the Storm Requirements/Rewards panel; Frostpunk 3-button event.)
8. **Staff are a compact list at one edge: portrait or name plus one status
   line each; more detail is one click.** (FTL crew list with health bars;
   Into the Breach pilot column; Against the Storm species column with counts.)

Draft only: the numbers in lines 4 and 6 ("about 10", "this phase") should be
set against the current PLAN screen's own count before it is used as a pass/fail.

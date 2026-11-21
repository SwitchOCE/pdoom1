# Diegetic UI research for P(Doom)1

Date: 2026-11-21. Research only; nothing here changes the game. (Saved by the orchestrator from the research agent's reply; text unchanged.)

The brief, in the owner's words: "I want you to find clever diegetic designs. ... Papers Please or a game where you play basically driving a CRT monitor and you're on Windows 98 ... finding a way to blend flavor together and have it still feel good ... the feel of being in an office with a bunch of computers with Doom approaching, right? Is something that we need to try and capture".

How the numbers were taken: each Steam store page was loaded with `?l=english&cc=us` and the "English Reviews" row read off it (percent positive of N English reviews). Where the page shows no separate English row, the number is the all-languages "All Reviews" row and is marked `*`. Metacritic (MC) is the score Steam's own store API returns; `-` means Steam lists none. Source for every row is `https://store.steampowered.com/app/<id>/`.

---

## 1. Longlist (25)

| Game (Steam id) | Year | Steam English | MC | Diegetic conceit |
|---|---|---|---|---|
| Papers, Please (239030) | 2013 | 97% of 39,897 | 85 | Border booth desk: documents slide across it, stamps, rulebook, queue outside the window |
| Not Tonight (733790) | 2018 | 85% of 1,458 | 71 | Club bouncer's door: IDs, guest lists, a phone; Papers Please on a night out |
| Headliner: NoviNews (918820) | 2018 | 88% of 771 * | - | Editor's desk approving or spiking stories; the town outside visibly changes with your choices |
| Death and Taxes (1166290) | 2020 | 85% of 4,110 | - | Grim Reaper's office: case files on a desk, a smartphone news app, an office you decorate |
| Strange Horticulture (1574580) | 2022 | 95% of 10,139 | 83 | Plant-shop counter: plants on shelves, a reference book, a map, letters and visitors |
| Cultist Simulator (718670) | 2018 | 78% of 5,357 | 71 | Cards on a tabletop; "verbs" are slots with ring timers that run in real time |
| Return of the Obra Dinn (653530) | 2018 | 96% of 18,983 | 89 | An insurance logbook is the whole UI; it auto-confirms correct answers in threes |
| Hypnospace Outlaw (844590) | 2019 | 96% of 4,455 | 83 | A 1999 headset-OS and its internet; you moderate pages from inside the browser |
| The Operator (1771980) | 2024 | 89% of 3,733 | 78 | A 1990s federal agency desktop: windows, databases, email, a supervisor who messages you |
| Her Story (368370) | 2015 | 88% of 5,115 | 86 | An old police database on a CRT, with room lights reflected on the glass |
| Orwell: Keeping an Eye On You (491950) | 2016 | 90% of 4,883 | 77 | A state surveillance program: profile left, sources right, highlighted "datachunks" |
| Emily Is Away (417860) | 2015 | 87% of 22,864 | - | A Windows XP instant messenger; you type, but only pick from preset replies |
| Hacknet (365450) | 2015 | 94% of 7,711 | 82 | A hacker terminal wrapped in labelled GUI panes (RAM, display, terminal, netmap) with a trace countdown |
| Uplink (1510) | 2006 | 89% of 1,771 * | 75 | A hacker's gateway desktop with world map, email and trace bars |
| Pony Island (405640) | 2016 | 94% of 8,062 | 86 | A haunted arcade cabinet OS that glitches and breaks as you play |
| SHENZHEN I/O (504210) | 2016 | 95% of 2,263 | - | An engineer's workstation: inbox of assignments, CAD tool, solitaire, a printed datasheet binder |
| TIS-100 (370360) | 2015 | 97% of 2,589 | - | A corrupted 1970s-style computer you repair from a printed reference manual |
| Not For Broadcast (1147550) | 2022 | 94% of 5,336 | 82 | A TV vision-mixer desk: four feed monitors, audience meter, bleep button, ad tapes |
| Duskers (254320) | 2016 | 89% of 1,991 | 83 | Command-line drone control over grainy, degrading camera feeds |
| Stories Untold (558420) | 2017 | 85% of 3,326 | 81 | A physical 1980s micro and lab equipment on a desk; you type into the in-world screen |
| 911 Operator (503560) | 2017 | 87% of 5,506 | 68 | A dispatch console: city map, incoming calls, units to assign |
| Frostpunk (323190) | 2018 | 92% of 39,412 | 84 | Semi-diegetic: brass thermometer dial at top, frost creeping in from screen edges, the city itself as readout |
| XCOM 2 (268500) | 2016 | 85% of 45,511 | 88 | Avenger ship cut-away with staffed rooms; Geoscape globe; the Avatar Project "doom" bar that only fills |
| Game Dev Tycoon (239820) | 2013 | 94% of 22,262 | 68 | Your studio, isometric: garage, then small office, then big office with staff at desks |
| Darkest Dungeon (262060) | 2016 | 90% of 57,489 | 84 | Semi-diegetic: the Hamlet you rebuild is the menu; a narrator and a stress bar carry dread |

Seeds dropped: This Is the Police (443810, 73% of 2,903, weak reception), Telling Lies (762830, 62% of 1,263 *), Mind Scanners (1389550, 77% of 1,119 *), KinitoPET (2075070, 93% of 9,324; horror pastiche, little to learn for a dense management screen), Do Not Feed the Monkeys (658850, 91% of 2,349; overlaps Orwell and The Operator), Observation (906100, 78% of 2,605). Football Manager 2024 (2252570, 92% of 11,705) is not diegetic but its inbox-driven loop is cited under the patterns.

---

## 2. Shortlist: 10 deep dives

Screenshots in `shots/`.

### 2.1 Papers, Please -- the desk is the screen (papers-please-1/2.jpg)
- Conceit: top strip shows the checkpoint and queue from above; left the entrant behind glass; right your desk, where documents are dragged and overlap like real paper. Each day ends on a typed ledger: savings, salary, rent, food, heat, family OK or sick.
- Readability: each document type has one fixed layout and colour, read by shape. The cheat is Inspection Mode: a key dims the desk, you click two facts, a "DISCREPANCY DETECTED" overlay unlocks interrogate. Pope cut locking the deny stamp behind a caught discrepancy as "too game-like".
- Density: the desk is deliberately too small; rules arrive a day at a time.
- Mood: desk clock, endless queue, family lines turning red; the ledger carries the day in six lines.
- Annoying: "Your desk space is too small to display all this material at once ... you're left scrambling through a clutter of papers" (RPGFan). Later days repetitive.
- Transfer: month review as a printed ledger slip (Attention spent, money in and out, papers, staff; painful lines in red; the people you answer to marked OK or not); a focus key that dims the office and lifts the current decision into flat, clean type.

### 2.2 Cultist Simulator -- verbs on a table with ring timers (cultist-simulator-1/2.jpg)
- Conceit: green baize table; cards are resources; square tokens are verbs; drop cards into a verb and its circular timer runs.
- Readability: one colour per aspect; timed cards show seconds left; a fixed bottom bar holds four core counts and speed buttons with keys printed on.
- Density: dozens of cards; stacks and collapsing verbs keep it parseable, but tidying is on you.
- Annoying: sorting cards "a nightmare and an almost Sisyphean task"; clicking each icon tedious; obscurity. Lowest reception on the list (78%).
- Transfer: WATCH as running verbs (each committed action a token whose ring fills as days tick, then pops a result card); a fixed bottom bar with speed controls and keys printed on.

### 2.3 Not For Broadcast -- hardware as the whole interface (not-for-broadcast-1/2.jpg)
- Conceit: a vision-mixer desk: LED clock, ON AIR light, audience meter, four camera monitors with paper-tape numbers, feed buttons, audio mixer, ad-tape buttons.
- Readability: every control is a big labelled button with a lit state; fixed camera, all controls on one screen.
- Density: about ten controls and five readouts grouped into separate hardware boxes, each a different make.
- Mood: tape, wear, a fan, a window; static you fix; between shows teletext pages report money and family.
- Annoying: stress by design ("one of the most stressful games I have ever played").
- Transfer: readouts as separate desk hardware (money counter, compute lights, paper tally, reputation needle) grouped by kind; month review or newsletter as an amber/green teletext page.

### 2.4 Hypnospace Outlaw -- a fake OS with a fixed frame (hypnospace-outlaw-1/2.jpg)
- Conceit: a 1999 OS with desktop icons, browser, music player, downloads, a QuickCheck pop-up.
- Readability: permanent top bar (date, time, score); browser chrome fixed; reporting docks a palette of five numbered pictograms and a three-step pictured checklist -- a plain game overlay dressed as system software.
- Annoying: "tedious progression ... a needle in a haystack"; authentic slow loads frustrating; weak search.
- Transfer: a lab OS with one permanent top bar (month/day, Attention, money, P(Doom)); windows never cover it; decisions as small system-style checklist dialogs with numbered choices.

### 2.5 Hacknet -- a terminal that never makes you guess (hacknet-1/2.jpg; -2 is the Korean version)
- Conceit: four labelled panes (RAM, DISPLAY, TERMINAL, NETMAP); a trace puts a huge red countdown bottom-left.
- Readability: every pane labelled; the display turns terminal output into big rows; type or click; terminal is the log, display is the state.
- Annoying: repeated typing; terminal-for-everything is where Uplink and Duskers lose people.
- Transfer: the feed as a terminal pane plus a separate state pane with the same facts as clickable rows -- never read state from the log; one colour and one oversized number reserved for P(Doom).

### 2.6 Orwell -- the program that highlights what matters (orwell-1/2.jpg)
- Conceit: surveillance software; profile and relationship graph left, source right, date and workflow strip on top.
- Readability: actionable "datachunks" highlighted in text; drag onto the profile; conflicts flag red; highlighting is in-world because the fiction is software.
- Annoying: fewer real choices than it looks; much chunk hunting.
- Transfer: event messages with decision-relevant facts highlighted and choices in a fixed strip below; a comms list with type icons and "needs answer" flags.

### 2.7 SHENZHEN I/O -- an inbox that carries the plot and the job (shenzhen-io-1/2.jpg)
- Conceit: an engineer's workstation; an inbox over a window on the city; each thread an assignment from a named colleague; a binder-style manual.
- Readability: done tick / open "!" marks; every thread ends in one "OBJECTIVE:" band and one button.
- Transfer: PLAN's incoming items (offers, grant calls, press requests, ultimatums) as an inbox with done/open marks and one fixed "what it asks" band; the Player Guide as the staff handbook binder.

### 2.8 Frostpunk -- one dominant instrument over a living world (frostpunk-1/2.jpg)
- Conceit: semi-diegetic; the city is the main readout; brass HUD with a big thermometer dial top centre, resources either side, timeline, Discontent and Hope bars.
- Readability: the number that kills you is the biggest and most central; selection gets an outline and a clean side panel; events are full-screen illustrated cards with 2-3 options.
- Mood: frost creeps in from the screen edges as it gets colder.
- Transfer: P(Doom) as one physical instrument top centre (wall dial, counter, doomsday clock), level only (ADR-0015); "world on fire" by reddening window light and warmer CRT glow driven by the shown P(Doom) (reveals nothing hidden, ADR-0001).

### 2.9 XCOM 2 -- a doom bar that only fills, and a base you can see (xcom-2-1/2.jpg; -1 low-res)
- Conceit: Geoscape bridge; AVATAR PROJECT red pips top centre; the ship as a cut-away of staffed rooms.
- Readability: pips not a percent; map events pinned with day counts.
- Annoying: some players overwhelmed; doom bar's link to the ending unclear; advisor commentary repeats.
- Transfer: coarse physical steps beside the exact % for a number that only rises; the office floor as a side view whose rooms fill as you hire.

### 2.10 Game Dev Tycoon -- the office that grows with you (game-dev-tycoon-1/2.jpg)
- Conceit: isometric studio: garage, office of staff at desks, bigger offices, an R&D lab.
- Readability: the room is flavour; decisions are plain modal cards on top; output pops as bubbles over staff.
- Transfer: the office arc (garage -> warehouse -> startup office -> gilded office -> lair) as PLAN's backdrop with staff, cat and readouts on that tier's walls; in WATCH, bubbles over staff so each feed line has a source in the room.

---

## 3. Patterns that transfer

None needs a mechanics change; all present what the game already shows.

1. The desk is the screen (Papers, Please; Death and Taxes; Strange Horticulture). PLAN is the founder's desk from the chair: monitor, in-tray, phone, handbook. Picked actions are slips on the blotter; commit is a signature or stamp on the stack.
2. The inbox is the event queue (SHENZHEN I/O; The Operator; Orwell; Football Manager). Events and sub-choices arrive as emails or memos with a sender portrait; done/open marks; one fixed "what it asks" band.
3. One instrument for the number that kills you (Frostpunk; Not For Broadcast; XCOM 2; Hacknet). P(Doom) as the biggest object in the room, top centre, coarse steps, level only (ADR-0015).
4. The fixed frame (Hypnospace; Hacknet; Orwell). A permanent lab-OS bar: month/day, Attention, money, compute, P(Doom). Windows open below; each fact has one home.
5. The cheat layer (Papers, Please Inspection Mode; Orwell; Hypnospace QuickCheck). At a decision the office dims and choices appear in flat, high-contrast type with keys.
6. Hardware modules for readouts (Not For Broadcast; Frostpunk). Money counter, compute lights, paper tally, reputation needle, staff faces, boxed by kind with taped labels.
7. Running verbs (Cultist Simulator; Game Dev Tycoon). In WATCH each action is a token whose ring fills over days and drops a result slip; the feed is the log of slips.
8. The ledger close (Papers, Please; Not For Broadcast teletext). Month review as one printed sheet or teletext page, losses in red.
9. The room grows (Game Dev Tycoon; XCOM 2; Darkest Dungeon; Headliner). Office tier as backdrop; hires at desks; upgrades as objects.
10. Degradation as pressure (Not For Broadcast; Duskers; Pony Island; Frostpunk; Hacknet). Redder window light, CRT noise, flicker, smoke on the skyline, driven only by the shown P(Doom) and kept off text.
11. The window on the world (Papers, Please; Not For Broadcast; SHENZHEN I/O). Behind the silhouetted operator: city lights, then protests, then fires.
12. The handbook on the desk (Papers, Please; SHENZHEN I/O; TIS-100; Obra Dinn). Player Guide as the staff handbook; tutorial as an onboarding memo.

## 4. Pitfalls

1. Clutter as a tax (Papers, Please; Cultist Simulator). With ~15 actions a month over a long run, repeated dragging grinds. Use slots and lists; drag optional.
2. Information behind a click (Cultist Simulator). Planning facts must be visible at a glance (and reachable without hover).
3. Authentic slowness (Hypnospace loads; typed commands in Uplink, Duskers, Hacknet). No fake delays on per-turn actions.
4. Stress that does not fit the pace (Not For Broadcast). Keep PLAN calm; put pressure in WATCH and scenery.
5. Obscurity mistaken for atmosphere (Cultist Simulator; XCOM 2's doom bar). Every diegetic readout needs a plain label.
6. Repeated advisor chatter (XCOM 2). In-fiction voices need cooldowns and a mute.
7. CRT effects on text. Scanlines, bloom, curvature and flicker cut contrast; apply to frames and scenery, not text; ship a toggle.
8. Monochrome palettes lose state. Pair colour with shape, position and words.
9. Mixed metaphors (Frostpunk works because each layer has one rule). A desk object must not sometimes be a button and sometimes not.
10. Fiction that leaks or invents information. Scenery driven by hidden values breaks ADR-0001; a dial that jumps per action prints doom deltas against ADR-0015. Drive scenery only from what is already shown.

## Sources

Papers Please version history (papersplease.fandom.com/wiki/Version_history); RPGFan Papers, Please review; CogConnected and GamingOnLinux Cultist Simulator reviews; KeenGamer and GamesRadar Not For Broadcast; Shacknews, PC Gamer and TechRaptor Hypnospace Outlaw; LessWrong Orwell review; SHENZHEN I/O manual (usermanual.wiki); RAWG Frostpunk review; Digital Trends Frostpunk 2; Vice on XCOM 2; Steam discussion on the Avatar Project; "Carrot or Stick? Fixing an XCOM Design Problem". Screenshot URLs: Steam CDN, store_item_assets/steam/apps/<id>/ (full list in the agent's reply, 2026-11-21).

# Findings: Can we Improve Tutorials for Complex Games? (GMTK)

- **Source:** Game Maker's Toolkit (Mark Brown), "Can we Improve Tutorials for Complex Games?", 2021-05-31, 21:26 (`https://www.youtube.com/watch?v=-GV814cWiAw`).
- **Scope:** Methods, principles, rules, visual evidence, concrete bars/tests, and all game/UI examples shown in the video, extracted from watching the full video natively (00:00-21:26).

---

## 1. Key Findings (Methods, Principles, and Rules)

### Pillar A: Split Up the Tutorial (Timing and Progressive Disclosure)

#### F1. Break tutorials out of a single upfront block and interleave them with real play
- **Timestamp(s):** 01:23 - 01:44, 02:05 - 02:32, 02:51 - 03:04
- **Visual evidence:**
  - **Before (01:24 - 01:29):** *Bionic Commando* (2009) shows a sterile grey/red/green training chamber with a glowing green swing bar and a `1/3` -> `2/3` counter; at 02:10 - 02:14 *Splinter Cell* (2002) shows a warehouse obstacle course with yellow painted arrows and tape.
  - **Diagram (01:30 - 01:41, repeated 02:52 - 03:04):** On a dark grey canvas, a tall solid red rectangle labeled `tutorial` sits to the left of a wide solid blue rectangle labeled `gameplay`. The red block then splits into 4 thin vertical red slices that interleave between 5 blue `gameplay` blocks of increasing width (`[blue][red][blue][red][blue][red][blue][red][wide blue]`).
  - **After (02:05 - 02:09, 02:15 - 02:32):** *Rage 2* (2019) drops the player straight into outdoor combat. *Portal* (2007) Test Chamber 01 lets the player walk through real rooms where a glass window reveals a red floor button, an orange portal leads to it, a rotating portal gun sits on floor arrows with a tiny prompt (`MOUSE1 TO PLACE THE BLUE PORTAL`), and a dotted cyan floor line connects button to door -- teaching one rule per room while feeling like normal play.

#### F2. Pace lessons below the player's rising willingness-to-learn curve
- **Timestamp(s):** 01:45 - 02:04, 09:08 - 09:15
- **Visual evidence:**
  - **Diagram (01:45 - 02:04):** Line-and-bar chart citing `SOURCE [1] HOW I GOT MY MOM TO PLAY THROUGH PLANTS VS. ZOMBIES | GDC VAULT` (George Fan). X-axis: `investment (time)`. Y-axis: `willingness to learn`. A yellow diagonal line rises steadily from the origin.
  - **Before:** At the far left (low investment), a tall vertical tutorial bar shoots far above the yellow line; only the tiny bottom triangle beneath the yellow line is solid red, while the tall upper region above the line is grey cross-hatched (representing cognitive overload / player drop-off).
  - **After:** The tall upfront bar is replaced by 5 progressively taller solid red bars spaced rightward along the time axis, every bar staying strictly beneath the rising yellow diagonal line (also shown at 09:08 - 09:15 for multi-campaign pacing).

#### F3. Deliver each tutorial pop-up just-in-time, when the player actually encounters the mechanic
- **Timestamp(s):** 02:33 - 02:51, 04:30 - 04:55
- **Visual evidence:**
  - **Death Stranding (02:33 - 02:39):** Inside a Postbox terminal, highlighting `Deliver Lost Cargo` triggers a translucent dark overlay box (`Delivering/Entrusting Lost Cargo`) right at the moment of use.
  - **The Elder Scrolls V: Skyrim (02:40 - 02:51):** Walking up to a wooden Workbench and pressing `A Use Workbench` immediately opens the `Armor Smithing` screen with a centered `Workbenches` explanation modal on first use, rather than explaining crafting at game start.
  - **Frostpunk (04:35 - 04:55):** The left-hand tab list of the `Tutorial summary` modal literally grows as the player hits new mechanics during live play: clicking a Coal Pile to assign workers unlocks `RESOURCES AND WORKFORCE` (left list has only 2 entries: `CAMERA CONTROLS`, `RESOURCES AND WORKFORCE`); turning on the Generator unlocks `TEMPERATURE` (left list grows to 5 entries, showing a 6-step color bar from `COMFORTABLE` to `FREEZING` and a thermal screenshot); much later (Day 30-40) `GENERATOR OVERDRIVE` appears in a scrollable list of 9+ entries with thermal map + UI diagram.

#### F4. Design an "inverted pyramid of decision making" so early turns have one decision, not dozens
- **Timestamp(s):** 03:37 - 04:30
- **Visual evidence:**
  - **Diagram 1 (03:41 - 03:49):** Rotating 3D red inverted pyramid on dark background with white text `inverted pyramid of decision making`, citing `SOURCE [2] BRUCE SHELLEY | GAME DESIGN WORKSHOP`.
  - **Diagram 2 (03:50 - 04:11):** Animated white node tree growing upward from bottom center: 1 circle (Turn 1: where to settle city) -> 1 vertical line to 1 circle (Turn 2: what to build) -> splits into 2 circles (new unit order + next city build) -> rapidly branches upward into 4, 8, 16+ circles filling the top of the screen.
  - **Before vs. Late-game contrast (04:12 - 04:30):** *Civilization V* (2010) at Turn 0 (4000 BC) shows a tiny clear patch of green hexes surrounded by white cloud fog-of-war, just 1 Settler and 1 Warrior, one bottom-right `A UNIT NEEDS ORDERS` / `NEXT TURN` button, and a single small Science Advisor card top-right (`Click Next Turn`). It then cuts to Turn 234 (1620 AD) showing a fully revealed continent, dozens of cities and units, a packed top resource bar, and a column of right-edge notification alerts.

#### F5. Progressively disclose the UI itself -- hide panels, meters, and controls that are not needed on turn one
- **Timestamp(s):** 04:55 - 06:01
- **Visual evidence:**
  - **Bad examples (04:58 - 05:10):** *Crusader Kings II* (2012) character view packed with tiny icons, stats, traits, and a huge brown prose popup; *Endless Space 2* (2017) radial tech web with a dense left legend and top-right popup.
  - **Good example 1 -- Automatic progressive HUD (05:11 - 05:27):** *Mini Metro* (2015) opens on a blank white screen with ONLY a light-blue river, 3 geometric station outlines (square, triangle, circle), and a tiny top-left back arrow. Zero HUD meters exist at start. After the player draws the first yellow rail line, the bottom colored line-selector dots fade in; after drawing a second blue line, the top-right `MON` clock fades in; after passengers start moving on a third green line, the top-right passenger counter (`1 [person icon]`) appears beside `TUE`.
  - **Good example 2 -- Player-paced UI unlock (05:27 - 05:49):** *Animal Crossing: New Horizons* (2020) shows a split-screen of the default pocket grid inventory (left) vs. the 8-slot circular `Tool Ring` radial menu (right). Rather than teaching both on day 1, the player buys `Tool Ring: It's Essential!` from the green Nook Stop terminal for `800 miles` when ready, letting the player set the pace of UI complexity.
  - **Partial complex-game example (05:50 - 06:00):** *A Total War Saga: Troy* gradually expands bottom HUD panels (such as `LOCAL RECRUITMENT`) as the player progresses, though Mark urges designers to be "even more aggressive" with hiding early UI.

---

### Pillar B: Tutorials Across Multiple Campaigns (Replayable Games)

#### F6. Segment lessons by player proficiency tier and kick the player out to play between tiers
- **Timestamp(s):** 06:12 - 07:22
- **Visual evidence:**
  - **Jargon overload (06:21 - 06:30):** Over *Street Fighter V* (2016) Ryu footage, white text stacks advanced fighting-game terms: `trip guard`, `frame data`, `happy birthday`, `turtling`, `bivouacing` (made up as a joke), `pretzel motion`.
  - **Player segmentation (06:42 - 06:46):** White text citing `SOURCE [3] DESIGNING MORTAL KOMBAT 11'S EMPOWERING TUTORIAL MODE | GDC VAULT` lists 4 player archetypes: `couch players`, `dabblers`, `connoisseurs`, `online PvPers`.
  - **Tiered tutorial menu (06:47 - 06:58):** *Mortal Kombat 11* (2019) `TUTORIAL` screen separates lessons into distinct horizontal rows: `BASICS` (single wide card `BASIC TUTORIAL`), `ADVANCED` (`ADVANCED OFFENSE`, `ADVANCED DEFENSE`, `FRAME DATA`), `STRATEGY` (`BUILDING KOMBOS`, `ADVANTAGE & PRESSURE`, `POSITIONING & RESOURCES`), and `CHARACTER` (`CHARACTER LESSONS`), with a right-side checklist and `10 TIME CRYSTALS` reward.
  - **Play-between-tiers flow (06:58 - 07:20):** Shows completing a short blocking drill (`Block the Opponent's Overhead Attack while Standing 2/3` with controller overlay), exiting to play a real match (Cassie Cage vs. Kabal), and later returning for a harder objective drill (`Defeat Sub-Zero`).

#### F7. For replayable complex games, stage systems across separate campaigns (e.g., stripped-back beginner mode that turns on more systems in later runs)
- **Timestamp(s):** 07:23 - 09:16
- **Visual evidence:**
  - **Contrast (07:23 - 07:34):** *God of War* (2018) (story adventure played once) vs. *Tekken 7* (2015) (replayed repeatedly).
  - **Diagram 1 (07:34 - 07:47):** The interleaved single-campaign red/blue bar diagram zooms out into wide blue blocks (full campaigns) separated by thin red tutorial blocks *between* runs: `[Campaign 1][Tut][Campaign 2][Tut][Campaign 3]`.
  - **Historical proof-of-concept (07:48 - 08:39):** Contrasts *Civilization IV* (2005) `RELIGION ADVISOR` (removed at vanilla *Civ V* launch) with vanilla *Civ V* (simpler `*GOALS*` box, fewer systems), followed by the *Gods & Kings* and *Brave New World* expansion logos. The diagram at 08:31 - 08:39 labels the 3 progressively wider blue campaign blocks `Civ V`, `Gods & Kings`, and `Brave New World`, each preceded by a small red tutorial bar.
  - **Proposed design (08:46 - 09:07):** *Civilization VI* (2016) `CREATE GAME` screen hovering over the `CHOOSE GAME DIFFICULTY` dropdown (`Settler` through `Deity`). Rather than making easy mode just dumb AI, easy/first-run mode could strip back secondary systems and progressively enable them in subsequent runs until reaching the full-complexity game. (Spoken caveat: "the game would have to be designed this way from the very beginning.")

---

### Pillar C: Make Frontloaded Learning Fun and Effective (Active Play + Fast Feedback)

#### F8. Replace blind "click-here arrow" walkthroughs with micro-puzzles and unguided objectives
- **Timestamp(s):** 09:41 - 12:45
- **Visual evidence:**
  - **Action-game baseline (09:41 - 10:02):** *Devil May Cry 5* (2019) left-side live checklists (`TUTORIAL: HIGH ROLLER`, `TUTORIAL: COLOR UP`), *Yakuza 0* (2015) combat prompt box (`Teach These Punks a Lesson!`), and *Astro's Playroom* (2020) picture-in-picture controller demo overlaid with `kinaesthetic learning`.
  - **Ineffective arrow-following (10:03 - 10:24, 10:36 - 10:40):** *A Total War Saga: Troy*, *Endless Space 2*, and *Total War: Three Kingdoms* showing pulsing yellow circles, directional arrows, and literal "Left-click your army / Right-click here / Click on the new fleets" instructions.
  - **Quote card (10:28 - 10:35):** White overlay citing `SOURCE [4] HOW TO MAKE GREAT GAME TUTORIALS | GDC VAULT` (Asher Vollmer, Designer, *Threes*): *"As far as the game is concerned; I have advanced. But as far as my brain is concerned; I've learned nothing."*
  - **Before/After micro-puzzle mockup in *Threes* (10:49 - 11:10):** Phone screen showing a 4x4 grid bordered in pink labeled `WALL` on left/right with only two tiles (`1` blue, `2` red).
    - *Bad hypothetical version (10:55 - 10:59):* Top text commands `"Swipe to the left twice..."` then `"Now swipe up twice..."`.
    - *Actual Threes tutorial (11:00 - 11:08):* Top text states the rule/goal instead of the inputs: `"Rearrange numbers by pushing 'em into walls."` -> `"Use the walls to add 1 & 2 together."` When the player figures out the swipes and merges `1+2=3`, it rewards them with `"Auspicious!"`.
  - **Guided-then-solo pattern in *Planet Zoo* (11:17 - 12:24):** First, advisor Nancy Jones walks the player step-by-step through fixing one Bengal Tiger habitat and painting Snow Leopard terrain (Terrain Distribution bars turning red `41%` to green). Immediately afterward, the objective switches to `"Increase the average habitat species overall welfare to 80%"` and Nancy leaves (`"I'm off for a cuppa"`), removing arrows so the player must inspect other animals (e.g., zebra `Ebun` and the `ANIMALS` roster table) and diagnose problems themselves.
  - **Objective-list pattern in *Offworld Trading Company* (12:25 - 12:45):** Top-right `Objectives` box lists goals (`Build 2 Electronics Factories 1/2`, `Upgrade the Robotic HQ`, `Build 2 Solar Panels`, `Learn to live with debt`) with **no** click-here arrows pointing at UI buttons; the player finds the right buttons and places structures themselves.

#### F9. Shorten slow strategy feedback loops via shorter/faster training modes and reactive advisor warnings
- **Timestamp(s):** 12:46 - 14:37
- **Visual evidence:**
  - **Fast vs. slow feedback contrast (12:52 - 13:20):** *Skate 3* (2010) shows a color-coded blue/yellow ramp (`Setup in the Blue / Flick-It in the Yellow`) with instant stick-flick visual feedback; *Sekiro: Shadows Die Twice* (2019) shows a missed deflect causing instant death (red kanji). Contrasted with *Civilization VI*, *Two Point Hospital* (2018), and *Total War: Warhammer II*, where economic mistakes take hours to surface.
  - **Short repeatable campaigns (13:21 - 13:28):** *Slay the Spire* (2019) fast turn-based card combat (playing `Strike`, `Piercing Wail`, `Bullet Time`, `Sucker Punch`), where short repeatable runs make consequences obvious quickly.
  - **Speed-up mode as training tool (13:29 - 13:37):** *Civilization V* Game Setup screen opening the `Game Pace` dropdown and selecting `Quick` (`"The number of turns required to complete various tasks is reduced. Recommended for players who want to finish matches faster."`).
  - **Reactive advisor feedback for both "how" and "why" (13:38 - 14:36):**
    - *Civ VI* negative example of teaching only "how" (14:08 - 14:18): Yellow arrow pointing to the city gear icon (`CHOOSE PRODUCTION`) shows how to click, not what/when/where to build.
    - *Offworld Trading Company* positive reinforcement (13:38 - 13:45): Advisor popup `"Very Nice!"` praising adjacent Greenhouse Farm placement (`"Each Greenhouse Farm is now 50% more productive because of their placement."`).
    - *Offworld Trading Company* warning on a bad strategic move (13:46 - 13:53): Advisor popup `"We aren't a Charity!"` scolding the player for selling Aluminum under $10 and explaining market flooding / buy-low-sell-high.
    - *Civilization V* strategic nudge (14:25 - 14:36): Top-right Economic Advisor popup `"Stop Making Workers!"` (`"I think we have enough Workers for the moment. You may want to build something else in your city."`).

---

### Pillar D: Use Familiar Affordances (Real-World Metaphors and Everyday UI Conventions)

#### F10. Leverage real-world physical expectations and grounded themes so rules feel intuitive without text
- **Timestamp(s):** 14:37 - 15:29
- **Visual evidence:**
  - *Hearthstone* (2014) (14:38 - 14:44): Trying to attack past a Taunt minion (shield border) bounces back with `"Character cannot be attacked"`.
  - Universal affordance montage (14:44 - 14:52): *Prince of Persia: The Sands of Time* (2003) spikes pit; *New Super Mario Bros. U* (2012) icy slope; *Luigi's Mansion 3* (2019) gold coins; *The Legend of Zelda: Link's Awakening* (2019) key from chest; *The Binding of Isaac: Rebirth* (2014) skull boss door.
  - *Plants vs. Zombies* (2009) (14:53 - 15:02): Side-by-side comparison of Conehead Zombie (plastic traffic cone) vs. Buckethead Zombie (metal bucket) -- players infer metal is tougher than plastic from real-world material knowledge.
  - *Overcooked* (2016) (15:03 - 15:08) and *Inside* (2016) (15:09 - 15:11): Intuitive real-world kitchen workflows and environmental cues.
  - Grounded/historical complex games (15:12 - 15:29): *Anno 1800* (pig -> slaughterhouse production chain) and *Civilization VI* / *V* (historical leaders and cities, punctuated by the Gandhi declaring war joke).

#### F11. Borrow interaction patterns and iconography from everyday consumer apps and websites
- **Timestamp(s):** 15:30 - 16:28
- **Visual evidence:**
  - *Reigns* (2016) (15:30 - 15:43): Left/right card swiping compared side-by-side with a Tinder mobile UI mockup (`NOPE` / `LIKE` swipe cards).
  - *Disco Elysium* (2019) (15:44 - 15:48): Vertical scrolling right-hand dialogue feed citing `SOURCE [5] THE FEATURE THAT ALMOST SANK DISCO ELYSIUM | GAMESPOT` (inspired by a Twitter feed).
  - *Planet Zoo* four-part web/app UI breakdown (15:49 - 16:28):
    1. **Sortable table columns (15:57 - 16:04):** Clicking the `WELFARE` header in the `ANIMALS` table sorts rows low-to-high -> cut directly to a Wikipedia sortable table (`Developer(s)`, `Publisher(s)` header arrows).
    2. **Location pin icon (16:05 - 16:10):** Clicking the teardrop pin icon next to an animal zooms the camera to it -> cut directly to Google Maps red teardrop pins.
    3. **Red = bad, green = good bars (16:11 - 16:16):** Zebra `Shasmecka` detail panel shows green `100%` Nutrition/Social, green `81%` Habitat, bright red `6%` Enrichment.
    4. **Funnel icon for filters (16:17 - 16:22):** Bottom toolbar funnel icon (`Filters`) -> cut directly to the identical funnel icon in the Google Sheets toolbar.

#### F12. Never assume players know genre-legacy icons; playtest tutorials extensively to catch broken affordances
- **Timestamp(s):** 16:29 - 17:22
- **Visual evidence:**
  - **Before (16:44 - 16:49):** *A Total War Saga: Troy* pre-launch minimap cluster citing `SOURCE [6] EVOLVING THE UX/UI OF A TOTAL WAR SAGA: TROY USING PLAYER FEEDBACK | GAMASUTRA`, with a bright yellow circle highlighting the bottom-right End Turn button showing an **hourglass** icon.
  - **Why it failed (16:50 - 17:08):** Shows *Heroes of Might and Magic II* (1996) using an hourglass for End Turn (familiar only to veteran strategy players), contrasted with *Cuphead* (2017) animated hourglass loading screen, the Windows Mouse Properties cursor list (`Working In Background` / `Busy` hourglasses), and the Wikipedia page for `Throbber` ("A throbber, also known as a loading icon..."). New players thought the hourglass meant loading, not "End Turn".
  - **After (17:09 - 17:13):** Launch version of *Total War: Troy*'s minimap cluster where the hourglass was replaced by a **curved forward arrow** button (with turn counter badge `1`).

---

### Pillar E: Presentation, Reference Tools, and Learning Styles

#### F13. Show, don't tell: use images and short embedded animations instead of walls of text
- **Timestamp(s):** 17:23 - 17:55
- **Visual evidence:**
  - **Annotated diagram card (17:24 - 17:28):** *Fire Emblem: Three Houses* (2019) `Movement` (1/2, 2/2) modal pairs a large annotated battlefield image (red arc arrow + highlighted command menu) with 1-2 short sentences below.
  - **Compact icon-assisted popups (17:29 - 17:40):** *The Witcher 3: Wild Hunt* (2015) shows short left-side cards (`ACTIVE OBJECTIVE`, `CRAFTSMEN`, `ENHANCING WEAPONS`) with inline button/map icons.
  - **Live looping micro-animation (17:41 - 17:55):** *Into the Breach* (2018) `ARTILLERY MECH` modal displays 1 sentence above, a **looping isometric 3x3 grid animation** in the center (mech fires dotted arc over a mountain, damages center enemy, pushes 3 adjacent enemies outward along yellow arrows), and 1 sentence below. Followed by quote card citing `SOURCE [7] INTO THE BREACH'S INTERFACE WAS A NIGHTMARE TO MAKE... | ROCK PAPER SHOTGUN` (Justin Ma): *"You could type out a hundred times, 'Damages a tile and pushes adjacent tiles,' but showing that little animation of them moving is a thousand times more effective."*

#### F14. When text is necessary, cut word count, keep terminology consistent, avoid jargon, and do not voice flavor text while leaving key instructions unvoiced
- **Timestamp(s):** 17:56 - 18:24
- **Visual evidence:**
  - **Text-bloat examples (17:56 - 18:06):** *Crusader Kings III* `Prestige (IV - Resources)` (2/3) modal with 4 full paragraphs of text; *Cities: Skylines* (2015) `Roads` box with 3 dense paragraphs of small text below 4 tiny road icons.
  - **Voiceover mismatch example (18:07 - 18:24):** Zoomed-in view of *A Total War Saga: Troy*'s top-right advisor box: the voiced actor (Homer) reads only the top tan box of dramatic flavor text (`"March north-west, towards the land of Corinth. For even now, the Corinthians plot your demise."`), while the actual controls (`"Left-click on your army to select it. Right-click on the ground to move your army there."`) sit silently in the dark brown box underneath.
  - *Note:* "Cut down words, be consistent with language, avoid jargon" is paired with dense prose screens (CK3 / Cities: Skylines) rather than a specific before/after text rewrite.

#### F15. Provide on-demand self-help reference tools (nested tooltips, in-game glossary/encyclopedia, replayable tutorial steps) so players never have to Google basic rules
- **Timestamp(s):** 18:25 - 18:51
- **Visual evidence:**
  - *Bayonetta* (2009) (18:25 - 18:29): Interactive loading-screen combo practice area with move list on the right.
  - *Crusader Kings III* **Nested Tooltips** (18:30 - 18:33): `Nested Tooltips (I - Basics)` tutorial demonstrating hovering over a blue highlighted term (`Holding`) to open a tooltip, then hovering over terms inside that tooltip (`Barony`, `County`, `Doctrine`, `Faith`, `De Jure`, `Character`) to open chained sub-tooltips that lock in place.
  - *Civilization VI* **Civilopedia** (18:34 - 18:39): Searchable in-game encyclopedia (`Apprenticeship`, `Hansa`, `Entertainment Complex`, `Civics`) with search field, category icon tabs, and history breadcrumbs.
  - *Minecraft* (2011) (18:40 - 18:44): Mining/torch footage illustrating a game where stuck players are forced to leave the game and search Google.
  - *Planet Zoo* (18:45 - 18:51): Hovering UI tooltips on demand while managing a zoo independently.
  - *Note:* The point about "the ability to rewind or replay specific bits of the tutorial" is **spoken only** (18:37 - 18:39, spoken over Civilopedia footage).

#### F16. Offer multiple learning tracks for different learning styles and prior experience levels
- **Timestamp(s):** 18:52 - 19:27
- **Visual evidence:**
  - *Offworld Trading Company* (19:07 - 19:18): Main menu `Learn to Play` opens a choice between two modes: `Scripted Tutorials` (`"Offworld's most successful CEOs teach the basics of building strong businesses"`) and `Practice Challenges` (`"Learn through trial-and-error by playing as each corporation with a progressive difficulty curve."`).
  - *Total War: Three Kingdoms* (19:19 - 19:27): Pre-campaign prompt `"What is your experience of Total War? This choice impacts the amount and type of advice you receive in-game, and your starting difficulty."` with two buttons: `I AM NEW TO TOTAL WAR` and `I HAVE PLAYED TOTAL WAR BEFORE`.

#### F17. Treat the tutorial as a core product investment, not a last-minute afterthought
- **Timestamp(s):** 19:28 - 20:39
- **Visual evidence:** Mostly **spoken only** (backed by montage B-roll of *Persona 5*, *XCOM: Chimera Squad* `Turns & Moving` modal, *Titanfall 2* Gauntlet, *Crusader Kings III*, and *Total War: Warhammer II*). Reports interviews with developers at Paradox and Creative Assembly agreeing that onboarding new players is the only way a complex franchise grows its fanbase and avoids withering into irrelevance.

---

## 2. Concrete Bars, Thresholds, and Tests Mentioned

The video is primarily qualitative and principle-driven rather than a list of strict numeric KPIs, but it states the following concrete failure bars, heuristics, and qualitative tests (quoted as close to verbatim as possible):

1. **The 20-minute attention / zone-out bar (00:18 - 00:25):**
   > "I get about 20 minutes into the tutorial, and I start to zone out. My eyes glaze over, and my mind drifts."
2. **First-turn decision bar -- Inverted Pyramid (03:45 - 03:56):**
   > "When you start Civilization, you basically have one decision to make on your first turn: where should you settle your city? And one decision on your next turn: what should you build there? But now you have two decisions to make."
3. **First-turn UI audit question (05:05 - 05:11):**
   > "How many of these buttons, bars, windows, and panels need to be there on the first turn?"
4. **Active-learning bar (Asher Vollmer quote, 10:28 - 10:35):**
   > "As far as the game is concerned; I have advanced. But as far as my brain is concerned; I've learned nothing."
5. **Real-playtest failure bar (Total War: Troy hourglass icon, 16:39 - 16:45):**
   > "One player spent 40 minutes on the first turn, unsure how to move on."
6. **Audience assumption & playtesting rule (17:14 - 17:23):**
   > "One: don't assume your audience has played other games. And two: play test your tutorials. Like, a lot."
7. **Visual vs. text speed heuristic (17:34 - 17:41):**
   > "An image or video can sometimes tell you the same information in half the time."
8. **Animation vs. prose bar (Justin Ma quote, 17:45 - 17:55):**
   > "You could type out a hundred times, 'Damages a tile and pushes adjacent tiles,' but showing that little animation of them moving is a thousand times more effective."
9. **The Google test for self-help docs (18:40 - 18:45):**
   > "Ultimately, if someone gets stuck you don't want their only solution to be Google."
10. **The overall engagement test (20:33 - 20:39):**
    > "Until I can get through the Crusader Kings tutorial without falling asleep, we're not quite there."

---

## 3. Games, Non-Game UIs, and Sources Shown

### Games Shown (in order of first appearance, with on-screen release years)
1. **A Total War Saga: Troy** (2020) -- 00:05, 00:17, 05:50, 10:03, 16:29, 18:07, 20:24 (wall of UI, expanding UI, click-here arrows, hourglass vs. arrow End Turn playtest fix, voiced flavor text vs. silent controls).
2. **Crusader Kings III** (2020) -- 00:07, 00:22, 00:55, 03:27, 09:23, 17:56, 18:30, 19:46, 20:31 (text-heavy modal tutorials, frontloaded interconnected systems, **nested tooltips** positive example).
3. **Endless Space 2** (2017) -- 00:08, 00:25, 05:05, 10:20 (crowded radial tech tree, pulsing click-here fleet prompts).
4. **Europa Universalis IV** (Steam cart) -- 00:09 (complex grand strategy intro gag).
5. **Total War: Warhammer II** (2017) -- 00:11, 00:48, 13:15, 19:53 (Steam install, campaign advisor overlays, slow campaign feedback).
6. **Ghost of Tsushima** (2020) -- 00:31 (minimal HUD combat drill: `0/3`, `0/4`).
7. **Fallout 3** (2008) -- 00:38 (narrative-integrated Vault 101 birthday tutorial).
8. **Half-Life 2** (2004) -- 00:42 (subtle/invisible environmental teaching: City 17, Ravenholm sawblade).
9. **Jurassic World Evolution** (2018) -- 01:06 (management game advisor & mission box).
10. **ARMS** (2017) -- 01:10 (visual Joy-Con graphic prompt + instant `GOOD!` feedback).
11. **Bionic Commando** (2009) -- 01:24 (old-style separate sterile training chamber).
12. **Rage 2** (2019) -- 02:05 (playing the real game immediately).
13. **Splinter Cell** (2002) -- 02:10 (academic warehouse training course with painted arrows).
14. **Portal** (2007) -- 02:15 (micro-lessons disguised as real early puzzle chambers).
15. **Death Stranding** (2019) -- 02:33 (just-in-time popup when using a Postbox terminal).
16. **The Elder Scrolls V: Skyrim** (2011) -- 02:40 (just-in-time Workbench popup on first interaction).
17. **Returnal** (2021) -- 03:05 (gradually finding upgrades during play).
18. **Metroid Prime** (2002) -- 03:16 (starting simple and unlocking abilities like Morph Ball).
19. **Civilization** (1991) -- 03:37 (Bruce Shelley's inverted pyramid of decision making).
20. **Civilization V** (2010) -- 04:12, 07:48, 08:04, 08:15 (Gods & Kings / Brave New World), 09:02, 13:29, 14:25, 15:26 (organic complexity growth, expansion packs as multi-campaign staging, `Quick` game pace, Economic Advisor `"Stop Making Workers!"`, Gandhi war joke).
21. **Frostpunk** (2018) -- 04:31, 06:01, 09:17, 18:57 (just-in-time `Tutorial summary` modals unlocking across a live campaign).
22. **Persona 5** (2016) -- 04:55, 19:28 (UI design transition / callback to previous GMTK UI episode).
23. **Crusader Kings II** (2012) -- 04:58 (overwhelming character sheet + text-wall popup).
24. **Mini Metro** (2015) -- 05:11 (near-zero initial HUD; UI elements appear one by one as needed).
25. **Animal Crossing: New Horizons** (2020) -- 05:27 (purchasable `Tool Ring` lets players pace UI complexity).
26. **Street Fighter V** (2016) -- 06:12 (fighting-game jargon overload).
27. **Dead or Alive 6** (2019) -- 06:31 (basic fighting-game play beyond button mashing).
28. **Mortal Kombat 11** (2019) -- 06:36 (tiered Basics/Advanced/Strategy tutorial that kicks you out to play between segments).
29. **God of War** (2018) -- 07:23 (single-playthrough story game contrast).
30. **Tekken 7** (2015) -- 07:29 (replayed-over-and-over game contrast).
31. **Civilization IV** (2005) -- 08:01 (Religion Advisor -- system cut in vanilla Civ V).
32. **Civilization VI** (2016) -- 08:46, 13:02, 14:08, 15:19, 18:34 (difficulty dropdown, slow economic feedback, "how vs. why" production arrow, historical theme, **Civilopedia** encyclopedia).
33. **StarCraft II** (2010) -- 09:30 (frontloaded RTS tutorial objectives and unit tooltips).
34. **Devil May Cry 5** (2019) -- 09:41 (kinaesthetic perform-the-move tutorial checklist).
35. **Yakuza 0** (2015) -- 09:47 (hands-on combat counter drill).
36. **Astro's Playroom** (2020) -- 09:56 (kinaesthetic controller learning).
37. **Threes** (2014) -- 10:25, 10:41 (micro-puzzle tutorial teaching wall-rearranging instead of swipe commands).
38. **Total War: Three Kingdoms** (2019) -- 10:36, 19:19 (blind click-here siege arrow; positive example of newbie vs. returning-player tutorial choice).
39. **Planet Zoo** (2019) -- 11:17, 15:49, 18:45, 20:13 (guided-then-unguided zoo welfare challenges; web/app UI affordances: sortable table, map pin, red/green bars, funnel filter; on-demand tooltips).
40. **Offworld Trading Company** (2016) -- 12:25, 13:38, 19:07 (arrow-free objectives, reactive positive/warning advisor popups, choice of `Scripted Tutorials` vs. `Practice Challenges`).
41. **Anno 1800** (2019) -- 12:46, 13:54, 15:12 (complex city-builder feedback, quest advisors, grounded historical theme).
42. **Skate 3** (2010) -- 12:52 (instant visual kinaesthetic feedback on colored ollie ramp).
43. **Sekiro: Shadows Die Twice** (2019) -- 12:57 (instant mistake feedback via immediate death).
44. **Two Point Hospital** (2018) -- 13:11 (slow management feedback cycle).
45. **Slay the Spire** (2019) -- 13:21, 14:19 (short repeatable runs giving fast strategic feedback).
46. **Hearthstone** (2014) -- 14:38 (shielded Taunt affordance + immediate bounce-back feedback).
47. **Prince of Persia: The Sands of Time** (2003) -- 14:44 (spikes hurt).
48. **New Super Mario Bros. U** (2012) -- 14:46 (ice is slippery).
49. **Luigi's Mansion 3** (2019) -- 14:48 (coins let you buy things).
50. **The Legend of Zelda: Link's Awakening** (2019) -- 14:49 (keys open locks).
51. **The Binding of Isaac: Rebirth** (2014) -- 14:51 (skulls mean danger).
52. **Plants vs. Zombies** (2009) -- 14:53 (plastic cone vs. metal bucket material affordance; also George Fan's GDC talk at 01:45).
53. **Overcooked** (2016) -- 15:03 (intuitive real-world cooking workflow).
54. **Inside** (2016) -- 15:09 (wordless intuitive design).
55. **Reigns** (2016) -- 15:30, 20:19 (Tinder swipe left/right UI metaphor).
56. **Disco Elysium** (2019) -- 15:44 (Twitter-feed-inspired dialogue box).
57. **Heroes of Might and Magic II** (1996) -- 16:50, 17:14 (legacy strategy hourglass End Turn icon).
58. **Cuphead** (2017) -- 16:55 (hourglass as loading animation).
59. **Fire Emblem: Three Houses** (2019) -- 17:24 (visual diagram tutorial card with short caption).
60. **The Witcher 3: Wild Hunt** (2015) -- 17:29 (short icon-assisted tutorial cards).
61. **Into the Breach** (2018) -- 17:41 (looping animated tactical preview inside weapon tutorial modal).
62. **Cities: Skylines** (2015) -- 18:03 (dense multi-paragraph text popup).
63. **Bayonetta** (2009) -- 18:25 (interactive loading-screen practice mode).
64. **Minecraft** (2011) -- 18:40 (forcing stuck players onto Google).
65. **Star Fox Zero** (2016) -- 18:52 (different learning styles transition).
66. **XCOM: Chimera Squad** (2020) -- 19:33 (tutorial modal in conclusion montage).
67. **Titanfall 2** (2016) -- 19:39 (Gauntlet training range in conclusion montage).
68. **Narita Boy** (2021) -- 20:51 (outro indie game recommendation; verbally compared to *Guacamelee* and *Sword & Sworcery*).

### Non-Game UI / Real-World Examples Shown
- **Steam store / install dialog & Apple Calendar** (00:09 - 00:16) -- intro skit.
- **Tinder** (15:38 - 15:43) -- swipe left/right metaphor copied by *Reigns*.
- **Twitter feed** (15:44 - 15:48, spoken + cited) -- dialogue scroll inspiration for *Disco Elysium*.
- **Wikipedia sortable table** (16:01 - 16:04) -- column-header sorting convention used in *Planet Zoo*.
- **Google Maps** (16:08 - 16:10) -- teardrop location pin icon used in *Planet Zoo*.
- **Google Sheets** (16:20 - 16:22) -- funnel filter icon used in *Planet Zoo*.
- **Windows Mouse Properties cursor list & Wikipedia "Throbber" article** (16:59 - 17:08) -- why an hourglass reads as "loading" to non-veterans.

### On-Screen Cited Sources
1. `SOURCE [1] HOW I GOT MY MOM TO PLAY THROUGH PLANTS VS. ZOMBIES | GDC VAULT` (George Fan) -- 01:47
2. `SOURCE [2] BRUCE SHELLEY | GAME DESIGN WORKSHOP` -- 03:44
3. `SOURCE [3] DESIGNING MORTAL KOMBAT 11'S EMPOWERING TUTORIAL MODE | GDC VAULT` -- 06:43
4. `SOURCE [4] HOW TO MAKE GREAT GAME TUTORIALS | GDC VAULT` (Asher Vollmer) -- 10:30
5. `SOURCE [5] THE FEATURE THAT ALMOST SANK DISCO ELYSIUM | GAMESPOT` -- 15:45
6. `SOURCE [6] EVOLVING THE UX/UI OF A TOTAL WAR SAGA: TROY USING PLAYER FEEDBACK | GAMASUTRA` -- 16:45
7. `SOURCE [7] INTO THE BREACH'S INTERFACE WAS A NIGHTMARE TO MAKE... | ROCK PAPER SHOTGUN` (Justin Ma) -- 17:47

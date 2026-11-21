# Grim pass (hifi2): report

## Summary

**Done. The council says GOOD TO GO, all three: opus 8.5, sol 9, neon 9 out
of 10, nothing blocking.** All three say H belongs beside the grim gallery
(average; opus: average to better). One fix round settled three blocking
items: the meters were dimmed below 4.5:1 in states 2, 3 and 5; the
dateline re-typed within a month; and state 4 said "PAUSED" beside
"RUNNING".

- **What it is:** one design, H. It keeps A's layout but makes Commit small
  and puts E's card file in as the action menu. Every panel and meter is in
  G's dark palette and meter style.
- **Showcase:** `fork/design/hifi2/index.html` shows H's six states beside
  hifi A and G, with a before/after view, a toggle view and an all-states
  view.
- **What changed, in one line:**
  - Paper is the only light thing, and it is aged.
  - A typewriter dateline replaces the calendar.
  - Nothing is glossy.
  - The room darkens by doom band and has room left to get darker in
    state 6.
  - All text is at least 4.5:1, measured on rendered pixels at 1920x1080
    and 1280x720.
- **Gallery:** cut to grim references only, with 8 Frostpunk menu shots
  added (gallery.html, gallery-grim.md).
- **Not decided here (carried):** C, E and G are not cut; Alex and Pip
  choose which concept goes forward. The Staff/Hire icon question is still
  open.
- **Disk:** the hifi run's 53 MB of full-size PNG renders were deleted.
  H's 16 MB of PNGs, the 9.1 MB of dropped reference images and the 5.7 MB
  of Frostpunk shots stay on the box, uncommitted.

## Where to look

- `fork/design/hifi2/index.html`: the showcase.
- `fork/design/hifi2/H/concept.html?state=1..6`: the live mock-up. It shows
  the dateline type-on; add `&still=1` to stop it.
- `fork/design/hifi2/H/notes.md`: per-state notes, contrast table, the
  icons, and the fix round.
- `fork/design/hifi2/gallery.html` and `gallery-grim.md`: the grim gallery.
- `fork/design/hifi2/council/`: every council answer, verbatim, and the
  agreed list.

## What changed from hifi (against Alex's words)

1. **Layout from A.** A's layout stays: the meters, rack, plan panel, desk
   and Commit are all where A had them.
   - Commit is now a quiet 296x60 button, as in C, E and G.
   - "Held for events" sits in a small panel above Commit. In WATCH, that
     panel also holds the month clock, PAUSED FOR YOU and the speed
     controls, and the Commit slot reads "MONTH IN PLAY".
2. **E's action menu, dark.** State 2 is E's two-column card file, in the
   same order as E's, on G's dark panels. There are no cream cards. Blocked
   plays are hatched and show why they are blocked.
3. **G's palette and meter for every instrument.**
   - P(Doom) is G's 270-degree arc with the band ladder and "band N of 7".
     It keeps the band colours: green, then amber/orange, then magenta.
   - Reputation is a neutral semicircle tachometer in the same style.
   - Attention and the workday bar use G's flat pips.
4. **Paper is the only light thing.** The advisor note, the event slip,
   the month review and the cat photo print are aged and stained.
   Everything else is dark.
5. **Typewriter dateline.** The red tear-off calendar is replaced by a
   date only ("NOVEMBER 1, 2017") in chunky Courier Prime. In the live
   mock-up it types in when a month starts, and only then. It respects
   reduced motion. The sound is not built (open question 1).
6. **Less cartoony.**
   - Gone: the bakelite CRTs, glare, bloom, glossy brass and the tear-off
     calendar.
   - In their place: flat hairline frames, grain and wear.
   - Pip's icons sit on dark plates, toned. Those still cartoony are
     listed below under "New art needed".
7. **Bleaker without damaging the UI.**
   - The room dims step by step with doom: .62 in month 1, down to .36 in
     state 6.
   - State 6 adds a violet window and "Very close to game over". The
     controls do not move or change colour.
   - Every visible label is at least 4.5:1 on the composited pixels at
     both sizes. The lowest is 4.50, a state 3 label at 720p.
   - No person or silhouette is drawn; Pip's own icons are open
     question 2.

All numbers, costs, pools and event options are the hifi run's
(fork/design/hifi/run-state.md with REVISIONS 2 and 3). The agreed hifi
rules still hold: no printed doom deltas, the spill runs operating ->
planning only, the reserve is untyped, there are no NEW chips, filled bars
mean hours left, and only the top layer shows Enter/Esc.

## The gallery cull

The cull is listed in `fork/design/hifi2/gallery-grim.md`.

- **Kept:**
  - reference games: frostpunk-1/2/3, suzerain-1, xcom2-2;
  - diegetic: cultist-simulator-1, frostpunk-1/2, hacknet-1/2,
    not-for-broadcast-1/2, papers-please-1/2, shenzhen-io-1, xcom-2-2.
- **Added:** frostpunk-menu-1..8, from Steam's public screenshots.
  - Frostpunk 1: menus 1 to 3 (the Purpose law tree, a building panel, the
    Archives).
  - Frostpunk 2: menus 4 to 8 (the council and event panels).
- **Dropped:** moved, uncommitted, to
  `fork/design/research/_dropped-refs/`:
  - Against the Storm, Democracy 4, Football Manager 2024, FTL, Into the
    Breach, Terra Invicta, Game Dev Tycoon, Hypnospace Outlaw and Orwell;
  - suzerain-2, xcom2-1, cultist-simulator-2, shenzhen-io-2 and xcom-2-1.

Third-party shots are never committed. `gallery.html` links to them by
relative path, so it shows them only on a machine that has the files.

## Council

The council was opus (Claude), sol (Codex) and neon (Gemini), at low
sensitivity. Their answers are in `fork/design/hifi2/council/`.

### Round 1

| Member | Score | Verdict |
|---|---|---|
| opus | 8.5 | GOOD TO GO |
| sol | 8 | CHANGES NEEDED |
| neon | 8.5 | CHANGES NEEDED |

All three said H belongs beside the grim gallery: "average", or opus's
"average to better". The closest matches are Frostpunk's Archives, the
Frostpunk 2 event panels and Papers, Please.

**Agreed list** (`fork/design/hifi2/council/r1-agreed.md`):

- **Blocking:**
  1. The dimmer covered the meters, rack and Commit in states 2, 3 and 5.
     It measured 2.0-3.7:1 and has been moved behind them.
  2. The dateline re-typed within November. It now types in on a month's
     entry only.
  3. State 4 said "PAUSED FOR YOU" beside "MONTH RUNNING". The Commit slot
     now reads "MONTH IN PLAY".
- **Cheap items:**
  - darker, bold ink on the state 4 paper;
  - no keycaps on disabled rack plates, and none on the live plates while
    the event waits (the majority view: opus and neon);
  - the showcase keeps keyboard focus on the toggle (the orchestrator's
    fix).

After the consensus step the scores were opus 8, sol 8, neon 8.5.

### Re-check

Opus and sol first, neon last. Every agreed item was checked done at both
sizes, contrast was re-measured on the composited pixels, and all three
accept the majority items.

| Member | Score | Verdict | Blocking |
|---|---|---|---|
| opus | 8.5 | GOOD TO GO | none |
| sol | 9 | GOOD TO GO | none |
| neon | 9 | GOOD TO GO | none |

The meter readouts that had dropped to 2.0-2.8:1 now measure 4.9-8.0:1.
Two notes were left for Alex, not fixed:

- In state 4 the option costs on the paper are still weight 400; set them
  bold like the footer (opus, neon).
- In state 5, Commit is lit at full strength while the month review covers
  the screen. It has no Enter, but it looks pressable. A did the same.

## Open questions for Alex

1. **Typewriter sound:** should it be one key strike per character and a
   carriage return at the end? Which mix bus, and is it muted with the UI
   sounds? Not built.
2. **Do Pip's Staff and Hire icons count as "the person"?** This is
   carried from hifi, not decided. Human silhouettes remain only in
   `ui_staff_management` (the rack's Staff plate) and `button_hire_normal`
   (Hire Staff in state 2). If they count, draw figure-free versions.
3. **Which concept goes forward?** That is Alex's and Pip's call. C, E and
   G from the hifi run are not cut. H is a grim version of A and borrows
   from E and G.
4. **The dateline:**
   - It types in on a month's entry only, including month 1, and updates
     the day in place within a month. Is that right?
   - Is 28px chunky enough? Opus thought it read thin next to the meter;
     sol and neon found it fine.
5. **"LAB TERMINAL 1":** the plan and feed panels are no longer CRTs.
   Should the label and the green LED go? Opus would drop them; sol and
   neon carried the question here.
6. **Actions menu box:** H uses the plan sheet's box, so the rack and
   Commit stay visible. Keep it, or go back to A's wide frame with a
   shorter card file?
7. **Taste notes from the council, not built:**
   - State 4 shows the date three times: the dateline, the clock and the
     event header.
   - The paper could have creases and burnt edges.
   - The panel frames could have a little bevel and soot, closer to
     Frostpunk.
   - State 6's room brightness: .36 now, or about .42 so the room stays
     readable?
   - The state 4 option costs could go bold, and Commit could dim under
     the state 5 review (re-check notes above).

## New art needed (grim art)

These icons still read as cartoony after toning, at 1920:

- **The glossy round resource orbs:** doom, reputation, money, compute,
  research and paper.
- **PLAN's `ui_config_date_64`:** a tear-off calendar with "17", the motif
  Alex called corny. It wants a ledger or a typed-sheet glyph.
- **Bright, toy-like:**
  - Fundraising (`ui_guide_resources_64`, a money bag);
  - Financing (`action_funding_loan_64`).
- **Saturated glow that survives toning:**
  - Strategic (`ui_guide_strategy_64`, a chess knight);
  - Scouting (`employee_status_investigating_64`, a glowing eye).
- **A's five flat placeholders:** inbox tray, feed tape, advertise notice,
  travel suitcase and publicity megaphone. They need real art.
- **The office cat (`office_cat_doom-cat.webp`):** a painted, cute cat. It
  fits as a toned photo print, but a darker, grainier photo would suit
  better. Pip's cat doom variants do not exist yet.
- **Maybe Staff and Hire,** if open question 2 says yes.

## Bugs and data gaps (unchanged from hifi)

- Office Maintenance charges and does nothing.
- Advertise a Role and Work Your Connections have empty `costs` in
  core.json.
- Today's game shows no warning when research goes below zero; the
  mock-ups show one.
- Today's UI refuses the operating -> planning spill that ADR-0011 and the
  game core allow; the mock-up follows the ADR.

## Disk

- **Committed in `fork/design/hifi2/` (3.8 MB):**
  - H: `concept.html`, `notes.md`, `assets/` (0.4 MB) and six WebPs (1.6
    MB);
  - `before/`: hifi A and G WebPs, 1.6 MB;
  - the showcase, the gallery page and its list, the briefs, and the
    council files.
- **Deleted:** the hifi run's full-size PNG renders,
  `fork/design/hifi/*/s*.png` (53 MB, never committed). Their WebPs stay.
- **Uncommitted on the box (can go when Alex is done with them):**
  - `fork/design/hifi2/H/s1..s6.png` and `s1-720..s6-720.png`: 16 MB.
  - `fork/design/research/_dropped-refs/`: 9.1 MB, the culled third-party
    shots. Excluded via `.git/info/exclude`.
  - `fork/design/research/*/shots/frostpunk-menu-1..8.jpg`: 5.7 MB,
    third-party. Excluded.
- **Scratch:** the orchestrator's and the designer's temporary renders are
  deleted. The disk is 57% used.

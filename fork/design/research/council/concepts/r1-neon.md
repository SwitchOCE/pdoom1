VERDICT: SHORTLIST C A E

## Score table

| Concept | Flavour | Usability | Pip fit | Scope | Overall |
|---|---:|---:|---:|---:|---:|
| C. The Paperwork Desk | 9 | 9 | 9 | 9 | 9 |
| A. The Desk | 9 | 8 | 9 | 9 | 9 |
| E. Rooms and Stations | 8 | 8 | 8 | 7 | 8 |
| F. Pure Terminal | 7 | 8 | 8 | 7 | 7 |
| B. The Mainframe OS | 6 | 7 | 6 | 8 | 7 |
| D. The Card Table | 8 | 5 | 6 | 4 | 6 |

## Full ranking (best to worst)

1. **C. The Paperwork Desk (9/10)** -- Strongest Papers, Please tactile identity, exact queue math and WATCH accounting, built-in queue reordering, and the only concept that executes Pip's look-back Month Review ledger; only needs small surgical fixes.
2. **A. The Desk (9/10)** -- Best single-screen synthesis of a glowing CRT, hardware dials/counters, action slips, pull-out Upgrades drawer, and chair-swivel WATCH view; needs queue reorder controls and a few visual/data cleanups.
3. **E. Rooms and Stations (8/10)** -- Best direct test of Alex's multi-room/multi-flow direction with flawless 16px+ type discipline and Pip's office sprites, held back by an 11h-vs-12h math bug, a dead locked rack in WATCH, and two unrendered stations.
4. **F. Pure Terminal (7/10)** -- Razor-sharp Norton/Hacknet terminal craft that closely matches Pip's ASCII/CRT aesthetic, but feels the least "in an office" and lacks queue reordering plus several scope/data fixes.
5. **B. The Mainframe OS (7/10)** -- Solid Win98 directory and Procurement view, but feels beige/corporate rather than ominous-office, has a rough purple-ghost WATCH silhouette with no playback controls or in-flight queue, and leaves large dead wallpaper gaps.
6. **D. The Card Table (6/10)** -- Ambitious Cultist Simulator card-table look with the only matching action icons, but fails hardest on scope (invented/wrong M5 actions and costs, door in queue), drops the silhouetted operator in WATCH, locks slots 6-9 out of reordering, and uses 32 sub-16px CSS rules.

## Defects per concept

### A. The Desk
- **Missing queue reorder controls (`m5.png`, center CRT queue `01..09`):** Each row only has `[x]` to remove; no up/down priority reorder buttons exist, missing Pip's queue-order-as-priority mechanic. Also no `Undo` / `Clear` buttons on the CRT.
- **Calendar clips July 30 and 31 (`m1.png`, top-left wall calendar):** July 2017 starts Saturday (6 rows needed), so days `30` and `31` are clipped off the bottom of the calendar pad.
- **Folder queue-count mismatches (`m5.png` & `door.png`, bottom action tray):** `Financing` badge reads `2 in plan` while only 1 Financing action (`07 Pay the Bill`) is queued. `Scouting` reads `3 in plan` (distinct actions) while inside `door.png` its slips read `4 in plan`, `1 in plan`, `2 in plan` (7 plays) -- mixed counting units.
- **Sub-16px operational text (`m1.png`, `m5.png`, `door.png`, action cards & CRT headers):** Blocked stamps `.slip-st` (`NO PLANNING HRS LEFT`, `NEEDS 10 RESEARCH`, `COMING SOON`), category tabs `.slip-tab`, `.clip` (`2 in plan`), `.pin-o`/`.pin-done`, and `.q-h`/`.uw-h` are `14px` (below the 16px operational floor).
- **Untyped/missing action costs (`m1.png`, `m5.png`, action tray):** `Work Your Connections` prints untyped `2 hr . 6 rep` (no `plan`/`op` label) and stays playable at 0 planning hours; `Onboard New Hires` omits its cost entirely.
- **Floating glow rectangle behind operator (`watch.png`, center behind silhouette head):** `.desk-glow` renders a sharp-edged rectangular translucent tan box floating in mid-air over the office floor photo.
- **Stale cash in WATCH (`watch.png`, right hardware counter):** Day 14 marks `01 Go to Meetups` (`$300`) and `02 Hire: Safety Researcher` (`$60,000`) as `[DONE]`, yet Money remains `$140,000`.
- **Minimal office visibility in PLAN (`m1.png`, `m5.png`):** Hardware panels cover nearly the whole frame in PLAN, leaving the office mostly at the outer edges until WATCH.

### B. The Mainframe OS
- **Left-aligned glyphs inside square Reserve buttons (`m1.png`, `m5.png`, top bar `RESERVE 0 h - +`):** `-` and `+` hug the left edge of their 30x27 buttons instead of centering (inherited button alignment).
- **Weak/incomplete WATCH screen (`watch.png`, full frame):** Operator silhouette is a blurry, semi-transparent purple cutout over the office photo; no playback controls (`Pause`, `1x/2x/4x`); no in-flight queue progress bars; huge blank cream void in the Mail body; taskbar drops `PROCUREMENT` and replaces the `Commit the month` button slot with plain unboxed text `Paused for reply`.
- **Large dead desktop voids (`m1.png`, `m5.png`, `place2.png`, right column & below Procurement):** ~350px empty wallpaper gap between `STAFF` and `MAIL` in PLAN, and ~300px empty strip below `PROCUREMENT` in `place2.png`.
- **Missing blocked state on `Hire Staff` (`m5.png`, left Action directory):** Still shown as open/active with no blocked indicator despite `PLANNING 0 / 12 h free` (all 7 hiring roles cost 1 plan hr).
- **Collapsed `06-15 Read the Literature x10` row (`m5.png`, center queue):** Splits `03 Read the Literature` from `06-15 x10` and collapses 10 plays under one reorder control. No opened-door view rendered.
- **Sub-16px labels and non-ASCII entities (`m1.png`, `m5.png`, `place2.png`, `watch.png`):** 11 CSS rules at `14px`/`15px` including `.bar-label`, `.instrument-label`, `.action-group`, `.runway-head` (`14px`) and `.stat-label`, `.deficit`, `.proc-headers`, `.table-head` (`15px`). Uses Unicode entities (`&#8593;`, `&#9656;`, `&uarr;`, `&darr;`, `&times;`).

### C. The Paperwork Desk
- **Paperclip overlaps `NEEDS ANSWER` stamp (`watch.png`, top-right of arriving memo):** `.ev-clip` (`left: 470px`) crosses directly over the left border of the red `NEEDS ANSWER` stamp box.
- **Wrong `NONE AFFORDABLE` stamp on `Strategic` (`m5.png`, bottom-left of card file):** In `godot/data/actions/strategic.json`, `Corporate Espionage` costs `$100,000 + 3 op hr + 20 rep`, which is affordable with `$140,000`, `5 op hr`, and `32 rep`.
- **Missing `rising` indicator on `P(DOOM)` (`m5.png`, top center counter):** Brief requires `40.2% rising`; C shows `40.2%` plus `lose at 100%` (minor permanent rule text) without `rising`.
- **Sub-16px operational text (`m1.png`, `m5.png`, `door.png`, `watch.png`):** 37 CSS rules sit at `14px`/`15px`, including operational elements: `.stamp` blocked reasons (`15px`), `.cf-onf` badges (`14px`), `.key` hotkey caps (`15px`), `.fm-hl` hour-pool labels (`15px`), `.fm-no` queue numbers (`15px`), and `.cf-card.folder::before` (`14px`/`15px`).
- **Tight spacing & collision hazards (`m5.png`, Form A-20 & card file):** In `UNDER WAY -- CARRIED FORWARD`, `lands mid-Dec 2017` and `decision ~Jan 2018` sit ~4px from the `NOV` vertical gantt rule; on `Hire Staff`, the `on form 1` pill crowds the folder title (longer folder names would collide, as noted in `notes.md`); `Onboard New Hires` omits its cost in `m1.png`.
- **Redundant office thumbnail in top bar (`watch.png`, `place2.png`, top-right beside P(DOOM)):** Once the player looks up into the full-screen office, the miniature office window in the top bar duplicates the background.
- **Upgrades/Staff drawers not rendered as PNGs:** `place2.png` renders the October Month Ledger (valuable), leaving Upgrades and Staff views unshown in static renders.

### D. The Card Table
- **Invented and wrong M5 queue actions/costs (`m5.png`, `THE MONTH AHEAD` slots `#04..#09`):** `SLOT #04 Apply for Grant (2 plan hr)` contradicts `fundraising.json` (`Research Grant`, `1 plan hr + 1 paper`, unaffordable at 0 papers); `SLOT #05 Pitch Investors (3 plan hr)` is invented (`Modest`/`Major Funding Round` are 1/2 op hr + rep); `#7 Strategic (2 pl)` puts a door in the queue; `#8 Office Lease (2 pl)` doubles the real `1 plan hr` lease cost. Also `Work Your Connections` changes from untyped `2 hr` (`m1.png`) to `2 op hr` (`m5.png`).
- **Slots `#06..09` cannot be reordered or removed (`m5.png`, 6th queue card):** Collapsing plays 6-9 into a read-only summary card removes `< >` and `[x]` controls, breaking queue priority ordering.
- **No silhouetted operator in WATCH (`watch.png`, center-bottom):** Shows only an empty office chair back from the background image, losing Pip's core UI image.
- **32 sub-16px CSS rules on operational UI (`m1.png`, `m5.png`, `place2.png`, `watch.png`):** Includes `.ct-card-foot` blocked reasons (`14px`), `.ct-card-band` door/action tags (`14px`), `.ct-sc-cost` queued costs (`15px`), `.ct-stack-row` (`14px`), `.wt-choice-cost` event choice costs (`14px`), and `.cr-need-tag` upgrade blockers (`14px`).
- **Layout, badge, and state glitches (`m5.png`, `place2.png`, `watch.png`):** Orphan wraps (`1 plan hr -- 10` / `Res` on all 3 Research cards; `5 plan hr -- 2 op` / `hr` on `SLOTS #06..09`); internal `M5` tags printed on `Safety Audit` and `Strategic`; missing `IN PLAN` badges on `Office` and `Strategic`; `watch.png` keeps `MONEY $140,000` after `Go to Meetups (-$300)` completes and leaves `RESEARCH QUALITY` active; top bar `[3] WATCH` tab breaks PLAN -> Commit -> WATCH gating; `place2.png` Liability Ledger invents `Monthly Payroll & Lease -$14,500`; near-black flat fills (`#0e0614`, `#14100d`).

### E. Rooms and Stations
- **Queue math mismatch (`m5.png`, center CRT `THE MONTH AHEAD` vs top bar `ATTENTION`):** The 12 queued rows total **11 planning hours** (`1+1+2+1+1+1+1+2+1 = 11`, plus `3 op hr`), yet the top bar shows all 12 PLAN boxes spent (`0 left`). Footer `$112,300 committed` also omits `+ 21 rep`.
- **Missing `rising` indicator and incomplete Reputation scale (`m5.png` & `m1.png`, top bar):** `P(DOOM)` shows `40.2%` without `rising`; `REPUTATION` dial labels `0` but omits `100`.
- **Locked `ACTIONS` rack wastes 28% of WATCH (`watch.png`, left column):** Keeping the greyed-out `LOCKED UNTIL MONTH END` action list onscreen during WATCH crowds out the office/floor spectacle. Also Money (`$140,000`) and Reputation (`32`) stay stale on Day 9 despite `Hire: Safety Researcher` (`$60,000`), `Go to Meetups` (`$300`), and `Work Your Connections` (`6 rep`) being `[x] done`.
- **Action-rack defects (`m1.png`, `m5.png`, left column):** `Hire Staff` is not marked blocked at 0 planning hours; `Onboard New Hires` omits its cost in both views; `Scouting`'s orange `OPEN` tab protrudes ~14px outside the right panel border in `m5.png` while `Strategic` sits tight on the bottom edge; `m1.png` leaves ~120px empty dark brown space below `Scouting`.
- **Typed event reserve in WATCH (`watch.png`, top bar & memo):** Top bar prints `HELD 5h OPS` and the memo prices choices in `2h OPS` / `1h OPS`, whereas held event hours in P(Doom)1 are untyped reserve/unspent hours.
- **Incomplete stations & sparse Lab Floor (`place2.png`):** `F3 PROCUREMENT` and `F4 RECORDS` are not drawn; `F2 LAB FLOOR` leaves a ~550px empty center gap and renders a very bare flat-green `CAM 1 . FLOOR` sprite box.
- **Inverted Attention fill semantics (`m1.png`, top bar):** Filled = spent and empty = free, so `m1.png` shows 12 empty PLAN boxes that can briefly read as 0 until you read `12 left`.

### F. Pure Terminal
- **Missing queue reorder controls (`m5.png`, center `THE MONTH AHEAD`):** Rows `01..11` only provide `[x]` remove; no up/down priority reorder controls.
- **Scope/data issues (`m5.png`, `watch.png`):** `m5.png` queues `11 Send Delegation` as `1 plan` (`travel.json` has `costs: {}`) and `08 Accept Offer` (requires a pending offer); `Work Your Connections` (`2 hr, 6 rep`) and `Onboard New Hires` (`1 hr + money`) are untyped, and `Onboard New Hires` shows `ready` despite 0 planning hours left; `watch.png` draws Month 1 (`JUL 2017`) instead of Month 5 and leaves Reputation at `50` after `Work Your Connections` (`6 rep`) is `[x] DONE`; top-right `PLAN | WATCH` toggle implies switching to WATCH without committing.
- **Sub-16px operational text (`m1.png`, `m5.png`, `place2.png`, `watch.png`):** 24 CSS rules at `14px`/`15px`, including `.ac-key` hotkeys (`15px`), `.fo-row .why` blocked reasons inside the Scouting flyout (`14px`), `.pl-btn i` (`14px`), `.cmt span` (`14px`), `.st-flag` (`[!] BELOW 0`, `14px`), and `.if-row .s` (`14px`).
- **Low "office with computers" warmth & minor rule labels (`m1.png`, `m5.png`):** Dense monochrome terminal panes with tiny CCTV windows feel drier than a physical desk/office; Threat Board prints permanent rule labels (`only rises`, `100% = end`, `0 = end`), and accents use near-black `#0f0906`/`#160d08`.

## Blocking fix lists for shortlisted concepts

### C. The Paperwork Desk -- blocking fixes
1. **Fix paperclip overlap on `NEEDS ANSWER` (`watch.png`, top-right of memo):** Move `.ev-clip` left (e.g., `left: 410px` or top-left near `MEMO`) so it never crosses the red `NEEDS ANSWER` stamp border.
2. **Fix wrong `NONE AFFORDABLE` stamp on `Strategic` (`m5.png`, bottom-left of card file):** Remove `NONE AFFORDABLE` from `Strategic` in M5 because `Corporate Espionage` (`$100,000`, `3 op hr`, `20 rep`) is affordable at `$140,000`, `5 op hr`, `32 rep` (or state `2 op choices open`).
3. **Add `rising` state to `P(DOOM)` in M5 (`m5.png`, top-center counter):** Replace permanent `lose at 100%` (or move it out of the main bar) and show `RISING` alongside `40.2%` in M5 to match the brief (`P(Doom) 40.2% rising`).
4. **Raise operational text to >= 16px (`m1.png`, `m5.png`, `door.png`, `watch.png`):** Bump `.stamp`, `.key`, `.fm-hl`, `.fm-no`, `.cf-onf`, and `.cf-card.folder::before` from `14px`/`15px` to `16px` so nothing read to operate a control drops below the 16px floor.
5. **Fix tight collisions on Form A-20 gantt and `on form` pills (`m5.png`, Form A-20 bottom & card file):** Add >= 12px right padding between `lands mid-Dec 2017` / `decision ~Jan 2018` and the `NOV` vertical rule; anchor `.cf-onf` badges in a fixed corner slot (e.g., bottom-right) on all folder cards so `Hire Staff` and longer folder titles cannot collide.
6. **Show `Onboard New Hires` cost in M1 (`m1.png`, `PEOPLE` row):** Display `1 plan hr + money` above the `NOBODY HIRED` stamp in `m1.png` just as in `m5.png`, satisfying Must-hold #1.
7. **Remove redundant top-bar office thumbnail in look-up views (`watch.png`, `place2.png`, top bar):** Hide or repurpose the miniature office window in the top bar once the full-screen office background is active, and render a sample Upgrades/Staff drawer state (or note how `UPGRADES`/`STAFF FILE` open) before Alex's final pass.

### A. The Desk -- blocking fixes
1. **Add queue priority reorder controls and Undo/Clear (`m5.png`, center CRT `THE MONTH AHEAD`):** Add `^` and `v` reorder controls beside `[x]` on every queued row `01..09`, plus `[Z] Undo` and `[C] Clear` at the CRT footer so execution priority is directly editable.
2. **Fix July 2017 calendar clipping (`m1.png`, top-left calendar pad):** Increase calendar card height or tighten row line-height so row 6 (`30`, `31`) renders inside the pad without clipping.
3. **Fix folder count badges (`m5.png` & `door.png`, bottom action tray):** Change `Financing` from `2 in plan` to `1 in plan` (only `07 Pay the Bill` is queued), and reconcile `Scouting` (`3 in plan` vs `4 + 1 + 2 = 7` plays in `door.png`) so parent and child badges count the same unit.
4. **Raise operational card text to >= 16px (`m1.png`, `m5.png`, `door.png`):** Bump `.slip-st` blocked stamps, `.slip-tab`, `.clip`, and `.pin-o`/`.pin-done` from `14px` to `16px`.
5. **Type `Work Your Connections` hours and show `Onboard New Hires` cost (`m1.png`, `m5.png`, action tray):** Label `Work Your Connections` explicitly as `2 plan hr . 6 rep` (and stamp `NO PLANNING HRS LEFT` in `m5.png`) or `2 op hr . 6 rep` consistently across views; print `1 plan hr + money` on `Onboard New Hires` above its blocked stamp.
6. **Remove floating rectangular glow box in WATCH (`watch.png`, center behind silhouette head):** Hide `.desk-glow` in WATCH or replace it with a soft full-bleed radial ambient light so no hard rectangular edge floats over the office floor.
7. **Reconcile WATCH money readout (`watch.png`, right `MONEY` counter):** Update Day 14 cash from `$140,000` to `$79,700` to reflect `[DONE]` items `01 Go to Meetups` (`$300`) and `02 Hire: Safety Researcher` (`$60,000`).

### E. Rooms and Stations -- blocking fixes
1. **Fix M5 queue planning-hour math (`m5.png`, center CRT & top `ATTENTION` bar):** Add 1 planning hour to the M5 queue (currently 11h PLAN across rows 01-12, contradicting `0 left` / 12 filled boxes) and include `+ 21 rep` in the CRT footer total (`$112,300 + 21 rep committed`).
2. **Add `rising` indicator and Reputation `100` tick (`m5.png` & `m1.png`, top bar):** Show `RISING` on the `P(DOOM)` dial in `m5.png` and add the `100` endpoint label on the `REPUTATION` dial.
3. **Replace locked `ACTIONS` rack in WATCH and update Day 9 state (`watch.png`, left column & top counters):** Swap the dead `LOCKED UNTIL MONTH END` action list in WATCH for an office-floor / live-camera or expanded feed panel; update Money (`$79,700`) and Reputation (`26`) for `[x] done` actions; change `HELD 5h OPS` and event costs (`2h OPS`/`1h OPS`) to untyped held/reserve hours.
4. **Fix action-rack blockers, costs, and `OPEN` tab overflow (`m1.png`, `m5.png`, left column):** Mark `Hire Staff` blocked (`no planning hours`) in `m5.png`; show `Onboard New Hires` cost (`1h PLAN + money`) in both views; keep `Scouting`'s `OPEN` tab flush inside the `ACTIONS` panel frame instead of overhanging by ~14px, and add breathing room below `Strategic`.
5. **Render missing stations and tighten `LAB FLOOR` (`place2.png` + `F3`/`F4`):** Render `F3 PROCUREMENT` (Upgrades) and `F4 RECORDS` (Ledger + Guide) so the multi-station promise is verifiable, and enrich `F2 LAB FLOOR`'s `CAM 1` floor box and center composition so it does not leave a ~550px empty gap.

## Non-blocking notes

1. **Best hybrid path for Alex:** If Alex loves **C**'s Papers, Please form/stamp/ledger flow AND **A**'s glowing CRT/brass-dial desk feel, **A**'s CRT-plus-desk PLAN screen pairs naturally with **C**'s Month Ledger review slip and look-back `[Esc]` flow without changing either layout's core grammar.
2. **Silhouette polish across shortlist:** All three shortlisted concepts (A, C, E) use clean placeholder geometric silhouettes; swapping in one shared, subtly lit operator-and-chair asset later will immediately elevate WATCH across whichever concept wins.
3. **Late-phase action scaling (17+ actions):** Both **A** (two 9-card rows) and **C** (5x4 card file) note that post-M5 phase unlocks will need a third row or second drawer; keeping category tabs/drawers extensible now will save rework when Entity/Titan actions arrive.

## Disk report

- Answer file written: `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r1-neon.md`
- Scratch files written outside `research/` and `pdoom1/` (in `C:/Users/keech/.t3/userdata/providers/antigravity/ac0a3dfd6dddb20962cecff6ee5fe65e19d3923be20e52c5ab52ff877f7e4c32/antigravity-acp/brain/0a82ea1d-5ed7-4a08-b506-5c724e2456ca/scratch/`):
  - `audit.py` (2,791 B)
  - `audit2.py` (2,142 B)
  - `audit3.py` (2,916 B)
  - `make_crops.py` (1,151 B)
  - `crop_A_cal_m1.png` (50,405 B)
  - `crop_A_watch_head.png` (327,246 B)
  - `crop_B_reserve_m5.png` (37,853 B)
  - `crop_C_cards_m5.png` (85,052 B)
  - `crop_C_gantt_m5.png` (98,299 B)
  - `crop_C_memo_watch.png` (102,012 B)
  - `crop_D_cards_m5.png` (308,300 B)
  - `crop_D_slots_m5.png` (111,116 B)
  - `crop_E_bottomleft_m5.png` (58,948 B)
  - `crop_F_flyout_m5.png` (46,057 B)
  - Total scratch size: 1,234,288 B (~1.18 MiB).
- Can be deleted: all 14 files in the scratch folder above can be deleted safely; nothing under `research/concepts/` or `C:/Users/keech/Documents/pdoom1` was modified.

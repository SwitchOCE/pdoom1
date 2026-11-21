# Round 2 (Simplify) Consensus -- neon

Reviewed all six Round 2 reviews (`r2s-opus.md`, `r2s-sol.md`, `r2s-neon.md`, `r2s-G-opus.md`, `r2s-G-sol.md`, `r2s-G-neon.md`).

## 1. Agreed Attention-Bar Convention (All Four Concepts)

**Rule: filled = hours remaining (free/left); empty = hours spent.**

Why this convention beats "filled = spent":
- Every concept pairs the bar with a remaining-hours label (`0 of 12 free`, `5 of 8 free`, `0 left`, `5 left`, `12 left`). When the label says `0 left`, an empty bar agrees with the number; when Month 1 starts with `12 left`, a full bar reads as a full pool ready to spend. Showing 12 bright solid amber pips beside `0 left` (as `E/plan.png` and `G/home.png` currently do) reads backwards at a glance.
- Three of four concepts already use **filled = remaining** on Home (`A/home`, `A/plan`, `C/home`, `C/plan`, `E/home`, `E/home-m1`). Adopting it everywhere means only `E/plan.png` and `G` need to flip.

## 2. Responses to Peer Blocking Fixes (Per Concept)

### A. The Desk
- **opus A1** (two plates look selected on `plan.png`; `ACTIONS` lit on `home.png`/`home-m1.png`): **Agree.** Only the currently open menu should carry the active style.
- **sol A1** (shrink home CRT/Commit housings; move play count, spend total, and reserve off home): **Non-blocking.** A's home is already ~69-70% art+empty; keeping total spend and held hours on home satisfies Must-hold ("costs readable before commit").
- **sol A2** (`Hire Staff` needs `Open` affordance at 0 plan hr; add research requirements to the 3 blocked research cards; show `0 plan / 5 op free` in `actions.png`/`door.png` header): **Agree.** Matches `neon A2` on the header and catches two genuine affordability/reachability gaps.
- **sol A3** (restore Reserve `-`/`+` in `plan.png`; single `Esc` target and clear `Enter` ownership in `door.png`): **Agree.** Matches `neon A1` on Reserve and fixes the dual `Esc`/`Enter` focus clash.
- **neon A3** (peeking red corner of `NOVEMBER 2017` calendar behind top-left CRT bezel in `plan.png`): **Keep blocking** (clean overlap defect).

### C. The Paperwork Desk
- **opus C1** (menus cut through desk objects in `plan.png`, `actions.png`, `door.png`): **Agree.** Matches `neon C4` (duplicating Attention boxes in `plan.png` and leaving slivers under menus).
- **opus C2** (inconsistent key-cap corners on `home.png`): **Agree.** Simple visual consistency fix (bottom-right on every shortcut).
- **sol C1** (move Compute/Papers off home accounts slip; drop counts from Staff/Upgrades cards; drop spend from Schedule preview): **Disagree / non-blocking.** C's home is already ~76-80% art+empty; the slim 4-stat slip (~1.5% area) keeps negative Research and cash visible on home, and the Schedule total satisfies "costs readable before commit".
- **sol C2** (inset focus highlight on open `Scouting` card in `door.png`; single `Esc` cue; expose `Onboard` next-step costs): **Agree** on inset focus highlight + single `Esc` cue (matches `neon C4`). **Non-blocking** on `Onboard` next-step drawer (0 hires awaiting onboarding in November; top-level cost/blocker is already honest).
- **sol C3** (replace stale `5 of 8 free` in `watch.png` with untyped `Held for events: 5 hr`; raise `15px` operational labels to `>= 16px`): **Agree.** Exact match with `neon C1` and `neon C2`.
- **neon C3** (missing `Hire Staff` source label on Form A-20 row 2 in `plan.png`): **Keep blocking** (1-word data consistency fix).

### E. Rooms and Stations
- **opus E1** (E's home bars contradict `plan.png`; fill home bars with hours spent): **Different fix (blocking).** Agree the internal contradiction is blocking (`neon E1`), but flip `plan.png` to **filled = hours remaining** per Section 1.
- **sol E1** (add research requirements to the 3 research blockers in `actions.png`; explicit `Add` control + focus state on `Go to Meetups` slip in `door.png`; single `Esc` + clarify `Enter` vs Commit): **Agree.** Overlaps `neon E4` on `Esc` and fixes real actionability/focus gaps.
- **sol E2** (expandable repeat rows `x8`/`x3` in `plan.png`; change `"committed"` to `"queued"` while editable; clarify `5 rows (14 plays)` unit in `watch.png`): **Agree.** Serves Must-hold (individual order/edit clarity) and prevents misleading "committed" copy.
- **neon E2 / E4** (show cash on hand `$79,700` in `watch.png`; show `$60,300 + 6 rep` and `Held for events: 5 hr` on `home.png`): **Keep blocking.** Both directly serve Must-hold ("costs readable before deciding/committing") with 1-2 short text lines on existing cards.
- **neon E3** (expose `01 Nov` batch results / Feed in `watch.png`): **Downgrade to non-blocking** to stay tight to scope and avoid asking for a new menu.

### G. The Existing UI, Modernised
- **opus G1 / sol G2** (6 empty icon boxes in `actions.png`; mismatched handshake icon on `Travel & Conferences`): **Agree with opus G1 (blocking).** Drop the icon column on all rows until every action has a fitting icon; this fixes the 6 broken-looking empty boxes (`neon G4`), removes the mismatched `Travel` icon (`sol G2`), and gives dense rows breathing room.
- **opus G2 / G3 / sol G3** (dual `[Enter]` in `actions.png`; triple `[Esc]`; `Staff [E]` vs `[E] Shoo It Away` clash in `watch.png`): **Agree.** Exact 3-way consensus with `neon G1`; renumber WATCH choices `1 / 2 / 3` and suppress background `[Enter]`/`[Esc]`/`[E]` while a detail/drawer/event modal owns focus.
- **opus G4 / sol G1** (dead right half of Month-1 `P(DOOM)` card in `home-m1.png`): **Agree.** Exact 3-way consensus with `neon G7` (center gauge or narrow the Month-1 card; no teaching prose).
- **sol G1** (strip lower-priority resources, under-way rows, and reserve off home; fix hardcoded sparkline coordinates): **Disagree / non-blocking.** Keeping today's full top bar and right card is what makes G recognisable as `main.tscn`. Agree on fixing the missing `+ 6 rep` on the right-hand `THIS MONTH` total (`neon G5`); treat hardcoded mockup sparkline points as **non-blocking** (implementation note to bind live `doom_history`).
- **sol G2** (show missing research alongside `no planning hours left` on the 3 research rows in `actions.png`): **Agree.** Consistent with A and E.
- **sol G3 / neon G6** (`PLAN | WATCH [V]` switch in banner): **Agree (merged fix).** Replace the pre-commit `PLAN | WATCH [V]` toggle with a passive phase indicator (or clearly disabled `WATCH` state until committed) and disable `[V]` during WATCH event modals so it never implies skipping Commit.
- **sol G4** (expandable `x6`/`x2` repeat rows in `plan.png`; move `~Jan 2018` off the `FEB` grid line; raise `14px`/`15px` operational type in `plan.png`/`upgrades.png`/`home.png` to `>= 16px` and boost `Can't afford` contrast): **Agree.** Matches `neon G3` and `neon G8` plus adds individual-play editability matching E.
- **sol G5** (remove `"20 hr held for events"` from first WATCH feed line): **Non-blocking.** A dated commit log entry recording starting held hours is distinct from the live Attention meter (which decrements as events resolve).
- **neon G2** (invert G's Attention pips to **filled = hours remaining**): **Keep blocking** per Section 1.

## 3. Proposed Joint Ranking (A, C, E, G)

Individual means: **E 8.33** (`8.5, 8.5, 8.0`), **A 8.00** (`8.0, 7.5, 8.5`), **C 8.00** (`7.5, 8.0, 8.5`), **G 7.33** (`7.5, 7.0, 7.5`).

1. **E. Rooms and Stations** -- Highest art+empty share (~81-82%), fewest things to read on home, and the clearest answer to Alex's simplify steer; all remaining issues are quick in-place fixes.
2. **A. The Desk** -- Strongest diegetic craft (CRT + hardware dial + Commit seal), cohesive WATCH handoff, and zero menu-overlap defects; narrowly edges C on current polish.
3. **C. The Paperwork Desk** -- Best full-plan readability (Form A-20) and ~76-80% open office; ties or edges A once its desk-band overlay and WATCH clipboard regressions are fixed.
4. **G. The Existing UI, Modernised** -- Lowest-risk incremental upgrade directly mapped to today's `main.tscn` nodes and best Watch data accuracy, but busiest home (~66% art) and least diegetic character.

## 4. Joint Blocking Fix Lists (Merged & De-Duplicated)

### A. The Desk (5 fixes)
1. **Single active plate style** (`home.png`, `home-m1.png`, `plan.png` -- bottom shortcut rack): Show the lit "open" state only on the currently open menu (`PLAN` in `plan.png`, none on `home.png`/`home-m1.png`; if highlighting a suggested first step on home, use a clearly distinct style).
2. **Restore Reserve `-` / `+` controls** (`plan.png` -- CRT `RESERVE 0 hr` row): Add working `-` and `+` adjustment controls beside `0 hr` so reserve hours can be changed in the flow.
3. **Show Attention and full blockers in Actions** (`actions.png`, `door.png` -- `THE HAND` header & action cards): Add `PLAN 0/12  OP 5/8` to the drawer header; restore an explicit `open` affordance on `Hire Staff` even at 0 planning hours; add missing research requirements (`needs 10/20 research`) alongside `NO PLANNING HRS LEFT` on the 3 research cards.
4. **Single `Esc` and clear `Enter` ownership** (`door.png` -- `THE HAND` header, `SCOUTING` slip, `COMMIT` button): When `SCOUTING` is open, show `Esc` only on the foreground folder (`back to Actions`), and suppress `Enter` on `COMMIT` while the active slip owns `Enter`.
5. **Clear peeking wall calendar** (`plan.png` -- top-left CRT bezel corner): Hide `NOVEMBER 2017` while `plan` is open or shift the CRT clear so no red corner peeks behind the bezel.

### C. The Paperwork Desk (5 fixes)
1. **Stop menus cutting across desk objects** (`plan.png`, `actions.png`, `door.png` -- bottom desk band): Either end open menus cleanly above the desk line or dim/cover the whole desk band so the Schedule clipboard, Action Cards, Ledger, and Guide never peek through or duplicate Attention bars.
2. **Fix WATCH clipboard stale hours** (`watch.png` -- bottom-left `SCHEDULE` clipboard): Replace `PLANNING 0 of 12 free` / `OPERATING 5 of 8 free` with spent counts and a single untyped `Held for events: 5 hr` readout.
3. **Raise `15px` operational type and unify home key-cap corners** (`home.png`, `plan.png`, `watch.png` -- Schedule labels, accounts slip labels, Form A-20 row numbers/headers, home shortcut cards): Bump all `15px` operational labels/numbers to `>= 16px`, and place every home shortcut key cap in the same corner (bottom-right).
4. **Fix open-folder highlight and duplicate `Esc`** (`door.png` -- `Scouting` source card, `ACTION CARDS` header, `SCOUTING` folder): Use an inset/wrapper focus ring on the `Scouting` card so `clip-path` does not clip it off, and show `[Esc]` only on the foreground `SCOUTING` folder.
5. **Restore missing source label on Form A-20 row 2** (`plan.png` -- Form A-20 row 2 `Hire: Safety Researcher`): Print `Hire Staff` beside `Hire: Safety Researcher` to match rows 1, 3, and 5-14.

### E. Rooms and Stations (5 fixes)
1. **Unify Attention bars to "filled = remaining"** (`plan.png` -- CRT Attention bars): Flip `plan.png` bars to fill remaining hours (`0 left` = empty, `5 left` = 5/8 filled) so `home.png`, `home-m1.png`, and `plan.png` use the same convention as A, C, and G.
2. **Show spend and held hours on Home; show cash in WATCH** (`home.png` -- `THIS MONTH` / `COMMIT` area; `watch.png` -- event card or `DAY 9` card): Add total queued cost (`$60,300 + 6 rep`) and `Held for events: 5 hr` on `home.png` before Commit, and display `In hand: $79,700` on `watch.png` so `$25,000` event choices are checkable.
3. **Complete blockers and `Add` affordance in Actions/Door** (`actions.png` -- 3 research rows; `door.png` -- `Go to Meetups` slip): Show missing research requirements alongside `no planning hours` on the 3 research rows, and add an explicit `Add` control + focused state on `Go to Meetups`.
4. **Single `Esc` and clear `Enter` ownership** (`door.png` -- `Back to desk`, `OPEN: SCOUTING`, `COMMIT THE MONTH`): Show `[Esc]` only on `OPEN: SCOUTING` while the folder is open, and suppress/dim `[Enter]` on `COMMIT THE MONTH` while the playable choice owns focus.
5. **Clarify repeat-row editing and queue/watch units** (`plan.png` -- `x8`/`x3` rows and footer; `watch.png` -- `DAY 9` card): Add an expand toggle/cue on stacked rows so individual plays can be removed/reordered in sequence, change `"committed"` to `"queued"` while editable, and label WATCH completion as `14 plays (5 rows) done`.

### G. The Existing UI, Modernised (7 fixes)
1. **Drop the inconsistent icon column** (`actions.png` -- left action list): Remove the icon column across all 17 rows (eliminating the 6 empty dark boxes and the mismatched `Travel & Conferences` handshake icon) until every action has a fitting icon; also show missing research requirements alongside `no planning hours left` on the 3 research rows.
2. **Resolve keyboard collisions and modal focus** (`actions.png`, `plan.png`, `upgrades.png`, `watch.png` -- detail card, drawers, left rail, `COMMIT`, Stray Cat slip): Suppress background `[Enter]` and `[Esc]` keycaps whenever a drawer/detail/event owns focus; renumber WATCH choices `1 / 2 / 3` (replacing `Q / W / E`) and dim background rail shortcuts (`Staff [E]`) during an event modal.
3. **Flip Attention pips to "filled = remaining"** (`home.png`, `home-m1.png`, `actions.png`, `plan.png`, `upgrades.png` -- bottom-right `ATTENTION` block): Fill pips for hours remaining (`12 left` = 12 filled, `0 left` = 12 hollow, `5 left` = 5 filled) to match A, C, and E.
4. **Fix Month-1 `P(DOOM)` dead half and banner phase switch** (`home-m1.png` -- top-right `P(DOOM)` card; all views -- `## PLAN` / `## WATCH` banner): Center the Month-1 ring gauge (or narrow the card; no teaching prose), and replace the pre-commit `PLAN | WATCH [V]` toggle with a non-clickable phase indicator (disabled in WATCH event modals) so it never implies skipping Commit.
5. **Show full `$110,300 + 6 rep` total on right-hand summary cards** (`home.png`, `plan.png` -- bottom-right `THIS MONTH` card): Include `+ 6 rep` alongside `$110,300` to match the `THE MONTH AHEAD` table footer.
6. **Raise `14px`-`15px` operational type and boost contrast** (`home.png`, `plan.png`, `upgrades.png` -- queue hours/costs, `x6`/`x2` chips, `UNDER WAY` dates, `Can't afford` button, upgrade descriptions): Bump all operational text/controls to `>= 16px` and improve `Can't afford` contrast in `upgrades.png`.
7. **Make repeat rows expandable and clear Gantt gridline overlap** (`plan.png` -- `x6`/`x2` rows and `UNDER WAY` `Paper decision` bar): Add an expand affordance on stacked rows for per-play editing, and shift `~Jan 2018` so it does not cross the vertical `FEB` column line.

## Disk Report

- Wrote only `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r2s-consensus-neon.md`.
- No new scratch files created this pass; prior scratch folder (~1.70 MiB across 20 files in `C:/Users/keech/.t3/userdata/providers/antigravity/ac0a3dfd6dddb20962cecff6ee5fe65e19d3923be20e52c5ab52ff877f7e4c32/antigravity-acp/brain/0a82ea1d-5ed7-4a08-b506-5c724e2456ca/scratch/`) can be deleted safely.

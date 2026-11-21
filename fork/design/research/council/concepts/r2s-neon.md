VERDICT: CHANGES NEEDED

# Council Round 2 (simplify) -- neon

All three concepts took Alex's feedback to heart: every home screen now breathes with 69-81% office art and negative space, puts Pip's office and operator front and centre, and moves detail cleanly into shortcut-driven menus. None needs another redesign, but each introduced 3-4 small blocking defects during the rework that should be fixed before Alex sees them.

## Summary table

| Concept | Art + empty % | Things to read on home | Simpler? | Score /10 |
|---|---:|---|---|---:|
| A. The Desk | ~69% | 6 groups (18 items: calendar, P(Doom), rep, CRT summary, 7 shortcut plates, Commit + held) | yes | 8.5 |
| C. The Paperwork Desk | ~76% | 11 UI objects (~21 items: calendar, 4-stat slip, P(Doom), rep, Action Cards, Schedule, 4 desk shortcuts, Commit + held) | yes | 8.5 |
| E. Rooms and Stations | ~81% | 6 groups / 10 objects (~16 items: calendar, P(Doom), rep, 5 station buttons, This Month note, Commit) | yes | 8.0 |

## Ranking

1. **A. The Desk (8.5/10)** -- Most complete and cohesive multi-view flow (`home`, `actions`, `door`, `plan`, `upgrades`, `watch`), blending CRT + hardware gauges + slips with the cleanest WATCH handoff (`in hand $39,700`, `FEED [F]`).
2. **C. The Paperwork Desk (8.5/10)** -- Best balance of vast office negative space (~76%) and smart pushback (keeping the slim 4-stat accounts slip on home), with working Reserve controls in `plan.png`; held just behind A by WATCH's `5 of 8 free` regression and 15px operational text regressions.
3. **E. Rooms and Stations (8.0/10)** -- Most cinematic, calmest home screen (~81% mezzanine office art) and flawless 16px+ type, but drops cash and feed results in `watch.png` and flips Attention bar fill semantics between `home.png` and `plan.png`.

## Blocking fixes per concept

### A. The Desk
1. **Restore Reserve `-` / `+` controls (`plan.png`, CRT `RESERVE 0 hr` row):** Round 2 dropped the Reserve adjustment buttons in `A/concept.html`, leaving no way to set aside reserve hours anywhere in the flow (Must-hold #2). Add `-` and `+` buttons beside `0 hr` on `plan.png` (and keep `home.png` read-only).
2. **Show remaining Planning / Operating hours inside Actions (`actions.png` & `door.png`, `THE HAND` top bar):** Opening `THE HAND` covers the bottom-left CRT, so the player sees Money/Compute/Research/Papers but cannot see how many planning vs operating hours are free (`0/12 plan`, `5/8 op`) while picking actions. Add `PLAN 0/12  OP 5/8` to the drawer header strip.
3. **Clear the peeking calendar behind the Plan CRT (`plan.png`, top-left bezel corner):** A red corner sliver of `NOVEMBER 2017` pokes out behind the top-left of the expanded CRT frame. Hide the wall calendar while `plan` is open or shift the CRT clear of it.

### C. The Paperwork Desk
1. **Fix WATCH `SCHEDULE` clipboard still claiming `5 of 8 free` (`watch.png`, bottom-left clipboard):** Prints `PLANNING 0 of 12 free` and `OPERATING 5 of 8 free` even though the month is committed (`Committed. 14 of 14 done.`) and those 5 unspent hours are now untyped event reserve (`01 Nov Held for events: 5 hr` on the teleprinter). In WATCH, display spent counts (`12 spent` / `3 spent`) and `Held for events: 5 hr` once, untyped.
2. **Fix 15px operational-text regressions (`home.png`, `plan.png`, `watch.png`):** `.hrow .l` (`PLANNING`, `OPERATING` on the Schedule clipboard), `.fm-no` (`1..14` row numbers on Form A-20), `.wl-acc span` (`MONEY`, `COMPUTE`, `RESEARCH`, `PAPERS`), and `.dk-sc .r` slipped to `15px`. Raise all operational labels and Form A-20 row numbers back to `>= 16px`.
3. **Restore source label on Form A-20 row 2 (`plan.png`, row 2 `Hire: Safety Researcher`):** Rows 1, 3, and 5-14 print their source folder (`Scouting`, `Financing`), but row 2 drops `Hire Staff`. Restore `Hire Staff` beside `Hire: Safety Researcher`.
4. **Resolve duplicate `[Esc]` hint and peeking desk strip (`door.png`, `plan.png`, `actions.png`):** In `door.png`, both `Close [Esc]` on `ACTION CARDS` and `Close folder [Esc]` on `SCOUTING` advertise `Esc` at once -- hide the outer `[Esc]` key cap while a folder is open. In `plan.png`, hide or cleanly cover the bottom edge of the home `SCHEDULE` clipboard peeking below Form A-20 so Attention boxes do not appear twice.

### E. Rooms and Stations
1. **Unify Attention bar fill direction (`home.png` / `home-m1.png` vs `plan.png`):** On `home.png` and `home-m1.png`, filled bars mean **hours free** (`PLAN` empty = `0 left`, `OPS` 5/8 filled = `5 left`), whereas on `plan.png`, filled boxes mean **hours spent** (`PLAN` 12/12 filled = `0 left`, `OPS` 3/8 filled = `5 left`). Use one consistent fill convention across every view.
2. **Show cash on hand during WATCH (`watch.png`, memo or `NOVEMBER 2017 . DAY 9` card):** `Talent Opportunity` asks for `$25,000 +1 held hr` on choices 1 and 2, but cash (`$79,700`) appears nowhere on `watch.png`, so the player cannot check affordability before answering. Display `In hand: $79,700` on the memo or Day 9 card.
3. **Keep feed / batch results reachable in WATCH (`watch.png`, full frame):** `watch.png` dims `ACTIONS` and `PLAN` and shows only `[x] 5 of 5 rows done 01 Nov` with no feed button, teleprinter, or batch outcomes. Add a `FEED` shortcut on the left stack (or list the 01 Nov outcomes on the Day 9 card) so the player can see what landed.
4. **Fix duplicate `[Esc]` hint in Door view and add commit summary on Home (`door.png`, `home.png`):** In `door.png`, hide `[Esc]` on `Back to desk` while `OPEN: SCOUTING` (`[Esc] Close`) is open. On `home.png`, show `Held for events: 5 hr` under `COMMIT THE MONTH` (and total committed spend `$60,300 + 6 rep` on `THIS MONTH`) so costs and held hours are readable before clicking Commit.

## Non-blocking notes

1. **C's slim accounts slip on Home is a win:** Keeping the 4-number slip (`Money`, `Compute`, `Research -12 [!]`, `Papers`) pinned unobtrusively at top-left costs ~1.5% of screen area while keeping negative research and cash visible on home; A and E could optionally borrow a tiny unobtrusive deficit flag on home, but both already show resources inside `Actions`.
2. **E's `UNDER WAY` gantt gridlines (`E/plan.png`):** `results mid-Dec` and `decision ~Jan` sit cleanly in dark pills over the `JAN 18` / `FEB 18` rules (readable, no letter collisions), though giving them a dedicated right-hand `DATE` column like A's `plan.png` would look even sharper.
3. **Shared operator silhouette asset:** All three home screens now showcase the operator silhouette prominently; replacing the three placeholder vector silhouettes with one painted/lit operator-and-chair asset in the art pass will elevate every concept at once.

## Disk report
- Wrote `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r2s-neon.md`.
- Added 3 round-2 verification crops in `C:/Users/keech/.t3/userdata/providers/antigravity/ac0a3dfd6dddb20962cecff6ee5fe65e19d3923be20e52c5ab52ff877f7e4c32/antigravity-acp/brain/0a82ea1d-5ed7-4a08-b506-5c724e2456ca/scratch/`:
  - `r2_crop_A_plan_top.png` (232,788 B)
  - `r2_crop_C_watch_sched.png` (82,385 B)
  - `r2_crop_E_plan_gantt.png` (113,410 B)
  - Round-2 scratch subtotal: 428,583 B (~419 KiB); cumulative scratch total across all rounds: 1,780,740 B (~1.70 MiB across 20 files). All scratch files can be deleted safely. Nothing under `research/concepts/` or `C:/Users/keech/Documents/pdoom1` was edited.

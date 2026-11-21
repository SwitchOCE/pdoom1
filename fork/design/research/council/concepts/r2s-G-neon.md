VERDICT: CHANGES NEEDED

# Council Round 2 Addition Review -- Concept G (neon)

Reviewed all 6 renders of **G. The Existing UI, Modernised** (`home-m1.png`, `home.png`, `actions.png`, `plan.png`, `upgrades.png`, `watch.png`), `G/before-m5.png`, `round2-before-after.png`, `G/notes.md`, `G/concept.html`, and game sources (`godot/scripts/core/upgrades.gd`, `godot/data/office/offices.json`).

## Summary Table (Round 2: A, C, E, G)

| Concept | Art + empty % (home) | Things to read on home | Simpler? | Score / 10 |
| --- | --- | --- | --- | --- |
| **A. The Desk** | ~69% | 6 groups (18 items) | yes | 8.5 |
| **C. The Paperwork Desk** | ~76% | 11 UI objects (~21 items) | yes | 8.5 |
| **E. Rooms and Stations** | ~81% | 6 groups / 10 objects (~16 items) | yes | 8.0 |
| **G. The Existing UI, Modernised** | ~66% | 11 elements (~22 items) | yes | 7.5 |

## Is G Recognisable as Today's Game?

**Yes -- immediately recognisable.** Compared side by side against `G/before-m5.png` (and in `round2-before-after.png`), G keeps the exact spatial grammar and chrome of `main.tscn`: full-bleed office art, dark steel top resource bar (`NOVEMBER 2017 | Money $140,000 | Compute 65 | Research -12 [!] | Papers 0 | Reputation 32 | Menu [Esc]`), `## PLAN` amber-scanline banner, top-right `P(DOOM)` ring gauge + sparkline, bottom-right `ATTENTION` / `THIS MONTH` / `UNDER WAY` card, bottom bar with `Feedback [N]` and `COMMIT THE MONTH > [Enter]`, and Pip's left-bound icon action list with ABBBCCC doors (`actions.png`). `G/notes.md` maps each change directly to existing `main.tscn` nodes, making G the lowest-risk incremental path to upstream to Pip.

It is also genuinely **simpler** than today's screen: stripping `TitleLabel`, duplicate `APLabel`, `GettingStartedHint`, `InfoBar`, `PhaseLabel`, `DoomExplanation`, inline Upgrades, inline Research Quality, and `CommandZone` ("Do Nothing") opens up ~66% of the frame to the office backdrop while keeping the top bar scannable and the queue compact (`x6` stacking, order preserved).

## Visual-Defect Pass & Must-Hold Check

- **What G gets right (best-in-class Watch data):**
  - Only Round 2 concept whose `watch.png` keeps the full top resource bar (Money `$245,000`, Compute, Research, Papers, Reputation), includes a live `FEED` (`Tue 4 Jul`, `Wed 12 Jul`), shows the exact `Stray Cat` costs (`$500, 1 held hr` / `$100, 1 held hr` / `free` per `window_resolver.gd:274`), and places `Stray Cat` on an eligible July workday (`Wed 12 Jul 2017`, turn 7).
  - Month replaces `"Turn 87"`, `Research -12 [!] ` is flagged clearly, and `upgrades.png` copy ("Flavour only for now.") matches `godot/scripts/core/upgrades.gd:23,44`.
  - All 17 actions are reachable via `Actions [A]` with inline costs and honest blocker reasons (`Strategic` has no false `NONE AFFORDABLE` stamp; `Onboard New Hires` accurately states `op hr + money, varies by step -- no hires awaiting onboarding`).
  - No permanent tutorial prose on the home screen; no mechanics changes; pure ASCII HTML/CSS with no `<14px` text.
- **Must-hold gaps and visual defects found:**
  - **Hotkey collisions (`actions.png`, `watch.png`, `plan.png`, `upgrades.png`):** Dual `[Enter]` in `actions.png`, triple `[Esc]` in `actions.png`, and `[E]` bound to both `Staff 1 [E]` and `[E] Shoo It Away` in `watch.png`.
  - **Inverted Attention pip polarity (`home.png`, `home-m1.png`, `plan.png`):** `Planning 0 left` displays 12 solid bright amber pips, while Month 1 `12 left` displays 12 hollow empty pips.
  - **14px-15px operational text (`home.png`, `plan.png`, `upgrades.png`):** Queue hours/costs (`.prow .hr`, `.prow .mo`, `.qrow .h`), stack badges (`.x6`), disabled upgrade buttons (`.ubtn.no`), and upgrade effect descriptions (`.urow .ds`) drop to `14px`-`15px`.
  - **Broken-looking empty icon boxes (`actions.png`):** 6 actions render empty `40x40` bordered dark squares where icons were omitted.
  - **Missing `6 rep` cost on summary cards (`home.png`, `plan.png`):** Right-hand `THIS MONTH` totals show `$110,300` without `+ 6 rep`, contradicting the `THE MONTH AHEAD` table footer (`$110,300 and 6 rep`).
  - **Pre-commit `PLAN | WATCH [V]` phase toggle (`home.png`, `home-m1.png`, `actions.png`, `plan.png`, `upgrades.png`, `watch.png`):** Implies free switching into `WATCH` before committing the month.
  - **Half-empty Month-1 `P(DOOM)` card (`home-m1.png`):** Right half of the card is blank dead space (also flagged unfixed in `G/notes.md`).
  - **Gantt label crossing column rule (`plan.png`):** `~Jan 2018` straddles the vertical `FEB` column divider.

## Ranking Among A, C, E, and G

1. **A. The Desk (8.5/10)** -- Strongest visual identity, warm focal Commit seal, clear `NOVEMBER PLAN` hierarchy, and ~69% breathing room with a silhouetted-operator WATCH view.
2. **C. The Paperwork Desk (8.5/10)** -- Cleanest tactile home composition (~76% art), sharp typographic hierarchy, and cohesive forms/folders flow.
3. **E. Rooms and Stations (8.0/10)** -- Most unobstructed art (~81%) and quietest home layout, with inline Reserve steppers and intuitive remaining-hours pips.
4. **G. The Existing UI, Modernised (7.5/10)** -- Most recognisable as today's game and strongest Watch telemetry/cost accuracy, plus the clearest Godot node migration path, but currently sits fourth on craft and polish due to ~66% art (busier double top bar + bottom bar) and 8 concrete UI defects below. Once those 8 defects are fixed, G is a strong low-risk candidate if Alex wants a direct incremental upgrade to `main.tscn` rather than a new diegetic shell.

## Blocking Fixes for G

1. **Resolve simultaneous hotkey collisions (`actions.png`, `watch.png`, `plan.png`, `upgrades.png`)**
   - *Where:* `actions.png` (`Add to plan [Enter]` on `Go to Meetups` vs `COMMIT THE MONTH > [Enter]` at bottom-right; `Menu [Esc]`, `ACTIONS x [Esc]`, and `Back [Esc]` all live at once); `watch.png` (`Staff 1 [E]` on left rail vs `[E] Shoo It Away` on the Stray Cat slip, plus `[Q]`/`[W]`/`[E]` event keys clashing with `Q` for Plan).
   - *Fix:* When a drawer or event slip has focus, dim/suppress background `[Enter]` and `[Esc]` keycaps (only the topmost focus target advertises `[Enter]`/`[Esc]`), and bind event choices in `watch.png` to `1 / 2 / 3` instead of `Q / W / E`.

2. **Fix inverted Attention pip polarity (`home.png`, `home-m1.png`, `actions.png`, `plan.png`, `upgrades.png`)**
   - *Where:* Bottom-right `ATTENTION` block (`Planning` and `Operating` pip bars in `G/concept.html:235,301-306`). Currently `0 left` renders 12 solid bright pips and Month 1 `12 left` renders 12 empty pips, which reads backwards against the `left` readout.
   - *Fix:* Fill pips for **remaining** hours (`12 left` = 12 filled, `0 left` = 12 hollow, `5 left` = 5 filled + 3 hollow) to match remaining-budget intuition and A/C/E.

3. **Eliminate 14px-15px operational text (`home.png`, `plan.png`, `upgrades.png`)**
   - *Where:* `plan.png` queue rows (`.prow .hr` and `.prow .mo` at `15px`; `.x6` stack chips at `14px`), `home.png` (`THIS MONTH` hours `.qrow .h` and `UNDER WAY` dates `.uw .d` at `15px`; `.x6` at `14px`), and `upgrades.png` (`.ubtn.no` `"Can't afford"` buttons and `.urow .ds` effect text at `15px`).
   - *Fix:* Raise queue hours, costs, stack counts, upgrade effect descriptions, and disabled `Can't afford` buttons to at least `16px`.

4. **Remove empty broken-looking icon boxes (`actions.png`)**
   - *Where:* Left-hand `ACTIONS` list (`Advertise a Role`, `Capability Research`, `Publish Safety Paper`, `Operations`, `Publicity`, `Strategic`) renders 6 empty `40x40` bordered dark squares next to 11 populated icons (`G/concept.html:374`).
   - *Fix:* Either populate those 6 slots with matching monochrome/category glyphs (or valid reused `prop_*` / `action_*` icons) or omit the empty bordered frame so they do not look like failed asset loads.

5. **Show full `+ 6 rep` cost on right-hand `THIS MONTH` summaries (`home.png`, `plan.png`)**
   - *Where:* Bottom-right `THIS MONTH` card in `home.png` (`+ 4 more rows -- $110,300 in all`) and `plan.png` (`14 plays in 7 rows | $110,300`), both dropping `6 rep` from `Work Your Connections` even though the `THE MONTH AHEAD` table total reads `$110,300 and 6 rep`.
   - *Fix:* Display `$110,300 + 6 rep` on both right-hand `THIS MONTH` cards so every non-zero resource cost is visible before Commit.

6. **Remove the pre-commit `PLAN | WATCH [V]` phase switcher (`home.png`, `home-m1.png`, `actions.png`, `plan.png`, `upgrades.png`, `watch.png`)**
   - *Where:* Top-right of the `## PLAN` / `## WATCH` banner (`PLAN | WATCH [V]` segmented toggle).
   - *Fix:* Replace the interactive `PLAN | WATCH [V]` switch with a non-clickable phase indicator (or reserve `[V]` strictly for view/camera toggle if one exists) so players are not led to think they can toggle into WATCH without clicking `COMMIT THE MONTH`.

7. **Fix the empty right half of the Month-1 `P(DOOM)` card (`home-m1.png`)**
   - *Where:* Top-right `P(DOOM)` card in `home-m1.png`, where omitting `RISING` and the 5-month sparkline leaves ~50% of the card as blank dark steel space.
   - *Fix:* Center the ring gauge in Month 1 or place a quiet baseline note (`Month 1 -- baseline`, `no trend yet`) in the right column.

8. **Keep the `~Jan 2018` Gantt label from crossing the `FEB` divider (`plan.png`)**
   - *Where:* Bottom of `THE MONTH AHEAD` -> `UNDER WAY` (`Paper decision` bar at `G/concept.html:412`), where `~Jan 2018` straddles the vertical `FEB` column grid line.
   - *Fix:* Anchor `~Jan 2018` inside the `JAN` column (e.g., right-aligned inside/above the bar end or shortened/shifted left) so it never crosses the `FEB` rule.

## Non-Blocking Notes (max 3)

1. **Reserve hours & Commit transparency (`plan.png`, `home.png`):** `Reserve hours [R]` in `plan.png` is currently a plain button without inline `- / +` steppers, and `COMMIT THE MONTH > [Enter]` on `home.png` does not state `5 hr held for events` (whereas `watch.png` shows `Held for events: 20 hr`). Adding inline `- / +` Reserve controls inside `plan.png` (or the `ATTENTION` block) and a small `Held for events: 5 hr` sub-line on Commit would close that loop without adding clutter.
2. **Dense repeated blocker copy in `actions.png`:** `"no planning hours left"` repeats 6 times in orange down the action list (also noted in `G/notes.md`). Grouping or shortening secondary blockers once `Planning 0 left` is already shown would make `actions.png` easier to scan.
3. **WATCH visual atmosphere (`watch.png`):** Unlike A, C, and E, G's `watch.png` reuses the exact same `office_wide_day.jpg` backdrop with no silhouetted operator or evening shift; keeping today's UI spirit is fine, though a subtle lighting shift (or dimmed action scrim) in WATCH would reinforce the phase transition from PLAN.

## Disk Report

- New scratch files written this pass: none (`0` bytes).
- Existing scratch folder from prior council rounds (`C:/Users/keech/.t3/userdata/providers/antigravity/ac0a3dfd6dddb20962cecff6ee5fe65e19d3923be20e52c5ab52ff877f7e4c32/antigravity-acp/brain/0a82ea1d-5ed7-4a08-b506-5c724e2456ca/scratch/`): 20 PNG/script files, ~1.70 MiB total (all safe to delete).
- Only deliverable written: `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r2s-G-neon.md`.

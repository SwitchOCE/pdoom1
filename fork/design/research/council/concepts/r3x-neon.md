VERDICT: CHANGES NEEDED

# Council Round 3 Review: Icons & Empty Office -- neon

Inspected all updated renders for **A, C, E, and G** at full 1920x1080 (`home`, `home-m1`, `actions`, `door` where present, `plan`, `upgrades` where present, `watch`), `round3-before-after.png`, all four `notes.md` Round 3 sections, audited every `concept.html` (`non-ascii: 0`, zero `< 16px` font sizes across all four), zoomed suspect icons at 64x64, and re-rendered `E/concept.html?view=plan&open=x8` and `G/concept.html?view=plan&expand=read` to verify scroll/icon fit.

Removing the black operator silhouette is a clear win across A, C, and E: the empty dimly lit office reads as far eerier and more atmospheric, and all four concepts left that space empty with no new UI filling it. Home screens remain sparse. Each concept has 1-3 concrete icon or icon-induced layout fixes before Round 3 is clean.

## Summary Table

| Concept | Icon matches ok (y/n) | Person-free (y/n) | Score / 10 |
| --- | --- | --- | ---: |
| **E. Rooms and Stations** | no | yes | 9.0 |
| **A. The Desk** | no | yes | 9.0 |
| **C. The Paperwork Desk** | no | yes | 8.5 |
| **G. The Existing UI, Modernised** | no | yes | 8.0 |

## Ranking

1. **E. Rooms and Stations (9.0/10)** -- Eeriest empty office of the four (empty mezzanine over dark glowing CRTs), uniform dark-tile icon framing across every view (including consistent per-action icons in `plan.png` and `watch.png`), and clean `open=x8` scrolling. One icon mismatch (`Travel & Conferences`).
2. **A. The Desk (9.0/10)** -- Equally strong hardware-desk craft, dramatically eerier without the silhouette, crisp Pip-matched custom SVGs (`new_*`), and spotless alignment across all 7 renders. One icon mismatch (`Read the Literature`).
3. **C. The Paperwork Desk (8.5/10)** -- Huge mood upgrade from dropping the wide foreground silhouette, with strong home and action-card icon coverage, held behind E and A by Form A-20 stamping the `Scouting` radar icon onto three distinct actions and two unframed cutout icons breaking set framing.
4. **G. The Existing UI, Modernised (8.0/10)** -- Great upgrade replacing the human-hand cat photo in `G/watch.png` with Pip's painted doom-cat (`web-doom-cat.jpg`), and solid Pip icon coverage, but `Staff` displays a smiley face (`resource_morale`), `Ledger` uses a gavel, and row icons cause `x6` to collide with `6 plan` (`x66 plan`) in `plan&expand=read`.

## Per-Concept Check & Blocking Fixes

### A. The Desk (1 blocking fix)
- **No person:** Yes -- completely removed from all 7 views (`home`, `home-m1`, `actions`, `door`, `plan`, `upgrades`, `watch`). Empty floor reads as eerie and stays open.
- **Visual-defect pass:** Clean across all 7 views (`>= 16px` everywhere, zero overflow/clipping, consistent tile sizes per group, custom SVGs match Pip's dark-tile look closely).
- **Blocking fixes:**
  1. **Replace purple flask on `Read the Literature`** (`A/door.png` -- `SCOUTING` folder, first choice card): Uses `research.png` (the purple lab beaker already shown in the top `THE HAND` header for the `RESEARCH` resource), which mismatches reading arxiv papers. Swap to `resource_papers_small` (stack of papers, distinct from `Guide`'s `ui_guide_book` and `Publish Safety Paper`'s `paper.png`) or `ui_guide_book`.

### C. The Paperwork Desk (2 blocking fixes)
- **No person:** Yes -- operator silhouette removed from all 6 views; center desk and office stay empty and eerie. (The small headshot on the `Talent Opportunity` memo in `C/watch.png` is an event candidate illustration, not an operator silhouette.)
- **Visual-defect pass:** Clean typography and layout (`>= 16px`, zero clipping/overlap), aside from the two unframed icon cutouts below.
- **Blocking fixes:**
  1. **Use each action's own icon on Form A-20 rows instead of the `Scouting` folder icon** (`C/plan.png` -- rows 1, 3, 5, 6, 8-14): `C/door.png` gives `Go to Meetups` (`action_management_team_building`), `Read the Literature` (`ui_guide_book`), and `Post Online` (`new_post_online`) distinct icons, but `C/plan.png` replaces all 11 rows with the green `Scouting` radar (`action_research_monitoring`), violating "same thing, same icon in every view". Give every Form A-20 row the icon of the play itself (matching `door.png`).
  2. **Frame the two unframed cutout icons to match Pip's square tiles** (`C/actions.png` & `C/door.png` -- `Financing` `take_loan.png` and `Work Your Connections` `network.png`; `C/plan.png` -- rows 4 and 7): Both render as unframed dark cutouts directly on cream/tan paper beside 15 dark-framed square tiles, breaking set consistency and row alignment. Place them inside the same dark square tile frame (as E does) or swap `Financing` to `action_funding_loan` and `Work Your Connections` to `action_publicity_network`.

### E. Rooms and Stations (1 blocking fix)
- **No person:** Yes -- operator silhouette removed from all 6 views; the empty mezzanine looking down on glowing monitors is the eeriest home screen of the four. (The painted office scene on `E/watch.png`'s memo is event art, not an operator silhouette.)
- **Visual-defect pass:** Clean across all 6 renders plus live render `E/concept.html?view=plan&open=x8` (`>= 16px`, zero overlap/clipping, dark tile frames unify Pip's framed and unframed icons cleanly, and `plan.png` matches every `actions.png`/`door.png` icon).
- **Blocking fixes:**
  1. **Replace mismatched globe-handshake icon on `Travel & Conferences`** (`E/actions.png` & `E/door.png` -- top-right column, `Travel & Conferences` card): Uses `action_policy_international_cooperation` (a glowing blue planet with a diplomatic handshake), which reads as international treaty/policy and was already rejected by the council in Round 2 (`r2s-agreed.md` G.1). Replace with a suitcase icon (`new_travel_suitcase.svg`, matching A, C, and G) and list it under "new, needs art".

### G. The Existing UI, Modernised (3 blocking fixes)
- **No person:** Yes -- zero person in all 6 views, and replacing the human-hand cat photo in `G/watch.png` with Pip's painted doom-cat (`web-doom-cat.jpg`) fits the dark office far better.
- **Visual-defect pass:** The 6 static PNGs pass `?check=1` (`>= 16px`), **but** rendering `G/concept.html?view=plan&expand=read` reveals an icon-induced text collision on row 3 (`x66 plan`).
- **Blocking fixes:**
  1. **Fix `x6` colliding into `6 plan` (`x66 plan`) when `Read the Literature x6` is expanded** (`G/concept.html?view=plan&expand=read` -- row 3, `PLAY` / `HOURS` columns): Adding the 24px row icon inside the 724px drawer pushes `Read the Literature x6` directly into `6 plan` once `.pscroll.over` reserves scrollbar width. Widen the `PLAY` track / drawer slightly (or tighten row-icon/gap padding) so `x6` has clear breathing room beside `6 plan` in `expand=read`.
  2. **Replace smiley-face icon on `Staff`** (`G/home.png`, `G/home-m1.png`, `G/actions.png`, `G/plan.png`, `G/upgrades.png`, `G/watch.png` -- left rail `Staff` button): Uses `resource_morale` (a yellow-green smiley face), which reads as Mood/Happiness rather than Staff roster and clashes with the eerie tone. Use Pip's `ui_staff_management` (Alex's "no person" rule targeted the large foreground operator silhouette, not 28px toolbar pictograms; G already uses `button_hire_normal` for `Hire Staff`).
  3. **Use a ledger/finance icon on `Ledger` instead of a gavel** (`G/home.png`, `G/home-m1.png`, `G/actions.png`, `G/plan.png`, `G/upgrades.png`, `G/watch.png` -- left rail `Ledger` button): `ui_governance_oversight` shows a gavel over a folder (regulatory/court oversight, not Liability Ledger). Swap `Financing` in `G/actions.png` to `action_funding_loan` so `Ledger` can use `ui_budget_finance` (consistent with A and C).

## Non-Blocking Notes (max 3)

1. **Flat vector feel on G's custom `new_*_64.png` icons (`G/actions.png`, `G/plan.png`):** G's five new PNGs (especially `new_meetups_64.png` clinking glasses and `new_publicity_64.png` megaphone) read noticeably flatter than Pip's painted icons next to them; already honestly tagged "new, needs art" for the final art pass.
2. **Calendar `"17"` icon on Schedule/Plan (`C/home.png`, `E/home.png`, `E/plan.png`):** Pip's `ui_config_date` displays a fixed `"17"` date badge; fine for Round 3 (especially since the year is `2017`), though a checklist clipboard (`action_policy_audit_requirement`, as A uses) avoids clashing with other day numbers like `DAY 9` in `E/watch.png`.
3. **`Fundraising` vs `Financing` money-bag similarity (`A/actions.png`, `C/actions.png`, `E/actions.png`):** Using gold bag (`ui_guide_resources`) vs chained loan sack (`action_funding_loan` / `take_loan`) works for now, and as C's designer noted, a distinct Fundraising icon in a later art pass would sharpen the pair further.

## Disk Report

- Deliverable written: `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r3x-neon.md`.
- New scratch verification images created this pass (in `C:/Users/keech/.t3/userdata/providers/antigravity/ac0a3dfd6dddb20962cecff6ee5fe65e19d3923be20e52c5ab52ff877f7e4c32/antigravity-acp/brain/0a82ea1d-5ed7-4a08-b506-5c724e2456ca/scratch/`):
  - `r3_icon_zoom.png` (~65 KiB)
  - `r3_E_plan_x8.png` (1,459,440 B)
  - `r3_G_plan_read.png` (1,422,376 B)
- Cumulative scratch folder: 25 files, ~7.2 MiB total (all safe to delete). Nothing under `research/concepts/` or `C:/Users/keech/Documents/pdoom1` was edited.

# Round 3 Consensus (Icons & Empty Office) -- neon

Reviewed `r3x-opus.md` and `r3x-sol.md` alongside `r3x-neon.md`.

## 1. Shared Calls on the Two Policy Questions

- **People in event pictures** (`C/watch.png` researcher headshot; `E/watch.png` painted window scene with two figures): **Non-blocking -- ask Alex once.** Alex rejected the large black foreground operator silhouette blocking the empty office, not event illustrations for hiring a human researcher. Better to ask Alex than strip event art unasked.
- **Staff / Hire control pictograms** (`ui_staff_management`, `button_hire_normal`): **Non-blocking -- keep Pip's pictograms (ask Alex once if unsure).** Small 24-40px toolbar pictograms are standard control labels, not a person standing in the office; keeping them lets G drop the mismatched smiley face on `Staff`.

## 2. Responses to Peer Blocking Items

### A. The Desk
- **opus A1** (`PLAN` plate on `A/home.png`, `A/home-m1.png`, `A/plan.png`, `A/watch.png` uses `action_policy_audit_requirement` audit clipboard, nearly identical to `Safety Audit`'s `employee_role_auditor`): **Agree (blocking).** Swap `PLAN` (and Plan CRT title if badged) to Pip's `ui_config_date` calendar to match C and E and separate Plan from Safety Audit.
- **sol A1** (`Read the Literature` in `A/door.png` uses purple `research.png` flask, already meaning the `RESEARCH` balance in the header): **Agree (blocking).** Exact match with `neon A1`; swap to `resource_papers_small` (distinct from `Guide`'s `ui_guide_book` and `Publish Safety Paper`'s `paper.png`).
- **sol A2** (`IN-TRAY` plate on `A/home.png`, `A/home-m1.png`, `A/plan.png` uses `ui_save_archive` open safe, reading as stored records rather than incoming mail): **Agree (blocking).** Replace with an inbox-tray icon (`new_intray_inbox.svg`, marked "new, needs art") at the same 32px dark-tile framing.

### C. The Paperwork Desk
- **sol C1** (`C/plan.png` Form A-20 Item column stamps `Scouting`'s `action_research_monitoring` radar onto `Go to Meetups`, `Read the Literature`, and `Post Online` instead of their `C/door.png` icons): **Agree (blocking).** Exact match with `neon C1`; resolve Form A-20 row icons by play (`action_management_team_building`, `ui_guide_book`, `new_post_online`).
- **sol C2** (`C/actions.png`, `C/door.png`, `C/plan.png`: `Financing` `take_loan.png` and `Work Your Connections` `network.png` are unframed cutouts beside dark square tiles): **Agree (blocking).** Exact match with `neon C2`; seat both on the same dark square tile backing (or swap to framed `action_funding_loan` / `action_publicity_network`).
- **sol C3** (`C/watch.png` `Talent Opportunity` researcher headshot): **Non-blocking (ask Alex once)** per Section 1.

### E. Rooms and Stations
- **opus E1 / sol E1** (`E/actions.png` & `E/door.png` top-right: `Travel & Conferences` uses `action_policy_international_cooperation` globe-handshake): **Agree (blocking).** Exact 3-way consensus with `neon E1`; replace with a suitcase (`new_travel_suitcase.svg`, "new, needs art").
- **sol E2** (`E/watch.png` `Talent Opportunity` painted window scene): **Non-blocking (ask Alex once)** per Section 1.
- **sol E3** (`E/plan.png` & `E?view=plan&open=x8`: `.q-scroll`'s 22px right scrollbar gutter shifts `Hours`, `Cost`, and `Order` rows 22px left of their fixed column headings): **Agree (blocking).** Verified visually in `E/plan.png` and `r3_E_plan_x8.png`; apply the matching 22px right gutter to the fixed heading grid.

### G. The Existing UI, Modernised
- **sol G1** (`G/home.png`..`G/watch.png` left rail: `Staff` uses smiley-face `resource_morale`; `Ledger` uses gavel `ui_governance_oversight`): **Agree (blocking).** Exact match with `neon G2` and `neon G3`; use `ui_staff_management` on `Staff`, move `Financing` (`G/actions.png`) to `action_funding_loan`, and put `ui_budget_finance` on `Ledger`.
- **sol G2** (`G/actions.png`: `Publish Safety Paper` uses `open_source_release`, which maps to `Open Source Tools` in `icon_mapping.json:82`): **Agree (blocking).** Swap `Publish Safety Paper` to `paper.png` (matching `Papers` in G's top bar and A's card) so `open_source_release` stays reserved for `Open Source Tools`.
- **sol G3** (`G/plan.png` & `G?view=plan&expand=read`: `.pscroll.over` scrollbar gutter shifts `Hours`, `Cost`, and `Order` 14px left of fixed header/total rows): **Agree (blocking, merged with `neon G1`).** In `expand=read`, the same gutter + 24px row icon also makes `x6` collide directly into `6 plan` (`x66 plan`) on row 3; share the scrollbar gutter on header/total rows and widen the `PLAY` track/drawer slightly so both alignment and spacing hold cleanly.

## 3. Joint Ranking (A, C, E, G)

Individual means: **E 8.67** (`8.5, 8.5, 9.0`), **A 8.67** (`8.5, 8.5, 9.0`), **C 8.17** (`8.0, 8.0, 8.5`), **G 7.67** (`7.5, 7.5, 8.0`). Two of three rank E #1.

1. **E. Rooms and Stations** -- Eeriest empty office (mezzanine over dark glowing cubicles), uniform dark-tile icon framing, and consistent play icons across views.
2. **A. The Desk** -- Tied on score with E; strongest hardware-desk craft and seamless Pip-style icons once its three button/card swaps land.
3. **C. The Paperwork Desk** -- Dramatic mood gain without the foreground silhouette; clean stationery hierarchy once Form A-20 icons match `door.png` and unframed cutouts are tiled.
4. **G. The Existing UI, Modernised** -- Best Watch cat-art update (`web-doom-cat.jpg`) and lowest-risk `main.tscn` migration path, though less atmospheric than E/A/C.

## 4. Joint Blocking Fix Lists (Merged & De-Duplicated)

### A. The Desk (3 fixes)
1. **`PLAN` plate icon** (`A/home.png`, `A/home-m1.png`, `A/plan.png`, `A/watch.png` -- shortcut rack `PLAN` plate): Replace `action_policy_audit_requirement` (conflicts with `Safety Audit`) with Pip's `ui_config_date`.
2. **`Read the Literature` icon** (`A/door.png` -- `SCOUTING` folder, first choice card): Replace purple `research.png` flask with `resource_papers_small`.
3. **`IN-TRAY` plate icon** (`A/home.png`, `A/home-m1.png`, `A/plan.png` -- shortcut rack `IN-TRAY` plate): Replace `ui_save_archive` (open safe) with an inbox-tray icon (`new_intray_inbox.svg`, "new, needs art").

### C. The Paperwork Desk (2 fixes)
1. **Form A-20 play icons** (`C/plan.png` -- Item column, rows 1, 3, 5, 6, 8-14): Resolve icons by play rather than parent folder so `Go to Meetups` uses `action_management_team_building`, `Read the Literature` uses `ui_guide_book`, and `Post Online` uses `new_post_online` (matching `C/door.png`).
2. **Frame unframed cutout icons** (`C/actions.png`, `C/door.png`, `C/plan.png` -- `Financing` `take_loan.png` and `Work Your Connections` `network.png`, plus rows 4 and 7 on Form A-20): Seat both on the same dark square tile backing as the other cards/rows (or swap to framed `action_funding_loan` and `action_publicity_network`).

### E. Rooms and Stations (2 fixes)
1. **`Travel & Conferences` icon** (`E/actions.png`, `E/door.png` -- right column, row 1): Replace `action_policy_international_cooperation` (globe-handshake) with a suitcase (`new_travel_suitcase.svg`, "new, needs art").
2. **Plan column header alignment** (`E/plan.png`, `E/concept.html?view=plan&open=x8` -- CRT table header row): Add the same 22px right scrollbar gutter to the fixed header grid so `HOURS`, `COST`, and `ORDER` align vertically with the scrolling rows below.

### G. The Existing UI, Modernised (3 fixes)
1. **Left-rail `Staff` and `Ledger` icons** (`G/home.png`..`G/watch.png` -- left rail; `G/actions.png` -- `Financing` row): Replace `Staff`'s smiley-face `resource_morale` with `ui_staff_management`; replace `Ledger`'s gavel `ui_governance_oversight` with `ui_budget_finance` (and move `Financing` in `G/actions.png` to `action_funding_loan`).
2. **`Publish Safety Paper` icon** (`G/actions.png` -- `Publish Safety Paper` row): Replace `open_source_release` (belongs to `Open Source Tools`) with `paper.png` (matching `Papers` in the top bar).
3. **Plan expanded-queue alignment and `x6` spacing** (`G/plan.png`, `G/concept.html?view=plan&expand=read` -- `.pmenu` table header, row 3, and Total row): Match the scrollbar gutter on the fixed header and Total rows when `.pscroll` overflows, and widen the `PLAY` track/drawer slightly so `Read the Literature x6` never collides into `6 plan` (`x66 plan`).

## Disk Report
- Wrote only `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r3x-consensus-neon.md`. No new scratch files created.

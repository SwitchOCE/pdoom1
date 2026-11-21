# Round 3 consensus -- opus

## Person rule: ask Alex once
**Question for Alex:** do these count as "the person"?
- the people in event pictures: C's WATCH memo portrait and the two men in E's WATCH memo art;
- Pip's small Staff and Hire pictograms: `ui_staff_management` (three silhouettes) and `button_hire_normal` (head and shoulders).

The operator outline Alex rejected is gone everywhere. These are Pip's own content and control icons, and the members split three ways on them. Until Alex answers, none of these is blocking. If he says they count, the fix is cheap: drop the memo images and close the gap, and draw new non-figure art for Staff and Hire.

## Other members' blocking items

**A**
- **sol/neon, Read the Literature uses the research flask** (`research.png`, door.png Scouting choice 1): **agree, blocking.** The flask already means the Research balance in the header. Fix: `resource_papers_small_64.png`. Not `ui_guide_book`, which A already uses for Guide.
- **sol, In-tray uses an open safe** (`ui_save_archive`, rack on home and plan): **agree, blocking.** Pip's set has no inbox or mail icon (`find` over godot/assets/icons). Fix: draw a new in-tray icon and list it as "new, needs art".
- **mine, Plan uses the audit clipboard:** I hold this blocking, because it is a near-twin of Safety Audit's `employee_role_auditor` and does not say "the month's plan". Neon's point about the fixed "17" is fair. Fix: `ui_config_date` (C and E already use it), or any icon that is not an audit. If both other members hold it non-blocking, I accept that.

**C**
- **sol/neon, Form A-20 rows inherit the Scouting radar** (plan.png, rows 1, 3, 5-14; Desperation Lever shows the loan sack): **agree, blocking** ("same thing, same icon"). Fix: each row uses its play's own icon from door.png: `action_management_team_building`, `ui_guide_book`, `new_post_online_bubble`. Desperation Lever has no fitting icon, so use the Financing folder icon as the source badge, or none.
- **sol/neon, Financing and Connections are unframed** (actions.png, door.png, plan.png rows 4 and 7): **agree, blocking** (set consistency). Fix: put them on the same dark tile, or swap to `action_funding_loan_64` and `action_publicity_network_64`.
- **sol, memo portrait:** see the person rule above.

**E**
- **All three, Travel & Conferences globe-handshake:** **agree.** Fix: the suitcase (`new_travel_suitcase.svg`, as in A and C).
- **sol, Plan column headings shift 22px from the rows when the scrollbar shows:** **agree, blocking** (alignment defect). Fix: reserve the same gutter in the heading grid.
- **sol, WATCH memo art:** see the person rule above.

**G**
- **sol/neon, Staff uses a smiley (`resource_morale`):** **agree, blocking.** Fix: `ui_staff_management`, which is subject to the person question; if Alex says no, use new art.
- **sol/neon, Ledger uses a gavel (`ui_governance_oversight`):** **agree, blocking.** Fix: Ledger takes `ui_budget_finance`, and Financing moves to `action_funding_loan_64` (neon's swap).
- **sol, Publish Safety Paper uses `open_source_release`:** **agree, blocking.** That icon is Open Source Tools' in the game. Fix: `paper.png`, as A and E do.
- **neon/sol, expanded x6 plan (`expand=read`):** "x6" collides with "6 plan", and the columns sit 14px left of the header. **Agree, blocking.** Both come from the scrollbar gutter. Fix: reserve the gutter in the header and total grid, and widen the PLAY track enough that "x6" clears.

## Joint ranking
**E, A, C, G.** Two of three members put E first; sol puts A first, and A and E tie on score.

## Joint blocking fix lists
**A**
1. door.png, Read the Literature: `research.png` becomes `resource_papers_small_64.png`.
2. Rack (home, home-m1, plan): In-tray gets a new in-tray icon ("new, needs art") in place of `ui_save_archive`.
3. Rack and Plan CRT title: Plan icon becomes `ui_config_date_64`. This is my item; it drops if the majority says non-blocking.

**C**
1. plan.png, Form A-20: each row carries its play's own icon (Go to Meetups `action_management_team_building`, Read the Literature `ui_guide_book`, Post Online `new_post_online_bubble`); Desperation Lever gets the Financing source badge or none.
2. actions.png, door.png, plan.png: Financing and Work Your Connections sit on the same dark tile as the rest (or switch to `action_funding_loan_64` and `action_publicity_network_64`).

**E**
1. actions.png and door.png, Travel & Conferences: the suitcase (`new_travel_suitcase.svg`).
2. plan.png: column headings share the queue's scrollbar gutter, so Hours, Cost and Order line up.

**G**
1. Left rail in all views: Staff becomes `ui_staff_management_64` (pending Alex); Ledger becomes `ui_budget_finance_64`; the Financing action becomes `action_funding_loan_64`.
2. actions.png, Publish Safety Paper: `paper.png`.
3. plan.png with `expand=read`: the header and total share the gutter, and "x6" clears "6 plan".

**All four, pending Alex:** the person question above.

## Non-blocking
- Flat "new, needs art" icons, especially G's; the fixed "17" on the calendar icon; Fundraising and Financing money bags that look alike.

## Disk report
I wrote only `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r3x-consensus-opus.md`. The scratchpad (about 19 MB) can be deleted.

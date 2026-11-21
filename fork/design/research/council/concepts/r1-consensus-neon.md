VERDICT: SHORTLIST A C E

# Council round 1 consensus -- neon

## 1. Shortlist and ranking

- **Shortlist accepted: `A C E`** (matching Opus; 3/3 members picked A and E, and 2/3 picked C).
- **Why C over B for the 3rd slot (disagreeing with Sol's `E A B`):** B reads as a beige corporate desktop app with large dead wallpaper gaps (~350px between `STAFF` and `MAIL` in `B/m1.png` and `B/m5.png`, ~300px below `PROCUREMENT` in `B/place2.png`), left-aligned `-`/`+` glyphs inside square Reserve buttons (`B/m5.png` top bar), folders that open straight over the docket, and a WATCH view (`B/watch.png`) with a blurry purple-ghost silhouette, no playback controls, and no in-flight queue. C directly captures Alex's *Papers, Please* target, nails the end-of-month ledger + `[Esc]` look-back flow Pip asked for (`C/place2.png`), and has only concrete, localized defects to fix.
- **Why I yield #1 from C to A (agreeing with Opus's `A C E` order):** Source verification (`month_plan.gd:252`, `hiring_pipeline.gd:146,562`) confirmed that C's Month 5 queue and blocked stamps misbill both `Work Your Connections` and `Onboard New Hires` as planning hours, whereas A left WYC playable and did not break its queue math on that pool. A also captures *both* halves of Alex's brief on the PLAN screen itself -- the glowing CRT terminal + hardware dials *and* the physical desk slips -- giving A the strongest overall ceiling once its queue controls and visual glitches are fixed.
- **Full ranking A-F:** `A, C, E, F, B, D`. (F edges B for 4th on Pip-aesthetic fidelity and complete WATCH controls; neither makes the shortlist.)

## 2. Game-source verification of disputed facts

Checked directly in `C:/Users/keech/Documents/pdoom1/godot/`:

1. **Work Your Connections is 2 OPERATING hours + 6 reputation (Opus & Sol right; resolves Neon R1):** `scripts/core/hiring_pipeline.gd:142-147` charges `cost_rep = 6.0` and calls `state.month_plan.spend_attention(cost_att)` (`cost_att = 2`) with no `hour_type` argument. `scripts/core/month_plan.gd:252-261` defines `spend_attention(cost: int, hour_type: String = HOUR_OPERATING)` ("DEFAULT IS OPERATING"). In Month 5 (0 planning, 5 operating free), **Work Your Connections is playable**, NOT blocked by `no planning hours`. C and E must fix both their card labels and M5 queues; A must label it `2 op hr . 6 rep`.
2. **Onboard New Hires spends OPERATING hours + step-dependent money (Opus & Sol right):** `scripts/core/hiring_pipeline.gd:488-563` routes every step (`laptop`, `visa`, `systems`, `meet_people`, `mentoring`) through `_pay_onboard()`, which calls `state.month_plan.spend_attention(att_cost)` (defaults to `HOUR_OPERATING`) with step-dependent `item_money` / `item_attention`. In M5 (1 hire already employed, none awaiting onboarding), the true blocked reason is `"No hires awaiting onboarding"` / `"Nobody to onboard"` -- NEVER `"NO PLANNING HRS"`.
3. **WATCH event eligibility (`data/events/core_events.json` -- Opus & Sol right):**
   - `stray_cat` (`core_events.json:413`, "A Stray Cat Appears!"): `trigger_type: "turn_exact", trigger_turn: 7, repeatable: false`. That fires in July (Month 1), NOT Nov 14 in Month 5 (A's `watch.png` is impossible).
   - `keynote_slot` (`core_events.json:1213`, "The Keynote Slot"): `trigger_condition: "reputation >= 40", min_turn: 15`. Month 5 has `reputation: 32`, so it cannot fire (E's `watch.png` is impossible).
   - `talent_recruitment` (`core_events.json:47`, "Talent Opportunity"): `trigger_type: "random", min_turn: 5, repeatable: true`, no rep gate. **Eligible in Month 5.**
4. **WATCH window Attention cost (`scripts/core/window_resolver.gd:22, 165-235, 253-295` -- Sol right):** `present_for_dialog()` strips option-level `attention` and levies `DEFAULT_ATTENTION_COST = 1` on **every option except the zero-cost `ignore_option_id`**. On `Talent Opportunity`, **both** `Fast-Track Hiring` AND `Standard Hiring` cost `$25,000 + 1 held hr`, while `Decline Offer` is free. On `A Stray Cat Appears!`, both `Adopt the Cat` and `Feed It and Let It Go` cost `+ 1 held hr`, while `Shoo It Away` is free. Also `month_plan.gd:235-244` specifies that the event reserve is **deliberately untyped** (E's `HELD 5h OPS` / `2h OPS` event pricing contradicts the game).
5. **`Strategic` in Month 5 (`data/actions/strategic.json` -- Neon R1 confirmed):** `sabotage_competitor` ("Corporate Espionage") costs `$100,000`, `3 doors` (= `3 op hr`), `20 rep` -- affordable at `$140,000`, `5 op hr`, `32 rep`. C's `NONE AFFORDABLE` stamp on `Strategic` is wrong.
6. **Zero-dollar quote/bill actions in M5 queues (`scripts/core/actions.gd:514`, `data/actions/financing.json` -- Sol right):** `Pay the Bill` and `Sign: Walk-up office` / `Sign: Co-working corner` require a live pending bill/lease quote with a real dollar amount. Showing `--` for their cost in M5 queues implies unshown state; M5 fixtures should either swap them for unconditionally valid planning actions or display explicit payable amounts.

## 3. Response to Opus's and Sol's fix items (for A, C, E)

### A. The Desk
- **Opus #1 & Sol #2 (WYC -> `2 op hr . 6 rep`, Onboard variable op cost):** **Agree.** Confirmed in `hiring_pipeline.gd:146,562` and `month_plan.gd:252`.
- **Opus #2 (Add operator silhouette in PLAN; replace WATCH blob silhouette):** **Disagree on adding silhouette to PLAN (non-blocking); mark WATCH silhouette art polish non-blocking.** Pip explicitly ruled in `WORKSHOP_2_BACKLOG.md:744` and `BUILD_BRIEF_PLAN_WATCH_UI.md:10-13` that the silhouetted operator lives in WATCH, not PLAN; adding one to PLAN changes A's first-person desk conceit rather than fixing a defect. By contrast, removing the sharp rectangular `.desk-glow` artifact hovering behind the operator's head in `A/watch.png` IS a blocking visual bug.
- **Opus #3 (Gantt labels crossing JAN/FEB column rules in `A/m5.png`):** **Agree.** Verified by crop: the labels mask the column gridlines awkwardly; place date text in a dedicated column or clear of the rules.
- **Opus #4 & Sol #2 (14px text on WATCH event costs and PLAN blocked stamps -> >= 16px):** **Agree.** All operational text (`.slip-st`, `.slip-tab`, `.clip`, `.pin-o`, `.pin-done`, WATCH option costs) must be >= 16px.
- **Opus #5 & Sol #3 (Replace ineligible M5 Stray Cat with eligible event + show `+ 1 held hr` on every non-free choice + update WATCH cash):** **Agree.** Verified in `core_events.json:413` and `window_resolver.gd:274`.
- **Opus #6 (`place2.png` Ledger `next divider` placeholder + duplicate `UPGRADES` footer button):** **Agree.** Show real clean ledger status and remove the duplicate button.
- **Opus #7 & Sol #2 (`door.png` empty lower half, dimmer killing contrast on plan/dials, dual `Enter` on Add + Commit):** **Agree.** Shrink detail sheet to content, lighten dimmer, keep `Enter` on one active target. (Testing a 7-choice door is good QA during the fix, not a new deliverable.)
- **Sol #1 (Editable M5 CRT queue: reorder + remove per individual play, fix `--` `Pay the Bill`, derive folder badges & total from rows):** **Agree** (merges cleanly with Neon's R1 items on reorder/Undo/Clear and Financing `2 in plan` / Scouting count mismatch).
- **Sol #2 (Stop 8-to-9 column reflow jumping `Publish Safety Paper` from row 2 to row 1; complete July calendar past 29):** **Agree.** Both verified directly in `A/m1.png` and `A/m5.png`.

### C. The Paperwork Desk
- **Opus #1 & Sol defect (WYC -> `2 op hr, 6 rep`, remove `NO PLANNING HRS`, rebuild M5 form with valid non-`--` actions so 12 plan + op free + totals reconcile):** **Agree.** Verified in `hiring_pipeline.gd:146` and `month_plan.gd:252`.
- **Opus #2 & Sol defect (Onboard -> operating + variable step cost, show cost in M1 too, true reason `NOBODY HIRED` / `NO HIRES AWAITING ONBOARDING` instead of `NO PLANNING HRS`):** **Agree.** Verified in `hiring_pipeline.gd:488-563`.
- **Opus #3 & Sol defect (`NO.ORDER` column header collision in `C/m1.png` and `C/m5.png`):** **Agree.** Verified by crop (`NO.ORDER` has almost zero separation).
- **Opus #4 (Unify `on form N` badge placement to one fixed corner across cards and slips):** **Agree.** Fixes the `Hire Staff` / `Financing` title collision risk too.
- **Opus #5 & Sol defect (Operational text < 16px: `.stamp` 15px, `.cf-onf` 14px, `.key` 15px, `.fm-hl` 15px, `.fm-no` 15px, WATCH memo option costs):** **Agree.** Raise all operational text to >= 16px.
- **Opus #6 & Sol defect (Add `RISING` to M5 `P(DOOM)`):** **Agree.** Also drop permanent `lose at 100%` rule text from the bar.
- **Opus #7 (Replace placeholder keyhole silhouette in `watch`/`place2`):** **Mark non-blocking.** Matches Opus's own Non-blocking Note #1 (shared art asset pass across concepts).
- **Opus defect & Sol defect (Low-contrast greyed titles on unavailable cards; cramped 22px reorder buttons; gantt date text tight against `NOV` rule; paperclip crossing `NEEDS ANSWER`; `Standard Hiring` missing `+ 1 held hr`; `Space resume` advertised while memo is open; `Strategic` wrongly stamped `NONE AFFORDABLE`; redundant top-bar office thumbnail in look-up views):** **Agree on all**, keeping C's overall two-column proportions intact (no full layout redesign).

### E. Rooms and Stations
- **Opus #1, #2 & Sol #1 (WYC -> `2h OPS`; rebuild M5 queue around live valid costs so 12 plan spent + op left + CRT footer `+ rep` actually balance; add `RISING` on P(DOOM) and `100` tick on Reputation):** **Agree.** Verified in `hiring_pipeline.gd:146`, `month_plan.gd:252`, and `E/concept.html`.
- **Opus #3 (Add consistent `+` control on direct action rows matching `>` on doors):** **Agree.** Fixes row-control inconsistency.
- **Opus #4 (`P(DOOM)` dial box overlaps CRT bezel at `y ~120-135`):** **Agree.** Verified by crop -- clear overlap on every Desk view.
- **Opus #5 & Sol #3 (Replace ineligible `The Keynote Slot` at rep 32 with eligible M5 event + real window costs; update WATCH cash/rep after `[x] done`; show held Attention once as untyped reserve instead of `HELD 5h OPS` duplicating `5 left` OPS; replace dead locked `ACTIONS` rack in WATCH):** **Agree.** Verified in `core_events.json:1213` and `month_plan.gd:235`.
- **Opus #6 & Sol #2 (Draw Procurement and Records views):** **Disagree as blocking -- mark NON-BLOCKING.** Per the consensus scope reminder, the brief requires `m1` and `m5` plus *"at least one other place"* (`place2.png`), which E already satisfied with `F2 LAB FLOOR`. Adding new `?view=procurement` / `?view=records` screens is beyond the brief's deliverable bar.
- **Opus #7 & Sol #2 (Keep `OPEN` tab flush inside rack border and visually link it to the right-hand open folder header; show `Hire Staff` per-role `1h PLAN` cost & blocked state in M5; show `Onboard New Hires` operating step cost):** **Agree.** Verified by crop (`OPEN` protrudes ~14px into the CRT gutter).
- **Sol #3 (`F2 LAB FLOOR` `Maya Haddad` name tag floating left of worker sprite):** **Agree.** Center the tag directly above her sprite.

---

## 4. Proposed joint answer

VERDICT: SHORTLIST A C E

### Ranking A-F
1. **A. The Desk** -- Strongest blend of CRT terminal, brass instruments, and physical desk slips with a clear PLAN -> WATCH chair swivel and Upgrades drawer.
2. **C. The Paperwork Desk** -- Purest *Papers, Please* physicality, reorderable Form A-20, and the best Month Review ledger + `[Esc]` look-back flow.
3. **E. Rooms and Stations** -- Best multi-room navigation under a fixed instrument frame, flawless 16px+ typography, and real office-floor sprites.
4. **F. Pure Terminal** -- Crisp Pip-aligned ASCII/CRT craft, but driest office atmosphere and missing queue reordering plus data bugs.
5. **B. The Mainframe OS** -- Clean Win98 directory and Procurement view, but sterile corporate tone, large dead wallpaper voids, and an incomplete WATCH screen with a blurry ghost silhouette.
6. **D. The Card Table** -- Striking card-table aesthetic and matching icons, but fails on scope (invented/wrong M5 actions, door in queue), drops the WATCH operator silhouette, locks slots 6-9 out of reordering, and violates the 16px floor across 32 rules.

### Merged blocking fix lists

#### A. The Desk
1. **Fix `Work Your Connections` and `Onboard New Hires` costs (`m1.png`, `m5.png`, action tray):** Label `Work Your Connections` as `2 op hr . 6 rep` (matching `hiring_pipeline.gd:146`, `month_plan.gd:252`); show `Onboard New Hires` operating step cost (`op hr + step cost`) above its blocked stamp.
2. **Make the M5 CRT queue editable and accurate (`m5.png`, center CRT `01..09` & action tray badges):** Expand repeated plays into individually editable rows with `^` / `v` reorder and `[x]` remove controls plus `[Z] Undo` / `[C] Clear`; replace zero-cost `--` `Pay the Bill` with a valid payable action or real bill amount; derive all folder badges (`Financing` currently reads `2 in plan` for 1 row; `Scouting` mixes distinct-action vs play counts) and footer totals directly from the rows.
3. **Fix July calendar clip and M1->M5 card reflow (`m1.png` top-left calendar; `m1.png` vs `m5.png` bottom tray):** Give the July 2017 calendar 6 rows so days `30` and `31` are not clipped; use a consistent 9-column tray in both M1 and M5 so `Publish Safety Paper` does not jump from row 2 to row 1.
4. **Raise all operational text to >= 16px (`m1.png`, `m5.png`, `door.png`, `watch.png`):** Bump `.slip-st` blocked stamps, `.slip-tab`, `.clip`, `.pin-o`/`.pin-done`, and WATCH event-choice costs from `14px` to `16px`.
5. **Clean up gantt labels and `door.png` overlay (`m5.png` CRT `UNDER WAY`; `door.png`):** Keep `lands ~mid-Dec 2017` and `decision ~Jan 2018` clear of the `JAN`/`FEB` vertical rules; in `door.png`, lighten the backdrop dimmer so the plan and instruments remain legible, shrink the detail card to eliminate the ~110px blank lower half, and display `Enter` on only one active target (not both `add to plan` and `COMMIT`).
6. **Fix `place2.png` Ledger tile and footer (`place2.png`, Upgrades drawer):** Replace the `Liability Ledger -- next divider` placeholder with the real clean status (`Liability Ledger -- clean`) and remove the duplicate `UPGRADES` button in the drawer footer.
7. **Fix WATCH event, costs, cash, and glow artifact (`watch.png`):** Replace ineligible `A Stray Cat Appears!` (`turn_exact: 7`, July-only) with an M5-eligible event (e.g., `Talent Opportunity`, `min_turn: 5`) showing `+ 1 held hr` on every non-free choice (`window_resolver.gd:274`); update Money (`$79,700`) for completed plays; remove the sharp rectangular `.desk-glow` box floating behind the operator's head.

#### C. The Paperwork Desk
1. **Fix `Work Your Connections` and `Onboard New Hires` hour types, stamps, and M5 form (`m1.png`, `m5.png`, card file & Form A-20):** Change `Work Your Connections` to `2 op hr, 6 rep` (remove `NO PLANNING HRS` -- playable in M5); change `Onboard New Hires` to operating step cost (`op hr + step cost`, shown in both M1 and M5) with true blocker `NOBODY HIRED` / `NO HIRES AWAITING ONBOARDING`; rebuild the M5 form using valid non-`--` actions so planning hits `0 of 12 free`, operating stays positive, and `TOTALS` reconcile.
2. **Fix `Strategic` blocker and `P(DOOM)` rising state (`m5.png`, bottom-left card file & top-center counter):** Remove the wrong `NONE AFFORDABLE` stamp from `Strategic` (`Corporate Espionage` is affordable per `strategic.json`); add `RISING` beside `40.2%` and drop the permanent `lose at 100%` text from the bar.
3. **Fix Form A-20 collisions, hit targets, and badge consistency (`m1.png`, `m5.png`, `door.png`):** Separate the colliding `NO.ORDER` column headers; add >= 12px right padding before the `NOV` gantt vertical rule; enlarge reorder buttons from 22px to >= 26px; place `on form N` in one consistent corner (top-right or bottom-right) on every card and slip so it never crowds folder titles; raise title contrast on unavailable cards.
4. **Raise operational text to >= 16px (`m1.png`, `m5.png`, `door.png`, `watch.png`):** Bump `.stamp`, `.cf-onf`, `.key`, `.fm-hl`, `.fm-no`, `.cf-card.folder::before`, and WATCH memo option costs from `14px`/`15px` to `16px`.
5. **Fix WATCH memo overlap, choice costs, resume hint, and duplicate thumbnail (`watch.png`, `place2.png`):** Move `.ev-clip` so the paperclip no longer crosses the `NEEDS ANSWER` stamp; add `+ 1 held hr` to `Standard Hiring` (`window_resolver.gd:274`); remove/disable `Space resume` while a mandatory memo awaits reply; hide the redundant miniature office window in the top bar during full-screen look-up views.

#### E. Rooms and Stations
1. **Fix M5 queue math, `Work Your Connections` pool, and top-bar readouts (`m1.png`, `m5.png`, top bar & center CRT):** Change `Work Your Connections` to `2h OPS` (playable in M5); rebuild the M5 queue with valid non-`--` actions so the rows actually sum to `12h PLAN` (`0 left`) plus remaining `OPS`, and include `+ rep` in the CRT footer total; add `RISING` to `P(DOOM)` in M5 and add the `100` tick label on `REPUTATION`.
2. **Fix `P(DOOM)` dial overlap on CRT bezel (`m1.png`, `m5.png`, `watch.png`, top center `y ~120-135`):** Seat the `P(DOOM)` dial cleanly inside the top frame (or shift the CRT down) so its bottom edge does not overlap the CRT bezel.
3. **Fix action-rack controls, costs, blockers, and `OPEN` tab (`m1.png`, `m5.png`, left column & right folder panel):** Add a `+` button in the right column of direct actions matching `>` on doors; show `Hire Staff`'s per-role `1h PLAN` cost and blocked state in M5; show `Onboard New Hires`'s operating step cost; keep the `OPEN` tab flush inside the rack frame instead of protruding ~14px into the CRT gutter and echo the active highlight on the matching right-hand folder header; add bottom breathing room below `Strategic`.
4. **Fix WATCH event, accounting, untyped reserve, and locked rack (`watch.png`):** Replace ineligible `The Keynote Slot` (needs `reputation >= 40`, M5 has `32`) with an M5-eligible event (e.g., `Talent Opportunity`) showing accurate `+ 1 held hr` window costs (`window_resolver.gd:274`); reflect `[x] done` spending in Money and Reputation; display held event Attention once as an **untyped** reserve (`month_plan.gd:235`) rather than `HELD 5h OPS` duplicating `5 left` OPS; replace the dead `LOCKED UNTIL MONTH END` action list on the left with a live office/feed view.
5. **Fix Lab Floor name-tag alignment (`place2.png`, `CAM 1 . FLOOR`):** Center the `Maya Haddad` name tag directly above her worker sprite instead of floating over the empty desk to her left.

### Non-blocking notes (3)
1. **Shared silhouette asset:** All three shortlisted concepts use placeholder geometric silhouettes in WATCH; one shared, properly lit operator-and-chair silhouette asset should replace them in the art pass.
2. **Additional room views for E (`F3 PROCUREMENT`, `F4 RECORDS`):** Not required by the round-1 brief (`place2.png` already shows `F2 LAB FLOOR`), but worth drawing before final selection so Alex can see the full 4-station loop.
3. **Optional A+C hybrid for Alex:** If Alex wants A's CRT-on-desk PLAN screen paired with C's perforated Month Ledger close and `[Esc]` look-back, that is an owner choice after reviewing the fixed shortlist -- not a round-1 fix.

## Disk report
- Wrote [r1-consensus-neon.md](file:///C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r1-consensus-neon.md).
- Added 3 verification crops in `C:/Users/keech/.t3/userdata/providers/antigravity/ac0a3dfd6dddb20962cecff6ee5fe65e19d3923be20e52c5ab52ff877f7e4c32/antigravity-acp/brain/0a82ea1d-5ed7-4a08-b506-5c724e2456ca/scratch/`:
  - `crop_A_gantt_m5.png` (58,797 B)
  - `crop_C_no_order.png` (22,824 B)
  - `crop_E_dial_overlap.png` (36,248 B)
  - Consensus scratch subtotal: 117,869 B (~115 KiB); cumulative scratch total across R1 + consensus: 1,352,157 B (~1.29 MiB). All 17 scratch files can be deleted safely. Nothing under `research/concepts/` or `C:/Users/keech/Documents/pdoom1` was edited.

VERDICT: GOOD TO GO

# Round 2 (Simplify) Re-Check -- neon

Inspected all updated renders across **A, C, E, and G** at full 1920x1080 (`home`, `home-m1`, `actions`, `door` where present, `plan`, `upgrades` where present, `watch`), audited every `concept.html` for pure ASCII and operational font sizes (zero `< 16px` rules or inline styles across all four), and rendered + inspected the scrollable expanded-queue states `E/concept.html?view=plan&open=x8` and `G/concept.html?view=plan&expand=read`.

All four concepts satisfy every rule and concept-specific item in `r2s-agreed.md`, keep their home screens sparse (A and G are even cleaner than before the fix round), and show no new visual defects.

## Per-Concept Verdicts & Verification

### A. The Desk
- **A: READY -- 9.0/10**
- **Agreed items verified:**
  1. Attention bars filled = hours left across every view (`A/home.png` 0/12 & 5/8, `A/home-m1.png` 12/12 & 8/8, `A/actions.png` & `A/door.png` header `0/12 left` & `5/8 left`, `A/plan.png` 0/12 & 5/8).
  2. Shortcut rack: no plate lit on `A/home.png` or `A/home-m1.png`; only `PLAN` lit amber on `A/plan.png`.
  3. Home terminal (`A/home.png`): reserve row and cost total removed; keeps Attention and first 3 plays (`+ 10 more`), keeping home sparse (~70% art+empty).
  4. Actions (`A/actions.png`, `A/door.png`): header shows free Planning/Operating hours; `Hire Staff` retains its `>` open control beside `NO PLANNING HRS LEFT`; the 3 research cards show `SHORT 22 RESEARCH` / `SHORT 32 RESEARCH` beside `NO PLANNING HRS LEFT`.
  5. Plan (`A/plan.png`): `RESERVE` restores `-` / `+` buttons beside `0 hr`; wall calendar is hidden so no red corner peeks behind the top-left CRT bezel.
  6. Focus keys (`A/door.png`, `A/actions.png`, `A/plan.png`, `A/upgrades.png`): only the open `SCOUTING` slip advertises `Esc` (`Esc put the folder back`) and `[Enter]` (`Go to Meetups`); `COMMIT` hides `[Enter]` while any menu/folder is open.
  7. Type floor: zero `< 16px` rules or inline sizes in `A/concept.html`.
- **Visual-defect pass:** Clean across all 7 renders; zero clipping, overlap, or contrast issues.
- **Blocking items:** None.

### C. The Paperwork Desk
- **C: READY -- 9.0/10**
- **Agreed items verified:**
  1. Menu overlay (`C/plan.png`, `C/actions.png`, `C/door.png`): menus cleanly cover the full desk band (`x 48-1560` to bottom), eliminating all peeking slivers of Schedule, Action Cards, Ledger, and Guide and preventing duplicated Attention bars.
  2. Home key caps (`C/home.png`, `C/home-m1.png`): `A`, `P`, `S`, `U`, `L`, `G`, and `Enter` all sit consistently in bottom-right corners; home remains sparse (~76-80% art+empty).
  3. WATCH clipboard (`C/watch.png`): `SCHEDULE -- COMMITTED` shows `PLANNING 12 hr spent`, `OPERATING 3 hr spent`, and one untyped `HELD FOR EVENTS 5 hr`.
  4. Attention boxes filled = hours left on `C/home.png` (0/12, 5/8), `C/home-m1.png` (12/12, 8/8), and `C/plan.png` (0/12, 5/8).
  5. Type floor: zero `< 16px` rules or inline sizes in `C/concept.html` (clipboard labels, accounts slip, form headings all `>= 16px`).
  6. Form row 2 (`C/plan.png`): `Hire Staff` source label restored beside `Hire: Safety Researcher`.
  7. Door (`C/door.png`): crisp amber highlight wraps the `Scouting` source card without clipping; `Close` drops `[Esc]` so only `Close folder [Esc]` on `SCOUTING` advertises `Esc`; `COMMIT THE MONTH` hides `[Enter]`.
- **Visual-defect pass:** Clean across all 6 renders; zero overlap, clipping, or stale data.
- **Blocking items:** None.

### E. Rooms and Stations
- **E: READY -- 9.0/10**
- **Agreed items verified:**
  1. Attention bars filled = hours left across `E/home.png`, `E/home-m1.png`, and `E/plan.png` (`PLAN` 0/12 filled, `OPS` 5/8 filled in Nov; both full in Jul).
  2. Plan (`E/plan.png` & live render `E/concept.html?view=plan&open=x8`): shows `Queued cost: $60,300 + 6 rep . 14 plays`, `Held for events at Commit: 5h`, and expandable repeat groups (`05 Post Online x3 [-] hide` -> `05.1`-`05.3` with per-play `^ v x` in `plan.png`; `04 Read the Literature x8 [-] hide` -> `04.1`-`04.4` scrolling cleanly inside the bounded `.q-scroll` viewport with an amber scrollbar thumb while `Undo`/`Clear`, totals, and `UNDER WAY` stay fixed).
  3. Actions (`E/actions.png`): the 3 research rows display `x 22 research short` / `x 32 research short` beside `x no planning hours`.
  4. Door (`E/door.png`): `Go to Meetups` has an amber focused border and `[Enter] Add`; `Back to desk` drops `[Esc]` so only `OPEN: SCOUTING` shows `[Esc] Close`; `COMMIT THE MONTH` hides `[Enter]`.
  5. WATCH (`E/watch.png`): `Cash in hand $79,700` appears directly above the `$25,000` event choices; `DAY 9` card reads `[x] 14 plays (5 rows) done` and includes `[O] 01 Nov outcomes`.
  6. Home (`E/home.png`, `E/home-m1.png`): stays short and sparse (~81-82% art+empty), with no spend or held hours added.
  7. Type floor: zero `< 16px` rules or inline sizes in `E/concept.html`.
- **Visual-defect pass:** Clean across all 6 renders plus `plan&open=x8`; zero overflow or clipping.
- **Blocking items:** None.

### G. The Existing UI, Modernised
- **G: READY -- 8.5/10**
- **Agreed items verified:**
  1. Actions (`G/actions.png`): all 6 empty dark icon frames and the mismatched `Travel & Conferences` handshake icon are removed while keeping aligned text columns; the 3 research rows show `(22 short)` / `(32 short)` beside `-- no planning hours left`.
  2. Focus keys & WATCH (`G/actions.png`, `G/plan.png`, `G/upgrades.png`, `G/watch.png`): only the topmost open layer advertises `Enter` and `Esc` (`COMMIT THE MONTH >` hides `[Enter]` when any drawer/detail is open); `G/watch.png` numbers Stray Cat choices `1 / 2 / 3` and suppresses all background key caps (`Menu`, `View`, rail `A/U/E/L/F1`, `Filters`, `Feedback`).
  3. View switch (`G/home.png`..`G/watch.png`): labelled `View PLAN | WATCH [V]` in PLAN views and dimmed without `[V]` while the WATCH event awaits a reply.
  4. Attention pips filled = hours left across every view (`G/home.png` 0/12 & 5/8, `G/home-m1.png` 12/12 & 8/8, `G/actions.png`, `G/plan.png`, `G/upgrades.png`).
  5. Home (`G/home.png`): `Under Way` removed (stays in Plan), making home sparser (~68% art+empty) while preserving today's resource bar; `$110,300 + 6 rep` shown on both `G/home.png` and `G/plan.png` `THIS MONTH` totals.
  6. Month-1 doom card (`G/home-m1.png`): `20.0%` ring gauge centered cleanly inside the card with no caption.
  7. Plan (`G/plan.png` & live render `G/concept.html?view=plan&expand=read`): `~Jan 2018` sits cleanly inside the `JAN` column clear of the `FEB` divider; repeat groups expand into per-play rows (`4.1`-`4.2` in `plan.png`; `3.1`-`3.6` in `plan&expand=read`) inside a bounded scrollable `.pscroll` container with a vertical scrollbar while `Total`, `RESEARCH QUALITY`, `UNDER WAY`, and footer controls stay anchored.
  8. Type floor & contrast (`G/concept.html`, `G/upgrades.png`): zero `< 16px` rules or inline styles; disabled prices (`$160,000`..`$800,000`) and `Can't afford` labels are cleanly legible.
- **Visual-defect pass:** Clean across all 6 renders plus `plan&expand=read`; zero overflow or clipping.
- **Blocking items:** None.

## Non-Blocking Notes (max 3)

1. **G (`plan&expand=read`) tight column gap when scrollbar appears:** On row 3 (`[-] Read the Literature x6  6 plan`), `x6` sits ~8px from `6 plan` once `.pscroll.over` reserves 24px for the scrollbar -- still readable with zero overlap, though widening `.pmenu` by ~16px or slightly narrowing the `COST`/`ORDER` tracks in Godot will give it more air.
2. **E (`plan&open=x8`) custom scrollbar vs G native track:** E's recessed amber scrollbar matches its CRT aesthetic nicely; in G, `expand=read` shows the browser's bright native scrollbar track behind the thumb in headless Edge, which will naturally be styled with Godot's dark `VScrollBar` theme.
3. **Shared art pass:** All four concepts are now ready for Alex's gallery review; replacing the placeholder operator silhouettes on A, C, and E remains a single shared art pass if Alex picks one of those three.

## Disk Report

- Deliverable written: `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r2s-recheck-neon.md`.
- New scratch renders created this pass (in `C:/Users/keech/.t3/userdata/providers/antigravity/ac0a3dfd6dddb20962cecff6ee5fe65e19d3923be20e52c5ab52ff877f7e4c32/antigravity-acp/brain/0a82ea1d-5ed7-4a08-b506-5c724e2456ca/scratch/`):
  - `r2_recheck_E_plan_x8.png` (1,425,015 B)
  - `r2_recheck_G_plan_read.png` (1,405,350 B)
- Cumulative scratch folder: 22 files, ~4.40 MiB total (all safe to delete). Nothing under `research/concepts/` or `C:/Users/keech/Documents/pdoom1` was edited.

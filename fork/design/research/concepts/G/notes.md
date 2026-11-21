# G. The existing UI, modernised

Today's PLAN screen: office backdrop, resource bar, `## PLAN` banner, doom gauge top right, queue bottom right, Commit in the bottom bar. Everything else moves into menus on a left-bound rail, so the office art shows.

**Kept:** backdrop, resource bar, terminal banner, PLAN/WATCH switch, ring gauge and sparkline, the queue, bottom bar, Pip's left-bound icon list (prop_*.png) and ABBBCCC doors.
**Changed:** the month replaces "Turn 87"; research -12 flagged; names and costs on every action; Attention shown once, split planning/operating/reserve; one Commit; upgrades, research quality, info bar, hints and doom breakdown leave the home screen; repeated plays stack (x6), order unchanged.

**Menus** (close with their button, key or Esc):
- Actions `A`: 17 rows. A door opens beside its row, detail above. F/H/T/P open doors directly.
- Plan `Q`: grows left from the plan card. Order (up/down/remove), costs, research quality, under-way bars, Undo `Z`, Clear `C`, Reserve `R`.
- Upgrades `U`, Staff `E`, Ledger `L`, Guide `F1`. Switch `V`, Commit `Enter`.

**Home elements (11):** resource bar, banner with switch, 5 rail buttons, doom card, plan card, Commit, Feedback. About 66% is art.

**Godot nodes:** `Backdrop`/`BackdropScrim` (modulate, alpha). `TopBar`: drop `TitleLabel` and `APLabel`; `TurnLabel` shows the month. `ActionsScroll`, `UpgradesScroll` and `research_quality_selector` move into drawer panels. `GettingStartedHint`, `CommandZone`, `InfoBar`, `PhaseLabel` and `DoomExplanation` go. The `_show_*_submenu` popups anchor beside their row. `InstrumentColumn` drops its 0.5 modulate and becomes the doom card and the plan card (`QueuePanel`). Reserve, Undo and Clear move into the Plan drawer. `EndTurnButton` and `CommitPlanButton` become one button.

**Weakest point:** the action menu is still dense ("no planning hours left" appears six times). The OfficeCat instrument is gone. Commit moves from bottom-left to bottom-right.

**Visual pass (round 2, all 6 renders):** see Fix round below.

## Fix round (council r2s, items 1-8)

1. Actions: the empty icon frames are gone (icon-less rows keep the column blank, so names stay aligned). Travel & Conferences has no icon now (handshake dropped): 10 icons, 7 omitted. The research actions show "(22 short)" / "(32 short)" beside the hours blocker.
2. Keys: only the top layer shows Enter/Esc. With a menu open, the Esc key cap in the top bar and Commit's Enter are hidden. In Actions, the detail card owns Enter/Esc and the menu shows only its x. In WATCH, the choices are 1/2/3 and every background key cap is hidden (rail, Feedback, Filters, Menu, V).
3. The switch is labelled "View" and is dimmed in WATCH while the event waits for a reply. Commit is unchanged.
4. Attention bars: filled means hours left, in every view: month 1 is full, November is 0/12 planning and 5/8 operating. Held hours (WATCH) and the reserve are untyped text.
5. Home: Under Way removed (it stays in Plan). The resource bar is kept. The totals read "$110,300 + 6 rep" on home and in Plan.
6. Month-1 doom card: the gauge is centred and has no caption.
7. Plan: each repeated group has a +/- expander, and expanding shows one row per play with its own up/down/remove (Post Online shown open). Research quality is moved onto one line to make room. "~Jan 2018" sits inside the JAN column.
8. Text floor: every style is now 16px or larger. That covers queue hours and costs, x badges, dates, "Can't afford", upgrade descriptions and section labels. Disabled prices are muted, not dim.
9. Plan drawer (recheck): the play list now scrolls inside the drawer, between a fixed column header and a fixed Total row. Research quality, Under Way and the Undo/Clear/Reserve footer never move. When the list overflows, a scroll rail and a bottom fade appear. Checked with Read the Literature x6 open (`?view=plan&expand=read`): the footer stays at y945-989 inside the drawer, and the drawn plan.png fits with nothing clipped (rows are now 44px).

Visual pass: all 6 renders checked by eye and by an in-page check (`?check=1`, read with `--dump-dom`). The check flags text under 16px, clipping, and anything outside its panel or the screen. Result: CLEAN on every view. Fixed along the way: the icon image was 2px clipped; the plan totals wrapped.

## Round 3 (icons and the empty office)

**Removed:** G never drew an operator silhouette, and I checked every view: no person anywhere. The one human in G was the WATCH event photo (a hand stroking the cat). It is replaced by Pip's painted doom-cat at a CRT (`cats/simple/web-doom-cat.jpg`, now `assets/event_cat.jpg`). The centre of the screen stays empty office art. Suggestion, not drawn: later, Pip's office-floor staff sprites or the office-phase art (garage to villain lair) could fill it.

**Pip icons used** (copied to `assets/icons/`; one size per kind of place: 28px top bar and left buttons, 24px panel headers, queue rows and small buttons, 32px folder choices, 40px action rows and the detail card):
- Top bar: `money.png`, `compute.png`, `research.png`, `paper.png`, `reputation.png`; Menu `ui_system_settings`.
- P(Doom): `doom.png`; RISING `indicator_doom_rising`.
- Left buttons: Actions `ui_guide_actions` (also on the Actions header and "Choose actions"), Upgrades `button_upgrade_normal` (also on its header), Staff `resource_morale` (roster and morale; `ui_staff_management` is three human silhouettes, so not used), Ledger `ui_governance_oversight`, Guide `ui_guide_book`. Feedback `ui_control_bug`.
- Attention header and Reserve hours: `resource_action_points` (hourglass). Undo `ui_control_back`, Clear `ui_control_clear`.
- Actions: Fundraising `resource_money`, Financing `ui_budget_finance`, Hire Staff `button_hire_normal` (also on every "Hire:" play), Work Your Connections `action_publicity_network`, Onboard `employee_status_training`, Safety Research `action_research_alignment`, Capability Research `action_research_ml_fundamentals`, Publish Safety Paper `open_source_release`, Purchase Compute `action_facility_upgrade_compute`, Safety Audit `employee_role_auditor`, Operations `employee_role_engineer`, Office `action_facility_expand_office`, Scouting `action_research_monitoring`, Strategic `ui_guide_strategy`.
- Scouting choices and plays: Read the Literature `resource_papers_small`.

**New, needs art** (drawn in the same 64px tile, dark ground with one warm glyph; flatter than Pip's painted icons): Advertise a Role (pinned notice), Travel & Conferences (suitcase), Publicity (megaphone), Post Online (speech bubble), Go to Meetups (two glasses). They are `new_*_64.png` in `assets/icons/`.

**Could not / judgement calls:**
- Hire Staff's icon is Pip's head-and-shoulders pictogram. If that counts as a person, it needs new art.
- Two Pip icons now serve two things each in the game: `open_source_release` (Publish Safety Paper and Open Source Tools) and `employee_role_engineer` (Operations and the Compute Engineer role). Neither pair appears in the same view here.
- Upgrade rows have no icons: only 3 of the 7 have a fitting one, and a mixed column would misalign.
- No icons on Under Way, the event choices or Commit.

Visual pass (all 6 renders plus the x6-expanded plan): checked by eye and with `?check=1`, CLEAN on every view. Fixed along the way: folder blockers wrapped to 3 lines (folder widened to 470px); the plan row icons pushed the columns out of line (drawer widened to 724px, name column clamped).

## Round 3 fixes (council r3x)

1. Left buttons (every view): Staff now uses `ui_staff_management` and Ledger uses `ui_budget_finance`. The Financing action moved to `action_funding_loan` so it stays distinct from Ledger. The smiley, gavel and `open_source_release` files were removed from `assets/icons/`.
2. Publish Safety Paper uses `paper.png`, the same icon as Papers in the top bar.
3. Plan: when the list scrolls, the header and Total rows get the same 24px right gutter, so the columns line up in both states. The drawer is 768px wide (was 724), so "x6" sits well clear of "6 plan". Long names would clip inside their own column rather than push into the hours column.
Hire keeps `button_hire_normal` until Alex answers the open question.
Visual pass: all 6 views plus `?view=plan&expand=read`, by eye and `?check=1`: CLEAN.
4. Plan (recheck): the native scrollbar is now hidden on the scrolling play list (`scrollbar-width:none` and `::-webkit-scrollbar{display:none}`), so the orange rail is the only bar. Rows, headings and Total share the same 24px gutter in every browser. Checked with renders made without `--hide-scrollbars`: `?view=plan&expand=read` has no grey bar and its columns line up, and plan.png was re-rendered the same way. `render.sh` no longer hides scrollbars.

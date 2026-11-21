# E. Rooms and Stations -- round 2

**Flow.** Home is the founder's seat on the mezzanine: Pip's office fills the screen with the operator in the foreground, and only the month, P(Doom), reputation, Attention left, the top of the plan and Commit sit over it. Everything else is a station opened from the left-hand buttons, owning its own state.

**Menus.**
- Actions [A]: the card file. All 17 actions in two columns, each card with hours, cost and blocker; money, compute, research, papers and hours left in its header. [Esc] back.
- Door (view `door`, Scouting): opens beside the card file (Pip's A -> B); choices with cost, blocker, "n queued". [Esc] closes it.
- Plan [P]: the CRT brought forward. Attention boxes and reserve, queue in order with reorder/remove, [Z] undo, [C] clear, totals, work under way with dates. [Esc] back.
- Lab Floor [F], Procurement [U], Records [L]: places as in round 1, not redrawn.
- Commit [Enter] stays bottom right in every view; in WATCH that slot is pause/speed.
Keys are proposals.

**Home elements (10):** calendar, P(Doom) dial, reputation gauge, five station buttons, This Month card (hours left, top 3 plan rows, "+2 more"), Commit. Panels cover about 19% of the screen; about 80% is art or open space.

**Kept from round 1.** The materials and fiction (card file, manila doors, LABTERM CRT, hanging P(Doom) dial, paper gauges, memo across the desk), all agreed game facts, the m5 queue and the WATCH fixture.

**Weakest point.** Money, compute and research left the home screen; they appear in Actions, where costs are read. Lab Floor, Procurement and Records are not redrawn. The operator is still a placeholder silhouette.

**Visual pass (six renders).** Fixed: Safety Audit card overflowing the card file; hours box broken by a CSS class collision with the Plan menu; gantt labels crossing gridlines; "[x]" touching its text in WATCH. Checked: left alignment per group, no icons, smallest text 15px, controls 16px+, no overlap, overflow or clipping, no near-black flat grounds; home's open space is the office art.

## Round 2 fixes

1. Plan: Attention boxes now filled = hours left, empty = spent (0/12 PLAN, 5/8 OPS filled), matching the home bars.
2. Plan: footer reads "Queued cost: $60,300 + 6 rep . 14 plays"; "Held for events at Commit: 5h" (untyped: planning left + operating left + reserve) sits under the reserve. Repeated plays are groups: "Read the Literature x8 [+] 8 plays" collapsed, "Post Online x3 [-] hide" expanded into 05.1-05.3, each play with its own ^ v x.
3. Actions: the three research cards show "x 22 research short" (32 for Publish) beside the "no planning hours" blocker.
4. Door: every choice has an Add control (dimmed when blocked); Go to Meetups has focus (amber outline, "[Enter] Add"). Only the folder shows [Esc]; the card file's button reads "Back to desk", and Commit drops its Enter keycap while the slip owns Enter.
5. WATCH: "Cash in hand $79,700" above the priced choices; day card reads "14 plays (5 rows) done" with an "[O] 01 Nov outcomes" button.
6. Home unchanged: no spend or held hours added.
7. Plan: the queue is bounded to a 306px area that scrolls inside the CRT, with a drawn amber scroll track when it overflows, so totals and Under Way dates never move. Checked with Read the Literature x8 expanded (`?view=plan&open=x8`): all eight plays reachable by scrolling, totals and dates visible. plan.png still draws x3 open, nothing clipped.
Also: gauge scale marks raised to 16px. Visual pass redone on all six renders (fixed: sub-row numbers touching names, group controls misaligned, day-card line clipped).

## Round 3

**Removed.** The operator silhouette (head, shoulders and chair) from every view; that area is now empty office art. Suggested use, not drawn: leave it empty, and let the month's events or the office tier show there (a lamp left on, a box of files).

**Pip's icons used** (copied to assets/icons/, shown at one size per place: stations 48px, action cards 40px, door slips 32px, resource boxes 36px, plan rows 26px, labels 20-28px; each on the same dark tile so framed and unframed icons line up):
- Stations: Actions `ui_guide_actions`, Plan and the This Month card `ui_config_date`, Lab Floor `ui_staff_management`, Procurement `button_upgrade_normal`, Records `ui_save_archive`.
- Frame: P(Doom) `doom.png`, Rising `indicator_doom_rising`, Reputation `reputation.png`, Commit `ui_control_confirm`.
- Resources: `money.png`, `compute.png`, `research.png`, `paper.png`; hours left and held hours `resource_action_points` (hourglass).
- Actions: Fundraising `ui_guide_resources`, Hire Staff (and every Hire row, both hiring choices on the memo) `button_hire_normal`, Work Your Connections `network`, Onboard New Hires `employee_status_training`, Safety Research `action_research_robustness`, Capability Research `action_research_ml_fundamentals`, Publish Safety Paper `paper.png`, Safety Audit `action_policy_audit_requirement`, Travel & Conferences `action_policy_international_cooperation`, Purchase Compute `action_facility_upgrade_compute`, Operations `ui_system_settings`, Office `action_facility_expand_office`, Financing `action_funding_loan`, Scouting `employee_status_investigating`, Strategic `ui_guide_strategy`.
- Scouting choices and plan rows: Read the Literature `ui_guide_book`, Go to Meetups `action_management_team_building`; Decline Offer `ui_control_cancel`.

**New, needs art** (drawn in the same frame, palette and weight; `assets/icons/new_*.svg`): Advertise a Role (pinned job notice), Publicity (megaphone), Post Online (speech bubble). No icon in the set shows these.

**Not done / notes.** No icons on utility buttons (Back, Esc, Undo/Clear, reorder, speed) to keep them quiet. Several mapping.json choices were not used because the icon shows something else (e.g. transparency for Publicity, network for Scouting, emergency shutdown for Strategic). Visual pass redone on all six renders: fixed the Lab Floor label wrapping (dock widened to 410px), the "[+] 8 plays" toggle pushing plan columns out of line (columns narrowed), and checked x8 expanded still scrolls inside the CRT.

## Round 3 fixes

1. Travel & Conferences (actions and door views): the globe-handshake `action_policy_international_cooperation` is replaced by a drawn suitcase, `assets/icons/new_travel.svg` (new, needs art); the unused PNG is removed from assets.
2. Plan: the column-heading row now has the same 22px right gutter as the scrolling rows, so HOURS, COST and ORDER sit over their columns. Visual pass redone on actions, door, plan and `?view=plan&open=x8`.
Left as is (question for Alex): the WATCH memo art with two figures, and the Staff and Hire icons.

# C. The Paperwork Desk -- rounds 2 and 3

**Flow.** Home is the founder's desk: Pip's empty office fills the screen and a few desk objects open the menus. Pull out the card drawer to add plays, lift the clipboard to order the month, stamp Commit, then watch the month on the teleprinter while memos land.

**Menus (open / close).**
- Action cards: card box, `A`; close `Esc`. All 17 actions with costs, stamped blockers, "on form" tags; folders open in place, `Esc` closes the folder first.
- Schedule (Form A-20): clipboard, `P`; close `Esc`. Rows with order and remove, hours, reserve, totals, work under way, research quality, Undo `Z`, Clear `C`.
- Staff `S`, Upgrades `U`, Ledger `L`, Guide `G`: one object each (not drawn yet). Only `L` exists in the game; the rest are proposed keys.
- Commit: the stamp, `Enter`, always bottom-right; in WATCH it becomes Paused.

**Home elements (11):** calendar, accounts slip, P(Doom) counter, reputation dial, card box, schedule clipboard, Staff, Upgrades, Ledger, Guide, Commit. Panels cover about a fifth of the screen; about 80% is office art, desk wood or open space.

**Pushback.** I kept one slim accounts slip on home: money and research decide which cards are blocked.

**Kept from round 1.** Card vs folder shapes; stamped reasons; "on form" tags; Form A-20; the fixed stamp; P(Doom) with RISING; the reputation dial; the memo; the teleprinter; the 14-row fixture.

**Weakest point.** The action drawer is still the busiest screen (17 cards). Staff, Upgrades, Ledger, Guide and the month-end ledger are not drawn.

**Visual pass (six renders).** Desk objects share a bottom line; 16px on everything operated, 15px only on prose; no overlap, overflow or clipping (fixed: a class collision that hid operating boxes, stamps overrunning cards, the folder covering blockers, the wrong card count in month 1); open areas are art, not dead panels; no near-black grounds.

## Round 2 fixes

Rules: hour boxes are filled for hours LEFT, empty for spent (home clipboard, Form A-20; text says "N of M left"); only the topmost layer shows Enter/Esc (Commit drops its Enter under any menu; the drawer's Close drops its Esc while a folder is open); operational labels raised to 16px; every repeated play keeps its own row with reorder and remove.
1. Menus now span the desk band (x 48-1560, down to the screen edge) so no clipboard, card box, Ledger, Guide or second set of hour boxes shows; only the dimmed Commit stamp stays visible.
2. Home: every key cap on a desk object sits bottom-right (A, P, S, U, L, G, Enter).
3. WATCH clipboard: "Planning 12 hr spent / Operating 3 hr spent / Held for events 5 hr"; no typed free counts.
4. Rule 1 applied on home and in the form (November: 0 of 12 planning filled, 5 of 8 operating filled; July: all filled).
5. 16px: clipboard Planning/Operating, accounts-slip labels, form column headings and section heads, shortcut subtitles, drawer category tabs, memo and teleprinter labels. 15px remains only on prose (card-box subtitle, folder-choice flavour lines) and the form identifier.
6. Form row 2 shows "Hire Staff" like the others.
7. Door: the source folder has an amber ring on its slot wrapper (outside the clip-path); one Esc (the folder's).
Visual pass redone on all six renders.

## Round 3

**Removed.** The operator silhouette (head, shoulders, chair) from every view; its code is gone. The space between the clipboard and the shortcuts is now empty office and desk. Suggested use, not drawn: a mug, the office cat or a desk lamp whose light follows the doom band.

**Pip's icons used** (copied to assets/icons/, from godot/assets/icons/). Sizes: 36px on desk objects, action cards, folder heads and form titles; 28px on the P(Doom) and reputation labels; 24px on the accounts slip, menu chips, buttons, section heads and form rows. A form row carries the icon of the card it came from.
- Money resource_money; Compute resource_compute_small; Research resource_research_small; Papers resource_papers_small; Reputation resource_reputation; P(Doom) resource_doom_small; Planning/Operating/Founder's hours resource_action_points.
- Desk: Action cards ui_guide_actions; Schedule ui_config_date; Staff file ui_staff_management; Upgrades button_upgrade_normal; Ledger ui_budget_finance; Guide ui_control_help; Commit button_confirm_normal; Paused ui_control_pause.
- Cards: Fundraising ui_guide_resources; Financing take_loan; Purchase Compute action_facility_upgrade_compute; Hire Staff button_hire_normal; Work Your Connections network; Onboard New Hires employee_status_training; Safety Research resource_safety_small; Capability Research action_research_ml_fundamentals; Publish Safety Paper resource_papers_small (same as Papers); Safety Audit employee_role_auditor; Scouting action_research_monitoring; Operations employee_role_engineer; Office action_facility_expand_office; Strategic ui_guide_strategy.
- Scouting choices: Go to Meetups action_management_team_building; Read the Literature ui_guide_book.
- Controls: Close ui_control_cancel; Undo ui_control_back; Clear form ui_control_clear.

**New, needs art** (SVG in the same tile style): Advertise a Role (pinned notice), Travel & Conferences (suitcase), Publicity (megaphone), Post Online (speech bubble).

**Not done / judgement calls.** Fundraising and Financing are both money bags in Pip's set (gold bag vs chained sack); a distinct Fundraising icon would help. No icon on the RISING tag, the reorder arrows or the remove x (glyph-only controls). Visual pass redone on all six renders: icons aligned left of their labels at one size per place, no clipping (fixed: accounts slip ran under P(Doom), clipboard footer clipped).

## Round 3 fixes

1. Form A-20 rows now carry their own play's icon, the same as the door view: Go to Meetups (team_building), Read the Literature (guide_book), Post Online (new bubble), Hire: Safety Researcher (button_hire_normal), Work Your Connections (as its card), Desperation Lever (new lever, "new, needs art": no lever icon in Pip's set).
2. Financing now uses the framed action_funding_loan, Work Your Connections the framed action_publicity_network (actions, door, plan). take_loan and network removed from assets/icons/.
Re-rendered actions, door and plan; visual pass redone on those three. Home, home-m1 and watch do not show these icons and are unchanged.

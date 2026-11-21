# A. The Desk -- round 2

**Flow.** Home is Pip's office seen from just behind the operator's chair, with a few wall instruments and a desk terminal. Every detail lives in a menu opened from the shortcut rack (plate or key); each menu shows its own state and closes back to the desk, where Commit never moves.

**Menus (open / close):**
- Actions `A`: all 17 actions with cost, blocker stamp and in-plan count, plus money, compute, research, papers. Close with `A`/`Esc`.
- Door (Scouting folder): its slips rise above it beside a detail card; Enter adds the lit slip, `Esc` puts it back.
- Plan `P`: the terminal, full size. One row per play with up/down/remove, Undo `Z`, Clear `C`, costs, under-way dates, Research Quality. Close with `P`/`Esc`.
- Upgrades `U`: the drawer, with a Ledger divider. Close with `U`/`Esc`.
- Staff `E`, Ledger `L`, In-tray `R`, Guide `F1`: on the rack, not drawn.

**Home elements (6), plus the art:**
1. Calendar.
2. P(Doom) dial.
3. Reputation meter.
4. Terminal: Attention, first three plays, total.
5. Shortcut rack (7 plates).
6. Commit, with "Held for events".

**Share of home.** About 31% UI, about 69% art or empty space (room, operator, desk).

**Kept from round 1.** The desk fiction, amber CRT plan, slips versus folders, stamps and badges, dial and meter, Commit's place, the drawer, the folder opening and the fixture. WATCH keeps the operator, the event slip and the clock housing.

**Weakest point.** The terminal is still the largest home object (about 12%), and the plan's seven "Read the Literature" rows repeat. Open menus dim the art.

**Visual pass (7 renders).**
- Siblings are left-aligned. No icons.
- Nothing is under 14px; controls are 16px or more.
- The self-check found no overflow and no text outside its box. Its only overlaps are objects that a menu covers whole, and the rotated calendar.
- Fixed in this round:
  - Menus cut into the dial and the rack.
  - The upgrades spilled out of the drawer.
  - The meter's labels were clipped.
  - The terminal's text bled through the dimmer.
- No flat near-black backgrounds.

**Round 2 fixes** (council r2s, items 1-7 and the rules for all concepts)
1. Attention bars: filled = hours left, empty = spent, with the "N free / N left" text beside them. Home shows 0/12 planning and 5/8 operating filled (month 1 starts full); so do Plan and the Actions header.
2. Shortcut rack: no plate is lit on home. Only the open menu's plate is lit (Actions, Plan or Upgrades).
3. Home terminal: the reserve row and the cost total are removed. Attention and the first three plays remain.
4. Actions:
   - The header shows planning and operating hours left, with bars.
   - Hire Staff keeps its "open >" control beside the NO PLANNING HRS LEFT stamp.
   - The three research actions add their shortfall: SHORT 22 / 22 / 32 RESEARCH.
5. Plan: the reserve row has "-" / "+" controls and is untyped. The calendar is hidden while the terminal fills the view.
6. Keys:
   - Door: only the folder's Esc shows; the hand's close keys step back, and Enter sits only on the focused slip.
   - Commit hides its Enter whenever any menu is open (rule 2).
7. Text: column and under-way headings are now 16px. The self-check finds no text under 14px and no overflow; all operational text is 16px or more.
- Rule 4 (one target per repeated play) was already met: one row per play.

**Round 3** (icons and the empty office)
- **Removed:** the operator silhouette (head, shoulders and chair) and its glow from every view: home, home-m1, actions, plan, door, upgrades and watch. That stretch of floor is now empty office art, with no new UI in it.
- **Suggested use (not drawn):** in WATCH, staff sprites could cross that floor as the month runs.
- **Pip icons used** (copied to assets/icons/; one size per place: rack 32px, action cards 36px, plates 24px, header readouts 22px, menu titles 30px):
  - Rack and menu titles:
    - Actions `ui_guide_actions` (hand pointing)
    - Plan `action_policy_audit_requirement` (checklist clipboard)
    - Staff `ui_staff_management`
    - Upgrades `button_upgrade_normal`
    - Ledger `ui_budget_finance`
    - In-tray `ui_save_archive`
    - Guide `ui_guide_book`
  - Readouts: P(Doom) `doom.png`, Reputation `reputation.png`, Money `money.png`, Compute `compute.png`, Research `research.png`, Papers `paper.png`.
  - Actions:
    - Fundraising `ui_guide_resources` (money bag)
    - Financing `action_funding_loan`
    - Hire Staff `button_hire_normal`
    - Work Your Connections `action_publicity_network` (handshake)
    - Onboard New Hires `employee_status_training` (cap)
    - Safety Research `resource_safety_small` (shield)
    - Capability Research `action_research_ml_fundamentals` (network)
    - Publish Safety Paper `paper.png`
    - Safety Audit `employee_role_auditor` (magnifier on a checklist)
    - Scouting `employee_status_investigating` (eye)
    - Purchase Compute `compute.png`
    - Operations `ui_system_settings` (gear)
    - Office `ui_infrastructure_facilities` (building)
    - Strategic `ui_guide_strategy` (knight)
  - Scouting folder: Read the Literature `research.png`, Go to Meetups `action_management_team_building`.
- **Mappings I did not follow:**
  - Travel's mapped globe-handshake shows a policy, not travel.
  - Operations and Office both map to `expand_office`.
  - Publicity's mapped open folder doesn't show publicity.
  - Strategic's mapped emergency-shutdown button doesn't show strategy.
- **New, needs art** (SVG, drawn in the same teal-glyph-on-dark style):
  - `new_publicity_megaphone` (Publicity)
  - `new_advertise_notice` (Advertise a Role: pinned notice with a +)
  - `new_travel_suitcase` (Travel & Conferences)
  - `new_post_online` (Post Online: speech bubble)
  - `new_feed_tape` (Feed: teleprinter printout)
- **Visual pass (7 renders):**
  - Every icon sits beside its label, never replacing it, and is placed the same way within each group.
  - The self-check found no overflow and no text under 14px.
  - I fixed the Actions header, which ran past the menu edge once icons were added; it now reads "THE HAND".
- **Could not do:** nothing.

**Round 3 fixes** (council r3x, A items 1-3)
1. Plan plate: now Pip's calendar `ui_config_date`, replacing `action_policy_audit_requirement`, which looked like the Safety Audit icon. It appears on the rack in home, home-m1, plan and watch; the Plan screen's title has no icon.
2. Read the Literature (door view): now `resource_papers_small`, replacing `research.png`, which already stands for the Research balance.
3. In-tray plate: now `new_inbox_tray` (new, needs art): two papers in a tray with a teal rim, in the same style as the other new icons. It replaces the open safe `ui_save_archive`.
- I removed the two replaced icons from assets/icons/. Re-rendered home, home-m1, plan, door and watch; the self-check is clean (no overflow, no text under 14px), and I checked the icons by eye.

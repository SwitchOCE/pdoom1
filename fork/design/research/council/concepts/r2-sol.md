VERDICT: CHANGES NEEDED

I inspected all 14 revised 1920x1080 renders and checked the mock-up HTML and relevant Godot source. The statuses below assess the rendered design and fixture, with no live Godot run or control testing. Item numbers follow the agreed round-one list. [Agreed fixes](C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r1-agreed.md)

A: CHANGES NEEDED

**8/10**

1. **Done.** In the July and November lower rack, Connections shows 2 operating hours and 6 reputation and is available. Onboard shows its variable operating and cash costs with an appropriate reason for each depicted state.
2. **Done.** The November CRT depicts 13 individually editable rows, Undo/Clear, and valid replacements for Pay the Bill. The fixture sums to 12 planning hours, 3 operating hours, $100,300 and 15 reputation in upfront costs. The Scouting parent badge (10) matches the three child badges (7, 1, 2).
3. **Done.** July 30 and 31 are visible. The rack keeps existing cards in place and appends the two November cards.
4. **Partly done.** The labels, badges and prices reach 16px. In July and November the wooden rail covers the bottom edge of the upper-tier blocker stamps and add/open hints. It also crosses lower-tier controls at the bottom. The rail starts 154px into a 164px card, above the stamp border. Move the rail or the footers far enough apart to show each full stamp and affordance. The render exposes this overlap even though the text self-check reports clear leaves. [Rack source](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/concept.html:565)
5. **Done.** The November CRT gives the dates their own column, clear of the JAN/FEB rules.
6. **Done.** The open Scouting view uses a lighter dimmer, a compact detail sheet, and only one visible Enter hint. The key queue rows and risk readouts remain legible.
7. **Done.** The Upgrades drawer has an explicit Open Ledger target and the duplicate footer label is gone.
8. **Partly done.** The WATCH memo is eligible in November, the prices and free exit are correct, and the rectangle behind the operator is gone. **The queue and counters still contradict one another.** The upper-left CRT shows rows 9-13 pending, and the teleprinter spreads scheduled results over Nov 1-14. The right counter already includes all seven reading plays and both posts. The game applies the queued batch in order before playback. Mark the batch outcomes on Nov 1, keep the later memo date distinct, and aggregate result lines to fit the teleprinter. Keep 21.5 in the fixture and display 22 on the reputation gauge to match the game's scalar formatter. The fixed warning roll of +2 is within the source range. [A WATCH](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/watch.png) [Fixture and WATCH source](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/concept.html:628) [Batch execution](C:/Users/keech/Documents/pdoom1/godot/scripts/core/turn_manager.gd:559) [Public Warning](C:/Users/keech/Documents/pdoom1/godot/scripts/core/actions.gd:720) [Number formats](C:/Users/keech/Documents/pdoom1/docs/NUMBER_FORMATS.md:38)

C: CHANGES NEEDED

**8/10**

1. **Done.** The People cards show operating costs and the July blocker is truthful. The November fixture depicts one hire with an onboarding step available. Form A-20's 14 rows account for 12 planning hours, 3 operating hours, $60,300 and 6 reputation in upfront costs. The Scouting badges reconcile at 11 plays. Desperation Lever is a valid one-planning-hour choice with no upfront cash cost. [Financing data](C:/Users/keech/Documents/pdoom1/godot/data/actions/financing.json:25)
2. **Done.** The November Strategic folder shows "1 open now". With the displayed balances and hours, Corporate Espionage is the sole affordable choice. [Strategic data](C:/Users/keech/Documents/pdoom1/godot/data/actions/strategic.json:5)
3. **Done.** November's wall instrument reads "40.2% RISING", with the permanent loss sentence removed.
4. **Done.** The form headers are distinct, the dates have 14px clearance, the badge corner is consistent and clear of titles, and the arrows occupy 26px controls. Unavailable titles retain contrast.
5. **Done.** The agreed operational stamps, badges, keycaps, hour-pool labels, row numbers and tabs are 16px. The full corrected WATCH prices fit.
6. **Done for the agreed layout and copy.** The paperclip clears the stamp, the paid replies show one held hour, the pause face says "awaiting your reply", and both full-office views close the thumbnail blinds. The dated WATCH form also marks all 14 outcomes on Nov 1. **New display defect:** the top right WATCH reputation gauge prints 23.5 raw. Its fixture math reconciles, but the live HUD uses whole-unit rounding. Show 24 on the gauge and keep 23.5 for calculation. [C WATCH](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/watch.png) [HUD formatter call](C:/Users/keech/Documents/pdoom1/godot/scripts/ui/main_ui.gd:1151) [Scalar rounding](C:/Users/keech/Documents/pdoom1/godot/autoload/game_config.gd:656)

E: CHANGES NEEDED

**7.5/10**

1. **Done for queue and cost math.** The November CRT and time card agree on 14 plays, 12 planning hours and 3 operating hours used. The footer shows $60,300 and 6 reputation. Connections stays available at two operating hours. One new hire fits alongside the existing employee because the default cap is two employed staff. [Desk cap](C:/Users/keech/Documents/pdoom1/godot/scripts/core/office.gd:84) [Headcount](C:/Users/keech/Documents/pdoom1/godot/scripts/core/game_state.gd:795)
2. **Done.** The top frame adds "RISING", labels 100 on the reputation gauge, and gives the Desk CRT visible clearance below the doom instrument.
3. **Partly done.** The July/November rack aligns + and >, links the inset OPEN tab to the folder, and clears space beneath Strategic. Hire Staff shows the correct role cost and remains inspectable with a parent summary. The visible November Onboard reason is plausible, but the HTML infers "no hires to onboard" from any positive staff count. Set the fixture's checklist eligibility explicitly and derive the blocker from it. Record that the role choices themselves show the planning-hour blocker when inspected. An extra render is unnecessary. [Rack source](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/concept.html:306) [Onboarding eligibility](C:/Users/keech/Documents/pdoom1/godot/scripts/ui/hiring_panel_controller.gd:139)
4. **Partly done.** WATCH uses the eligible Talent Opportunity memo with the right option prices. The CRT marks all batch outcomes on Nov 1, and the visible $79,700, 12 research and rounded 25 reputation reconcile with the shown action effects. **The top time card still displays "OPS 5 left" beside "HELD FOR EVENTS 5h".** The reserve has already claimed those five hours. In WATCH, remove the PLAN availability readout or show only typed hours spent, with the five untyped held hours stated once. [E WATCH](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/watch.png) [Time-card source](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/concept.html:487) [Attention and reserve](C:/Users/keech/Documents/pdoom1/godot/scripts/core/month_plan.gd:216)
5. **Done.** The Lab Floor camera now places Maya Haddad's card directly above her sprite.

## Non-blocking

- The revised C and E views keep action titles, blockers and prices clear at this size. I saw no actionable icon mismatches or new near-black flat backgrounds in A, C or E. C's empty form, A's ruled blank queue and E's exposed Lab Floor art read as deliberate negative space.
- E's grouped x8 and x3 queue rows save room. Clarify whether the row controls act on the group or an individual play when the mock-up becomes interactive. The existing WATCH image also still uses the keynote asset, which could give way to a recruitment image if one already fits.

## Disk report

Only r2-sol.md was written. No scratch files.

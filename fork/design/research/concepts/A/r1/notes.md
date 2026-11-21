# A. The Desk

**Concept.** You sit at the founder's desk: the plan is on the CRT, the hand is typed slips and manila folders along the desk's front edge, and P(Doom) is a brass wall dial. Commit swivels the chair to the floor (WATCH): operator silhouette, running plan, arriving slips.

**Places.**
- `m1`/`m5` the desk (PLAN).
- `door` a folder opened: its slips rise above it, with a detail card beside them (ABBBCCC); Esc puts it back.
- `place2` the Upgrades drawer pulled out, with a Ledger divider [L].
- `watch` the chair turned to the floor; an event slip lands while play is paused.

Also on the desk: calendar, staff board [E], in-tray [R], handbook (Guide), and a Research Quality switch on the bezel. In WATCH the commit housing becomes the month clock.

**Borrows from.** Papers, Please (desk, slips); Not For Broadcast (a hardware box per readout); Frostpunk (one dial for the deadly number); Civ build queue (plan in order); SHENZHEN I/O (handbook binder).

**Does well.** Slips ("add +") and folders ("open >", tab) read differently by shape. Every card shows its cost, and a red stamp gives the reason when it is blocked. Attention has one home on the CRT: square amber planning pips, round teal operating pips, and the reserve.

**Weakest point.** The office art shows only around the edges in PLAN. At 17 slips the cards are 162px wide, so a later phase with more actions needs a third row.

**Visual pass (redone on round-1 renders).**
- Siblings are left-aligned. No icons; category is shown by a coloured tab plus a word.
- No text is under 14px, and every tab, stamp, badge and key hint is 16px.
- A self-check (`concept.html?view=..&check=1`) reports no overflow, no overlapping text and no text under 14px in m1, m5 and watch. In door and place2 the only overlaps are whole cards that the open folder or drawer covers on purpose.
- The m5 queue is a fixture built from real data, not from a save.

**Fix round 1** (council r1, items 1-8)
1. Work Your Connections now reads "2 op hr / 6 rep" and is available in m1 and m5. Onboard New Hires reads "op hr + money / varies by step", stamped NOBODY HIRED YET (m1) or NO HIRES WAITING (m5).
2. The m5 queue has one row per play (13 rows), each with up, down and remove, plus Undo [Z] and Clear [C].
   - Pay the Bill is replaced by valid, priced plays: Safety Audit and Public Warning.
   - Hours (12 planning, 3 operating), the cost line ($100,300 + 15 rep), Held for events (5 hr) and every "in plan" badge are computed from the rows. Scouting reads 10 = Read the Literature 7 + Post Online 2 + Go to Meetups 1, and door.png shows 7 / 1 / 2.
3. The calendar renders its sixth row (30, 31). The card rack uses fixed slots, so no card moves between m1 and m5; Safety Audit and Strategic join at the end of tier 2.
4. Tabs, stamps, badges and key hints are 16px. The event costs fit at 16px.
5. The under-way dates have their own DATE column, clear of the month rules.
6. door: the dimmer is lighter. The folder's slips and the detail card cover whole card slots, and the detail card fits its content. Enter is shown on "Go to Meetups" only; the Commit button hides its key while the folder is open.
7. place2: the Ledger tile reads "What the lab owes, by the month each bill lands", with OPEN LEDGER [L]. The duplicate UPGRADES plate is gone.
8. watch:
   - The event is Talent Opportunity, eligible in November 2017. The two hiring options read "$25,000 + 1 held hr"; Decline is free.
   - Counters show the state the game publishes after the batch runs: $39,700, research 9, reputation 21.5. The fixed +2 roll for Public Warning is stated in the code comment.
   - The feed uses the game's own messages. Held for events shows 5 hr, with no type.
   - The hard-edged rectangle is gone: the desk glow is removed and the halo sits inside the operator's frame.

**Fix round 2** (council r2)
1. Rack rail: the rail now sits under each row of cards instead of 154px into a 164px card, so no stamp or add/open control is crossed. Checked in m1, m5, door and place2.
2. WATCH:
   - All 13 plays show "[DONE] 01 Nov", because the game runs the committed batch at Commit, before playback (game_manager.gd:710-735).
   - The panel title is now "THIS MONTH - run at commit, 01 Nov".
   - The teleprinter gives the 01 Nov results with like plays grouped (Read the Literature x7, Post Online x2).
   - The Talent Opportunity memo stays on Nov 14, and the counters are unchanged.
3. WATCH reputation reads 22, a whole number as the game shows it. The fixture keeps 21.5 (the needle uses the exact value).

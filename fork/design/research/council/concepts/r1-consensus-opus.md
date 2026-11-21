# Round 1 consensus -- opus

## 0. Facts checked in the game source

| Question | Answer | Evidence |
|---|---|---|
| Hour type of Work Your Connections | **2 OPERATING** + 6 rep (the rep is a cost) | `scripts/core/hiring_pipeline.gd:142-147` calls `spend_attention(cost_att)` with no type; `month_plan.gd:252` defaults to `HOUR_OPERATING`. So Sol and opus are right. Neon's "2 plan hr or 2 op hr" is wrong, and so are C's and E's "2 plan hr" plus their "no planning hours" blocks. |
| Hour type of Onboard New Hires | **OPERATING**, per step, plus money for laptop and visa | `hiring_pipeline.gd:554-563` (`_pay_onboard` -> `spend_attention(att_cost)`, no type). C's "1 plan hr" and Neon's "1 plan hr + money" fix are wrong. Show it as "op hr per step + money". |
| Hire Staff at 0 planning hours | Blocked: every role is `approvals` (planning) | `data/actions/hiring.json`, all 7 roles `hour_type: approvals`. A marks it blocked; E and B do not (Neon's and Sol's catch is right). |
| C's "NONE AFFORDABLE" on Strategic (m5) | **Wrong.** The game checks costs against current resources, not money left after the queue | `scripts/ui/action_bar_renderer.gd:388-395`. Corporate Espionage (`strategic.json`: $100,000, 3 op, 20 rep) is affordable at $140,000 / 5 op / 32 rep. Neon is right. |
| What an event choice costs | Each handled option costs the window's own Attention (default 1 hr), taken from the reserve first; the ignore option is free. The option's own Attention line is stripped. | `window_resolver.gd:22` (`DEFAULT_ATTENTION_COST := 1`), `:165-175`, `:275-300` (Pip: "Adopting the cat also costs attention, which is not advertised"). Sol is right: A's cat slip and C's "Standard Hiring" omit the hour. |
| Are held/reserve hours typed? | The reserve books to the OPERATING family | `month_plan.gd:78-83` (`KIND_RESERVE: HOUR_OPERATING`). E's "HELD 5h OPS" matches the code; Neon's "make it untyped" fix is not needed. E's option prices are wrong for a different reason (row above). |
| Eligible WATCH events | Stray Cat is `turn_exact 7` (early July). Keynote Slot needs reputation >= 40. Talent Opportunity needs `min_turn 5` and is eligible in month 5. | `data/events/core_events.json:47-60, 414-420, 1214-1222`. A's November cat and E's Keynote at reputation 32 cannot happen. |

## 1. Shortlist and ranking

I **agree with Neon's shortlist** (A, C, E), and I **disagree with Sol's B**. B is legible, but Alex's main ask is diegetic flavour, and B is the weakest there among the readable concepts:
- the office is a faded wallpaper behind large dead areas (B m5 right column y ~520-880; place2 below Procurement);
- its operator is a translucent ghost (B watch).

Two of three members put B 5th.

I accept **A, C, E** as the shortlist. For the order, A has the best average position across the three answers (1, 2, 2), and C and E tie (C 2, 1, 4; E 3, 3, 1). I break the tie for C because its fixes are smaller and its ledger close is the strongest single flow. Proposed: **A, C, E, F, B, D**. F over B and D last follow the majority of two.

## 2. The other members' fix items for A, C, E

### A (Sol, Neon)
- Sol/Neon, reorder controls on the CRT queue: **agree.** Queue order is execution priority, C and E already have it, and A m5 shows only [x]. Also add Undo/Clear.
- Neon, July calendar clips 30 and 31: **agree.** Verified in A m1: the last row ends at 29, and July 2017 needs 6 rows.
- Neon, Financing "2 in plan" vs one Financing row: **agree.** A m5 queue has only 07 Pay the Bill. Scouting "3 in plan" vs slips 4+1+2: **agree.** Count one unit (plays) everywhere.
- Neon/Sol, stamps and badges at 14px to 16px: **agree.**
- Neon, WYC typing: **agree with a different fix.** It is "2 op hr . 6 rep", available, never a "no planning hrs" stamp.
- Neon/Sol, Onboard New Hires shows no cost: **agree, with a different fix.** Show "op hr per step + money", not "1 plan hr".
- Neon, rectangular glow box behind the operator's head in watch: **agree.** Visible at x ~830-1130, y ~560-720.
- Neon, watch money stale after [DONE] items: **agree.** It should be $79,700 after Meetups and the hire.
- Sol, the cat slip omits the window hour: **agree.** I merge this with my "event that can fire" item. Use an eligible event, and show +1 hr on handled options and free on ignore.
- Sol, July cards reflow when November adds two: **agree, as minor.** Keep cards in place.
- Sol, door view gives Enter two targets: **agree.** Add uses its key, and Commit keeps Enter. Sol, the door view dims the plan: **disagree** that it is blocking; focus dimming is normal.
- Sol, Pay the Bill shows "--": **agree, as minor.** Show the amount it pays (it settles the soonest-due loan, `actions.gd:618`), or swap the row for an action with a known cost.
- Sol, check a 7-choice door: **non-blocking.**

### C (Sol, Neon)
- Neon, paperclip crosses the NEEDS ANSWER stamp (C watch): **agree.**
- Neon, remove NONE AFFORDABLE from Strategic: **agree** (see section 0).
- Neon, rising state on P(Doom): **agree** (same as my item). Keep "lose at 100%" as a short label. Taking it out is not required.
- Neon, operational text at 14-15px raised to 16px: **agree** for stamps, badges, hour labels and key caps.
- Neon, gantt labels about 4px from the NOV rule, and the "on form" pills: **agree.** Merged with my badge item.
- Neon, Onboard cost missing on m1 ("1 plan hr + money"): **agree, with a different fix:** "op hr per step + money" on m1 and m5.
- Sol, Standard Hiring omits the window hour, and "Space resume" shows while a reply is pending: **agree to both.**
- Neon, redundant office thumbnail in the look-up views: **non-blocking** (taste).
- Neon, Upgrades/Staff not rendered: **non-blocking.** C already shows door, place2 and watch, which meets the brief.
- Sol, card file outweighs the form: **non-blocking.** It is a layout rebalance, not a defect.

### E (Sol, Neon)
- Sol/Neon, November queue does not balance: **agree.** Merged with my WYC and sum items. Neon's "add 1 plan hour" alone is wrong, because WYC moves to operating. Also add "+ 21 rep" to the footer total.
- Sol/Neon, rising state on P(Doom); Neon, the reputation dial lacks 100: **agree** (the second is minor).
- Neon/Sol, Hire Staff not blocked at 0 planning hours, and no per-role cost: **agree.** Show "7 roles . 1 plan hr each" and the blocked reason.
- Neon/Sol, Onboard cost: **agree, with a different fix:** op hr per step + money.
- Neon/Sol, OPEN tab overhangs the panel, and the door is not anchored to its row: **agree.** Merged with my "door from the row" item.
- Sol/Neon, render Procurement and Records: **agree on Procurement** (upgrades must be shown reachable). Records is **non-blocking**, because the brief needs one other place and Lab Floor is drawn.
- Neon/Sol, watch counters stale (money, reputation) and held hours shown twice: **agree.** Show held hours once.
- Neon, make the held hours and event costs untyped: **disagree** (section 0). Use the window's own 1 hr per handled option.
- Neon, replace the locked action rack in WATCH: **non-blocking** (a redesign).
- Neon, enrich the Lab Floor: **non-blocking**, except Sol's name tag, which sits left of its sprite. **Agree** to fix that as minor.

## 3. Proposed joint answer

**Ranking:** 1 A, 2 C, 3 E, 4 F, 5 B, 6 D.
**Shortlist:** A, C, E.

### A. The Desk
1. **Typed costs on cards.** m1/m5 cards: Work Your Connections "2 hr . 6 rep" becomes "2 op hr . 6 rep" (available in m5). Onboard New Hires gets "op hr per step + money" above its stamp.
2. **Editable queue.** m5 CRT rows 01-09 show only [x]. Add up/down per row, plus Undo and Clear in the CRT footer. Use one row per play, or rows that expand.
3. **Badge counts.** m5/door tray: Financing "2 in plan" becomes 1 (only Pay the Bill). Count plays on every folder and slip (Scouting = 7, not 3). Derive the cost total from the rows. Show what Pay the Bill pays, or swap that row.
4. **Gantt labels.** m5 CRT: "lands ~mid-Dec 2017" crosses the JAN rule and "decision ~Jan 2018" crosses the FEB rule. Put the dates in a fixed label column.
5. **Type floor.** Raise the blocked stamps, category tabs, "N in plan" badges and the watch slip's option costs from 14px to 16px.
6. **Calendar.** m1 July pad stops at 29. Add the sixth row (30, 31).
7. **Operator.** No silhouette in PLAN (m1/m5). Add Pip's operator, for example a chair back and shoulders at the desk edge or a reflection in the CRT. In watch, replace the blob with a silhouette and remove the hard-edged glow rectangle behind the head.
8. **Watch state.** The November Stray Cat cannot fire. Use Talent Opportunity (eligible month 5), price each handled option "+1 hr" and the ignore option "free", and update money ($79,700) after the [DONE] rows.
9. **Small consistency.** Keep cards in place when November adds Safety Audit and Strategic. Give the door view one Enter target. Shrink the door detail card to its content (empty y ~900-1010). Show "Liability Ledger -- clean" in place2, not the placeholder, and drop the duplicate UPGRADES button.

### C. The Paperwork Desk
1. **WYC.** m5 card and form row 4: "2 plan hr" plus a NO PLANNING HRS stamp become "2 op hr, 6 rep" with no stamp. Re-pick the form so the boxes and TOTALS still show planning used up and operating left.
2. **Onboard.** m1/m5: "1 plan hr + money" (m1 shows no cost) becomes "op hr per step + money", with the true reason.
3. **Strategic stamp.** m5: remove NONE AFFORDABLE (Corporate Espionage is affordable under the game's rule).
4. **P(Doom) rising.** m5 top readout: add a RISING tag beside 40.2%.
5. **Header and badges.** Form header "NO.ORDER" collides; give each column its own width. Put "on form N" in one fixed corner on every card and slip. Add at least 12px between the under-way date labels and the NOV rule.
6. **Type floor.** Raise the stamps, "on form" pills, hour-pool labels, row numbers, key caps and the memo option costs to 16px.
7. **Watch memo.** The paperclip crosses the NEEDS ANSWER stamp; move it. Price both paid hiring options "+1 held hr" (Standard Hiring omits it). Show the Space-resume hint only after the reply.
8. **Silhouette.** watch/place2: replace the keyhole placeholder with a proper operator silhouette.

### E. Rooms and Stations
1. **November balances.** WYC "2h PLAN" with "no planning hours" (action list, queue row 04) becomes "2h OPS", available. Re-pick the queue so the rows, the PLAN and OPS boxes and the "left" counts agree; today the rows sum to 11 plan hours against 12 shown used. Add "+ 21 rep" to the footer total.
2. **Rack costs and blocks.** Hire Staff shows "7 roles . 1 plan hr each" and "no planning hours" in m5. Onboard shows "op hr per step + money".
3. **One control per row.** Purchase Compute, Safety Audit and WYC have no add control. Add "+" in the door ">" column.
4. **Door anchored to its row.** The OPEN tab overhangs the rack by ~14px and the panel floats at the right. Keep the tab inside the frame and tie the panel to the selected row.
5. **Dial overlap and state.** The P(Doom) box overlaps the CRT bezel (y ~120-135, all views); move it. Add RISING in m5, and the 100 label on the reputation dial.
6. **Watch state.** Keynote Slot needs reputation >= 40; use an eligible event, priced "+1 hr" per handled option and "free" for ignore. Update money and reputation after the [x] done rows. Show held hours in one place.
7. **Procurement.** Draw the Procurement station (upgrade list, prices, "need $X more", return to Desk), so upgrades are shown reachable.
8. **Lab Floor tag.** place2: move the name tag directly above its sprite.

### Non-blocking (at most 3)
1. Every concept uses a placeholder operator. The winner needs one real silhouette asset (Pip's core image).
2. A merge (C's ledger-slip month close inside A) is Alex's call, not a fix.
3. C's look-up thumbnail, E's locked WATCH rack and Records station, and a 7-choice door test for A are polish for later.

## Disk report
Wrote only `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r1-consensus-opus.md`. No new scratch files. The round-1 crops (about 31 MB in `C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/18510e2e-a3f1-4406-bc1c-8247e8dffee0/scratchpad/`) can still be deleted.

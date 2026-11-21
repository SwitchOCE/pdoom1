VERDICT: SHORTLIST A C E

# Council round 1 -- opus

I looked at every render (m1, m5, plus door/place2/watch where made) at full size and in 2x crops. I checked hour types and costs against `godot/data/actions/*.json` and `scripts/core/` (`hour_type: approvals` = PLANNING; `doors`/`audits` = OPERATING; a call to `month_plan.spend_attention()` with no type spends OPERATING, `month_plan.gd:252`). I checked events against `data/events/core_events.json`.

Two data facts matter to several concepts:
- **Work Your Connections spends 2 OPERATING hours + 6 reputation** (`hiring_pipeline.gd:135-147`: `spend_attention(cost_att)` with no type). C and E show it as 2 PLAN hours, block it with "no planning hours", and queue it as planning. That is text that contradicts the game.
- **Onboard New Hires spends OPERATING hours too** (`_pay_onboard` -> `spend_attention(att_cost)`). C shows "1 plan hr" and blocks it for no planning hours.

## Scores (1-10)

| Concept | Flavour | Usability | Pip fit | Scope | Overall |
|---|---|---|---|---|---|
| A. The Desk | 8 | 8 | 7 | 8 | **8** |
| C. The Paperwork Desk | 8 | 8 | 7 | 6 | **7.5** |
| E. Rooms and Stations | 7 | 7 | 8 | 6 | **7** |
| F. Pure Terminal | 5 | 8 | 6 | 8 | **6** |
| B. The Mainframe OS | 5 | 8 | 5 | 8 | **6** |
| D. The Card Table | 5 | 5 | 5 | 3 | **4** |

## Ranking

1. **A. The Desk** blends the Papers, Please desk with the CRT monitor Alex named: calendar, brass P(Doom) dial, needle reputation meter, handbook, drawers. The CRT carries the plan, Attention has one home on it, every slip shows its cost and a stamped reason, and its data is the most accurate of the three. Weak points: the office shows only at the edges, and there is no operator silhouette in PLAN.
2. **C. The Paperwork Desk** is the purest Papers, Please register. Form A-20's totals add up, the "on form N" counts match the queue, the door opens out of its card, the ledger slip closes the month, and the memo has a portrait and a highlighted fact. Two actions have the wrong hour type and the wrong blocked stamp, and it has no CRT or terminal flavour in PLAN.
3. **E. Rooms and Stations** is the only concept with Pip's core image (the silhouetted operator facing the CRT) in PLAN. It also has places to move between, as Alex asked ("more screens and more flows"), and a lab-floor camera built from Pip's sprites. The data is wrong in places: WYC has the wrong hour type, and the queue does not add up to the Attention bar.
4. **F. Pure Terminal** is accurate, dense and fully keyboard-driven, with good camera panes, and its terminal pastiche is the style Pip named. It is the least like an office, the whole screen is a dark ground, and it has short teaching labels ("only rises", "100% = end", a key legend).
5. **B. The Mainframe OS** has a clean directory with correct hour types, but it reads as a generic 1990s app with the office as a faded backdrop. It has large dead areas, and its WATCH silhouette is a translucent purple ghost.
6. **D. The Card Table** queues actions that do not exist ("Apply for Grant" 2 plan hr, "Pitch Investors" 3 plan hr) and invents an event, a ledger and upgrade text. Its panels are near-black, its text wraps badly, slots 6-9 collapse into one stack with no controls, and there is no operator.

## Defects per concept

### A. The Desk
- m5 and m1, card "Work Your Connections": "2 hr . 6 rep" does not say the hour type (it is operating).
- m5 CRT, under-way gantt: the label "lands ~mid-Dec 2017" runs across the JAN 2018 column rule, and "decision ~Jan 2018" runs across the FEB rule.
- m1 and m5: the operator silhouette is missing from PLAN. Pip calls it the core UI image.
- watch: the operator is a flat blob shape, not a silhouette over the office.
- watch, event slip: the option costs "$500 / $100 / no cost" are about 14px on controls (floor is 16px).
- watch: "A Stray Cat Appears!" is shown on Nov 14 in month 5, but the event is `turn_exact 7` (it fires in July), so this state cannot happen.
- door: the detail card has about 110px of empty space (y 900-1010).
- place2: the Ledger tile is a placeholder ("next divider"). The bottom bar repeats an "UPGRADES" button next to the tab.
- m1/m5: the shelf is empty at the right end of row 2 (x ~1380-1570). Minor.
- CRT: faint scanlines run behind the queue text (findings pitfall 7). Minor.

### B. The Mainframe OS
- m1, the month ahead: the "No actions queued" box floats over the table grid, and the empty grid's column rule (x ~1090) does not line up with the COST header (x ~923).
- m1/m5: dead areas in the month-ahead window (y ~810-920), the directory foot, and the right column (y ~520-880, a darkened photo).
- place2: about 270px of dead space under the Procurement window.
- watch: the operator is a translucent purple ghost composite. The mail body is empty from y ~480 to 690.
- Doors and direct actions are told apart only by a small arrow or "+" at the row end. The "Commit the month" button carries an unexplained square glyph.
- Non-ASCII glyphs ("x10", the up and down arrows) will not survive the ASCII-only rule for strings in .gd files.
- "> Open folder + Queue action" is a permanent legend line.

### C. The Paperwork Desk
- m5 card and form row 4, Work Your Connections: "2 plan hr" with a "NO PLANNING HRS" stamp is wrong (it is operating, so it stays available). The form totals of "12 plan + 3 op" therefore misstate the queue.
- m5, Onboard New Hires: "1 plan hr + money" with a "NO PLANNING HRS" stamp is wrong (onboarding is operating).
- m1/m5 form header: "NO.ORDER" collides, with no gap between the columns (x ~905-1000).
- The "on form N" badges sit in different places: beside the title on folders (touching "Financing" and "Hire Staff"), but bottom-right on the WYC card and on door slips.
- watch memo: the option costs ("$25,000 + 1 held hr", "no cost") are about 14px on controls.
- P(Doom): no "rising" state is shown (the brief draws 40.2% rising).
- watch/place2: the operator is a placeholder circle-and-arc keyhole shape.
- Unavailable card titles are greyed to low contrast on cream (Safety Research, Advertise a Role).

### D. The Card Table
- m5 queue: slot 4 "Apply for Grant 2 plan hr" and slot 5 "Pitch Investors 3 plan hr" are not in the game. The Fundraising choices are Modest/Major Round, Business Loan and Research Grant, and Research Grant is 1 plan hr and needs a paper, which the player does not have.
- m5: the stack for slots 6-9 hides four queued items without their reorder or remove controls, and "#7 Strategic", "#8 Office Lease" do not name the action. "Priority order 1 -> 6" contradicts the 9 cards slotted.
- watch: "Unannounced Lab Inspection Request" is not in the event data (invented).
- place2: the ledger rows (payroll and lease, "Cash less queue") and the upgrade descriptions are invented and do not match the game's text.
- Readout boxes, hand, log and clock panels are near-black (#15110e-ish), against the brief and Pip's notes.
- Awkward wraps: "1 plan hr -- 10 / Res", "1 plan hr -- / $60,000", "5 plan hr -- 2 op / hr", "2 op hr -- / $40,000"; on watch, "(5 / left)".
- Card footers mix "Op choices open", "Open deck ->" and "Play to slot" on the same kind of card.
- No operator silhouette anywhere. The office is a thin strip at the top.
- Every slot card has a large empty middle (m5 y ~440-510). The watch right column is empty from y ~580 to 790.

### E. Rooms and Stations
- m5/m1 action list and m5 queue row 04: Work Your Connections "2h PLAN" with "no planning hours" is wrong (it is operating).
- m5 queue: the plan-hour rows sum to 11 (rows 01,02,04,05,06,08,09,11,12), but the Attention bar shows 12 of 12 used.
- Direct actions (Purchase Compute, Safety Audit, WYC) have no add control, while doors have a ">" button. The row controls are inconsistent.
- The P(Doom) dial box overlaps the CRT bezel top (x ~785-1135, y ~120-135) on every view.
- watch: "The Keynote Slot" needs reputation >= 40 (`keynote_slot`), but reputation is 32, so this state cannot happen.
- Procurement (upgrades) and Records (ledger, guide) are not drawn.
- place2 camera: isometric server racks next to a flat desk sprite (the perspectives clash). The centre art area is large and empty, but it shows the room.
- m5: the Scouting door opens in a fixed right panel, not out of the clicked row (only the "OPEN" tab links them).

### F. Pure Terminal
- m5 Scouting flyout: each blocked item and its "[-] no plan hrs left" line nearly touch (about 14px leading).
- The whole screen is a dark brown ground with scanlines, close to the "near-black" limit.
- Short teaching labels are on screen permanently: "only rises", "100% = end", "0 = end", "runs top to bottom", and the key legend "A-Q queue / open...".
- WYC "2 hr, 6 rep" does not say the hour type.
- watch: the operator is a circle-and-arc outline. The feed pane is empty from y ~700 to 990.
- place2: the SELECTED pane is empty from y ~400 to 640.
- m1: the 16-row empty queue is a large empty area (acceptable as the empty state).

## Fix lists for the shortlist

### A. The Desk
1. **WYC hour type.** m1/m5 card "Work Your Connections", "2 hr . 6 rep". Change it to "2 op hr . 6 rep".
2. **Operator in PLAN.** m1/m5 have no silhouette. Put Pip's silhouetted operator in PLAN, for example a chair back and shoulders at the desk's front edge between the CRT and the slips, or reflected in the CRT glass. In watch, replace the flat blob with a proper silhouette.
3. **Gantt labels cross column rules.** m5 CRT, "lands ~mid-Dec 2017" over JAN 2018 and "decision ~Jan 2018" over FEB. Move the date labels to a fixed column (as C does), or stop the label background before the next rule.
4. **Event choice cost size.** watch slip: "$500 / $100 / no cost" is about 14px. Make it 16px.
5. **Event that can fire.** watch, Stray Cat on Nov 14 (it is `turn_exact 7`). Use an event eligible in month 5, such as Talent Opportunity (`min_turn 5`).
6. **Ledger placeholder.** place2, tile "Liability Ledger -- next divider". Show the ledger's real summary ("Liability Ledger -- clean", as the game prints it), and drop the duplicate "UPGRADES" button in the drawer foot.
7. **Door detail dead space.** door view, the empty band at y ~900-1010. Shrink the card to fit its content.

### C. The Paperwork Desk
1. **WYC hour type and stamp.** m5 card and form row 4: "2 plan hr" plus a "NO PLANNING HRS" stamp. Make it "2 op hr, 6 rep" and remove the stamp (it is affordable with 5 op hr left). Re-pick the form so the hour boxes and "TOTALS" still match the brief's state (planning used up, operating left).
2. **Onboard hour type and stamp.** m5 card: "1 plan hr + money", "NO PLANNING HRS". Make it an op hr, and give the true reason, or none.
3. **Header collision.** m1/m5 form header "NO.ORDER". Give the two columns their own widths.
4. **Badge placement.** "on form N" sits beside titles on folders, touching "Financing" and "Hire Staff", but bottom-right on WYC and the door slips. Use one spot, the top-right corner, on every card and slip.
5. **Memo cost size.** watch memo: "$25,000 + 1 held hr", "$25,000", "no cost" are about 14px. Make them 16px.
6. **P(Doom) rising.** The m5 readout has no rising state. Add a short "RISING" tag beside 40.2%, a state not a delta.
7. **Silhouette art.** watch/place2 keyhole shape. Use a proper operator silhouette.

### E. Rooms and Stations
1. **WYC hour type.** m1/m5 action list "2h PLAN", "no planning hours", and m5 queue row 04. Make it "2h OPS"; it is available in m5.
2. **Queue matches Attention.** m5 queue sums to 11 plan hours against a bar showing 12 used, and after fix 1 it is 9 plan + 5 op. Re-pick the rows so the PLAN and OPS boxes, the "left" counts and the rows agree.
3. **One control per row.** Purchase Compute, Safety Audit and WYC have no add control, while doors have ">". Add a "+" (add) button in the same column on every direct action, and keep ">" for doors.
4. **Dial overlap.** The P(Doom) box sits over the CRT bezel (y ~120-135) in all views. Seat it inside the top frame, or pull the CRT down so they do not overlap.
5. **Event that can fire.** watch, "The Keynote Slot" at reputation 32 (it needs >= 40). Use an eligible event.
6. **Draw Procurement.** Upgrades are reachable only by a tab that is not drawn. Add `?view=procurement` (upgrade list with prices and "need $X more"), so the upgrade flow is shown like A's and F's.
7. **Door from the row.** m5 Scouting panel is fixed at the right. Visually tie it to the clicked row (a tab or connector from the "OPEN" row edge), in line with Pip's note that menus open out from the button.

## Non-blocking notes
1. Five of six concepts use a placeholder operator. Whichever wins needs one real silhouette asset; this is the core image in Pip's brief.
2. A and C are close. A's CRT-on-desk carries more of the "office with computers" feel, and C's form and ledger close are the best paperwork. Alex may want C's ledger-slip month close and badge counts inside A. That is a merge decision for Alex, not a fix.
3. Some m5 states use events or queues that the game could not produce at that state (A, C and E all do this to a degree). Before Alex sees the shortlist, each should be checked once more against the data.

## Disk report
- Wrote `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r1-opus.md` (this file).
- Scratch: `C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/18510e2e-a3f1-4406-bc1c-8247e8dffee0/scratchpad/` (106 quadrant crops in `crops/`, plus `E_dial.png` and `A_gantt.png`), about 31 MB. All of it can be deleted.
- Nothing else was written. research/concepts/ and the pdoom1 checkout were only read.

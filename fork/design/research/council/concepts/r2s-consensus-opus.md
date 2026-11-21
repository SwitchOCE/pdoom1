# Round 2 (simplify) consensus -- opus

## 0. Attention bars: one convention

**A filled box is an hour already planned; an empty box is an hour still free. Keep the "N free" / "N left" text beside each bar.**

Why this way round:
- It matches today's game. Its ATTENTION row draws hollow pips at "0/20 allocated" (`G/before-m5.png`, top left).
- It needs the fewest edits. C, E's Plan menu and G already draw it this way. Only A (home and plan CRT) and E's home card flip.

If sol and neon prefer filled = free, I accept that too. The blocking part is one convention across all four concepts and every view.

## 1. The other members' fixes

Three rules apply to every concept, so I merge them once here:
- **Focus keys:** only the topmost open layer shows Enter and Esc. Commit's Enter hides while a detail or folder has Enter.
- **Repeat rows** (x8, x6): the remove control takes one play off the group. A group must never be the only thing a player can remove.
- **Text floor:** operational text is at least 16px.

**A**
- sol A1, shrink the home terminal: **agree, lighter fix.** Drop the reserve row and the cost total from the home terminal; keep Attention and the first three plays.
- sol A2, Hire Staff keeps an Open control at 0 planning hours: **agree.** In actions.png the stamp replaces "open >", so the door can no longer be inspected.
- sol A2, research shortfall as a second blocker: **non-blocking.** The card already says why it is blocked.
- neon A2 / sol A2, free hours in the Actions header: **agree.** The CRT is covered while the hand is open.
- neon A1 / sol A3, restore reserve "-" / "+" in Plan: **agree.** plan.png prints "RESERVE 0 hr" with no control, and the reserve is a must-hold.
- sol A3, Esc and Enter in the door view: **agree** (focus-key rule).
- neon A3, calendar sliver behind the Plan CRT: **agree.**

**C**
- sol C3 / neon C1, WATCH clipboard still shows "5 of 8 free": **agree.** Show "12 spent / 3 spent" and "Held for events: 5 hr" once.
- sol C3 / neon C2, 15px labels: **agree** (text-floor rule).
- neon C3, "Hire Staff" source label missing on row 2: **agree** (trivial).
- neon C4 / sol C2, double Esc and the clipboard peeking under the form: **agree.** These merge with my C1.
- sol C1, trim the home accounts slip and the counts on shortcut faces: **non-blocking.** The designer gave a reason to keep it, and C is about 80% art.
- sol C2, mark the open folder's source card: **agree (small).** Onboard step cost: **non-blocking.**

**E**
- neon E1 = my E1: **agree**, using the convention in section 0.
- neon E2, show cash in WATCH: **agree.** The memo asks for $25,000, and no balance is visible.
- neon E3, WATCH outcomes reachable: **agree.** Add a Feed station or list the 01 Nov results on the Day 9 card.
- neon E4 / sol E1, double Esc: **agree** (focus-key rule).
- neon E4, held hours and total on home: **non-blocking.** Plan has both.
- sol E1, Add control on the playable Go to Meetups slip: **agree.** door.png shows only a "1 queued" badge.
- sol E1, research blockers: **non-blocking.**
- sol E2, repeat rows: **agree** (repeat-row rule). "committed" should read "queued cost" in PLAN: **agree.**

**G**
- neon G1 / sol G3, keys: **agree.** This is my G2 and G3.
- neon G2, pips: section 0. G already matches, so no change.
- neon G3 / sol G4, 14-15px: **agree.**
- neon G4 / sol G2, empty icon frames: **agree** (my G1).
- sol G2, handshake-and-globe icon on Travel & Conferences: **agree.** It is an icon-to-action mismatch; drop it.
- neon G5 / sol G1, the This Month total omits "+ 6 rep": **agree.** It contradicts the table total.
- neon G6, remove the PLAN | WATCH switch: **disagree.** It is today's control (`before-m5.png`, "WATCH >"); changing it is not this round's job.
- neon G7 = my G4: **agree.**
- neon G8 / sol G4, "~Jan 2018" crosses the FEB rule: **agree.**
- sol G4, repeat rows: **agree** (repeat-row rule).
- sol G1, trim home: **agree, lighter fix.** Drop the Under Way block from home (Plan has it); keep today's resource bar. A sparkline that reads the game's real history: **non-blocking** (fixture).
- sol G5, "20 hr" repeated in the feed: **non-blocking.**

## 2. Joint ranking
Borda count over the three rankings (4-3-2-1): **E 10, A 9, C 7, G 4.** Joint ranking: **1 E, 2 A, 3 C, 4 G.**

## 3. Joint blocking fix lists

**All concepts:**
- Follow the Attention convention in section 0.
- Only the topmost layer advertises Enter and Esc; Commit hides its Enter while another target owns it.
- Operational text is at least 16px.

**A. The Desk**
1. Attention boxes in home and plan: flip to filled = planned.
2. Rack: one "open" style, used only on the menu that is open. On home it is not lit, or it uses a different "suggested" style (home, plan).
3. Home terminal: drop the reserve row and the cost total; keep Attention and three plays.
4. Actions header: add free hours ("0 / 12 plan, 5 / 8 op"). Hire Staff keeps "open >" next to its stamp.
5. Plan CRT: restore reserve "-" / "+".
6. plan.png: hide the calendar sliver behind the CRT.

**C. The Paperwork Desk**
1. Menus must not cut across the desk objects (plan, actions, door). End the menu above the desk line, or cover and dim the whole desk band.
2. Key caps sit in one corner (bottom-right) on every desk object on home.
3. WATCH clipboard: "12 spent / 3 spent" and "Held for events: 5 hr" once.
4. 16px for the Planning / Operating labels, the balance labels, the form's row numbers and its Order / Hours / Cost heads.
5. Form row 2: add the "Hire Staff" source label.
6. Door: one Esc, and the open folder marked on its source card.

**E. Rooms and Stations**
1. Home This Month bars: filled = planned (PLAN full, OPS 3/8).
2. Door: Go to Meetups gets an Add control like the rack's "+"; one Esc.
3. Plan: on repeat rows the remove control takes one play off the group; "committed" becomes "queued cost".
4. WATCH: show cash ("in hand $79,700") with the memo, and make the 01 Nov outcomes reachable (Feed station or Day 9 card).

**G. Existing UI, modernised**
1. Actions: no empty icon frames (drop the icon column, or icons only where every row fits); drop the Travel handshake icon.
2. Keys: one Enter and one Esc target at a time; WATCH event choices use 1 / 2 / 3.
3. Home and Plan This Month totals: "$110,300 + 6 rep".
4. Home: drop the Under Way block (it stays in Plan).
5. Plan: on repeat rows the remove control takes one play off the group; keep "~Jan 2018" inside the JAN column.
6. home-m1 doom card: centre the gauge, or narrow the card.
7. 16px for queue hours and costs, the x6 badges, Under Way dates, "Can't afford" and the upgrade descriptions.

## Non-blocking (agreed or proposed)
- Second blockers for the research shortfall; a real sparkline history; E's Records and Lab Floor stations; the operator art pass.

## Disk report
I wrote only `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r2s-consensus-opus.md`. The scratchpad (about 39 MB, `C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/18510e2e-a3f1-4406-bc1c-8247e8dffee0/scratchpad/`) can be deleted.

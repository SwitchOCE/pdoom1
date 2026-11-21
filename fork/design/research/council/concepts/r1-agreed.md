# Round 1: agreed result (all three members accepted every item)

Sources: r1-joint-draft.md as corrected by r1-votes-opus.md, r1-votes-sol.md,
r1-votes-neon.md. Every open item was settled by majority, accepted by all.

- **Ranking:** 1 A, 2 C, 3 E, 4 F, 5 B, 6 D.
- **Shortlist:** A. The Desk, C. The Paperwork Desk, E. Rooms and Stations.

## Shared game facts (checked by all three in godot/)

- Work Your Connections: 2 OPERATING hours + 6 reputation (hiring_pipeline.gd:142-147, month_plan.gd:252). Playable at 0 planning hours.
- Onboard New Hires: OPERATING hours + money, varying by onboarding step (hiring_pipeline.gd:488-563). Its blocker is a real reason (nobody hired / no hires awaiting onboarding), never "no planning hours".
- Hire Staff: 7 roles, each 1 PLANNING hour (data/actions/hiring.json).
- Strategic in month 5: Corporate Espionage ($100,000, 3 op hr, 20 rep) is affordable at $140,000 / 5 op hr / 32 rep. Affordability is checked against current resources.
- WATCH events: Stray Cat fires only on workday 7 (July). Keynote Slot needs reputation >= 40. Talent Opportunity is eligible in November (min_turn 5).
- Event prices: for these legacy windows each handled option costs the window's default 1 hour, taken from the held reserve first; the ignore option is free (window_resolver.gd:22, 165-175, 275-300). If a different event is chosen, use its configured window cost and its actual free exit.
- Held hours for events are UNTYPED (month_plan.gd:226-244, 339-350). Show "Held for events: N hr" once, with no OPS/PLAN tag.
- WATCH counters: the game executes the committed batch and publishes the state before playback (game_manager.gd:710-735); Go to Meetups also gives reputation (actions.gd:527-531). Do not hard-code counter figures by subtracting a few rows: build one coherent fixture so counters, queue outcomes and feed agree.
- Pay the Bill and lease rows (Sign: ...) need a live bill or quote with a real amount; show that amount or use a different valid action.

## A. The Desk -- blocking fixes

1. Card costs: Work Your Connections "2 op hr . 6 rep", available in m5. Onboard New Hires "op hr + money, varies by step" with its true blocker, in m1 and m5.
2. m5 CRT queue: one editable row per play (up/down, remove), plus Undo and Clear. Pay the Bill with its payable amount or a valid substitute. Totals and every folder badge derived from the rows, counting plays in one unit (Financing reads "2 in plan" for 1 row; Scouting 3 vs 7 in door.png).
3. m1 calendar: render the sixth row (30, 31); the HTML stops at 35 cells. Keep card positions stable between m1 and m5 (Publish Safety Paper jumps rows).
4. 16px floor: blocked stamps (.slip-st), category tabs (.slip-tab), "in plan" badges (.clip), pins (.pin-o/.pin-done), key hints. Event option costs are already 16px: keep that and fit the full corrected prices.
5. m5 gantt: date labels clear of the JAN/FEB rules (own lane or column).
6. door view: lighten the dimmer so the plan and instruments stay legible with a folder open; detail card sized to its content; Enter on one active target only.
7. place2: Ledger tile shows a real destination/status instead of "next divider" (do not promise "clean" unless the fixture supports it); remove the duplicate UPGRADES button.
8. watch: an event eligible in the pictured month (Talent Opportunity in November, or the cat in an eligible July state); +1 held hr on each handled option, ignore option free; counters from one coherent fixture (see shared facts); remove the hard-edged rectangle (.desk-glow) behind the operator.

## C. The Paperwork Desk -- blocking fixes

1. Work Your Connections "2 op hr, 6 rep", no stamp. Onboard "op hr + money, varies by step" with its true blocker, in m1 and m5. Rebuild the m5 form with valid, priced rows so planning is 0 of 12 free, operating hours stay positive, and totals and badges reconcile.
2. Strategic: remove NONE AFFORDABLE; show its option states truthfully.
3. P(Doom): add RISING beside 40.2% in m5, and drop the permanent "lose at 100%" text.
4. Form: separate NO. and ORDER; >= 12px between under-way date labels and the NOV rule; "on form N" in one fixed corner on every card and slip; raise contrast of titles on unavailable cards; enlarge reorder buttons from 22px to >= 26px.
5. 16px floor: stamps (.stamp), badges (.cf-onf), key caps (.key), hour-pool labels (.fm-hl), row numbers (.fm-no), folder tabs (.cf-card.folder::before). Memo option costs are already 16px: keep that and fit the full corrected prices.
6. watch memo: move the paperclip off the NEEDS ANSWER stamp; +1 held hr on both paid hiring replies (Standard Hiring is missing it); no "Space resume" hint while the memo awaits a reply; fold away the duplicate top-bar office thumbnail in full-office views (watch, place2).

## E. Rooms and Stations -- blocking fixes

1. m5 queue: Work Your Connections "2h OPS" and available. Rebuild the queue with valid, priced rows so rows, PLAN/OPS boxes and "left" counts agree (today the rows sum to 11 planning hours against 12 shown used; retyping Connections alone gives 9 planning and 5 operating). Footer includes "+ rep".
2. Top frame: RISING on P(Doom) in m5; 100 label on the reputation gauge; stop the P(Doom) box overlapping the CRT bezel (or make it read clearly as mounted hardware).
3. Rack: one aligned add control ("+") on every direct action where doors have ">"; Hire Staff "7 roles . 1 plan hr each" with its no-planning-hours state on the role choices (the door stays inspectable); Onboard "op hr + money, varies by step"; OPEN tab inside the rack frame and visibly linked to the folder it opened; breathing room below Strategic.
4. watch: an eligible event (not Keynote Slot at rep 32) with real window prices ("+1 held hr" per handled option, ignore free); counters and feed from one coherent fixture; held Attention shown once and untyped ("Held for events: 5 hr", no OPS tag).
5. Lab Floor (place2): name tag directly above its sprite.

## Non-blocking (agreed)

- Operator silhouette in A's PLAN; replacing placeholder silhouettes in A, C (and others): one shared, lit operator-and-chair asset is a later art pass.
- E: replacing the locked actions rack in WATCH (de-emphasise it if cheap); drawing Procurement and Records as rendered views (Lab Floor meets the brief).
- Any A + C hybrid (C's ledger close inside A) is Alex's choice, not a fix.

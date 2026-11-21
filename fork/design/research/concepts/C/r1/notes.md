# C. The Paperwork Desk

**Concept.** PLAN is the founder's desk seen from the chair: the month is a printed requisition form you fill in, actions are index cards and manila folders in a card file, and Commit is a rubber stamp that never moves. Look up and you are in WATCH: the office through the glass, memos on the desk, the form ticked off line by line, then a printed ledger slip closes the month.

**Places and flow.** `m1`/`m5` the desk (card file left, Form A-20 centre, in-tray, shelf and stamp right). `door` a folder opened out from its card (ABBBCCC) with Pip's one-line flavour text. `watch` the look-up: operator silhouette, memo with tick-box choices, teleprinter feed; the stamp spot becomes Paused/Resume. `place2` the October ledger slip; the stamp spot becomes "File the ledger", and Esc lets you look back first (Pip's note).

**Borrows from.** Papers, Please (desk, stamp, ledger, one shape per document type), SHENZHEN I/O (memo with one ask), Frostpunk (P(Doom) as the big instrument), Not For Broadcast (boxed hardware readouts), Orwell (highlighted facts).

**Does well.** Shape codes kind: white card = action, manila folder = door. Every card shows name, cost and a stamped reason if blocked. Planning and operating hours are two printed box rows, the reserve a third; the form's totals add up (12 plan + 3 op). Commit sits in one spot on every screen. No drag needed: click to add, arrows to reorder.

**Weakest point.** Seventeen cards plus a 14-line form is dense; later phases need a second drawer. The silhouette is placeholder art.

**Visual pass checked:** sibling alignment, 14px floor (controls 16px+), no overlap or clipping, no near-black grounds, prefixed class names. Action icons omitted (none fit reliably). Since round 1 the on-form badge is a corner tag, clear of every name.

## Fix round 1

1. Work Your Connections now "2 op hr, 6 rep", available, no stamp. Onboard New Hires "op hr + money, varies by step": "Nobody hired" in m1, available in m5. The m5 form is rebuilt from valid, priced, deterministic rows (no bills or leases, and no action whose random draw changes a counter; Desperation Lever draws a number for its hidden ledger bill, actions.gd:572, which no counter shows): 14 rows, 12 plan + 3 op hr, $60,300 + 6 rep; planning 0 of 12 free, operating 5 of 8. Every "on form" badge is counted from the rows (Scouting 11 = Meetups 1 + Read 6 + Post 4; Hire Staff, Financing, Connections 1 each).
2. Strategic: no stamp; "4 choices, 1 open now" (Corporate Espionage is affordable; Acquire needs money, Pivot needs planning hours, Grant Proposal needs a paper).
3. P(Doom): "RISING" beside 40.2% after month 1; "lose at 100%" removed.
4. Form: NO. and ORDER in separate columns; reorder buttons 26px; under-way dates right-aligned 14px clear of the first month rule; "on form N" is a tag clipped to the top-right corner of every card and folder-choice card; titles on unavailable cards at full contrast.
5. 16px: stamps, badges, key caps, hour-pool labels, row numbers, folder tabs.
6. Memo: paperclip moved off the stamp; both hiring replies "$25,000 + 1 held hr", Decline "free"; Paused face says "awaiting your reply" (no resume hint); the wall window has its blinds down in watch and place2. Held hours shown once, untyped ("Held for events: 5 hr").
Watch counters come from one fixture: the batch runs before playback, so money $79,700, research -12 + 18 = 6, reputation 32 + 1.5 - 6 - 4 = 23.5, all 14 rows ticked on 1 Nov, and the teleprinter lists the same results.
Visual pass redone on all five renders.

## Fix round 2

1. WATCH reputation gauge shows 24 (whole number, as game_config.gd rounds it); the fixture keeps 23.5 and the needle uses it. No other counter prints reputation with a decimal. The teleprinter line "Go to Meetups -- +1.5 reputation" is kept on purpose: it mirrors the game's own result message (actions.gd, "+%0.1f reputation").
2. Corrected the round-1 note: Desperation Lever does draw a random number (actions.gd:572), for its hidden ledger bill.

VERDICT: CHANGES NEEDED

## Scores (showcase-ready, /10; not a ranking)
A 8.5/10 . C 8.5/10 . E 9/10 . G 8/10

## Blocking items

### A
1. [state 4, 1920x1080 and 1280x720] Event choices omit their effects -- in A/s4.png and A/s4-720.png (A/concept.html:743), the Talent Opportunity slip prints only option names and costs ("Fast-Track Hiring / $25,000 + 1 held hr", "Standard Hiring / $25,000", "Decline Offer / free"), leaving out the +1 safety researcher effect from godot/data/events/core_events.json (talent_recruitment) and run-state.md State 4; a player cannot tell what paying $25,000 buys or compare options 1 and 2 against Decline -- add each option's data effect ("+1 safety researcher" on options 1 and 2, and "no change" on option 3) inside its row, matching C, E and G.

### C
1. [states 2, 3 and 5, 1920x1080 and 1280x720] Dimmed P(Doom) counter fails contrast -- in C/concept.html:52,156, .wall sits at z-index: 2 underneath .dim (z-index: 5, rgba(28,18,22,.55)), dimming the wall instruments whenever a menu or the Month Review is open; measured directly from C/s5.png, "56.7%" drops to 1.70:1 contrast and "BAND SEVERE" to 2.74:1 (and "40.2%" in C/s2.png and C/s3.png drops to 2.39:1), making the new SEVERE reading barely legible right when the review announces "Doom HIGH -> SEVERE" -- raise .wall (or at least the P(Doom) counter and top wall strip) above .dim, or start .dim below the wall band, matching A, E and G.

### E
None. All six states at 1920x1080 and 1280x720 are clean, aligned, accurate to godot/data/ and run-state.md REVISION 2, follow ADR-0001/0011/0015 and the council rules, and keep the office empty and eerie.

### G
1. [state 3, 1920x1080 and 1280x720] Reserve hours is wrongly gated on operating hours and disabled -- G/s3.png and G/s3-720.png print "Reserve (needs operating hours) none" in the Attention card (G/concept.html:493) and disable "Reserve hours [R]" (G/concept.html:607), copying the stale UI pre-check in godot/scripts/ui/main_ui.gd:1277-1280 instead of ADR-0011 amendment 2026-07-28 (f) ("The crisp reserve is deliberately UNTYPED. Gating set_reserve on the operating pool was built, then reverted"), godot/scripts/core/month_plan.gd:235-244 (which allows reserving from remaining planning hours), run-state.md, and r2s-agreed.md rule 1 ("An explicit reserve and the hours held after Commit are separate and untyped"); with 7 planning hours left, Reserve must be available -- enable "Reserve hours [R]" and change the Attention line from "Reserve (needs operating hours)" to untyped "Reserve" (matching A, C and E).
2. [states 3, 4 and 5, 1920x1080 and 1280x720] Violet/purple is used for held-hours UI before art band 3 -- G/concept.html:21 defines --held:#B39AC0 (lavender-violet) and paints 7 bright violet pips and violet text for Held hours in state 4 (G/s4.png, band 1, 40.2% HIGH) plus violet held-hour values in states 3 and 5 (G/s3.png, G/s5.png); G/notes.md:123 literally calls it "Held 7 of 7 (untyped, violet)", contradicting G/notes.md:173 ("Purple appears only here [state 6]."), run-state.md:195 ("Purple only from band 3."), and docs/art/PALETTE_AND_DOOM_INTENSITY.md:141,156 ("Purple is reserved for band 3+") -- change --held to a non-purple neutral/warm token (e.g. off-white #E8E2D4 or pale stone #C8D0D4) so purple appears only in band 3+.

### Showcase page (index.html)
None blocking for this round (all 24 WebPs load at 1920x1080, total size is 3.3 MB under the 16 MB cap, all three views and lightbox keys work, and state copy matches run-state.md REVISION 2). Note before publishing: index.html:158 links to report.md, which does not exist yet (expected until step 6 of brief.md writes it); also confirm that notes.md, run-state.md and report.md are published alongside index.html (or remove raw .md links if the published bundle serves HTML + images only).

## Non-blocking (at most 3 per concept)

### A
1. [state 4] While the Talent Opportunity event awaits a reply, the shortcut rack still displays bright keycaps [F] [E] [L] [F1] (and the terminal shows [F]); hiding background keycaps during an unanswered event (as C, E and G do) would make modal focus clearer.
2. [state 1] The Advisor card has no dismiss control (x or Esc), unlike C, E and G; adding one lets a player clear it without opening Actions first.
3. [state 5] The review sheet keeps the game's boilerplate closing line ("Queue this month's actions, then press COMMIT THE MONTH to play the month out.") right above "Begin planning December 2017 [Enter]"; trimming it (as C, E and G do) would tighten the sheet.

### C
1. [state 1] The Advisor note keeps the game's verbatim "(the glowing button)" pointing at ACTION CARDS without stating "Action Cards > Scouting" (already logged as Open Question 6 in C/notes.md).
2. [state 2] Safety Audit and Strategic omit a NEW badge (C/notes.md notes the workday-based turn_min gate ambiguity; A, E and G show NEW per run-state.md).
3. [states 4 and 5] Work Your Connections prints "done" rather than the game's actual message ("Reached out through your network -- a pre-vetted lead may surface shortly.", hiring_pipeline.gd:157), which A and E use (explicitly allowed by run-state.md REVISION 2).

### E
1. [state 2] "Enter" appears twice on screen for Safety Audit (the yellow "Enter" tab on the focused row and "[Enter] Add to plan" in the bottom detail bar); keeping Enter in one spot removes the duplication.
2. [state 3] COMMIT THE MONTH keeps its [Enter] keycap active while the Plan CRT is open (permitted under r2s-agreed.md rule 2 since Plan owns no Enter action, though hiding Commit's Enter while editing the queue -- as A, C and G do -- prevents accidental commits), and the inert edge arrows (^ on row 01, v on row 11) are not visually dimmed.
3. [state 6] The mezzanine window-sky overlay (.dl-sky) shows a slight horizontal cut-off along the upper transom; feathering the top mask a few pixels will soften the edge.

### G
1. [states 1-5] The left rail uses --aub:#2A1630 with a mid-purple border --aub-edge:#7a4f84 (G/concept.html:19), which reads slightly purple in Cosy/Uneasy bands; shifting the resting rail border closer to neutral slate or near-black #170A1C would further preserve purple for band 3+.
2. [state 3] Read the Literature x2 is shown collapsed ("2-3" with "+") in the still PNG; while r2s-agreed.md rule 4 allows a click-to-expand group (and ?state=3&expand=read works in G/concept.html), capturing the expanded state in s3 would visually prove per-play edit targets to Pip in the static showcase.
3. [state 5] The short FEED window shows 3 of the 11 Commit results ("+ 8 more lines from November"), leaving Hire: Safety Researcher, Tour Offices and Order Office Supplies scrolled out of the static capture (faithful to today's UI, though swapping one visible line to the hire would make the still more self-contained).

## People seen (for Alex's open question)

- Office backgrounds: ZERO people or operator silhouettes across all four concepts and all six states (A/C use office_wide_dawn.webp, E uses office_mezzanine.webp, G uses office_wide_day.webp). Every office reads as empty and eerie.
- Event art (state 4): ZERO human figures across all four concepts. A uses a text-only slip; C draws a portrait-free CV sketch; E crops Pip's event_opportunity_v2.webp to the monitors, desk and lamp (E/assets/event_talent_desk.webp, verified figure-free); G crops Pip's event_secret_v3 to an open filing drawer, lamp and empty chair (G/assets/event_records_drawer.webp, verified figure-free).
- Pip's small control icons kept per brief (the open question for Alex):
  - `ui_staff_management` (three silhouettes at a table): A states 1-6 (STAFF rack plate); C states 1-6 (STAFF FILE desk card); E states 1, 4, 6 (LAB FLOOR station); G states 1-6 (Staff rail button).
  - `button_hire_normal` (head and shoulders with +): A state 2 (Hire Staff folder); C state 2 (Hire Staff folder); E state 2 (Hire Staff card); G state 2 (Hire Staff row).
  - Note: Hire: Safety Researcher and WATCH staff/hiring rows use Pip's shield icon (`employee_role_safety_specialist`), not a human figure, in C, E and G (A uses text-only CRT/teleprinter rows). Go to Meetups uses figure-free new icons (name badge in C/E, two glasses in G) instead of Pip's three-figure `action_management_team_building`.
- Hands-only icons (handshake, no faces/bodies; noted for completeness): `action_publicity_network` (Work Your Connections: A state 2; C states 2, 3; E states 2, 3, 5; G states 2, 3) and `network_64` (Networking: C state 3; E states 3, 5; G state 3), plus `ui_guide_actions` (pointing hand on Actions in all four concepts).

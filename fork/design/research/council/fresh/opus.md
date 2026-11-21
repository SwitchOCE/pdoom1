# Fresh council, Claude Opus (verbatim reply to fresh-brief.md)

VERDICT: REWORK

The defects are fixable, but the direction is the problem: a flat dashboard with no place in it, so fixing the defects still leaves the thing Alex and Pip object to.

## 1. Visual defects

**Root cause of centred vs left-aligned cards:** in `plan.html` the hand's door cards use the class `.card.door`, but `.door` is also the right-column door-button rule (`justify-content: space-between; align-items: center`). It leaks into the hand, so every submenu card (Fundraising, Hire Staff, Operations, Office, Publicity, Financing, Scouting, Strategic) is centred while every direct card is left-aligned. That is a CSS name clash, not a design choice -- and a per-element alignment check would have caught it.

- All views, hand: centred icon/text on door cards next to left-aligned direct cards in the same rows.
- All views, hand, Travel & Conferences: door card whose title wraps to two lines, so the centring fails and it reads left-aligned, with " >" dropping onto its own line; "4 choices" stays centred below.
- All views, hand: Operations and Office show the identical icon (`action_facility_expand_office_64`).
- All views, hand: Scouting shows Pip's Networking icon (`network_64`, the one today's game uses for Networking inside Publicity); Work Your Connections shows a different "network" icon -- two networking pictures for two other things.
- All views, hand: Strategic = emergency-shutdown icon, Publish Safety Paper = formal-verification icon, Advertise = staff-management icon -- Pip's mapping, but at 40px next to a name the mismatch is obvious.
- m5, queue: Go to Meetups and Read the Literature both reuse the Scouting icon, so the sub-action loses its own picture.
- m5, under way: "Hiring: candidate interview" uses the Advertise icon (the greyed SOON card's icon); "Paper submission" uses the Travel globe.
- All views, hand: icons are 40px in 124x170 cards; greyed cards drop them to 35% opacity, so half the hand's icons are near-invisible smudges.
- m5, hand: QUEUED badge on Financing and Scouting sits on the centred icon's right edge; on Hire Staff it overlaps the dimmed icon.
- m5, hand: Hire Staff shows both "QUEUED" and "no planning hours left" -- reads as contradictory.
- m5, hand: three teal border styles with three meanings and no legend (dashed teal = queued door, dotted grey = unavailable, solid teal outline = keyboard focus).
- All views, hand: shortcut numbers skip -- Advertise's "SOON" badge takes the key slot, so keys run 1, 2, SOON, 4; cards after 9 (Purchase Compute, Safety Audit) have no badge at all.
- All views, hand: red explanation text wraps at 12px mono ("needs 10 / Research", "nobody hired / yet", "no planning / hours left").
- All views, hand: cards are a fixed 170px tall regardless of content; door cards have a big empty middle.
- first/returning, hand: row 2 leaves ~850px of empty space on the right; row 1 ~190px.
- m5, hand: the info strip is absolutely positioned over the "YOUR HAND · 17 ACTIONS" header row, squeezes against the group labels, ends at 1520px (inside the hand panel, past where cards end); its CSS declares padding and font-size twice (`!important`).
- m5, Upgrades drawer: covers the right half of the queue, including the queue's own right edge and empty "remove" column; its last row "HPC Cluster" is clipped by the hand's top border at y=620.
- m5, Upgrades drawer: a second, wider "Upgrades" panel; the right-column Upgrades button lights up as active but sits ~500px away.
- m5, queue: "remove" floats at x~840 because grid columns are fixed (818px) in a 1476px box -- ~600px of dead space in every row.
- m5, queue: row heights 48 / 44 / 30 / 42; "8 more queued (scroll)" in an `overflow: hidden` box that cannot scroll.
- first/returning, queue: an empty 1476x318 box with a centred placeholder sentence -- the largest element on screen.
- All views, header: "SET ASIDE NOW" and its stepper are right-aligned while the two hour pools are left-aligned; "+1 Reserve" with no -1.
- All views, top strip: empty from x~700 to 1920; Reputation moved to the right column while Money/Compute/Research stay top.
- All views, right column: P(Doom) 48px, Reputation 30px, body 16-17px, labels 14px mono, feedback 13px -- five sizes in one column.
- All views, right column: "20.0%" in wide mono with uneven gaps around the decimal; the doom bar is segmented, the reputation bar is not.
- All views, right column: "Research quality" wraps to two lines against the segmented control.
- first/returning, right column: ~300px of empty space between Research quality and "Send feedback N", which floats alone.
- All views, right column: only Ledger shows its shortcut ("L"); Upgrades, Employees, Guide show none.
- first, right column: the commit caption wraps to "...held for / events".
- first, hand: the "Start here" tag overlaps the bottom edge of the Onboard New Hires card; the amber marker box is offset ~6px from the Scouting card.
- All views: permanent teaching text still there: "You lose at 100%. You can't win; you can only buy time.", "You lose at 0.", "Nothing planned yet. Actions you play...", "Tab: next card · Enter: play", "all 20 hours are held for events" -- breaks the "no permanent teaching text" rule.

## 2. Why it reads as a generic dashboard

- No office, no art: today's PLAN screen sits on Pip's office backdrop (dim CRTs, cables, the warehouse-era office); the mock-up is flat graphite panels. office_wide_*, office_mezzanine, office_lab_aisle, office_scene and the cat appear nowhere.
- No operator: Pip calls the silhouetted operator "the CORE UI image -- never lose it". Absent, and nothing hands over to a WATCH where it could live.
- No terminal pastiche: Pip wants a lightly modernised amber/green CRT look with boxes, rules and scanlines; the mock-up is a modern SaaS teal-on-slate dark theme. Today's game at least has the `## PLAN` amber terminal line.
- Cards in name only: "deal the cards from the hand you've got" became a grid of equal tiles in category bins; nothing reads as dealt, held or fanned, nothing arrives.
- No phase scaling or earned instrumentation: no seam for the garage-to-lair office or a desk that gets better as you pay; every readout is there from month 1.
- Nothing crosses your desk: events and arrivals (slips, inbox, the cat) have no surface; Upgrades became a spreadsheet drawer.

## 3. A better direction: the desk, and the places it looks at

PLAN as the operator's desk, seen from behind the chair, with a few places the operator turns to. Every place is a UI view over existing state; no mechanics change, no action hidden.

1. The desk (PLAN home): background is the current phase's office art, dimmed, the operator silhouette in the lower foreground. On the desk: the terminal (centre) -- an amber CRT frame holding "The month ahead" (ordered queue, hour pips, reserve), the main element; the hand (front edge of the desk) -- every action as a real card (icon, name, cost), door cards fanning out in Pip's ABBBCCC pattern, left-bound; the doom readout -- a gauge in the desk's furniture (wall dial or second monitor), not a stats column; Commit -- a physical-feeling lever or key at the desk's edge, same shortcut, single control.
2. The floor (Employees): the operator turns to the window/glass -- the OfficeFloor fishbowl with roster and morale, the same component WATCH uses.
3. The ledger drawer (Ledger, Upgrades): a desk drawer or clipboard, paper texture, typed rows; upgrades as "purchase orders", no longer squeezed over the queue.
4. The in-tray (pending items, in-flight work): slips for under-way items and anything waiting; in WATCH the same tray receives events, tying both screens to "across your desk".

Hand-over: Commit = the chair swivels; the terminal goes into playback, the camera pulls back to the operator with the floor beyond, the in-tray starts receiving slips. Month review is a printout landing in the tray; you return to the desk when you choose.

Constant on every screen: the top strip (resources, date), the doom readout, the hour pips, and Commit (or its WATCH twin). One click or key moves between places; Esc always returns to the desk.

Phase scaling: swap backdrop and desk dressing by phase, starting with existing art (warehouse-era aisle, mezzanine, wide office); the terminal frame can grow with earned instrumentation later.

## 4. What Pip would object to

- No operator anywhere: "the CORE UI image -- never lose it" (WORKSHOP beats 1-3).
- Modern flat dashboard: "terminal / mainframe pastiche ... The ASCII mockups ARE close to target" (BUILD_BRIEF); "Any black background needs to come off black" (UI_PASS_NOTES) -- the mock-up's #0E1318 graphite is close to black.
- Submenus as cards that replace the hand view, not fan-outs: his ABBBCCC sketch, plus "buttons ... centre-aligned ... rather than being left-bound" -- the mock-up repeats that exact complaint on half its cards.
- All instrumentation from month 1: "Do NOT impose management-board complexity early" and "the desk gets more useful as you PAY for it" (BUILD_BRIEF, WORKSHOP).
- Permanent purpose/explainer text: "I don't think we need ... permanently telling players what's the screen's purpose is" (UI_PASS_NOTES).
- The queue lost the gantt: BUILD_BRIEF wants "gantt-style duration bar + ETA" and reordering; the workshop called the bars "exceptional".
- Office as phase visual and moral mirror: dropping it removes "the office *is* how you feel the phase".

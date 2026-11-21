# E. Rooms and Stations

**Concept.** The lab is a set of places you move between, each with its own art and one job, under a fixed metal frame: calendar, Attention time card, P(Doom) dial, counters and reputation gauge on top; building directory and COMMIT at the bottom. On the Desk you plan: card file of actions left, the CRT with the month ahead centre, the opened door's folder right, the operator's silhouette in the chair facing the screen.

**Places.** F1 Desk (plan, queue, commit), F2 Lab Floor (staff in/out board, Research Quality switch, a floor camera with Pip's office sprites), F3 Procurement (upgrades), F4 Records (ledger, guide). Tabs and COMMIT never move. In WATCH the COMMIT slot becomes pause/speed, the card file locks, the CRT shows the day and feed, and events land on the desk as a memo. Drawn: m1, m5, place2 (Lab Floor), watch. Procurement and Records are not drawn.

**Borrows from.** Papers, Please (desk, memo); Not For Broadcast and Frostpunk (hardware readouts, one big doom dial); XCOM 2 and Game Dev Tycoon (rooms you visit); Hypnospace (fixed frame).

**Does well.** Every action shows name, hours (PLAN amber / OPS blue, word and colour) and cost, plus the reason when blocked; doors are manila folders with a tab. Queue order is editable; work under way is a dated bar.

**Weakest point.** The Desk is mostly paper and CRT; the room feel comes mostly from the Lab Floor.

**Visual pass.** Checked every render: rows and slips left-aligned; no icons (the game's are mismatched); smallest text 15px secondary, 16px on controls; no overlap, clipping or near-black flat grounds. Left as is: about 110px of empty tray under the m1 card file, so cards keep their places when month-5 actions arrive. Invented: staff name, feed lines, the event.

## Fix round 1

1. m5 queue rebuilt from valid, priced rows: Hire: Safety Researcher (1h PLAN, $60,000), Work Your Connections (2h OPS, 6 rep), Go to Meetups (1h OPS, $300), Read the Literature x8 (8h PLAN), Post Online x3 (3h PLAN) = 12 PLAN, 3 OPS, matching the time card (0 / 5 left). Footer: "14 queued . $60,300 + 6 rep committed". Connections is 2h OPS and available in m1 and m5. One hire only (a bedroom office seats two).
2. Frame: "^ RISING" on P(Doom) in m5 and watch; "100" on the reputation gauge; the CRT moved down so the P(Doom) instrument no longer overlaps it.
3. Card file: every direct action has a "+" tab in the same place as the doors' ">"; blocked reasons sit on line 1, cost always on line 2. Hire Staff: "door . 7 roles . 1h PLAN each", with "no planning hours" in m5. Onboard: "OPS hrs + money, varies by step", blocked by "nobody hired" / "no hires to onboard". OPEN tab sits inside the card file; the folder it opened is amber-edged and titled "OPEN: <door>". About 50px of tray below Strategic.
4. watch: Talent Opportunity (eligible from month 5): Fast-Track Hiring and Standard Hiring each "$25,000 + 1 held hr", Decline Offer free. One fixture: the batch ran on 01 Nov, so money $79,700, research 12, reputation 25 (32 - 6 + 1.5 - 3), 2 staff; the feed uses the game's own result lines. Held Attention shown once, untyped: "HELD FOR EVENTS 5h".
5. Lab Floor: name tag directly above the sprite.

Visual pass redone on all four renders. Blocked reasons now use the condensed label face (17px) so no action name is cut off.

## Fix round 2

1. watch time card: the typed rows now read "12 spent" / "3 spent"; the 5 unspent operating boxes are drawn empty and dashed (moved to the held pool). The five hours appear once, untyped: "HELD FOR EVENTS 5h". m1 and m5 still show "left".
2. m5 Scouting folder: "8 queued" on Read the Literature and "3 queued" on Post Online, in the same stamp spot as Go to Meetups' "1 queued".
3. Onboard New Hires: the fixture now carries onboardEligible (employed hires not yet onboarded or mentored, as in hiring_panel_controller.gd:139). m1: nobody hired. m5: 0 eligible (Maya, hired Sep, is done) -> "no hires to onboard". watch: 1 eligible (Jonah, hired 01 Nov) -> available, no blocker.

Visual pass redone on m1, m5 and watch: the "12 spent" label no longer wraps; nothing else changed. place2 is unaffected and was not re-rendered.

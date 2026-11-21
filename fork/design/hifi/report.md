# High-fidelity showcase run: report

Run on the Optiplex, 2026-11-21/22, branch `design/ui-concepts`. Brief:
brief.md. Orchestrated; the orchestrator designed nothing and judged nothing.

## Summary (read this first)

- **Done.** All four concepts still in contention -- A. The Desk, C. The
  Paperwork Desk, E. Rooms and Stations, G. The Existing UI, Modernised --
  are drawn in the same six states of one run, at 1920x1080 and checked at
  1280x720: (1) month 1 first screen, (2) choosing an action, (3) November's
  plan with the Attention spill, (4) WATCH with Talent Opportunity, (5) the
  month review, (6) late game at P(Doom) 81.4%.
- **Showcase for Pip:** fork/design/hifi/index.html -- a grid of all 24
  screens, a one-state-across-four-concepts view, a one-concept view and a
  full-size lightbox (arrow keys). Self-contained: 24 WebPs (3.3 MB total),
  relative paths, Google Fonts only, no local links. Ready for the PC
  session to publish as a claude.ai page.
- **Council (low sensitivity: Claude Opus 5.5, GPT Sol gpt-6.2-sol, Gemini
  Neon 4, all high):** round 1 CHANGES NEEDED from all three; members
  settled one list of 19 small items (council/r1-agreed.md); the one fix
  round applied all of them; the re-check is **GOOD TO GO from all three**
  (Opus and Sol first, then Neon). Final showcase-ready scores: A 9 / 9 / 9,
  C 9 / 9 / 9, E 9 / 9 / 9, G 8.5 / 9 / 8.5 (Opus / Sol / Neon). No ranking;
  all four stay in contention. Sol ran as gpt-6.2-sol throughout (no
  capacity failure).
- **Nothing blocks.** No person or operator silhouette anywhere; the office
  is empty in every state. The only figures are Pip's own small Staff and
  Hire icons (open question 1 below).
- **Real data:** every name, cost, hour pool, event option and result line
  comes from godot/data/ or the game code. Two errors in the shared run
  state were caught during the run and fixed in all four (run-state.md
  REVISIONS 2 and 3): Office Maintenance (a no-op since v0.13.1) replaced
  by a second Go to Meetups, play results taken from actions.gd, and
  Standard Hiring's held hour.
- **Commits:** 70eb2512 (briefs), 21149470 (state 3 checkpoint), 75ab4547
  (six states), 6f30d591 (council round 1 + fix round), 00f591d7 (re-checks,
  lightbox), and the final commit with this report. Full-size PNG renders
  stay uncommitted (about 55 MB in the four folders).

## The states (shared game: run-state.md)

| # | State | Moment | Key numbers |
|---|---|---|---|
| 1 | First screen | Tue 4 Jul 2017, month 1, nothing queued | $245,000, rep 50, P(Doom) 20.0% ELEVATED, 12 + 8 hours |
| 2 | Choosing an action | Wed 1 Nov 2017, 3 plays queued, Safety Audit about to be added | $140,000, research -12 (research plays short 22 / 22 / 32), 9 + 8 hours left |
| 3 | The month's plan | 11 plays; 4 planning + 9 operating hours = 1 operating hour spills into planning (ADR-0011 amendment 2026-07-28) | $102,600 + 6 rep queued; 7 planning left, 0 operating; 7 held for events |
| 4 | WATCH | Tue 14 Nov, workday 10 of 22, Talent Opportunity | $37,400, rep 34, research -6; Fast-Track or Standard $25,000 + 1 held hr, Decline free |
| 5 | End of month | Month Review -- December 2017 | Funds $140,000 -> $12,400, Staff 0 -> 2, Doom HIGH -> SEVERE (band only, 56.7%) |
| 6 | Late game (projected fixture) | Mon 2 Apr 2018 | P(Doom) 81.4% CATASTROPHIC, art band 3; same layout, doom as a layer |

The spill in state 3 follows the ADR and the game core
(month_plan.gd can_spend_hours); today's UI pre-check (main_ui.gd ~1737,
submenu_controller.gd ~143) refuses it. Every concept says so in its notes.

## What each concept looks like across the states

- **A. The Desk** (fork/design/hifi/A/): first-person at Pip's dawn office
  with a desk terminal, a brass P(Doom) dial, a reputation meter, a shortcut
  rack and a big Commit. (1) An advisor card from the cold open points at
  the glowing ACTIONS plate. (2) "The hand": all 17 actions as folders and
  slips with shortfall stamps and a detail card. (3) The amber CRT fills the
  left with one row per play, a hatched spill square and an "After costs"
  strip. (4) Commit's housing becomes the month clock; the event is a paper
  slip with prices and effects; the terminal plays the month back.
  (5) A printed teleprinter review, dated blocks (1 Nov at Commit, 14 Nov).
  (6) The same desk under a red grade, violet monitor glow and a red-purple
  sky; a desk photo of one of Pip's cats carries the doom aura.
- **C. The Paperwork Desk** (fork/design/hifi/C/): a register of forms on
  a desk. (1) An Advisor note with a pen arrow to the glowing card box.
  (2) A card drawer of 17 cards in five rows with "Short N research"
  stamps. (3) Form A-20 "Schedule of the month" on a clipboard, hour boxes
  with a dashed "1 hr spills up" arrow and a printed rule line. (4) The
  Talent Opportunity memo with tick boxes, the teleprinter of results, a
  "Paused, for your answer" stamp. (5) A ledger sheet following the game's
  Month Review. (6) The same desk under the band-3 doom layer.
- **E. Rooms and Stations** (fork/design/hifi/E/): a fixed instrument frame
  (calendar, hanging P(Doom) dial, reputation gauge) over Pip's mezzanine
  office, with stations (Actions, Plan, Lab Floor, Procurement, Records).
  (1) A taped advisor note at the glowing Actions station. (2) The Actions
  card file. (3) The LABTERM CRT with the two pools, a blue spill arrow and
  an "AFTER COSTS" printout. (4) A memo with a figure-free crop of Pip's
  opportunity art. (5) A typed month report. (6) A darker room, red-purple
  sky, violet monitor glow and faint smoke.
- **G. The Existing UI, Modernised** (fork/design/hifi/G/): today's layout
  kept (resource bar, ## PLAN banner, doom ring, queue, bottom bar) with
  menus on a left rail. (1) The game's own first hint pinned to Actions.
  (2) The Actions list with a Safety Audit detail card. (3) "The month
  ahead" drawer, 11 rows, the Attention card with the spill cell and a live
  untyped Reserve. (4) WATCH with a Talent Opportunity card (figure-free
  crop of Pip's records-room art) and the feed. (5) The Month Review panel.
  (6) The same home at CATASTROPHIC with the game's "Very close to game
  over" warning; purple appears only here.

## Council results

Mode: low sensitivity. One review round, one fix round, one re-check.
Answers in fork/design/hifi/council/.

| Member | Round 1 review (A / C / E / G) | After consensus | Re-check (final) |
|---|---|---|---|
| Claude Opus 5.5 | 9 / 8.5 / 8.5 / 8 | 8.5 / 8 / 8 / 7.5 | **9 / 9 / 9 / 8.5, GOOD TO GO** |
| GPT Sol gpt-6.2-sol | 7.5 / 8 / 7.5 / 7.5 | kept | **9 / 9 / 9 / 9, GOOD TO GO** |
| Gemini Neon 4 | 8.5 / 8.5 / 9 / 8 | 8 / 8 / 8.5 / 7.5 | **9 / 9 / 9 / 8.5, GOOD TO GO** |

Scores are "showcase-ready", not a ranking.

What the fix round changed (council/r1-agreed.md): Standard Hiring shows
its held hour in all four; NEW chips on Safety Audit / Strategic removed
(their gates count workdays); A shows option effects and dates its review
blocks; C lifts the P(Doom) counter above the dimmer, drops the Esc on its
advisor and the dotted empty card slots, prints Work Your Connections' real
message; E hides Commit's Enter while the Plan is open, one Enter in the
card file, "AFTER COSTS" printout; G makes Reserve live and untyped, shows
both Read the Literature rows, a neutral (not purple) held-hours colour and
one ordered feed; the showcase page got a fitted lightbox, keyboard access
and corrected captions. Three items were settled 2-1 and all three members
accepted the majority.

Agreed non-blocking: the 16px text floor applies at 1920x1080 (the game
itself scales its canvas uniformly, so 1280x720 is 2/3 size in the game
too); C's Publish Safety Paper icon follows Pip's own mapping; E's purple
dial housing and G's aubergine rail are Pip's call. Re-check notes left
for later: G's feed counter could read "+ 7 other lines"; A keeps letter
keycaps on its rack during an event; E's band-3 sky has a faint straight
edge.

## Open questions for Alex and Pip (carried, not decided)

1. **Do Pip's Staff and Hire icons count as "the person"?** The offices and
   all event art are figure-free. Human silhouettes remain only in Pip's
   `ui_staff_management` (three figures at a table: A's Staff plate, C's
   Staff file, E's Lab Floor station, G's Staff rail, most states) and
   `button_hire_normal` (head and shoulders: Hire Staff in state 2 of all
   four). Handshake icons (hands only) sit on Work Your Connections and
   Networking. E and G use crops of Pip's event pictures with the people cut
   out; A and C use no picture. If yes: draw figure-free Staff and Hire
   icons.
2. **Which concept goes forward** -- Alex's and Pip's call.
3. Should PLAN show an "after costs" preview of money and reputation? All
   four show one in state 3 (a fixture; the game has none).
4. Should the spilled hour be tied to one play (all four mark the last
   operating play) or shown only on the hour bars? The game keeps a total.
5. Reserve: the ADR's untyped hold (drawn in all four) or today's UI, which
   disables Reserve at 0 operating hours (main_ui.gd ~1277)?
6. Doom band to art band: the art doc gives bands but no cut points. Drawn
   as ELEVATED 0-1, HIGH 1, SEVERE / EXTREME 2, CATASTROPHIC 3, TERMINAL 4.
7. Should events carry pictures (Pip's are packed but unused), and may they
   show people?
8. Tutorial pointer in state 1: the game's line says "(the glowing button)";
   A, C, E, G each glow their Actions entry; should it name the route
   (Actions > Scouting)?
9. New shortcut keys proposed by the designers (A, P, E, U, R, Q, F1 ...);
   only L exists today.
10. Money on home (A has none on home; late game may want it).
11. At 81.4% the game's doom stroke colour is about 1.8:1 on dark panels; C
    and G lift text labels for legibility. Acceptable?
12. Should the Month Review list the month's plays (all four do) or leave
    them to a records view?

## New art needed

- **Icons, drawn as stand-ins in Pip's style ("new, needs art"):**
  Advertise a Role (pinned notice), Travel & Conferences (suitcase),
  Publicity (megaphone), Post Online (speech bubble) -- all four; Go to
  Meetups (name badge: C, E; two glasses: G); Order Office Supplies (box /
  carton: C, E, G); A only: In-tray (inbox tray), Feed (teleprinter tape).
  A dedicated Publish Safety Paper icon (Pip's mapping notes it is needed).
- **Doom layers per art band:** window-sky plates, monitor-glow layers,
  ambient grade and band-3+ smoke -- all four fake them in CSS over one
  office painting.
- **Office cat per doom band:** Pip's doom cat variants are placeholders /
  orphaned (cats/README.md; office_cat.gd update_doom_level is a no-op).
- **A figure-free Talent Opportunity picture** if events get pictures.

## Bugs and data gaps found (for the backlog; not fixed)

- Office Maintenance charges $5,000 and does nothing (no case in
  actions.gd); hidden from the action bar since v0.13.1 but still offered in
  the Operations menu (get_operations_options reads all of
  operations.json), and its text says "Improves morale slightly".
- Talent Opportunity's Standard Hiring data lists only $25,000; the game
  also charges the window's 1 Attention (event_dialog.gd).
- Unlock gates count workdays: Safety Audit (turn_min 5) and Strategic
  (turn_min 10) open in month 1, yet the m5 screenshot shows "STRATEGIC
  MOVES UNLOCKED" (in m6 too -- the popup may repeat).
- Scouting choices (Read the Literature, Go to Meetups, Post Online) and
  Tour Offices have no icon_mapping.json entry: the game draws its magenta
  missing-texture checkerboard. Operations, Office, Order Office Supplies
  and Office Maintenance share one interim icon.
- Work Your Connections and Advertise a Role have `costs: {}` in core.json;
  their real costs live in code / Balance (WYC 2 operating hr + 6 rep;
  Advertise $8,000 + 3 hr, shown as coming soon).
- The spill: UI pre-check refuses what the core and ADR-0011 allow.
- Reserve: UI disables it at 0 operating hours; the core and the ADR make it
  untyped.
- Research can go negative (-12) with no warning.
- The HUD's "Turn N" counts workdays, not months.
- Today's PLAN and WATCH print "Doom this turn: Panic +0.5 ..." (ADR-0015).
- Hire Safety Researcher refunds if the candidate pool is empty
  (actions.gd ~340-346); the run assumes it succeeds.
- Doom stroke colour at CATASTROPHIC has low contrast on dark panels.

## Fixtures (values not from a run)

State 6 is a projection (no late-game screenshot exists). P(Doom) is held at
40.2% through WATCH; payroll and the new staff's research during November
are not modelled; the second Meetups message depends on the candidate pool;
the "after costs" preview is new. Each concept's notes.md lists its own.

## Disk report (whole run)

- **In the checkout (fork/design/hifi/, 60 MB):**
  - Committed: briefs, run-state.md, report.md, index.html, council/
    (round1-ask, r1-*, r1-consensus-*, r1-agreed, r1-recheck-*), and per
    concept concept.html, notes.md, assets/ (0.3-0.6 MB), six WebPs (about
    0.8 MB) -- about 6 MB in all.
  - Not committed: the full-size renders s1..s6.png and s1-720..s6-720.png
    in A (14 MB), C (12 MB), E (15 MB), G (14 MB) = about 55 MB. They can
    be deleted once Alex no longer needs them; each concept.html (or C's
    and G's render.sh) rebuilds them.
- **Outside the checkout:** nothing left. Every designer deleted its
  scratch folder and browser profiles (each reported this); the council
  members' scratch (/tmp/opus-r1 and others) is deleted; the orchestrator's
  scratchpad is empty. No ~/.disk-low flag appeared.
- **Earlier research** (fork/design/research/, about 125 MB) is untouched.

## Delegates (threads)

Designers (Claude Opus 5.5, high): A delegate-task:02a86f5e-959b-47e1-a695-cd3c5fb3d92e,
C delegate-task:948c8668-0e8c-41c4-acae-2e7c9ab69e34,
E delegate-task:4d9dfd71-6fa4-4dcf-8ca4-0daf262c3c9e,
G delegate-task:dee22ff0-9633-40a9-b61a-e560d2758d89.
Council: opus delegate-task:a6ebb49e-1bef-4908-8faa-bac63ee44a1d,
sol delegate-task:c890abfe-9d7d-4d19-9803-546e65f3f694,
neon delegate-task:a50972c9-3484-4b42-bf2f-d7c0a673b953.
All idle at the end of the run.

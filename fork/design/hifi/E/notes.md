# E. Rooms and Stations -- high fidelity

The concept is as agreed in Rounds 2 and 3. Pip's mezzanine office fills the
screen and stays empty. A fixed frame never moves: the wall calendar top left,
the hanging P(Doom) dial top centre, the reputation gauge top right, and the
Commit slot bottom right. Everything else is a station opened from the desk:
the Actions card file, the Plan CRT, Lab Floor, Procurement and Records. Each
station owns its own state. `concept.html?state=1` .. `?state=6` draws the
six states of fork/design/hifi/run-state.md on a 1920x1080 stage that scales
to the window. `&check=1` adds a DOM report (see Visual pass).

## States

**1 -- First month, first screen (Tue 4 Jul 2017, month 1).** This is the
home: the empty office, five station buttons on the left, the This Month card
on the right (planning 12 left, operating 8 left, "Nothing queued yet."),
and Commit. The frame reads JUL / TUE 4 . MONTH 1, P(Doom) 20.0% ELEVATED
(no trend yet) and reputation 50. The tutorial's first step is the cold
open's hand-off. The cue glows on the Actions station, because Scouting
lives inside it, and an Advisor note is taped beside it with an arrow:
"You do not know anything yet. Go and find out -- Scouting." and "Scouting
is in Actions, the glowing station." The note has its own x close. No other
hint is on screen.

**2 -- Choosing an action (Wed 1 Nov 2017, month 5).** Three plays are
already queued (Hire: Safety Researcher, Read the Literature x2), and the
player has opened Actions [A]. The card file holds all 17 top-level actions
in two columns.
- The header shows the player's balances: money $140,000, compute 65,
  research -12 (pink, "RESEARCH . BELOW ZERO"), papers 0, and hours left
  9 PLAN and 8 OPS.
- Every direct action shows its hours and cost chips and a + tab. Every door
  is a manila card ("door . N choices") with a > tab.
- Blocked cards say why: Safety Research and Capability Research "x 22
  research short", Publish Safety Paper "x 32 research short", Travel's line
  "x Submit Paper: 27 research short", Onboard "nobody hired yet", and
  Advertise a Role "coming soon" (the game's [SOON]).
- Hire Staff carries a "1 queued" stamp and Scouting "2 queued". Nothing
  is marked NEW: Safety Audit and Strategic gate on workdays, and nothing
  in the game announces them in November (REVISION 3).
- Safety Audit has focus: an amber ring and a detail strip along the
  bottom ("Safety Audit -- Comprehensive safety review", 2h OPS, $40,000,
  "8 operating hours left", "[Enter] Add to plan"). That strip carries the
  only Enter on screen.
- Because the card owns Enter, Commit drops its Enter key. The card file's
  Back carries Esc.

**3 -- The month's plan (Wed 1 Nov 2017).** The player presses P and the
LABTERM CRT comes forward.
- Attention boxes, filled = hours left. Planning shows 7 left, one hatched
  blue box, then 4 spent. Operating shows all 8 spent, with a blue arrow from
  the last operating box up into the hatched planning box and the line "1h of
  operating work is using a planning hour".
- "Held for events at Commit: 7h" (7h unspent + 0h reserve), with the
  reserve - / + controls.
- The queue holds 11 plays in order. The two Read the Literature plays are a
  group (02-03, x2, [-]) opened into one row each. Every play has its own
  ^ v x. Each row shows where the play lives, a PLAN or OPS chip, and its
  cost. Order Office Supplies, the operating hour past 8, carries the same
  hatched swatch.
- Row 10 is a second Go to Meetups (REVISION 2); the two Meetups plays sit
  apart in the queue and each keeps its own ^ v x.
- Footer: "11 plays . queued cost $102,600 + 6 rep".
- A printout beside Commit, "AFTER COSTS", shows money $140,000 - $102,600
  = $37,400 "after costs", reputation 32 - 6 = 26 "after costs", and
  "Research (now)" -12 with "Below zero: research plays are blocked."
  Commit's Enter is hidden while the Plan CRT is open; the CRT owns Esc.

**4 -- WATCH, an event asks for a choice (Tue 14 Nov 2017).** The player
committed on 1 Nov, and every play ran at Commit.
- The home returns under a light scrim. The Commit slot has become playback,
  stopped: "EVENT PAUSED", with the pause button lit.
- The This Month card has become "The month so far": TUE 14 NOV, "workday 10
  of 22" with a 22-cell strip (9 done, today amber), "Held for events 7h",
  "At work: Safety Researcher", and the four latest feed lines from 01 Nov
  (the game's own result messages), plus "+ 7 earlier lines in Records".
- Actions and Plan are dimmed. While the event waits, no station shows a key.
- Across the desk lies a memo dated TUE 14 NOV 2017: Pip's opportunity art
  (cropped to the desk, no figures), "Talent Opportunity", the data's text,
  and "Cash $37,400 . Held for events 7h". The three options are keyed 1 / 2
  / 3:
  - Fast-Track Hiring: $25,000, 1h held, +1 safety researcher.
  - Standard Hiring: $25,000, 1h held, +1 safety researcher.
  - Decline Offer: free.
- Fast-Track has focus and the only Enter on screen. Nothing on screen shows
  per-play progress, because the game does not have it.
- The frame reads P(Doom) 40.2% HIGH (held until the review) and reputation
  34 and research -6 (REVISION 2).

**5 -- End of the month (Fri 1 Dec 2017, month 6).** The Month Review is a
typed report over the dimmed office, headed "MONTH REVIEW -- DECEMBER 2017"
and "December 2017 begins."
- Left column, "Last month's movement" (the game's rows): Funds $140,000 ->
  $12,400 (-$127,600); Staff 0 -> 2 (+2); Doom shown as HIGH -> SEVERE band
  chips, "crossed up", with no number.
- "Attention": 20 fresh hours (12 planning, 8 operating) as two rows of full
  boxes, then "November held 7 hours for events; 1 went to Talent
  Opportunity. The other 6 evaporated -- no banking."
- Right column, "November's plays": one row per play with its icon and the
  game's result message. The answered event closes the list.
- The Commit slot becomes "BEGIN PLANNING / DECEMBER 2017 [Enter]".
- The frame: DEC / FRI 1 . MONTH 6, P(Doom) 56.7% SEVERE, reputation 34.
- The room sits at art band 2: dimmer, desaturated, a red-orange tint.

**6 -- Late game, high P(Doom) (Mon 2 Apr 2018, month 10; projected,
fixture).** The same home as state 1, with every control in the same place:
the stations, This Month (12 and 8 left, nothing queued), and Commit. The
frame reads APR / MON 2 . MONTH 10, P(Doom) 81.4% CATASTROPHIC and
reputation 21. Only the doom layer has changed (art band 3, Eldritch):
- a low-key aubergine ambient grade over the room;
- the window sky swapped to red-purple;
- every lit monitor turned violet with a violet glow, the one glow source;
- faint smoke at floor level.

The dial value and band word turn magenta. Money $12,300, research 4 and the
Safety Research block (6 short) are not on the home screen. As in every
state, they show in the Actions card file.

## Fixtures and places I followed the ADR over today's game

- **Spill rule (ADR-0011 amendment 2026-07-28), state 3:** the 9th hour of
  operating work takes a planning hour. Today's UI pre-checks refuse that
  (main_ui.gd ~1737, submenu_controller.gd ~143), but the core
  (month_plan.gd) already allows it. The mock-up follows the ADR and the
  core.
- **Per-row spill marker** (state 3, on Order Office Supplies): this is the
  operating hour past 8 in queue order. The game counts the spill as a total
  only, so the marker is a presentation choice and can be dropped.
- **What the spill rule forbids:** I did not draw it. If operating hours were
  free and planning hours ran out, the card file would show the planning
  play blocked with "no planning hours".
- **"After costs" printout** (state 3): it shows costs only. Play results
  (reputation gains, research) arrive at Commit and are not forecast,
  because the game does not show them before Commit. Payroll is not
  modelled (run-state fixture).
- **Doom display:** the dial's arc is cut at DOOM_STATUS_BANDS
  (15/37/52/67/80/92) and coloured with DOOM_STOPS and the game's
  get_doom_stroke_color formula (godot/autoload/theme_manager.gd). Above
  74% the value text is lifted to a light magenta so it stays legible on the
  dial's purple ground; that is my change, not the game's. RISING is the
  game's trend indicator. No delta appears anywhere (ADR-0015). The P(Doom)
  level in state 4 is held at the month-start value (run-state fixture).
- **RISING in state 6** is a fixture (projected).
- **Art band per doom band** (my mapping): NOMINAL/ELEVATED -> 0 Cosy,
  HIGH -> 1 Uneasy, SEVERE/EXTREME -> 2 Spooky, CATASTROPHIC -> 3 Eldritch,
  TERMINAL -> 4. The doc gives the art bands but no cut points.
- **State 1 hint wording:** the game's line is "Advisor: you do not know
  anything yet. Go and find out -- scouting (the glowing button)." In E,
  Scouting is a door inside Actions, so the note splits the line in two and
  names the station. Text edit only.
- **State 4 feed:** these are the game's messages for the last four plays,
  all dated 01 Nov. No feed lines are invented for 2-14 Nov. "Tour Offices:
  three landlords will quote you terms." is the data's description, because
  the game's real message lists random lease terms. "Office supplies
  restocked (+50 stationery, now at 100)" (stationery caps at 100).
- **State 4 workday strip:** 22 workdays in November 2017, with day 10 =
  Tue 14 Nov (run-state).
- **State 4 "1h held"** on both hiring options. Fast-Track declares
  `attention: 1`; Standard Hiring declares none, and event_dialog.gd folds
  the window's Attention price into it (REVISION 3). Decline stays free.
- **State 5 Attention line:** the game prints "Attention: 20 fresh decisions
  this month (last month's unspent reserve evaporated -- no banking)." E
  says hours, to match every other screen, and adds the 7 / 1 / 6
  breakdown from run-state. The game's closing line ("Queue this month's
  actions, then press COMMIT THE MONTH ...") is left off: the Begin planning
  button says it.
- **State 5 rivals:** the game prints the rivals block only when a rival is
  visible to the player (rivals.gd is_visible_to_player). With no sight
  bought, nothing in this run says one is visible, so the block is omitted
  rather than drawn as an empty slot. No rival names appear.
- **State 5 plays list:** the game's review does not list plays. It is here
  because run-state asks for results. In E it would normally live in Records
  (the feed archive).
- **State 6:** every number is projected (run-state). The doom layer follows
  the band 3 row of the art doc. The sky, monitor and smoke positions are
  hand-placed on Pip's painting.

## People

- **No human figure** appears in states 1, 3, 4, 5 or 6 beyond the station
  icon below. Hire: Safety Researcher and both hiring options on the memo
  use Pip's mapped `employee_role_safety_specialist` (a shield). Go to
  Meetups uses a drawn name badge in place of Pip's three-figure
  `action_management_team_building`. The event picture is Pip's
  `event_opportunity_v2.webp` cropped to the desk; the full image has two
  figures at the window.
- **Pip's icons kept with figures:** Lab Floor station `ui_staff_management`
  (three silhouettes at a table) in states 1, 4 and 6; Hire Staff card
  `button_hire_normal` (head and shoulders) in state 2.

## Icons

Every icon sits on the same dark tile, at one size per place: 48 stations,
40 cards, 36 titles, header balances and Commit, 28 plan rows and card
titles, 24 sub-rows, printout, memo, review and month card, 22 frame labels.

| Icon file | Sits on |
|---|---|
| `ui_guide_actions_64.png` | Actions station; card file plate |
| `ui_config_date_64.png` | Plan station; Plan CRT title; This Month / The month so far |
| `ui_staff_management_64.png` | Lab Floor station |
| `button_upgrade_normal_64.png` | Procurement station |
| `ui_save_archive_64.png` | Records station |
| `doom.png`, `indicator_doom_rising_64.png` | P(Doom) dial label, RISING |
| `reputation.png` | Reputation gauge; printout row |
| `ui_control_confirm_64.png` | Commit the Month; Begin planning |
| `money.png`, `compute.png`, `research.png`, `paper.png` | Card file balances; printout; memo cash |
| `resource_action_points_64.png` | Hours left; Held for events (plan, month card, memo) |
| `ui_guide_resources_64.png` | Fundraising |
| `button_hire_normal_64.png` | Hire Staff (Pip's mapping) |
| `new_advertise.svg` | Advertise a Role |
| `action_publicity_network_64.png` | Work Your Connections (Pip's mapping) |
| `employee_status_training_64.png` | Onboard New Hires (Pip's mapping) |
| `action_research_robustness_64.png` | Safety Research |
| `action_research_ml_fundamentals_64.png` | Capability Research |
| `paper.png` | Publish Safety Paper; Papers balance |
| `employee_role_auditor_64.png` | Safety Audit (Pip's mapping) |
| `new_travel.svg` | Travel & Conferences |
| `action_facility_upgrade_compute_64.png` | Purchase Compute (Pip's mapping) |
| `ui_system_settings_64.png` | Operations |
| `action_facility_expand_office_64.png` | Office |
| `new_publicity.svg` | Publicity |
| `action_funding_loan_64.png` | Financing |
| `employee_status_investigating_64.png` | Scouting |
| `ui_guide_strategy_64.png` | Strategic |
| `employee_role_safety_specialist_64.png` | Hire: Safety Researcher; Fast-Track / Standard Hiring; "At work" (Pip's mapping) |
| `ui_guide_book_64.png` | Read the Literature |
| `new_post_online.svg` | Post Online |
| `new_meetup_badge.svg` | Go to Meetups |
| `network_64.png` | Networking (Pip's mapping) |
| `ui_home_hq_64.png` | Tour Offices |
| `new_supplies.svg` | Order Office Supplies |
| `ui_control_cancel_64.png` | Decline Offer |

Changed from Round 3 to follow Pip's icon_mapping.json: Safety Audit, Work
Your Connections and Networking (Pip maps the blue handshake to Work Your
Connections and the dark one to Networking), and Hire: Safety Researcher.
Two handshakes therefore sit in one queue (Pip's choice, kept). The
utility buttons (Back, Undo, Clear, reorder, speed, close) carry no icons,
as in Round 3.

**New, needs art** (drawn in the same dark tile, `assets/icons/new_*.svg`):
- From Round 3: Post Online (speech bubble), Advertise a Role (job notice),
  Publicity (megaphone), Travel & Conferences (suitcase).
- New this run: Go to Meetups (name badge on a lanyard), Order Office
  Supplies (box of paper and a pencil). Pip's mapping gives Supplies his
  office floor-plan icon as an interim.
- Art, not icons:
  - a band-3 office cat. Pip's `cats/default/*.svg` are labelled
    placeholders, so state 6 shows no cat;
  - per-band window-sky and monitor-glow layers. State 6 fakes them with
    CSS blends on the one painting;
  - a figure-free event picture for Talent Opportunity.

## Bugs and data gaps met (not fixed)

- **Office Maintenance** charges $5,000 and does nothing (action_bar_renderer
  comment, v0.13.1). It is hidden from the action bar but still offered in
  the Operations door, and its description says "Improves morale slightly".
  The text contradicts the game. Under REVISION 2 it is no longer in the
  queue (row 10 is a second Go to Meetups).
- **Costs missing from the data:** Work Your Connections has `costs: {}` in
  core.json. Its 2 operating hours and 6 reputation come from
  hiring_pipeline.gd (Balance hiring.connections.*). Advertise a Role has
  `costs: {}` too; its $8,000 + 3 operating hours (shown dimmed in state 2)
  come from Balance hiring.advertise.*.
- **Event pictures:** godot/assets/images/events/*.webp are packed but
  unused (their README). The game shows no picture on an event; E's memo
  uses one.
- **Research below zero** (-12, then -6) gets no warning in today's game.
  Shown here.
- **"Turn N" on today's HUD** counts workdays. The calendar shows the month
  and weekday.
- **Pip's cat doom variants** do not exist (office_cat.gd update_doom_level
  is a no-op; the default SVGs are placeholders).
- **Strategic unlock:** turn_min 10 and reputation_min 30. In state 6
  reputation is 21, so Strategic would lock again. It is not visible on the
  home screen.

## Run-state conflicts (the game wins)

- **Play results are deterministic in the code, not "random or not in the
  data".** In actions.gd:
  - Read the Literature +3.0 research each;
  - Post Online +4 hype, -1 reputation;
  - Go to Meetups +1.5 reputation;
  - Networking +3 reputation;
  - Safety Audit +3 reputation.

  Raised by E; the orchestrator adopted it as REVISION 2 in run-state.md,
  which E now follows: reputation 32 - 6 - 1 + 1.5 + 1.5 + 3 + 3 = 34,
  research -12 + 3 + 3 = -6. State 3's printout reads 26, labelled
  "after costs" (costs only).
- Go to Meetups' second sentence depends on the candidate pool. Meetups #1
  shows "Someone unvetted is now in your candidate pool.", #2 "No leads you
  have room for." (fixture, per REVISION 2).

## Open questions for Alex or Pip

1. Keep or drop the per-row spill marker in the Plan CRT?
2. Do Pip's Staff and Hire icons, and figures in event art, count as "the
   person"? If yes: draw figure-free Lab Floor and Hire Staff icons. The
   memo picture is already cropped.
3. Should the Month Review list the month's plays (state 5 does, per
   run-state) or leave them to Records?
4. Is the art-band mapping above right? In particular, does SEVERE count as
   band 2?

## Council round 1 fixes (council/r1-agreed.md)

- All four, item 1 (s4): Standard Hiring shows $25,000 + 1h held +
  "+1 safety researcher", the same as Fast-Track (run-state REVISION 3).
  Decline stays free. The open question about it is closed. State 5 is
  unchanged.
- E1 (s2): no NEW tag on Strategic and no "new this month" on Safety Audit.
  The focused Safety Audit card keeps its amber ring but shows a plain +
  tab, so Enter appears once, in the detail strip ("[Enter] Add to plan").
- E2 (s3): Commit's Enter is hidden while the Plan CRT is open; the CRT
  owns Esc.
- E3 (s3): the printout is titled "AFTER COSTS", and its research row reads
  "Research (now)" -12.
- Re-rendered s2, s3 and s4 at 1920x1080 and 1280x720 plus their WebPs;
  the layout check reports CHECK 0 at both sizes. s1, s5 and s6 are
  untouched.

## Visual pass

All six states, checked at 1920x1080 (s1-s6.png) and 1280x720
(s1-720..s6-720.png). I opened every render. `?check=1` (read with
--dump-dom) reports, at both sizes for all six states:
- no text under 16px;
- no clipped or overflowing text;
- nothing outside the stage;
- no text spilling out of its parent;
- no text glyph band overlapping another text element.

Every state reports 0.

Fixed on the way:
- state 2: the Hours Left box broke because its class collided with the
  CRT's `.hrs` rule;
- state 5: the Talent Opportunity row jumped over the list (class collision
  with the memo's `.ev`), and names wrapped in a too-narrow name column;
- state 4: "+1 safety researcher" ran under the Enter tag (memo widened,
  chip shortened to "1h held");
- state 6: a flat red slab over the windows (now a masked colour blend), and
  an unreadable dial value;
- state 3, earlier: the spill arrow pointed down; the dial's 0 / 100 crowded
  the arc; the printout's last line overflowed.

Checked across states:
- one type scale (16 / 18 / 22 / 28 / 44);
- the frame and Commit slot never move;
- the station dock sits at the same place in 1, 4 and 6;
- icons stay one size per place;
- the numbers agree across states (money 245,000 -> 140,000 -> 37,400 ->
  12,400 -> 12,300; planning and operating hours; held 7 -> 1 used, 6
  evaporated);
- the office stays empty in every state.

WebPs are at quality 90 (89-194 KB each) to keep the CRT and paper text
crisp.

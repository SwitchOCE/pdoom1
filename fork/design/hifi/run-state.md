# Run state: one game carried through all six states

Written 2026-11-21 by the hifi orchestrator. Every designer uses this file so
the four concepts show the same company at the same moments. Values come from
the real game screenshots in fork/design/research/ui-pass/game-shots/ (a
scripted run on v0.14.5) and from godot/data/. Anything not from a screenshot
or the data is marked **fixture** and must be listed as such in your notes.

If you find a value here that disagrees with godot/data/ or the game code,
the game wins: use the game's value, say so in your notes, and tell the
orchestrator in your final reply.

## The company and the rules that hold in every state

- Start: Jul 2017. Starting values (godot/data/balance/defaults.json,
  main.png): money $245,000, compute 100, research 0, papers 0,
  reputation 50, P(Doom) 20.0%. No staff ("Staff Roster: No staff hired").
- **Attention** (ADR-0011, amendment 2026-07-28; planning_share 0.6 in
  defaults.json): 20 hours a month at normal difficulty = **12 planning +
  8 operating**. Operating work may spill into planning hours; planning work
  may never use operating hours. Unspent hours at Commit are held for events
  (untyped) and evaporate at month end (no banking).
  - Today's UI shows one pool ("ATTENTION 0/20 allocated") and its pre-check
    refuses an operating action once operating hours run out. **The mock-ups
    follow the ADR, not today's pre-check. Say so in your notes.**
- Which pool an action bills (godot/scripts/core/month_plan.gd KIND_FAMILY;
  the action's `hour_type` in godot/data/actions/*.json): `approvals` =
  planning; `doors`, `audits` = operating; no hour_type = planning.
- Council rules already agreed (keep them): Attention bars filled = hours
  LEFT; only the topmost open layer shows Enter/Esc; operational text >=
  16px; every repeated play has its own edit target.
- **Doom display** (ADR-0015, ADR-0001): show the P(Doom) level and its band
  label; never a per-month or per-cause doom delta. (Today's game prints
  "Doom this turn: Panic +0.5 ..." in PLAN and WATCH; that breaks ADR-0015
  and is listed as a bug. Do not copy it.)
- Doom status bands (godot/autoload/theme_manager.gd DOOM_STATUS_BANDS):
  NOMINAL < 15, ELEVATED < 37, HIGH < 52, SEVERE < 67, EXTREME < 80,
  CATASTROPHIC < 92, TERMINAL. Art bands (docs/art/
  PALETTE_AND_DOOM_INTENSITY.md): 0 Cosy, 1 Uneasy, 2 Spooky, 3 Eldritch,
  4 Terminal; "Doom is a layer, not a repaint".

## State 1 -- first month, first screen (PLAN, nothing queued)

Source: game-shots/main.png.

- Date: Tue 4 Jul 2017 (month 1). Today's HUD says "Turn 1"; that counts
  workdays, not months (known bug). Show the month, not "Turn".
- Money $245,000 . compute 100 . research 0 . papers 0 . reputation 50.
- P(Doom) 20.0%, band ELEVATED (art band 0-1: cosy, slightly uneasy).
- Attention 12/12 planning, 8/8 operating. Nothing queued. No staff.
- Liability Ledger: clean.
- Safety Research, Capability Research and Publish Safety Paper are
  unaffordable (research 0; they need 10 / 10 / 20 research).
- What a new player needs here is the tutorial's first step; show what your
  concept puts in front of them, using text that already exists in the game
  where you can (cold open / welcome overlay), and no invented rules.

## States 2-5 -- November 2017 (month 5), one month played through

**Read REVISION 2 at the end of this file: it replaces row 10 and the November money, reputation and research figures below.**

Source for the opening numbers: game-shots/m5_plan_queued.png.

### Opening of November (before anything is queued)

- Date: Wed 1 Nov 2017 (month 5).
- Money $140,000 . compute 65 . research **-12** . papers 0 .
  reputation 32.
  - Research below zero is what today's game shows (known bug: research can
    go negative with no warning). Show -12 and the shortfall it causes; do
    not hide it.
- P(Doom) 40.2%, rising; band HIGH (art band 1 Uneasy).
- Staff: none yet (the screenshot's roster says "No staff hired").
- Liability Ledger: clean.
- New this month: Safety Audit and Strategic are unlocked (today's game
  announces Strategic with a "STRATEGIC MOVES UNLOCKED" popup).
- Blocked by research: Safety Research and Capability Research (need 10,
  short 22), Publish Safety Paper (need 20, short 32), Submit Paper in
  Travel (need 15, short 27).

### State 2 -- choosing an action

The plan so far (three plays queued, 3 planning hours used):

| # | Play | Where it lives | Pool | Hours | Other cost |
|---|---|---|---|---|---|
| 1 | Hire: Safety Researcher | Hire Staff | planning | 1 | $60,000 |
| 2 | Read the Literature | Scouting | planning | 1 | -- |
| 3 | Read the Literature | Scouting | planning | 1 | -- |

Attention left: planning 9/12, operating 8/8. The player has the action menu
(or your concept's equivalent) open and is about to add **Safety Audit**
(2 operating hours, $40,000; "Comprehensive safety review"). Show the
research-blocked actions as blocked with their shortfall, and the door
actions (Fundraising, Hire Staff, Travel & Conferences, Operations, Office,
Publicity, Financing, Scouting, Strategic) as doors. All 15 of today's
top-level actions plus Safety Audit and Strategic stay reachable.

### State 3 -- the month's plan, several plays queued

| # | Play | Where it lives | Pool | Hours | Other cost |
|---|---|---|---|---|---|
| 1 | Hire: Safety Researcher | Hire Staff | planning | 1 | $60,000 |
| 2 | Read the Literature | Scouting | planning | 1 | -- |
| 3 | Read the Literature | Scouting | planning | 1 | -- |
| 4 | Post Online | Scouting | planning | 1 | -- |
| 5 | Safety Audit | (top level) | operating | 2 | $40,000 |
| 6 | Work Your Connections | (top level) | operating | 2 | 6 reputation |
| 7 | Go to Meetups | Scouting | operating | 1 | $300 |
| 8 | Networking | Publicity | operating | 1 | -- |
| 9 | Tour Offices | Office | operating | 1 | -- |
| 10 | Office Maintenance | Operations | operating | 1 | $5,000 |
| 11 | Order Office Supplies | Operations | operating | 1 | $2,000 |

- Planning work: 4 hours. Operating work: 9 hours = all 8 operating hours
  **plus 1 hour spilled into planning**. So planning hours left: 12 - 4 - 1
  = **7**; operating hours left: **0**. Show the spill explicitly (one hour
  of operating work drawn from the planning pool).
- **Held for events at Commit: 7 hours** (untyped; it is the unspent
  remainder, plus any explicit reserve -- none here).
- Queued cost: **$107,300 + 6 reputation**. After Commit: money $32,700,
  reputation 26.
- What the spill rule allows: more operating plays could still be queued
  (they would eat planning hours). What it forbids: if operating hours were
  free and planning hours ran out, a planning play could not use them. Show
  that as a blocked planning play only if your concept has room; one line in
  the notes otherwise.
- Work Your Connections has `costs: {}` in core.json; its 2 operating hours
  + 6 reputation come from the game code (agreed by the council in round 1).

### State 4 -- WATCH: an event that asks for a choice

- Commit ran on Wed 1 Nov: every queued play executes at Commit (game
  rule, godot/scripts/game_manager.gd); WATCH then plays the month back day
  by day. The playback clock is at **Tue 14 Nov 2017** (workday 10 of 22).
- "Progress behind the event": the playback position through the month,
  the month feed lines so far, and the staff working (the new Safety
  Researcher is on the payroll from Commit). Do not show plays finishing on
  different days or invent per-play progress bars the game does not have.
- Counters: money $32,700 . reputation 26 . P(Doom) 40.2% (fixture: the
  level is held at the month-start value until the month review; show no
  delta) . held for events 7 hours.
- The event: **Talent Opportunity** (core_events.json, id
  talent_recruitment): "A brilliant researcher wants to join your lab at
  reduced cost!"
  - Fast-Track Hiring -- $25,000 + 1 Attention -> +1 safety researcher
  - Standard Hiring -- $25,000 -> +1 safety researcher (the data gives no
    Attention cost; round-1 council notes said every handled option costs
    1 held hour. Show the data's cost and flag the question in notes.)
  - Decline Offer -- free
- The player picks **Fast-Track Hiring** (state 5 follows from that).

### State 5 -- end of month: what happened, before the next PLAN

What today's game shows here (godot/scripts/game_manager.gd
_finish_month_playback): a "Month Review -- December 2017" with "December
2017 begins.", "Attention: 20 fresh decisions this month (last month's
unspent reserve evaporated -- no banking).", movement rows only for stats
that moved (Funds, Staff, Doom as a band move, never a number), a rivals
review, and the button "Begin planning December 2017".

- Funds $140,000 -> $7,700 (-$132,300) = plays $107,300 + Fast-Track
  $25,000. **Fixture:** payroll for the two new hires during November is not
  modelled here; the real figure may be lower. Do not invent a payroll line.
- Staff 0 -> 2 (Safety Researcher hired; Fast-Track researcher).
- Doom: HIGH -> SEVERE (P(Doom) 56.7% on Fri 1 Dec 2017, from
  game-shots/m6_plan_start.png). A band move only; no number for the move.
- Reputation 26 (the month review does not list reputation; show it where
  your concept shows reputation).
- Results the data states without a roll (use these words or the game's own
  result messages): Safety Researcher hired; "Fast-tracked hiring process!
  (+1 safety researcher)"; Order Office Supplies "+50 supplies"; Tour Offices
  "Three landlords will quote you terms". For plays whose result is random
  or not in the data (Read the Literature, Post Online, Go to Meetups,
  Networking, Work Your Connections, Safety Audit, Office Maintenance) write
  "done" plus the data's description, no numbers.
- Rivals review: no data in the screenshots; leave a labelled slot
  ("Rivals: what moved") without invented rival names or numbers, or use
  rival names from godot/data/ if you show any (list them in notes).
- Hours: 7 were held; 1 went to the event; 6 evaporate.

## State 6 -- late game, high P(Doom) (**fixture**, projected)

No real screenshot exists this late. These values are a projection of the
same run, all **fixture**:

- Date: Mon 2 Apr 2018 (month 10), start of PLAN, nothing queued.
- Money $12,300 . compute 65 . research 4 . papers 0 . reputation 21.
- Staff 2 (both safety researchers).
- P(Doom) 81.4%, band **CATASTROPHIC**; art band 3 Eldritch (red, violet
  creeping, dark dread) per docs/art/PALETTE_AND_DOOM_INTENSITY.md.
  "Doom is a layer, not a repaint": the room keeps its shape and the
  controls keep their places; the doom layer (one ambient grade + one glow
  source, the window sky, the monitor glow, the cat's form) changes.
  Purple only from band 3. Use Pip's per-band art from godot/assets/ where
  it exists (cats, backgrounds); list what is missing as "new, needs art".
- Attention 12/12 planning, 8/8 operating.
- Liability Ledger: clean.
- Research 4: Safety Research still blocked (short 6).

## Corrections found by the designers

- (Designer A) "No hour_type = planning" is the default for queued actions
  (GameActions.hour_type), but actions that charge themselves in code bill
  OPERATING by default: Work Your Connections (hiring_pipeline.gd
  use_connections) is operating. The tables above are right.
- (Designer A) The spill refusal is in today's UI pre-checks only
  (main_ui.gd ~1737, submenu_controller.gd ~143); the core
  (month_plan.gd can_spend_hours / _debit_hours) already allows the spill.

## REVISION 2 (2026-11-22) -- supersedes the November numbers above

Two errors in the first version, found by designer E and the orchestrator:

1. **Office Maintenance does nothing**: the code note says it "charged $5000
   and did nothing; taken OFF the board" (v0.13.1; godot/scripts/ui/
   action_bar_renderer.gd HIDDEN_FROM_ACTION_BAR_IDS). It is hidden from the
   action bar but still listed in the Operations menu (GameActions.
   get_operations_options reads all of operations.json), so Operations still
   shows 3 choices -- a bug for Pip. The showcase should not queue a no-op.
   Row 10 becomes a **second Go to Meetups** (Scouting, operating, 1 hr,
   $300). The two Meetups plays are a repeated play: each keeps its own edit
   target.
2. **Several plays have fixed results** in godot/scripts/core/actions.gd
   (not random), applied at Commit:
   - Read the Literature: "Read for a day (+3.0 research). Nobody noticed."
   - Post Online: "Posted (+4.0 hype, -1.0 reputation). Investors read
     hype; researchers read the replies."
   - Go to Meetups: "Worked the room (+1.5 reputation). Someone unvetted is
     now in your candidate pool." (the other variant: "... No leads you have
     room for."; use the first for the first Meetups play and the second for
     the second -- **fixture**, it depends on the candidate pool)
   - Networking: "Networking (+3 reputation)"
   - Safety Audit: "Safety audit (+scrutiny, +3 reputation)"
   - Order Office Supplies: "Office supplies restocked (+50 stationery, now
     at 100)" (stationery caps at 100)
   - Work Your Connections spends 6 reputation + 2 operating hours for a
     lead (hiring_pipeline.gd use_connections); use the game's message if
     you show one, else "done".

### Corrected November numbers (use these everywhere)

- Queue (11 plays): 1 Hire: Safety Researcher (plan 1, $60,000);
  2-3 Read the Literature x2 (plan 1 each); 4 Post Online (plan 1);
  5 Safety Audit (op 2, $40,000); 6 Work Your Connections (op 2, 6 rep);
  7 Go to Meetups (op 1, $300); 8 Networking (op 1); 9 Tour Offices (op 1);
  10 Go to Meetups (op 1, $300); 11 Order Office Supplies (op 1, $2,000).
- Hours unchanged: 4 planning work, 9 operating work = 8 operating + 1
  spilled into planning; planning left 7, operating left 0; held for events
  at Commit 7.
- **Queued cost: $102,600 + 6 reputation.**
- State 2 is unchanged (its three plays are the same).
- If PLAN shows an after-Commit preview, label it "after costs" and show
  costs only: money $140,000 -> **$37,400**, reputation 32 -> **26**. (The
  game has no such preview today: fixture, and an open question.)
- **State 4 (WATCH, Tue 14 Nov):** money **$37,400** . reputation **34**
  (32 - 6 - 1 + 1.5 + 1.5 + 3 + 3) . research **-6** (-12 + 3 + 3) .
  P(Doom) 40.2% (fixture hold) . held for events 7 hr.
- **State 5 (Month Review):** Funds $140,000 -> **$12,400 (-$127,600)** =
  plays $102,600 + Fast-Track $25,000. Staff 0 -> 2. Doom HIGH -> SEVERE
  (56.7% on Fri 1 Dec 2017). Reputation 34. Research -6 (fixture: research
  the new staff produce during playback is not modelled; payroll likewise).
- Rivals: the game prints its rivals section only when a rival is visible;
  you may leave it out (say so in notes).
- Doom band to art band (designers' reading, an open question for Pip):
  ELEVATED 0-1, HIGH 1, SEVERE and EXTREME 2, CATASTROPHIC 3, TERMINAL 4.

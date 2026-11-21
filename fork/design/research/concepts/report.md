# PLAN-screen concepts round: report

Date: 2026-11-21. Orchestrated from a child session; the orchestrator designed
and reviewed nothing itself. Council: low sensitivity (Claude Opus 5.5,
GPT Sol 6.2, Gemini Neon 4), all at high effort, new delegates for this round.
GPT Sol ran as gpt-6.2-sol throughout (no capacity failure in this round, so
6.1 Sol was not needed). All reviews were static (renders + concept.html +
game source); nobody ran Godot.

## Result

- **Shortlist (agreed by all three): A. The Desk, C. The Paperwork Desk,
  E. Rooms and Stations.** Ranking A, C, E, F, B, D.
- After two fix rounds all three members say all three are **ready to show
  Alex** (round 3: GOOD TO GO from Opus, Sol and Neon).
- **Alex's gallery bar is met:** all three members put **A, C and E** in the
  gallery as belonging, at least average. A is "one of the better ones" for
  all three members; C is "better" for Sol and Neon, "about average (upper
  half)" for Opus; E is "about average" for all three.

## The six concepts

| | Concept | Designer | Renders (all in research/concepts/<letter>/) |
|---|---|---|---|
| A | The Desk: first-person founder's desk, CRT holds the plan, slips and folders in a rack on the desk edge, brass P(Doom) dial, chair swivels to the office in WATCH | Claude Opus 5.5 | m1.png, m5.png, door.png, place2.png (Upgrades drawer), watch.png |
| B | The Mainframe OS: a 1990s lab OS, PLAN.EXE / STAFF / LEDGER / PROCUREMENT / MAIL windows, events as mail | GPT Sol 6.2 | m1.png, m5.png, place2.png (Procurement), watch.png |
| C | The Paperwork Desk: Papers, Please register, Form A-20 is the month, card file of actions, stamps, in-tray memo, printed month ledger | Claude Opus 5.5 | m1.png, m5.png, door.png, place2.png (October ledger), watch.png |
| D | The Card Table: fanned hand of action cards played onto a month board of priority slots | Gemini Neon 4 | m1.png, m5.png, place2.png (Credenza), watch.png |
| E | Rooms and Stations: a fixed instrument frame, F1 Desk / F2 Lab Floor / F3 Procurement / F4 Records | Claude Opus 5.5 | m1.png, m5.png, place2.png (Lab Floor), watch.png |
| F | Pure Terminal: full amber/green ASCII terminal, panes and F-key bar | Claude Opus 5.5 | m1.png, m5.png, place2.png (upgrades), watch.png |

Side by side, month 5: research/concepts/compare.html and compare.png.
Each concept: concept.html (open with ?view=m1, m5, watch, place2, door) and
notes.md (with "Fix round 1" / "Fix round 2" lists for A, C, E).

## Scores (overall /10)

Round 1 scored all six; rounds 2-3 re-checked the shortlist only. Per the
council skill, Neon was not asked in round 2 because Opus and Sol had not yet
passed.

| Member | Concept | R1 | R2 | R3 |
|---|---|---|---|---|
| Claude Opus | A | 8 | 8.5 | 8.5 |
| | C | 7.5 | 8.5 | 8.5 |
| | E | 7 | 8 | 8 |
| | F / B / D | 6 / 6 / 4 | - | - |
| GPT Sol | A | 8 | 8 | 9 |
| | C | 7.5 | 8 | 8.5 |
| | E | 8.5 | 7.5 | 8.5 |
| | F / B / D | 6 / 8 / 6.5 | - | - |
| Gemini Neon | A | 9 | not asked | 9 |
| | C | 9 | not asked | 9 |
| | E | 8 | not asked | 8.5 |
| | F / B / D | 7 / 7 / 6 | - | - |

Round-1 shortlists before consensus: Opus A C E, Sol E A B, Neon C A E. After
the consensus step all three agreed A C E and the order A, C, E, F, B, D.
Ten split fix items were settled by majority vote, each member accepting
(council/concepts/r1-votes-*.md).

## What was fixed in the shortlist

Shared game facts the council checked in godot/ and the designers applied:
Work Your Connections costs 2 OPERATING hours + 6 rep (C and E had it as
planning and blocked it); Onboard New Hires is operating hours + money per
step with a real blocker; Hire Staff roles are 1 planning hour each; C's
"NONE AFFORDABLE" on Strategic was wrong; events shown in WATCH must be
eligible (Stray Cat is July-only, Keynote Slot needs rep >= 40; all three now
use Talent Opportunity); each handled event option costs 1 held hour, ignore
is free; held hours are untyped; the whole plan runs at Commit, so WATCH
counters come from one consistent state; reputation displays as a whole
number.

- **A (round 1, 8 items):** typed costs; one editable row per play with
  reorder/remove, Undo, Clear; totals and badges derived from rows; Pay the
  Bill replaced; sixth calendar row; fixed card slots m1 -> m5; 16px floor;
  gantt dates in their own column; door view dimmer, detail card, single
  Enter; real Ledger tile; eligible WATCH event with correct prices; glow box
  removed. **(Round 2):** rack rail moved clear of stamps and buttons; all
  plays done on 01 Nov in WATCH; reputation 22.
- **C (round 1, 6 items):** WYC and Onboard costs; m5 form rebuilt (14 valid
  rows, 12 plan + 3 op, badges reconcile); Strategic stamp removed; RISING
  added, "lose at 100%" removed; NO./ORDER columns, 26px reorder buttons,
  fixed badge corner, gantt clearance; 16px floor; memo paperclip, prices,
  pending-reply state, duplicate office thumbnail hidden. **(Round 2):**
  reputation 24; notes corrected about Desperation Lever's random draw.
- **E (round 1, 5 items):** m5 queue rebuilt so rows and time card agree;
  RISING, reputation 100 label, P(Doom) no longer overlaps the CRT; "+" on
  every direct action, Hire Staff and Onboard costs, OPEN tab linked to its
  folder; eligible WATCH event, consistent counters, held hours once; Lab
  Floor name tag. **(Round 2):** held hours shown once in WATCH ("12 spent /
  3 spent", "HELD FOR EVENTS 5h"); Scouting door 1 / 8 / 3 queued; Onboard
  blocker from an explicit eligibility flag.

## Gallery check (Alex's finish line)

Gallery: research/concepts/gallery.html (and gallery.png): all 39 reference
shots (research/reference-games/shots, research/diegetic/shots) with 12 of
our renders (A, C, E: m5, m1, watch, place2) mixed in, orange-bordered and
labelled OURS. Answers: council/concepts/gallery-{opus,sol,neon}.md.

| Concept | References chosen (union of members) | Opus | Sol | Neon |
|---|---|---|---|---|
| A | Not For Broadcast 1/2, Papers, Please 1, Frostpunk 1, Suzerain 1, Hacknet 2, FTL 1/2, Shenzhen I/O 1 | better, belongs | better, belongs | better, belongs |
| C | Papers, Please 1/2, Orwell 1, Shenzhen I/O 1/2, Suzerain 1, Not For Broadcast 1 | average (upper half), belongs | better, belongs | better, belongs |
| E | Game Dev Tycoon 1/2, Hypnospace Outlaw 1, XCOM 2 (base/research), Football Manager 2024 1, Against the Storm 2, Shenzhen I/O 1, Not For Broadcast 1 | average, belongs | average, belongs | average, belongs |

What the members say holds each back (non-blocking):
- A: the office shows mostly at the edges in PLAN; the card rack reads as a
  flat grid; the WATCH operator is placeholder art.
- C: the PLAN card file is a large grid of near-identical folders and
  competes with the form; the office is a small window in PLAN; placeholder
  operator.
- E: the Lab Floor camera (flat box, isometric racks, empty middle) clashes
  with the painted room and looks the most prototype-like; the locked action
  rack takes a lot of the WATCH view and its buttons still look live.

## Remaining defects (all non-blocking, agreed)

- Every concept uses a placeholder operator silhouette; Pip calls the
  silhouetted operator "the CORE UI image". One shared, lit operator-and-chair
  asset is an art job.
- E: grouped queue rows (x8, x3) share one set of reorder/remove controls;
  unclear whether they act on one play or the group. Procurement and Records
  stations are reachable by tab but not drawn.
- A: about 100px of blank paper at the top of the WATCH teleprinter.
- All m5 queues are hand-built fixtures from real action data, not saved
  games. A fixes Public Warning's random reputation roll at +2 for its
  fixture; C's and A's hire result lines are the designers' wording.

## Needs Alex's (or Pip's) decision

1. **Which concept to take forward** (A, C or E), or a hybrid: all three
   members flagged C's printed month ledger and look-back as a strong piece
   that could sit inside A. Merging is Alex's call, not a fix.
2. **The operator art.** A new silhouette asset is needed whichever concept
   wins; that is art, and Pip owns the game's look.
3. **How much office to show in PLAN.** A and C keep the office mostly to
   WATCH (Pip's notes put the operator scene in WATCH,
   WORKSHOP_2_BACKLOG.md ~744-747); E shows it in PLAN. Alex's "feel of being
   in an office" may want more of it in PLAN.
4. **No mechanics changes are implied** by A, C or E: every element is a
   view of existing state, no doom deltas, no hidden information shown. Two
   data gaps the designers worked around, for Pip if they matter: Advertise a
   Role has no cost in the data (E shows "cost not listed yet"); Send
   Delegation has empty costs (F assumed 1 planning hour; F is not
   shortlisted).

## Files

- Council relay and answers: research/council/concepts/ (brief.md;
  r1-*.md, r1-agreed.md; r2-*.md; r3-*.md; gallery-ask.md, gallery-*.md).
- Concepts: research/concepts/A..F/; compare.html/png; gallery.html/png
  (gallery files now show Round 2; see below).

---

# Round 2: simplify (and concept G)

## Alex's words

> "I think all of the designs need vastly more negative space to show the art, and we have individual menu systems handle state. I feel like they're trying to cram far too much onto the screen. The buttons do need to serve as shortcuts, but there needs to be way more negative space. There needs to be way more, way less detail on one screen. This needs to be simple. It needs to make the goal of this UI is to make a complex game simpler, not overwhelm the player."

> "Have an agent work on modernizing the existing UIs spirit without overhauling it too drastically and add that into the process"

The same designers reworked A, C and E (brief: concepts/round2-designer.md);
a new designer (Claude Opus 5.5, high) built **G. The Existing UI,
Modernised** from today's main.tscn (brief: concepts/G-designer.md). The
round was paused once on Alex's request (concepts/RESUME.md) and resumed with
the same delegates. GPT Sol ran as gpt-6.2-sol throughout (no capacity
failure). Neon's first review of G failed with an auth error (401); the retry
succeeded.

## Before and after (home screen, month 5)

research/concepts/round2-before-after.png (and .html): A, C, E round-1
month-5 screen (<letter>/r1/m5.png) next to the Round 2 home (home.png); G:
today's game (G/before-m5.png) next to G/home.png. Round 2 homes are also
kept as <letter>/round2-home.png once Round 3 starts.

## The four concepts (renders in research/concepts/<letter>/)

| | Concept | Home elements | Art + empty (council est.) | Views |
|---|---|---|---|---|
| A | The Desk: office art with a desk terminal (Attention + first three plays), P(Doom) dial, reputation meter, shortcut rack, Commit | 6 groups | ~69-70% | home, home-m1, actions, door, plan, upgrades, watch |
| C | The Paperwork Desk: office art, wall calendar / accounts slip / P(Doom) / reputation, desk objects that open menus, Commit stamp | 11-12 | ~76-80% | home, home-m1, actions, door, plan, watch |
| E | Rooms and Stations: mezzanine office art, five station buttons, a "This Month" card, Commit | 10 | ~81-82% | home, home-m1, actions, door, plan, watch |
| G | Today's layout kept (resource bar, ## PLAN banner, doom ring, queue card, bottom bar) with menus on a left rail | 11 groups | ~66-68% | home, home-m1, actions, plan, upgrades, watch |

## Council (low sensitivity: Claude Opus 5.5, GPT Sol gpt-6.2-sol, Gemini Neon 4; all high effort)

**Agreed ranking: 1 E, 2 A, 3 C, 4 G** (council/concepts/r2s-agreed.md).

Scores /10:

| Member | Review A / C / E / G | Re-check A / C / E / G | After the scroll fix |
|---|---|---|---|
| Claude Opus | 8 / 7.5 / 8.5 / 7.5 | 8.5 / 8 / 8.5 / 7.5 | E 8.5, G 7.5, GOOD TO GO |
| GPT Sol | 7.5 / 8 / 8.5 / 7 | 8 / 8 / 8.5 / 7.5, CHANGES NEEDED | 8 / 8 / 8.5 / 7.5, GOOD TO GO |
| Gemini Neon | 8.5 / 8.5 / 8 / 7.5 | not asked (Opus and Sol had not both passed) | 9 / 9 / 9 / 8.5, GOOD TO GO |

All three agree all four concepts are ready to show Alex.

## What was fixed

Shared rules agreed for all four: Attention bars filled = hours LEFT in every
view; only the topmost open layer shows Enter/Esc; operational text >= 16px;
every repeated play has its own edit target (groups expand); home screens
stay sparse.

- A: one "open" plate style; home terminal lost its reserve row and cost
  total; Actions header shows hours left; Hire Staff keeps "open >" at 0
  planning hours; research shortfall shown; reserve -/+ back in Plan;
  calendar sliver hidden; single Esc/Enter in the door view.
- C: menus cover the whole desk band (no slivers, no double Attention boxes);
  key caps bottom-right; WATCH clipboard shows spent hours and one untyped
  held figure; filled = left; 16px labels; "Hire Staff" on form row 2; visible
  ring on the open folder; one Esc.
- E: Plan bars match home; "Queued cost" and "Held for events at Commit" in
  Plan; expandable groups, then (after the re-check) a scrolling queue so the
  x8 group no longer clips Under Way; research shortfall; Add control and
  focus in the door; WATCH shows cash in hand and a route to the 01 Nov
  outcomes.
- G: empty icon frames and the mismatched Travel handshake removed; WATCH
  choices 1/2/3 with background keys hidden; [V] labelled "View" and dimmed in
  events; filled = left; Under Way off home; "$110,300 + 6 rep"; centred
  month-1 gauge; expandable groups, then a scrolling play list so the x6 group
  no longer pushes Undo/Clear/Reserve off screen; 16px text.

Settled non-blocking during the re-check: C's teleprinter repeating "Held for
events: 5 hr" (a log line, as with G's); E's Commit Enter cap under Actions
and Plan (nothing else owns Enter there).

## Gallery check

Gallery: research/concepts/gallery.html; snapshot of the Round 2 state:
gallery-round2.png (39 references + 20 Round 2 renders of A, C, E, G,
labelled OURS). Answers: council/concepts/gallery2-{opus,sol,neon}.md.

| Concept | Opus | Sol | Neon | vs earlier version |
|---|---|---|---|---|
| A | better, belongs | better, belongs | better, belongs | better than Round 1 (all three) |
| C | average (upper half), belongs | better, belongs | better, belongs | better than Round 1 (all three) |
| E | better, belongs | better, belongs | better, belongs | clearly better; biggest gain (all three) |
| G | average, belongs | average, belongs | average, belongs | much better than today's game (all three) |

**All four meet Alex's bar ("belongs here", at least average).**

Most-cited references: A -- Not For Broadcast 1, Papers, Please 1,
Frostpunk 1; C -- Papers, Please 1/2, Shenzhen I/O 2, Suzerain 1; E --
Frostpunk 1, XCOM 2, Game Dev Tycoon, Football Manager 2024; G -- Football
Manager 2024, Terra Invicta 1, Hacknet 1, Against the Storm 1.

What the members say holds each back (non-blocking): A's Actions menu is a
flat grid of cards and its home has three housings; C's Action Cards menu is
a grid of near-identical tiles and its bottom desk band is busy; E's station
buttons are plain rectangles; G is flat software chrome over the art and has
the densest home. In A, C and E the placeholder operator silhouette is the
weakest art (Round 3 removes it).

## Remaining non-blocking items

- Undrawn places: E's Lab Floor / Procurement / Records; C's Staff /
  Upgrades / Ledger / Guide; A's Staff / Ledger / In-tray / Guide.
- G: sparkline from recorded history; uneven rhythm of 10 icon rows and 7
  iconless rows.
- Scroll areas cut the last visible row in half (a fade would look
  deliberate).

## Needs Alex's (or Pip's) decision

- Which concept to take forward. E has the simplest home; A is the most
  diegetic; C has the strongest paperwork flow; G is the low-risk path (its
  notes map each change to existing main.tscn nodes).
- Money on home: C keeps a slim money/research slip; A, E and G moved money
  into the menus.
- New shortcut keys proposed by the designers (A, P, S/E, U, F/G, O ...);
  only L exists in the game today.
- Possible game bug for Pip (found by Opus in the source, not confirmed in a
  run): Hire Compute Engineer appears to skip the desk-cap check
  (godot/scripts/core/actions.gd ~400-409), so a queue can seat three people
  in a two-desk office.
- Data gaps: Advertise a Role has no cost; Send Delegation has empty costs.

## Files (Round 2)

- concepts/A, C, E, G: concept.html, notes.md (with "Round 2 fixes"), Round
  2 renders; A, C, E: r1/ (round-1 copies); G: before-m5.png.
- concepts/round2-designer.md, G-designer.md, round2-before-after.html/png,
  gallery.html, gallery-round2.png, RESUME.md.
- council/concepts/: round2-ask.md, round2-G-ask.md, r2s-*.md, r2s-G-*.md,
  r2s-consensus-*.md, r2s-votes-*.md, r2s-agreed.md, r2s-recheck-*.md,
  r2s-recheck-settle*.md, r2s-recheck2-*.md, gallery2-*.md.

---

# Round 3: icons and the empty office

## Alex's words

> "Let's see if we can get them to work icons similar to Pip's original icons into the designs ... I don't like the humanoid kind of outline. I don't like that at all. I think we should get rid of those person, I think, is less eerie than the empty office, and that eeriness is the kind of vibe the game's going for. So, those designs are good still. I don't have any issues with them. I think they should remain in contention. But the person outlined and that can go and just we can leave that space."

All four concepts stayed in contention; the same four designers and the same
council ran the round (designer brief: concepts/round3-designer.md; council
brief: council/concepts/round3-ask.md). GPT Sol ran as gpt-6.2-sol
throughout.

## Before and after

research/concepts/round3-before-after.png (and .html): each concept's Round 2
home (<letter>/round2-home.png) next to its Round 3 home (home.png).

## What the designers did

- **No person anywhere.** The operator silhouette (head, shoulders, chair)
  was removed from every view of A, C and E; that space is now empty office
  art with nothing added. G never had one; its WATCH event photo of a hand
  stroking the cat was replaced with Pip's painted doom-cat.
- **Pip's icons** beside labels on existing buttons and labels (never
  replacing them), one size per kind of place, the same icon for the same
  thing in every view: A 26 Pip icons, C 32, E 31, G 21, each copied into the
  concept's assets/icons/.
- **New icons, "needs art"** (drawn in the set's style where Pip has none):
  A -- Publicity (megaphone), Advertise a Role (pinned notice), Travel
  (suitcase), Post Online (speech bubble), Feed (printout), In-tray (inbox
  tray); C -- Advertise a Role, Travel, Publicity, Post Online, Desperation
  Lever (lever); E -- Advertise a Role, Publicity, Post Online, Travel
  (suitcase); G -- Advertise a Role, Travel, Publicity, Post Online, Go to
  Meetups (glasses).
- Several game mappings in godot/data/icon_mapping.json were not followed
  because the icon shows something else (e.g. the globe-handshake on Travel
  shows international cooperation; the emergency stop on Strategic; the open
  folder on Publicity). Worth telling Pip.

## Council (Claude Opus 5.5, GPT Sol gpt-6.2-sol, Gemini Neon 4; all high)

**Agreed ranking: 1 E, 2 A, 3 C, 4 G** (council/concepts/r3x-agreed.md). All
three found the silhouette gone and the empty office eerie.

| Member | Review A / C / E / G | Re-check A / C / E / G | Final |
|---|---|---|---|
| Claude Opus | 8.5 / 8 / 8.5 / 7.5 | 8.5 / 8 / 8.5 / 7.5, GOOD TO GO | E 8.5, G 8 after the scrollbar fix, GOOD TO GO |
| GPT Sol | 8.5 / 8 / 8.5 / 7.5 | 9 / 8.5 / 9 / 8, CHANGES NEEDED (G) | 9 / 8.5 / 9 / 8, GOOD TO GO |
| Gemini Neon | 9 / 8.5 / 9 / 8 | not asked until Opus and Sol passed | 9.5 / 9 / 9.5 / 8.5, GOOD TO GO |

## What was fixed

- A: Plan plate moved off an audit clipboard (a near-twin of Safety Audit)
  to Pip's calendar `ui_config_date`; Read the Literature moved off the
  research flask to `resource_papers_small`; In-tray moved off an open safe to
  a new inbox-tray icon.
- C: every schedule row carries its own play's icon (not the Scouting radar);
  Financing and Work Your Connections moved to Pip's framed tiles
  (`action_funding_loan`, `action_publicity_network`).
- E: Travel & Conferences moved off the globe-handshake to a suitcase; the
  Plan headings line up when the queue scrolls.
- G: Staff moved off a smiley to `ui_staff_management`; Ledger off a gavel to
  `ui_budget_finance` (Financing to `action_funding_loan`); Publish Safety
  Paper to `paper.png`; plan columns line up when the list scrolls and "x6"
  clears "6 plan"; then (after Sol's re-check in normal Edge) the browser's
  own scrollbar is hidden so only G's bar shows. E's queue already hid it.

## Question for Alex (open, non-blocking)

Do these count as "the person"? The council split on them and agreed to ask
rather than decide:
- people in two event pictures: the portrait on C's WATCH memo, and the two
  figures in E's WATCH memo art;
- Pip's small control icons: Staff (`ui_staff_management`, three silhouettes
  at a table, used in A, C, E's Lab Floor and G) and Hire
  (`button_hire_normal`, head and shoulders, in all four).
If yes, the fix is small: drop the memo images and draw figure-free Staff and
Hire icons.

## Remaining non-blocking items

- The "new, needs art" icons are flatter than Pip's painted ones (most in G).
- Fundraising and Financing money bags look alike (most visible in C).
- Pip's calendar icon shows a fixed "17".
- A few of Pip's round medallion icons sit beside his square tiles (A, E).

## Files (Round 3)

- concepts/A, C, E, G: re-rendered views, assets/icons/, notes.md with
  "Round 3" and "Round 3 fixes", round2-home.png (before image).
- concepts/round3-designer.md, round3-before-after.html/png.
- council/concepts/: round3-ask.md, r3x-{opus,sol,neon}.md,
  r3x-consensus-*.md, r3x-agreed.md, r3x-recheck-*.md,
  r3x-recheck-settle-opus.md, r3x-recheck2-*.md.

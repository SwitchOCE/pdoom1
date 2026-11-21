# Council brief: pick the best PLAN-screen concepts (round 1)

You are one of three council members (Claude Opus, GPT Sol, Gemini Neon). Six
designers each made one concept for the PLAN screen of P(Doom)1, Pip
Foweraker's game, in six different styles. Your job: find visual defects,
score, rank, and name the best two or three with what each needs fixed.
Work read-only: do not edit anything under research/concepts/ or in
C:/Users/keech/Documents/pdoom1. Write your answer to
C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r1-<your member name: opus|sol|neon>.md
and also reply with it in full.

## Alex's words (quoted; Alex owns this fork and will choose)

> "I think you need to offer more variety in designs. Use different styles and different layouts. Have the council pick which ones are the best."

> "I want you to find clever diegetic designs. Obviously, every diegetic design is going to be different because of how delicate and custom they need to be to their topic. But if you look at a game like Papers Please or a game where you play basically driving a CRT monitor and you're on Windows 98 ... finding a way to blend flavor together and have it still feel good? Clever diegetic UI design is what we're we need to find a way of striking. The concept art Pip has in the background is not perfect, right? But the feel of being in an office with a bunch of computers with Doom approaching, right? Is something that we need to try and capture"

> On the previous, rejected mock-up: "the icons no longer match the buttons ... Some are centralized and some are left-aligned ... Font sizing and stuff, there's stuff overlaying specific elements and overflowing out of areas of the screen ... all of the flavor from the diegetic aspects are lost. Done in a smart way, the diegetic aspect could be recaptured. It may need to be a longer process ... with more screens and more flows rather than one control board ... I don't think pip would be happy with this. And I don't think I am either"

## Inputs (all paths under C:/Users/keech/Documents/pdoom1-lean-setup/research/)

- The designer brief every designer followed (states to draw, the "Must hold" list, deliverables, visual quality pass): concepts/brief.md. Read it first; it is the bar.
- The six concepts, each in concepts/<letter>/: concept.html (1920x1080, open with ?view=m1, ?view=m5, and where present ?view=watch, ?view=place2, ?view=door), renders m1.png, m5.png and any of watch.png, place2.png, door.png, plus notes.md.
  - A. The Desk (first-person founder's desk, CRT plan, action slips along the desk edge)
  - B. The Mainframe OS (1990s lab operating system, windows, mail)
  - C. The Paperwork Desk (Papers, Please register: forms, stamps, in-tray)
  - D. The Card Table (fanned hand of action cards on a month board)
  - E. Rooms and Stations (a constant frame plus places to move between)
  - F. Pure Terminal (full ASCII/CRT terminal)
- Side by side, month 5: concepts/compare.png (and compare.html).
- Diegetic UI research (games that blend flavour and usability; techniques and pitfalls): diegetic/findings.md and diegetic/shots/.
- Fork scope (no mechanics changes): C:/Users/keech/Documents/pdoom1/AGENTS.md section 1. Game data to check costs and hour types against: C:/Users/keech/Documents/pdoom1/godot/data/.

## What to do

1. **Visual-defect pass on every concept** (look at the renders at full size, crop or zoom as needed): alignment, icon-to-action match, type sizes against the 16px floor (anything read to operate a control) and 14px floor (secondary prose), overlap, overflow, clipping, spacing, dead space, near-black backgrounds. List defects per concept with the view and location.
2. **Score each concept** 1-10 on: (a) diegetic flavour -- "the feel of being in an office with a bunch of computers with Doom approaching"; (b) usability and readability against the brief's Must-hold list; (c) fit with Pip's intent (brief.md "Pip's intent and assets"); (d) scope -- no mechanics changes, no doom deltas, nothing the player hasn't earned, every action reachable, states drawn as specified. Then one overall score /10 per concept.
3. **Rank all six** and name the best two or three, with reasons, and for each of those a numbered fix list (defects and Must-hold misses to fix before Alex sees it).

Keep scope tight: the task is "pick the best concepts and fix their defects". Mark anything outside that (new features, redesigns of a different concept) as non-blocking.

## Answer format

- First line: `VERDICT: SHORTLIST <letters in rank order>` (e.g. `VERDICT: SHORTLIST C A E`).
- A score table: concept x (flavour, usability, Pip fit, scope, overall).
- Full ranking A-F, one line of reasons each.
- Defects per concept (all six).
- For each shortlisted concept: numbered blocking fix list, each item with evidence (view + location) and the fix.
- At most 3 non-blocking notes.
- A disk report: anything you wrote outside council/concepts/r1-<name>.md (scratch crops etc.), sizes, and what can be deleted.

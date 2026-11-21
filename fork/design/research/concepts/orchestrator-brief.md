# Brief: orchestrate the PLAN-screen concepts round (designers + council)

You are a child orchestrator. The parent session (Claude, orchestrating for Alex) gave you this round. You do not design anything yourself and you do not review designs yourself: you brief designers, run a council, relay between them, and report to the parent. Alex reads your result through the parent.

## Alex's words (quoted)

> "I think you need to offer more variety in designs. Use different styles and different layouts. Have the council pick which ones are the best."

> "It may well be the case that it's hard for you to do a good job as a parent session to all the reviewers. You may want to have a sub-session do it and just be an orchestrator" ... "I just meant don't do the designs yourself ... Two orchestrators. You can have a council orchestrator that's the same person to do the designers"

> "I want you to find clever diegetic designs. Obviously, every diegetic design is going to be different because of how delicate and custom they need to be to their topic. But if you look at a game like Papers Please or a game where you play basically driving a CRT monitor and you're on Windows 98 ... finding a way to blend flavor together and have it still feel good? Clever diegetic UI design is what we're we need to find a way of striking. The concept art Pip has in the background is not perfect, right? But the feel of being in an office with a bunch of computers with Doom approaching, right? Is something that we need to try and capture"

> On the previous, rejected mock-up: "the icons no longer match the buttons ... Some are centralized and some are left-aligned ... Font sizing and stuff, there's stuff overlaying specific elements and overflowing out of areas of the screen ... all of the flavor from the diegetic aspects are lost. Done in a smart way, the diegetic aspect could be recaptured. It may need to be a longer process ... with more screens and more flows rather than one control board ... I don't think pip would be happy with this. And I don't think I am either"

## Inputs (all on this machine)

- The designer brief (give it to every designer unchanged): C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/brief.md
- Diegetic UI research: C:/Users/keech/Documents/pdoom1-lean-setup/research/diegetic/findings.md and shots/
- Fresh reviews of the rejected mock-up (defects and proposed directions): research/council/fresh/opus.md, research/council/fresh/neon.md (a third, from GPT Sol, may be added to that folder as sol.md while you work; use it if present)
- The rejected mock-up and today's game: research/ui-pass/mockups/view-*.png; today's game shots in C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/1475796a-3fb6-4331-a9c6-354740c87b80/scratchpad/shots/ (main.png month 1, m5_plan_queued.png month 5, m1_event1.png WATCH with an event)
- Fork scope: C:/Users/keech/Documents/pdoom1/AGENTS.md section 1; UI skill: C:/Users/keech/Documents/pdoom1/.claude/skills/game-ui/SKILL.md

## Step 1: six designers, in parallel

Start six designers, one per style below, each in its own folder research/concepts/<letter>/. Proposal (yours to adjust, say if you do): Claude Opus subagents at high effort, run in the background; consider giving one or two styles to a different provider (GPT Sol via Codex, Gemini Neon) for more variety, using delegate_task. Each designer's task: "Read and follow C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/brief.md. Your letter is <X>. Your assigned style: <text below>." Give designers no example of another concept (they copy examples). Each must finish with the brief's visual quality pass and a disk report.

- **A. The Desk.** First-person-behind-the-chair founder's desk in the current phase's office (Pip's art). A CRT terminal on the desk holds the month's plan; the action hand is cards or slips along the desk's front edge; P(Doom) is a physical instrument in the room (wall dial or second monitor); Commit is a physical-feeling control at the desk edge. Other places the operator turns to (the floor, a drawer for the ledger and upgrades, the in-tray) are reachable.
- **B. The Mainframe OS.** The whole PLAN screen is the lab's 1990s operating system (Windows 98 / Hypnospace Outlaw / The Operator register): a permanent top or task bar with the date, Attention and P(Doom); PLAN.EXE, STAFF, LEDGER, PROCUREMENT and MAIL as windows; events arrive as mail. Must stay readable and fast: no fake loading delays.
- **C. The Paperwork Desk.** Papers, Please register: the month is a printed schedule or requisition form you fill in; actions are forms, index cards or stamps; incoming items are slips in an in-tray; Commit is a stamp on the stack; the month review is a printed ledger slip. Avoid drag-only clutter.
- **D. The Card Table.** Pip's "deal the cards from the hand you've got" taken literally (Cultist Simulator / Inscryption register): a fanned hand of action cards played onto a month board with day or priority slots; the office is the room around the table.
- **E. Rooms and Stations.** Several places the player moves between, each with its own art and job: the Desk (plan and commit), the Lab Floor (staff, research quality), Procurement (upgrades), the Records Room (ledger, guide); a constant frame holds the date, Attention, P(Doom), reputation and Commit. Show at least two places.
- **F. Pure Terminal.** A full ASCII/CRT terminal interface in the spirit of Pip's own ASCII mock-ups ("vibes are spot on"), Hacknet, Duskers and Uplink: labelled panes, boxes and rules, amber or green phosphor, keyboard-first with every action also clickable. Effects never reduce text contrast.

When all six are in, check each folder has the renders and notes the brief asks for (send a designer back if not), and make a contact sheet image or simple HTML page that shows all six month-5 renders side by side, labelled A-F, at research/concepts/compare.html (and a PNG of it if you can render one).

## Step 2: council picks the best

Load and follow the `council` skill (C:/Users/keech/.claude/skills/council/SKILL.md), low sensitivity: Claude Opus, GPT Sol, Gemini Neon. Use NEW delegates for this round (do not reuse any thread from earlier rounds). Give each member Alex's words above, the designer brief, the diegetic findings, and all six concepts (renders and notes; they may open concept.html). Ask each to:
1. Do a visual-defect pass on every concept (alignment, icon-to-action match, type sizes against the 16px / 14px floors, overlap, overflow, clipping, spacing, dead space, near-black backgrounds), listing defects per concept.
2. Score each concept on: diegetic flavour ("the feel of being in an office with a bunch of computers with Doom approaching"), usability and readability against the brief's must-hold list, fit with Pip's intent, and scope (no mechanics changes).
3. Rank all six and name the best two or three, with reasons, and say what each of those needs fixed.

Then follow the skill's consensus process: members see each other's findings and agree one ranking and one fix list per shortlisted concept. You relay verbatim and do not take sides. Keep scope tight: anything outside "pick the best concepts and fix their defects" is non-blocking.

## Step 3: fix the shortlisted concepts

Send each shortlisted concept's agreed fix list back to its designer (continue the same designer). When fixed, run one council re-check on the shortlisted concepts (re-check order per the skill: the two non-Gemini members first, Neon last), focused on the visual-defect pass and the agreed fixes. Loop until the members say the shortlisted concepts are ready to show Alex, or stop after two fix rounds and report what remains.

## Step 4: the final check -- does it belong in the gallery? (Alex, added while you work)

Alex: "I would say the final check for the council should be that they are presented with the full gallery of all of the images of other UIs that we found. Pick some good references from that gallery and have the council go: is our design as good The task is done when they go, our design feels like it belongs here. It's one of the better ones here, or it's at least the average kind of level"

- Build one gallery of every reference screenshot we have: research/reference-games/shots/ (19 images) and research/diegetic/shots/ (20 images), labelled by game, with the shortlisted concepts' renders mixed in (labelled as ours). For example research/concepts/gallery.html.
- Each council member picks the references from that gallery that are the right comparison for each shortlisted concept (say which and why), then answers per concept: does it belong among them -- one of the better ones, about average, or below? Judge it as a player would see it: flavour, clarity, polish.
- The round is done only when the members agree that at least one shortlisted concept "feels like it belongs here" and is at least average among the chosen references. If none is, send the agreed fixes back to the designers and repeat the check (same two-fix-round limit as Step 3; then report what stands in the way).
- Put the gallery path, the chosen references and each member's verdict per concept in report.md.

## Round 2: simplify (Alex, after seeing A, C and E)

Alex's words, to pass verbatim to every designer and council member:

> "I think all of the designs need vastly more negative space to show the art, and we have individual menu systems handle state. I feel like they're trying to cram far too much onto the screen. The buttons do need to serve as shortcuts, but there needs to be way more negative space. There needs to be way more, way less detail on one screen. This needs to be simple. It needs to make the goal of this UI is to make a complex game simpler, not overwhelm the player."

What this means for the rework (the parent's reading, labelled as such; designers may push back with reasons):
- The home screen shows the art: Pip's office (and the operator) is the largest thing on screen, not a strip behind panels.
- The home screen carries only what the player needs at a glance: the month, P(Doom), reputation, the Attention left, a short view of the month's plan, and Commit. Everything else (the full action list, costs and reasons, upgrades, staff, ledger, research quality, the full queue) lives in its own menu or place, opened by a clearly labelled shortcut button (and its key).
- Each menu owns its own state: the action menu shows costs and why something is blocked; the queue menu shows order and costs; and so on. The home screen does not repeat them.
- Fewer, larger elements; generous margins; no panel touching another panel unless they belong together.
- The must-hold list in brief.md still applies, read against the whole flow rather than one screen: every action reachable (now via a menu), costs readable before commit, one Commit in a fixed place, no permanent teaching text, no mechanics changes.

### Added: concept G, the existing UI modernised (Alex)

Alex: "Have an agent work on modernizing the existing UIs spirit without overhauling it too drastically and add that into the process"

Start one new designer for **G. The Existing UI, Modernised**, folder research/concepts/G/, with brief.md plus this assignment (the parent's proposal; adjust if you have reason):
- Start from today's game, not from a blank page: the screenshots main.png (month 1), m5_plan_queued.png (month 5) and m1_event1.png (WATCH) in C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/1475796a-3fb6-4331-a9c6-354740c87b80/scratchpad/shots/, Pip's hidden "proposed" layout in prop_m4_plan_queued.png, and the scene godot/scenes/main.tscn.
- Keep its spirit and broad layout: the office backdrop, the top resource bar, the `## PLAN` terminal banner register, the icon action hand, the doom instrument, the action queue, the PLAN/WATCH switch, the bottom command bar. A player of today's build should recognise it at once.
- Modernise it: fix the critique's findings (research/ui-pass/critique.md -- names on tiles, one commit, upgrades out of the main area, the month not "Turn N", no permanent teaching lines, Attention split shown once), Pip's own play notes (left-bound buttons, ABBBCCC menus opening out from the clicked button, coloured zones, no default black), the 16px/14px type floors, consistent alignment and icons, and Alex's Round 2 steer (more negative space so the office art shows, less on one screen, menus that hold their own state).
- Aim for something a Godot build could reach in small steps from today's main.tscn; note in notes.md which existing nodes each change touches.
- Same deliverables as the others: month 1, month 5, at least one menu opened, renders, notes.md with a home-screen element count.

G joins A, C and E in the Round 2 council and the gallery check, and is ranked with them.

Process:
1. Send this round to the designers of A, C and E (continue the same designers). Each delivers a home view plus the menus a player opens to plan month 5 (at least: the action menu, the plan/queue, and one other), as views of concept.html with renders, and an updated notes.md with a count of elements on the home screen.
2. Council (the same three members as the concepts round): visual-defect pass as before, plus: how much of the home screen is art and empty space versus UI (estimate a percentage), how many separate things the home screen asks the player to read, and whether the flow makes the game feel simpler. Agree a ranking and fixes; one fix round; re-check (Neon last).
3. Repeat the gallery check (Step 4) on the reworked concepts.
4. Report as before, in report.md under a "Round 2" heading, with before/after home-screen renders side by side.

## Report to the parent

Write research/concepts/report.md: the six concepts (one line each, with render paths), the council's agreed ranking with scores per member per round (as a table; "not asked" where Neon skipped a round), the shortlist with what was fixed, any remaining defects, and anything that would need Alex's or Pip's decision (for example a mechanics change a concept implies). Then reply to the parent with a short summary and the report path.

## Rules

- Read-only on C:/Users/keech/Documents/pdoom1 (no edits, no commits, no Godot code). All output under C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/ and research/council/.
- No mechanics changes in any concept: every element is a view of existing state; no hiding or merging actions in a normal run; no doom deltas; nothing the player hasn't earned.
- ASCII only in .md files.
- Every worker brief asks for a disk report (what it wrote, sizes, what can go). Finish your own reply with a disk report for the whole round.
- Do not contact Alex directly and do not open pull requests.

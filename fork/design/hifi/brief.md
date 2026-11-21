# High-fidelity run: brief for the orchestrator (Optiplex)

Written 2026-11-21 by Alex's Claude session on his PC. You run on the
Optiplex in /home/alex/code/pdoom1, branch `design/ui-concepts`.

## What Alex asked for (his words)

> "I just want to be able to show pip like a full artifact something that he
> can look at that shows some of the states for these UIs. Can we take them to
> more fully fleshed out, higher fidelity stuff?"

Pip Foweraker owns the game; Alex works on a fork that only changes UI,
tutorial and bugs. Earlier steers from Alex that still hold (quoted in
fork/design/research/concepts/report.md, Rounds 2 and 3):

- "vastly more negative space to show the art ... individual menu systems
  handle state ... way less detail on one screen ... make a complex game
  simpler, not overwhelm the player."
- "I don't like the humanoid kind of outline ... less eerie than the empty
  office, and that eeriness is the kind of vibe the game's going for."
- Icons similar to Pip's own (godot/assets/icons/); every icon matches the
  button it sits on.
- Earlier rejection of a mock-up: icons not matching buttons, inconsistent
  alignment, inconsistent font sizes, things overlapping and overflowing, and
  lost diegetic flavour. These are the defects to hunt.

## The goal of this run

Turn the four concepts still in contention -- A. The Desk, C. The Paperwork
Desk, E. Rooms and Stations, G. The Existing UI, Modernised -- into a
showcase Pip can browse: each concept shown in the same set of game states,
at higher fidelity than the Round 3 mock-ups. All four stay in contention;
do not pick a winner or cut one.

Higher fidelity means:

1. Every screen uses the game's real content: action, upgrade, event and
   staff names, costs and descriptions read from godot/data/ (do not invent
   numbers; if a value is missing in the data, show what the game shows and
   note it). Numbers on screen agree with each other across states.
2. Pip's art and icons from godot/assets/ (backgrounds, events, office floor,
   cats, icons). No person or operator silhouette anywhere. Where a
   needed icon or picture does not exist, draw it in his style and list it
   as "new, needs art".
3. Every state below is drawn, not described, with the same game moment
   carried through so the states read as one story.
4. Finished visual craft: one type scale, aligned grids, consistent spacing,
   no overflow, overlap, clipped text or placeholder text, at 1920x1080 and
   1280x720.

## The states (same list for every concept)

Alex chose six states (2026-11-21); the others wait until Pip or Alex asks.
Carry one run through them: same company, same month numbers. Before any
designer starts, you write fork/design/hifi/run-state.md: the company,
month, money, staff, queued actions, the event and its choices, and the
doom band for each state, taken from the real months 1-6 screenshots in
fork/design/research/ui-pass/game-shots/ and from godot/data/. Every
designer uses that file, so the one-state-across-four-concepts view
compares like with like.

1. First month, first screen a new player sees (month 1, nothing queued).
2. Choosing an action (the action menu or card file open).
3. The month's plan with several actions queued, showing Attention: 12
   planning and 8 operating hours, operating work may spill into planning
   hours, never the reverse, and what is held back for events. (This is
   the rule in ADR-0011's 2026-07-28 amendment, planning_share 0.6. Today's
   UI pre-check refuses the spill; the mock-up follows the ADR. Say so in
   the notes.)
4. WATCH: an event that asks the player to choose, with the month's actions
   visibly progressing behind it.
5. End of month: what happened, before the next PLAN.
6. Late game, high P(Doom): how the office and screen change.

If a concept's structure makes a state not apply, say why in its notes and
draw the nearest equivalent.

## Rules (from AGENTS.md; break none)

- Mock-ups only. Do not edit anything under godot/, scripts/, tools/ or
  docs/. Work only in fork/design/ (new work in fork/design/hifi/).
- The screens must show the game's real rules. Do not invent mechanics or
  show information the game hides: read
  docs/game-design/decisions/ADR-0015 (no printed doom deltas) and ADR-0001
  (spending buys sight) before putting a number on screen. For state 6 read
  docs/art/PALETTE_AND_DOOM_INTENSITY.md ("Doom is a layer, not a
  repaint") before drawing how the office changes.
- ASCII only in .md and .html text you write; no emoji.
- Git: commit to `design/ui-concepts` only and push to origin. Never `git
  add -A` or `git add .`; stage named paths under fork/design/. Never commit
  fork/design/research/reference-games/shots/, diegetic/shots/,
  tutorial-video/transcript.md or concepts/gallery*.png (third-party or
  rebuildable; excluded on this box, but never add them anyway). Commit only
  HTML, notes, small assets and the compressed showcase images; leave the
  full-size PNG renders uncommitted. Run `git pull --rebase` before every
  push (Alex may push the same branch from his PC). Never touch `lean` or `main`,
  never push to upstream, never open a PR. Never run `git sparse-checkout
  disable`.
- Rendering: headless Chromium via Playwright (browsers in
  ~/.cache/ms-playwright). Do not install system packages.
- The box is shared: one Chromium per designer at a time, closed after each
  batch; do not fill /tmp (a 16 GB RAM disk). If ~/.disk-low appears: halt
  renders, delete your own scratch, and report.

## Read first

- fork/design/research/RESUME.md, then concepts/report.md (all rounds).
- Each concept's fork/design/research/concepts/<A|C|E|G>/notes.md and
  concept.html, and its renders.
- .claude/skills/game-ui/, game-tutorial/ and ux-copy/ (this repo's design
  skills), ~/.claude/skills/council/SKILL.md (the review process).
- fork/design/research/council/concepts/r2s-agreed.md and r3x-agreed.md
  (rules the council already agreed: Attention bars filled = hours left;
  only the topmost layer shows Enter/Esc; operational text >= 16px; every
  repeated play has its own edit target).
- Paths in those files point at C:/Users/keech/Documents/pdoom1-lean-setup/
  research/...; read them as fork/design/research/.

## Who does what

- You orchestrate; you do not design. Start one designer per concept
  (Claude Opus 5.5, effort high), each with its concept's history and this
  brief. Each builds fork/design/hifi/<letter>/ (HTML + assets + one PNG per
  state at 1920x1080, and a 1280x720 check of every state).
- Council, low sensitivity, per the council skill: Claude Opus 5.5 (effort
  high), GPT Sol gpt-6.2-sol (reasoningEffort high), Gemini 4 Neon
  (Antigravity, thought_level high). Same delegates every round. If Sol is
  at capacity, retry twice, an hour apart; then carry on with Opus and Neon,
  mark Sol "not available" in the report, and never substitute another
  model.
- Start every delegate on full access (the run is unattended; an approval
  prompt would stall it).
- Every brief you write quotes Alex's words above and asks for a disk
  report (what was written outside the checkout, sizes, what can go).

## Review and finish line

1. Designers build all the states. You look at the renders only to send
   obvious breakage back; judging is the council's.
2. Checkpoint: once state 3 (the month's plan) exists in all four concepts, commit and push
   it (compressed images only) so Alex can check the fidelity early. Do
   not wait for him.
3. Build the showcase: fork/design/hifi/index.html, a page that lets Pip
   flip between the four concepts and the states (a grid view plus a
   one-state-across-four-concepts view). Self-contained, relative paths, no
   external requests except Google Fonts. A neutral dark frame that keeps
   the screens the focus. Images as WebP or JPEG, 1920 wide, about 300 KB
   each; the page and everything it loads under 16 MB. The PC session will
   publish it as a claude.ai page for Pip.
4. One council round on the showcase (all three at once), covering for each
   concept and state: (a) visual-defect pass (also check every state at
   1280x720), (b) real data and rules correct, (c) no person anywhere, the
   office reads as eerie, (d) icons match their buttons and read as one set
   with Pip's, (e) is it clear, faithful to Pip's game and worth his time.
   Answer format per the council skill, with a "showcase-ready" score /10
   per concept (not a ranking; all four stay in contention).
5. Members settle one agreed list; designers apply it; re-check with Opus
   and Sol, then Neon last. One fix round. If anything still blocks after
   it, stop and report it rather than looping.
6. Write fork/design/hifi/report.md: what each concept looks like across
   the states, council results, open questions for Alex and Pip, new art
   needed, bugs and data gaps, and the disk report.

## Open questions to carry, not decide

- The council was split on whether the people in event pictures and Pip's
  Staff (three silhouettes) and Hire (head and shoulders) icons count as
  "the person" Alex wants gone. Until Alex answers, keep Pip's icons, avoid
  new human figures, and list every place a figure appears.
- Which concept goes forward is Alex's and Pip's call.
- Bugs and data gaps found on the way: list them; do not fix the game.

## When done

Commit and push fork/design/hifi/ on `design/ui-concepts`. Reply with: a
short summary, the commit hash, the scores table, the open questions, and a
disk report for the whole run. Delete scratch renders and browser profiles
you no longer need.

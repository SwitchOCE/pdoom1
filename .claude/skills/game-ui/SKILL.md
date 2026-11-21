---
name: game-ui
description: Design, redesign or critique a P(Doom)1 screen, panel or overlay from first principles - what the player must see to make this phase's decisions, what can wait one click away, and what stays hidden on purpose. Use instead of design:design-critique, design:design-system and design:accessibility-review in this repo; use before any UI change in this fork, when asked to review a screen or screenshot, or when briefing an agent to do either. Not for tutorial content (game-tutorial) or wording alone (ux-copy).
---

# Game UI from first principles

Generalised from the owner's Bramble design skills (design-critique,
design-system, accessibility-review) and the owner's notes on clutter and
tutorials; the P(Doom)1 parts are marked. The rules of the game are Pip's:
this skill decides how things are shown, never what the game does (AGENTS.md
section 1).

## The owner's two rules

1. **The main screen serves the hundredth game, not the first.** The owner
   (Bramble, 9 Nov 2026): "When I play chess, there isn't a sign on my knight
   telling me that it can jump over other pieces ... the majority of players
   will only play for the first time once, and then spend hundreds of games
   playing when they already know what things do." And: "The job of a
   tutorial is to tutorialize. Other than that, the player is assumed to know
   how to play the game when they're in the game environment." Permanent
   hints, explainer labels and "click here" text on the main screen are
   clutter. They belong in the tutorial, which removes them when it ends.
2. **Design the UI so it can be taught.** Tutorial work in this fork is
   mostly blocked on the UI. Every element the player must learn needs a
   stable place, a plain name it is called by everywhere, and a way to be
   pointed at (highlighted, dimmed around, revealed when it first matters).
   If a thing cannot be pointed at or named in one short phrase, the tutorial
   cannot teach it.

## Focus each pass

The owner (Bramble, 9 Nov 2026): "Get good at one or two things and then start
fixing other issues. And if you have too many rules, you're going to have
impossible evaluation criteria." Pick the one or two player outcomes a change
targets and judge it on those. The scope rules and constraints below still
apply to every change.

## Method: start from the decision, not the data

Do these in order. Write the result down before drawing anything.

1. **Name the phase and its decisions.** A screen exists to make some
   decisions possible. List them in player words. The lists below are a
   starting point as of 2026-11-21; re-derive them from the live screen and
   code before you rely on them.
   - P(Doom)1, PLAN: which actions to queue this month and in what order;
     which upgrades to buy; the Research Quality setting; how much Attention
     to hold back. Attention is split into planning and operating hours, and
     an action is affordable only if both the total and its hour type allow
     it. Then commit the month.
   - P(Doom)1, WATCH: answer each response window with the options that
     event offers (today they map to handle or ignore; ADR-0012's defer is
     legal only for deferrable events and is not reachable in the v1
     dialog); set the speed; read what happened.
   - P(Doom)1, Month Review: the hand-over from WATCH back to PLAN; what the
     player learns about the month before planning the next.
2. **For each decision, list what the player must know to make it.** Usually:
   what it costs, whether they can afford it (and why not), what it changes
   (in words), and the current state of the thing it changes. Anything not on
   any decision's list is a candidate for a lower tier.
3. **Sort every element into one tier.**
   - **Glance**: always on screen, readable in two seconds without reading a
     sentence. Only what a decision needs this phase, the lose conditions'
     state, and whether each available action can be afforded.
   - **Reach**: one click or keyboard focus away, at the point of use (a
     detail panel beside the queue, a tooltip that also opens on click or
     focus). Never hover only: costs, eligibility and consequences must be
     readable before commit without a mouse hover. Give that information
     without changing what a control's click already does: on PLAN an action
     tile's click queues it, a door tile's opens its submenu, and an upgrade
     button's buys it (`main_ui.gd`). Use keyboard focus, a selection panel
     or a separate info control.
   - **Archive**: the guide, the ledger, the feed history. Found when looked
     for.
   - **Hidden by design**: information the game withholds on purpose (see
     "P(Doom)1 constraints"). Never promote these.
   - **Not yet**: readouts and panels the player only reads and that have no
     state yet (an empty staff roster, a clean ledger). They may appear when
     they first have something to show. Not yet never covers controls: every
     action the game makes available keeps a visible route, and existing
     unlock gates (`GameActions.is_action_unlocked()`) are respected as they
     are.
4. **Count the glance tier.** Fewer is better; there is no magic number, but
   say the count before and after. On 2026-11-21 the PLAN screen showed about
   45-55 separate readouts and controls on turn 1.
5. **Lay it out.** One primary area per phase, where the decision happens,
   with the most space. Then:
   - **Proximity**: gaps inside a group clearly smaller than gaps between
     groups; a control sits next to the thing it acts on.
   - **Framing**: each zone reads as one region by frame or ground.
   - **Alignment**: zones share edges and centre lines.
   - **Stability**: readouts and buttons stay put between months and phases.
     A player learns positions, not labels.
   - **Eye path**: the first stop is this phase's decision; the next action
     (for example Commit, once the plan is ready) is easy to find but not
     first.
6. **Emphasis.** One action accent, kept for what to press next. Semantic
   colours (doom bands, good/bad deltas, warnings) are a coded set, not
   accents, and each has a second cue (icon, shape or word). Depth or glow
   changes only on what is active: hovered, selected, queued, demanding a
   response.
7. **Check it against the constraints below, then critique it.**

When two layouts both pass, make both as screenshots and compare them; do not
argue it in prose. Compare with how similar games lay out the same decision
(the owner asks for direct screenshot comparison with other games).

## Critique: what to check

Judge the screen as played: mid-run with staff, a full queue and an open
window, not only the empty turn-1 state.

1. **First two seconds.** What draws the eye first, and is that right for this
   phase? Is the phase and what to do next obvious?
2. **Usability.** Can every decision in step 1 be made without hunting? Is it
   obvious what is clickable, what is affordable, what is queued, and why an
   action cannot be taken? Any unnecessary step or confirmation?
3. **Hierarchy.** Does the eye path match the method's step 5? One accent?
   Typography: one clear level each for headings, values and prose.
4. **Grouping and stability.** Proximity, framing, alignment; nothing jumps
   on hover (Pip's #577 is a known case).
5. **Consistency.** Same name, icon and colour for the same thing on every
   screen (the top bar, tiles, tooltips, guide and feed).
6. **Teachability.** Could a tutorial point at each element and name it in a
   short phrase? Is anything explained by permanent on-screen text that
   should move to the tutorial?
7. **Accessibility.** Text contrast at least 4.5:1 (3:1 for large text and
   UI shapes); meaning never by colour alone; every action and every piece of
   decision information reachable without a hotkey and without hover; visible
   focus or selection.
8. **What you could not judge.** From a still screenshot write "not judged"
   for motion, hover timing, feel and anything at other resolutions. Never
   pass them. Agents see stills from one resolution; the owner's hands are
   the test for feel.

Feedback is specific ("COMMIT competes with Plan (Enter)", not "confusing"),
says why in terms of the player's decision, proposes a fix, and names what
works.

## P(Doom)1 constraints

Read the source before you rely on a line here; the ADRs and code win.

- **Actions are Pip's.** Hiding, locking or removing the visible route to an
  action the player can use, or re-nesting it (which actions are doors is the
  `is_submenu` key in `godot/data/actions/*.json`), is a proposal for Alex,
  not a UI change. Moving a control on screen while it stays visible and
  reachable is layout. Pip's target of at most 10 top-level doors, and its
  staged rollout, are in `docs/design/UI_ARCHITECTURE_2026-08-06.md` (#1132);
  the target is not permission to reorganise the live actions.
- **No doom numbers on actions or events** (ADR-0015). Doom is computed from
  world state; text may name a visible direction ("raises public alarm"),
  never a doom delta.
- **Spending buys sight** (ADR-0001, ADR-0004). The sight line covers facts as
  well as numbers: a label, tooltip or panel shows only what the player can
  currently know. An undiscovered rival or a hidden cause stays unnamed. The
  coarse doom band and "this is becoming lethal" warnings are free, so lethal
  causes become legible at that threshold. Where the code already shows
  something for free that the ADRs say is earned, flag it to Alex; do not
  change it on your own.
- **Interruptions are scarce.** Events come as ambient < feed < window
  (DESIGN_PHILOSOPHY.md, `scripts/core/event_tiers.gd`). Do not turn feed
  items into interruptions. ADR-0012: the backlog that overflows what the
  player can see is part of the game, not a UI defect to fix with alerts.
- **The game must explain your death before it kills you**, and **Attention
  is the resource the UI must be honest about** (DESIGN_PHILOSOPHY.md). Both
  lose conditions (doom 100%, reputation 0) must be visible.
- **No dead ends, with one exception** (UI_ESCAPE_CONTRACT.md,
  NAVIGATION_AUDIT.md): every overlay closes with Esc and a visible button;
  nothing is hotkey-only; Esc goes back one level; typed text outranks
  shortcuts (P6). The exception: an unanswered event dialog swallows Esc on
  purpose (#452, `modal_stack.gd`). Anything drawn over it (a hint, a lesson)
  closes itself without answering, skipping or closing the event.
- **Pause** (docs/design/PAUSE_SEMANTICS.md): the pause menu's tree pause and
  a response window stopping month playback are different things. While the
  tree is paused, UI fades, pulses and toasts stop; every `create_timer` passes
  its second argument explicitly (AGENTS.md section 2).
- **Type and colour** (godot/UI_STYLE_GUIDE.md, `theme/base_theme.tres`,
  docs/art/PALETTE_AND_DOOM_INTENSITY.md): font sizes come from the theme
  (base size 19; the font test requires body text of at least 18, and
  `menu_theme.tres` declares no font sizes) with no new literal overrides; nothing a player reads to operate a control is below 16,
  and no secondary prose is below 14. Colour encodes state on two axes
  (catastrophe: amber to fire; weirdness: green, blue, violet); doom colours
  come only through ThemeManager. Numbers per docs/NUMBER_FORMATS.md. ASCII
  only, no emoji.
- **The office floor only renders state** (ADR-0018).
- **"Turn" is two things today.** To the player a turn is a month (the planning
  period), but the HUD's "Turn N" shows `GameState.turn`, which counts
  workdays (`game_state.gd`, `main_ui.gd` date formatter). Say "month" in new
  text; flag the HUD label to Alex as a display bug; check any code gate
  written as `turn < N`.

## Showing a UI change

- Before and after screenshots at 1920x1080 from the running game (`[` in
  game), in the same game state. For a new layout, mock it first and get
  Alex's reaction before building.
- A layout mock-up shows two views of the same screen: the first-month view
  with its tutorial cue, and the returning player's view with the cue gone.
  Every available action is reachable in both.
- Say the glance-tier count before and after.
- Reactions from Alex set what to iterate on; they are directions, not
  verdicts. Do not drop a layout on the first negative reaction; show what
  it teaches or a version that answers the reaction.

## Output for a critique

```markdown
## Critique: [screen, phase, game state]

Decisions this phase: [list]
Targeted outcomes: [the one or two this pass is about]
Glance tier: [count] items -- [too many / right]

| # | Finding | Severity (blocks play / slows play / polish) | Fix |
|---|---------|----------------------------------------------|-----|

Not judged from stills: [motion, hover, feel, other resolutions]
What works: [1-3 lines]
Top 3 changes: [most impactful first, each with why]
```

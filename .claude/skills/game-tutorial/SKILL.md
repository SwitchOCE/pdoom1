---
name: game-tutorial
description: Plan, build or review how P(Doom)1 teaches itself - the cold open, first-run hints, the advisor and nudges, just-in-time explanations, tooltips and the Player Guide. Use before any tutorial change in this fork, when reviewing a first-run experience, or when briefing an agent to do either. Pair with game-ui (the screen must be teachable first) and ux-copy (the words).
---

# Teaching a complex game

Built from two sources:
- the method in Game Maker's Toolkit, "Can we Improve Tutorials for Complex
  Games?" (Mark Brown, 2021, https://www.youtube.com/watch?v=-GV814cWiAw),
  which Alex named as the template. Transcript and findings, with timestamps
  and what is on screen: `C:/Users/keech/Documents/pdoom1-lean-setup/research/tutorial-video/`
  (findings F1-F17 cited below);
- the owner's Bramble notes on clutter and tutorials (9 Nov 2026).

## The owner's rule

The tutorial teaches; the game does not. The owner: "The job of a tutorial is
to tutorialize. Other than that, the player is assumed to know how to play the
game when they're in the game environment." Every teaching element on the main
screen is temporary: it appears for a learning player, and is gone (not just
faded) once the lesson is learned or the player opts out. A lesson once
completed or dismissed never comes back on its own, and a player who turns
hints off sees no automatic lessons in any run. A player with hints on may
still meet a new lesson on a later run, when it first becomes relevant (see
method 6). Help on demand (the guide, tooltips) is always there. And:
"Animations should, by player feel, capture how a game is and how it plays" -
show, don't label.

Focus each pass: pick the one or two bars below that a change targets and
judge it on those ("if you have too many rules, you're going to have
impossible evaluation criteria", owner, 9 Nov 2026). Scope rules apply to
every change.

## Methods

1. **Split the tutorial up; teach inside real play** (F1). No upfront block of
   lessons. Short lessons sit between stretches of the real game, each one
   when it is needed.
2. **Teach no faster than the player's willingness to learn grows** (F2). It
   starts low and rises with time invested. The first minutes carry the least
   teaching; the depth comes later.
3. **Just in time** (F3). Explain a thing at the moment the player first meets
   it (first response window, first hire, first time compute runs low), not
   at game start. A lesson triggered by game state the player reached beats a
   lesson on a timer.
4. **An inverted pyramid of decisions** (F4). The first month should feel like
   one clear decision, the next like two, and so on. Get there by what you
   point at and what you leave quiet. Every action the game makes available
   stays visible and reachable; narrowing the actual choices is a rules
   change (see "Scope").
5. **Reveal readouts as they matter** (F5). Ask, for each readout and panel the
   player only reads: does it need to be on screen in the first month? One
   with nothing to show yet can appear when it first does. The video urges
   designers to be "even more aggressive" here than Total War. Controls are
   not hidden this way (see game-ui, "Not yet").
6. **Teach in tiers, across runs** (F6, F7). Basics first, then send the
   player into real play; advanced and strategy lessons come after they have
   used the basics, on a later month or a later run, and can be found again.
   P(Doom)1 is played as repeated runs, so deeper lessons can wait for run 2
   or 3 instead of crowding run 1. A stripped-back beginner mode that turns
   systems off (F7) or a shorter game pace (F9: the video's Civ "Quick"
   setting, which shortens in-game task durations) changes the rules: a
   proposal for Alex, not a tutorial change. WATCH's playback speed buttons
   already exist and are not this.
7. **Goals, not click-here** (F8). Do not walk the player through a chain of
   "click this" steps: "As far as the game is concerned I have advanced. But
   as far as my brain is concerned I've learned nothing" (Asher Vollmer).
   State the rule or the goal ("Hire someone who can do research") and let
   the player find the control. A guided first step, then an unguided goal on
   the same idea, is the Planet Zoo pattern.
8. **Teach why, not only how; close slow feedback loops** (F9). Strategy
   mistakes surface hours later. A reactive advisor that comments on what the
   player just did, with praise and with warnings ("We aren't a charity!"),
   teaches why. In P(Doom)1 such lines name only causes and directions the
   player can currently see: never a doom number (ADR-0015), never an
   unearned fact (ADR-0001, ADR-0004).
9. **Lean on what players already know** (F10, F11). Real-world meanings
   (money, staff, a phone, a ledger) and everyday app conventions (sortable
   tables, red/green status, filters, feeds) need no lesson.
10. **Never assume genre knowledge; playtest the tutorial, a lot** (F12). An
    hourglass End Turn button read as a loading spinner; "one player spent
    40 minutes on the first turn, unsure how to move on". "Don't assume your
    audience has played other games. And two: play test your tutorials.
    Like, a lot." Unlabelled icons are a tutorial problem.
11. **Show, don't tell** (F13). A short animation or an annotated picture
    beats a paragraph: "showing that little animation of them moving is a
    thousand times more effective" (Justin Ma, Into the Breach).
12. **When text is needed, cut it** (F14). Few words, consistent terms, no
    jargon. Use the ux-copy skill.
13. **Self-help inside the game** (F15). "If someone gets stuck you don't want
    their only solution to be Google." Tooltips that explain terms inside
    other tooltips, a searchable guide, and a way to see a lesson again, all
    reachable during play.
14. **More than one way in** (F16). A new and a returning player want
    different amounts of help; ask once, or let the player skip and come
    back. A guided track and a learn-by-trying track can sit side by side.
15. **The tutorial is part of the product** (F17), not an afterthought.

## Bars a P(Doom)1 tutorial change is checked against

The video reports failures (a player stuck 40 minutes on a first turn; the
narrator zoning out 20 minutes into a tutorial); the bars below are this
skill's P(Doom)1 targets derived from them, not the video's own numbers.
Agents cannot pass the human ones (see "What agents can't judge"); say
"not judged" for those.

- **First month**: a new player, with no outside help, commits their first
  month and can say in a sentence why they queued what they did, or why they
  held Attention back.
- **Learned, not followed**: after a guided step, the player makes the same
  kind of choice again later without help.
- **One decision first**: the first-month screen points at one decision; the
  rest is quiet, while every available action stays reachable.
- **No click-here chains**: each lesson line states a goal or a rule, not a
  sequence of clicks.
- **Just in time**: each lesson is triggered by the state it explains.
- **Shown, not walled**: no lesson is a wall of text where a picture, a
  highlight or the game itself could show it.
- **No Google**: every rule the player needs is reachable in game, during a
  run. (Today the Player Guide opens only from the main menu.)
- **Gone when learned**: completed or dismissed lessons stay gone across
  runs; with hints off, no automatic lesson appears in any run; the main
  screen carries no permanent teaching text. Lessons not yet met may still
  appear, with hints on, when they become relevant.
- **Never trapped**: every lesson closes with Esc and a visible button, and
  skipping is never a punishment (UI_ESCAPE_CONTRACT.md). A lesson shown over
  an unanswered event dialog closes itself without answering or closing the
  event, which swallows Esc on purpose (#452). The cold open fails this bar
  today (no Esc handler): treat it as a bug to fix, not a model to copy.
- **Acting soon**: no long stretch of reading-only teaching; the player is
  acting within moments of each lesson.

## The tutorial mode (Alex, 21 Nov 2026)

Alex: "In terms of changing the mechanics and hiding the buttons, like what
would be required, that can be a tutorial. It's a separate gameplay thing.
We're not going to change the main gameplay loop. We are going to develop a
tutorial that teaches people how these things work. It will be a separate
gameplay mode. But that will still come after the UI redesign."

- The tutorial will be its own mode, separate from a normal run. Inside that
  mode, lessons may hide buttons, restrict actions, script events and change
  what happens, as the lessons need.
- A normal run must be untouched: with the same seed and inputs, a normal run
  plays out exactly as before (AGENTS.md section 1). Tutorial-mode code may
  not draw from the normal run's RNG or change its state.
- The mode comes after the UI redesign. Do not start it before Alex says so.
- The rest of this skill applies inside the mode too: goals not click-here,
  just in time, show don't tell, nothing hidden that the ADRs say is earned.

## Scope: what this fork may and may not do

Outside the tutorial mode, this fork changes presentation and teaching, never
the rules (AGENTS.md section 1; apply its same-seed test).

- **Allowed**: when and how text, highlights, advisor lines, overlays and
  readouts appear; which elements are pointed at; what is revealed to the eye
  first; the Player Guide's content and where it opens from; tooltips.
- **Stop and ask Alex**: anything in a normal run that changes what the player
  can do or what happens - hiding, locking or re-nesting actions in early
  months, a beginner
  mode that turns systems off, shorter in-game task durations, a forced first
  turn, a tutorial that changes starting resources, or any tutorial code that
  draws a random number or writes game state. These are Pip's calls; bring them as
  proposals.
- **Hidden on purpose stays hidden** (ADR-0001, ADR-0004, ADR-0015): no lesson,
  advisor line, example or guide text reveals a number or a fact the player
  has not earned the sight of. Lethal causes become legible at the free
  becoming-lethal warning.
- **Goal text follows ADR-0002**: you cannot win, only buy time; survival is
  the score.
- **Timing follows PAUSE_SEMANTICS.md**: lesson fades, pulses and toasts stop
  while the pause menu is open; every `create_timer` passes its second
  argument explicitly.
- Pip's own design for the advisor and milestone popups
  (`docs/game-design/ONBOARDING_STORY_DESIGN.md`) recommends a nudge plus glow
  and rejects a forced first turn. The nudge plus glow and the intro version
  gate (`last_seen_intro_version`) are built and can be reused; its advisor
  queue and milestone hooks are proposed patterns (pseudocode), not code.
  Build on them and say where you depart from them. Do not reuse its example
  copy: lines like "drive doom toward 0%" and "hire a researcher -> lowers
  doom" predate ADR-0002 and ADR-0015. Check any effect a lesson names against the live action.

## P(Doom)1's teaching surfaces today (2026-11-21)

Check the code before relying on this list.
- Welcome overlay (first launch): three lines and a link to the Player Guide.
- Cold open (`cold_open_sequence.gd`): lore beats and a phone; ends by
  pointing the player at scouting. Has no Esc handler.
- First-lever nudge and getting-started hint (`main_ui.gd`): one pulsing tile
  and a static line. Gated on `turn < 3`, but `turn` counts workdays, so it
  likely vanishes after the first month: check before building on it. The
  fallback hint ("hire a researcher to lower it") uses the stale doom
  framing above.
- Player Guide (`player_guide.gd`): static text, reachable only from the main
  menu.
- Tooltips on top-bar resources and the info bar on tile hover.
- No advisor, milestone popups or just-in-time lessons are built yet.

## What agents can't judge

Agents see still screenshots and read code. They do not get bored, confused or
impatient, and they already know the rules. An agent play-through finds broken
flows, wrong text and dead ends; it is not evidence that a lesson teaches.
Whether a new player learns is judged by a person playing: Alex, or a
playtester Alex arranges, ideally including someone new to strategy games. Say
so in every report.

## Showing a tutorial change

- The trigger (what state starts the lesson), what the player sees, the
  lesson's goal in one line, and how it ends and is dismissed.
- Screenshots of each step in the running game, and of the main screen after
  the lesson is gone.
- Which one or two bars it targets, and which bars were "not judged".

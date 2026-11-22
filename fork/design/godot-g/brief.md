# Godot build spec for G: brief for the orchestrator (Optiplex)

Written 2026-11-22 by Alex's PC session. You run on the Optiplex in
/home/alex/code/pdoom1, branch `design/ui-concepts`. Read AGENTS.md (the
fork's rules) first. This run writes a spec and a prompt. It does NOT
change the game: nothing under godot/ is edited or committed.

## Alex's words (verbatim; quote them in every brief you write)

> "Okay, I think every single one of these designs is excellent. I'd be
> happy with any of them. Which one is the closest to be ready for a test
> build in Godot?"
> "Sorry, I misspoke. I mean G. G's are the easiest"
> "Okay, can we get a clean spec that everyone agrees will work inside of
> Godot, acknowledging Godot's differences to HTML and et cetera, and any
> complications that come with transition states and animations, or your
> desire for shaders, or the animation elements, or sound elements that are
> supposed to be part of the diegetic aspect. Built as a build spec and a
> prompt for an orchestrator to begin work on that spec."

His answers to the setup questions:

> Scope: "G with all upgrades is the final scope is that it can be phased
> into sub-phases by the orchestrator if they choose"
> Rules: "we can keep whatever works currently in the game if it's going
> to cause the engine to crash because the written rules contradict the
> code, then yeah, we need to follow the current stuff"
> Art: "Have Sol generate art following any guidelines Pip has for art
> creation in the past and matching the rest of the visual style And look
> at the Bramble repo for the kind of guidelines as to how to prompt Sol to
> get good artwork out of it. Too specific tends to lead it to create bland
> stuff that is nonsensical"
> Where: the Optiplex, stopping at the spec and the prompt.

## What G is, and "all upgrades"

- **G** = "The Existing UI, Modernised": today's layout kept (resource bar,
  PLAN banner, doom ring, queue) with menus on a left rail, in the darker
  look. Latest version: fork/design/hifi3/G/ (concept.html, notes.md, six
  renders). Its node-by-node mapping onto today's scene is in
  fork/design/hifi/G/notes.md.
- **The upgrades** are what design H got in the last round and G did not
  (fork/design/hifi3/report.md, "The addendum round"; spec.md sections
  1.3, 2.4, 3.2, 3.3, 6.4):
  1. hierarchy (P(Doom) first, then Attention left and money, then the
     plan; the rest recedes, text still >= 4.5:1);
  2. the room's colour by doom band (never by month; the lowest band a
     little brighter; a layer, not a repaint);
  3. resources as tier icons (five tiers plus zero-or-below, fixed
     thresholds, the number beside the icon), reputation drawn once with
     "0 ends the run";
  4. the typewriter dateline with its sound, in place of today's turn
     label;
  5. the trace-window take. It needs month-start history the game does not
     record today. Include it only if it can be done without touching
     game state or anything under scripts/core/ (for example history kept
     in the UI layer from values the UI already sees; say that such
     history starts empty when a save is loaded). Otherwise the spec marks
     it "not in this build" and says why.
- The final scope is G with all of these. The spec may split it into
  phases and sub-phases; the build orchestrator may split further.

## Rules for the spec

- **Mechanics unchanged.** AGENTS.md section 1: with the same seed and
  inputs a run must play out the same. Where the mock-ups follow Pip's
  written rules but the code behaves differently (the Attention spill
  pre-check, Reserve when operating hours run out), the build follows the
  code as it is today, and the UI shows what the game actually allows.
  List each such place.
- **Pure UI paths:** godot/scripts/ui/, godot/scenes/, godot/theme/,
  godot/assets/. Anything outside them needs a reason; anything in
  scripts/core/ or data/ is out unless it is a named bug fix Alex approves.
- **Pip's CI rules** (AGENTS.md section 2): font sizes only from
  theme/base_theme.tres and ThemeManager.get_font_size(), no literal
  sizes; every create_timer passes process_always explicitly; ASCII only;
  no emoji; scene changes only through SceneTransition. Presentation
  randomness (key-strike variation) must never touch the game's RNG
  (state.rng): use a local RandomNumberGenerator.
- **The A/B switch.** Build behind the existing layout switch
  (godot/scripts/ui/layout_controller.gd, "classic"/"proposed", F9 in
  debug builds) so the old UI stays one key away. Check how it works
  today and spec against it.

## What the spec must answer: HTML versus Godot

For every part of G-with-upgrades, say how it is built in Godot 4.5.1 and
what differs from the HTML mock-up. At least:

- **Layout:** Control nodes, containers and anchors under the project's
  stretch settings (canvas_items, aspect expand, 1920x1080); what happens
  at 1280x720 and at wider screens; which mock-up CSS tricks have no direct
  equal (absolute positioning, CSS filters, blend modes, gradients,
  inner shadows) and what replaces each (StyleBoxFlat, StyleBoxTexture /
  NinePatchRect, TextureRect, custom _draw, shaders).
- **Type:** the faces the mock-up uses are not bundled; which fonts to add
  (licence), how they are imported, and how sizes map to ThemeManager's
  steps (the hifi3 spec found small = 15 vs a 16 px floor and no 22 step).
- **Shaders:** the room's doom-band layer, film grain, grime and vignette.
  Which are CanvasItem shaders, which renderer the project uses and
  whether the shaders compile in it, their cost per frame, and a fallback
  when shaders are off or slow. Keep the shader count small.
- **Animation and transitions:** the dateline type-on, opening and closing
  menus and sheets, PLAN to WATCH and back, the month review, the room
  stepping between doom bands, the P(Doom) arc and band ladder changing.
  Tween or AnimationPlayer, durations, what happens if the player acts
  mid-animation (skip, queue, ignore), interaction with pause
  (docs/design/PAUSE_SEMANTICS.md), the Esc contract
  (UI_ESCAPE_CONTRACT.md, modal_stack.gd, esc_to_close.gd) and #452 (event
  dialogs swallow Esc). Reduced motion: the game has no such setting, and
  settings persist through game_config, a gameplay autoload that is "bug
  fixes only" (AGENTS.md). So either keep reduced motion inside the UI
  layer or list the game_config change as a question for Alex.
- **Sound:** the typewriter strike as WAV one-shots on the SFX bus
  (default_bus_layout.tres bus 1; game_config SFX volume), variation via
  AudioStreamRandomizer or a local RNG, sync of letters to strikes, never
  two datelines at once, never in-month. The source is H's synthesised
  render (fork/design/hifi3/H/dateline-sound.wav and the TypeSound code in
  H/concept.html); the spec says how the one-shots are cut or rendered.
- **Data binding:** for each element, which game signal or value drives
  it, read-only (main_ui.gd and the seam map docs/MAIN_UI_SEAM_MAP.md;
  game_manager signals). No new information the game hides (ADR-0001,
  ADR-0015).
- **Keys:** which shortcut keys are new, which clash with today's
  (autoload/keybind_manager.gd), and the proposal.
- **Tests and checks per phase:** the fast gate, check_no_emoji,
  check_scene_nav, the scope tripwire, before/after screenshots from the
  real game.

## Prove the risky parts in Godot

"Everyone agrees will work inside of Godot" needs evidence, not opinion.
Before the council reviews, build tiny spikes that prove the risky parts
run in Godot 4.5.1 on this box (headless or under xvfb-run; check the
installed Godot version first and say if it is not 4.5.1):

- the doom-band layer shader and grain over the office art, at 1920x1080.
  project.godot sets no renderer, so the game uses Godot's default
  (Forward+, Vulkan). Under xvfb on this box it may fall back to a software
  rasteriser or fail, and --headless gives no pixels. Report which
  renderer and GPU you actually got; treat any frame time as proof that it
  compiles and runs, not as its real cost, and say what would need
  checking on Alex's PC;
- a bundled font imported and sized through the theme and
  ThemeManager.get_font_size();
- the dateline type-on with the sound one-shots in sync (log the letter
  and strike timings; no video needed).

The rest (StyleBox/NinePatch grime, Tween menus with Esc mid-animation)
is routine Godot: the spec describes it without a spike.

Spikes live outside the game: a throwaway Godot project under
fork/design/godot-g/spikes/ (copying the few assets it needs), or in
/tmp. Never edit godot/. Commit only small source files and a few
screenshots; leave builds and videos uncommitted and report their size.
Set APPDATA/XDG paths so a headless run never writes to the real player
profile (AGENTS.md section 4 explains the Windows case; on Linux use a
throwaway HOME or XDG_DATA_HOME for Godot runs).

## Art: Sol makes it

Alex wants Sol (Codex, gpt-6.2-sol, reasoningEffort high, its built-in
image tool) to make the art the build needs. In this run, write the art
plan and prove the method with one small trial batch; the full set is
made during the build.

- **Pip's guidance:** docs/art/PALETTE_AND_DOOM_INTENSITY.md,
  godot/assets/ASSETS_README.md, and the look of his existing icons and
  office art in godot/assets/. Match them.
- **How to prompt Sol, from the Bramble repo** (read
  /home/alex/code/Bramble/docs/design/art-direction/card-art-recipe.md and
  /home/alex/code/Bramble/tools/art/prompts/glass-art-window.txt; if the
  Bramble checkout on this box lacks them, `git -C /home/alex/code/Bramble
  show origin/main:<path>`). The lessons: a loose prompt beats rule-heavy
  ones ("Codex followed them literally and the pictures came out flat");
  a fixed header, two short paragraphs ("Look:" and "The design"), then
  numbered `filename -- description` items; a shape or size guide may be
  attached, but never a finished picture as a style reference (it locks
  whatever is in it); run a batch two or three times and choose; work in a
  folder outside the repo (/data/pdoom1-art/ on this box); the worker is
  told by path where the guide is and that it must not run git.
- **The art list:** the 25 resource tier icons (drafts in
  fork/design/hifi3/H/assets/tiers/ show the intent), the room layers per
  doom band (window sky, monitor glow, grime, smoke and fire light for the
  top bands), panel grime textures, and the five placeholder icons
  (in-tray, feed, advertise a role, travel, publicity). Say for each
  whether it is a picture (Sol), a shader, or a texture, and its size and
  format for Godot import.
- **The trial (small):** one batch of the money tiers only (5 icons), run
  twice, saved under /data/pdoom1-art/trial-*/. No room layers: they may
  end up as shaders. Put a small
  contact sheet of the results in fork/design/godot-g/art-trial.png
  (committed, under 1 MB); the full images stay uncommitted. The
  council judges whether the method gives art that belongs beside Pip's.

## Deliverables

1. fork/design/godot-g/spec.md, the build spec: what G-with-upgrades is
   (paraphrase Alex, do not paste his dictation), the phases, and for each
   part the Godot build, data binding, states and transitions, sound, art
   and tests, per the sections above; the list of places where the build
   follows today's code instead of the ADR; open questions for Alex or
   Pip, each one plain sentence with what happens if nobody decides.
   Reuse fork/design/hifi3/spec.md (H) wherever it applies to G; say where
   G differs.
2. fork/design/godot-g/build-prompt.md, the prompt for the build
   orchestrator: self-contained, quoting Alex's words, pointing at
   spec.md, and covering the fork's change process (AGENTS.md sections
   1, 5, 6, 7: one ui/<slug> branch per phase from lean, squash into lean
   with the right Ladder-Impact declaration, the fast gate, checks,
   tripwire, before/after screenshots, a fresh scope reviewer per phase,
   never a PR to Pip), Alex's orchestration rules (no merge without the
   runtime gate and a scope-reviewer pass with no cut or ask items; every
   few phases say whether the original problem is fixed; every worker
   brief asks for a disk report), where it runs (this box, worktrees under
   ~/code/, Godot under xvfb), how the art batches are run (the method
   above), and a line telling workers to mark any background command they
   wait on with t3_background_wait before ending a turn. It must not start
   any work by itself; Alex approves it first.
3. fork/design/godot-g/spikes/ (small sources and screenshots) and
   art-trial.png.
4. fork/design/godot-g/report.md, summary first: what the spec covers,
   what the spikes proved (with numbers), the art trial result, council
   results, open questions, disk.

## Who does what

- You orchestrate. Delegate the spec writing to one Claude Opus 5.5
  writer (effort high); the spikes to a Codex gpt-6.2-sol worker or the
  writer, your call; the art trial to a Codex gpt-6.2-sol worker with its
  image tool. Every brief quotes Alex's words and asks for a disk report.
- Council, low sensitivity, per ~/.claude/skills/council/SKILL.md: Claude
  Opus 5.5 (effort high), GPT Sol gpt-6.2-sol (reasoningEffort high),
  Gemini 4 Neon (Antigravity, thought_level high). Neon's last run on this
  box ended with a Google sign-in error (401); Alex is signing it in
  again. If Neon still fails, retry once later; if it still fails, carry on
  with Opus and Sol, mark Neon "not available" in the report, and never
  substitute another model. If Sol is at capacity, retry twice an hour
  apart, then the same. Start every delegate on full access.
- The council's question: "Will this spec work in Godot 4.5.1 as written,
  and is it complete enough that a build orchestrator can start without
  guessing?" Each member reads the spec, the spikes and the trial art, and
  checks claims against the code. VERDICT line, blocking items with
  evidence and fix, at most 3 notes, score /10. Members settle one agreed
  list; the writer applies it; re-check with Opus and Sol, then Neon last.
  At most two fix rounds; then stop and report what still blocks.
- Git: commit only under fork/design/godot-g/ on design/ui-concepts;
  `git pull --rebase` before every push; never `git add -A` or `.`; never
  touch lean, main or upstream; never `git sparse-checkout disable`.
- Unattended: Alex's PC may be off. Do not wait on it. Put the summary at
  the top of report.md, push, and reply with: a short summary, the commit
  hash, council results, open questions in plain sentences, and a disk
  report. Delete scratch builds, videos and browser or Godot profiles you
  no longer need.

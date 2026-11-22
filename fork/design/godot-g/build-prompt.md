# Build prompt: G with all upgrades, in Godot

Status: draft for Alex to approve. **Do not start any work from this file
until Alex has approved it in his own words in the thread that runs it.** If
you are an agent reading this without that approval, stop and say so.

---

You are the build orchestrator for UI design G with all of H's upgrades, in
Alex's fork of P(Doom)1. You plan the work, brief workers, check their
results and merge. You do not write the feature code yourself, except small
review fixes.

## 1. What Alex asked for (his words, verbatim)

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

The goal, in one line: **a G test build Alex can play, made from `lean`,
with the old UI one switch away and every run playing out exactly as it does
today.**

## 2. What to read first

**Design inputs come from one pinned commit, read-only (A8).** `lean` does not
carry `fork/design/godot-g/` or `fork/design/hifi3/`, so a worktree cut from
`lean` does not have them. The pin is the `design/ui-concepts` commit that
holds the approved spec: `PIN=5e540c1c`.
Make one read-only copy for everyone:
`git worktree add --detach ~/code/pdoom1-design-$PIN $PIN`, then
`chmod -R a-w ~/code/pdoom1-design-$PIN/fork`. Every brief points workers at
files in that copy (or at `git show $PIN:<path>`). Nobody edits it; if the
spec must change, Alex approves a new pin.

1. `fork/design/godot-g/spec.md`: the build spec. It is the plan. Section 12
   gives the phases and sub-phases; you may merge or split them (Alex's scope
   line above). Section 10 lists where the build follows today's code instead
   of the ADR or the mock-up; section 15 the open questions with their
   defaults; section 16 what is out.
2. `AGENTS.md` in full, especially sections 1, 5, 6 and 7. It overrides
   anything here it disagrees with, except the Linux commands in section 4
   below (AGENTS.md section 4 is written for Alex's Windows PC).
3. `.claude/CLAUDE.md` (project) and Alex's global `~/.claude/CLAUDE.md`
   "Orchestrating and reviewing delegated work".
4. The sources spec.md cites when a sub-phase touches them: `fork/design/hifi3/G/`
   (the G mock-up and renders), `fork/design/hifi3/spec.md` (H),
   `docs/MAIN_UI_SEAM_MAP.md` before any `main_ui.gd` edit.

Open questions (spec.md section 15): build with each one's stated default
unless Alex has answered it. Never stop the run to wait on one; list them in
each report.

## 3. The change process (AGENTS.md sections 1, 5, 6, 7)

Per sub-phase:

1. **Branch.** One `ui/g-<slug>` branch per sub-phase, cut from `lean`, in its
   own worktree under `~/code/` (for example
   `git worktree add -b ui/g-switch ~/code/pdoom1-g-switch lean`). Never commit
   to `main`. Never `git add -A` or `git add .`; stage only the files meant to
   change (Godot rewrites `.import` and `.uid` files). Never stage, stash,
   restore or check out `.claude/settings.local.json`.
2. **Scope.** Mechanics unchanged: with the same seed and inputs, a run plays
   out exactly as today. No edits in `godot/scripts/core/`, `godot/data/`
   (except provenance records, and only with Alex's approval, section 6) or the gameplay autoloads. No new
   doom numbers on screen (ADR-0015, ADR-0001). If a worker finds the plan
   needs a mechanics change, stop that sub-phase and tell Alex.
3. **Fork files stay off change branches (A8).** Fork tools
   (`fork/design/godot-g/tools/*`: `contrast_godot.py`, `cut_icons.py`, the
   copied `synthesize.py`) and the fork provenance file
   (`fork/design/godot-g/provenance.json`) are never committed on a `ui/g-*`
   branch. Commit them as separate fork commits on `lean` (like backlog
   commits) or on `design/ui-concepts`. A `ui/g-*` squash that lists any
   `fork/`, `AGENTS.md` or `.claude/` file is a cut item.
4. **Upstream rules.** ASCII only in `.gd`, `.json`, `.md`, no emoji anywhere;
   scene changes only through `SceneTransition`; font sizes only through
   `base_theme.tres` and `ThemeManager.get_font_size()`; every
   `create_timer(...)` passes `process_always` explicitly.
5. **Runtime gate** (spec.md 12.1), all on the branch, everything committed:
   - fast gate `python scripts/run_godot_tests.py --quick --ci-mode --min-tests 300`
     exits 0 (2 = did not complete: never a pass);
   - `python scripts/check_no_emoji.py`, `python tools/check_scene_nav.py`;
   - Pip's hidden font-size and pause-timer guards, run against the real
     worktree with the copy-and-link method in spec.md 12.1 item 3, plus
     `check_pause_timers.py --self-test`. A copy run from anywhere else scans
     the wrong tree and "passes" on zero files: never accept that;
   - the scope tripwire `python tools/check_ladder_bump.py --base lean --head HEAD`;
     every listed file must be one spec.md 2.5 names as presentation-only;
   - the same-seed fixture (spec.md 12.1 item 5) matches between classic and
     g: one fresh isolated Godot process per layout, with seed `g-parity-1`
     written into that profile's config before `main.tscn` loads and asserted
     on the state before queueing (never a second `start_new_game`); three
     accepted plays (through the action slots in 1a, through the Scouting
     door from 1b); an enabled event choice; the review and the next month
     reached in both runs;
   - before (classic) and after (G) screenshots from the real game at
     1920x1080 and 1280x720 for the states the sub-phase touches, and the
     contrast check on the G shots. Say in the report that this box renders
     on the CPU (spec.md 13.1). Screenshots and any spike rerun output go to
     scratch under `/data/pdoom1-g/`, never into tracked folders (spec.md 13);
   - in every phase that adds media: the provenance audit (spec.md 11.5).
6. **Scope review.** Spawn the `scope-reviewer` agent on the sub-phase's
   commit range. Its brief: Alex's words from section 1 above, quoted, plus
   AGENTS.md section 1 and the spec.md sections the sub-phase builds, as the
   plan. Never review a sub-phase in your own context. Pass your worker
   briefs to it only as labelled proposals.
7. **Merge only if** the runtime gate passed and the scope review has no cut
   or ask items and says the step moves the goal. Otherwise stop and bring
   Alex its cut and ask items, one line each.
8. **Squash** into `lean` as ONE commit: the problem line, `Refs #N` if any,
   and the declaration. For G sub-phases that touch only UI paths: no line. If
   the tripwire listed the presentation-only autoload edits (keybinds, the
   font step), or `data/asset_provenance.json` with Alex's approval (section 6):
   `Ladder-Impact: none -- presentation only: <what>; no run outcome changes`.
   Never a `Ladder-Impact:` line on the branch's own commits. Never edit
   `ladder_version.txt`. If the pre-squash tripwire listed files or the squash
   needed a conflict fixed, run
   `python tools/check_ladder_bump.py --base <squash>~1 --head <squash>`; it
   must exit 0.
9. **Backlog.** Update `fork/BACKLOG.md` on `lean` in a separate commit.
10. **Clean up.** Delete the merged branch and its worktree once pushed.
11. **Never open a PR to Pip's repo** (`PipFoweraker/pdoom1`). Pushing `lean`
    and branches to Alex's fork (`origin`) is fine.

## 4. Where it runs

- This box, the Optiplex (Linux). Worktrees under `~/code/`. Temp files, logs
  and big output on `/data` (for example `/data/pdoom1-g/`), never `/tmp` or
  the home disk; set `TMPDIR` for every command that writes temp files.
- Godot 4.5.1, the official binary:
  `/data/godot-4.5.1/Godot_v4.5.1-stable_linux.x86_64`. Point `PDOOM1_GODOT`
  and `GODOT_BIN` at it. The box's own `godot` is 4.7.2: never use it.
- Godot needs a display here: run it under `xvfb-run`. A bare
  `godot --headless` writes into the real player profile, so give every
  direct Godot run its own `XDG_DATA_HOME` / `HOME` under `/data` (the spikes'
  `fork/design/godot-g/spikes/run.sh` shows how); the test runner isolates
  itself.
- Before launching the game run the class-cache check
  (`python tools/check_class_cache.py --repair` with an isolated profile).
- Run the fast gate, builds and anything over a minute in the background with
  a hard time limit about twice the normal runtime; read only the tail.
- Alex playtests builds made from `lean` on his Windows PC. Phase 3 (the room)
  and phase 4 (the sound) each need one check on that PC (spec.md 5.14, 7.2):
  ask Alex for it in the phase report; do not block later phases on it.

## 5. Workers

- Brief each worker like a peer: the sub-phase's spec.md sections, its branch
  and worktree path, the runtime gate it must pass, Alex's words from section
  1 quoted, and AGENTS.md section 1.
- **Every worker brief asks for a disk report:** what it wrote outside its
  checkout, each with its size, and what can go. A worker without one is not
  done. Workers never delete anything outside their checkout; they list it,
  and you delete it after the step is merged or replaced and anything worth
  keeping is pushed. A Codex `rm -rf` outside its checkout waits for Alex's
  approval: avoid it.
- **Every worker brief includes this line:** "If you start a background
  command and wait on it, mark it with t3_background_wait before ending a
  turn."
- Read the `codex-workers` skill before starting any Codex worker.
- While any worker runs, keep `timeout 7100 ~/.local/bin/t3-approval-watch.py`
  running in the background and restart it whenever it ends. If it names a
  worker waiting over a minute, act on it (cancel and do the step yourself if
  you may, otherwise tell Alex at once). "WATCH BROKEN" means the watch has
  stopped working, not that all is clear: say so.

## 6. Art batches (the Bramble method, spec.md section 11)

- Sol makes the pictures: a Codex worker on `gpt-6.2-sol`, `reasoningEffort`
  high, started with T3 `delegate_task`.
- Template: `fork/design/godot-g/art-trial-prompt.txt`. Each batch copies it
  and changes only the subject sentence, the "The design" paragraph where the
  set needs it, and the numbered `filename -- description` items (spec.md
  11.2-11.3). Keep it loose: no style rules, no finished picture as a
  reference. A shape or size guide only.
- Each run's task text starts with three lines: the working folder
  (`/data/pdoom1-art/<batch>-run<k>/`, outside the repo), the guide file if
  any, and "Do not run git or commit anything. Do not change any file in the
  repo."
- Run each batch two or three times into separate folders; make a contact
  sheet; pick per item against spec.md 11.4; post-process with the script in
  `fork/design/godot-g/tools/`; copy only the picked files into
  `godot/assets/` at the sizes in spec.md 11.2; add a provenance record for
  each (spec.md 11.5).
- Smoke and paper are not square objects: use their own recipes
  (spec.md 11.2a). Generate the action icons on a transparent background.
- Judge every batch at 32 and 40 px on the G plate beside Pip's rail and
  resource icons (spec.md 11.1); whether the set belongs is Alex's call.
- Script-made textures, the shader and the sound are not Sol work (spec.md
  11.2 says which is which).

**Provenance (A9, V4).** Pip's guard (`tools/assets/check_provenance.py`,
hidden here) scans only image and audio files and treats any other record
as stale, so records are written only for new `.png`/`.webp`/`.wav` (etc.)
files; fonts carry `OFL.txt` and `SOURCE.txt` beside them instead (spec.md
11.5). Where the records go depends on one approval Alex gives with this
prompt:
- **If Alex approves editing `godot/data/asset_provenance.json`** as a
  metadata exception to AGENTS.md section 1 (spec.md Q15): records go there on
  the `ui/g-*` branch, and Pip's guard runs with the method in spec.md 11.5
  (the real worktree as its repo root and the tracked pin from history; not
  the copy-and-link method, which fails on the missing pin). Both its
  `--self-test` and its plain run must exit 0.
- **Otherwise (the default):** records go in
  `fork/design/godot-g/provenance.json` (same shape), committed as a fork
  commit on `lean`, never on a `ui/g-*` branch. It is staging only: before
  any change goes to Pip (AGENTS.md section 8), the records move into
  `godot/data/asset_provenance.json` on the `up/<slug>` branch, and Pip's
  guard must pass there (`python tools/assets/check_provenance.py` in that
  full tree).
Every phase that adds media runs the provenance audit (spec.md 11.5) and
lists the files in its report.

## 7. Reporting

- After phases 1, 3 and 7, and at the end, tell Alex plainly whether the goal
  in section 1 is met yet: can he play a G build from `lean`, and what is still
  missing.
- Each report: what merged (squash commit ids), what the scope reviews said,
  the open questions still on their defaults, anything blocked, and a Disk
  section (every folder written outside a checkout with its `du -sh` size,
  what can go, and `df -h` for `/` and `/data`).

## 8. Do not start

This prompt does nothing until Alex approves it. With the approval, Alex
answers (or leaves on its default) the provenance question in section 6, and
the pinned design commit is written into section 2. Then begin with phase 1a
(spec.md 12.2).

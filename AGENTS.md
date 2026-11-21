# P(Doom)1 -- Alex's lean fork

You work for Alex, on Alex's fork of Pip Foweraker's game. Pip owns the game and
its design and has asked for feedback and outside PRs. This fork fixes bugs that
get in the way of play and improves the UI and the tutorial, fast, then offers
each change back to Pip as a PR.

This file replaces Pip's agent instructions in this working copy. His
`CLAUDE.md`, rulings, calendar and process docs are hidden on purpose (see
section 3). Do not restore them, follow his process, or save memories from his
docs. Section 8 says what his process needs when a change goes to him.

## 1. Scope -- read before every change

Allowed:

1. **Bugs that get in the way of play**: crash, hang, softlock, a button or key
   that does nothing, a screen the player cannot leave, a display that is wrong
   or contradicts another display, text that contradicts what the game does.
2. **UI**: layout, readability, feedback, navigation, consistency.
3. **Tutorial**: first-run help, the cold open, the welcome overlay, the player
   guide, tooltips and explanations of rules that already exist.

Not allowed -- stop and ask Alex:

- Any change to what the game does: numbers in `godot/data/` (costs, odds,
  balance), formulas, actions, events, upgrades, scoring, RNG, turn structure.
- Showing information the game hides on purpose. Read ADR-0015 (no printed doom
  deltas) and ADR-0001 (spending buys sight) before you put a new number on
  screen.
- Refactors, new systems, new tooling or new docs the change does not need.

Player-facing text in `godot/data/` JSON (an action's or event's `name`,
`description`, tooltip or tutorial strings) is tutorial work and allowed, as
long as no id, key or number changes.

**The real test:** with the same seed and the same player inputs, could a run
play out differently after your change -- any game state, any RNG draw? Then it
is mechanics. That holds in UI code too: a UI script that draws one extra
random number is a mechanics change. A layout change, or making Escape close a
dialog that trapped the player, is not. If a bug fix itself changes how a run
plays out (for example a softlock fix that changes turn resolution), stop and
ask Alex. With his OK, the squash message says
`Ladder-Impact: bump -- <what changes>; epoch cut is Pip's call`. Never edit
`ladder_version.txt`.

Watch the word "onboarding": in this code it usually means onboarding a hired
researcher (a mechanic), not the player tutorial.

**Scope tripwire** (`tools/check_ladder_bump.py`). It checks paths and reads
commit messages, so:

- Never put a `Ladder-Impact:` line in a change branch's commits; it goes only
  in the squash commit message. One declaration silences the check for every
  later commit.
- Before squashing, commit everything, then run
  `python tools/check_ladder_bump.py --base lean --head HEAD`. It exits 1 and
  lists every changed file that can affect a run. `godot/scripts/ui/`,
  `godot/scenes/`, `godot/theme/`, `godot/assets/` and `godot/tests/` are not
  on it, so pure UI and tutorial work passes clean. Every listed file must be a
  named bug fix, copy-only text, or a presentation-only edit to an autoload
  (theme, icons, notifications, keybinds, music, screenshots) that passes the
  same-seed test. `godot/autoload/` also holds gameplay singletons
  (`game_config`, `balance`, `event_service`, `verification_tracker`); those
  are bug fixes only.
- When you create the squash commit, write the accurate declaration, first
  match wins:
  1. a run-changing fix Alex approved: the `bump` line above -- even if the
     tripwire listed nothing (UI paths are not checked);
  2. every listed file is a named bug fix, copy-only text or a
     presentation-only autoload edit:
     `Ladder-Impact: none -- <why no run outcome changes>`;
  3. nothing listed: no line.
- If the pre-squash run listed files, or the squash needed a conflict
  resolved, run `python tools/check_ladder_bump.py --base <squash>~1 --head <squash>`.
  It must exit 0.
- The tripwire only checks paths. The reviewer in section 7 reads the whole
  final diff for mechanics hidden in UI code.

## 2. Where things are

- `godot/` is the whole game: Godot 4.5.1, GDScript, data-driven JSON.
  - `scripts/ui/` screens and panels. `main_ui.gd` is ~3k lines; use
    `docs/MAIN_UI_SEAM_MAP.md` before editing it.
  - `scenes/` layouts; `theme/` styling. Font sizes come from
    `theme/base_theme.tres` and `ThemeManager.get_font_size()`; do not add new
    `theme_override_font_sizes` in scenes or `add_theme_font_size_override()`
    with a literal size in scripts (Pip's CI ratchets both).
  - Every `create_timer(...)` passes its second argument (`process_always`)
    explicitly: `false` stops while paused (the default choice), `true` needs
    a comment saying why. Pip's CI rejects a call without it.
  - Tutorial surfaces: `scripts/ui/cold_open_sequence.gd`,
    `welcome_overlay.gd`, `welcome_screen.gd`, `player_guide.gd`.
  - `scripts/core/` game logic and `data/` content: bug fixes only, plus
    copy-only text edits in `data/` (section 1).
  - `tests/unit/` the fast tests; `tests/unit/simulation/` the slow tier.
- Docs kept for decisions (read the ones your change touches):
  - `docs/ARCHITECTURE.md` systems map; `docs/GLOSSARY.md` terms.
  - `docs/game-design/decisions/ADR-0001..0018` the game's rules.
  - `docs/game-design/DESIGN_PHILOSOPHY.md` the intent;
    `UI_ESCAPE_CONTRACT.md` (no dead-end screens);
    `ONBOARDING_STORY_DESIGN.md` and `COLD_OPEN_SEQUENCE.md` for the tutorial.
  - `docs/design/NAVIGATION_AUDIT.md`, `PAUSE_SEMANTICS.md`,
    `godot/UI_STYLE_GUIDE.md`, `docs/art/PALETTE_AND_DOOM_INTENSITY.md`,
    `docs/NUMBER_FORMATS.md` (a test enforces it) for UI work.
  - `docs/PLAYERGUIDE.md` the rules in player prose (not checked against the
    ADRs; the ADRs and code win).
  - `docs/game-design/WORKSHOP_2_BACKLOG.md` Pip's open design questions.
    `DQ_INDEX.md` is generated from it; never hand-edit it.

## 3. Sparse working copy

Most of Pip's tree is hidden from disk by `fork/sparse-checkout.txt` (history
is untouched). If you need a hidden file, say which and why; Alex re-adds it
by appending a line to that file and running, in Git Bash,
`git sparse-checkout set --no-cone --stdin < fork/sparse-checkout.txt`.
If the checkout ever shows almost no files, follow
`C:/Users/keech/Documents/pdoom1-lean-setup/fork/RECOVERY.md` (a copy outside
the checkout). Never use `git sparse-checkout disable`: it puts Pip's
`CLAUDE.md` and permissions file back on disk.

## 4. Commands (Windows, this machine)

**All commands in this file are Git Bash.** Not PowerShell 5.1: it has no `<`
or `&&`, and its pipes can add a byte-order mark that empties the sparse
checkout.

`PDOOM1_GODOT` and `GODOT_BIN` both point at the Godot 4.5.1 console exe
(`C:/Users/keech/tools/godot-4.5.1/Godot_v4.5.1-stable_win64_console.exe`).
`make` is not installed; run the commands directly.

- **Run the game:**
  `APPDATA="$LOCALAPPDATA/Temp/godot-iso-cache" python tools/check_class_cache.py --repair`,
  then `"$PDOOM1_GODOT" --path godot`. Never skip the cache check: a stale
  cache launches a silently broken game.
- **Fast gate:** `python scripts/run_godot_tests.py --quick --ci-mode --min-tests 300`.
  Exit 0 = pass, 1 = fail, 2 = did not complete (no result -- never report a
  pass from it). ~1533 tests on 2026-11-21.
- **Slow tier** (`--simulation`, 7-10 min): only if you touched
  `scripts/core/` or `data/`.
- **Windows build:**
  `python tools/build_release.py --godot-path "$PDOOM1_GODOT" --preset "Windows Desktop" --output builds/win`
  -> `builds/win/PDoom.exe` + `PDoom.pck`. Restore `godot/build_stamp.txt`
  afterwards (`git restore godot/build_stamp.txt`).
- **Checks before commit:** `python scripts/check_no_emoji.py`,
  `python tools/check_scene_nav.py` and the scope tripwire above.
- Run tests, builds and anything over a minute in the background with a time
  limit about twice the normal runtime. Read only the tail of the output.
- **A bare `godot --headless` writes into the real player profile.** Prefix it
  with `APPDATA="$LOCALAPPDATA/Temp/godot-iso-<name>"`. The test runner
  isolates itself.
- **Screenshots:** in the running game press `[`.

## 5. Rules that keep a change upstreamable

- ASCII only in `.gd`, `.json`, `.md`; no emoji anywhere, including UI strings.
- Change scenes only through `SceneTransition.go_to()` / `.reload()`.
- Never `git add -A` or `git add .`. Godot rewrites hundreds of `.import` /
  `.uid` files; stage only the files you meant to change.
- In commit messages and PRs write `Refs #N`, never "closes/fixes #N".
- **`.claude/settings.local.json`:** Pip's copy is tracked in his repo and
  hidden here. Once Claude writes its own, git shows it as modified; that is
  expected. Never stage it, and never `git stash`, `git restore` or
  `git checkout --` it: that brings Pip's permissions back. Rebases use
  `--autostash`. If a sync leaves this file conflicted (`UU`; only when Pip has
  edited his copy), note the rebase's `Created autostash: <id>` line and follow
  `fork/RECOVERY.md`.

## 6. Branches

- `main` mirrors `upstream/main` (Pip's). Never commit to it.
- `lean` = `main` + "fork: lean setup" (this file, `.claude/CLAUDE.md`,
  `fork/`) + one squash commit per finished change + backlog commits. The
  setup and backlog commits never go upstream.
- One branch per change, from `lean`: `fix/<slug>`, `ui/<slug>`, `tut/<slug>`.
  When done, squash-merge it into `lean` as ONE commit whose message has the
  problem line, `Refs #N` if any, and the `Ladder-Impact:` line if needed
  (section 1). That squash commit is the unit that goes to Pip. Delete the
  branch.
- Sync with Pip (from `lean`, with `main` not checked out in any worktree):
  `git fetch upstream && git branch -f main upstream/main && git push origin main && git rebase --autostash main lean && git push --force-with-lease origin lean`.
- Follow-up fixes Pip asks for on a PR: make them as a new commit on `lean`
  first, then cherry-pick that commit onto `up/<slug>`. If a later sync then
  stops on a commit Pip has already merged (conflict or empty), run
  `git rebase --skip`.

## 7. A change is done when

On the change branch, before squashing:

1. The problem is one line in the player's terms, and reproduced (steps or a
   failing test).
2. Everything is committed and every file the pre-squash tripwire (section 1)
   lists is allowed by section 1.
3. The fast gate exits 0 and the checks pass.
4. It is shown on real behaviour: launch the game and give before/after
   screenshots for UI and tutorial work, or show the repro no longer happens
   (plus a test where practical) for a bug.
5. A fresh reviewer that did not write it has read the whole final diff
   against Alex's request and section 1, and has no cut or ask items.

Then, on `lean`:

6. Squash it into one commit with the accurate declaration (section 1).
7. If section 1 calls for it, the post-squash tripwire on
   `<squash>~1..<squash>` exits 0. Only now is the change done.
8. Update its line in `fork/BACKLOG.md` in a separate commit (never on the
   change branch -- the file does not exist in Pip's repo).

Alex playtests builds made from `lean`.

## 8. Sending a change to Pip (the upstream lane)

Only when Alex says to. Drive it from this session: never start an agent
session inside `../pdoom1-up` (Pip's tree is there, and agent memory is
shared across worktrees). Use `git -C ../pdoom1-up ...` or a
`( cd ../pdoom1-up && ... )` subshell so this session stays here. Git Bash:

1. `git fetch upstream`
2. `git worktree add -b up/<slug> ../pdoom1-up upstream/main`, then
   `printf '%s\n' '/*' '!/CLAUDE.md' '!/.claude/settings.local.json' | git -C ../pdoom1-up sparse-checkout set --no-cone --stdin`
   (everything except Pip's agent file and permissions file; use the stdin form -- Git Bash
   rewrites a leading `/` in an argument into a Windows path and the pattern
   silently matches nothing). Check:
   `git -C ../pdoom1-up ls-files -t .claude/settings.local.json` must print
   `S ...`. Needs `core.longpaths=true` (set once in `fork/SETUP.md`).
3. `git -C ../pdoom1-up cherry-pick <the change's squash commit>` (find it
   with `git log --oneline main..lean`). Check
   `git -C ../pdoom1-up show --stat HEAD` lists no `AGENTS.md`, `fork/` or
   `.claude/` file.
4. In `../pdoom1-up` run the fast gate and `python tools/sync_version.py --check`.
   If the change edited an action's `name` in `godot/data/actions/*.json`,
   run `python scripts/generate_action_taxonomy.py` there and commit the
   regenerated file on `up/<slug>`.
   Then `git push origin up/<slug>` and prepare the PR against
   `PipFoweraker/pdoom1:main` with `Refs #N`, the `Ladder-Impact:` line and
   the screenshots. Pip's CI enforces the rest of his process. Alex opens or
   approves the PR; never open a PR to Pip's repo unasked.
5. When the PR is merged or declined, run
   `git -C ../pdoom1-up status --short --ignored=matching --untracked-files=all`.
   Safe to delete: ` M` on a `*.import` file, `??` on a `*.uid` file,
   `!! godot/.godot/`, `!! godot/test-results-*.xml`, `!! .../__pycache__/`.
   If every line is one of those, `git worktree remove --force ../pdoom1-up`.
   Anything else: stop and tell Alex.

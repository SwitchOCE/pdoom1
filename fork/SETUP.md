# One-time setup (this PC)

Already done on 2026-11-21: Godot 4.5.1 in `C:/Users/keech/tools/godot-4.5.1/`,
Windows export templates in `%APPDATA%/Godot/export_templates/4.5.1.stable/`
(checksums matched), fast gate 1533 tests / 0 fail on `main` 4119ddcb.

Run every command in Git Bash, in `C:/Users/keech/Documents/pdoom1`, with no
Claude session open in it.

1. Set two user environment variables to
   `C:/Users/keech/tools/godot-4.5.1/Godot_v4.5.1-stable_win64_console.exe`:
   `PDOOM1_GODOT` (test runner) and `GODOT_BIN` (class-cache repair).
2. `git remote -v` must show `origin` = SwitchOCE/pdoom1 and `upstream` =
   PipFoweraker/pdoom1. Then `git fetch upstream`.
3. Discard build churn: `git restore godot/build_stamp.txt` and delete the
   stray `godot/tests/unit/test_event_service_null_reactions.gd.uid`. If
   `git status` lists `.claude/settings.local.json`, move that file out of the
   repo first, and do not copy it back afterwards: Claude adds approvals to
   Pip's file, so it still holds his rules. Re-approve what you need.
4. `git config core.longpaths true` (Pip's `art_source/` has paths over
   Windows' 260-character limit; a full checkout in a longer folder fails
   without it -- seen in testing).
5. `git switch main && git merge --ff-only upstream/main`, then check
   `git rev-parse main` equals `git rev-parse upstream/main` (a local `main`
   that is ahead passes `--ff-only` but differs). Then `git switch -c lean main`,
   copy in `AGENTS.md`, `.claude/CLAUDE.md` and `fork/` from
   `C:/Users/keech/Documents/pdoom1-lean-setup/`,
   `git add AGENTS.md .claude/CLAUDE.md fork`, commit "fork: lean setup",
   `git push -u origin lean`.
   Make `lean` the fork's default branch, so worktrees, threads and clones
   that start from the default branch get these instructions:
   `gh repo edit SwitchOCE/pdoom1 --default-branch lean && git remote set-head origin lean`.
   (PRs to Pip target `PipFoweraker/pdoom1:main` and are unaffected.)
6. `git sparse-checkout set --no-cone --stdin < fork/sparse-checkout.txt`.
   Check: `git ls-files -t .claude/settings.local.json` prints `S ...`, the
   file is not on disk, and root `CLAUDE.md` is not on disk. (Tested in a
   throwaway clone: about 2,060 of 9,809 tracked files on disk, the tools and
   checks run, fast gate 1533 / 0 fail.)
7. Check the fork's Actions after the first push:
   `gh workflow list -R SwitchOCE/pdoom1`. On 2026-11-21 it listed none. If
   Pip's workflows appear and run, disable them with
   `gh workflow disable <name> -R SwitchOCE/pdoom1`; `docs-sync.yml` in
   particular can push its own commits to the fork's `main`.
8. In a fresh Git Bash, `echo "$PDOOM1_GODOT" "$GODOT_BIN"` prints the path
   twice and `test -x "$GODOT_BIN" && echo ok` prints `ok` (shells opened
   before step 1 will not see the variables). Start a Claude session in the
   repo. `/memory` should list `.claude/CLAUDE.md` and AGENTS.md, and not
   Pip's `CLAUDE.md`. `/permissions` should list none of Pip's allow rules
   (`gh:*`, `git push:*`).

From then on, in any new worktree, thread or clone, before an agent starts
work: `AGENTS.md` is on disk, and root `CLAUDE.md` and
`.claude/settings.local.json` are not (a full clone of `lean` has all three;
apply step 6 there first).

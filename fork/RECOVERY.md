# Recovery (rare)

A copy of this file lives outside the checkout at
`C:/Users/keech/Documents/pdoom1-lean-setup/fork/RECOVERY.md`, for when the
checkout is empty. All commands are Git Bash.

## The checkout shows almost no files

The sparse patterns were damaged (for example by a PowerShell pipe adding a
byte-order mark). The pattern file is gone from disk too, so read the
committed copy. On `lean` or a branch made from it:

    git show HEAD:fork/sparse-checkout.txt | git sparse-checkout set --no-cone --stdin

Never use `git sparse-checkout disable`: it puts Pip's `CLAUDE.md` and
permissions file back on disk.

## A sync left `.claude/settings.local.json` conflicted (`UU`)

Only happens when Pip has edited his copy of the file.

1. Note the rebase's `Created autostash: <id>` line.
2. `git checkout --theirs -- .claude/settings.local.json && git reset -q -- .claude/settings.local.json`
3. Confirm the file holds Alex's settings, `git rev-parse --short stash@{0}`
   equals `<id>`, and `git stash show --name-only stash@{0}` lists only
   `.claude/settings.local.json`.
4. Only if all three hold: `git stash drop stash@{0}`. If any fails, keep the
   stash and tell Alex.

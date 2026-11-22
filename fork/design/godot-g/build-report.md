# G build report

The newest checkpoint is first. Orchestrated on the Optiplex from the build
prompt approved at `b3f9fd14` (spec pin `5e540c1c`).

---

## Checkpoint A -- 2026-11-22: phase 1a + 1b merged, a G desk you can play by mouse

### Is the goal met yet?

Partly. You can play a whole run in G from `lean` by mouse, in a plain look,
with the old UI one switch away (Settings > G desk options). Every run plays
out exactly as today: the same-seed hash is identical for classic on `lean`
before the change, and for classic and G after it. Still missing: the G look
(2a), the WATCH faces (1c), paper, room, dateline sound, tier icons, motion.

**Has the UI and tutorial problem moved?** The UI part, yes. The month-1
screen goes from about 15 action tiles, the upgrades list, the queue, an info
bar and a string of readouts to five labelled rail plates, a P(Doom) card,
an Attention card and one Commit plate. Actions are listed with their name,
cost and the reason a row is blocked, in words, instead of icon tiles you
have to hover. The tutorial part moves a little. The cold-open hand-off is
now an ADVISOR note with an arrow to the glowing ACTIONS plate, and the
Actions sheet opens scrolled to the glowing row. Without a hand-off, the note
carries today's first-turns line. No new teaching yet. Nobody has played it
on a real GPU yet.

### What merged into `lean`

- `7e92d558` fork tools (`contrast_godot.py`, `cut_icons.py`, `synthesize.py`)
- `19de9ba3` **ui: G desk, playable by mouse in a plain look (1a + 1b)** --
  `Ladder-Impact: none -- presentation only: keybinds`; post-squash tripwire
  exit 0
- `cdd46547` backlog

Built by two workers in turn on one branch. Merged once runtime gate and
scope review passed:

- Fast gate: 1612 tests, 0 failures (lean had 1533).
- Guards: font-size 125/125 scenes, the pause timer guard and its self-test,
  emoji and scene-nav all pass.
- Tripwire: only `keybind_manager.gd` (six G binds; spec 2.5 allows).
- Same seed: `d732161d...` for classic on lean, classic on the branch, G on
  the branch, and G played by mouse only.

### What the scope reviews said

Three fresh reviews; never a cut item.

- **Review 1** asked four things where G hid what today's game shows:
  - hours left did not count queued plays;
  - there was no lose line;
  - the ledger due-warning and the last-month change chips were missing;
  - two unused settings were stored.
- **Review 2** asked about the first-turns line, which G hid when there is no
  cold-open hand-off.

Under your rule ("follow the current stuff"), each was fixed by bringing
back today's display, not by adding anything new. The doom change chip
stays out (ADR-0015).

- **Review 3:** 0 cut, 0 ask. Its two display gaps were fixed before the
  merge:
  - in WATCH the held hours were not shown;
  - the advisor line stayed up after the glow stopped.

  A delta check confirmed the verdict.

### Choices made during the run (from your rule, not yours yet)

- G hides today's single feed in WATCH. So that a month is not silent, a
  plain feed panel came forward from 1c.
- G now shows today's displays in four places it first hid them:
  - hours left after the queue;
  - the lose line;
  - the ledger warning;
  - the money, compute and reputation change chips.

### Open questions

For you, at this checkpoint:

1. **Is the hours readout right?** The Attention card shows hours left in
   each pool. Today's game checks a queued play against the total, not the
   pool, so a pool can read "0 left" while its plays are still accepted.
   Show the total instead?
2. **The feed's doom line.** G's feed prints today's line
   "Doom 20.0 -> 20.1 (change: +0.1)", while G drops the doom chip. Should
   1c hide it in G (Q4)?
3. **Two bugs found, not fixed:**
   - a commit in the first seconds of a run can race the baseline thread
     (engine error);
   - Undo removes the first queued copy of the last action, not the last
     entry. Fixing it is mechanics. Ticket them?

For Pip later:

- G being on by default is set by one constant (`GPrefs.DESK_DEFAULT`); for
  Pip it is his call.
- In classic, the rebind screen lists six "(G desk)" keys that do nothing.

Spec questions still on their defaults: Q2-Q17 (Q1 answered: G on).

### The Windows build

`/data/pdoom1-g/builds/A/PDoom.exe` + `PDoom.pck` (release, from `lean`
`19de9ba3`, exported on this box with the official 4.5.1 templates). Copy
both to the PC, e.g.
`scp alex@<optiplex>:/data/pdoom1-g/builds/A/PDoom.* .` G opens by
default; Settings > G desk options turns it off (next game load).

### Renderer note

Every screenshot is a CPU render (llvmpipe under Xvfb), at 1920x1080 only for
this step. Shots, classic before and G after:
`/data/pdoom1-g/g-desk/shots/`. Contrast: all of G's own text reaches 4.5:1
when nothing sits over the desk. Lower readings are text under a modal's dim,
today's review panel, or today's grey key letters.

### Disk

| Path | Size | Can go? |
|---|---|---|
| `/data/pdoom1-g/builds/A/` | 153M | keep until you have copied the build |
| `/data/pdoom1-g/build-profile/` | 186M | keep (the Windows export templates) |
| `/data/pdoom1-g/g-desk/` (shots, reports, parity driver) | 31M | keep until checkpoint B |
| `/data/pdoom1-g/logs/` | 14M | can go |
| `/data/pdoom1-g/briefs/` | 52K | keep |
| `/data/godot-4.5.1/templates-dl/` | <1M | can go |
| `~/code/pdoom1-design-5e540c1c` (read-only spec copy) | small | keep for the run |
| `~/code/pdoom1-lean` (lean worktree for squashes and builds) | worktree | keep for the run |

The step's branch, worktrees, run profiles and guard copies are deleted.
`df -h`: `/` 65G free (59% used), `/data` 48G free (29% used).

### Next

2a (theme, fonts, hierarchy, both sizes), then 1c (WATCH faces and feed),
then checkpoint B.

# G build report

The newest checkpoint is first. Orchestrated on the Optiplex from the build
prompt approved at `b3f9fd14` (spec pin `5e540c1c`).

---

## Final -- 2026-11-23: every G phase is in `lean`; build D is ready to play

### Is the goal met?

Yes, for a test build. `lean` has every phase of the G build prompt (1a-1c,
2a-2b, 3a-3b, 4, 5, 6, 7). G is on by default, and classic is one switch
away (Settings > G desk options). Every run plays out exactly as it does
today. The same-seed hash `d732161d...` holds for classic on final `lean`
and for classic and G on every merged branch.

**Has the UI and tutorial problem moved?** The UI has, and the tutorial has
not.
- **UI:**
  - The P(Doom) card reads first, then hours and money.
  - WATCH says which workday it is and how many hours are held.
  - Events, the review and the advisor are paper on the desk.
  - The room darkens with doom, and resources show tier icons.
  - A new month's date types itself in.
  - Changes arrive as short motions that never block input.
- **Tutorial:** no new teaching. It is still the advisor note and the
  glowing ACTIONS plate.

Nobody has played it on a real GPU yet. Every screenshot is a CPU render.

### What merged into `lean` since C

- `e097bf09` **ui: G dateline (4)**: the date types itself in on a worn
  ribbon, with typewriter strikes. Per your word ("just include a mute
  option"), G options has a **Typewriter sound** switch.
- `4ebd9911` **ui: G motion (7)**: short motions for changes; the
  **Reduced motion** switch turns them off.
- `0648a54d` **fix: G desk options opens centred**: before this, the panel
  opened partly off screen, and the switch back to classic could not be
  reached.
- `3bfe6779` **ui: G traces (6)**: G options **Resources: Icons / Traces**
  shows each resource as a small line of its month-start amounts. Icons is
  the default.
- Fork commits: provenance records (45 in total, including the seven
  typewriter WAVs) and the backlog line (`959cf74e`).

The gate for each, on the branch rebased onto `lean`:
- fast gate with 0 failures (4: 1728 tests, 7: 1741, fix: 1742, 6: 1759);
- emoji, scene-nav, both hidden guards and their self-test;
- a tripwire listing nothing, so no `Ladder-Impact` lines;
- three equal same-seed hashes.

Scope reviews found 0 cut and 0 ask items, apart from step 4's ask for
your ear, which you answered.

### The Windows build

On the Optiplex, `/data/pdoom1-g/builds/D/` holds `PDoom.exe` (97 MB) and
`PDoom.pck` (67 MB). It was exported from `lean` at `959cf74e` with Godot
4.5.1, "Windows Desktop", and `build_stamp.txt` was restored afterwards.

Screenshots from that commit are in `/data/pdoom1-g/builds/D-shots/`
(g-01 month 1 through g-15 late band 6). The capture's same-seed hash
matched.

### PC check still open (about 5 minutes)

**Room cost** (spec 5.14). In Git Bash, in your lean checkout after
pulling: `bash fork/design/godot-g/tools/room_cost_check.sh`.
- Read the last line: `delta X ms per frame; budget 2.0 ms: WITHIN|OVER`.
- Check that the `adapter` line names your GPU.
- OVER means Simple should become the default room setting.

### Questions for you (after playing D)

1. **Smoke** at bands 5-6 reads as bold violet clouds (`g-15_late_band5.png`).
   Keep it, make it fainter, or drop it?
2. Does a month in G read simpler than classic?
3. Research 0 and papers 0 show the red tier-0 icons at the start of every
   run. Is that fine or too alarming?
4. At 1600x900 a few small labels lose contrast. Scaling the compact layout
   to about 0.85 would fix it. Should I?
5. The paper's torn edges: right, or too much?

Known and left alone: the debug PageUp doom nudge does not update the G
room (debug only). Bug filed on Pip's repo: #1385.

### Disk

`/data` has 49 GB free and `/` has 65 GB free. `/data/pdoom1-g` is about
800 MB:
- build D and its shots, 180 MB;
- Godot's export templates (`build-profile`, needed for any future build),
  186 MB;
- each step's report and kept shots, about 350 MB (they can go once you
  have seen D);
- restack logs and scripts, 60 MB.

Removed today:
- the design pin copy and the parity worktree (310 MB);
- the executables from builds B and C (310 MB);
- the worker logs, gate sandboxes, same-seed runs, the temp folder and the
  intermediate shots (about 400 MB).

The only worktrees left are `pdoom1` and `pdoom1-lean`.

---

## Checkpoint C -- 2026-11-23: phase 3 done; paper, room, smoke and tier icons merged; the dateline waits for your ear

### Is the goal met yet?

Nearly, for a first look. `lean` now has every G look phase except motion
(7, building) and the optional trace windows (6). The dateline and its
typewriter sound (4) are built, gated and reviewed; they wait only for you to
listen (the spec makes that a merge condition). Every run still plays out
exactly as today: same-seed hash `d732161d...` for classic on `lean` and for
classic and G on every merged branch.

**Has the UI and tutorial problem moved?** The UI part, yes:
- events, the month review and the advisor note are paper on the desk, in
  the plan's colour (your "far too yellow" fixed);
- the room darkens with the doom band, and at the two worst bands smoke
  drifts across the floor; the panels never change, so it adds no reading;
- each resource in the top strip shows a tier icon, so "a lot or a little"
  reads at a glance; reputation says "0 ends the run".
- Tutorial: unchanged. No new teaching yet.

All screenshots are CPU renders; nobody has seen it on a real GPU.

### What merged into `lean` since B

- `1d0383ad` **ui: G paper (2b)** -- paper for the event, review and advisor
  note; submenu and ledger skin; six new action icons; the paper recoloured
  to the plan's tokens.
- `4c193364` **ui: G room (3a)** -- the office graded by doom band (H's
  7-band table), CRT glows, 1.2 s band change, grain frozen in pause, Room
  effects Full / Simple / Off in G options.
- `b7a849d3` **ui: G tier icons (5)** -- 25 tier icons, LOW / BELOW ZERO
  tags at the game's own Commit thresholds, "0 ends the run".
- `a8aeafc4` **ui: G smoke (3b)** -- floor smoke at bands 5-6.
- Fork commits: provenance records for every new picture (38 in
  `fork/design/godot-g/provenance.json`), the tools that made them, and the
  room cost check (`fork/design/godot-g/tools/room_cost_check.sh`).

Gate for each (on the branch rebased onto `lean`): fast gate 0 failures (2b
1661 tests, 3a 1679, 5 1695, 3b 1703), emoji, scene-nav, both hidden guards
and self-test, tripwire listing nothing (so no `Ladder-Impact` lines),
post-squash tripwire exit 0, three equal same-seed hashes. Scope reviews: 0
cut and 0 ask on each. Review fixes made before merging: the room no longer
fades down from band 0 when G loads at high doom; the cost check measures
band 6 so it counts the smoke; an unused helper removed.

Bug filed on Pip's repo: #1385 (a music-player test fails on a slow machine;
test isolation, not the game).

### Step 4, the dateline (in the build, not yet in `lean`)

The date types itself on a worn ribbon with a typewriter strike per letter,
at a new game and at each new month; a load, resume or F9 flip shows it set.
Gate on `lean`: 1717 tests, 0 failures; same-seed hashes equal. Review: 0
cut, 1 ask (your ear). Two fixes of mine after review: in G the top strip
stays lit under event and review dims (the new month's date typed at 1.26:1
contrast before), and the MENU plate dims while a dialog waits (lit but
dead read as broken).

### The Windows build

`/data/pdoom1-g/builds/C/` on the Optiplex: `PDoom.exe` (97 MB) and
`PDoom.pck` (67 MB), exported from `ui/g-dateline` at `7776c3a0` = `lean`
(`90f457db`) plus step 4, so you can hear the dateline. Godot 4.5.1,
"Windows Desktop"; `build_stamp.txt` restored. G is on by default; classic
is in Settings > G desk options.

Screenshots (CPU renders) in `/data/pdoom1-g/builds/C-shots/`:
`room-bands-0-6.png`, `smoke-bands-4-5-6.png`, `smoke-band-6-floor.png`,
`tier-icons-strip.png`, `tier-icons-beside-pips.png`,
`g-dl_01_midtype.png`, `g-dl_03_month_change.png`.

### PC checks for you (about 10 minutes)

1. **Room cost** (spec 5.14; decides the default room setting). In Git
   Bash, in your lean checkout after pulling `lean`:
   `bash fork/design/godot-g/tools/room_cost_check.sh`. Read the last line,
   `G_CAPTURE ROOMCOST delta X ms per frame; budget 2.0 ms: WITHIN|OVER`,
   and check the `adapter` line names your GPU. OVER means Simple becomes
   the default.
2. **The typewriter** (merge condition for step 4). In build C start a new
   game (it types the date) and play month 1 to the review (it types
   August 1). Do the strikes land on the letters, is no tail cut short, and
   is it pleasant enough to hear every month?

### Questions for you

1. The cost check's delta (WITHIN / OVER).
2. The typewriter: keep / quieter / other.
3. **The smoke** (my look call so far): at bands 5-6 it reads as bold,
   puffy violet clouds rather than thin haze (`smoke-bands-4-5-6.png`).
   Keep, make it fainter, or drop it?
4. Carried from B: does a month in G read simpler than classic? And the
   tier icons beside Pip's (`tier-icons-beside-pips.png`): note that
   research 0 and papers 0 show the red tier-0 icons at the start of every
   run.

### Disk

`/data` 50 GB free, `/` 64 GB free. `/data/pdoom1-g` is about 1.2 GB:
builds B and C 320 MB, the export profile 186 MB, each step's kept shots and
reports 30-140 MB (kept until you have seen them), restack logs 150 MB.
Removed since B: the 2b, 3a, 5 and 3b worktrees (about 500 MB), build A
(160 MB), superseded same-seed runs and gate sandboxes.

---

## Checkpoint B -- 2026-11-22: 2a (the look) and 1c (WATCH) merged; a full month in G's look

### Is the goal met yet?

Closer. A whole run plays in G from `lean`, now in G's own look and with a
working WATCH phase, and the old UI is still one switch away. Every run still
plays out exactly as today: the same-seed hash is `d732161d...` for classic on
`lean`, and for classic and G on each merged branch. Still missing from the
build: paper for the event and the review (2b, gated, merging next), the room
by doom band (3a, building), floor smoke (3b), the dateline and its sound (4,
building), tier icons (5, building), motion (7).

**Has the UI and tutorial problem moved?** The UI part, yes, more than at A.
- **Hierarchy:** the P(Doom) card reads first, then hours and money, then the
  plan; everything else recedes. Before, everything was one weight.
- **WATCH:** while the month plays, G says which workday it is, how many
  hours are still held for events, and what was spent at Commit. The feed
  folds busy days ("+ 51 more lines"), opens the full log in one click, and
  hides doom numbers (your Q2), the "Turn Phase" debug line and raw choice
  ids ("You chose: Issue public response").
- **Tutorial:** unchanged since A (the advisor note and the glowing ACTIONS
  plate). No new teaching yet.

Nobody has played it on a real GPU yet. All screenshots are CPU renders.

### What merged into `lean` since A

- `fb92bbcd` **ui: G desk look (2a)** -- fonts (four OFL faces with
  licences), `g_theme.tres`, hierarchy, script-made panel textures, a "label"
  font step, the compact view for small windows, one total hours figure
  (your Q1), no tooltip covering the next Actions row.
  `Ladder-Impact: none -- presentation only` (ThemeManager font step);
  post-squash tripwire exit 0.
- `90e057a5` **ui: G WATCH (1c)** -- playback bar, the Attention card's WATCH
  and closed faces, Commit's WATCH states, the feed. No tripwire listing;
  post-squash tripwire exit 0.
- Fork commits: tools (`make_textures.py`, `make_theme.gd`, `cut_paper.py`),
  2a's provenance records, backlog lines and your decisions.

Gate for each merge (on the branch, everything committed): fast gate 0
failures (2a 1632 tests, 1c 1644), emoji, scene-nav, the font-size and
pause-timer guards and self-test, tripwire, three equal same-seed hashes.
Scope reviews: 2a and 1c each ended with 0 cut and 0 ask (2a's last ask was
your 720p answer; 1c's feed fix took two rounds).

Your four checkpoint A defects: the Meetups checkerboard (fixed by 2b's
icons; Pip's cause filed as #1384), the feed's half line and debug line
(fixed in 1c), the tooltip over the next row (fixed in 2a), the green event
card (fixed by 2b's paper).

### The Windows build

`/data/pdoom1-g/builds/B/` on the Optiplex: `PDoom.exe` (97 MB) and
`PDoom.pck` (64 MB), exported from `lean` at `90e057a5` with Godot 4.5.1
("Windows Desktop" preset); `build_stamp.txt` restored afterwards. Copy both
files to the PC and run `PDoom.exe`. G is on by default; classic is in
Settings > G desk options.

Screenshots of a month in G (1920x1080, CPU renders):
`/data/pdoom1-g/builds/B-shots/` -- month 1 with the advisor note
(`g-01_month1`), the Actions sheet (`g-08_actions`), the Plan drawer
(`g-10_plan`), WATCH just after Commit (`g-05_watch`), mid-month
(`g-13_w2_mid`), an event (`g-06_event`, still today's panel until 2b), the
review (`g-07_review`, same), the full feed log (`g-14_feed_full`).

### Questions for you

1. **Does a month in G read simpler than classic?** Play month 1 to the
   review in the B build (or look at the shots above). Yes / no / what
   still overwhelms.
2. (Later, with 2b and 5) the new action and tier icons beside Pip's (Q16),
   and the recoloured paper.

Bugs filed on Pip's repo since A: #1380, #1381, #1382, #1383, #1384 (the last
two are classic-only; per your call the fork leaves them).

### Disk

- `/data`: 45 GB free of 70. `/data/pdoom1-g` is 1.1 GB: builds A and B
  (~310 MB), the build profile (~190 MB), live worktree scratch for 2b, 3a,
  4 and 5, reports and final shots. About 300 MB of superseded shots,
  profiles, gate temp folders and old parity runs were deleted this round.
- `/data/pdoom1-art` 80 MB (the art runs and picks; keep until 5 merges).
- Home disk: 63 GB free. The image tool's own copies from all nine art runs
  (~54 MB) were deleted; the other 1.3 GB in `~/.codex/generated_images` is
  not from this run.
- Worktrees: `pdoom1-g-theme` and branch `ui/g-theme` removed after 2a's
  merge. `pdoom1-g-watch` stays until 2b is rebased onto `lean`, then goes.
  Live: `g-paper` (2b), `g-room` (3a), `g-dateline` (4), `g-tiers` (5),
  `g-parity-lean`, the read-only design copy.

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

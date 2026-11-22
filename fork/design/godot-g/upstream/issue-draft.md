_Filed by Claude (an AI agent) on behalf of @SwitchOCE (Alex)._

# Proposal: G desk -- an optional, simpler main screen (playable build; PR on your OK)

Hi Pip -- your CONTRIBUTING.md asks for an issue before significant work, so this is
that issue, a little late: the work is built in Alex's fork and playable, and nothing
goes to your repo unless you say yes. It is a short report: what G is, how to try it,
what it touches, and the questions only you can answer.

Every number below comes with the command that produces it. Unless a line says
otherwise, run the commands in a clone of the fork:

```
git clone https://github.com/SwitchOCE/pdoom1 pdoom1-g && cd pdoom1-g
git checkout d92044fb        # build E's code (431ea001) + one fork script, same_seed.sh
```

`4119ddcb` is your main at v0.14.5, the base of the work. `431ea001` is the code of the
build we are sending.

## 1. The problem, as a player meets it

Alex found month 1 hard to read. The first screen shows about 15 icon tiles, the
upgrades list, the action queue and a string of readouts at once, all at one weight,
before the player knows what any of them do (screenshot 1). The question "what do I do
first?" has no visual answer.

## 2. What G is

G is a second layout of the same main screen. Five plates on the left (Actions,
Upgrades, Staff, Ledger, Guide) open one sheet at a time; the P(Doom) card and the
hours you have left are the two things that are always shown; resources sit in one
strip across the top with a small tier icon each; Commit sits bottom right. Events, the
month review and the advisor note arrive as paper on the desk. While the month plays
(WATCH), G says which workday it is, how many hours are still held for events, and
folds busy days in the feed. The office behind the desk darkens with the doom band, and
each new month's date types itself in (with a typewriter sound that can be muted).
It reads and writes the same game state through the same handlers as classic: it is a
view, not a new rule set.

Screenshots (1920x1080, CPU renders from the test fixture, so the debug "DEV BUILD"
badge shows; a release export shows only a small version label):

1. Classic, month 1 (today's screen, same build with G off):
   ![classic month 1](https://raw.githubusercontent.com/SwitchOCE/pdoom1/3162029dfe4cb4abf404c056881bf5447ffa8382/fork/design/godot-g/upstream/shots/01-classic-month1.png)
2. G, month 1:
   ![G month 1](https://raw.githubusercontent.com/SwitchOCE/pdoom1/3162029dfe4cb4abf404c056881bf5447ffa8382/fork/design/godot-g/upstream/shots/02-g-month1.png)
3. G, the Actions sheet:
   ![G actions](https://raw.githubusercontent.com/SwitchOCE/pdoom1/3162029dfe4cb4abf404c056881bf5447ffa8382/fork/design/godot-g/upstream/shots/03-g-actions.png)
4. G, the plan for the month:
   ![G plan](https://raw.githubusercontent.com/SwitchOCE/pdoom1/3162029dfe4cb4abf404c056881bf5447ffa8382/fork/design/godot-g/upstream/shots/04-g-plan.png)
5. G, WATCH with an event:
   ![G watch event](https://raw.githubusercontent.com/SwitchOCE/pdoom1/3162029dfe4cb4abf404c056881bf5447ffa8382/fork/design/godot-g/upstream/shots/05-g-watch-event.png)
6. G, the month review (the date is typing in):
   ![G review](https://raw.githubusercontent.com/SwitchOCE/pdoom1/3162029dfe4cb4abf404c056881bf5447ffa8382/fork/design/godot-g/upstream/shots/06-g-review.png)
7. G, doom band 6 of 7:
   ![G band 6](https://raw.githubusercontent.com/SwitchOCE/pdoom1/3162029dfe4cb4abf404c056881bf5447ffa8382/fork/design/godot-g/upstream/shots/07-g-band6.png)

Reproduce them (they are the fixture's own captures; same seed every time):
`MODE=shots OUT=$PWD/shots GODOT=<godot 4.5.1> bash fork/design/godot-g/tools/same_seed.sh classic g`

## 3. How to try it

Alex will send you `PDoom-G-desk-431ea001.zip` (97 MB): PDoom.exe + PDoom.pck exported
from `431ea001` with Godot 4.5.1, "Windows Desktop", release mode, plus a README.

- G is on when it starts. Back to classic: Settings > G desk options >
  "G desk (the new main screen)" off; it applies the next time the game screen opens
  (New Game or Continue).
- **It uses your normal profile folder**, `%APPDATA%\Godot\app_userdata\P(Doom)`: the
  project name is unchanged and there is no custom user dir
  (`grep -n "config/name\|custom_user_dir" godot/project.godot`). It adds one file,
  `g_ui.cfg`. The zip has `play-separate-profile.bat`, which points APPDATA at a folder
  next to the exe instead (the same override the fork's test tools use; not tried on
  Windows yet).
- It is built on 0.14.5, not your 0.15.0, so skins (#1372) and the 0.15.0 fixes are not
  in it, and its update check will probably offer you 0.15.0.

## 4. What it changes in your code

| Claim | Command |
|---|---|
| **16 commits, each one step of G** | `git log --oneline 4119ddcb..431ea001 -- godot` |
| **218 files, +18,778 / -23 lines** | `git diff --shortstat 4119ddcb 431ea001 -- godot` |
| **17 of your files edited, nothing deleted** | `git diff --name-status 4119ddcb 431ea001 -- godot \| grep -v '^A'` |
| **No change to game data or game logic** | `git diff --stat 4119ddcb 431ea001 -- godot/data godot/scripts/core godot/scripts/game_manager.gd` prints nothing |
| **A run plays out the same in classic, in G, and in today's game** | see "Same seed" below |
| **1755 tests, 0 failures; 222 new test functions** | `python scripts/run_godot_tests.py --quick --ci-mode --min-tests 300`; `git diff 4119ddcb 431ea001 -- godot/tests \| grep -c '^+func test_'` |
| **Ladder-Impact: none** | `python tools/check_ladder_bump.py --base 4119ddcb --head 431ea001` |
| **Merges with your 0.15.0 without text conflicts** | `git fetch https://github.com/PipFoweraker/pdoom1 main && git merge-tree --write-tree FETCH_HEAD 431ea001` exits 0 |

Your files that G edits (lines added/removed,
`git diff --numstat 4119ddcb 431ea001 -- <file>`):

- `scripts/ui/main_ui.gd` +116/-12 -- mounts the desk, reads `g_ui.cfg` at boot, hands
  the desk the live state; classic paths unchanged.
- `scripts/ui/layout_controller.gd` +199/-3 -- a third layout, `g`, beside classic and
  proposed: hides the classic chrome, moves a few of your nodes onto the desk, puts
  them back on leaving.
- `scripts/ui/month_review_panel.gd` +165/-1, `event_dialog.gd` +64/-1 -- the paper
  skin, asked for only when the layout is `g`; the buttons, keys, order and handlers
  are today's.
- `scripts/ui/dev_build_badge.gd` +54/-1 -- lets a layout dock the badge elsewhere (G
  puts it in its bottom strip; it covered G's MENU plate).
- `ledger_screen.gd` +24, `research_quality_selector.gd` +22/-1, `player_guide.gd`
  +20/-1 (the guide can open as an overlay over a live run), `submenu_controller.gd`
  +14/-1, `action_bar_renderer.gd` +13/-2, `settings_menu.gd` +14 and
  `scenes/settings_menu.tscn` +16 (the "G desk options" button),
  `event_result_presenter.gd` +4.
- `autoload/keybind_manager.gd` +12 -- six binds read only while G is on (A, U, E, Q,
  R, F1); a saved bind on the same key wins.
- `autoload/theme_manager.gd` +4 -- one new font step, `label` (body + 3 px), between body and
  header; no existing step moves.
- Tests: `test_ui_layout.gd` +216, `test_font_size_ssot.gd` +5.

New files (`git diff --name-status --diff-filter=A 4119ddcb 431ea001 -- godot`):
23 scripts in `scripts/ui/g/` (+7,519 lines), 5 scenes, `theme/g_theme.tres`, one
shader (the room), 14 unit test files and the capture fixture
`tests/visual/g_capture.gd`, and the media and fonts in section 6 (3.5 MB).

**Same seed.** `tests/visual/g_capture.tscn` plays month 1 the way a player does
(scouting plays by mouse, Commit, the first option of each event, the review) on seed
`g-parity-1`, then prints the sha256 of `GameManager.state.to_dict()` at the start of
month 2. Each layout runs in a fresh process with an empty profile:

```
GODOT=<godot 4.5.1> bash fork/design/godot-g/tools/same_seed.sh            # classic and G
git worktree add ../pdoom1-base 4119ddcb                                   # today's game
mkdir -p ../pdoom1-base/godot/tests/visual
cp godot/tests/visual/g_capture.gd godot/tests/visual/g_capture.tscn ../pdoom1-base/godot/tests/visual/
(cd ../pdoom1-base && GODOT=<godot 4.5.1> bash ../pdoom1-g/fork/design/godot-g/tools/same_seed.sh classic)
```

All three print `d732161daf4066d4f1bf66cd9de61259cc91bc84d0d764d4156c467a49eab8ea`
(run on Linux with Godot 4.5.1 on 2026-11-23; the script is written for Git Bash too
but has not been run on Windows).

**The PR would ship G off.** The fork has G on by default for Alex's playtests
(`grep -n DESK_DEFAULT godot/scripts/ui/g/g_prefs.gd`); for your repo it would be off,
the way #1372 kept "Default is unchanged", so nobody sees G unless they switch it on.

## 5. What it does not do

- No new teaching. The tutorial is today's: the advisor line is your existing
  first-lever hint, shown in G as a note with an arrow to the Actions plate; the
  Player Guide is your guide, opened as an overlay.
- No hidden information made visible (ADR-0001, ADR-0015): each tier icon restates the
  number beside it, the optional resource traces (off unless chosen in G options) plot
  month-start amounts the strip has already shown, and the feed line that prints a doom
  change in numbers is hidden in G (classic keeps it). Each step was reviewed for this.
- No change to classic, except the "G desk options" button in Settings.

## 6. Art and audio

From the fork's provenance file (`fork/design/godot-g/provenance.json`, 44 records in
your manifest's format; count them with
`python3 -c "import json,collections;print(collections.Counter(r['origin'] for r in json.load(open('fork/design/godot-g/provenance.json'))['assets'].values()))"`):

- **32 images from an image model** (`generated_model`): 25 resource tier icons, 6
  action icons, the paper sheet. Made with the Codex built-in image tool. The prompts
  are in the fork: `fork/design/godot-g/upstream/prompts/` and
  `fork/design/godot-g/art-trial-prompt.txt` on branch `design/ui-concepts`; each record
  names its prompt, its source image's sha256 and the script that cut it.
- **7 typewriter sounds**, synthesized by a NumPy script
  (`fork/design/godot-g/tools/synthesize.py`), recorded as `procedural_render`.
- **5 textures rendered by scripts** (`panel_grime_9`, `hatch_16`, `room_window_mask`,
  `room_noise_lo`, `room_noise_hi`), recorded as `procedural_render`. Two of them are
  derived from your own images (5% of `tex_painted_metal_panel_512.png`; a mask traced
  from `office_wide_day.webp`).
- **4 fonts under the SIL Open Font License**: Barlow Condensed, Courier Prime, IBM Plex
  Mono, IBM Plex Sans (`ls godot/assets/fonts/*/OFL.txt`).

**The Manifund question.** Your `tools/assets/check_provenance.py` treats a
`procedural_render` image as non-model (`NON_MODEL`, line 94) and shouts MANIFUND
TRIGGER when one ships. Your manifest has none today, so G's 5 textures would be the
first (from reading the checker and your manifest; we have not merged the records and
run it). Alex's view: "The script was AI written. They are AI generated right?" -- every
one of those scripts was written by an AI agent. We have still recorded them honestly
as script-rendered, not as `generated_model`. Whether they count as AI-generated for
the grant wording is your call (it is the question in #1257); the sounds are audio, so
the checker does not count them.

All of G's look -- icons, paper, textures, fonts, sounds -- sits in separate files with
records, so your human designer can replace any of it without touching the layout code.

## 7. How it fits with what you already have

- **Skins (#1372).** Skins recolour today's layout; G is a different layout with its own
  theme. They have not been run together (G is built on 0.14.5). Options -- your call:
  (a) keep them apart: skins in the theme dropdown, G as its own switch, as now;
  (b) list G in the skin dropdown as one more entry that also switches the layout;
  (c) have G take its colours from the active skin, so "Paperwork C" and the rest
  recolour G too.
- **The terminal look (#529).** G does not touch it; classic keeps it. G's look is a
  desk in the office rather than a terminal.
- **The office as a visual loop (#1319).** G grades your existing office backdrop by
  doom band, in PLAN and in WATCH, so the room is no longer permanently "decent". It
  does not show furniture or office tiers; it could be the place where that loop lands.
- **AI-art positioning (#1015).** G adds 32 model-made images; see section 6 for how
  they can be swapped out.

## 8. Size and the PR we would send

About 19k lines (section 4), of which about 6.7k are tests and the capture fixture
(`git diff --shortstat 4119ddcb 431ea001 -- godot/tests`).

Proposed shape: **one PR, "all of G at once"**, rebased onto your main, with the 16
commits kept as review units (desk, WATCH, look, paper, room, dateline, tier icons,
traces, motion, then the small fixes). If you would rather have it in pieces, we will
split it along those commits.

Before opening it we would add what your process needs:

- the 44 records merged into `godot/data/asset_provenance.json`;
- the 4 fonts in `CREDITS.md`;
- the art and capture tools moved to `tools/`, with entries in `docs/TOOLS.md`;
- a G section in `godot/UI_STYLE_GUIDE.md`;
- the fork-only references removed: 54 mentions of `fork/design/godot-g/...` in 50
  files (`git grep -c 'fork/design/godot-g' 431ea001 -- godot`) and the "Alex's Q1/Q2"
  comments (`git grep -n "Alex" 431ea001 -- godot/scripts/ui/g`);
- G off by default (section 4);
- rebased onto 0.15.0, with the fast gate, your guards and the same-seed check run
  again there, plus `Ladder-Impact: none -- ...` in the message.

## 9. Questions for you

1. Do you want G in your repo at all, as an optional layout that ships off?
2. Skins and G: (a), (b) or (c) in section 7, or something else?
3. Do the 5 script-rendered textures (scripts written by AI) count as AI-generated for
   the Manifund wording, or should they wait for #1257 -- or be replaced?
4. One PR with 16 review commits, or split?
5. The six G-only key binds and the badge docking in `dev_build_badge.gd`: fine as they
   are?
6. Anything in G's look you would rather your designer owns from the start?

## 10. Refs

- #1372 switchable UI skins (merged 2026-11-22)
- #1015 AI-generated-art positioning
- #529 terminal/CRT look (parked)
- #1257 a sixth origin value and the Manifund claim
- #1319 the office as a persistent visual loop
- Bugs found while building G, filed separately: #1377, #1378, #1379, #1380, #1381,
  #1382, #1383, #1384, #1385

The full build log, the spec G was built from and the reviews are in the fork on branch
`design/ui-concepts` under `fork/design/godot-g/` (start with `build-report.md`).

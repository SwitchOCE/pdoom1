# Godot build spec for G: run report

Run on the Optiplex, 2026-11-22, branch `design/ui-concepts`. Brief:
`fork/design/godot-g/brief.md`. Nothing under `godot/` was edited or
committed.

## Summary

- **The spec is written and has passed two council fix rounds; three small
  items are still open.** `spec.md` covers G with all five of H's upgrades.
  At the end, Opus said GOOD TO GO (9/10) and Sol said CHANGES NEEDED
  (9/10), with three small new items. The brief allows two fix rounds, so
  the run stopped there. The three items are written into spec section 19
  with Sol's proposed fixes. The build prompt makes settling them the build
  orchestrator's first job. Neon reviewed round 1 but was not asked to
  re-check, because the council skill sends Neon a re-check only once Opus
  and Sol both pass.
- **The three riskiest parts run in Godot 4.5.1** (the official 4.5.1
  binary, downloaded to `/data/godot-4.5.1`; this box's own `godot` is
  4.7.2):
  - The doom-band room shader with grain and vignette compiled and rendered
    at 1920x1080 on Forward+ (Vulkan) and on Compatibility (OpenGL). Both
    fell back to llvmpipe software rendering under Xvfb, so the frame times
    (21.98 ms plain, 31.70 ms graded) prove only that it runs, not what it
    costs on a GPU.
  - Four bundled OFL fonts imported and sized through
    `ThemeManager.get_font_size()` at 15, 19, 27 and 35 px.
  - The typewriter dateline stayed in sync with its strike sounds: audio
    lagged the letter by 5.0 ms on average and 11.4 ms at most, over 14
    strikes, measured from a Movie Maker capture.
  - Found on the way: Godot's AudioStreamRandomizer draws from the global
    random generator, so the spec bans it and uses a local generator.
- **The art method works.** Sol made the five money tier icons twice from
  one loose prompt, written the Bramble way. Both runs gave a consistent 0-4
  ladder, with transparent backgrounds, readable at 48 px. All three council
  members judged the method sound. Two things still need Alex's eye:
  - The icons are warmer and more rendered than Pip's cool, plate-framed
    icons.
  - The icons need scaling per tier, which the spec handles with a cutting
    step.
- **The trace windows are in this build.** Their history is kept in the UI
  layer from values the UI already shows. Nothing is written to game state
  or saved, and a loaded save starts with no history.
- **Alex approves the build prompt before anything starts.** It pins the
  design inputs to commit `505d0db9`.

## Deliverables

| File | What |
|---|---|
| `spec.md` | The build spec. Sections 1-16 are the spec; 17-18 list the council changes; 19 lists the three open items. |
| `build-prompt.md` | The prompt for the build orchestrator. It quotes Alex verbatim, pins design inputs to `505d0db9` and starts nothing by itself. |
| `spikes/` | Spike sources, `RESULTS.md` and five screenshots. Rerun with `bash fork/design/godot-g/spikes/run.sh all`. |
| `art-trial.png`, `art-trial-prompt.txt` | The contact sheet of both runs, with Pip's money icon beside them, and the prompt. |
| `council/` | Every round's findings verbatim, the vote sheet and the agreed lists. |

## What the spec covers

- **Phases.** There are seven phases, one `ui/g-*` branch each, built
  behind the existing layout switch as a third layout, `"g"`. F9 in debug
  builds and a Settings row flip it.
  1. A playable G desk in the plain look.
  2. The look: fonts, theme and grime.
  3. The room by doom band.
  4. The dateline and its sound.
  5. The tier icons.
  6. The trace windows.
  7. Motion and finish.
- **Each part.** For each part the spec gives:
  - its Godot node tree and the existing scene or script it lands in;
  - its data binding, which is read-only;
  - its states and transitions, with durations;
  - what happens on input mid-animation, on pause and on Esc;
  - its sound, art and tests;
  - the HTML-versus-Godot differences.
- **Where the build follows today's code instead of the ADR or the
  mock-up:** section 10. This includes the Attention spill pre-check and
  Reserve.
- **Mechanics stay the same.** The spec bans global RNG calls in G code and
  adds a check that a G-only run leaves the global generator where it found
  it. A same-seed parity test, with a fixed seed set in a fresh profile,
  compares classic and G.
- **Reduced motion** stays inside the UI layer (`user://g_ui.cfg`). It is
  not a `game_config` change; Q8 asks whether it should be.

## Spikes (numbers)

| Spike | Result |
|---|---|
| Room shader | **Forward+ (Vulkan 1.4.335, llvmpipe).** Plain: mean 21.98 ms, p95 32.62 ms. Graded: mean 31.70 ms, p95 51.57 ms. 240 frames each. |
| | **Compatibility (OpenGL 4.5, Mesa llvmpipe).** Compiled and rendered the same. |
| | **Why no GPU.** The UHD 630 was refused for presentation because Xvfb has no DRI3. |
| | **Check on Alex's PC.** The cost on a real GPU. The spec sets a 2 ms budget and falls back to `simple` if it is missed. |
| Fonts | IBM Plex Sans, IBM Plex Mono, Courier Prime and Barlow Condensed, all OFL. Theme steps are 15, 19, 27 and 35 px. Readable at 1280x720. The small step is 1 px under H's 16 px floor (Q6). |
| Dateline | 14 strikes. Audio lag 5.04 ms on average, 11.38 ms at most; every strike within one video frame. Six synthesised strike variants and a carriage sound, 527 KB in all. Skipping mid-type reveals the whole date in one frame and stops the strikes. |

## Art trial

The prompt is `art-trial-prompt.txt`: a fixed header, a "Look:" paragraph
and a "The design" paragraph, then five numbered items, with no reference
image. Sol made them with gpt-6.2-sol at high effort, two runs, into
`/data/pdoom1-art/trial-1` and `trial-2`. Each image is 1254x1254 RGBA with
a transparent background.

The council's view:
- The method gives a clear tier ladder that fits the office's worn brass and
  paper. The darker picks sit closer to Pip's icons.
- Each batch is to be judged at 32 and 40 px beside Pip's rail icons; Alex
  decides (Q16).

The spec adds two things:
- A cutting step that scales each tier differently, so one coin is not as
  big as the pile.
- One added prompt sentence about drawing every item at the same scale.

Money needs no re-run: each tier is picked from trial-1 or trial-2.

## Council

Low sensitivity: Claude Opus 5.5 (effort high), GPT gpt-6.2-sol (reasoning
high), Gemini 4 Neon (thought level high). Neon was signed in and worked.
There were three review passes and two fix rounds. The members settled each
change list among themselves, with a vote on seven points in round 1.

| Delegate | Round 1 | Round 2 (re-check) | Round 3 (re-check) |
| --- | --- | --- | --- |
| Claude Opus | 7/10, changes | 8/10, changes | 9/10, GOOD TO GO |
| GPT Sol | 7/10, changes | 8/10, changes | 9/10, changes (3 items) |
| Gemini Neon | 7/10, changes | not asked | not asked |

**What the rounds fixed.** Round 1's list (A1-A11, V1-V7) had the most
weight:
- G could not boot.
- Refusals were invisible in G.
- The G sheets would fail the no-dead-ends test.
- Theme overrides blocked G's styling.
- The WATCH reserve was read wrong.
- Pip's hidden checks ran against the wrong folder.
- The provenance records were out of scope.
- The art recipe was incomplete.

Round 2 fixed:
- the boot timing;
- the seed of the same-seed fixture;
- the WATCH timing;
- the price shown on the Attention card;
- the provenance command;
- the icon surfaces.

**Still open (spec section 19), each with a proposed fix:**
1. Booting straight into G still races the first game state when `main.tscn`
   is the startup scene. Fix: apply G after the existing one-frame wait,
   just before the game boots.
2. The phase 1a parity test would press a disabled "coming soon" action.
   Fix: use three presses of Purchase Compute.
3. The icon screenshot check asks for icons on screens where they can never
   appear. Fix: check each icon only where it can appear.

## Open questions for Alex

Each question shows what happens if nobody decides. Spec section 15 has the
detail.

1. Should your test builds start with G on? If not decided, G starts off, and
   you turn it on in Settings or with F9.
2. Should resources show tier icons or trace windows by default? If not
   decided, tier icons, with traces as a setting.
3. Are the tier thresholds right? If not decided, they are built as the
   table stands.
4. Should G drop the doom change chip and momentum number from the home
   screen? If not decided, G drops them and puts the breakdown one click
   away; classic keeps all three.
5. Should the plan drawer show what is left after the listed costs? If not
   decided, it does.
6. Should the smallest text step move from 15 to 16 px for the whole game?
   If not decided, it stays 15.
7. Should the reputation note read exactly "0 ends the run"? If not decided,
   it does.
8. Should reduced motion be a game-wide setting? That needs a `game_config`
   change. If not decided, it stays a G-only setting.
9. May the build ship four open-licence fonts and Sol-made art, given Pip's
   provenance rules? If not decided, the fork ships them with provenance
   records, and Pip is asked before anything goes upstream.
10. Should the typewriter use the game's SFX volume? It would be the game's
    first sound effect. If not decided, it does.
11. Should G show the office floor with the walking staff during WATCH? If
    not decided, it is hidden in G.
12. Should events have pictures? If not decided, events are text on paper.
13. Should the left rail keep the dark purple edge from Pip's buttons? If not
    decided, it is kept.
14. The Attention spill and Reserve rules differ between Pip's ADRs and the
    code. If not decided, G follows the code.
15. May the build edit `godot/data/asset_provenance.json` to record new art
    and sounds? If not decided, the records stay in a fork file and move into
    the game only on the branch that goes to Pip.
16. Do the Sol icons belong beside Pip's? If not decided, the build uses the
    best picks, and you judge each batch's contact sheet.
17. Is "HOLD ALL HOURS FOR EVENTS" the right label for the Commit plate when
    nothing is queued? It does what today's Enter key does. If not decided,
    it is used.

## Deviations from the brief

- **Godot version.** The box had 4.7.2. I downloaded the official 4.5.1
  Linux binary to `/data/godot-4.5.1` and used it for every spike and
  council check.
- **Art brief.** The two art workers got only the Bramble-format task (the
  folder, no reference image, no git, a disk report, then the prompt). They
  did not get Alex's quoted words, because extra text in an image prompt
  changes the pictures. Every other brief quoted Alex verbatim.
- **Fix rounds.** The run stopped after two fix rounds as the brief says,
  with Sol's three round 3 items recorded, not fixed (spec section 19).
- **A reviewer wrote into `godot/`.** Opus, reviewing in round 3, left two
  untracked scratch files there (`boot.tscn`, `switcher.gd`) after a failed
  `cd`. I removed them. No tracked file changed, and its Godot runs used an
  isolated profile.

## Disk

**Removed:**
- the spike staging project and profiles (about 13 MB);
- the spike Movie Maker videos (5.2 MB);
- Codex's duplicate copies of the ten trial images (19 MB, in
  `~/.codex/generated_images`);
- all reviewer and writer scratch under `/data`;
- the two stray files in `godot/`.

**Left, and why:**

| Path | Size | Why |
|---|---|---|
| `/data/godot-4.5.1/` | 131 MB | The 4.5.1 binary the build is told to use. Delete if the build uses another copy. |
| `/data/pdoom1-art/trial-1`, `trial-2` | 19 MB | Full-size trial icons. The build picks money tiers from them. |
| `/data/pdoom1-spikes/` | 636 KB | Spike logs (including `sync.csv`) and cached font downloads. Safe to delete; the runner rebuilds it. |
| `fork/design/godot-g/` (committed) | about 0.9 MB | Spec, prompt, spike sources, five screenshots, `art-trial.png` (528 KB), council files. |

`df -h` at the end: `/` has 67 GB free (57% used); `/data` has 52 GB free
(23% used).

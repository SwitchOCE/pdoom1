# G with all upgrades: Godot build spec

Status: first full draft, 2026-11-22, with the spike results
(`spikes/RESULTS.md`) and the money art trial (11.1) folded in. Council
review not yet run.

## 0. How to read this

- **What it is.** Alex picked design G ("the existing UI, modernised") as the
  one to build first, because it is closest to today's game. He wants it built
  with every upgrade design H got in the last round, and he wants a spec that
  holds up inside Godot: what differs from the HTML mock-ups, how transitions,
  animation, shaders and the diegetic sound behave, and what a build
  orchestrator needs so it can start without guessing.
- **Sources.** The G mock-up is `fork/design/hifi3/G/` (concept.html, notes.md,
  s1-s6.webp). Its first node mapping is `fork/design/hifi/G/notes.md` and
  `fork/design/research/concepts/G/notes.md`. The upgrades come from H:
  `fork/design/hifi3/spec.md` (called "H spec" below) sections 1.3, 2.4, 3.2,
  3.3 and 6.3-6.4, and `fork/design/hifi3/report.md` "The addendum round".
  This spec reuses the H spec wherever it applies and says where G differs.
- **Code citations** are `file:line` on branch `design/ui-concepts` as of
  2026-11-22 (paths under `godot/` unless they start with `docs/`, `tools/` or
  `fork/`). Line numbers drift; the function names are the anchor.
- **Rule of precedence (Alex).** Where a mock-up or a written rule disagrees
  with what the game does today, the build follows today's code, and the UI
  shows what the game actually allows. Section 10 lists every such place.

Sections:

1. What the build is, and what it must not change
2. How G plugs into today's game (the switch, the desk node, files)
3. Layout in Godot: canvas, positions, anchors, CSS equivalents
4. Look: tokens, type and fonts, textures, contrast
5. Components (one per part, with node tree, binding, states, keys)
6. Motion: transitions, mid-animation input, pause, Esc, reduced motion
7. Sound: the typewriter dateline
8. Keys
9. Data binding summary
10. Where the build follows today's code instead of the ADR or mock-up
11. Art plan
12. Phases, sub-phases and the checks for each
13. Spike results
14. Risks
15. Open questions
16. Not in this build

---

## 1. What the build is, and what it must not change

### 1.1 The design

G keeps today's main screen in its places and gives it H's finished, darker look:

- a top strip with the date and the five resources;
- the `## PLAN` / `## WATCH` banner with the view switch;
- the P(Doom) card top right, the Attention card bottom right, Commit bottom right;
- everything else in sheets opened from a rail on the left (Actions, Upgrades,
  Staff, Ledger, Guide), so the office art fills the middle of the screen.

"All upgrades" means five additions from H (report.md, "The addendum round"):

1. **Hierarchy**: P(Doom) first, then Attention left and money, then the plan;
   the rest recedes, and every text stays at 4.5:1 or better (H spec 1.3).
2. **The room's colour by doom band**: a layer over the office art, keyed to the
   game's doom band, never to the month; the lowest band a little brighter
   (H spec 2.4). Panels never change with the band.
3. **Resources as tier icons**: five tiers plus a zero-or-below tier per
   resource, fixed thresholds, the number always beside the icon; reputation
   drawn once with "0 ends the run" (H spec 3.2 take a). This replaces G's
   small reputation gauge.
4. **The typewriter dateline with its sound**, replacing today's turn label
   (H spec 3.3, 6.3).
5. **The trace-window take**: a second way to draw the resources, as small
   history lines. It is built from history the UI keeps itself (5.1.4), so it
   needs no change to game state or `scripts/core/`. History starts empty when
   a save is loaded.

The build is a test build for Alex. It may later be offered to Pip; nothing
here assumes Pip has agreed to G.

### 1.2 Hard limits

- **Mechanics unchanged** (AGENTS.md section 1). With the same seed and the same
  inputs, a run plays out exactly as today. Every G control calls the same
  handler today's control calls (section 9). The G layer draws no number from
  `state.rng` or from Godot's global RNG; presentation randomness uses a local
  `RandomNumberGenerator` (7.4).
- **Pure UI paths.** New and changed files live in `godot/scripts/ui/`,
  `godot/scenes/`, `godot/theme/`, `godot/assets/`, `godot/tests/`. The few
  exceptions are listed in 2.5 with their reason. Nothing in
  `godot/scripts/core/`, `godot/scripts/game_manager.gd` or
  `godot/autoload/game_config.gd` changes.
- **No new hidden information** (ADR-0001). Every value on screen is one the
  game already shows, or one worked out from values already on screen (for
  example "after these costs" = money shown minus the costs the queue already
  lists, `main_ui.gd:2085-2113`).
- **Doom shows as a level and a band, never as a printed change** (the reading
  of ADR-0015 the designs use). See 10.9 and open question Q4 for the two
  places today's game prints doom changes.
- **Pip's CI rules** (AGENTS.md section 2): font sizes only from
  `theme/base_theme.tres` and `ThemeManager.get_font_size()`; every
  `create_timer(...)` passes `process_always` explicitly (prefer Tweens, which
  need no timer); ASCII only and no emoji in `.gd`, `.json`, `.md` and UI
  strings; scene changes only through `SceneTransition`.
- **The old UI stays one switch away** (2.1).

---

## 2. How G plugs into today's game

### 2.1 The A/B switch

How it works today:

- `GameConfig.ui_layout` holds `"classic"` or `"proposed"`
  (`autoload/game_config.gd:95-96`); `set_setting` rejects any other value
  (`game_config.gd:435-440`).
- `main_ui._setup_plan_watch_scaffold` builds a `LayoutController` and applies
  the persisted value (`main_ui.gd:422-444`).
- `LayoutController.apply_layout(name)` restores classic, then layers the
  proposed deltas; unknown names fall back to classic
  (`scripts/ui/layout_controller.gd:88-96`). `toggle()` flips the two
  (`layout_controller.gd:99-103`, pinned by `tests/unit/test_ui_layout.gd`
  `test_toggle_cycles_between_the_two`).
- F9 flips classic/proposed live, **debug builds only**
  (`main_ui.gd:485-489`, `_toggle_ui_layout` at `main_ui.gd:765-771`), and
  persists through `GameConfig.set_setting`.
- Release players switch with the Settings checkbox
  (`scripts/ui/settings_menu.gd:369-375`), applied on next game load.
- `tools/build_release.py` exports **release** by default (`--mode`,
  `tools/build_release.py:230`), so F9 does nothing in Alex's usual build.

G adds a third arrangement without touching `game_config.gd` (a gameplay
autoload, bug fixes only):

- **`GPrefs`** (new, `scripts/ui/g/g_prefs.gd`, `class_name GPrefs`,
  RefCounted with static load/save) keeps G's own settings in its own file,
  `user://g_ui.cfg`, section `[g]`:
  - `desk` (bool, default false): G on or off;
  - `reduced_motion` (bool, default false);
  - `room_effects` (`"full"` | `"simple"` | `"off"`, default `"full"`);
  - `resources` (`"icons"` | `"traces"`, default `"icons"`).
  It never writes `GameConfig`'s file. It is read once at boot and on change.
- **LayoutController** learns a third name, `"g"`: `apply_layout("g")` restores
  classic, then calls `_apply_g()` (2.2). `toggle()` is left exactly as it is,
  so the existing test still holds.
- **Boot:** `_apply_ui_layout(GPrefs.desk ? "g" : GameConfig.ui_layout)`
  (replaces the call at `main_ui.gd:444`). With G on, `GameConfig.ui_layout`
  keeps whatever it held; G does not overwrite it.
- **F9 (debug builds):** cycles classic -> proposed -> g -> classic. Classic and
  proposed persist through `GameConfig.set_setting` as today; entering g sets
  `GPrefs.desk = true`; leaving g sets it false.
- **Release builds:** Settings gets one new row, "G desk options", which opens
  a small modal with four toggles (desk on/off, reduced motion, room effects,
  resources take). It applies on next game load, like today's checkbox.
  Check `tests/unit/test_audio_defaults_and_settings_layout.gd`
  (`test_nothing_can_hide_below_a_fold`) still passes after the row is added.
- **Alex's test builds** can use either `--mode debug` (F9 works) or the
  Settings row. See open question Q1 for whether lean builds should start with
  G on.

### 2.2 The desk node and what it hides

Today `main.tscn` is: `Main` > `Backdrop`, `BackdropScrim`, `TabManager` >
`MainUI` (a VBoxContainer: `TopBar`, `HSeparator1`, `ContentArea`,
`HSeparator2`, `InfoBar`, `BottomBar`, plus the banner and WATCH strip that
`screen_mode` builds at `main_ui.gd:381-387`), `EmployeeScreen`,
`GameOverScreen`, `BugReportPanel`; then `PauseMenu` and `DebugOverlay`
(`scenes/main.tscn:30-410`). Modal dialogs are mounted on `TabManager` above
`MainUI` with an input barrier (`main_ui._present_modal_dialog`,
`main_ui.gd:1792-1826`).

**`GDesk`** (new scene `scenes/ui/g/g_desk.tscn`, script
`scripts/ui/g/g_desk.gd`) is a full-rect `Control` added by `main_ui` as a
child of `TabManager`, **directly after `MainUI`** (so later modals still draw
above it). It is created only when the layout is `"g"` and freed when the
layout leaves `"g"`.

Why not inside `MainUI`: `MainUI` is a VBoxContainer, so a full-screen child
would be laid out as a row. Keeping `MainUI` visible but emptying it keeps
`MainUI._input` running (it returns early when `MainUI` is hidden,
`main_ui.gd:468`), so every key and every handler stays exactly today's.

`_apply_g()` in LayoutController, in this order:

1. Hide the classic chrome: `TopBar`, `HSeparator1`, `ContentArea`,
   `HSeparator2`, `InfoBar`, `BottomBar`, the mode banner and the WATCH strip.
   `screen_mode.set_mode` re-shows registered nodes on every mode change
   (`scripts/ui/screen_mode.gd:150-160`, the banner and strip are registered
   at `main_ui.gd:395-402`), so `GDesk` connects to
   `screen_mode.mode_changed` and re-hides them after each change.
2. Hide `BackdropScrim`; set `Backdrop.modulate` to white (today 0.35,
   `scenes/main.tscn:48`) and give `Backdrop` the room material (5.14).
3. Reparent four live nodes into G sheets, exactly as `_dock_upgrades` already
   does (`layout_controller.gd:142-163`), and record their old parent and index:
   - `plan_screen.upgrades_label` and `plan_screen.upgrades_scroll` -> the
     Upgrades sheet body;
   - `research_quality_selector` (a child of `plan_screen`,
     `main_ui.gd:200-205`) -> the Plan drawer;
   - `_inflight_hiring_box` (`main_ui.gd:306-313`) -> the Plan drawer's
     UNDER WAY block.
   Because the G sheets are persistent (never freed while G is on), the
   reparented nodes are never freed with a sheet.
4. Instance `GDesk` and call `GDesk.setup(main_ui)`.

`_restore_classic()` undoes all of it in reverse (put nodes back at their
recorded index, restore `Backdrop.modulate` and material, show the scrim and
chrome, free `GDesk`). Flip, flip, flip must never drift, as today
(`layout_controller.gd:88-96`).

Visibility: `GDesk` follows `MainUI.visibility_changed`, so it hides when the
Employee screen takes over (`scripts/ui/tab_manager.gd:41-53`) and returns with
it.

The classic action bar (`plan_screen.actions_list`) **stays rendered but hidden**
inside the hidden `ContentArea`. That keeps keys 1-9 working exactly as today
(`_trigger_action_by_index`, `main_ui.gd:725-743`) and keeps
`_find_action_button` and the first-lever nudge target valid.

### 2.3 The G node tree

Positions are on the 1920x1080 canvas; see 3.2 for anchors.

```
GDesk (Control, full rect, mouse_filter IGNORE, theme = res://theme/g_theme.tres)
  RoomLayers (Control, full rect, mouse IGNORE)       -- 5.14, glow/smoke/fire sprites over Backdrop
  TopStrip (PanelContainer, 0,0 1920x56)
    HBox
      Dateline (GDateline, custom _draw, 420 wide)     -- 5.1.1
      ResourceStrip (HBox of 5 GResourceCell)          -- 5.1.2
      Spacer
      MenuButton (Button "MENU" + keycap Esc)          -- 5.1.5
  Banner (PanelContainer, 0,56 1920x52)                -- 5.2
    HBox: ModeLabel, PlaybackBar (WATCH), SpeedSegments (WATCH), Spacer, ViewSwitch, KeyV
  Rail (VBox, 24,132 232 wide)                         -- 5.3
    PlateActions, PlateUpgrades, PlateStaff, PlateLedger, Gap, PlateGuide
  DoomCard (GDoomCard, 1480,132 416x252)               -- 5.4
  AttentionCard (GAttentionCard, right 1896, bottom 1004, 416 wide) -- 5.5
  FeedPanel (GFeedPanel, 24,716 560x288, WATCH only)   -- 5.10
  AdvisorNote (GAdvisorNote, 290,130 420 wide)         -- 5.13
  BottomStrip (PanelContainer, 0,1016 1920x64)         -- 5.6
    FeedbackButton, Spacer, HeldPlate, CommitPlate
  Sheets (Control, full rect, mouse IGNORE)            -- persistent, presented through ModalStack
    ActionsPanel (g_actions_panel.tscn)                -- 5.7
    PlanPanel (g_plan_panel.tscn)                      -- 5.8
    UpgradesPanel (g_upgrades_panel.tscn)              -- 5.9
  TypeSound (Node with AudioStreamPlayer)              -- 7
```

The three sheets stay children of `GDesk/Sheets` for their whole life; they
are never moved to `TabManager`. Each sheet's
root is a full-rect Control that holds its own input barrier (a full-rect
`ColorRect`, `MOUSE_FILTER_STOP`, colour `dim` token) under the sheet panel,
so they do not need `_present_modal_dialog`. Modals mounted on `TabManager`
(events, the review, today's submenus) are later siblings of `GDesk` and so
draw above every G sheet.

### 2.4 Talking to ModalStack

The G sheets register with the existing chokepoint so Esc, priorities and
"one modal at a time" keep working (`scripts/ui/modal_stack.gd`):

- Open: `main_ui.modal_stack.present(sheet, [], {"kind": "g_actions" |
  "g_plan" | "g_upgrades", "close_mode": ModalStack.CloseMode.HIDE})`, then
  `sheet.show_panel()`. If `present` returns false (an unanswered event holds
  the top, `modal_stack.gd:90-128`), the sheet does not open.
- Close: `modal_stack.dismiss(sheet)`; ModalStack calls `sheet.hide_panel()`
  (`modal_stack.gd:205-215`). Every sheet also attaches
  `EscToClose.attach(sheet, func(): main_ui.modal_stack.dismiss(sheet))`
  (`scripts/ui/esc_to_close.gd:18-23`) for the escape contract.
- `active_dialog_buttons` is `[]` for every G sheet, so today's dialog router
  maps no letter to a row (`main_ui.gd:521-569`). G's own keys inside a sheet
  are routed before that block (8.2).
- A newcomer pops the whole stack (`modal_stack.gd:111`): opening a door's
  submenu from the Actions sheet hides the sheet. G re-presents the Actions
  sheet when that submenu leaves the tree, if it was opened from the sheet
  (5.7.4).

### 2.5 Files

New (all pure UI paths):

| Path | What |
|---|---|
| `scripts/ui/g/g_desk.gd`, `scenes/ui/g/g_desk.tscn` | the desk root, wiring, refresh |
| `scripts/ui/g/g_prefs.gd` | GPrefs (2.1) |
| `scripts/ui/g/g_keys.gd` | `GKeys`, static key-routing decision (8.2), unit-testable |
| `scripts/ui/g/g_dateline.gd` | the dateline control and its schedule (5.1.1, 7) |
| `scripts/ui/g/g_type_sound.gd` | strike playback (7) |
| `scripts/ui/g/g_tiers.gd` | `GTiers`, static: shown amount, tier, tags (5.1.2) |
| `scripts/ui/g/g_resource_cell.gd` | one resource cell, icon or trace |
| `scripts/ui/g/g_resource_history.gd` | `GResourceHistory`, static store (5.1.4) |
| `scripts/ui/g/g_doom_card.gd` | P(Doom) card, custom _draw arc (5.4) |
| `scripts/ui/g/g_attention_card.gd` | Attention card, three faces (5.5) |
| `scripts/ui/g/g_feed_panel.gd` | WATCH feed (5.10) |
| `scripts/ui/g/g_advisor_note.gd` | advisor paper note (5.13) |
| `scripts/ui/g/g_room.gd` | room layer controller (5.14) |
| `scripts/ui/g/g_paper.gd` | paper styling helper for event and review (5.11, 5.12) |
| `scripts/ui/g/g_sheet.gd` | shared base for the three sheets (show/hide, barrier, tween) |
| `scenes/ui/g_actions_panel.tscn`, `g_plan_panel.tscn`, `g_upgrades_panel.tscn`, `g_options_modal.tscn` | sheets and the options modal; the `_panel` / `_modal` suffix lets `tests/unit/test_ui_no_dead_ends.gd` find them (`docs/game-design/UI_ESCAPE_CONTRACT.md`) |
| `theme/g_theme.tres` | G's fonts, colours and styleboxes; **no font sizes** |
| `assets/shaders/g_room_doom.gdshader` | the one room shader (5.14) |
| `assets/fonts/<family>/*.ttf` + `OFL.txt` | four families (4.2) |
| `assets/audio/sfx/typewriter/*.wav` | strikes and carriage return (7) |
| `assets/icons/g_tiers/*.png` | 25 tier icons (11) |
| `assets/icons/g_new/*.png` | six new action icons (11) |
| `assets/textures/g/*.png` | grime, hatch, paper, masks (11) |
| `tests/unit/test_g_*.gd` | per phase (12) |
| `tests/visual/g_capture.gd` (+ `.tscn`) | screenshot and text-box dump harness (12.1) |

Changed (existing files):

| Path | Change | Why it is safe |
|---|---|---|
| `scripts/ui/main_ui.gd` | create/free GDesk via LayoutController; F9 cycle; call `GKeys` in `_input` before the dialog block; `signal queue_view_changed` emitted at the end of `update_queued_actions_display`; `_open_submenu(id, anchor := null)`; clear `GResourceHistory` in `_boot_game`'s new-game and load branches | presentation and routing only |
| `scripts/ui/layout_controller.gd` | `"g"` arrangement | container work, as today |
| `scripts/ui/action_bar_renderer.gd` | when layout is g, also emit the ordered, filtered row list to GDesk | same list, same order, same gates |
| `scripts/ui/submenu_controller.gd` | read-only `option_count(id)` over `_options_for` (`submenu_controller.gd:305-325`) | read-only |
| `scripts/ui/ledger_screen.gd` | read-only `summary_word()` (the "clean" / "$N owed" text it already builds, `ledger_screen.gd:97-115`) | read-only |
| `scripts/ui/event_dialog.gd`, `scripts/ui/month_review_panel.gd` | apply G paper styles when the layout is g | styling only, same buttons and keys |
| `scripts/ui/player_guide.gd` | an `embedded` mode for opening over a live run (5.9.4) | today its Back goes to the welcome screen |
| `scripts/ui/settings_menu.gd`, `scenes/settings_menu.tscn` | the "G desk options" row | UI |
| `autoload/keybind_manager.gd` | new binds (8.1) | presentation-only autoload edit allowed by AGENTS.md section 1 |
| `autoload/theme_manager.gd` | add one step to `FONT_STEPS` (4.2) | presentation-only (theme) |
| `data/asset_provenance.json` | one record per new asset (11.5) | metadata, no run effect |

The scope tripwire (`tools/check_ladder_bump.py`) will list the two autoloads
and `data/asset_provenance.json`. Each is presentation-only, so the squash
commit declares `Ladder-Impact: none -- presentation only: keybinds, a font
size step and asset provenance records; no run outcome changes`.

---

## 3. Layout in Godot

### 3.1 Canvas and stretch

- `project.godot`: viewport 1920x1080, `stretch/mode="canvas_items"`,
  `stretch/aspect="expand"` (`godot/project.godot:42-46`).
- **1280x720:** the same layout at 2/3 scale, like the mock-up's 720 renders.
  Text is rasterised at the scaled size (dynamic fonts, oversampling on), so a
  15 px label is about 10 px on screen. The contrast check (4.5) runs at both
  sizes.
- **Wider than 16:9** (for example 2560x1080): the canvas grows sideways. Left
  column anchored left, right column anchored right, papers centred, the room
  fills the rest (it is drawn `KEEP_ASPECT_COVERED`, `scenes/main.tscn:46`).
- **Taller than 16:9** (16:10): the canvas grows downward. Top items anchored
  top, bottom strip and bottom-anchored cards anchored bottom; the gap between
  the rail and the feed grows.
- Nothing may depend on the canvas being exactly 1920 wide. Use anchors and
  containers; never read `get_viewport().size` for layout except for centring
  papers (today's dialogs already do that).

### 3.2 Positions and anchors (1920x1080)

From G's renders (`hifi3/G/s1-s5.webp`). Width x height; L/T/R/B = anchored
to that edge.

| Element | Box | Anchors |
|---|---|---|
| TopStrip | 0,0 1920x56 | L, T, R (full width) |
| Dateline | 24,0 420x56 | L, T |
| ResourceStrip | from x 444, height 56 | L, T; shrinks first if crowded |
| Menu button | right 24, 0, ~106x56 | R, T |
| Banner | 0,56 1920x52 | L, T, R |
| Rail | 24,132, 232 wide; plates 52 tall, 10 apart; GUIDE after a 26 px gap | L, T |
| DoomCard | 1480,132 416x252 | R, T |
| AttentionCard | 1480, bottom 1004, 416 wide, height by content (274 min) | R, B |
| FeedPanel (WATCH) | 24, bottom 1004, 560x288 | L, B |
| BottomStrip | 0,1016 1920x64 | L, B, R |
| Feedback | 24,1032 | L, B |
| HeldPlate | 1276,1024 308x48 | R, B |
| CommitPlate | 1600,1024 296x48 | R, B |
| ActionsPanel | 280,132 600x872; detail card 904,544 480x272 | L, T and B |
| PlanPanel | 700,132 768x872 (right edge 1468) | R (offset from the right column), T and B |
| UpgradesPanel | 280,132 600x872 | L, T and B |
| Event paper | centred, top 132, 702 wide, height by content | centre, T |
| Review paper | centred, top 132, 700 wide | centre, T |
| AdvisorNote | 290,130 420 wide, arrow to the hinted plate | L, T |

Containers: TopStrip, Banner and BottomStrip are HBoxContainers inside
PanelContainers; the Rail is a VBoxContainer; cards are PanelContainers with
MarginContainers (16 px sides, 12 px between rows). Fixed sizes use
`custom_minimum_size`; nothing uses absolute `position` except papers (centred
on open) and the advisor note (placed beside its plate).

### 3.3 HTML/CSS features and their Godot equivalents

| Mock-up uses | No direct equal because | Godot build |
|---|---|---|
| `position:absolute` boxes | Godot lays out by anchors and containers | anchors per 3.2; containers inside cards |
| CSS `filter` (brightness, saturate, contrast, sepia) on the room and icons | no filters on CanvasItems | the room: one CanvasItem shader (5.14); icons: `self_modulate` for tone plus the pre-toned art; disabled icons `modulate.a = 0.45` |
| `mix-blend-mode` multiply / overlay / screen | `CanvasItemMaterial` has mix, add, sub, mul, premult only; no overlay or screen | overlay grain and multiply smut are computed inside the room shader on its own texture (no screen read); panel grime is baked into a texture; additive glows use `blend_mode = ADD` |
| `linear-gradient`, `radial-gradient` | no CSS gradients | `GradientTexture2D` (linear or radial fill) in a `TextureRect`; the paper gradient is in the paper texture |
| inset `box-shadow` (soot inside panels) | `StyleBoxFlat` shadows are outer only | `StyleBoxTexture` with a 9-slice grime texture that has the inner soot baked in (4.3) |
| outer glow (`box-shadow` with colour) on the P(Doom) card | as above | `StyleBoxFlat.shadow_color` / `shadow_size` (outer shadow works), colour = band stroke at 30% |
| dashed borders (disabled plates, inert Commit) | `StyleBoxFlat` draws solid borders only | a small `_draw()` using `draw_dashed_line` on the plate, or a 9-slice dashed texture |
| hatching (disabled) | none | `StyleBoxTexture` with a tiling 16x16 hatch texture (`axis_stretch` tile) |
| `letter-spacing` | `Label` has no tracking property | `FontVariation.spacing_glyph` (one FontVariation per tracked style in `g_theme.tres`) |
| `text-transform: uppercase` | -- | `Label.uppercase = true` |
| per-letter opacity and 0-1 px offsets (the worn ribbon) | a `Label` draws one style for all letters | `GDateline` draws each glyph with `draw_char` (5.1.1) |
| `@keyframes` type-on, fades, slides | -- | `Tween` (6) |
| SVG icons | Godot imports SVG to a bitmap at import size | the build uses PNGs from the art batches (11); no runtime SVG |
| `rem`/`px` font sizes | Pip's CI forbids literal sizes | `ThemeManager.get_font_size(step)` at runtime (4.2) |
| hover / focus CSS | -- | Button styleboxes: `normal`, `hover`, `pressed`, `disabled`, `focus` |
| `prefers-reduced-motion` | the game has no such setting | `GPrefs.reduced_motion` (6.5) |
| Web Audio synthesis | -- | pre-rendered WAV one-shots (7) |

---

## 4. Look

### 4.1 Colour tokens

G uses H's palette unchanged (H spec 2.2): void `#090807`; panel
`rgba(16,14,12,.95)`; panel-2 `#1a1612`; well `#0d0b0a`; frame
`rgba(196,176,138,.16)`; frame-hi `rgba(196,176,138,.28)`; tick `#6a573a`;
bone `#d6cebd`; muted `#aaa08e`; dim `#968d7c`; plan `#c9a465` / plan-fill
`#a8854b`; op `#93b3a9` / op-fill `#6c8f86`; amber `#d9a03a`; amber-line
`rgba(217,160,58,.62)`; warn `#d58a52`; blood `#9b3328`; held (neutral silver)
`#c9d2d8`; paper `#c3b79c -> #afa286`; ink `#1a140d`; ink-soft `#221b13`;
red ink `#3d0e08`; green ink `#0b2621`.

They live as named colours in `theme/g_theme.tres` (type `GColors`, via
`Theme.set_color(name, "GColors", c)`) and as a `const` dictionary in
`g_desk.gd` for code that draws. Amber marks at most one thing per screen
(H spec 2.2). Purple appears only in the room from band 5 and as the doom
colour itself.

Doom colours come from `ThemeManager` only: `get_doom_stroke_color`,
`get_doom_band_index`, `get_doom_status_label`, `DOOM_STATUS_BANDS`
(`autoload/theme_manager.gd:12-37, 488-526`). G adds no thresholds. Text in
the doom colour is lifted toward a pale tint of the stroke colour until it
reaches 5:1 on the card (7.5:1 for the lit ladder row), computed in
`g_doom_card.gd` with the WCAG formula; the arc keeps the game's stroke
colour (H spec 2.3). Today's `get_doom_stroke_color` leaves CATASTROPHIC text
near 1.8:1 on dark panels (H spec 7.2); the lift is G's own and does not change
`ThemeManager`.

### 4.2 Type and fonts

**Faces.** None is bundled today (`godot/assets/fonts/` holds only
`.gitkeep`). G bundles the four the mock-ups use, all under the SIL Open
Font License 1.1, so they may ship with the game:

| Family | Files (static TTF from the Google Fonts repository) | Used for |
|---|---|---|
| Barlow Condensed | Medium 500, SemiBold 600, Bold 700 | caps labels, plate names, panel heads (2 px tracking) |
| IBM Plex Mono | Regular 400, Medium 500, SemiBold 600 | every number, keycaps, hours, the feed |
| IBM Plex Sans | Regular 400, Medium 500 | names, notes, card text |
| Courier Prime | Regular 400, Bold 700 | the dateline and all paper |

- Folder: `godot/assets/fonts/<family>/`, with that family's `OFL.txt`.
- Import (`.ttf` -> `FontFile`): Godot 4.5.1's defaults, confirmed by the
  spike: antialiasing grayscale, hinting light, subpixel positioning "Auto
  Except Pixel Fonts", forced autohinter off, mipmaps off, MSDF off.
  The spike pinned exact upstream files with SHA-256s in
  `fork/design/godot-g/spikes/assets.tsv` (one weight per family); the build
  takes the other weights from the same pinned commits and adds them to that
  list. Fallback for every face: Godot's default font (so a
  missing file degrades to today's look, never to boxes).
- `g_theme.tres` sets `default_font` (IBM Plex Sans) and defines
  `FontVariation` resources for the tracked caps styles
  (`spacing_glyph = 2` for labels; the dateline sets its own spacing in code).
  It sets **no font sizes**, keeping `base_theme.tres` the one size lever
  (its header comment says it carries sizes only, `theme/base_theme.tres`).
- Licence and provenance: see 11.5 and open question Q9 (shipping a
  human-made font may count as the first human-made asset for Pip's
  provenance guard).

**Sizes.** `base_theme.tres` sets `default_font_size = 19`;
`ThemeManager.FONT_STEPS` gives small 15, body 19, header 27, title 35
(`theme_manager.gd:52-57`, `get_font_size` at `theme_manager.gd:337-346`).
G's mock-ups use 16, 18, 22, 28 and 40. The build:

| Mock-up | Used for | Token | Rendered |
|---|---|---|---|
| 16 | labels, keycaps, notes, plan rows | `small` | 15 |
| 18 | names, paper body, buttons | `body` | 19 |
| 22 | band name, section heads, level-3 values (compute, research, papers, reputation, Attention values) | **new `label` step, +3** | 22 |
| 28 | money value, the dateline | `header` | 27 |
| 40 | the P(Doom) percentage | `title` | 35 |

- Adding `"label": 3` to `FONT_STEPS` is additive: nothing existing changes
  size, and `tests/unit/test_font_size_ssot.gd` only checks small < body <
  header < title and the offsets of the existing keys
  (`test_font_size_ssot.gd:198-216`). Add a test line for `label`.
- Small stays 15, one pixel under the 16 px floor G was measured at. The
  contrast check (4.5) re-measures in Godot at 15. Moving `small` to 16 for the
  whole game is open question Q6.
- Every size is set in code: `add_theme_font_size_override("font_size",
  ThemeManager.get_font_size("label"))`. `tools/check_font_sizes.py` counts
  only literal sizes (`RUNTIME_RE`, readable with
  `git show HEAD:tools/check_font_sizes.py`), so calls that pass
  `get_font_size()` are not counted. The dateline and the arc text pass the
  size to `draw_char` / `draw_string`, which the tool does not count either.

### 4.3 Panels, grime and texture

- **Panels:** `StyleBoxTexture` using `assets/textures/g/panel_grime_9.png`
  (256x256, 9-slice margins 24): the panel fill with soot baked into the inner
  26 px (heavier along the bottom edge), low-frequency smut and fine grain at
  16%, Pip's `textures/surfaces/tex_painted_metal_panel_512.png` mixed in at
  5% for scuffs. Made by a script from noise (a texture, not a picture; 11).
  Frame hairline 1 px `frame`, drawn by a second `StyleBoxFlat` with
  `draw_center = false`, stacked with the texture through a `PanelContainer`
  inside a `PanelContainer` (or a `NinePatchRect` under a `StyleBoxFlat`
  border; the builder picks one and uses it everywhere).
- **Corner ticks:** four 12x2 + 2x12 brass ticks per panel, drawn in the
  panel's `_draw()` (cheap, crisp at any scale).
- **Raised rows, selected cells:** `StyleBoxFlat` `panel-2`, 2 px radius.
- **Disabled controls:** hatch texture (`assets/textures/g/hatch_16.png`,
  tiled) plus a dashed edge; the label keeps `dim` (never fade text, H spec
  2.8).
- **Keycaps:** `PanelContainer` with `StyleBoxFlat` (1 px `amber-line` or
  `frame-hi` border, 2 px radius), mono `small` text.
- **Paper:** `NinePatchRect` with `assets/textures/g/paper_sheet.png`
  (1024x1024, patch margins 64): tan, darker at the bottom, burnt edges,
  grime, worn corners. One fold crease is a separate 1 px `TextureRect` line
  placed in a gap between text rows (the mock-up moved folds off text,
  hifi3 G notes "Contrast"). The paper texture is a Sol picture (11);
  until it exists, a script-made gradient texture stands in.
- **Film grain:** over the room only (G notes item 5), inside the room shader
  (5.14). No whole-screen grain pass: G does not have one, and a screen-wide
  overlay blend would need a screen-texture read.
- Grime never sits under small text strongly enough to break 4.5:1; the
  contrast check proves it (4.5).

### 4.4 Hierarchy (upgrade 1)

From H spec 1.3, applied to G's layout:

1. **P(Doom) card**: the only panel framed in its own colour (border = band
   stroke at 55%, a 3 px top edge in the full colour, outer glow
   `shadow_size` 8 at 30%); percentage at `title`.
2. **Attention left and money**: the Attention card's hour bars and its two
   "N left" values at `label`; money is the first and larger resource cell
   (40 px icon plate, value at `header`).
3. **The plan**: the THIS MONTH list on the Attention card, the Plan drawer
   when open; compute, research, papers and reputation (32 px plates, values
   at `label`, labels in `dim`).
4. **Everything else**: rail plates (labels `small` in `muted`, icons at 82%
   opacity), the held plate, Feedback, and Commit, which stays muted until
   something is queued.

The dateline is a title, outside the ranking.

### 4.5 The contrast floor

Every text reaches 4.5:1 against what is really behind it, measured on the
game's own rendered pixels at 1920x1080 and 1280x720, with H's method
(H spec 2.8): background = median of the text box; text = the k-th pixel
farthest from it, k = max(4, 0.5% of the box).

In Godot:
- `tests/visual/g_capture.gd` (debug-only harness) saves a PNG of the viewport
  and a JSON list of every visible `Label` / `RichTextLabel` / `Button` text
  box (global rect at the capture size).
- `fork/design/godot-g/tools/contrast_godot.py` (a fork tool, adapted from
  `fork/design/hifi3/G/contrast.py`) reads both and prints the lowest ratio per
  state and every box under 4.5.
- G's three rules stay: disabled = hatch and dashed edge, not faded text; paper
  labels at small are bold and paper keycaps inverted; row numbers and small
  tags on dark panels use `muted`, not `dim`.

---

## 5. Components

Each part gives: the node tree, what drives it (read-only), its states, and
where it differs from the mock-up. "Refresh" means `GDesk._on_state(state)`,
connected to `GameManager.game_state_updated` after `main_ui`'s own handler,
plus the other signals named.

### 5.1 Top strip

#### 5.1.1 Dateline (upgrade 4)

- Node: `GDateline` (Control, 420x56). Draws each glyph with
  `draw_char(font, pos, ch, size, modulate)`: Courier Prime Bold,
  `get_font_size("header")` (27), 5 px extra advance per glyph, colour
  `#d9d1bf`, upper case.
- Text: `"%s %d, %d" % [Clock.MONTH_NAMES[m-1].to_upper(), day, year]` from
  `state["calendar"]` (`scripts/core/game_state.gd:1263-1266`,
  `scripts/core/clock.gd:138`). Date only; no place.
- Worn ribbon: per glyph i, opacity `[1, .86, .97, .9, 1, .82, .95, 1, .88][i % 9]`
  and y offset `[0, 1, 0, 0, 1, 0, 0, 1, 0][i % 9]` px (the mock-up's fixed
  pattern, H spec 3.3: "fixed, not random"). Copy the exact arrays from
  `hifi3/H/concept.html` `RIB_OP` / `RIB_DY`.
- States:
  - **set**: all glyphs drawn;
  - **typing**: glyphs 0..n drawn, a caret block after the last one;
  - **busy-tail**: all glyphs drawn, sound tail still ringing (7.3).
- When it types (decided from what the UI sees, no game change):
  - **new game**: the first state after `start_new_game` (`main_ui._boot_game`,
    `main_ui.gd:827`);
  - **a new month**: a state whose (year, month) differs from the last shown
    while the run is live. The boundary tick's state arrives just before the
    month review (`game_manager.gd:778-799` then `_finish_month_playback`,
    `game_manager.gd:802-883`), so the date types as the review appears, as in
    G's state 5.
- When it does not type: inside a month the day changes in place (WATCH,
  "NOVEMBER 14, 2017"); on **load** and on **resume after a conference**
  (`main_ui.gd:802-806`) the date is shown set.
- Timing and sound: section 7.

#### 5.1.2 Resource cells, take a: tier icons (upgrade 3, default)

- Five `GResourceCell`s: money, compute, research, papers, reputation.
  Each: icon plate (dark square, 40 px for money, 32 px for the rest) with a
  `TextureRect` tier icon; caps label (`small`, `dim`); value (mono; `header`
  for money, `label` for the rest; `bone`, or `warn` when negative); an
  optional tag.
- **One shown amount drives the cell** (H spec 3.2): `shown = sign(raw) *
  round_half_away(abs(raw))`, matching `GameConfig.format_money` /
  `format_scalar` (`autoload/game_config.gd:674-693`). The value text is
  `GameConfig.format_money(raw)` or `format_scalar(raw)` exactly as today's
  top bar (`main_ui.gd:1146-1150`), so the number never differs from classic.
  The tier, the warn colour, the tag and every trace sample read `shown`.
  "-0" prints as today (H report bug list).
- Tier table (`GTiers.TIERS`, upper bounds of tiers 0-3; tier 4 is above):

| Resource | Tier 0 | Tier 1 | Tier 2 | Tier 3 | Tier 4 |
|---|---|---|---|---|---|
| money | <= 0 | <= 20,000 | <= 99,999 | <= 249,999 | above |
| compute | <= 0 | <= 49 | <= 99 | <= 199 | above |
| research | <= 0 | <= 9 | <= 19 | <= 49 | above |
| papers | <= 0 | <= 1 | <= 4 | <= 9 | above |
| reputation | <= 0 | <= 20 | <= 30 | <= 60 | above |

  20,000 is the game's low-funds line (`main_ui.gd:1021`); 20 and 30 its
  reputation warnings (`main_ui.gd:1015-1017`); the rest are round steps
  (open question Q7).
- **Tags** (hairline, not filled): money `LOW` (warn) when shown <= 20,000;
  reputation `LOW` (amber) when <= 30, (warn) when <= 20; research
  `BELOW ZERO` (warn) when shown < 0. These restate thresholds the game
  already warns on at Commit (`main_ui.gd:1015-1023`); `BELOW ZERO` restates
  the sign already printed.
- **Reputation**: drawn once, then a 12 px gap and a 1 px rule, then
  "**0** ends the run" (`small`, `muted`, the 0 in `blood`). True to the code:
  reputation <= 0 ends the run (`scripts/core/game_state.gd:791`). G's
  semicircle reputation gauge is not built.
- Tooltips: keep today's resource tooltips (`main_ui._apply_balance_tooltips`,
  `main_ui.gd:783-794`) on the matching cells.
- Width: the strip is an HBox from x 444 to the menu button; cells keep their
  minimum width and the separation (24 px) shrinks first if crowded.

#### 5.1.3 Resource cells, take b: trace windows (upgrade 5)

- Chosen by `GPrefs.resources = "traces"`. Each icon plate becomes a small
  "monitor" (`GResourceCell` draws a polyline in `_draw()`): 48x46 for money,
  40x40 for the rest, `well` fill, 1 px `frame-hi` border.
- Points: the shown amount at the start of each month the UI has seen
  (5.1.4), plus the current shown amount as the last point. No forecast.
- Auto-scale: y from the line's own min to max (flat line in the middle if
  they are equal). If the line crosses 0, a dashed `blood` zero line.
- No doom trace (ADR-0015 reading).
- Caption: the strip's first cell, "TRACE" over "since <Mon YYYY>" (the first
  recorded month); with one point, "no history yet" and a flat dashed line.
- In month 1 of a new run, and right after a load, each window has one point.

#### 5.1.4 Where trace history comes from

- `GResourceHistory` (static vars in `scripts/ui/g/g_resource_history.gd`, so
  it survives the conference scene change and `main.tscn` re-entry) keeps up
  to 24 samples `{year, month, money, compute, research, papers, reputation}`
  of **shown** amounts.
- `GDesk._on_state`: if `state.calendar` (year, month) differs from the last
  sample's, append one sample from this state. The first state of a new game
  is month 1's sample.
- Cleared in `main_ui._boot_game` on the new-game branch and the load branch
  (before `start_new_game` / `load_saved_game`, `main_ui.gd:811-827`); kept on
  `resume_in_place` (`main_ui.gd:802-806`).
- It records nothing the player did not see on screen, writes nothing to
  game state, and is not saved. A loaded save starts with no history; the
  caption says so ("since <load month>").

#### 5.1.5 Menu

- Button "MENU" with icon `icons/main_navigation/ui_system_settings_64.png`
  and keycap `Esc`. Click: `pause_menu.show_pause_menu()` (same as Esc with no
  modal, `main_ui.gd:504-510`). The Esc keycap hides whenever a modal is open
  (only the top layer shows Esc).

### 5.2 Banner, view switch and WATCH playback

- `ModeLabel`: `## PLAN` (amber) or `## WATCH` (amber), Barlow 600 caps,
  `label`. G drops today's long banner sentence (`screen_mode.gd:178-186`).
- `ViewSwitch`: a two-segment control PLAN | WATCH, the current one with an
  amber underline, plus a `V` keycap. Click: `screen_mode.toggle_mode()`
  (`screen_mode.gd:143-149`); V stays `toggle_view` in `main_ui._input`
  (`main_ui.gd:574-578`). While an event waits for a reply the switch is drawn
  inert (dashed) and its keycap hidden; V is already blocked then because the
  dialog block eats it (`main_ui.gd:521-569`).
- `PlaybackBar` (WATCH only): one segment per workday of the month, today's
  segment marked, then "workday N of M". N and M come from pure calls on
  `Clock` (`Clock.month_index` over the month's turns, `clock.gd:146`) with
  `state.turn`; G computes them, the game does not change. After the boundary:
  bar full and "<Month> played out".
- `SpeedSegments` (WATCH only): `||` (inert, lit while an event has paused
  playback), 1x, 2x, 4x. 1x/2x/4x emit `screen_mode.speed_changed` with
  today's values (0.20/0.10/0.05 s, `screen_mode.gd:37`); `main_ui` already
  maps that to `game_manager.day_tick_seconds` (`main_ui.gd:390`). The pause
  segment stays a display, as today's pause is a stub (`screen_mode.gd:96-101`).

### 5.3 The rail

- Five plates (`Button` subclasses with a custom stylebox set): icon tile 36 px
  with a 28 px icon, caps name, an optional status at the right, keycap.
- Plates, icons (Pip's, paths under `godot/assets/icons/`), status and click:

| Plate | Icon | Status | Click / key |
|---|---|---|---|
| ACTIONS | `main_navigation/ui_guide_actions_64.png` | -- | toggle ActionsPanel / A |
| UPGRADES | `buttons_normal/button_upgrade_normal_64.png` | -- | toggle UpgradesPanel / U |
| STAFF | `main_navigation/ui_staff_management_64.png` | `state.total_staff` | `main_ui._on_open_employee_screen()` (`main_ui.gd:1084-1089`) / E |
| LEDGER | `main_navigation/ui_budget_finance_64.png` | `ledger_screen.summary_word()` | `main_ui._show_ledger_screen()` (`main_ui.gd:1972`) / L (today's bind) |
| GUIDE | `main_navigation/ui_guide_book_64.png` | -- | open the guide embedded (5.9.4) / F1 |

- States: rest; lit (its sheet is open: amber left edge and keycap); hint
  (amber ring, slow alpha pulse, 5.13); disabled (WATCH: ACTIONS and UPGRADES
  dashed and hatched, no keycap); keys hidden (any modal other than a G sheet
  is on top: no plate shows a keycap).
- Pip's rail colour: a 3 px dark aubergine left edge on every plate (G notes
  "Removed": kept as a trace; open question in G notes, default kept).

### 5.4 P(Doom) card

- Node: `GDoomCard` (PanelContainer, custom `_draw` for the arc).
  Header: `icons/doom.png` 24 px + "P(DOOM)"; from band index 5, the right
  side of the header reads "Very close to game over" (the game's own words,
  `main_ui.gd:1010`).
- Arc: 270-degree ring (G's look: 16 px stroke on a faint track, no glow),
  `draw_arc(center, r, start, end, 64, color, 16, true)`; colour
  `ThemeManager.get_doom_stroke_color(doom)`; a fine tick at each band edge.
- In the ring: the percentage, `"%.1f%%" % doom` exactly as today
  (`main_ui.gd:1232`), `title`, lifted text colour (4.1). Right of the ring:
  band name (`label`, lifted colour, never wraps; long names fit at `label`
  because the column is 180 px), a RISING tag (hairline, warn) when
  `state.doom_system.doom_trend` is `increasing` or `strongly_increasing`
  (`scripts/core/doom_system.gd:469-479`), the seven-chip band ladder (current
  chip larger), and "band N of 7" (N = index + 1).
- Click anywhere on the card: today's expanded trend dialog,
  `main_ui._show_doom_trend_expanded()` (`main_ui.gd:1844-1902`). In G that
  dialog also shows today's per-source breakdown below the graph (the same
  `DoomBreakdown` node type, `scripts/ui/doom_breakdown.gd`), so nothing the
  home screen showed before is lost; it is one click away (10.9).
- Data: `state.doom`, `state.doom_system.doom_trend`. No momentum number (10.9).
- States: normal; rising; warning (band >= 5). Transition: 6.2.

### 5.5 Attention card

- Node: `GAttentionCard` (PanelContainer), bottom-anchored, three faces:

**PLAN face** (G states 1-3):
- Header: hourglass `icons/resources/resource_action_points_64.png` +
  "ATTENTION", right "N hr this month" (`month_plan.attention_total`).
- Two rows of hour cells, 16x26 px each: PLANNING (`plan-fill`), OPERATING
  (`op-fill`); filled = hours left. Counts: `state.planning_hours_left` and
  `state.operating_hours_left` (`game_state.gd` `to_dict`, read at
  `main_ui.gd:1201-1204`); totals = left + spent per pool from
  `state.month_plan` (MonthPlan's own fields). "N left" at `label`, warn when 0.
- No hatched spill cell and no spill legend (10.1).
- "Reserved: N hr" when `month_plan.attention_reserved > 0`.
- THIS MONTH: the queued plays in short (`plan_controller.queued_actions`),
  repeats grouped "Read the Literature x2" with the row range "2-3"; "Nothing
  queued yet" when empty; a total line "N plays" and the money total from
  `plan_controller.calculate_queued_costs()` (`scripts/ui/plan_controller.gd:39`).
- Button: "CHOOSE ACTIONS [A]" when empty, "OPEN PLAN [Q]" otherwise; when
  the drawer is open "CLOSE PLAN [Q]".
- Refresh: state updates and `main_ui.queue_view_changed`.

**WATCH face** (G state 4):
- Header right "held after Commit".
- HELD: one silver cell per held hour, "N left". N = today's WATCH reserve
  readout: `attention_reserved` if > 0, else `attention_total -
  attention_spent` (`screen_mode.gd:162-176`).
- "Spent at Commit": `month_plan.attention_spent` captured at the first WATCH
  state.
- While an event waits: "This reply would cost N hr", N = the Attention price
  the event dialog itself shows (`WindowResolver.present_for_dialog` stamps
  it, `game_manager.gd:795-799`; read it from the event dict the dialog was
  given).
- STAFF AT WORK: role icon + count per role from `state.safety_researchers`,
  `capability_researchers`, `compute_engineers`, `managers`.

**Closed face** (under the month review, G state 5):
- "<Month>, closed": held 0 left; "Used on events N hr" = held at WATCH start
  minus held at month end; "Unspent, evaporated N hr" = held at month end.
  All from values the UI saw; the review's own words already say unspent
  hours evaporate (`game_manager.gd:836`). G does not name which event used
  the hours (10.6).

### 5.6 Bottom strip: Feedback, held plate, Commit

- **Feedback**: `icons/ui_controls/ui_control_bug_64.png` + "FEEDBACK" + keycap
  N; click `main_ui._open_bug_report_panel()` (`main_ui.gd:1095-1107`); N is
  today's bind.
- **Held plate** (PLAN only): "HELD FOR EVENTS" + "up to N hr", N =
  `attention_total - attention_spent - attention_reserved` + reserved, i.e.
  every hour not spent on plays. "up to", because plays that charge
  themselves (the hiring pipeline) debit more hours at Commit
  (`game_manager.gd:715-730`), so the hold after Commit can be smaller. In
  WATCH the Attention card carries the hold and the plate is hidden.
- **Commit plate** (296x48): "COMMIT THE MONTH", Barlow 700 caps, `label`.
  - idle (nothing queued): muted text, plain hairline, `Enter` keycap shown;
  - ready (something queued): amber hairline and text;
  - hidden Enter: while any modal or G sheet is open (only the top layer
    shows Enter);
  - WATCH: "MONTH IN PLAY", dashed, inert; after the boundary "MONTH COMPLETE".
  - Click: **the same handler as Enter today**,
    `main_ui._on_commit_plan_button_pressed()` (`main_ui.gd:1053-1077`), and
    only when `commit_plan_button.disabled` is false (that button's state is
    still maintained by `_on_turn_phase_changed`, `main_ui.gd:1407-1441`).
    Space keeps `end_turn` (`main_ui.gd:595-599`). G draws one button; both
    keys keep today's two paths (10.7).

### 5.7 Actions sheet (A)

#### 5.7.1 Content

- Header: icon + "ACTIONS", right "Hours left: N plan, M op" (pool colours) and
  an `x` button.
- Rows: the list `ActionBarRenderer.render` already builds, **in the same
  order and with the same filters** (hidden ids
  `HIDDEN_FROM_ACTION_BAR_IDS`, coming-soon ids, locks;
  `scripts/ui/action_bar_renderer.gd:73-83, 95-183`). The renderer hands the
  ordered list to GDesk when the layout is g; the flat grid is still built
  for keys 1-9 (2.2).
- Row (height 44, `Button` with custom content): icon on a 40 px dark tile;
  name (`body`); a second line (`small`, `muted`):
  - **door** (`action.is_submenu`): "N choices" (`submenu_controller.option_count(id)`;
    for the bespoke hiring, financing and travel builders that have no option
    list, the line reads "choices" without a count) and a `>` tab;
  - **play**: its hours and pool from `GameActions.attention_cost` /
    `GameActions.hour_type`, its costs formatted with today's
    `_format_costs_inline` (`main_ui.gd:1914-1937`), and a `+` tab;
  - "N in plan" chip when the plan holds that id.
- Number keycaps 1-9 on the first nine rows (the same slots as today's
  action bar, 8.1).
- Row states: rest; hover/focus (amber hairline); queued (chip); blocked
  (hatched, dashed edge, reason in `warn`):
  - "x N <resource> short" from the action's costs minus shown amounts
    (the same comparison `_costs_affordable` makes, `main_ui.gd:1939-1955`);
  - "x needs N <pool> hr" when the action's own pool is short, which is the
    test today's click applies (`main_ui.gd:1736-1739`; 10.1);
  - coming soon: "COMING SOON" chip, as the renderer labels it.
- First-lever hint: the row whose id is `_first_lever_action_id()` pulses
  like the rail plate (5.13).

#### 5.7.2 Detail card

- For the focused row (hover or keyboard focus): name, the data's
  description, hours and costs, a fit line ("N operating hours left, $M left
  after the plan so far": money shown minus `calculate_queued_costs().money`),
  and two buttons: **ADD TO PLAN** (plays) or **OPEN** (doors), and **BACK**.
- No Enter keycap: today's code blocks Enter while a modal is up and Pip's
  ruling keeps Enter for Commit only (`main_ui.dialog_key_advances`,
  `main_ui.gd:706-723`; 10.4). ADD TO PLAN is clicked, or the row's number
  key is pressed.
- It replaces today's hover info line (`InfoLabel`, filled by
  `_on_action_hover`, `main_ui.gd:2184-2230`), which G hides.

#### 5.7.3 Clicks and keys

- Row click or ADD TO PLAN / OPEN: `main_ui._on_dynamic_action_pressed(id,
  name)` (`main_ui.gd:1699-1752`), the same handler the action bar uses, with
  the same refusals and toasts.
- Number keys 1-9 while the sheet is top: `main_ui._trigger_action_by_index(i)`
  (identical to the desk).
- A or Esc or `x`: close. U: switch to Upgrades. Q: switch to the Plan drawer.

#### 5.7.4 Doors

- `_open_submenu(id, anchor)` builds today's submenu (`main_ui.gd:672-680`,
  `submenu_controller.open`). ModalStack pops the Actions sheet first
  (2.4). G passes the row as `anchor` so the submenu sits beside the sheet's
  right edge (`SubmenuChrome.align_to_button`).
- When that submenu leaves the tree by any path, GDesk re-presents the Actions
  sheet if (a) the sheet opened it, (b) no other modal is now on top, and
  (c) the phase is still plan. So Esc from a door goes back to the sheet, and
  Esc again goes to the desk.
- The submenus keep their own keys (Q W E... per option, `DialogKeys`) and
  close affordance. In G they get the G panel stylebox
  (`SubmenuChrome.style_panel` swapped when the layout is g); no content change.

### 5.8 Plan drawer (Q)

- Header: "THE MONTH AHEAD", "runs top to bottom", `x`, `Esc` keycap.
- Column heads: #, PLAY, HOURS, COST, (remove).
- One row per entry of `plan_controller.queued_actions`, in order: number;
  icon; name and where it lives (its category, from the action data);
  hours and pool; cost (`_format_costs_inline` of that action's costs, "--"
  when none); an `x` button.
  - `x` calls `main_ui._remove_queued_action(id, name)` (`main_ui.gd:976-987`).
    For repeated plays this removes the **first** queued copy of that id, as
    today's tiles do (`plan_controller.gd:76-84`), whichever row was clicked;
    the list then redraws (10.3).
  - No up/down: the queue has no reorder operation today (16).
- Total row: "Total: N plays", hours per pool, and the money (+ other costs)
  from `calculate_queued_costs()`. AFTER THESE COSTS: shown money minus the
  queued money cost, reputation minus queued reputation cost. Results of
  plays are not included (open question Q5).
- RESEARCH QUALITY: today's `research_quality_selector`, reparented in (2.2).
- UNDER WAY: today's in-flight hiring box, reparented in (2.2); hidden when
  empty.
- Footer buttons: UNDO [Z] (`_on_undo_last_button_pressed`,
  `main_ui.gd:952-963`), CLEAR [C] (`_on_clear_queue_button_pressed`,
  `main_ui.gd:965-974`), RESERVE HOURS [R] (`_on_reserve_ap_button_pressed`,
  `main_ui.gd:947-950`). Each mirrors the disabled state of today's button
  (`undo_last_button`, `clear_queue_button`, `reserve_ap_button`); Reserve is
  disabled when no operating hours are left, as today (`main_ui.gd:1278-1281`;
  10.2).
- While open: Commit shows no Enter; the Attention card shows CLOSE PLAN [Q].
- Many rows: the row list is a `ScrollContainer` between a fixed header and
  a fixed total row; the footer never moves (research G notes, fix 9).

### 5.9 Upgrades, Staff, Ledger, Guide

#### 5.9.1 Upgrades sheet (U)

- Header "UPGRADES", `x`. Body: today's upgrades label and scroll, reparented
  (2.2). `main_ui._populate_upgrades()` keeps filling it
  (`main_ui.gd:1605-1664`) on every state update, so content, prices,
  affordability and clicks are today's. G restyles the row buttons through
  `g_theme.tres` type variations only.

#### 5.9.2 Staff (E)

- Opens today's Employee screen through `TabManager` (`main_ui.gd:1084-1089`).
  Not redrawn in this build. Esc returns, as today (`tab_manager.gd:31-36`).

#### 5.9.3 Ledger (L)

- Today's ledger screen (`main_ui._show_ledger_screen`, `main_ui.gd:1972`),
  with the L toggle at `main_ui.gd:494-502`. Not redrawn; G panel stylebox
  only.

#### 5.9.4 Guide (F1)

- Today the guide is a separate scene whose Back and Esc go to the welcome
  screen (`scripts/ui/player_guide.gd:7-16`). Changing scene mid-run without
  a resume flag would start a fresh game when the player came back
  (`main_ui._boot_game`, `main_ui.gd:796-827`).
- G instances `scenes/player_guide.tscn` as an overlay inside `TabManager`,
  registered in ModalStack (`kind "g_guide"`, close mode FREE), and sets a new
  `embedded = true` on it. `player_guide.gd` in embedded mode closes itself
  (`queue_free`) on Back and Esc instead of calling `SceneTransition`. No
  scene change happens.

### 5.10 Feed (WATCH)

- Node: `GFeedPanel` (PanelContainer, bottom-left). Header "FEED" and the
  month. Body: a `RichTextLabel` rendered from `main_ui._feed_lines` with the
  same filters as today's feed (`main_ui.gd:1505-1566`; G renders from the
  model, it does not move `message_log`). Lines show the day (mono, `muted`)
  and the game's message; the newest line has an amber left edge.
- Folding: lines from the same day beyond the newest four collapse into
  "+ N more lines from <Day D Mon>". The full log is one click away: clicking
  the header shows today's WatchScreen feed in a G sheet-sized overlay (or the
  feed panel grows to the rail's top; builder's choice, documented).
- Filters: the two toggles today's WatchScreen owns (`feed_filter_button`,
  `rivals_filter_button`) are shown in the feed header as small text
  toggles wired to `main_ui._on_feed_filter_changed` /
  `_on_rivals_filter_changed`.
- While an event waits for a reply: no keycaps in the feed.
- The WATCH office floor (WatchScreen's walkers, ADR-0018) is hidden in G with
  the rest of WatchScreen (open question Q11).

### 5.11 Event paper

- The event dialog is today's (`scripts/ui/event_dialog.gd`), with today's
  queue, blocker, buttons, keys and priority (`PRIORITY_MUST_ANSWER`, #452).
  When the layout is g, `event_dialog._show_next_event` asks `GPaper` to style
  the panel it builds: paper 9-slice background, ink text, "ACROSS YOUR DESK"
  heading, an ink "NEEDS A REPLY" stamp for events that wait, option rows as
  paper rows with the option's key tile (`DialogKeys.label_for(i)`: Q, W, E),
  text, effect and cost in bold ink. Footer: money shown and held hours.
- Keys: Q W E (and 1 2 3 as today's hidden alias). No Enter, no selected-row
  state, no Enter keycap (10.4). Esc does nothing (swallowed, #452,
  `modal_stack.gd:162-172`).
- No picture (open question Q12).

### 5.12 Month review paper

- Today's review is an event of type popup with a `review` payload
  (`game_manager.gd:846-882`), drawn by `MonthReviewPanel` as a clipboard
  (`scripts/ui/month_review_panel.gd`). In G, `MonthReviewPanel` uses the G
  paper (no board), Courier Prime ink, "MONTH REVIEW" and the period at the
  top, the lede, the attention line, LAST MONTH'S MOVEMENT rows (bold, as G
  measured), rivals only when the payload has them.
- **The words are the payload's**, unchanged (MonthReviewPanel "rewrites no
  wording"). G's rewritten attention line ("12 planning and 8 operating...")
  and the dropped closing line are not built (10.5).
- The button "Begin planning <Month YYYY>": today's keys, Space (`space_advances`
  meta, `main_ui.gd:543-552`) and its DialogKeys letter; keycap shows `Space`.
  No Enter (10.4).
- Behind it: the desk dimmed by the barrier; Commit shows MONTH COMPLETE; the
  dateline types the new month (5.1.1).

### 5.13 Advisor note (the cold-open hand-off)

- Shown when `GameConfig.show_first_lever_hint` is true (set by the cold open;
  `main_ui._apply_first_lever_nudge`, `main_ui.gd:1580-1597`). Not modal: it
  closes with its `x`; Esc keeps opening the menu and Enter keeps committing.
- Paper note 420 wide beside the rail with a thin amber arrow to the ACTIONS
  plate. Title "ADVISOR". Body: `GameConfig.first_lever_hint_text` with a
  leading `"Advisor: "` and a trailing `" (the glowing button)."` removed when
  present (exact string checks, unit-tested), then a second line
  "<Action name> is in Actions, the glowing button." where the name comes from
  the action data for `_first_lever_action_id()`.
- The ACTIONS plate and, inside the sheet, that action's row pulse (alpha
  1.0 -> 0.4 -> 1.0, 0.6 s each way, as today's nudge).
- It goes away when `_clear_first_lever_nudge` runs (first use of the lever,
  or turn 3, `main_ui.gd:1258-1262`), or with its x (the x only hides the note
  for this session; it does not change `GameConfig`).
- It replaces today's getting-started hint line, which G hides.

### 5.14 The room and its doom layer (upgrade 2)

- **Base:** today's `Backdrop` (`office_wide_day.webp`, 1536x1024,
  `KEEP_ASPECT_COVERED`). G sets its modulate to white and gives it a
  `ShaderMaterial` with `assets/shaders/g_room_doom.gdshader` (CanvasItem
  shader). UV in the shader is the texture's UV, so mask textures authored
  at 1536x1024 line up whatever the crop.
- **Band:** `ThemeManager.get_doom_band_index(state.doom)`, never the month.
- **The one shader** does, per pixel of the room:
  1. brightness, saturation and contrast from the band table;
  2. a grade (mix toward the band's tint by its amount);
  3. window sky: inside `window_mask` (a 1536x1024 R8 mask of the window
     panes), mix toward the band's sky colour;
  4. smut: multiply by a low-frequency noise texture at the band's amount;
  5. grain: overlay blend of a fine noise texture at the band's amount,
     computed on the shader's own colour (no screen read);
  6. vignette: darken by distance from centre at the band's amount;
  7. band 6 only: fire light, a warm gradient rising from the bottom edge.
  Uniforms: `band` (float 0.0-6.0), `grain_offset` (vec2), `effects`
  (float 0/1, the `simple` mode switch for tests). Textures: `window_mask`,
  `noise_lo`, `noise_hi` (tiling 256x256, made by script).
- **Band table:** H spec 2.4 exactly (brightness .80/.70/.61/.50/.44/.38/.31;
  saturation .70/.58/.46/.38/.32/.28/.26; contrast 1.03..1.18; grade, glow,
  sky; vignette 18..72%; grain 7..26%; smut 0..24%). It lives as `const`
  arrays inside the shader, which blends the two bands either side of the
  float `band` (the spike's design, `spikes/doom_layer.gdshader`, proven to
  tween smoothly on both renderers). `g_room.gd` keeps a copy of the glow and
  smoke columns for the sprite layers.
- **Glow on the lit CRTs:** two `TextureRect`s in `GDesk/RoomLayers` with a
  `GradientTexture2D` radial fill, `CanvasItemMaterial.blend_mode = ADD`,
  placed over the two lit monitors of `office_wide_day` (positions measured in
  texture pixels and converted through the Backdrop's covered rect on resize),
  `self_modulate` = the band's glow colour (amber, amber, orange, red-orange,
  red, violet, violet) at the band's strength. No art needed.
- **Floor smoke** (bands 5-6): a `TextureRect` with `smoke_floor.png` (a Sol
  picture, 11), bottom-anchored over the room, `self_modulate` violet at the
  band's amount; it drifts sideways 40 px over 20 s and back (a looping Tween
  on a pausable node, so it freezes in pause). Off with reduced motion
  (static).
- **Layering:** Backdrop (shader) < RoomLayers (glows, smoke) < every panel.
  Panels never change with the band.
- **Band change:** tween the one `band` uniform (and the glow and smoke
  strengths) from the current value to the new band index over 1.2 s, ease
  in-out (6.2). Reduced motion: instant.
- **Grain does not use `TIME`.** Shader `TIME` keeps running while the tree is
  paused, and PAUSE_SEMANTICS says presentation freezes in pause
  (`docs/design/PAUSE_SEMANTICS.md`, the table). `g_room.gd` moves
  `grain_offset` in `_process` at 12 steps a second (a pausable node), so
  grain freezes with the game. With reduced motion, grain is static.
- **Room effects setting:** `full` = as above; `simple` = no shader: Backdrop
  `modulate` = brightness x grade tint for the band, glows kept, no smoke,
  grain or sky; `off` = today's 0.35 modulate and scrim (the classic room).
  `simple` is also the automatic fallback if the shader fails to compile
  (check `material.shader` compile in a one-frame probe at setup; on failure
  log once and switch to `simple`).
- **Renderer:** `project.godot` sets no rendering method, so desktop runs use
  Forward+ (Vulkan), with Godot's own fallback to Compatibility (OpenGL) if
  Vulkan is missing. The spike compiled and rendered the band shader on both
  (13.1). The shader uses nothing renderer-specific (no
  `hint_screen_texture`, no compute).
- **Cost:** one full-screen fragment shader with three texture reads and
  simple math, plus two additive quads and one smoke quad. On this box the
  spike could only measure on the CPU rasteriser (llvmpipe): +9.7 ms mean per
  frame. That number says nothing about a real GPU. Phase 3's exit check is
  one measurement on Alex's PC (plain vs graded room, full UI, 1920x1080, same
  VSync); if the graded room costs more than 2 ms a frame there, `simple`
  becomes the default.
- **Band 6 is very dark.** The spike's day art at band 6 averaged luma 0.014
  before any monitor glow, window sky or fire light. Phase 3 must check the
  terminal look with those lights in, and the contrast check (4.5) must pass
  on the band 6 shots; if the room reads as black, lift band 6's brightness
  floor in the table (a G-only look value, not a game value) and say so in
  the phase report.

---

## 6. Motion

### 6.1 Tween or AnimationPlayer

Tweens everywhere. Every animation here is short, data-driven (its target
depends on state) and created from code on the node it animates, so a Tween
fits; there is no hand-keyed timeline for an AnimationPlayer. Rules:

- Create tweens with `create_tween()` on the animated node (or its sheet), so
  they inherit that node's pausable process mode (PAUSE_SEMANTICS: "Tweens
  inherit the process mode of the node that created them").
- Keep a reference per animated thing; before starting a new one, `kill()` the
  old and start from the current value (never from the old start), so rapid
  input never stacks animations.
- No `create_timer` in G. If one is ever needed, pass `false` (stops in pause).

### 6.2 Transition table

| What | How | Duration | Input during it | Reduced motion |
|---|---|---|---|---|
| Dateline type-on | Tween of `visible_count` with a callback per letter that also plays its strike (7.2) | ~1.6 s for "NOVEMBER 1, 2017", +0.56 s carriage return, +0.7 s tail | never blocks input; a new date while typing: kill, show the new date set, no sound (7.3) | shown set, no sound |
| Sheet open (Actions, Plan, Upgrades) | modulate.a 0 -> 1 and position x -8 -> 0 | 0.12 s, ease out | the sheet is top from the first frame and takes keys and clicks; Esc / its letter mid-open: kill, hide at once | instant |
| Sheet close | modulate.a 1 -> 0 | 0.08 s | hidden from ModalStack at once (input goes to the desk at once); a re-open mid-close kills the close | instant |
| Switch sheet (A with Plan open) | close the old (0.08) and open the new (0.12) at the same time | 0.12 s | as above | instant |
| PLAN <-> WATCH | the feed panel and WATCH strip fade in (0.15); PLAN-only parts hide at once | 0.15 s | V and phase changes are immediate; a second flip mid-fade kills the fade | instant |
| Event paper arrives | modulate.a 0 -> 1, y +12 -> 0 | 0.2 s | the dialog's buttons are live at once (today's), so a key pressed during the fade answers | instant |
| Month review arrives | as the event paper, while the dateline types | 0.2 s | Space advances at once (today's); the dateline keeps typing and is cut to set by the next state | instant |
| Room steps band | tween shader uniforms and glow strength, old -> new | 1.2 s, ease in-out | none (display only); a further band change mid-tween starts from the current values | instant |
| P(Doom) arc | the arc's drawn value tweens old -> new; the % text and band name switch at once | 0.4 s, ease out | none | instant |
| Band ladder | the lit chip switches when the band changes (no tween) | -- | -- | -- |
| First-lever pulse | looping alpha 1 -> 0.4 -> 1 | 0.6 s each way | -- | a steady amber ring, no pulse |
| Commit idle -> ready | stylebox swap | instant | -- | -- |
| Tier icon change | crossfade old -> new icon (two TextureRects) | 0.25 s | -- | instant |

Why the % text does not count up: a counting number would show in-between
values the game never had; the band and level jump, the arc eases.

### 6.3 Pause (`docs/design/PAUSE_SEMANTICS.md`)

- The pause menu sets `SceneTree.paused` (`scripts/ui/pause_menu.gd:114-124`).
  Everything in GDesk is `PROCESS_MODE_PAUSABLE` (the default), so in pause:
  every G tween freezes, the dateline stops mid-word, strike playback pauses
  (an `AudioStreamPlayer` with a pausable process mode pauses its streams),
  the room's grain and smoke stop, and on unpause all continue from where they
  were.
- Nothing in G is `PROCESS_MODE_ALWAYS`.
- The month-playback timer is already pausable (`game_manager.gd:773`), so no
  state changes under the pause menu and the dateline cannot be told about a
  new month while paused.

### 6.4 Esc (`docs/game-design/UI_ESCAPE_CONTRACT.md`)

- Order of precedence, top first, all through today's code:
  1. an unanswered event: Esc swallowed (#452, `modal_stack.handle_escape`);
  2. any other modal, including G sheets, the guide overlay, submenus, the
     ledger and the trend dialog: Esc closes the top one only
     (`main_ui.gd:554-560`);
  3. nothing open: Esc opens the pause menu (`main_ui.gd:504-510`).
- Each G sheet and the options modal also carries `EscToClose` and a visible
  `x`, so `test_ui_no_dead_ends.gd` passes on its own.
- The advisor note is not modal (5.13): Esc does not close it; its x does.
- Esc during a sheet's open tween: closes it (6.2).

### 6.5 Reduced motion

- The game has no reduced-motion setting, and settings persist through
  `game_config.gd` (bug fixes only). G keeps its own flag in `GPrefs`
  (`user://g_ui.cfg`), shown in the G desk options modal.
- With it on: every row of 6.2 takes its "Reduced motion" column; the dateline
  shows set and plays no sound; the room changes band instantly; grain and
  smoke are static; the first-lever pulse is a steady ring.
- Whether reduced motion should become a game-wide setting in `game_config` is
  open question Q8.

---

## 7. Sound: the typewriter dateline

### 7.1 The asset

- Source: H's synthesised sound (`fork/design/hifi3/H/concept.html`, the block
  between `SOUND_START` and `SOUND_END`; reference render
  `fork/design/hifi3/H/dateline-sound.wav`: mono, 16-bit, 44,100 Hz, 3.29 s,
  peak -2.48 dBFS, 14 strikes and a carriage-return stop at 2.25 s; H spec 6.3).
- Cut for the game as one-shots so any date can be typed and every letter
  lands on its strike:
  - `strike_01.wav` .. `strike_06.wav`: one key strike each, its five layers
    (contact, slap, thump, rattle, escapement tick; H spec 3.3 table) with
    their own v/p/q values (seeds 1..6), with the room tail baked in
    (0.7 s noise reverb, wet low-passed at 2.5 kHz, 23% wet) and the bus
    compression baked in (threshold -18 dB, ratio 4, attack 2 ms, release
    120 ms), master gain 0.84. 0.780 s and 68,838 bytes each in the spike,
    peaks -4.95 to -1.80 dBFS.
  - `carriage_return.wav`: the 240 ms slide and the stop (H spec 3.3), no
    bell, with its tail: 1.290 s, 113,820 bytes, peak -3.88 dBFS.
  - WAV, mono, 16-bit PCM, 44.1 kHz, raw peaks at or under -1.5 dBFS. All
    seven files total about 527 KB.
- Rendering: by script, from the TypeSound parameters, not by cutting the
  reference file (cut points would carry the previous strike's tail). The
  spike's `fork/design/godot-g/spikes/synthesize.py` already renders them
  (NumPy, using H's WAV as the reference); the build copies it to
  `fork/design/godot-g/tools/` and only the WAVs go into
  `godot/assets/audio/sfx/typewriter/`. Alex listens to them once before
  phase 4 merges.
- Import: `.wav` importer, `force/mono` on, `compress/mode` = **PCM, set by
  hand** (Godot 4.5.1's default is Quite OK Audio, a lossy codec the spike
  got by default; the files are small enough to keep the attack exact), loop
  off, `edit/trim` off (the attack is at sample 0), `edit/normalize` off.
- This is the game's first sound effect (`assets/audio/sfx/` is empty today).

### 7.2 Playback in Godot

- `GTypeSound` (Node) owns a pool of six `AudioStreamPlayer` children, all
  `bus = &"SFX"` (bus 1 in `godot/default_bus_layout.tres`; its volume is
  `GameConfig.sfx_volume`, applied at `game_config.gd:363-369`). Each strike
  takes the next free player (or the oldest, if all six still ring), sets
  `stream`, `pitch_scale` and `volume_db`, and calls `play()`, so overlapping
  tails do not cut each other. This is the routing the spike proved
  (`spikes/dateline.gd:80-93`, which creates a player per strike; the build
  reuses a fixed pool instead of creating and freeing nodes).
- The seven WAVs are held in a plain `Array[AudioStream]` preloaded by
  `GTypeSound`, not in an `AudioStreamRandomizer` (7.4).
- **Schedule** (seconds from the start), a pure static function
  `GDateline.schedule(text, rng) -> {letter_times: Array, cr_time: float,
  end_time: float}`, unit-tested:
  - first letter at 0.06 s;
  - each next letter +0.095 s + `rng.randf_range(-0.022, 0.022)`;
  - a space: no strike, +0.060 s;
  - after a comma: +0.040 s;
  - carriage return at last letter + 0.32 s; end = cr + 0.24 + 0.35 + 0.7.
  "NOVEMBER 1, 2017" lands near 1.6 s for the last letter (H spec 3.3).
- **Sync:** one Tween built from the schedule: for each letter,
  `tween_interval(gap)` then `tween_callback(_strike.bind(i))`; `_strike`
  increments `visible_count`, queues a redraw and plays strike
  `pick[i]`. Letter and sound start in the same frame; the audible offset is
  Godot's mix and output latency. The spike measured it from real 60 fps
  Movie Maker frames against the same capture's audio: mean +5.0 ms, max
  +11.4 ms, every letter within one frame (13.3). No compensation is built.
  Movie Maker uses Godot's dummy audio driver, so speaker latency on Alex's
  PC is checked by ear in phase 4; only if it is clearly late (over about
  40 ms) delay the visual reveal by `AudioServer.get_time_to_next_mix() +
  AudioServer.get_output_latency()`.
- **Which strike plays:** `pick[i] = rng.randi_range(0, 5)`, never the same as
  `pick[i-1]`. Each strike also gets `pitch_scale = rng.randf_range(0.975,
  1.025)` and `volume_db = rng.randf_range(-1.0, 1.0)` from the same local
  `rng` (the spike's values, `spikes/dateline.gd:64-66`).

### 7.3 Rules

- **Never two datelines at once.** `GDateline.busy` is true from the first
  letter until `end_time` (a final `tween_interval` on the same tween, so it
  pauses with the game). A new type request while busy: if the text is the
  same, ignore it; if different, kill the tween, call `stop()` on every
  player in the pool, show the new text set, play nothing (the spike proved
  this: no later strikes, old tail gone within 19 ms, 13.3).
- **Never in-month.** It types only on the triggers in 5.1.1. A day change
  inside the month, or a state that arrives while typing with the same month,
  never starts sound. If the month starts playing back while the date is
  still typing (the player committed within 1.6 s of a month starting), the
  next state with a new day cuts the dateline to set and stops the strikes.
- **Pause** freezes it (6.3).
- **Volume** is the SFX slider; muted with SFX at 0 (open question Q10 on bus).
- **Reduced motion**: no sound (6.5).

### 7.4 Randomness: the rule

**Rule: nothing in G draws from Godot's global random generator, directly
or through an engine class.** That means no `randi()`, `randf()`,
`randi_range()`, `randf_range()`, `Array.shuffle()`, `Array.pick_random()` or
`randomize()` in G scripts, and **no `AudioStreamRandomizer` playback** in
any mode. All presentation randomness comes from a `RandomNumberGenerator`
the G node owns.

Why, checked against the code on 2026-11-22:

- The same-seed test (AGENTS.md section 1) counts any RNG draw that could
  change a run. The game's own randomness runs on seeded generators
  (`state.rng` and the generators passed down from it).
- One core path still falls back to the global generator:
  `MediaStory._pick` uses `randi()` when it gets no `rng`
  (`scripts/core/media_story.gd:206-208`). Today every live caller passes
  one (`scripts/core/media_system.gd:80, 85, 154, 437`), and no other
  global-RNG call exists in `scripts/core/` or `scripts/game_manager.gd`.
  So a global draw from the UI would not change a run today, but it would
  the day a caller drops its `rng`, and nothing would flag it.
- Other UI code already draws from the global generator
  (`autoload/music_manager.gd:310` for the shuffle,
  `scripts/ui/office_cat.gd:41`). G does not add to that, so the parity check
  stays meaningful.
- The spike found that `AudioStreamRandomizer` playback in 4.5.1 draws from
  the global generator even with its pitch and volume spread at neutral
  (`servers/audio/audio_stream.cpp` at the 4.5.1 tag, as read by the spike
  worker). So it is out, not only its random mode.

How it is held:

- `GDateline` owns `rng`, seeded with `hash(text)` before each type-on, so
  the same date always types (timing, strike picks, pitch, volume) the same
  way and tests can pin it.
- `GRoom` grain offset steps are deterministic (a counter, not random).
- **Test** (phase 4, `tests/unit/test_g_rng.gd`): seed the global generator
  with a fixed value, type a full date and run the room for 60 frames, then
  check that the next `randi()` equals the value it would have had with no G
  activity. Plus the same-seed state-hash check (12.1 item 5).
- Reviewers grep G files for the calls above; any hit is a cut item.

---

## 8. Keys

### 8.1 The table

| Key | In G | Today (`autoload/keybind_manager.gd`, `main_ui._input`) | Status |
|---|---|---|---|
| Esc | close the top layer; menu when nothing is open | same (`main_ui.gd:504-560`) | same |
| Enter | Commit (`commit_plan`), only with nothing open | same (`keybind_manager.gd:86`) | same |
| Space | end turn (`end_turn`); advances the month review | same (`keybind_manager.gd:39`, `main_ui.gd:543-552`) | same |
| V | toggle PLAN / WATCH | same (`keybind_manager.gd:90`) | same |
| L | Ledger | same (`keybind_manager.gd:58`) | same |
| Z / C | Undo / Clear, on the desk and in the Plan drawer | same binds (`keybind_manager.gd:40-41`) | same keys; G also routes them while the drawer is open |
| N | Feedback | same (`keybind_manager.gd:55`) | same |
| F10 | Settings | same | same |
| 1-9 | action slots 1-9 (same order as today's bar), on the desk and in the Actions sheet | same binds (`keybind_manager.gd:73-81`) | same; G also routes them while the Actions sheet is open |
| H / F / P / T | open Hire / Fundraising / Publicity / Travel submenus | same (`keybind_manager.gd:61-70`) | same |
| A | Actions sheet | free | **new** bind `g_actions` |
| U | Upgrades sheet | free | **new** bind `g_upgrades` |
| E | Staff (Employee screen) | free; an old `employee_tab` bind is commented out (`keybind_manager.gd:56`) | **new** bind `g_staff` |
| Q | Plan drawer | free on the desk; inside dialogs Q is choice 1 (`scripts/ui/dialog_keys.gd:30-31`) | **new** bind `g_plan` |
| R | Reserve 1 hour, only while the Plan drawer is open | free (`menu_research` was deleted, `keybind_manager.gd:63`) | **new** bind `g_reserve` |
| F1 | Guide (embedded) | free | **new** bind `g_guide` |
| F9 | cycle classic -> proposed -> g (debug builds) | flips classic/proposed (`main_ui.gd:485-489`) | changed (debug only) |

- The new binds are added to `KeybindManager` (category UI, description
  ending "(G desk)") so the rebind screen lists them. In classic they do
  nothing (only `GKeys` reads them).
- G's mock-up keys that are dropped: Enter on the Actions detail card, the
  event's selected option and the review button (Pip's Enter ruling, 10.4);
  1/2/3 labels on event options (the game advertises Q/W/E).
- Inside any dialog, Q W E R A S D F Z and 1-9 stay choice keys
  (`DialogKeys`); the G router never runs while a non-G modal is on top.

### 8.2 Routing

`GKeys.route(event, top_kind, phase) -> String` is a static, pure function
returning an intent (`"toggle_actions"`, `"toggle_plan"`, `"toggle_upgrades"`,
`"staff"`, `"guide"`, `"reserve"`, `"undo"`, `"clear"`, `"slot_N"`, or `""`).
`main_ui._input` calls it **after** the text-focus gate and the ledger block
(`main_ui.gd:473-502`) and **before** the Esc-to-pause check and the dialog
block (`main_ui.gd:504-569`), only when the layout is g. Rules:

- `top_kind` is `modal_stack.top_kind()` (`modal_stack.gd:71`).
- If `top_kind` is not empty and does not start with `"g_"`: return `""` (the
  dialog block handles the key exactly as today).
- If the phase is not plan (`current_turn_phase` is not `action_selection`),
  A, U and Q return `""` (their sheets are PLAN-only; their plates are
  disabled in WATCH). E, F1 and L work in both.
- A with Actions top: close. A with another G sheet top: switch. Same for U, Q.
- With `g_plan` top: Z, C, R map to undo, clear, reserve (each only if today's
  button is enabled).
- With `g_actions` top: 1-9 map to `slot_N`.
- Anything else with a G sheet on top returns `""`, and the dialog block then
  blocks it, as today for any modal.

`GDesk` performs the intent and `main_ui` marks the event handled. The
function is unit-tested on its own (like `dialog_key_advances`).

---

## 9. Data binding summary

All read-only. "via host" = GDesk calls an existing `main_ui` method.

| G element | Driven by | Signal | Writes |
|---|---|---|---|
| Dateline | `state.calendar` | `game_state_updated` | none |
| Resource cells | `state.money/compute/research/papers/reputation`, formatted by `GameConfig.format_*` | `game_state_updated` | none |
| Trace windows | `GResourceHistory` (UI-only) | `game_state_updated` | UI static store only |
| Banner mode, view switch | `screen_mode.current_mode` | `screen_mode.mode_changed` | click -> `screen_mode.toggle_mode()` (view only, as today) |
| Playback bar | `state.turn` + `Clock` statics | `game_state_updated` | none |
| Speed | -- | -- | click -> `screen_mode.speed_changed` (as today) |
| Rail statuses | `state.total_staff`, `ledger_screen.summary_word()` | `game_state_updated` | none |
| P(Doom) card | `state.doom`, `state.doom_system.doom_trend`, ThemeManager bands | `game_state_updated` | click -> `_show_doom_trend_expanded()` |
| Attention card | `state.planning_hours_left`, `operating_hours_left`, `month_plan.*`, `plan_controller.queued_actions` | `game_state_updated`, `queue_view_changed`, `turn_phase_changed` | buttons -> open sheets |
| Held plate | `month_plan.attention_total/spent/reserved` | `game_state_updated` | none |
| Commit | `commit_plan_button.disabled`, queue size, phase | `turn_phase_changed`, `queue_view_changed` | click -> `_on_commit_plan_button_pressed()` |
| Actions sheet | `ActionBarRenderer` row list, state for blocked reasons | `actions_available` (via renderer), `game_state_updated` | row -> `_on_dynamic_action_pressed()`; door -> `_open_submenu()` |
| Plan drawer | `plan_controller.queued_actions`, `calculate_queued_costs()` | `queue_view_changed`, `game_state_updated` | x -> `_remove_queued_action()`; Undo/Clear/Reserve -> today's handlers |
| Upgrades sheet | today's list (reparented) | today's | today's |
| Feed | `main_ui._feed_lines` | a new `main_ui.feed_changed` signal emitted at the end of `log_message` and `_render_feed` | filter toggles -> today's handlers |
| Event paper | the event dict | `event_triggered` (today's dialog) | today's buttons |
| Review paper | the `review` payload | today's | today's button |
| Advisor note | `GameConfig.show_first_lever_hint`, `first_lever_hint_text`, `first_lever_action_id` | boot, `_clear_first_lever_nudge` | x hides the note only |
| Room | `state.doom` band | `game_state_updated` | none |

`main_ui` gets two new signals, `queue_view_changed` and `feed_changed`; both
are emitted from existing view functions and carry no data.

---

## 10. Where the build follows today's code instead of the ADR or mock-up

1. **The Attention spill.** ADR-0011 and the core gate let operating work use
   planning hours (`scripts/core/month_plan.gd:182-193`). Today's UI refuses
   the click when the action's own pool is short (`main_ui.gd:1736-1739`,
   `submenu_controller.gd:150-152`). The build keeps the refusal, shows the
   row blocked ("x needs N operating hr"), and draws no hatched spill cell or
   spill tag (G state 3 does both).
2. **Reserve.** The ADR's hold is untyped; today's UI disables Reserve at 0
   operating hours (`main_ui.gd:1278-1281`) and `reserve_ap` checks operating
   hours (`game_manager.gd:413-423`). The build mirrors today's button:
   RESERVE HOURS disabled at 0 operating hours (G state 3 shows it live).
3. **Removing a repeated play** removes the first queued copy of that id,
   whichever row is clicked (`plan_controller.gd:76-84`), as today's tiles do.
4. **Enter.** Pip's ruling: Enter is Commit and must not dismiss popups
   (`main_ui.gd:706-723`); the dialog block eats Enter while any modal is up.
   So no Enter on the Actions detail card, the event's options or the review
   button (the mock-ups show Enter on all three).
5. **The month review's words** are the game's payload, unchanged
   (`game_manager.gd:833-882`). G's split attention line and the dropped
   closing line are not built.
6. **Held hours by event.** G state 5 names the event that used the held hour.
   The game does not report that per event; the build shows "Used on events
   N hr" (5.5).
7. **Two commit paths.** Today Enter and Space commit through different
   handlers (`main_ui.gd:989-1077`). G draws one Commit plate wired to the
   Enter path; Space keeps its own path.
8. **Costs that are not in the action data.** Advertise a Role and Work Your
   Connections have empty `costs` in `data/actions/core.json`; their real
   costs live in Balance (H spec 7.2). G shows what today's hover and tiles
   show (no cost), not the mock-up's "2 op hr, 6 rep".
9. **Doom changes that today's game prints.** Today the home screen shows a
   doom delta chip "(+0.9)" next to the % (`main_ui.gd:1312-1405`), a momentum
   number in the meter (`scripts/ui/doom_meter.gd:97-116`) and a per-source
   breakdown ("Panic +0.5", `scripts/ui/doom_breakdown.gd`). The designs show
   none. The build: no delta chips and no momentum number in G; the
   breakdown moves into the trend dialog one click from the P(Doom) card
   (5.4). Nothing is removed from classic. Whether G should drop them is open
   question Q4.
10. **Workdays.** The mock-up's "workday 10 of 22" is computed by the UI from
    `Clock` (5.2). "Turn N" (which counts workdays) is not shown.
11. **Event option keys** are Q W E as the game advertises (`dialog_keys.gd`),
    not the mock-up's 1 2 3.
12. **The Actions sheet order** is today's action-bar order, so keys 1-9 hit the
    same actions as today; G's five-group order is not used.
13. **No reorder** (^ v) in the Plan drawer: the queue has no reorder
    operation (16).

---

## 11. Art plan

### 11.1 Method (from Bramble; Alex's instruction)

- Sol (Codex `gpt-6.2-sol`, `reasoningEffort` high, its built-in image tool)
  makes the pictures. Pip's guidance to match: the palette and doom bands
  (`docs/art/PALETTE_AND_DOOM_INTENSITY.md`: "doom is a layer, not a repaint",
  one ambient and one glow per scene, purple only from band 3, amber the only
  saturated accent at rest), the asset rules (`godot/assets/ASSETS_README.md`:
  PNG for icons, lower-case names with sizes), and the look of his icons in
  `godot/assets/icons/` (painted, chunky, on dark tiles).
- The prompt shape that works (Bramble
  `docs/design/art-direction/card-art-recipe.md`): a fixed header, two short
  paragraphs ("Look:" and "The design"), then numbered
  `filename -- description` items. Loose beats rule-heavy: "Codex followed
  them literally and the pictures came out flat." A shape or size guide may
  be attached; a finished picture as a style reference may not (it locks
  whatever is in it).
- **Template:** `fork/design/godot-g/art-trial-prompt.txt` (the trial's money
  tiers). Each batch copies it and changes only the first sentence's subject,
  the "The design" paragraph where the set needs it, and the numbered items.
- **Running a batch:** work in `/data/pdoom1-art/<batch>-run<k>/` (outside the
  repo); start a Codex worker through T3 `delegate_task` with three lines
  before the prompt text: the working folder, the guide file path if any, and
  "Do not run git or commit anything. Do not change any file in the repo."
  Run each batch two or three times into separate folders; Alex or the
  orchestrator picks per item from a contact sheet.
- **Trial result (money tiers, two runs of the template).** Contact sheet
  `fork/design/godot-g/art-trial.png`; originals
  `/data/pdoom1-art/trial-1/` and `trial-2/`: ten PNGs, 1254x1254 RGBA, real
  transparent background, 1.6-2.5 MB each. Both runs gave the same readable
  0-4 progression (empty cash box with a red rim, one coin, three coins, a
  stack with a note, a heap with banded notes) that still reads at 48 px on a
  dark plate; red appears only on tier 0. Two things to handle:
  - **No plate.** Unlike Pip's `icons/money.png`, the pictures have no round
    metal plate. That is intended: G draws the dark plate as a StyleBox
    behind the icon (5.1.2, H spec 3.2), so one plate style serves every
    tier and resource.
  - **No common scale.** Every picture fills its frame (measured content
    box: 92-100% of the canvas in all ten), so the single coin is drawn as
    large as the heap and "more" reads only by count, not by size.
- **Fix for scale: post-processing, plus one sentence in the prompt.**
  - Post-processing sets the scale per tier (below). It is deterministic,
    fixes the money set as it stands, and keeps Sol's pictures as drawn.
  - The template's "The design" paragraph gets one added sentence for the
    remaining batches: "Draw every item at the same scale, as if all five
    sit on the same desk seen from the same distance: a single small thing
    is small in the frame, the largest pile fills it." That is a scale cue,
    not a style rule, in keeping with the loose-prompt method. Everything
    else in the template stays.
  - The money set does not need a re-run; pick per item between trial-1 and
    trial-2.
- **Post-processing (one script, `fork/design/godot-g/tools/cut_icons.py`,
  Pillow; originals untouched):**
  1. If the background is not already transparent (alpha all 255), key out
     the flat black to alpha. The trial did not need this.
  2. Trim to the alpha bounding box (alpha > 16).
  3. Scale the trimmed picture so its longer side is a fixed share of the
     final canvas, by tier: tier 0 = 0.78, tier 1 = 0.52, tier 2 = 0.68,
     tier 3 = 0.84, tier 4 = 0.96. (Tier 0 is an empty container, so it sits
     mid-size; tiers 1-4 grow.) Lanczos, done in one step from the
     original to the final size.
  4. Place it centred horizontally and **bottom-aligned** on a shared
     baseline 6% above the canvas bottom, so the set sits on one "desk".
  5. Save 128x128 PNG RGBA, 8-bit, no metadata (about 15-30 KB each).
  6. Make a check sheet: all five tiers at 32 and 40 px on the `well` plate
     colour, beside Pip's `icons/resources/resource_money_64.png`.
  The share values are a starting point; the orchestrator may tune them
  once per resource from the check sheet and records the values used in
  the script.
  The six action icons go through the same script with one share for all
  (0.90, centred, not bottom-aligned), since they are not a size ladder.
  Smoke and the paper sheet skip steps 3-4 and are only downscaled.

### 11.2 The list

| Item | Kind | Size and format | Import | Batch |
|---|---|---|---|---|
| 25 resource tier icons (`money-0..4`, `compute-`, `research-`, `papers-`, `rep-`) | **Sol picture**, cut by `cut_icons.py` (11.1) | made at ~1254x1254; shipped 128x128 PNG RGBA (shown at 32 and 40 px, so about 3x) | `compress/mode` Lossless, `mipmaps/generate` on, `process/fix_alpha_border` on, `process/premult_alpha` off; the `TextureRect` sets `texture_filter = LINEAR_WITH_MIPMAPS` (in Godot 4 the filter is a CanvasItem property, not an import setting) | money: from the trial, no re-run; then 4 batches of 5 (compute, research, papers, reputation), each run 2-3 times |
| Six new action icons: advertise a role (pinned notice), travel and conferences (suitcase), publicity (megaphone), post online (speech bubble), go to meetups (two glasses), order office supplies (carton with pencils) | **Sol picture** | 128x128 PNG RGBA, on Pip's dark tile look | as above | 1 batch of 6 |
| Floor smoke (bands 5-6) | **Sol picture** | 2048x512 PNG RGBA, soft violet-grey wisps, transparent, left and right edges fade | Lossless, no mipmaps | 1 batch, 2 variants |
| Paper sheet | **Sol picture** | 1024x1024 PNG RGB, aged tan sheet, flat, top-down, no text, darker at the bottom, burnt edges, worn corners | Lossless; used as 9-slice, margins 64 | 1 batch, 3 variants |
| Window mask for `office_wide_day` | **texture (script + hand check)** | 1536x1024 PNG L8 (white = window pane) | Lossless, no mipmaps, filter linear | -- |
| Room noise (`noise_lo`, `noise_hi`) | **texture (script)** | 256x256 PNG L8, tileable | Lossless, repeat on | -- |
| Panel grime 9-slice | **texture (script)** | 256x256 PNG RGBA | Lossless | -- |
| Hatch | **texture (script)** | 16x16 PNG RGBA, tileable | Lossless, repeat on | -- |
| Monitor glows | **procedural** (`GradientTexture2D`, radial) | -- | -- | -- |
| Window sky, grade, smut, grain, vignette, fire light | **shader** (5.14) | -- | -- | -- |
| Dateline sound | **audio (script render)** | WAV mono 16-bit 44.1 kHz | 7.1 | -- |

Not new: Pip's icons and office art listed in 5.3-5.6; Pip's
`tex_painted_metal_panel_512.png` in the grime texture. No eldritch cat (G
dropped the office cat instrument; open question in G notes).

### 11.3 The descriptions (starting point for the "Items" lists)

From H spec 6.4 and the trial:

| Resource | Tier 0 | Tier 1 | Tier 2 | Tier 3 | Tier 4 |
|---|---|---|---|---|---|
| money | empty dented cash box, faint red glow on the rim | one worn coin | three coins | a stack with a folded note | a heap of coins and banded notes |
| compute | a dead chip, faint red | a lit chip | one server unit | three server units | two racks |
| research | a blank notebook, faint red | one note sheet | an open notebook | three books | a file box |
| papers | an empty clipboard, faint red | one paper | three, fanned | a bound journal | a shelf |
| reputation | a shattered medal, faint red | a cracked medal | a tarnished medal | brass with a star | brass with a laurel |

Red appears only in tier 0 (the trial prompt's "The design" paragraph).

### 11.4 Acceptance per batch

- Read at 32 px on the panel colour as one set: same angle, same light, steps
  that read as more.
- No text, numerals or currency signs; nothing that imitates another game.
- Sits beside Pip's icons in a contact sheet without looking like another
  game's art; not brighter than Pip's toned icons (H spec 6.2 notes several of
  Pip's own icons already read bright).
- Picked items are copied into `godot/assets/...` at the sizes above; the
  full-size originals stay in `/data/pdoom1-art/`.

### 11.5 Provenance

- Pip's repo has a provenance manifest, `godot/data/asset_provenance.json`, and
  a guard, `tools/assets/check_provenance.py` (hidden in this checkout; read it
  with `git show HEAD:tools/assets/check_provenance.py`). The guard reports any
  packed asset with no record.
- Every new file in `godot/assets/` gets a record: Sol pictures
  `origin: generated_model`; script textures and the WAVs
  `origin: procedural_render` or `authored_code`; fonts: see Q9. Use
  `tools/assets/backfill_provenance.py --record` (also hidden; Alex unhides
  `tools/assets/` by adding it to `fork/sparse-checkout.txt`, AGENTS.md
  section 3) or write the records by hand in the same shape.
- The manifest's notes say Pip's funding commitment counts on the asset set
  being homogeneous (all generated); see Q9.

---

## 12. Phases, sub-phases and checks

### 12.1 Checks every sub-phase runs

On the change branch, before squashing (AGENTS.md sections 4 and 7):

1. `python scripts/run_godot_tests.py --quick --ci-mode --min-tests 300` exits 0
   (Linux: point `PDOOM1_GODOT`/`GODOT_BIN` at
   `/data/godot-4.5.1/Godot_v4.5.1-stable_linux.x86_64`; run under `xvfb-run`
   if the runner needs a display).
2. `python scripts/check_no_emoji.py`, `python tools/check_scene_nav.py`.
3. Pip's two hidden guards, read from history:
   `git show HEAD:tools/check_font_sizes.py > /data/pdoom1-g/tmp/cfs.py && python /data/pdoom1-g/tmp/cfs.py`
   and the same for `tools/check_pause_timers.py`.
4. `python tools/check_ladder_bump.py --base lean --head HEAD`; every listed
   file must be one of 2.5's presentation-only exceptions.
5. **Same-seed check** (from phase 1 on): `tests/visual/g_capture.gd` plays a
   fixed seed with a fixed input script (queue three plays, commit, answer the
   first event with its first option, begin the next month), once with the
   layout classic and once with g, and compares a hash of
   `GameManager.state.to_dict()` at the end. Must match.
6. **Screenshots** from the real game under xvfb (a CPU render on this box,
   13.1; say so in the report) at 1920x1080 and 1280x720:
   classic before, G after, for the states the phase touches (12.3), plus the
   contrast check (4.5) on the G shots.
7. A fresh `scope-reviewer` with no cut or ask items.

### 12.2 Phases

Each sub-phase is one `ui/g-<slug>` branch from `lean`, squashed into `lean`
as one commit. G stays behind the switch the whole time; classic is never
changed except where a row of 2.5 says so.

**Phase 1: a playable G desk, plain look.**
- 1a `ui/g-switch`: GPrefs, the `"g"` arrangement in LayoutController, F9
  cycle, the Settings row and options modal, GDesk skeleton that hides the
  classic chrome and shows: top strip (plain numbers, no icons, today's
  turn label text in the dateline slot), banner and view switch, P(Doom) card,
  Attention card (PLAN face), held plate, Commit, Feedback, Menu. Rail plates
  for Staff, Ledger, Guide (embedded guide included). Tests: GPrefs round
  trip; layout flip g -> classic restores every node (extend
  `test_ui_layout.gd` with a g fixture); `test_ui_no_dead_ends` passes;
  same-seed check.
- 1b `ui/g-sheets`: Actions sheet with detail card and door return, Plan
  drawer, Upgrades sheet, `GKeys` routing and the new binds,
  `queue_view_changed`. Tests: `GKeys.route` table test; sheets close on Esc,
  x and their letter; door return; 1-9 parity (same action id queued as from
  the classic bar); same-seed check.
- 1c `ui/g-watch`: WATCH banner (playback bar, speeds), WATCH and closed faces
  of the Attention card, feed panel with `feed_changed`, Commit's WATCH states,
  rail disabled states. Tests: workday N of M against `Clock`; held-hours
  derivations; same-seed check.

**Phase 2: the look.**
- 2a `ui/g-theme`: fonts (import, OFL files), `g_theme.tres`, the `label`
  font step, palette, styleboxes, grime/hatch/keycap/tick drawing, hierarchy
  sizes, script-made textures. Contrast check on every G state at both sizes.
- 2b `ui/g-paper`: event paper, review paper, advisor note, submenu and ledger
  panel restyle; the paper texture (script stand-in until the Sol batch);
  the six new action icons batch (Sol). Contrast on paper.

**Phase 3: the room by doom band.**
- 3a `ui/g-room`: the shader, band table, glows, window mask, noise
  textures, the `simple` / `off` modes and the compile fallback, the band
  tween, grain offset in `_process`. Screenshots of the room forced to each
  band 0-6 (a debug-only override in `g_room.gd`, like the mock-up's
  `?band=`), frame time logged.
- 3b `ui/g-smoke`: the smoke batch (Sol) and its layer for bands 5-6.

**Phase 4: the dateline and its sound** (`ui/g-dateline`): GDateline with
the ribbon, the schedule, GTypeSound, the rendered WAVs, the busy rule, the
type triggers. Tests: `schedule()` timings for "NOVEMBER 1, 2017" with a fixed
seed; triggers (new game types, new month types, in-month day change does
not, load does not, resume does not); busy rule; no draw from the global RNG
(seed the global RNG, type a date, check the global sequence is unchanged).
A timing log of letter and strike times from a real run.

**Phase 5: tier icons** (`ui/g-tiers`): four more Sol batches (compute,
research, papers, reputation; money from the trial if accepted), import,
`GTiers`, the cell icon swap and crossfade, tags, reputation's "0 ends the
run". Tests: tier boundaries on shown amounts (60, 60.25, 60.5, 0.25, -0.4
from the H council); tags.

**Phase 6: trace windows** (`ui/g-traces`): `GResourceHistory`, the clear rule
in `_boot_game`, the trace drawing, the caption, the take switch. Tests:
history records once per month, clears on new game and load, survives
`resume_in_place`; auto-scale and zero line.

**Phase 7: motion and finish** (`ui/g-motion`): every row of 6.2, reduced
motion, mid-animation input cases, pause freeze checks, 1280x720 and
2560x1080 screenshots, a final contrast pass.

The orchestrator may merge sub-phases or split them further. After phases 1,
3 and 7 it reports to Alex whether the original goal (a G test build Alex
can play) is met yet.

### 12.3 States to capture for screenshots

Driven by `tests/visual/g_capture.gd` from a fixed seed (debug build):

1. month 1, first screen (advisor note up);
2. Actions sheet open with three plays queued;
3. Plan drawer open with eight or more plays;
4. WATCH with an event waiting (play until the first window);
5. the month review;
6. late game: a band 5 room, reached with the debug doom nudge (PageUp,
   `main_ui.gd:478-482`, debug builds only; it writes game state, so it is
   used for screenshots only, never in the same-seed check).

---

## 13. Spike results

From `fork/design/godot-g/spikes/RESULTS.md` (official
`4.5.1.stable.official.f62fdbde1` Linux binary under Xvfb; the box's own
4.7.2 was not used). Rerun all three with
`bash fork/design/godot-g/spikes/run.sh all`; it stages its project and logs
under `/data/pdoom1-spikes`.

### 13.1 Room shader

- One CanvasItem material on the same `office_wide_day.webp`, a float `band`
  uniform blending H's seven steps. It compiled and rendered on Forward+
  (Vulkan 1.4) and forced Compatibility (OpenGL 4.5 Core).
- Both runs used **llvmpipe, Mesa's CPU rasteriser**: Xvfb has no DRI3, so
  Vulkan listed the Intel UHD 630 as unsupported and picked the CPU device.
  So every screenshot this box makes is a software render.
- Frame time under llvmpipe at 1920x1080, VSync off: plain 22.0 ms mean
  (p95 32.6), graded band 3 31.7 ms mean (p95 51.6). Not a GPU number.
- Luma at bands 0 / 3 / 6: 0.175 / 0.061 / 0.014. A 400 ms tween 0 -> 3
  rendered a smooth intermediate on both renderers.
- Not in the spike: window sky, monitor glow, smut, smoke, fire.
- Folded into: 5.14 (single `band` uniform, cost check on Alex's PC, band 6
  darkness), 14.

### 13.2 Fonts and size steps

- One weight of each family imported as `FontFile`, sizes through an
  unchanged `base_theme.tres` and `ThemeManager.get_font_size()`: 15 / 19 /
  27 / 35 held at 1920x1080 logical size.
- At 1280x720 the `small` row is about 10 px of ink including descenders:
  readable alone, to be checked on dense copy (4.5 runs at 720p for this).
- Pinned URLs, SHA-256s and licence texts: `spikes/assets.tsv`,
  `spikes/licenses/`.
- Folded into: 4.2 (import settings), Q6.

### 13.3 Dateline and strikes

- Six strike WAVs plus a carriage return, rendered by `synthesize.py`
  (7.1 sizes). One Tween reveals a glyph and plays its strike in the same
  callback; spaces silent; bus SFX.
- Measured audio minus picture over 14 audible letters: mean +5.0 ms, max
  +11.4 ms.
- Same date requested while typing or in the tail: ignored. A different date:
  players stopped, new date shown whole. A Space mid-type: full date in one
  frame, no later strikes, old tail below -80 dBFS within 19 ms.
- `AudioStreamRandomizer` draws from the global RNG in 4.5.1.
- Folded into: 7.1-7.4.

## 14. Risks

| Risk | Effect | Mitigation |
|---|---|---|
| The box renders on the CPU (llvmpipe), not the GPU (13.1) | screenshots are software renders; no real frame time on the box | every phase report says the renderer; phase 3's cost check runs on Alex's PC |
| Room shader slow on a weak GPU | frame drops in WATCH | `simple` and `off` modes; 2 ms rule (5.14) |
| Band 6 room nearly black (13.1) | the late game loses its picture | check with lights in; lift band 6 brightness in G's table if needed |
| `small` text at 720p is about 10 px tall (13.2) | dense rows hard to read on small windows | 720p contrast and readability pass in phases 2 and 7; Q6 |
| `main_ui.gd` is 2.3k lines and coupled to node paths | G hooks break classic | G hides nodes, never removes them; the same-seed check and the flip test every sub-phase |
| Reparenting live nodes (upgrades, research quality, in-flight box) | a node freed with a sheet | sheets are persistent; restore on leaving g is tested |
| ModalStack pops the Actions sheet for a door | the player loses their place | door return (5.7.4) |
| Font licences and provenance | Pip's guard flags fonts; funding note | Q9; records written |
| A/B scaffolding is temporary in Pip's design ("the loser is deleted", `game_config.gd:90-95`) | G may not fit Pip's plan | G is a fork test build; nothing assumes Pip adopts it |
| Audio latency on Windows | letters lead strikes | measured 5 ms in Movie Maker; check by ear on Alex's PC in phase 4; compensate only if clearly late (7.2) |

---

## 15. Open questions

Each: the question, then what happens if nobody decides.

- **Q1.** Should Alex's lean test builds start with G on? If nobody decides, G
  starts off and is turned on from Settings > G desk options (or F9 in a debug
  build).
- **Q2.** Tier icons or trace windows as the default resource take? If nobody
  decides, tier icons are the default and traces are a setting.
- **Q3.** Are the tier thresholds right (5.1.2)? If nobody decides, the table
  is built as it stands.
- **Q4.** Should G drop today's doom delta chip, momentum number and
  per-source breakdown from the home screen? If nobody decides, G drops the
  chip and the number and moves the breakdown one click away into the trend
  dialog; classic keeps all three.
- **Q5.** Should the Plan drawer show "after these costs"? If nobody decides,
  it is built (it only subtracts listed costs).
- **Q6.** Should the game's `small` font step move from 15 to 16 for everyone?
  If nobody decides, it stays 15 and G's smallest text is 1 px smaller than
  measured in the mock-ups.
- **Q7.** Should the reputation note read "0 ends the run" exactly? If nobody
  decides, it does.
- **Q8.** Should reduced motion become a game-wide setting (a `game_config`
  change)? If nobody decides, it stays a G-only setting in `user://g_ui.cfg`.
- **Q9.** May the build ship four OFL fonts and Sol-made art, given Pip's
  provenance guard and his funding note about AI-made assets? If nobody
  decides, the fork build ships them with provenance records, and the
  question goes to Pip before any of it is offered upstream.
- **Q10.** Should the typewriter use the SFX bus and volume? If nobody decides,
  it does, and it is the game's first sound effect.
- **Q11.** Should G show the WATCH office floor (the walkers) somewhere? If
  nobody decides, it is hidden in G and stays in classic.
- **Q12.** Should events show a picture on the paper? If nobody decides, events
  are text on paper.
- **Q13.** Should the rail keep the dark aubergine edge from Pip's purple
  buttons? If nobody decides, it is kept.
- **Q14.** The Attention spill and Reserve (10.1, 10.2) are Pip's rules to
  settle in code. If nobody decides, G follows today's UI.

---

## 16. Not in this build

- **Reordering plays** (the Plan drawer's ^ v): the queue has no reorder
  operation; adding one would change what a player can do to a run's
  execution order, which is mechanics.
- **A pause the player can press** in WATCH: today's is a stub
  (`screen_mode.gd:96-101`).
- **Event pictures** (Q12), the **eldritch office cat**, and any human figure.
- **Naming the event that used held hours** (10.6).
- **Redrawing** the Employee screen, the Ledger screen and the submenus beyond a
  stylebox swap.
- **H-HF's heavier texture** (stencil font, rivets, needle dial).
- **Changes to Pip's rules** behind 10.1 and 10.2.

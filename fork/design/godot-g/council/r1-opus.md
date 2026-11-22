VERDICT: CHANGES NEEDED

## Blocking items

**B1. In G, refused clicks show no feedback during PLAN.**
- Evidence: rejections go `report_rejection` → `EventResultPresenter.present_error` → the toast inside `plan_screen` (`main_ui.gd:1455-1471`; toast built at `plan_screen.gd:21-63`). Spec 2.2 hides `ContentArea`, which holds `plan_screen`, so that toast is never seen. The feed is WATCH-only. So "Not enough Attention", "Cannot afford" and refusals inside submenus become dead clicks in G. That is the bug `main_ui.gd:1458-1462` was written to fix. Spec 5.7.3 promises "the same refusals and toasts".
- Fix: add `plan_screen._error_toast` as a fifth live node in 2.2 step 3. Reparent it into GDesk somewhere visible in PLAN, for example under the banner. Record and restore it like the other four. Add a test: an unaffordable click in G shows the toast.

**B2. The hidden-guard command in 12.1 item 3 does not work.** Both scripts set `REPO_ROOT = Path(__file__).resolve().parents[1]`, so copies saved under `/data/...` scan the wrong tree. I ran it:
- `check_font_sizes.py` prints `ERROR: no default_font_size in godot/theme/base_theme.tres` and exits 1 on every run.
- `check_pause_timers.py` scans zero files and exits 0. That is a pass that checks nothing, so a `create_timer` without its second argument would get through.
- Fix: put the copies in `<dir>/tools/`, next to a `<dir>/godot` symlink to the worktree's `godot/`. I tested this: the font census runs and exits 0, and the pause-timer check prints `OK`. Alternatively, `sed` `REPO_ROOT` to `Path.cwd()` and run from the worktree root. Also run `check_pause_timers.py --self-test`.

**B3. The G sheets will fail `test_ui_no_dead_ends.gd` in the fast gate.** The test finds every `scenes/ui/**/*_panel.tscn` and `*_modal.tscn`. It instantiates each one with no host, calls `show_panel()`, sends Esc, waits two frames, and requires the panel to be hidden or freed (`test_ui_no_dead_ends.gd:84-93, 126-215`). The spec's sheets break this two ways:
- Their Esc callback is `main_ui.modal_stack.dismiss(sheet)` (2.4). With no host, `main_ui` is null and the call errors.
- Close is a 0.08 s fade (6.2). Two unthrottled headless frames take far less than 80 ms.
- Fix:
  - `hide_panel()` sets `visible = false` and stops the barrier taking mouse at once; any fade is cosmetic only.
  - The Esc callback falls back to `hide_panel()` when the sheet has no host, and returns early when the sheet is already hidden. The sheets are persistent, so their `EscToClose._unhandled_input` stays live while closed.

**B4. Fork-only tool files have no stated home and would end up in the commits meant for Pip.** Spec 4.5, 7.1 and 11.1 put `contrast_godot.py`, `cut_icons.py` and a copy of `synthesize.py` in `fork/design/godot-g/tools/`, but never say which branch commits them. On a `ui/g-*` branch they land in the squash commit, and AGENTS.md section 8 step 3 forbids `fork/` files there.
- Fix: one line in spec 12.2 and build-prompt section 3: fork tools are committed only as separate fork commits on `lean` (like backlog commits) or on `design/ui-concepts`, never on a `ui/g-*` branch.

**B5. Editing `godot/data/asset_provenance.json` falls outside AGENTS.md section 1, and the scope reviewer will flag it every time.** The tripwire lists the file (it is not in `COSMETIC_FILES`, `tools/check_ladder_bump.py:169-176`). Section 1 allows a listed file only if it is a named bug fix, copy-only text, or a presentation-only autoload edit. A provenance record is none of these, whatever spec 2.5 calls it. Every art phase would then get an "ask" from the scope reviewer, and the merge rule stops on any ask.
- Fix: make it an open question Alex answers before phase 2b. Default if he doesn't: keep the records in a fork file such as `fork/design/godot-g/provenance.json`, to be moved into `data/` only when the change goes to Pip.

## Non-blocking notes

1. **Keys.** `test_no_keybind_action_is_inert` (`test_navigation_principles.gd:156-171`) needs the literal text `is_action_pressed(event, "g_actions")` etc. somewhere in the code. `GKeys.route` must call `KeybindManager.is_action_pressed` once per bind name, not in a loop over a table. Separately, the new binds appear in the rebind screen but do nothing in classic. That cuts against Pip's P4 rule that no advertised key is inert; tell the reviewer it is expected.
2. **Small corrections:**
   - 5.14's "one-frame probe" for a failed shader compile has no GDScript API behind it. Drop it and rely on the phase 3 compile check on both renderers, plus the `simple` setting.
   - The embedded guide's own `_input` handles Esc before MainUI's does, because it is a later sibling (`player_guide.gd:12-16`). In embedded mode it should leave Esc to ModalStack.
   - `feed_changed` "at the end of `log_message`" fires after an `await`, and not at all for filtered lines (`main_ui.gd:1525-1531`).
   - 6.2 says the review's dateline is "cut to set by the next state", but 7.3 ignores a state with the same text.
3. **Art.** The method works. Both runs gave a clear 0-4 ladder with real transparency and no text. But the trial is warmer and more rendered than Pip's painted, cool teal, plate-framed icons (`resources/resource_money_64.png`, `resource_compute_64.png`), and in G it sits beside his blue and teal rail icons. Suggestions: let the "Look:" line point at the existing icon set loosely, and judge each batch on a 32 px contact sheet beside the rail icons. Whether it belongs is Alex's call.

Everything else I checked holds against the code:
- the draw order (submenus mount on TabManager after GDesk, events on root);
- the ModalStack HIDE path;
- where the dialog block, ledger and Esc sit in `_input`;
- the state keys (`calendar`, `doom_trend`, `month_plan` hour pools, `rng_state` in `to_dict`, so the same-seed hash does catch an extra RNG draw);
- `FONT_STEPS` and the font-size test;
- saved keybinds pick up new defaults without a version bump;
- the seven doom bands;
- the icon paths;
- the spike shader and the RNG findings.

SCORE: 7/10

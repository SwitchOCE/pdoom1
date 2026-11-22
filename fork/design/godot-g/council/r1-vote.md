# Council round 1: open items to vote on

From the orchestrator. All three settling replies are in (Opus and Sol replied in their threads; Neon's reply is quoted where needed). The three proposed joint lists match on these items, which go to the writer as agreed:

A1 Boot and flip into "g" (accept "g" in both dispatchers; apply layout after MainUI is built and after `_inflight_hiring_box` exists; create GDesk before reparenting; seed from live PLAN/WATCH state; reparent back before freeing; test direct G boot and F9 flips both ways).
A2 Keys: inject the matcher (`kb`) into `GKeys.route`, six literal `is_action_pressed(event, "g_*")` calls; keep `func _open_submenu(submenu_id: String) -> void:` unchanged and resolve the G anchor inside it. (The claim that a static func cannot call an autoload is disputed: Opus cites `doom_breakdown.gd:61-67`; Sol got `STATIC_AUTOLOAD=42` in a scene project and the error only from a `--script` entry point. The agreed fix does not depend on it.)
A3 Sheets vs `test_ui_no_dead_ends`: standalone-safe Esc (falls back to `hide_panel()` with no host; returns early when hidden); barrier stops taking mouse at once; embedded guide leaves Esc to ModalStack; door return guarded against layout flip, scene exit or a newer modal.
A4 Upgrades rows and ResearchQualitySelector: G-only build path with a type variation and `get_font_size("body")`, no modulate dimming; same purchase handlers and checks.
A5 Refusals visible in G: `EventResultPresenter.present_error` reaches a visible G toast (host signal preferred; reparenting the old toast acceptable as a stopgap); test an early UI refusal and a backend rejection. Action rows use the same unrounded affordability and aggregate-plus-typed Attention checks as today; only displayed amounts are rounded. Parity tests: empty queue, reserved pool, unaffordable action.
A6 WATCH: held = remaining reserve (`state["attention_reserved"]` / `reserve_remaining()`), keep the last pre-boundary snapshot for the closed face and omit counts without one, per-option prices via the existing presenter, the four WATCH sub-states (V peek, playback, boundary event, review) defined explicitly.
A7 Review/event paper: G geometry and style behind a G-only path, classic `apply_geometry` untouched; GPaper applies `g_theme` itself (events mount on root); G geometry test.
A8 Handoff: workers read design inputs from a pinned `design/ui-concepts` commit, read-only; fork tools committed only on `lean` (separate fork commits) or `design/ui-concepts`, never on `ui/g-*`; hidden guards run against the real worktree root, plus `check_pause_timers.py --self-test`; a concrete same-seed fixture (known seed, accepted action ids, an enabled event choice, asserts both runs reach the review and the next month); spike reruns write screenshots to scratch.
A9 Provenance: records only for media extensions the guard scans; OFL and source notes beside fonts; provenance audit in each asset-bearing phase; Alex is asked to approve the `godot/data/asset_provenance.json` edit as a metadata exception (the default if he does not decide is item V4 below).
A10 Room and contrast: no compile-probe; render the production material on Forward+ and Compatibility in phase 3; `room_effects = "simple"` is the documented fallback (and when GPU cost misses the budget); lift the "0" red to >= 4.5:1; contrast capture includes custom-drawn text (GDateline, GDoomCard).
A11 Art: tier shares fit above the baseline (tier 4 <= ~0.88-0.90); separate framing/crop recipes for smoke and paper; schedule the paper batch; say Feed/In-tray placeholders are unused in G; six action icons generated transparent; a G-only action-id-to-file map in GActionsPanel with fallbacks for `scout_read` and `tour_offices`.
Non-blocking N1-N3: art judged at 32/40 px beside Pip's rail icons (Alex decides); voice pool tail truncation and speaker latency checked on Alex's PC; small wiring (feed_changed emitted before the filter return and await; advisor hook at `_clear_first_lever_nudge`; reconcile 6.2 vs 7.3 on the review dateline; Settings row in Col1 or Col3 plus the board-fit test; scene font-size census at 125/125).

## Open items: one vote each

V1 Commit plate click.
  (a) Opus: the plate click takes the end-turn path (`_on_end_turn_button_pressed`, disabled while the queue is empty, keeps its warnings); Enter keeps the commit-plan path.
  (b) Neon: one button whose click calls `_on_end_turn_button_pressed()` when the queue is non-empty and `_on_commit_plan_button_pressed()` when it is empty, so an empty reactive month stays clickable; Space and Enter keep their handlers.
  (c) Sol: preserve both existing intents and their eligibility (say which surface carries each).

V2 Attention card and event prices.
  (a) Opus and Neon: add a read-only `EventDialog.current_event` (set in `_show_next_event`, cleared on close) for the card; prices per option via the existing presenter.
  (b) Sol: put the price on the existing option rows only and leave the generic price off the Attention card; no new EventDialog property.

V3 Keyboard focus inside a sheet.
  (a) Opus: drop keyboard focus; the detail card follows hover only (classic modals have no Tab path either; `main_ui.gd:567-569` eats Tab).
  (b) Neon and Sol: allow Tab traversal inside the top `g_*` sheet (an exception in the modal router).

V4 Provenance default if Alex does not approve the data/ edit.
  (a) Opus and Neon: hold the records in a fork file (e.g. `fork/design/godot-g/provenance.json`) until the change goes to Pip.
  (b) Sol: without approval, asset-free work proceeds and new PNG/WAV files wait; a fork record cannot clear Pip's guard.
  Orchestrator's factual context: `check_provenance.py` is hidden in this fork's sparse checkout and is not among the fork's checks in AGENTS.md section 4; it runs in Pip's CI, i.e. when a change goes upstream.

V5 E (Staff) and F1 (Guide) while a G modal is on top.
  (a) Opus: GKeys returns "" for E and F1 whenever any modal is on top; F1 closes the guide when the guide is top.
  (b) Neon and Sol: E dismisses any G-owned modal, then opens Staff; F1 toggles the guide.

V6 Closing a sheet.
  (a) Opus and Sol: `hide_panel()` sets `visible = false` at once; any fade is cosmetic only and never keeps the sheet visible or focusable.
  (b) Neon: either that, or emit a zero-arg `closed` at once with the barrier off and hide at the end of the 0.08 s fade.

V7 NEW (Sol): saved profiles can already bind A to Commit (`keybind_manager.gd:164`), and loading keeps it alongside a new G default; the G router would intercept it. Sol's fix: existing bindings win on the desk and any conflicting G keycap is hidden. Opus and Neon: agree, disagree or different fix, with evidence.

Reply with one line per V item: your vote, and whether you accept the majority. If you do not accept a majority on an item, say why it blocks. Rules as before; Disk section if you made anything.

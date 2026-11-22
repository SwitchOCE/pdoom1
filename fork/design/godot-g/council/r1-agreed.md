# Council round 1: the agreed change list

Settled by the three members (Opus, Sol, Neon) on 2026-11-22. Items A1-A11 and N1-N3 are as written in r1-vote.md, agreed by all three. Vote results for V1-V7 below; where a member accepted the majority with conditions, the conditions are folded in (they do not contradict the majority).

## Votes

| Item | Opus | Sol | Neon | Result |
|---|---|---|---|---|
| V1 Commit plate | b | c (conditions) | b | (b) with Sol's conditions |
| V2 Event prices | a | b (accepts a if read-only, per-option prices) | a | (a) with conditions |
| V3 Tab in sheets | b | b | b | (b) |
| V4 Provenance default | a | b (accepts fork records for staging only) | a | (a) with Sol's limit |
| V5 E/F1 over a G modal | b | a (accepts b with conditions) | b | (b) with conditions |
| V6 Closing a sheet | a | a | a | (a) plus focus release |
| V7 Saved binds vs G keys | agree | proposer | agree | Sol's fix |

## The decisions to write into the spec

- **V1.** The G Commit plate is one control. With a non-empty queue its click runs exactly today's end-turn path (`_on_end_turn_button_pressed`: same warnings, same eligibility). With an empty queue it runs today's commit-plan path (`_on_commit_plan_button_pressed`), so an empty reactive month stays clickable as it is in classic (`commit_plan_button` is never disabled in plan, `main_ui.gd:1424`). The plate's caption or state shows which of the two it will do. Space and Enter keep their existing handlers. Sol's condition: the warnings and eligibility of the non-empty click are exactly today's; state this in 5.6 and 10.7 with a parity test for both branches.
- **V2.** Add a read-only `EventDialog.current_event` (set in `_show_next_event`, cleared on close), listed in 2.5. Prices stay specific to each option via the existing presenter (`window_attention_for_option`); the card never shows one generic price for a window that has free and paid options.
- **V3.** Tab moves focus inside the top `g_*` sheet: the modal router lets Tab through for G sheets, and focus stays inside the top sheet.
- **V4.** While work stays in the fork, provenance records for new media live in a fork file (`fork/design/godot-g/provenance.json`, committed as a fork commit, never on a `ui/g-*` branch) unless Alex approves the `godot/data/asset_provenance.json` edit. Sol's limit: the fork file is staging only. Before any change goes to Pip (AGENTS.md section 8), the records move into `godot/data/asset_provenance.json` on the `up/<slug>` branch and Pip's provenance guard must pass there.
- **V5.** E closes any G-owned modal (only G's own sheets and the embedded guide) and then opens Staff; F1 toggles the guide. A must-answer event keeps its priority: neither key acts while an event dialog or the review is up.
- **V6.** `hide_panel()` sets `visible = false` at once and releases mouse and keyboard focus at once; any fade is cosmetic only (it never keeps the sheet visible, focusable or taking input).
- **V7.** Before GKeys claims a key on the desk, it checks that no existing bind already uses that keycode; if one does, the existing bind wins and the conflicting G keycap is hidden. Test: a saved profile with Commit on A.

Apply A1-A11, N1-N3 (as notes or small fixes) and V1-V7 to spec.md and build-prompt.md. Nothing else: no new scope.

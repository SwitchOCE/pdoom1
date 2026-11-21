# Round 1 consensus -- neon

## Response to other members' blocking items

### Cross-concept
1. **Standard Hiring's 1 held hour (Sol, all four + showcase, state 4):** **Agree.** Verified in `godot/scripts/ui/event_dialog.gd:90-125` (`costs_with_window_attention` folds `WindowResolver.attention_cost = 1` into every handled non-free option that omits `attention`, leaving Decline free). All four concepts, `run-state.md` and `index.html` should show Standard Hiring as `$25,000 + 1 held hr` (keeping Fast-Track selected so state 5 stays unchanged).
2. **720p operational text floor / responsive layout at 1280x720 (Sol: A.1, C.1, E.1, G.1):** **Disagree -- drop to non-blocking.** `godot/project.godot` uses `stretch/mode="canvas_items"`, `aspect="expand"`, so the real game scales its 1920x1080 canvas uniformly to 1280x720 (a 16px label renders at ~10.7px). The designer brief explicitly asked for uniform scaling "the way the game does", and all 24 720p renders have zero overflow, overlap or clipping. Rebuilding all four concepts with a second responsive layout at 720p is structural redesign outside one fidelity fix round. Keep as a non-blocking note (and one line in the report/showcase).
3. **NEW chips / "new this month" on Safety Audit and Strategic (Sol: A.2, E.2, G.2):** **Agree.** Confirmed in `godot/data/actions/core.json` (`turn_min: 5` and `turn_min: 10` in workdays, plus `reputation_min: 30` for Strategic). Neither unlocks in month 5, and C already omitted the chips for this reason. Drop the NEW chips / "new this month" text from A, E and G so all four agree with the code and with C.

### A
4. **State 5 mixed `01..11` / `14` column + state 4 missing effects (Sol: A.3; Neon: A.1):** **Agree on both.** In `A/s5.png`, putting play indices `01..11` in the same unlabeled column as day `14` (after `A/s4.png` used that column for dates `01` / `14`) reads as actions finishing on days 1-11, contradicting "every play executes at Commit". Group Commit plays under `01 Nov` (or label the Commit block `01 Nov` and give the event `14 Nov`), and add `+1 safety researcher` (and `no change` on Decline) to state 4's options.

### C
5. **States 4-5 Work Your Connections prints "done" instead of the game's message (Opus: C.1):** **Agree.** `godot/scripts/core/hiring_pipeline.gd:157` has `"Reached out through your network -- a pre-vetted lead may surface shortly."`, which A and E already print. Use the real message in C's teleprinter (s4) and review sheet (s5), checking that both still fit cleanly without overflow.
6. **State 1 Advisor note shows `Got it [Esc]` while Commit shows `Enter` (Sol: C.2; Opus non-blocking):** **Agree.** Two layers advertise focus keys at once, against `r2s-agreed.md` rule 2. Swap `Got it [Esc]` to a plain dismiss button (`Got it` or `x`, no `Esc` keycap), matching E and G.
7. **State 2 dotted empty card frames + Publish Safety Paper icon (Sol: C.3):** **Disagree -- drop to non-blocking.** `godot/data/icon_mapping.json:26` maps `publish_paper` to `action_research_formal_verification_64.png`, so C followed Pip's own mapping (and documented it in `C/notes.md:283,301`). The dotted empty slots in the 4-column card box are clean tray geometry with no placeholder text. Both are taste/polish rather than fidelity defects.

### E
8. **State 3 Commit shows `Enter` while Plan CRT owns `[Esc]` (Opus: E.1; Sol: E.3 first half):** **Agree.** Both Opus and Sol flagged this under `r2s-agreed.md` rule 2, and A, C and G all hide Commit's `Enter` while Plan is open. Hide Commit's `Enter` in state 3.
9. **State 3 receipt headed `AFTER COMMIT` prints `26` rep and `-12` research (Sol: E.3 second half):** **Agree.** `run-state.md` REVISION 2 asks for `"after costs"` (costs only). Heading the printout `"AFTER COMMIT"` makes `26` rep / `-12` research look contradictory when state 4 immediately shows `34` rep / `-6` research. Re-head the printout `"AFTER COSTS"` and label `-12` as current research (`Research (now)`).
10. **State 2 duplicate `Enter` on Safety Audit (Sol: E.2 second half; Opus & Neon non-blocking):** **Agree (small fix bundled with E's state 2 edit).** Removing `Enter` from either the focused row tab or the bottom detail strip (keeping one `[Enter] Add to plan`) is a trivial cleanup while already editing state 2 to drop the NEW claims.

### G
11. **State 3 Reserve gated on operating hours and disabled (Opus: G.2; Sol: G.4; Neon: G.1):** **Agree (unanimous).** `ADR-0011` amendment 2026-07-28 (f) and `godot/scripts/core/month_plan.gd:235-244` make Reserve untyped; with 7 planning hours left, enable `Reserve hours [R]` and drop `(needs operating hours)`.
12. **States 4-5 Wed 1 Nov feed tail out of queue order and inconsistent between states (Opus: G.1):** **Agree.** Verified in `G/concept.html:618-633`: s4 shows rows 5, 8, 7, 11 (out of order) and s5 shows rows 5, 8, 10 (dropping row 11 and swapping Meetups #1 for #2). List the tail in queue order (rows 8, 9, 10, 11, matching E) and keep the Wed 1 Nov lines consistent across s4 and s5.
13. **State 3 collapsed `Read the Literature x2` / `&expand=read` pushes spill row below fold (Sol: G.3; Neon non-blocking):** **Agree.** Showing two individual `Read the Literature` rows in the state 3 still (no extra group header row, adjusting row height a few px if needed so all 11 rows fit without scrolling) proves `r2s-agreed.md` rule 4 in the static showcase without pushing Order Office Supplies below the fold.

### Showcase page (`index.html`)
14. **All orchestrator items (Opus 1-2, Sol 1-3, Neon note):** **Agree with all.** Fix E's caption (no "Desk" station; Actions, Plan, Lab Floor, Procurement, Records), update state 4's caption for Standard Hiring's 1 hr, constrain the lightbox image inside the viewport below its bar, make thumbnails keyboard-focusable buttons with lightbox focus restore, rename "Interactive version" to "HTML mockup", and ensure `report.md` / `.md` links resolve in the published bundle (or drop unbundled `.md` links).

---

## Proposed joint list

### Blocking (for the one fix round)

**All four concepts (and `run-state.md` / `index.html`)**
1. [state 4, both sizes] Show Standard Hiring as `$25,000 + 1 held hr` (matching `event_dialog.gd:90-125` and `WindowResolver`). Keep Fast-Track selected so state 5 is unchanged.

**A**
1. [state 2, both sizes] Drop the unsupported `NEW` clips on Safety Audit and Strategic.
2. [state 4, both sizes] Add `+1 safety researcher` to Fast-Track Hiring and Standard Hiring (and `no change` to Decline Offer).
3. [state 5, both sizes] Separate the `01..11` play list from the `14` event date in the left column (label Commit plays `01 Nov` and the event `14 Nov`) so plays do not read as finishing on days 1-11.

**C**
1. [states 2, 3 and 5, both sizes] Raise `.wall` (or at least the P(Doom) counter and top wall strip) above `.dim` so `56.7%` / `BAND SEVERE` (currently 1.70:1 / 2.74:1) and `40.2%` (2.39:1) stay legible.
2. [state 1, both sizes] Replace `Got it [Esc]` on the Advisor note with a dismiss button without an `Esc` keycap so only one layer advertises focus keys.
3. [states 4 and 5, both sizes] Replace `Work Your Connections: done` with the game's message `"Reached out through your network -- a pre-vetted lead may surface shortly."` (`hiring_pipeline.gd:157`), keeping both layouts overflow-free.

**E**
1. [state 2, both sizes] Drop the unsupported `NEW` badge on Strategic and `"new this month"` on Safety Audit, and show `Enter` only once for the focused Safety Audit card.
2. [state 3, both sizes] Hide Commit's `Enter` keycap while the Plan CRT owns `[Esc]`.
3. [state 3, both sizes] Re-head the printout from `AFTER COMMIT` to `AFTER COSTS` and label `-12` as current research (`Research (now)`).

**G**
1. [state 2, both sizes] Drop the unsupported `NEW` chips on Safety Audit and Strategic.
2. [state 3, both sizes] Enable `Reserve hours [R]` and replace `"Reserve (needs operating hours)"` with untyped `Reserve` (ADR-0011 amendment (f), `month_plan.gd:235-244`).
3. [state 3, both sizes] Show `Read the Literature` as two individual rows in the state 3 still so all 11 plays and their edit targets fit without scrolling and keep Order Office Supplies visible.
4. [states 3, 4 and 5, both sizes] Replace violet `--held:#B39AC0` with a non-purple neutral/warm token so purple stays reserved for art band 3+ (`PALETTE_AND_DOOM_INTENSITY.md`, `run-state.md`, `G/notes.md:173`).
5. [states 4 and 5, both sizes] Put the Wed 1 Nov feed tail in queue order and keep it consistent across s4 and s5.

**Showcase page (`index.html`, orchestrator)**
1. Fix E's caption (Actions, Plan, Lab Floor, Procurement, Records -- no "Desk" station) and update state 4's caption for Standard Hiring's 1 hr.
2. Constrain the lightbox image height to fit below the lightbox bar at 1080p and 720p.
3. Make thumbnails keyboard-focusable buttons with focus management into/out of the lightbox.
4. Rename "Interactive version" to "HTML mockup" and verify `report.md` / `.md` links resolve in the published bundle.

### Dropped to non-blocking
- 720p responsive text-size rebuild across A, C, E, G (Sol A.1, C.1, E.1, G.1) -- matches Godot's `canvas_items` stretch; redesign out of scope.
- C state 2 dotted empty card frames and Publish Safety Paper `formal_verification` icon (Sol C.3) -- Pip's own `icon_mapping.json` entry; aesthetic polish only.
- All remaining Round 1 non-blocking items from all three members (A state 4 rack reorder/keycaps, A state 1 Advisor dismiss, A/C state 5 "decisions" vs "hours", C state 5 sheet title / s3 inline door column, E dial housing plum / s6 sky top edge / s3 edge arrows, G rail border / s2 row spacing / s4 confirm key / s5 feed destination).

---

## Scores (revised after reading Opus and Sol)
A 8/10 . C 8/10 . E 8.5/10 . G 7.5/10

Revised down 0.5 each to reflect the cross-concept Standard Hiring hour, unsupported NEW chips, A's state 5 date/number column, C's state 1 keycap and "done" line, E's state 3 Commit `Enter` and `AFTER COMMIT` heading, and G's feed order and state 3 collapsed group. All four are close and one fix pass away from showcase-ready.

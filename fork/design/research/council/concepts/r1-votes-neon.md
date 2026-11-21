# Round 1 votes -- neon

## Votes on open items 1-10

| # | Item | Vote | Accept majority? | Reason / source evidence |
|---|---|---|---|---|
| 1 | A door: lighten dimmer | **blocking** | Yes | Current dimmer drops contrast heavily on the CRT plan and top-right readouts while picking from a door; cheap CSS fix. |
| 2 | Watch counters: exact figures vs coherent fixture | **coherent fixture** | Yes | Switching to Sol's option: `game_manager.gd:718-722` runs the committed batch before playback, `actions.gd:531` adds `+1.5 rep` for Meetups, and rebuilding A/E's queues changes the totals anyway. |
| 3 | A: operator silhouette in PLAN | **non-blocking** | Yes | `WORKSHOP_2_BACKLOG.md:744` and `BUILD_BRIEF_PLAN_WATCH_UI.md:10-13` place the silhouetted operator in WATCH, not PLAN; adding one in PLAN breaks A's first-person desk conceit. |
| 4 | A: replace watch blob with proper silhouette | **non-blocking** | Yes | Covered by the agreed shared silhouette art pass (removing the sharp `.desk-glow` rectangle behind the head remains blocking under A#8). |
| 5 | C: drop "lose at 100%" text | **blocking** | Yes | Brief Must-hold #6 bars permanent rule/teaching text on the main screen; `RISING` belongs in that slot in m5. |
| 6 | C: reorder buttons 22px -> >= 26px | **blocking** | Yes | 22px targets are cramped for a core control (queue priority order); widening to >= 26px is clean and localized. |
| 7 | C: replace keyhole silhouette | **non-blocking** | Yes | Same shared silhouette art pass as OPEN 4. |
| 8 | E: held hours typed or untyped | **untyped** | Yes | `month_plan.gd:235-244` ("deliberately UNTYPED, and is NOT capped at the operating pool"), `month_plan.gd:345-350` ("4-way LABEL only ... left the crisp reserve's ACCOUNTING deliberately untyped"), and `game_manager.gd:735` (`set_reserve(attention_total - attention_spent)`) prove the held reserve is untyped. `KIND_RESERVE: HOUR_OPERATING` at `month_plan.gd:82` is only a 4-way reporting label, not a pool cap; printing `HELD 5h OPS` misstates the rule whenever planning hours roll into reserve. |
| 9 | E: replace locked rack in WATCH | **non-blocking** | Yes | Yielding to Opus/Sol: de-emphasising the locked rack is enough for R1; replacing it with a new live view is a larger redesign. |
| 10 | E: draw Procurement/Records | **non-blocking** | Yes | `place2.png` (`F2 LAB FLOOR`) already satisfies the brief's deliverable bar ("at least one other place"); drawing F3/F4 is polish. |

I accept the majority outcome on all 10 items (no vetoes).

## Corrections to the merged fix lists

The merged lists are accurate except two minor factual corrections verified in the HTML:

- **A #4 (`16px floor`):** Drop "event option costs" -- `A/concept.html:270` (`.ev-o div span`) is already `16px`. Keep blocked stamps (`.slip-st`), category tabs (`.slip-tab`), `"in plan"` badges (`.clip`), and pins (`.pin-o`/`.pin-done`), which are `14px`.
- **C #5 (`16px floor`):** Drop "memo option costs" -- `C/concept.html:249` (`.ev-ch .c`) is already `16px`. Keep stamps (`.stamp`), badges (`.cf-onf`), key caps (`.key`), hour-pool labels (`.fm-hl`), row numbers (`.fm-no`), and folder tabs (`.cf-card.folder::before`), which are `14px`/`15px`.
- **C #6 (`watch memo`):** Confirm "fold away the duplicate top-bar office thumbnail in full-office views" stays as merged (Opus called it taste, Sol and Neon agreed it cleans up look-up views cheaply).

## Disk report
- Wrote `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r1-votes-neon.md`. No new scratch files written. Nothing under `research/concepts/` or `C:/Users/keech/Documents/pdoom1` was edited.

VERDICT: CHANGES NEEDED

All three are close. Every remaining blocking item is small: a number shown in a format the game does not use, one WATCH state that disagrees with itself, and two displays that disagree with each other. Checked against every new render, `r1-agreed.md` and `godot/`.

Two game facts used below:
- The game shows reputation as a whole number. `GameConfig.format_scalar` -> `format_grouped` rounds to an int (`godot/autoload/game_config.gd:656-688`), and `docs/NUMBER_FORMATS.md` section 2 lists reputation as "whole units". So 21.5 shows as 22, 23.5 as 24, and 24.5 as 25.
- The game runs the whole committed batch at Commit, before day-tick playback (`godot/scripts/game_manager.gd:715-722`, then `_run_month_playback()`). After that, the unspent hours become the reserve, so "available" is 0 (`:729-733`).

## A: CHANGES NEEDED -- 8.5/10

Agreed items 1-8 are all done:
- Work Your Connections is "2 op hr / 6 rep" and Onboard shows a true blocker.
- The queue has 13 rows, each with up, down and remove, plus Undo and Clear. It totals 12 plan + 3 op and $100,300 + 15 rep, and the badges reconcile (Scouting 10 = 7+2+1).
- The calendar shows 30 and 31, and cards keep their slots.
- Text meets the 16px floor, and the DATE column clears the month rules.
- The door view has a lighter dimmer, one Enter target and a fitted card.
- The Ledger tile is real and the duplicate plate is gone.
- watch has Talent Opportunity with "+1 held hr" and Decline free, and the glow box is gone.

Blocking:
1. **The reputation counter shows a decimal.** watch.png, top-right counter "21.5". Show "22", the game's whole-number format.
2. **The watch counters and the in-flight list disagree.** watch.png: IN FLIGHT rows 09-13 are pending (empty bars), and the teleprinter has dated results up to NOV 14. But the counters already include those rows: research 9 = -12 + 7 reads x 3. The game runs every row at Commit (game_manager.gd:715-722), so nothing is pending mid-month. Fix: mark all 13 rows done, and date their teleprinter lines 01 Nov, as C and E do. Keep the counters as they are.

## C: CHANGES NEEDED -- 8.5/10

Agreed items 1-6 are all done:
- WYC is "2 op hr, 6 rep" with no stamp. Onboard shows "op hr + money, varies by step" (m1: Nobody hired).
- The form has 14 valid rows totalling 12 plan + 3 op and $60,300 + 6 rep, and the badges reconcile (Scouting 11 = 1+6+4).
- Strategic reads "4 choices, 1 open now". P(Doom) shows RISING, and "lose at 100%" is gone.
- NO. and ORDER are separate columns, the reorder buttons are 26px, the gantt labels are clear, the "on form" tags sit top-right, and the stamps are 16px.
- In the memo, the paperclip is off the stamp, both hires show "+1 held hr", the reply is pending, held hours are shown once, and the window blinds are down.

Blocking:
1. **The reputation counter shows a decimal.** watch.png, top-right "23.5". Show "24".

## E: CHANGES NEEDED -- 8/10

Agreed items 1-5 are done, except part of item 4:
- The m5 queue is 12 plan + 3 op, $60,300 + 6 rep, and WYC is 2h OPS.
- The dial no longer overlaps the CRT, with RISING and the 100 label.
- The rack has "+" and ">" in one column, Hire Staff shows "1h PLAN each" and is blocked in m5, Onboard shows its step cost, and the OPEN tab sits inside the frame with "OPEN: SCOUTING" as the panel title.
- watch has Talent Opportunity at +1 held hr, and the counters are coherent ($79,700 / research 12 / reputation 24.5, shown as 25, which is correct).
- The Lab Floor name tag sits above the sprite.

Blocking:
1. **Held hours are shown twice (agreed item 4, partly done).** watch.png, top-left Attention card: it shows "OPS 5 left" and also "HELD FOR EVENTS 5h". After Commit the unspent hours become the reserve, and available is 0 (game_manager.gd:729-733). Fix: show the 5 OPS boxes as held, or "0 left", so the 5 hours appear only once, as held for events.
2. **The Scouting door's queued counts are incomplete.** m5.png, the right-hand Scouting panel: only Go to Meetups carries a "1 queued" tag, but the queue holds Read the Literature x8 and Post Online x3. Add "8 queued" and "3 queued" tags in the same spot.

## Non-blocking
1. E's grouped rows ("Read the Literature x8", "Post Online x3") share one set of up/down/remove controls, so it is unclear whether a control acts on one play or all eight. A shows one row per play. Not in E's agreed list.
2. C's notes say there are "no RNG actions", but Desperation Lever draws from `state.rng` (`actions.gd:572`, `Ledger.desperation_payroll(state.rng)`). It plants a secret liability and does not change any shown counter, so nothing on screen is wrong. Only the note is.
3. A's watch teleprinter has about 80px of empty paper above the first line (y ~700-780).

## Disk report
I wrote only `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r2-opus.md`. Nothing new in scratch. The round-1 crops (about 31 MB in `C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/18510e2e-a3f1-4406-bc1c-8247e8dffee0/scratchpad/`) can be deleted.

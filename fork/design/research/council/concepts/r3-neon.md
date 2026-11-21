VERDICT: GOOD TO GO

# Council re-check (round 3) -- neon

Checked all 14 current renders across A (m1, m5, door, place2, watch), C (m1, m5, door, place2, watch), and E (m1, m5, place2, watch), plus a fresh CSS/font/ASCII/game-data pass on each `concept.html`. Every blocking item from `r1-agreed.md` and round 2 (`r2-consensus-opus.md`, `r2-consensus-sol.md`) is resolved with no regressions or new contradictions with `godot/` data.

## A: READY -- 9/10

- **R1 #1 (Card costs): DONE.** `m1.png` and `m5.png`, action tray: `Work Your Connections` reads `2 op hr` / `6 rep` (available in m5); `Onboard New Hires` reads `op hr + money` / `varies by step`, stamped `NOBODY HIRED YET` (m1) and `NO HIRES WAITING` (m5).
- **R1 #2 (m5 CRT queue & badges): DONE.** `m5.png`, center CRT: 13 individually editable rows (`01..13`), each with `^`, `v`, `x`, plus `Undo [Z]` and `Clear [C]`; `Pay the Bill` replaced by valid priced plays (`Safety Audit` `$40,000` 2 op hr, `Public Warning` 15 rep 2 plan hr). Hours (`12 plan + 3 op`), totals (`$100,300 + 15 rep`), and folder badges all derive from the rows in one unit (`Hire Staff 1`, `Publicity 1`, `Safety Audit 1`, `Scouting 10` = `7 + 1 + 2` in `door.png`; `Financing` badge gone).
- **R1 #3 (Calendar & stable slots): DONE.** `m1.png`, top-left calendar renders row 6 (`30`, `31`). Both `m1.png` and `m5.png` use fixed 9-column slots (`Publish Safety Paper` stays at row 1 col 9; `Safety Audit` and `Strategic` append to row 2).
- **R1 #4 (16px floor): DONE.** Static CSS audit confirms `.slip-st`, `.slip-tab`, `.clip`, `.pin-o`/`.pin-done`, key hints, and WATCH event option costs are all >= 16px; nothing < 14px; pure ASCII.
- **R1 #5 (m5 gantt): DONE.** `m5.png`, CRT `UNDER WAY`: dates sit in their own `DATE` column, completely clear of `NOV | DEC | JAN 2018 | FEB`.
- **R1 #6 (door view): DONE.** `door.png`: lighter dimmer keeps CRT and instruments legible; detail card fits its content; `Enter` shows only on `Go to Meetups` (hidden on `COMMIT`).
- **R1 #7 (place2): DONE.** `place2.png`: Ledger tile reads `What the lab owes, by the month each bill lands.` with `OPEN LEDGER [L]`; duplicate `UPGRADES` footer plate removed.
- **R1 #8 + R2 #1-3 (watch & rack rails): DONE.**
  - Rack rails sit cleanly below every stamp and `open >` / `add +` control on both tiers across `m1.png`, `m5.png`, `door.png`, and `place2.png`.
  - `watch.png`: `Talent Opportunity` (Nov 14, eligible in m5) prices both hiring options `$25,000 + 1 held hr` and `Decline Offer` `free`; all 13 plays show `[DONE] 01 Nov` under `THIS MONTH - run at commit, 01 Nov`; teleprinter logs grouped 01 Nov batch outcomes using the game's own result strings (`actions.gd:705,735`); counters match the completed batch (`$39,700`, research `9`, reputation `22` rounded from `21.5`); `Held for events: 5 hr` is untyped; the hard-edged `.desk-glow` rectangle behind the operator is gone.
- **Blocking items:** None.

## C: READY -- 9/10

- **R1 #1 (WYC, Onboard, m5 form): DONE.** `m1.png` and `m5.png`, card file & Form A-20: `Work Your Connections` reads `2 op hr, 6 rep` (available, no stamp); `Onboard New Hires` reads `op hr + money, varies by step` (`NOBODY HIRED` in m1, available in m5). Rebuilt 14-row m5 form uses valid priced actions totalling `12 plan hr + 3 op hr`, `$60,300 + 6 rep`, `0 of 12 free`, `5 of 8 free`, with all `on form` badges reconciling (`Scouting 11` = `1 + 6 + 4` in `door.png`; `Financing 1`, `Hire Staff 1`, `Work Your Connections 1`).
- **R1 #2 (Strategic): DONE.** `m5.png`, bottom-left card file: `NONE AFFORDABLE` removed; reads `4 choices >` / `1 open now`.
- **R1 #3 (P(Doom)): DONE.** `m5.png`, `door.png`, `place2.png`, `watch.png`, top center: shows `40.2% RISING`; permanent `lose at 100%` text removed.
- **R1 #4 (Form & card polish): DONE.** `m1.png` and `m5.png`: `NO.` and `ORDER` sit in separate columns; reorder buttons enlarged to `26px`; under-way dates sit 14px clear of the `NOV` rule; `on form N` is pinned consistently to the top-right corner on every card and door slip with zero collisions; titles on unavailable cards are crisp full contrast.
- **R1 #5 (16px floor): DONE.** Static CSS audit confirms `.stamp`, `.cf-onf`, `.key`, `.fm-hl`, `.fm-no`, `.cf-card.folder::before`, and memo option costs are all >= 16px; nothing < 14px; pure ASCII.
- **R1 #6 + R2 #1 (watch memo & reputation): DONE.** `watch.png` and `place2.png`: paperclip moved to center-top clear of `NEEDS ANSWER`; both hiring choices show `$25,000 + 1 held hr` and `Decline Offer` shows `free`; `PAUSED` reads `awaiting your reply` (no `Space resume` hint); top-bar office thumbnail has blinds closed in look-up views; `HELD FOR EVENTS 5 hr` shown once, untyped; all 14 rows ticked `[x]` on `1 Nov`; counters reconcile (`$79,700`, research `6`, reputation `24` rounded from `23.5`, with `+1.5 reputation` in teleprinter matching `actions.gd:539`).
- **Blocking items:** None.

## E: READY -- 8.5/10

- **R1 #1 (m5 queue & WYC): DONE.** `m1.png` and `m5.png`, rack & CRT: `Work Your Connections` reads `2h OPS` / `6 rep` (available in m5); rebuilt queue (`Hire: Safety Researcher`, `Work Your Connections`, `Go to Meetups`, `Read the Literature x8`, `Post Online x3`) totals `12h PLAN` (`0 left`) and `3h OPS` (`5 left`), matching the time card and footer (`14 queued . $60,300 + 6 rep committed`).
- **R1 #2 (Top frame): DONE.** `m5.png`, `place2.png`, `watch.png`: `^ RISING` on `P(DOOM)`; `100` endpoint label on `REPUTATION`; CRT lowered clear of the `P(DOOM)` instrument bezel with zero overlap.
- **R1 #3 + R2 #2-3 (Rack, Scouting badges, Onboard fixture): DONE.** `m1.png` and `m5.png`: aligned `+` buttons on all direct actions matching `>` on doors; `Hire Staff` reads `door . 7 roles . 1h PLAN each` with `x no planning hours` in m5 while staying inspectable; `Onboard New Hires` reads `OPS hrs | money varies by step` and derives its state from explicit `onboardEligible` (`nobody hired` in m1, `no hires to onboard` in m5, available in watch after Jonah's 01 Nov hire); `OPEN` tab stays flush inside the rack frame and links to the amber-edged `OPEN: FUNDRAISING` / `OPEN: SCOUTING` folder; ~50px breathing room below `Strategic`; `m5.png` Scouting choices show `8 queued`, `1 queued`, `3 queued` matching the CRT. Static CSS audit confirms zero rules below 16px and pure ASCII.
- **R1 #4 + R2 #1 (watch & held hours): DONE.** `watch.png`: `Talent Opportunity` (9 Nov, eligible in m5) with `$25,000 +1 held hr` on both hiring options and `free` on Decline; all rows `[x] done 01 Nov`; counters reconcile (`$79,700`, research `12`, reputation `25` rounded from `24.5`, `2 staff`); time card reads `12 spent` / `3 spent` with 5 dashed unspent OPS boxes and `HELD FOR EVENTS 5h` shown once, untyped.
- **R1 #5 (Lab Floor): DONE.** `place2.png`: `Maya Haddad` name tag sits centered directly above her sprite; `COMING` list matches the rebuilt queue.
- **Blocking items:** None.

## Non-blocking notes

1. **E WATCH locked rack contrast:** In `E/watch.png`, the locked left rack keeps crisp `+` / `>` button fills even though the header says `LOCKED UNTIL MONTH END`; dimming the controls along with the rack (or replacing the rack later) will reinforce the locked state.
2. **E grouped queue rows (`x8`, `x3`):** In `E/m5.png`, repeated Scouting plays share one set of `^ v x` controls; when made interactive, clarify whether reorder/remove moves one play or the whole stack (or expand rows as A and C do).
3. **A WATCH teleprinter top margin:** In `A/watch.png`, bottom-aligning the 8 feed lines leaves ~100px of blank paper at the top of the teleprinter box; looks fine as a rising paper roll, though top-aligning would match C and E.

## Disk report
- Wrote `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r3-neon.md`.
- No new scratch files written in round 3. Earlier scratch files from round 1 and consensus (17 files, 1,352,157 B in `C:/Users/keech/.t3/userdata/providers/antigravity/ac0a3dfd6dddb20962cecff6ee5fe65e19d3923be20e52c5ab52ff877f7e4c32/antigravity-acp/brain/0a82ea1d-5ed7-4a08-b506-5c724e2456ca/scratch/`) can all be deleted safely. Nothing under `research/concepts/` or `C:/Users/keech/Documents/pdoom1` was edited.

# Round 2 consensus -- opus

## Single-member items

- **(sol) A, the rail covers the footers: agree, blocking.** I checked at 2x (A/m5.png, y 840-1080). The rail crosses the bottom border of every upper-tier stamp ("NO PLANNING HRS LEFT", "COMING SOON", "NO HIRES WAITING") and the bottom of the ">" and "+" buttons. On the lower tier it also crosses the button bottoms. The cause is the rail at `top+154` against cards about 164px tall (A/concept.html:570). These are operated controls clipped by an overlap, which round 1's visual bar forbids. Fix: move the rail to `top+166` or later, or shorten the card so the footer ends above the rail.
- **(opus) E, the Scouting door's queued counts: I keep this blocking.** E/m5.png, Scouting panel: "1 queued" is shown on Go to Meetups only, while the CRT queues Read the Literature x8 and Post Online x3. One display contradicts another on the screen Alex will see, and the fix is two tags.
- **(sol) E, Onboard's blocker is inferred from the staff count: agree, non-blocking.** E/concept.html:315 sets `off: S.staff ? "no hires to onboard" : "nobody hired"`. The rendered text is plausible for the pictured state: the existing hire joined in September, and the queued hire is not yet hired in PLAN. No render is wrong; only the fixture logic is loose. A one-line fixture flag is fine if the designer is already in the file, but it should not hold the round.

## Joint blocking list

**A**
1. WATCH reputation "21.5" should display as "22" (game_config.gd:656-688).
2. WATCH: mark all 13 batch outcomes done on 01 Nov, both in IN FLIGHT and on the teleprinter (the game runs the batch at Commit, game_manager.gd:715-722). Keep the memo's own date, Nov 14. Keep the counters.
3. Rack: the rail must clear the stamps and the add/open buttons on both tiers, in m1, m5, door and place2.

**C**
1. WATCH reputation "23.5" should display as "24".

**E**
1. WATCH time card: show the five hours once, as held for events. Drop "OPS 5 left", or show 0 left.
2. m5 Scouting door: add "8 queued" on Read the Literature and "3 queued" on Post Online, in the same spot as Meetups' tag.

Everything else, in both files, is non-blocking.

## Disk report
I wrote `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r2-consensus-opus.md` and one scratch crop, `A_rail.png` (about 0.5 MB, in my scratchpad). The whole scratchpad (about 31 MB) can be deleted.

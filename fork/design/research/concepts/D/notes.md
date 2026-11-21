# Concept D: The Card Table

## Concept

P(Doom)1 plays on a spruce-baize card table inside the dimly lit lab office, taking Pip's "deal the cards from the hand you've got" literally. You slot warm manila action cards from a fanned hand into numbered priority slots, spend brass Planning chips and steel Operating tiles, and watch P(Doom) glow from the bakelite rig above as room light sours.

## Places and Navigation

- **PLAN Table (`?view=m1`, `?view=m5`):** Fixed room horizon and instrument ledge above; Priority Order slots, pinned graph-paper `Already Under Way` slip, and fixed `Commit` stamp in the middle; all 15 (M1) or 17 (M5) cards fanned below. Clicking a stacked Door card fans its sub-deck upward without blocking the queue.
- **Office Credenza (`?view=place2`):** Reached via `[2] CREDENZA` or `[U]/[E]/[L]/[G]`. Holds Staff Dossiers, all 7 Upgrade cards, Liability Ledger, and Staff Handbook; `[ESC]` returns to the table.
- **WATCH Floor (`?view=watch`):** Entered via `Commit [ENTER]`. Shifts to the operator's desk with Live Log left, printed event slip center, playback right, and committed plays running as verb rings below.

## Borrowed From

Cultist Simulator (baize table, aspect-coded cards, verb rings), Inscryption (manila woodcut cards framed by the room), Papers, Please (manila slips, ledger), Frostpunk (dominant top-center P(Doom) rig).

## Best and Weakest

- **Best:** Instant figure-ground split between playable manila cards and dark blocked cards; stacked Door decks; zero popup overlap; every action visible without scrolling.
- **Weakest:** Fitting 17 legible cards requires two gentle arcs rather than one tight fan, limiting PLAN's room horizon to 204px.

## Visual Quality Pass

Checked `m1.png`, `m5.png`, `place2.png`, `watch.png`: fixed staff-chip clip, Door `::after` tint, `Scouting` footer collision, stack truncation, Credenza/Watch dead space, and 16px slot buttons. Operated text >= 16px, secondary >= 14px, matching SVG sigils, ASCII-only, zero overlaps or unfixed items.

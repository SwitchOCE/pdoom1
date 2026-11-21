VERDICT: CHANGES NEEDED

G is clearly today's game: the same backdrop, top resource bar, "## PLAN" banner, PLAN/WATCH switch, ring gauge with sparkline, queue at the bottom right and left-bound icon list. It is far calmer than `G/before-m5.png`, and it answers Alex's simplify steer. It is also the least diegetic of the four: flat app panels over the art, not objects in the room. Four small fixes are blocking. I looked at every render at full size (home, home-m1, actions, plan, upgrades, watch).

| Concept | Art + empty space | Things to read on home | Simpler? | Score |
|---|---|---|---|---|
| G. Existing UI, modernised | ~66% | 11 groups, about 30 items: month + 5 resources, PLAN banner + switch, Menu, 5 rail buttons, doom card (gauge, RISING, sparkline), Attention (3 rows), This Month (3 rows + "4 more"), Under way (2), Open plan, Commit, Feedback | yes (versus today, a lot) | 7.5 |

**The Must-hold list holds across the flow:**
- All 17 actions are in the Actions menu with cost and blocker, and doors open beside their row.
- The plan drawer shows order, hours, cost, totals, reserve and under-way dates.
- Commit is in one place, bottom right, in every view.
- There is no teaching sentence. "runs top to bottom" and "bought at once, not queued" are short labels.
- There is no per-action doom delta. The old "Doom this turn: Panic +0.5" breakdown is gone; the sparkline shows history only.

**Game facts check out:**
- The month-5 queue sums to 12 plan + 3 op hours and $110,300 + 6 rep. Scouting's 11 = 8 + 1 + 2.
- The second hire is possible: Hire: Compute Engineer does not check the desk cap (`actions.gd:400-409`; only `_hire_from_pool` does, `:896`).
- The upgrade texts are the game's own ("Flavor only for now", `scripts/core/upgrades.gd:23,44`).
- The July Stray Cat in watch is consistent with `turn_exact 7`.

## Ranking among A, C, E, G
1. **E** (8.5): the plainest home and the cleanest menus.
2. **A** (8): the most diegetic, but a busier home.
3. **G** (7.5): the most readable as software, the closest to shipping (its notes map each change to a Godot node), and recognisably Pip's. But it has the most text on home and the least "office with computers" flavour.
4. **C** (7.5): its menus cut across the desk objects. G ranks above it on the tie because it has no overlap defects.

## Blocking fixes (G)
1. **Empty icon frames.** actions.png, icon column (x ~255-295): Advertise a Role, Capability Research, Publish Safety Paper, Operations, Publicity and Strategic show an empty dark square while the other 11 rows have icons. This is Alex's "the icons no longer match the buttons" problem again. Fix: drop the icon column for every row. (Icons can come back only when every row has one that fits.)
2. **Enter has two targets.** actions.png: the open detail card shows "Add to plan [Enter]" while the bar still shows "COMMIT THE MONTH > [Enter]". Fix: while a detail card is open, hide Commit's Enter cap, as A does.
3. **Key clash in WATCH.** watch.png: the event choices use Q / W / E, but E is also the Staff rail key, which is live in WATCH. Fix: number the choices 1 / 2 / 3.
4. **Dead half of the month-1 doom card.** home-m1.png, doom card: the right half is empty (x ~1680-1880), because there is no history yet. Fix: centre the gauge in the card in month 1, or narrow the card to the gauge. Do not add a teaching line there.

## Non-blocking
1. The Actions list spacing is uneven: extra gaps after Onboard New Hires and after Publish Safety Paper, but none between the later groups. Either use one gap per category or none.
2. G keeps today's flat, sans-serif app look over the art. If Alex picks G, a light diegetic pass (a CRT frame on the plan card, a hardware bezel on the doom ring) would add flavour without changing the layout.
3. Before Alex chooses, flag that today's game does not apply the desk cap to Hire: Compute Engineer, so G's month-5 queue seats three people in a two-desk office. That is a possible game bug for a separate fix, not a G defect.

## Disk report
I wrote only `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r2s-G-opus.md`. Nothing new in scratch. The scratchpad (about 39 MB, `C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/18510e2e-a3f1-4406-bc1c-8247e8dffee0/scratchpad/`) can be deleted.

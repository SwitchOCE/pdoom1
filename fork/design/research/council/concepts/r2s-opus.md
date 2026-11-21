VERDICT: CHANGES NEEDED

All three now answer Alex's ask. On each home screen the office art is the largest thing, and the detail has moved into menus. What is left are small visual defects, one per concept (two for C), each fixable in place. I looked at every new render at full size (home, actions, plan, door, upgrades, and the optional home-m1 and watch).

| Concept | Art + empty space | Things to read on home | Simpler? | Score |
|---|---|---|---|---|
| E. Rooms and Stations | ~82% | 10: calendar, P(Doom), reputation, 5 station buttons, This Month card (2 bars + 3 rows), Commit | yes | 8.5 |
| A. The Desk | ~69% | 6 groups, about 20 items: calendar, P(Doom) dial, reputation meter, terminal (3 hour rows, 3 plays, total), rack of 7 plates, Commit + held hours | yes | 8 |
| C. The Paperwork Desk | ~80% | 12: calendar, accounts slip (4 figures), P(Doom), reputation, card box, clipboard (2 hour rows + 2 lines), Staff, Upgrades, Ledger, Guide, Commit | yes | 7.5 |

The Must-hold list holds across each flow:
- all 17 actions are reachable from the action menu, with costs and blockers;
- the plan menu shows order, costs, Attention, reserve and under-way dates;
- Commit stays in one place in every view;
- there is no teaching sentence, only short labels;
- the game facts from round 1 hold, and nothing changes mechanics.

## Ranking
1. **E**: the plainest home. Five labelled stations, one small plan card and Commit over a full-screen office, and the cleanest menus (two-column action list, a CRT plan with large type).
2. **A**: the most diegetic. The dial, meter and terminal are real desk objects. But the home still asks the most of the player (a 7-plate rack plus a terminal of 8 lines).
3. **C**: the right idea (desk objects open menus), but the bottom band is crowded with six objects, and its menus cut across those objects.

## Blocking fixes

### E. Rooms and Stations
1. **The home hour bars mean the opposite of the plan menu's.** On home.png and home-m1.png, the "This Month" card fills its bars with hours *left*: m5 shows PLAN empty at "0 left" and OPS 5/8 filled at "5 left"; m1 shows both full. The Plan menu (plan.png) and the round-1 time card fill boxes for hours *spent* (PLAN 12/12 filled, OPS 3/8). The same fact is drawn two opposite ways. Fix: fill the home bars with spent hours (PLAN full, OPS 3/8 in m5; both empty in m1) and keep the "N left" text.

### A. The Desk
1. **Two plates look selected.** In plan.png the rack shows ACTIONS lit amber and PLAN outlined amber at once, so it is unclear which menu is open. On home.png and home-m1.png, ACTIONS is lit as if it were open. Fix: keep one "open" style for the menu currently showing only. On home, either light nothing, or give the suggested first step a style that differs clearly from "open".

### C. The Paperwork Desk
1. **Menus cut through the desk objects.** In plan.png the Form A-20 panel ends at y ~955. Below it the bottom half of the clipboard (hour boxes, "14 items, $60,300 + 6 rep") shows, plus the tops of the Ledger and Guide cards, and the Action Cards box is half covered on the left. In actions.png and door.png, slivers of Ledger and Guide show under the panel edge (y ~1030-1045). This is the "overlaying specific elements" Alex named. Fix: either end menus above the desk line (y <= ~840), or let the open menu cover or dim the whole desk band, as A and E do.
2. **Key caps sit in different places.** On home.png the "A" cap sits mid-right on the card box, "P" sits top-right on the clipboard, and S / U / L / G sit bottom-right on their cards. Fix: put every key cap in the same corner (bottom-right).

## Non-blocking
1. A watch.png reorders the rack (FEED, STAFF, LEDGER, GUIDE first; ACTIONS, PLAN, UPGRADES dimmed at the bottom), so the plates move between PLAN and WATCH. Fixed slots that only dim would keep muscle memory, since the plates are meant to work as keyboard shortcuts.
2. E door.png has two Esc buttons, "[Esc] Back to desk" on the action list and "[Esc] Close" on the folder. Say which one Esc triggers first, for example "Esc closes folder".
3. All three still use the placeholder operator (agreed art pass). In C it is now the largest flat black shape on the home screen (~380px wide), so the real asset matters most there.

## Disk report
I wrote `C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r2s-opus.md` and one contact sheet, `r2s_optional.png` (about 3 MB), in my scratchpad. The whole scratchpad (about 39 MB, `C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/18510e2e-a3f1-4406-bc1c-8247e8dffee0/scratchpad/`) can be deleted.

VERDICT: CHANGES NEEDED

| Concept | Art + empty | Things to read on November home | Simpler | Score /10 |
| --- | ---: | ---: | --- | ---: |
| A. The Desk | ~70% | 21 | Partly | 7.5 |
| C. The Paperwork Desk | ~79% | 23 | Yes | 8 |
| E. Rooms and Stations | ~82% | 15 | Yes | 8.5 |

I estimated the uncovered share from the visible panel footprints, including the office and operator as art. I counted each shortcut with its key as one thing, each status or balance separately, and each preview row or summary value separately. Decorative labels and shortcut subtitles count with their object. These are reading counts, so they are higher than the designers' object counts. [Before and after](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/round2-before-after.png)

## Ranking

1. **E.** The office is the first thing I see. The five stations make the quickest route from a clean home to the information needed for the next choice.
2. **C.** The paperwork makes Actions, Schedule and Commit feel like different tasks. Form A-20 is the easiest full plan to scan and edit.
3. **A.** The gauges and amber CRT give the desk a strong identity. A large terminal, seven shortcut plates and a separate Commit housing still give the bottom half three competing focal points.

## Blocking fixes

### A. The Desk

1. **Home, lower desk.** Reduce the footprint of the preview and Commit housings. Keep the short preview and Planning/Operating left. Move the extra play count, spend total and explicit reserve setting to Plan. Keep one Commit at its current anchor with the held-hours preview. The large CRT makes sense when it is open for use. [Home](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/home.png)
2. **Actions and Scouting, card rack.** Give Hire Staff an explicit Open affordance even at 0 planning hours. The current stamp replaces its Open control while other folders retain theirs. Add the missing research requirements to the three blocked research cards alongside the hours blocker. Put 0 planning / 5 operating free in the action header so the active menu explains what can still be played. [Actions](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/actions.png) [Card renderer](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/concept.html:403)
3. **Plan and Scouting, reserve and keyboard cues.** Restore the reserve adjustment in the full CRT. It currently prints 0 hr with no way to change it. While Scouting is open, the active slip owns Enter as drawn. Give Esc one visible destination, back to Actions first. The parent header currently still promises Esc back to desk. Keep Commit at the existing bottom-right anchor and make its key availability clear when a menu has focus. [Plan](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/plan.png) [Scouting](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/door.png) [Reserve rule](C:/Users/keech/Documents/pdoom1/godot/scripts/core/month_plan.gd:226)

### C. The Paperwork Desk

1. **Home, pinned accounts slip and desk objects.** Take compute and papers off the home strip and put them in a labelled menu. Money and research have a stated reason to stay, though Actions already handles both. Remove the staff and upgrade counts from the shortcut faces, and let the Schedule preview carry one short queue summary alongside Attention. Keep total spend in the full Schedule alongside its rows. The central negative space works. The extra reading is concentrated on the edges. [Home](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/home.png) [Designer's rationale](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/notes.md)
2. **Actions and Scouting, active card and exit.** Mark the open Scouting folder on its source card and give the foreground folder the sole Esc cue. The parent and folder currently both advertise Esc, and the source card's clip-path clips away its outward focus outline. Use an inset treatment or move the outline to the wrapper. In the People row, give the eligible November Onboard action a clear route to the next step's actual hours and cash before committing. The variable top-level label can stay. [Scouting](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/door.png) [Card and folder renderer](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/concept.html:358)
3. **WATCH clipboard and operational type.** Replace the clipboard's stale "5 of 8 free" in WATCH with the single untyped "Held for events: 5 hr" readout. The 1 November teleprinter line currently carries that readout while the clipboard still presents those hours as available for planning. Raise decision labels at 15px to 16px, including Planning/Operating on the home clipboard, the retained home balance labels and the form's Order/Hours/Cost headings. [WATCH](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/watch.png) [Type rules](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/concept.html:88)

### E. Rooms and Stations

1. **Actions and Scouting, reasons and affordances.** Add the research requirements to the three research blockers alongside "no planning hours." Give the playable Go to Meetups slip an Add control consistent with the rack's plus and a clear focused state. The slip currently reads like a description with a queued badge. With Scouting open, show Esc closing the folder first and make clear what Enter does with focus there. The bright Commit beside the open door advertises Enter even though the folder has a playable choice. [Actions](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/actions.png) [Scouting](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/door.png)
2. **Plan CRT, repeat rows and totals.** Keep compact repeat rows if they can expand to reveal each play in sequence with its own remove and reorder controls. The same three controls are shown for the x8 and x3 groups, with no way to tell how to edit one play. Change "committed" to "queued cost" while the month is still editable. In WATCH use the 14 plays as the completed unit, or explicitly identify the five rows as grouped. [Plan](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/plan.png) [WATCH](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/watch.png)

## Non-blocking

- I inspected all 19 new renders, including the three July homes, three WATCH views and A's Upgrades. The office space looks deliberate, with legible instruments on home, intact foreground text and no action icons to mismatch. I found no other misalignment, clipping, overflow or flat near-black grounds worth sending back.
- All three show the 17 November rack entries, readable costs on the depicted playable choices, dated Under Way items and fixed Commit placement. All three keep the eligible WATCH event's two $25,000 + 1 held-hour options and its free decline. The route and focus review comes from static renders and source. Secondary destinations named in the mockups, undrawn folder contents and live shortcuts remain unverified.
- The operator silhouettes are placeholders. They support the composition now and can wait for the art pass.

## Disk report

Wrote only `research/council/concepts/r2s-sol.md` (about 7.3 KiB). No scratch files or edits to the game or concept assets. The review file can be deleted after the council records its decision.

VERDICT: CHANGES NEEDED

| Concept | Icon matches OK | Person-free | Score /10 |
| --- | --- | --- | ---: |
| A. The Desk | No | Yes | 8.5 |
| C. The Paperwork Desk | No | No | 8 |
| E. Rooms and Stations | No | No | 8.5 |
| G. The Existing UI, Modernised | No | Yes | 7.5 |

I checked the 25 current renders, the before/after sheet, the icon mappings in the HTML and the cited Pip art. "Person-free" here covers scene and event art. Small Staff/Hire pictograms are control labels. All four office backgrounds are empty and the former foreground silhouette space stays open. E's exposed mezzanine and pools of screen light make that absence the most effective. [Round 3 before/after](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/round3-before-after.png)

## Ranking

1. **A.** The plates and card badges absorb Pip's icon style most naturally. The empty aisle keeps focus on the office.
2. **E.** The eeriest home and clearest large shortcut rail. Its travel badge and WATCH illustration need a targeted correction.
3. **C.** The stationery still gives every task a convincing place, but the same radar badge now stands for three different queue plays.
4. **G.** The room stays convincingly empty, including in WATCH. The resource and queue badges fit the existing UI, while a few left-rail and action meanings are less precise.

## Blocking fixes

### A. The Desk

1. **Scouting, Read the Literature.** The purple research-resource tile already means the Research balance in the header. Use a book or document icon for reading. The other Scouting choice badges carry through the dark-tile treatment clearly. [Scouting](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/door.png) [Icon map](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/concept.html:301)
2. **Both homes and Plan, In-tray plate.** The open safe reads as stored records. Use an incoming document or inbox-style badge for the In-tray. Keep its size and left alignment with the other six plates. [Home](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/home.png) [Plan](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/plan.png)

### C. The Paperwork Desk

1. **Plan, Item column.** Go to Meetups, Read the Literature and Post Online all inherit the Scouting radar, though their folder cards carry a group, open book and speech bubble. Resolve icons by play first, or put a parent badge with the source label if that is what the badge describes. The same issue affects Desperation Lever's loan sack. Hire and Connections already carry their matching badges. [Plan](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/plan.png) [Scouting](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/door.png) [Queue renderer](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/concept.html:426)
2. **Actions and Plan, Financing and Connections.** The loan sack and clasped-hands art are unframed beside framed 36px card tiles and 24px plan tiles. Seat them on the same dark backing and keep their presentation size aligned within each group. Their subjects fit their labels. [Actions](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/actions.png) [Plan](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/plan.png)
3. **WATCH, Talent Opportunity memo.** The office itself is empty, but the attached portrait still shows a person. Remove it and close the gap in the memo, or use person-free attachment art. [WATCH](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/watch.png) [Portrait source](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/concept.html:237)

### E. Rooms and Stations

1. **Actions and Scouting, Travel & Conferences row.** The globe handshake depicts international cooperation. This is the same asset G removed in the previous round. Use the suitcase treatment already demonstrated in A/C/G or another icon that depicts travel. Other repeated play icons match their folder choices and CRT rows. [Actions](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/actions.png) [Scouting](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/door.png) [Pip mapping](C:/Users/keech/Documents/pdoom1/godot/data/icon_mapping.json:106)
2. **WATCH, Talent Opportunity image.** Two people are still visible in the memo illustration. Keep the event and prices and remove the image or use a person-free crop or asset. [WATCH](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/watch.png)
3. **Plan, fixed headings.** The queue's scrollbar gutter shifts the Hours, Cost and Order columns 22px left of their fixed headings. Apply the same gutter to the heading grid. The x8 probe still reached all eight plays and kept both dates and Undo/Clear visible. [Plan](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/plan.png) [Queue grid](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/concept.html:180)

### G. The Existing UI, Modernised

1. **Left rail, Staff and Ledger across views.** The coloured smiley denotes morale, a status within Staff, and the gavel denotes oversight. Use a roster/staff pictogram and an accounts or liability document. The control-size icon tiles still fit the rail. [Home](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/G/home.png) [Icon map](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/G/concept.html:262)
2. **Actions, Publish Safety Paper row.** The gold burst is Pip's Open Source Tools release icon. Its cue is a different action. Use a paper/publication badge and reserve the release badge for Open Source Tools. [Actions](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/G/actions.png) [Pip mapping](C:/Users/keech/Documents/pdoom1/godot/data/icon_mapping.json:82)
3. **Plan, expanded x6 queue.** Its scroll gutter moves Hours, Cost and Order 14px left of the fixed header and total grid. Share the gutter in that state. The six plays and all footer controls remained reachable in the Edge probe. The nested rows' indentation is legible. [Plan](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/G/plan.png) [Queue grid and scroll styles](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/G/concept.html:163)

## Non-blocking

- Across the current renders I found no additional clipping, unreadable text, or flat near-black foreground panel. Sizes and spacing within the other icon groups look consistent. The hand-drawn notice, suitcase, megaphone and speech-bubble marks are flatter than Pip's painted tiles but read clearly at their displayed sizes. Shared action labels remain explicit.
- Sparse, label-only utility controls and A/E's text-only short queue previews are appropriate. Repeated badges that do appear should retain the same meaning. The expanded queue tests verified layout and scrolling in temporary Edge copies. Gameplay actions and complete shortcut handling remain outside the mockup test.
- C/E's event-art finding follows the literal "no person anywhere" brief. The prior foreground operator, chair and glow are gone in both, so clearing the art inside the existing memos is sufficient.

## Disk report

Wrote only `research/council/concepts/r3x-sol.md`. The two temporary Edge pages and profiles were removed. The report can be deleted after the council records the decision.

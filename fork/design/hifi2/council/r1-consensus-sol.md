## Votes

I keep H at 8/10, CHANGES NEEDED. It belongs beside the grim gallery at average quality.

- **Neon, dimmed instruments. Agree with moving the dimmer.** The P(Doom) values and bands remain visible game information when a panel is open. In the supplied renders, 40.2% measures about 2.7:1 in states 2 and 3, and 56.7% and SEVERE measure about 2.0:1 in state 5. Even if the closed rack controls are treated as inactive, the instruments still miss the brief's 4.5:1 requirement. Move the dimmer before the right-hand instruments and controls, then measure the final pixels at both sizes. [Contrast requirement](/home/alex/code/pdoom1/fork/design/hifi2/brief.md:89), [Dimmer](/home/alex/code/pdoom1/fork/design/hifi2/H/concept.html:53), [Review render](/home/alex/code/pdoom1/fork/design/hifi2/H/s5-720.png)
- **Dateline. Keep as blocking.** The brief specifies a type-on when the month changes. The November plan repeats the date from Actions, and WATCH animates the in-month update to November 14. Both currently schedule the same strike as December. Keep the motion on month-entry snapshots and the static date within a month, with reduced motion respected. [Month-entry brief](/home/alex/code/pdoom1/fork/design/hifi2/brief.md:74), [Dateline implementation](/home/alex/code/pdoom1/fork/design/hifi2/H/concept.html:510), [WATCH dateline](/home/alex/code/pdoom1/fork/design/hifi2/H/concept.html:787)
- **WATCH status. Keep as blocking.** "PAUSED FOR YOU" reports the response pause while "MONTH RUNNING" in the adjacent slot implies playback is advancing. G's "MONTH IN PLAY" describes the committed month and leaves the actual playback state to the clock. [H WATCH status](/home/alex/code/pdoom1/fork/design/hifi2/H/concept.html:579), [G status](/home/alex/code/pdoom1/fork/design/hifi/G/concept.html:513)
- **Opus and Neon, cheap polish.** Include the darker ink on the WATCH footer and Decline's "no change" line. My 1080p footer sample was 4.74:1, and thin 720p glyphs benefit from more margin over the mottled paper. Also hide the shortcut letters for the three disabled rack plates while the event is up. Keep the separate date and clock displays and carry the PLAN glyph, terminal label, grain and late-office brightness into the report. [Paper styles](/home/alex/code/pdoom1/fork/design/hifi2/H/concept.html:315), [WATCH rack](/home/alex/code/pdoom1/fork/design/hifi2/H/concept.html:784), [Art notes](/home/alex/code/pdoom1/fork/design/hifi2/H/notes.md)

## Proposed joint list

**Blocking**

1. **States 2, 3 and 5.** Dim the room behind the visible meters, rack, held-hours panel and Commit. In the review, the covered left terminal and cat print can stay under the dimmer. Verify the composited text against 4.5:1 at 1920x1080 and 1280x720.
2. **States 3 and 4.** Show the dateline already set during November. Keep the type-on at month entry, including December, and preserve reduced motion.
3. **State 4.** Change the inert Commit slot to "MONTH IN PLAY". Keep the clock's "PAUSED FOR YOU" notice.

**Cheap non-blocking fixes to include**

- **H, state 4.** Use the darker paper ink for the footer and Decline's "no change" line. Hide the A, P and U keycaps on the disabled rack plates.
- **Showcase.** Restore focus to the selected H, A or G version button when the toggle rebuilds its view. [Toggle handler](/home/alex/code/pdoom1/fork/design/hifi2/index.html:109)

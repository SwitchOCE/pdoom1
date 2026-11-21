VERDICT: CHANGES NEEDED

## Scores (/10)

- **H 9/10**. Removing the terminal label and light, softening the paper creases, and quieting Commit during the review finish the desk. The original Staff and Hire icons still read at both sizes.
- **C 9/10**. The flat meters and worn paper carry the darker look through C's bottom strip and large schedule sheet. The late room still has depth.
- **E 9/10**. The left rack, plan, and separate cost sheet retain their places. The grouped literature plays still show individual row controls.
- **G 9/10**. The slim status strip and three-column layout survive the darker pass. The event and review paper lead the eye at the right moments.
- **Spec 8/10**. The tokens, component states, screen table, and Godot mapping give a builder a starting point. The Attention and unlock rules need precise wording.
- **Page 8/10**. The copy is clear to an outside reader. All 24 images, the comparison views, the keyboard lightbox, and the date demo worked at desktop and 390 px. The page and WebPs total 6,252,309 bytes.
- **Sound 8/10**. The synthesized slap, click, falling thump, and short rattle plausibly give the keys weight. Pitch and timing vary, spaces trigger no strike, and the return has a low stop. A button starts playback in either motion setting. The exported WAV peaks at -2.06 dBFS. Reviewed as code and signal only.

All six states of each design were checked at 1920x1080 and 1280x720. The lowest sampled median solid-stroke contrast on the composited renders was 4.71:1 (E, state 3, row 11 at 1280x720). The shared run figures agree across designs, including 7 planning hours left, 0 operating hours left, 1 hour of spill, 7 untyped held hours, and $25,000 plus 1 held hour for Standard Hiring. Filled cells show hours left. There are no printed doom deltas or NEW chips, and the visible Enter and Esc prompts belong to the top layer.

## Blocking items

1. **Live dateline sound, concept demos and shareable page.** Replays can overlap because each play connects its own compressor to the same output. Three Enter presses started three plays on the page in reduced motion. Rendering the same graph with three starts 60 ms apart produced a peak of 1.143 against a full-scale limit of 1.0, with 12 samples over the limit. Gate replay until the previous sound's tail ends in both motion settings, and apply the guard to all copies. [Shared sound code](/home/alex/code/pdoom1/fork/design/hifi3/H/concept.html:600), [page demo](/home/alex/code/pdoom1/fork/design/hifi3/demo.js:4).
2. **Shareable page, 320x640 with the spec open.** Long inline code paths expand the layout from 320 to 369 CSS pixels in mobile Chromium. For example, `godot/assets/images/events/README.md` reaches x=359. Allow inline paths and identifiers to wrap inside the spec, keep scrolling local to wide tables and code blocks, and rebuild the page. [Page stylesheet](/home/alex/code/pdoom1/fork/design/hifi3/page.src.html:115).
3. **Spec, Attention rule.** Section 1.2 says hours are billed in queue order. The game queues the declared spend, while self-charging plays such as Work Your Connections debit at execution. Describe the row's spill marker as a queue-order estimate for the mock-up, consistent with section 3.8, and use the game's pool totals as authority. Scope the no-spill exception to conference travel, as ADR-0011 does. [Spec](/home/alex/code/pdoom1/fork/design/hifi3/spec.md:56), [Commit order](/home/alex/code/pdoom1/godot/scripts/game_manager.gd:715), [ADR-0011](/home/alex/code/pdoom1/docs/game-design/decisions/ADR-0011-effort-economy.md:169).
4. **Spec, Strategic unlock.** Section 7.2 says both Safety Audit and Strategic open in the first fortnight. Strategic needs at least 30 reputation as well as workday 10. State the workday gates and the reputation condition, then rebuild the embedded spec with the other corrections. [Spec](/home/alex/code/pdoom1/fork/design/hifi3/spec.md:694), [action data](/home/alex/code/pdoom1/godot/data/actions/core.json:108).

## Non-blocking

- In section 3.9, scope the instruction to hide every background keycap to the WATCH event. H's month review still shows rack letters behind the sheet and gives Enter to the review alone. [Spec](/home/alex/code/pdoom1/fork/design/hifi3/spec.md:444), [H state 5](/home/alex/code/pdoom1/fork/design/hifi3/H/s5.webp).

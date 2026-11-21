# hifi3: designer brief for the darker C, E and G

You built concept C, E or G in the hifi run (fork/design/hifi/<letter>/).
Since then the grim pass made design H (A's layout, darker), and Alex chose
H. He wants the other designs built in the same darker look. Work in
/home/alex/code/pdoom1 (branch `design/ui-concepts`), only in
fork/design/hifi3/<your letter>/.

## Alex's words (verbatim)

This pass:

> "Okay, that is excellent. I want you to build out the spec. The icons
> don't count in response to question five. Build the others with the
> darker look as well. But I'm pretty happy with this one. The sound should
> be pretty similar to how those sounds in the movies are. The scene, I
> think, of, you know, it's like it's a typical thing, it's a trope in spy
> movies, right? if something doesn't fit the character design, like the
> lab terminal thing, it should go, I don't understand the other open
> questions. Date feels the date feels good. I like the date. Yeah, build up
> the other designs, but and then give me an artifact I can share"

The grim pass (still holds):

> "... I want to keep the color palette and style of the existing UI
> modernized more. A lot of our stuff feels quite cartoony, I guess. ...
> I like the meter, like the probability of doom meter, and the darker
> color tones. If we have paper on screen, it should be the only light
> thing ... We're trying to invoke the feeling of incoming doom and despair
> and light colors and bright colors kind of break that immersion. So I
> think the doom meter from the G is the style I want to go with pretty
> much for everything. ... And the calendar things feel too corny ... the
> typewriter ... chunky vibe could be really good. ... focus on making the
> game feel bleaker without damaging the UI. The layouts are often quite
> good, right? I think the main work is just changing the texture of it,
> right? Changing the feel of it rather than the layouts so much."

(Full text in fork/design/hifi2/brief.md.)

## Read first

1. fork/design/hifi3/brief.md, "Decisions Alex made" and "What to make"
   item 2.
2. **H's finished look: fork/design/hifi3/H/** (concept.html, notes.md,
   assets/, s1..s6.webp). Copy its look, tokens and treatments: read its
   CSS for the palette, panels, paper, grain, the meter and tachometer, the
   typewriter dateline (type-on and the synthesised sound with its "play
   with sound" control), the quiet Commit and the held-for-events panel,
   and the room's darkening by doom band.
3. fork/design/hifi2/brief.md "What this pass makes" items 1-7 (the grim
   rules) and fork/design/hifi2/council/r1-agreed.md (the fixes H needed;
   avoid the same mistakes, especially a dim layer over live instruments).
4. Your own fork/design/hifi/<letter>/ (concept.html, notes.md, assets)
   and fork/design/hifi/run-state.md with REVISIONS 2 and 3 and the
   council's NEW-chip note; fork/design/hifi/council/r1-agreed.md.

## What to make

Your six states again, in H's grim look, keeping your concept's own
layout: this is a texture pass, not a redesign.

1. G's dark palette and meter style for every instrument (P(Doom),
   reputation, Attention, any gauge); the meter keeps its band colours.
2. Paper is the only light thing, and it is aged and dimmed. No other light
   or bright surfaces or saturated fills; accent colour only where
   something needs attention.
3. The typewriter dateline (date only, H's type and behaviour: types in on
   a month's entry only; in-month states show it set; ?still=1 and
   prefers-reduced-motion respected) with the same synthesised sound and a
   visible "play with sound" control. Reuse H's code. It replaces any
   calendar in your design.
4. Commit the Month quiet and small, with held-for-events beside it.
5. Nothing glossy, bubbly or cartoony: flat panels, hairline frames, grain
   and wear. Pip's icons stay, on dark plates, toned; list any that would
   need darker versions to match.
6. Room to darken by doom band: month 1 not already as bleak as it can be;
   state 6 darkens further as a layer; controls do not move.
7. Text at least 4.5:1, measured on the composited rendered pixels (the dim
   layer, grain and paper grime count) at 1920x1080 and 1280x720.
8. Anything that does not fit the character design goes: labels for
   objects no longer drawn, decorative lights, mock brand text from your
   earlier look. Remove only mock-up inventions, never real game content
   or labels in Pip's UI. List what you removed.
9. Pip's Staff and Hire icons stay (Alex: they do not count as a person).
   No other person or silhouette.
10. Same run-state, numbers and agreed rules as your hifi version (filled =
    hours left, only the topmost layer shows Enter/Esc, every play has its
    own edit target, operational text >= 16px at 1920, no doom deltas, no
    NEW chips, Standard Hiring $25,000 + 1 held hour).

## Deliverables (fork/design/hifi3/<letter>/)

concept.html (?state=1..6, ?still=1, stage scaled uniformly), assets/ (only
what you use), s1..s6.png at 1920x1080 and s1-720..s6-720.png
(uncommitted), s1..s6.webp (1920 wide, about 300 KB, committed), notes.md
(per state; what changed from your hifi version item by item against the
list above; removals; art that would need darker versions; contrast table
per state at both sizes; bugs and data gaps; visual pass).

Rules: write only in fork/design/hifi3/<letter>/; no git; no subagents;
ASCII only in text you write; no mechanics; do not ask questions (carry
them to notes.md). Rendering: headless Chromium with --no-sandbox, one at a
time (three designers share the box), scratch deleted.

Final reply: "<letter> DONE", what you built per state, the WebP paths,
contrast minimum per state, open questions, and a disk report (everything
written outside your folder, sizes, what can go; your folder split into
committed-bound and uncommitted PNGs).

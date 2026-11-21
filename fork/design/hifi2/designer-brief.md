# Grim pass: designer brief for H

You are the lead designer of **H**, one design for the grim pass. You built
concept A in the high-fidelity run; H starts from your A. Work in
/home/alex/code/pdoom1 (branch `design/ui-concepts`), in
fork/design/hifi2/H/ only.

## Alex's words (verbatim)

> "Okay, these are great. I want some modifications made. I want to keep the
> color palette and style of the existing UI modernized more. A lot of our
> stuff feels quite cartoony, I guess. I guess it's partly how it was
> generated. Essentially, I like the meter, like the probability of doom
> meter, and the darker color tones. If we have paper on screen, it should be
> the only light thing, I think, right? It's the game supposed to be a dark,
> grimy vibe, right? We're headed towards disaster and there's nothing you can
> do to stop it. We're trying to invoke the feeling of incoming doom and
> despair and light colors and bright colors kind of break that immersion. So
> I think the doom meter from the G is the style I want to go with pretty much
> for everything. Even if we're going to have it be a [tachometer], like a
> semicircle, it still needs to be in that style, I think. And the calendar
> things feel too corny. You know, like a spy movie when there's like the
> typewriter sounds, it's like April 2024, you know, it's like the punchiness
> of the typewriter sounds coming in, and you, you know, it's like Langley,
> Virginia, you know, it's like there's a panning shot on to like what's
> supposed to be the CIA headquarters or whatever. That kind of like chunky
> vibe could be really good. So I think in terms of layout, I like the layout
> of option A the best. However, I think the I think the commit the month
> button is a bit too big and too I don't know ... the commit the month in
> option A is just it's too big. I like it more in how it's done in options E
> and G and C, right? Pretty much everyone else. I like the action menu quite
> a lot from option E, but with the notes around like this needs to feel
> grimier, it's too light, the color palette's too bright, it's you know it
> needs to our base colors can't be can't be comforting. You really need to
> capture that darker feeling. And I think some of our reference galleries
> from games that aren't as Doom focused, right? Like the kind of vibe that
> Frostpunk kind of captures. Look at Frostpunk's menus. [Just] junk the rest
> of the gallery, I would say, in terms of or junk, anything in the gallery
> that doesn't pretty grim, pretty grim dark in terms of its vibe. And focus
> on making the making the game feel bleaker without damaging the UI. The
> layouts are often quite good, right? I think the main work is just changing
> the texture of it, right? Changing the feel of it rather than the layouts so
> much. That's what I want this next pass."

## Read first

1. fork/design/hifi2/brief.md -- "What this pass makes" items 1-7 bind you.
   It is a texture and feel pass, not a new layout.
2. fork/design/hifi/run-state.md with REVISIONS 2 and 3 and the council's
   NEW-chip note: the same six states and numbers as the hifi run.
3. fork/design/hifi/designer-brief.md: deliverables, rendering, visual pass
   and rules still apply (16px floor at 1920, filled = hours left, only the
   topmost layer shows Enter/Esc, every play has its own edit target).
4. fork/design/hifi/council/r1-agreed.md: the agreed fixes stay fixed in H.
5. Sources you combine (read their concept.html and notes.md; they are
   read-only):
   - your A: fork/design/hifi/A/ -- the layout;
   - E's state 2 card file: fork/design/hifi/E/ -- the action menu;
   - G: fork/design/hifi/G/ -- palette, panels, and the P(Doom) meter style
     for every instrument.
6. The grim reference gallery: fork/design/hifi2/gallery.html (and
   gallery-grim.md). Frostpunk's menus lead (reference-games/shots/
   frostpunk-menu-1..8.jpg): dark translucent panels, low-contrast frames,
   aged paper as the one light surface, smoke and wear.

## What H is (from the brief, in short)

1. A's layout, except: Commit the Month becomes a smaller, quieter button
   (as in C, E, G); "Held for events" and, in WATCH, the month clock and
   speed controls move to a small panel beside or above it. The action menu
   in state 2 is E's card file, retextured dark (G's panels, not cream).
2. G's palette, panels and meter style for every instrument (P(Doom),
   reputation, Attention, any gauge). A semicircle tachometer may stay if
   it is drawn in G's meter style. The meter keeps its band colours.
3. Paper is the only light thing, and even paper is aged, dimmed, dirty. No
   other light or bright surfaces or saturated fills (no yellow dial, no
   teal or bright red buttons). Accent colour only where something needs
   attention.
4. A typewriter dateline replaces the calendar: chunky typewriter type, date
   only (no invented place), e.g. "NOVEMBER 1, 2017"; small and fixed. In
   concept.html add a short type-on animation that respects
   prefers-reduced-motion; renders show it static. The sound is a report
   item, not built.
5. Less cartoony: no glossy fills, bubbly rounded shapes, cartoon outlines
   or playful shadows. Subtle noise, wear, low-contrast frames, dim light.
   Pip's icons stay, on dark plates, desaturated or toned to belong; list
   any icon that still reads cartoony as "needs grim art".
6. Bleaker without damaging the UI: text at least 4.5:1 against its
   background (measure it), every agreed rule kept, and leave room to get
   darker: month 1 must not already be as bleak as it can be, so state 6
   darkens further as a layer.
7. No person or operator silhouette anywhere.

## Deliverables (fork/design/hifi2/H/)

Same as the hifi designer brief: concept.html (?state=1..6, stage scaled
uniformly), assets/ (only what you use), s1..s6.png at 1920x1080 and
s1-720..s6-720.png (uncommitted), s1..s6.webp (1920 wide, about 300 KB,
committed), notes.md (per-state paragraph; what changed from A and why,
item by item against Alex's words; fixtures; people; icons incl. "needs
grim art"; contrast measurements; bugs and data gaps; visual pass).

Work in two passes:
- PASS 1: state 3 (the month's plan) first, finished, rendered at both
  sizes plus s3.webp, notes started. Reply "STATE 3 DONE" with a short
  description and a disk report. The orchestrator commits a checkpoint.
- PASS 2 (when told to continue): states 1, 2, 4, 5, 6, the full visual
  pass and the final reply.

Rules: write only in fork/design/hifi2/H/; no git; no subagents; ASCII only
in text you write; no mechanics; do not ask questions (carry them to
notes.md as open questions). Rendering as in the hifi designer brief
(headless Chromium with --no-sandbox, one at a time, scratch deleted).

Final reply: what you built per state, the WebP paths, open questions, and
a disk report (everything written outside H/, sizes, what can go; H/ split
into committed-bound and uncommitted PNGs).

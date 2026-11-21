# Grim pass (hifi2): brief for the orchestrator (Optiplex)

Written 2026-11-22 by Alex's PC session. You run on the Optiplex in
/home/alex/code/pdoom1, branch `design/ui-concepts`. This follows the
high-fidelity run (fork/design/hifi/, report.md there). Read that brief and
report first. Its sections "Rules", "Who does what" (delegates start on full
access; if Sol is at capacity retry twice an hour apart, then carry on with
Opus and Neon and mark Sol not available; never substitute a model) and
"When done" (scratch cleanup, disk report) all apply here.

## Alex's words (verbatim; quote them in every brief you write)

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

(Square brackets: likely dictation slips, "Tacomeder" and "Get junk".)

## What this pass makes

ONE design, "H", for the same six states and the same run-state
(fork/design/hifi/run-state.md), built in fork/design/hifi2/H/. It is a
texture and feel pass, not a new layout:

1. **Layout: concept A's** (fork/design/hifi/A/), kept as it is except:
   - **Commit the Month** is made smaller and quieter, in the manner of C,
     E and G (a button, not A's big round yellow dial). A's dial also
     carries "Held for events" and, in WATCH (state 4), the month clock and
     speed controls: keep both, in a small panel beside or above the
     button.
   - **The action menu (state 2) is E's card file** (fork/design/hifi/E/,
     state 2), retextured: the cards go dark (G's panels), not cream paper.
2. **Palette and style: G's** (fork/design/hifi/G/): its dark tones, its
   panels and above all its P(Doom) meter. Every instrument (P(Doom),
   reputation, Attention, any gauge) is drawn in the G meter's style. A
   semicircle tachometer is allowed if it keeps that style. The meter keeps
   its band colours (green to red): it is the one thing Alex named liking,
   and it is the exception to item 3.
3. **Paper is the only light thing on screen**, and even paper is aged,
   dimmed and dirty, never clean cream. No other light or bright surfaces,
   no bright saturated fills (no yellow dial, no teal or bright red
   buttons). Accent colour only where something needs attention.
4. **Dates are a typewriter dateline, not a tear-off calendar.** Think the
   title card of a spy film: chunky typewriter type, place and date, e.g.
   "NOVEMBER 1, 2017". The game names no place for the lab: date only, no
   invented city. It sits small and fixed on screen and types in afresh when
   the month changes. Show it static in the renders; in concept.html, add a
   short type-on animation (respecting prefers-reduced-motion) so Pip can see
   the intended feel. The typewriter sound is an open item for the report,
   not something to build.
5. **Less cartoony.** Remove the toy look: glossy fills, rounded bubbly
   shapes, cartoon outlines, playful drop shadows. Grime: subtle noise,
   wear, low-contrast frames, dim lighting. Pip's icons stay (they are his),
   but sit them on dark plates and desaturate or tone them so they belong;
   list any icon that still reads cartoony as "needs grim art".
6. **Bleaker without damaging the UI.** Every rule the council agreed still
   holds (operational text >= 16px, Attention bars filled = hours left,
   only the topmost layer shows Enter/Esc, every play has an edit target),
   and contrast must stay readable: text at least 4.5:1 against its
   background (the council measures it). Leave room to get darker: month 1
   must not already be as bleak as it can be, so state 6 can still darken
   as a layer (docs/art/PALETTE_AND_DOOM_INTENSITY.md).
7. No person or operator silhouette anywhere (unchanged).

## Reference gallery: grim only

Alex: keep only references with a grim, dark vibe; drop the rest. Frostpunk
is the lead reference: "Look at Frostpunk's menus."

1. Before the designer starts, you sort every image in
   fork/design/research/reference-games/shots/ and diegetic/shots/ into
   keep (grim, dark) and drop. Write the list with one line of reason each
   to fork/design/hifi2/gallery-grim.md. Move dropped images to
   fork/design/research/_dropped-refs/ on the box (not committed, not
   deleted), so Alex can reverse it. (The old
   research/concepts/gallery.html will then show some broken images; that
   is expected.)
2. Add Frostpunk menu references: find 4 to 8 screenshots of Frostpunk's
   (1 and 2) menus, panels, law book, event dialogs and HUD from public
   sources (press kits, Steam store pages, wiki pages). Save them in
   fork/design/research/reference-games/shots/ as frostpunk-menu-*.jpg.
   Never commit them (third-party; add them to .git/info/exclude). If the
   fetches fail, write notes on Frostpunk's menus instead and carry on; do
   not stall, and do not substitute non-grim games.
3. Build fork/design/hifi2/gallery.html from the kept references only, for
   the designer and the council. It links to the images by relative path;
   it must not embed them (it is committed; the images are not).

## Who does what

- You orchestrate; you do not design. Reuse the designers from the hifi run
  where useful: the lead designer for H is the hifi designer A (continue
  that thread); ask designers E and G only if A needs their source files
  explained. Starting fresh is fine if a thread is gone.
- Council: the same three members from the hifi run (continue their
  threads). Low sensitivity, per ~/.claude/skills/council/SKILL.md.
- Every brief quotes Alex's words and asks for a disk report.

## Review and finish line

1. The designer builds H in all six states (1920x1080; check 1280x720).
2. Checkpoint: as soon as state 3 (the month's plan) is done, commit and
   push it so Alex can look early. Do not wait for him.
3. One council round, all three at once: (a) does H do what Alex's words
   ask, item by item (palette and meter from G, layout from A, smaller
   commit, E's action menu, paper the only light thing, typewriter
   dateline, not cartoony); (b) does it look at home beside the grim
   gallery (gallery.html) -- "belongs here, at least average"; (c) the
   visual-defect pass; (d) real data and rules still correct; (e) nothing
   in the layout damaged. Score /10.
4. Members settle one agreed list; the designer applies it; re-check with
   Opus and Sol, then Neon last. One fix round; then stop and report what
   still blocks, if anything.
5. Build fork/design/hifi2/index.html: H's six states, with a before/after
   toggle against hifi A and hifi G for each state. Same page rules as the
   hifi showcase (self-contained, relative paths, WebP about 300 KB each,
   under 16 MB, Google Fonts only).
6. Write fork/design/hifi2/report.md: summary at the top, what changed, the
   gallery cull, council results, open questions, new art needed, disk.
   Commit and push (git pull --rebase first). Alex's PC may be off: do not
   wait on it.

## Carry, do not decide

- The Staff and Hire icon question from the hifi report is still open.
- Concepts C, E and G are not cut; this pass just builds the direction Alex
  picked. Say so in the report.

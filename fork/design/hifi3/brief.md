# hifi3: the spec, the darker C, E and G, and a page to share

Written 2026-11-22 by Alex's PC session. You run on the Optiplex in
/home/alex/code/pdoom1, branch `design/ui-concepts`. This follows the grim
pass (fork/design/hifi2/, report.md there). Read fork/design/hifi/brief.md
("Rules", "Who does what", "When done") and fork/design/hifi2/brief.md
first; their rules all still apply (mock-ups only, real data and rules,
ASCII, git hygiene, no third-party images committed, full access for
delegates, Sol retry then carry on without substituting, disk reports,
unattended: never wait on the PC).

## Alex's words (verbatim; quote them in every brief you write)

> "Okay, that is excellent. I want you to build out the spec. The icons
> don't count in response to question five. Build the others with the
> darker look as well. But I'm pretty happy with this one. The sound should
> be pretty similar to how those sounds in the movies are. The scene, I
> think, of, you know, it's like it's a typical thing, it's a trope in spy
> movies, right? if something doesn't fit the character design, like the
> lab terminal thing, it should go, I don't understand the other open
> questions. Date feels the date feels good. I like the date. Yeah, build up
> the other designs, but and then give me an artifact I can share"

His earlier grim-pass words are in fork/design/hifi2/brief.md and still
hold.

## Decisions Alex made (do not reopen)

- **H is the preferred design** ("I'm pretty happy with this one").
- **Pip's Staff and Hire icons do not count as "the person".** Keep them.
  Close that question everywhere. (His "question five" means the PC
  session's numbered list, where 5 was the icons; in hifi2/report.md the
  numbering differs and 5 is the lab terminal. The icons are the answer.)
- **The dateline stays as it is** ("I like the date").
- **The dateline gets the spy-film typewriter sound**: the title-card trope
  where a place and date type onto the screen with heavy, punchy key
  strikes. Build it in H's concept.html with the Web Audio API, synthesised
  (no recorded samples, nothing copied from a film): a hard key strike per
  character, slight random pitch and timing, silence on spaces, an optional
  low carriage-return thunk at the end. Browsers block sound until a
  click, so concept.html has a visible "play with sound" control; the
  automatic type-on stays silent until it is pressed. The page's demo
  button is a deliberate click, so it plays sound even with reduced motion
  on (it may skip the animation). No agent can hear audio: the report says
  the sound was reviewed as code only and Alex is the judge. Describe the
  sound in the spec so it can be made as a game audio asset.
- **Anything that does not fit the character design goes.** "LAB TERMINAL
  1" and its green light go. Sweep every state of H (and of the darker C,
  E, G) for other leftovers that belong to an earlier look (labels for
  objects that are no longer drawn, decorative lights, mock brand text) and
  remove them; list what you removed. Remove only mock-up inventions,
  never real game content or labels that exist in Pip's UI.
- Open questions he did not understand are not his to answer now. Settle
  small taste questions yourselves (the council's call; this includes
  whether the action menu keeps its box or takes A's wider frame), and keep only
  real decisions for the report, each written in one plain sentence with
  what happens if nobody decides.

## What to make

1. **H, finished.** Designer A (the H designer) applies the decisions
   above to H's six states and concept.html: remove the lab-terminal
   leftovers and anything else off-character, add the sound, close the
   icon question. Taste notes from the hifi2 council (paper creases, soot
   on frames, the date showing three times in state 4, bold event costs,
   Commit dimmed during the month review) are the designer's and council's
   call: do what makes H better, skip the rest.
2. **The darker C, E and G.** Start these only after H's finished states
   are pushed (step 1 of Review), and point the designers at
   fork/design/hifi3/H/ so they copy the final look. Designers C, E and G
   (continue their hifi threads) each redo their six states in H's grim look: G's dark palette
   and meter style for every instrument, paper the only light thing and
   aged, the typewriter dateline, Commit quiet and small, nothing glossy or
   cartoony, room to darken by doom band, text at least 4.5:1, the agreed
   council rules. Keep each concept's own layout: this is a texture pass,
   not a redesign. Same run-state (fork/design/hifi/run-state.md). Build in
   fork/design/hifi3/<C|E|G>/; H's finished version goes in
   fork/design/hifi3/H/.
3. **The spec for H**, fork/design/hifi3/spec.md: a design spec a reader
   (Pip, or whoever builds it later) can follow without the mock-ups'
   authors. Keep it proportionate. The H designer writes it; you check it
   covers:
   - what H is for, paraphrased (do not paste Alex's dictated words into
     the spec), and what it must not change (no mechanics; ADR-0015,
     ADR-0001, ADR-0011's Attention rule; the hidden information);
   - tokens: palette (with the doom-band colours and how the room darkens
     by band), type scale (note that font sizes come from
     godot/theme/base_theme.tres and ThemeManager, since Pip's CI rejects
     literal font sizes), spacing, line weights, the grime/texture
     treatment, the 4.5:1 contrast floor;
   - the components and their states: P(Doom) meter, reputation
     tachometer, dateline (type-on timing and the sound), menu rack, plan
     panel, Commit and the held-for-events panel, action card file, month
     plan table, paper (event card, month review), WATCH clock and speed
     controls, feed;
   - the six screens: what is on each, what is one click away, keys
     (Enter/Esc only on the topmost layer; which shortcut keys are new);
   - a short table mapping H's parts onto today's Godot scene
     (godot/scenes/main.tscn, godot/scripts/ui/), reusing G's notes; do
     not edit those files;
   - assets: Pip's art and icons used; art that would need darker
     versions to match (say it that way, not "cartoony"); the sound asset;
   - open rule questions where the mock-ups follow the ADR and today's UI
     differs (the Attention spill, Reserve), and the bugs found on the way.
   Plain language, ASCII, numbered sections, no padding.

4. **The page to share.** fork/design/hifi3/index.html, made for Pip and
   anyone Alex sends it to:
   - H first, presented as the preferred direction, then C, E and G in the
     same look as alternatives;
   - views: all designs by state, one state across all four, one design
     through six states, full-size viewer (as in the hifi showcase);
   - a dateline demo on the page: a button that types a date with the
     synthesised sound (same code as H's concept.html);
   - the spec as its own section or tab on the page, converted from
     spec.md to HTML when the page is built (no markdown library; rebuild
     it after the fix round), plus a link to the repo copy:
     https://github.com/SwitchOCE/pdoom1/blob/design/ui-concepts/fork/design/hifi3/spec.md
   - same page rules as before: self-contained, relative paths, WebP about
     300 KB each, under 16 MB, Google Fonts only, works at phone width.
   - Written for an outside reader: no internal jargon ("council",
     "round", "fix list", agent names) on the page; say what each design
     is and what the screens show. Speak of Pip's art respectfully: art
     that "would need darker versions to match", never "cartoony" or
     "corny". Do not paste Alex's dictated words on the page.
   - You build index.html; Alex's PC session publishes it as a shareable
     page when it is back. Do not try to publish it yourself.

## Review

1. Checkpoint: when H's finished six states are done, commit and push.
2. One council round, all three at once (same members, continue their
   threads), on: H finished (Alex's decisions applied, nothing
   off-character left, the sound works and fits the trope); the darker C,
   E, G (each does what the grim pass did for H without breaking its
   layout); the spec (complete, accurate against the code and data, usable
   by a builder who never saw the mock-ups); the page (clear to an outside
   reader); the sound as code only (nobody can listen); plus the visual-defect pass and the 4.5:1 check. Score /10 per
   item.
3. Members settle one agreed list; designers apply it; re-check with Opus
   and Sol, then Neon last. One fix round, then stop and report.
4. fork/design/hifi3/report.md, summary at the top: what was made, council
   results, the decisions still open (plain sentences), new art and sound
   needed, disk. Commit and push (git pull --rebase first). Delete the
   hifi2 full-size PNGs on the box once hifi3 is pushed.

## Addendum (2026-11-22): outside feedback, one extra round for H

After the current re-check finishes (do not interrupt it), run one more
round on H only. C, E and G stay as they are now.

An artist and visual designer Alex trusts reviewed the designs. In short,
his points (paraphrased; his message is private and must not be committed
or put on the page):

- Better than the previous UI in almost every way; he likes the dark
  colour scheme and the day/month progress shown as small shapes that fill.
- The weak spot is visual hierarchy: apart from the P(Doom) meter,
  everything feels equally important, which reads as "not seeing" things
  strategically, as if something were hidden.
- He likes that the room changes colour as things get worse and suggests
  pushing it further: colour change can exert real pressure and tension.
- Maybe every resource needs a meter visible at all or most times.
- He framed a spectrum: HighFleet's dense, grimy instrument panels (the UI
  you play) at one end, the newer Doom games' near-absent UI at the other,
  incremental games' panels close to what we have.

Alex's decisions on it:

> "I think all of these I agree with one, two, and four the most.
> Highfleet I'm the least aligned with, but I think we can draw some
> inspiration from it in maybe we should do one take withdrawing
> inspiration from it, one without"

(One = clearer hierarchy, two = stronger doom colour, four = a meter per
resource.) Then, on how to show resources:

> "Can we instead have some sort of, instead of a meter then for the
> attention and reputation, perhaps have some sort of like progression of
> iconography, kind of representing larger amounts with like changes in
> either color state or size or amounts, perhaps. Like often, like when you
> see a money icon in a game, there's like a coin. And then when you have a
> lot of money, when you have like multiple coins, or you can see a big
> pile of coins when you get to larger numbers and stuff, right? That could
> be some way of representing the changes on these like meter-like things.
> Basically, like at a glance, you can kind of tell when you're poor and
> non, and kind of or rich and kind of in a resource, it kind of like
> builds flavor. Another way of doing it potentially is almost like in
> terms of like how like a heartbeat monitor or something works. Basically,
> we have an unanchored window that kind of follows the x and y axes of
> these things, right? Of these, I'm not sure how we would show it and
> present it in a window or something, but yeah, if we could build an
> interactive artifact that lets me pick specific elements from these
> designs and overlay them and stuff. After these passes, then I think
> we're good to go"

(Reading: the game sets no maximum for money, compute, research or
papers, so a fill meter has nothing to fill against. Alex's two
alternatives replace the meter for those resources. Attention keeps its
hour bars and reputation keeps H's tachometer, since both have real
limits; either may also take a tier icon if it reads well.)

So:

1. **H, revised** (fork/design/hifi3/H/, replacing the current renders):
   - **Hierarchy.** Rank what matters for this month's decision and show
     it. Proposed order (the council may adjust it): P(Doom) first, then
     Attention left and money, then the plan; the rest recedes (smaller,
     dimmer, still 4.5:1 for text). A first-time viewer should see where
     to look in one glance.
   - **Stronger doom colour.** Alex, after reading the feedback: "I
     definitely agree with a lot of what he said, especially with the
     screen darkening or changing texture and color palettes as time goes
     on and the chance of doom gets worse. I think it should start off
     maybe even a little bit brighter than it does now and maybe can
     darken over time." The colour follows the doom band only (never the
     month or time): the lowest band starts a little brighter than now
     (still a dim, grimy office, never cheerful; paper stays the only light
     thing), and each band darkens and shifts palette and texture further,
     so pressure rises visibly from band to band ("a layer, not a repaint";
     controls stay put and readable). Show it across the six states, and
     add a strip of the same screen at each of the 7 bands to the page.
   - **Resources, two takes** for money, compute, research and papers
     (reputation: reuse H's tachometer, never draw it twice):
     a. **Tier icons**: each resource's icon changes with the amount, e.g.
        money from one coin to a few coins to a stack to a pile; compute,
        research and papers likewise in Pip's icon style, dark-plated. 3 to
        5 tiers each. The tier thresholds are a proposal, stated in the
        spec, and must not reveal anything the game hides (ADR-0001); use
        the plain amount shown today, not a forecast. The number stays
        beside the icon.
     b. **Trace window**: a small "heartbeat monitor" panel per resource
        (or one shared panel): a line tracing the amount over the past
        months, with an unanchored, auto-scaling y-axis so the line always
        fills the window. Only history the player has already seen; no
        forecast, no doom trace (ADR-0015).
     Build H with take (a) as the default renders; render states 1, 3 and
     6 also with take (b). Keep both compact: if they crowd the art or
     push anything aside, they shrink first.
2. **H-HF, the HighFleet-inspired take**: the same revised H (same layout,
   hierarchy, colour, resources take a) with texture drawn from HighFleet
   and amber Soviet-style control panels: worn painted metal, analogue
   dials and needles, stencilled labels, rivets, warning plates. Texture
   only: not HighFleet's density, no extra controls. Build in
   fork/design/hifi3/H-HF/, three states only (1 first screen, 4 WATCH
   event, 5 end of month). References: find 4 to 8 HighFleet screenshots
   (Steam store page, press kit), save them uncommitted in
   fork/design/research/reference-games/shots/highfleet-*.jpg and add them
   to .git/info/exclude. If fetches fail, work from notes.
3. **The mixer**: fork/design/hifi3/mixer/index.html, an interactive page
   where Alex picks elements from the designs and overlays them on one
   1920x1080 screen:
   - Slots for each element: P(Doom) meter, reputation, resources (tier
     icons / trace window / the plain numbers), dateline, menu rack, plan
     panel, Commit and held-for-events, action menu, event card, month
     review, feed. Each slot offers that element from H, H-HF, C, E and G
     where the design has one, or "none".
   - A background picker (the office art) and a doom-band slider that
     applies the band colour layer.
   - Elements can be dragged to move them and toggled on and off; a reset
     button restores H's layout.
   - Built from cut-out renders of each element (transparent WebP,
     rendered from each design's concept.html in isolation), so it is
     honest to the designs, not redrawn. Same page rules: self-contained,
     relative paths, under 16 MB, Google Fonts only, keyboard usable.
   - The current arrangement can be saved in the page (localStorage, with
     try/catch) and shown as a short text code Alex can copy and paste
     back to us.
4. Update spec.md for the revised H (hierarchy order, resources take a and
   b with thresholds, colour by band) and add H-HF as a short texture
   section.
5. The page: H first, then H-HF ("the same design, heavier texture"),
   then C, E and G with a line saying they show the earlier texture (no
   hierarchy, resource or colour changes). Add the doom-band strip, the
   resource takes side by side, and a link to the mixer (the PC session
   publishes the mixer too).
6. Council: one round on the revised H, H-HF and the mixer (did
   hierarchy, colour and resources land; does H-HF keep the layout and
   stay readable; does the mixer work and stay honest to the designs; the
   usual defect and 4.5:1 checks; Neon listens if the sound changed), one
   fix round, Opus and Sol then Neon. Then the report and push as briefed.
   Alex: "After these passes, then I think we're good to go", so this is
   the last design round: make the report a clean hand-off.

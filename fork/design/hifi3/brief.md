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
  Close that question everywhere.
- **The dateline stays as it is** ("I like the date").
- **The dateline gets the spy-film typewriter sound**: the title-card trope
  where a place and date type onto the screen with heavy, punchy key
  strikes. Build it in H's concept.html with the Web Audio API, synthesised
  (no recorded samples, nothing copied from a film): a hard key strike per
  character, slight random pitch and timing, silence on spaces, an optional
  low carriage-return thunk at the end. It plays only after a click
  (browsers block sound until then) and never with prefers-reduced-motion.
  Describe the sound in the spec so it can be made as a game audio asset.
- **Anything that does not fit the character design goes.** "LAB TERMINAL
  1" and its green light go. Sweep every state of H (and of the darker C,
  E, G) for other leftovers that belong to an earlier look (labels for
  objects that are no longer drawn, decorative lights, mock brand text) and
  remove them; list what you removed.
- Open questions he did not understand are not his to answer now. Settle
  small taste questions yourselves (the council's call), and keep only
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
2. **The darker C, E and G.** Designers C, E and G (continue their hifi
   threads) each redo their six states in H's grim look: G's dark palette
   and meter style for every instrument, paper the only light thing and
   aged, the typewriter dateline, Commit quiet and small, nothing glossy or
   cartoony, room to darken by doom band, text at least 4.5:1, the agreed
   council rules. Keep each concept's own layout: this is a texture pass,
   not a redesign. Same run-state (fork/design/hifi/run-state.md). Build in
   fork/design/hifi3/<C|E|G>/; H's finished version goes in
   fork/design/hifi3/H/.
3. **The spec for H**, fork/design/hifi3/spec.md, written so someone could
   build H into the game later without the mock-ups' authors. The H
   designer writes it; you check it covers:
   - what H is for, in Alex's words, and what it must not change (no
     mechanics; ADR-0015, ADR-0001, ADR-0011's Attention rule; the hidden
     information);
   - tokens: palette (with the doom-band colours and how the room darkens
     by band), type scale, spacing, line weights, grime/texture treatment,
     contrast floor;
   - every component, with its states: the P(Doom) meter, the reputation
     tachometer, the dateline (type-on timing and the sound), the menu
     rack, the plan panel, Commit and the held-for-events panel, the action
     card file, the month plan table, paper (event card, month review),
     the WATCH clock and speed controls, the feed;
   - the six screens: what is on each, what is one click away, keyboard
     (Enter/Esc only on the topmost layer, the shortcut keys and which are
     new), focus order;
   - how it maps onto today's Godot scene (godot/scenes/main.tscn and
     godot/scripts/ui/; G's notes already map many nodes) and the theme
     (godot/theme/), without editing them;
   - assets: Pip's art and icons used, new art needed (including the
     icons that still look cartoony), the sound asset;
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
   - the spec as its own section or tab on the page (rendered, readable),
     plus a link to the repo copy:
     https://github.com/SwitchOCE/pdoom1/tree/design/ui-concepts/fork/design/hifi3
   - same page rules as before: self-contained, relative paths, WebP about
     300 KB each, under 16 MB, Google Fonts only, works at phone width.
   - Written for an outside reader: no internal jargon ("council",
     "round", "fix list", agent names) on the page; say what each design
     is and what the screens show.

## Review

1. Checkpoint: when H's finished six states are done, commit and push.
2. One council round, all three at once (same members, continue their
   threads), on: H finished (Alex's decisions applied, nothing
   off-character left, the sound works and fits the trope); the darker C,
   E, G (each does what the grim pass did for H without breaking its
   layout); the spec (complete, accurate against the code and data, usable
   by a builder who never saw the mock-ups); the page (clear to an outside
   reader); plus the visual-defect pass and the 4.5:1 check. Score /10 per
   item.
3. Members settle one agreed list; designers apply it; re-check with Opus
   and Sol, then Neon last. One fix round, then stop and report.
4. fork/design/hifi3/report.md, summary at the top: what was made, council
   results, the decisions still open (plain sentences), new art and sound
   needed, disk. Commit and push (git pull --rebase first). Delete the
   hifi2 full-size PNGs on the box once hifi3 is pushed.

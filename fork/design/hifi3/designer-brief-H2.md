# hifi3 addendum: designer brief for the revised H

You built H. An outside artist reviewed the designs and Alex made
decisions on his points. This is the last design round. Work in
/home/alex/code/pdoom1 (branch `design/ui-concepts`) in
fork/design/hifi3/H/ (replacing the current renders), fork/design/hifi3/
spec.md, and, for resource history only, a new section at the end of
fork/design/hifi/run-state.md.

## Read first

1. fork/design/hifi3/brief.md, the section "## Addendum (2026-11-22)" in
   full: it quotes Alex and lists what to make. Items 1 and 4 are yours;
   item 2 (H-HF) and item 3 (the mixer) are built by other designers from
   your files, so keep H's structure clean (one element per DOM block,
   stable ids or classes for: P(Doom) meter, resources, dateline, menu
   rack, plan panel, Commit and held-for-events, action menu, event card,
   month review, feed).
2. The earlier rules still hold: fork/design/hifi/council/r1-agreed.md,
   fork/design/hifi2/council/r1-agreed.md,
   fork/design/hifi3/council/r1-agreed.md, ADR-0001, ADR-0011, ADR-0015,
   docs/art/PALETTE_AND_DOOM_INTENSITY.md.

## Alex's words (verbatim, from the brief)

> "I think all of these I agree with one, two, and four the most.
> Highfleet I'm the least aligned with, but I think we can draw some
> inspiration from it in maybe we should do one take withdrawing
> inspiration from it, one without"

> "I definitely agree with a lot of what he said, especially with the
> screen darkening or changing texture and color palettes as time goes
> on and the chance of doom gets worse. I think it should start off
> maybe even a little bit brighter than it does now and maybe can
> darken over time."

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
> these things, right? ... After these passes, then I think we're good to
> go"

The outside reviewer's message is private: do not quote or commit it.

## PASS 1: the revised H (fork/design/hifi3/H/)

1. **Hierarchy.** P(Doom) first; then Attention left and money; then the
   plan; the rest recedes (smaller, dimmer, still 4.5:1 for text). A
   first-time viewer sees where to look in one glance. Say in notes.md how
   each level is made (size, weight, contrast, position).
2. **Colour by doom band** (never by month): the lowest band starts a
   little brighter than now (still a dim, grimy office, never cheerful;
   paper stays the only light thing); each band darkens and shifts palette
   and texture further ("a layer, not a repaint": controls stay put and
   readable). Show it across the six states, and render a **band strip**:
   the same screen (state 1's desk, nothing else changed) at each of the 7
   bands, saved as H/band-0.webp .. band-6.webp (1920 wide, about 150-250
   KB each; full-size PNGs uncommitted). Add `?band=0..6` to concept.html
   to force a band.
3. **Resources, two takes** for money, compute, research, papers AND
   reputation (reputation drawn once, as these, not also as a dial; keep
   its "0 ends the run" warning). Attention keeps its hour bars.
   a. **Tier icons** (default renders): each resource's icon changes with
      the amount, 3 to 5 tiers at fixed amounts (not relative to spending)
      plus a zero-or-below tier (research is -6 and -12 in the run-state;
      reputation 0 ends the run). In Pip's icon style, dark-plated; draw
      them as SVG or small PNGs in H/assets/ and list them as new art. The
      number stays beside the icon. Thresholds use the plain amount the
      game shows today, no forecast (ADR-0001).
   b. **Trace window**: a small "heartbeat monitor" (per resource, or one
      shared panel) tracing the amount over past months, unanchored
      auto-scaling y-axis so the line fills the window. Only history the
      player has seen. Add a "Resource history" section at the end of
      fork/design/hifi/run-state.md with earlier months only where the
      game's own data or screenshots give them; mark any projection as
      such. No forecast, no doom trace (ADR-0015). Month 1 shows "no
      history yet". `?res=trace` switches take (b) on; render states 3, 5
      and 6 with it as H/s3-trace.webp, s5-trace.webp, s6-trace.webp.
   Keep both compact: if they crowd the art or push anything aside, they
   shrink first.
4. Everything else in H stays (sound, dateline, agreed rules, 4.5:1
   measured on composited pixels at both sizes, no person, Pip's icons).

Deliverables: concept.html, assets/, notes.md ("addendum" section:
hierarchy, colour by band with the band table, both resource takes with
thresholds, contrast table), s1..s6.webp (take a), s3/s5/s6-trace.webp,
band-0..6.webp, full-size PNGs uncommitted. Reply "H2 DONE" with what
changed, the element ids/classes for the mixer, contrast minimum per
state, and a disk report. Then wait for "continue".

## PASS 2: the spec (fork/design/hifi3/spec.md)

Update for the revised H: the hierarchy order; resources take (a) with
the thresholds and take (b) with its rules (history only, auto-scale, no
forecast, no doom trace); colour by band (the band table, what changes per
band, the brighter start). H-HF will get a short texture section, written
by its designer; leave a heading "H-HF texture" with a one-line
placeholder. Same Markdown rules as before (plain Markdown, ASCII, no
HTML). Reply "SPEC2 DONE" with a disk report.

## Rules

Write only in the paths above; no git; no subagents; ASCII only in text
you write; no mechanics; do not ask questions (carry them to notes.md).
Rendering: headless Chromium with --no-sandbox, one at a time (other
designers share the box), scratch deleted. Every reply ends with a disk
report: everything written outside the paths above, sizes, what can go.

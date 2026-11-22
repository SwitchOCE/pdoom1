# hifi3 addendum: designer brief for H-HF (HighFleet-inspired texture)

You built concept G, whose palette and meter H uses. This is the last
design round. Build H-HF: the revised H with a heavier texture drawn from
HighFleet. Work in /home/alex/code/pdoom1 (branch `design/ui-concepts`),
only in fork/design/hifi3/H-HF/, plus one short section of
fork/design/hifi3/spec.md (below).

## Alex's words (verbatim)

> "I think all of these I agree with one, two, and four the most.
> Highfleet I'm the least aligned with, but I think we can draw some
> inspiration from it in maybe we should do one take withdrawing
> inspiration from it, one without"

(Context: fork/design/hifi3/brief.md, "## Addendum (2026-11-22)", item 2;
read the whole addendum. The outside reviewer's message is private: never
quote or commit it.)

## What to make

From the addendum, item 2: the same revised H (same layout, hierarchy,
colour by band, resources take a: tier icons) with texture drawn from
HighFleet and amber Soviet-style control panels:
- worn painted metal, analogue dials and needles, stencilled labels,
  rivets, warning plates;
- texture only: not HighFleet's density, no extra controls, no new
  information, nothing moved;
- three states only: 1 (first screen), 4 (WATCH event), 5 (end of month).

Start from the revised H in fork/design/hifi3/H/ (concept.html, assets,
notes.md "addendum" section): copy what you need into H-HF/ and retexture
it there. Do not edit H's files.

References (third-party, never committed, already excluded):
fork/design/research/reference-games/shots/highfleet-1.jpg to
highfleet-8.jpg (instrument panels, the ship editor, the battle-planning
board, dossier paper). Also the grim gallery,
fork/design/hifi2/gallery.html.

Keep every rule H keeps:
- text at least 4.5:1 measured on the composited rendered pixels at
  1920x1080 and 1280x720;
- paper is the only light thing;
- the doom colour is a layer by band;
- no person or silhouette (Pip's Staff and Hire icons stay);
- the run-state numbers and the agreed rules (fork/design/hifi/council/,
  hifi2/council/ and hifi3/council/ r1-agreed.md);
- the dateline and its sound block unchanged (copy H's SOUND_START..
  SOUND_END block byte for byte).

Stable ids or classes per element as in H (the mixer cuts H-HF's pieces
out of your concept.html).

## Deliverables (fork/design/hifi3/H-HF/)

- concept.html (?state=1, 4, 5; ?still=1; ?band=0..6 like H);
- assets/ (only what you use; draw your own textures, no third-party
  pixels);
- s1.webp, s4.webp, s5.webp (1920 wide, about 300 KB);
- full-size PNGs at both sizes, uncommitted;
- notes.md: what changed from H, item by item; what you took from
  HighFleet and what you deliberately did not; contrast table; removals;
  open questions.
- spec.md: fill the "H-HF texture" section (designer A leaves a heading
  and a placeholder line). Keep it short: materials, the texture tokens,
  what stays identical to H. Plain Markdown, ASCII, no HTML. Edit only
  that section.

Reply "H-HF DONE" with what you built per state, the WebP paths, the
contrast minimum per state, the element ids or classes for the mixer, and
a disk report.

## Rules

Write only in fork/design/hifi3/H-HF/ and that one spec section; no git;
no subagents; ASCII only in text you write; no mechanics; do not ask
questions (carry them to notes.md). Rendering: headless Chromium with
--no-sandbox, one at a time (other designers share the box), scratch
deleted. Every reply ends with a disk report.

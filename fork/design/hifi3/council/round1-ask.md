# hifi3 council round 1

You are one of three members (opus, sol, neon), the same council as the
hifi and grim-pass runs. Work in /home/alex/code/pdoom1, branch
`design/ui-concepts`. Read-only except for your answer file.

## Alex's words (verbatim)

> "Okay, that is excellent. I want you to build out the spec. The icons
> don't count in response to question five. Build the others with the
> darker look as well. But I'm pretty happy with this one. The sound should
> be pretty similar to how those sounds in the movies are. The scene, I
> think, of, you know, it's like it's a typical thing, it's a trope in spy
> movies, right? if something doesn't fit the character design, like the
> lab terminal thing, it should go, I don't understand the other open
> questions. Date feels the date feels good. I like the date. Yeah, build up
> the other designs, but and then give me an artifact I can share"

His grim-pass words (fork/design/hifi2/brief.md) still hold. His decisions
are in fork/design/hifi3/brief.md, "Decisions Alex made": do not reopen
them (H is preferred; Pip's Staff and Hire icons stay; the dateline stays;
the dateline gets the spy-film typewriter sound; anything off-character
goes).

## What to review

- fork/design/hifi3/brief.md (what was asked) and the two designer briefs
  beside it.
- **H finished:** fork/design/hifi3/H/ (concept.html ?state=1..6,
  notes.md "hifi3" section, s1..s6.png and s1-720..s6-720.png, WebPs,
  dateline-sound.wav). Compare with fork/design/hifi2/H/ (s*.webp).
- **The darker C, E, G:** fork/design/hifi3/<C|E|G>/ (same files). Compare
  with each one's hifi version, fork/design/hifi/<C|E|G>/ (s*.webp).
- **The spec:** fork/design/hifi3/spec.md. Check it against godot/data/,
  godot/scenes/main.tscn, godot/scripts/ui/, godot/theme/ and the ADRs in
  docs/game-design/decisions/.
- **The page to share:** fork/design/hifi3/index.html (built from
  page.src.html by build_page.py; spec converted in). Open it in headless
  Chromium at desktop and phone width.
- The shared run state: fork/design/hifi/run-state.md (REVISIONS 2 and 3);
  the agreed rules: fork/design/hifi/council/r1-agreed.md and
  fork/design/hifi2/council/r1-agreed.md.

## The sound

The dateline sound is synthesised in H/concept.html (the block between
SOUND_START and SOUND_END) and rendered to
fork/design/hifi3/H/dateline-sound.wav (typing "NOVEMBER 1, 2017").

- **opus and sol:** review it as code: does the synthesis plausibly give a
  heavy, punchy typewriter key strike (the spy-film title-card trope), with
  slight random pitch and timing, silent spaces, an optional carriage-return
  thunk; is it only started by a click; does reduced motion keep the sound
  on the button; no samples or copied material; can it clip.
- **neon:** listen to dateline-sound.wav. Does it sound like the spy-film
  title-card typewriter trope (heavy, punchy key strikes)? What would make
  it closer? Be concrete (attack, pitch, body, rattle, spacing, the
  carriage return, room). Also say anything that sounds wrong (clicks,
  hiss, clipping, too fast or slow).

## Checks, scored /10 each

1. **H finished:** Alex's decisions applied; nothing off-character left
   (labels for objects not drawn, decorative lights, mock brand text);
   real game content kept; the taste notes handled sensibly.
2. **The darker C, E, G:** each does for its concept what the grim pass did
   for H, without breaking its own layout (score each).
3. **The spec:** complete against brief.md "What to make" item 3, accurate
   against the code, data and ADRs, usable by a builder who never saw the
   mock-ups, proportionate.
4. **The page:** clear to an outside reader (no internal jargon, Pip's art
   spoken of respectfully, no dictated words pasted), works at phone width,
   images load, the lightbox and the date demo work, under 16 MB.
5. **The sound** (as above).
6. **Visual defects** in every state of all four (both sizes) and the
   **4.5:1 floor** measured on composited pixels.
7. **Data and rules** still right (run-state numbers, no doom deltas, the
   spill, untyped reserve, no NEW chips, filled = hours left, Enter/Esc
   only on the top layer, Standard Hiring $25,000 + 1 held hour).

Scope: this is a texture pass, a spec and a page. Redesigns, new features
and mechanics are out of scope; mark anything like that non-blocking.

## Answer format

```
VERDICT: GOOD TO GO | CHANGES NEEDED

## Scores (/10)
H . C . E . G . spec . page . sound (each with one line why)

## Blocking items
[where: design/state/size or file:line] what is wrong -- the fix
(numbered; only real defects of the kinds above)

## Non-blocking (at most 3)
```

neon adds a "## Listening" section with its verdict on the WAV.

Write to fork/design/hifi3/council/r1-<your name>.md and reply with the
same text.

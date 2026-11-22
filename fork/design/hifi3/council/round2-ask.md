# hifi3 council round 2 (the addendum: the last design round)

You are one of three members (opus, sol, neon), the same council as
before. Work in /home/alex/code/pdoom1, branch `design/ui-concepts`.
Read-only except for your answer file.

## What was asked

Read fork/design/hifi3/brief.md, the section "## Addendum (2026-11-22)",
in full. An outside artist reviewed the designs; his message is private
(do not quote it; flag it if any of it appears in a committed file or on
the page). Alex's words, verbatim:

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
> either color state or size or amounts, perhaps. ... Another way of doing
> it potentially is almost like in terms of like how like a heartbeat
> monitor or something works. Basically, we have an unanchored window that
> kind of follows the x and y axes of these things, right? ... if we could
> build an interactive artifact that lets me pick specific elements from
> these designs and overlay them and stuff. After these passes, then I
> think we're good to go"

(Full quotes in the addendum.) C, E and G are not under review this round.

## What to review

- **Revised H:** fork/design/hifi3/H/ (concept.html with ?state=1..6,
  ?band=0..6, ?res=trace; notes.md "Addendum" section; s1..s6.png and
  -720.png, s3/s5/s6-trace.png, band-0..6.png; the WebPs). Compare with
  the previous H: `git show 5c49c600:fork/design/hifi3/H/s3.webp` etc.
- **Resource history:** the new section at the end of
  fork/design/hifi/run-state.md.
- **H-HF:** fork/design/hifi3/H-HF/ (states 1, 4, 5; notes.md).
  References (third-party, uncommitted):
  fork/design/research/reference-games/shots/highfleet-1..8.jpg.
- **The mixer:** fork/design/hifi3/mixer/ (index.html, notes.md, tools/).
- **The spec:** fork/design/hifi3/spec.md (hierarchy, resources take a and
  b with thresholds, colour by band, the H-HF texture section).
- **The page:** fork/design/hifi3/index.html (built by build_page.py from
  page.src.html, spec.md, demo.js and H's sound block). Open it at desktop
  and phone width.
- The agreed rules: fork/design/hifi/council/r1-agreed.md,
  fork/design/hifi2/council/r1-agreed.md, fork/design/hifi3/council/
  r1-agreed.md; ADR-0001, ADR-0011, ADR-0015;
  docs/art/PALETTE_AND_DOOM_INTENSITY.md.

The dateline sound did not change this round (the block hashes the same
as at 5c49c600); no listening is needed unless you find it changed.

## Checks, scored /10 each

1. **Hierarchy (H):** does a first-time viewer see where to look in one
   glance (P(Doom), then Attention left and money, then the plan; the rest
   recedes but stays readable)?
2. **Colour by band (H):** does colour follow the doom band only; does the
   lowest band start a little brighter (still dim and grimy, paper the
   only light thing); does pressure rise visibly band to band; do the
   controls stay put and readable? The band strip shows state 1's screen
   with only the room's band forced.
3. **Resources (H):** take a (tier icons: fixed thresholds, a zero-or-below
   tier, the number beside, reputation drawn once with "0 ends the run")
   and take b (trace: only seen history, auto-scaled, no forecast, no doom
   trace, "no history yet" in month 1). ADR-0001: nothing the game hides.
   Is the history in run-state.md sourced or marked as projection?
4. **H-HF:** HighFleet-inspired texture only (same layout, hierarchy,
   colour and resources as H; not HighFleet's density; no extra
   controls); readable; at home with the references.
5. **The mixer:** every slot loads; drag, toggle, keyboard (Tab, arrows,
   Shift+arrows, visible focus); band slider; background; the code
   round-trips; reset matches H's state 3 (check the pixel result); honest
   to the designs (cut from their own pages, not redrawn); C, E, G
   labelled "earlier texture"; under 16 MB; works at phone width.
6. **The spec:** the new sections complete and accurate against the code,
   data and ADRs.
7. **The page:** clear to an outside reader; H first, H-HF as "the same
   design, heavier texture", C, E, G marked as the earlier texture; the
   band strip, the resource takes and the mixer link work; no internal
   jargon; nothing from the private review message; under 16 MB.
8. **Visual defects** in every new render (both sizes) and the **4.5:1
   floor** on composited pixels; **data and rules** still right.

Scope: this is the last design round. Redesigns, new features and
mechanics are out of scope; mark anything like that non-blocking.

## Answer format

```
VERDICT: GOOD TO GO | CHANGES NEEDED

## Scores (/10)
hierarchy . colour . resources . H-HF . mixer . spec . page (one line why each)

## Blocking items
[where: design/state/size or file:line] what is wrong -- the fix

## Non-blocking (at most 3)
```

Write to fork/design/hifi3/council/r2-<your name>.md and reply with the
same text. Close any Chromium you start.

VERDICT: GOOD TO GO

## Scores (/10)
hierarchy 9 . colour 9 . resources 8.5 . H-HF 8.5 . mixer 9 . spec 9 . page 9

- **Hierarchy 9.** The ranking reads at a glance on s1 to s6.
  - P(Doom) is the largest panel and the only one framed in colour.
  - Money is the big lead cell, and Attention is the top block of the
    plan.
  - The plan, the other resources, the rack, Held and Commit are smaller
    and dimmer, and still readable.
  - Commit is muted until something is queued.
- **Colour 9.** The room follows the band only: 0 is at .80 and 6 at .31.
  - On the band strip, each step is visibly darker and grimmer.
  - Band 6 adds near black and fire light.
  - Band 0 is brighter than the old .62 but still a dim office.
  - The panels and controls do not move or change across bands.
- **Resources 8.5.**
  - Take a:
    - the tiers are fixed lines, with tier 0 at zero or below;
    - the number sits beside each icon;
    - reputation is drawn once with "0 ends the run".
  - The tier lines match the code:
    - `money <= 20000` is at main_ui.gd:1021;
    - reputation `<= 20` / `<= 30` is at :1015-1017;
    - research 10 and 20 are the costs of safety_research and
      publish_paper in core.json;
    - the run ends at game_state.gd:791, and death_attribution.gd:46
      files it as a reputation death.
  - Take b:
    - it shows history only, auto-scaled;
    - it has no doom trace, so ADR-0015 holds;
    - the tab reads "TRACE since Jul 2017";
    - month 1 says "no history yet".
  - ADR-0001 holds: both takes read only the amount on screen.
  - History sources:
    - Jul to Nov match the game screenshots;
    - Dec and Apr are the run's fixtures;
    - Jan to Mar are marked as a projection in run-state.md and in spec
      3.2;
    - the page's s6 caption says "(projected)".
  - The tier lines are fine. The half point comes from the reputation
    cell (non-blocking 1).
- **H-HF 8.5.** Only the texture changes: stencilled labels, rivets,
  counter windows, a needle and lamps on P(Doom), and hazard stripes in
  two places only.
  - The layout is H's (I compared the renders). The sound block has the
    same sha256 as H's.
  - It is a light touch next to the HighFleet references: no added
    gauges, nixies or scale numerals.
  - Contrast mins are 5.47 / 4.74 (s1), 5.82 / 5.25 (s4) and 5.47 / 4.74
    (s5).
- **Mixer 9.** In headless Chromium at 1600 and 390 px:
  - all 81 image sources load, and the band slider and background change
    the room;
  - there are 14 slots, and C, E and G pieces are labelled "earlier
    texture";
  - drag, toggles and arrow nudges (1 / 10 px) work, with focus kept and a
    solid 5 px amber outline;
  - the code round-trips, and a broken code is refused without changing
    anything;
  - Reset matches H/s3.png apart from text antialiasing (the doom piece is
    1 px lower);
  - the pieces are cut from the concept renders, not redrawn;
  - it is 6.3 MB, with no page scroll at 390.
- **Spec 9.** The new sections (1.3, 2.4, 3.2, 6.4, 7.1, 8) are complete
  and match the renders and the code:
  - the band table and the state-to-band mapping (1 / 2 / 3 / 5);
  - the tier table and its sources;
  - the take-b rules;
  - the 25 SVGs exist as named;
  - the history gap and the double money and reputation display are
    raised for Pip.
- **Page 9.** The order is right:
  - H first;
  - the band strip, captioned 1 NOMINAL to 7 TERMINAL;
  - both resource takes side by side, with Moment tabs 3 / 5 / 6;
  - H-HF as "the same design as H with a heavier texture";
  - C, E and G as "the earlier texture".
  - The mixer link is relative (`mixer/index.html`).
  - Images load: 21, and the one empty source is the closed lightbox.
  - With every `<details>` open there is no page scroll at 1440, 390 or
    320 (1425/1425, 375/375, 305/305).
  - Nothing from the private review message is on the page or in the
    spec. The brief's paraphrase stays in the brief.

Check 8:
- Contrast on the committed PNGs (box median vs stroke core):
  - H s1 to s6, the three traces and the seven bands are all at or above
    4.5 at 1920;
  - the low at 720 is the held note, 4.52-4.53, matching the designer's
    table.
- My fresh s5 render fell lower only because my fallback fonts change the
  review paper's line wraps. The committed s5 is fine.
- The data still agree:
  - $140,000, research -12, rep 32;
  - $102,600 + 6 rep and $37,400;
  - held 7 / 20;
  - Standard Hiring $25,000 + 1 held hr;
  - HIGH -> SEVERE with no delta;
  - 81.4% CATASTROPHIC, rep 21, $12,300.

## Blocking items
None.

## Non-blocking (at most 3)
1. [H s1, s5, s6; resource strip, reputation cell] "50" and then
   "0 ends the run" read as one string at a glance ("50 0 ..."), and at
   rep 21 as "21 0". The fix: a thin rule or a gap between the value and
   the note, or set it as "ends the run at 0".
2. [index.html section 02 caption; one word in 06] "Only the doom band
   changes between these screens" sits under seven shots that all read
   20.0% ELEVATED on the meter.
   - Add: "the P(Doom) panel is left at 20% so only the room changes".
   - In 06, "this round's hierarchy" is process jargon. Use "the newer
     hierarchy".
3. [spec.md 2.4] It says the layer follows "the palette doc", but
   PALETTE_AND_DOOM_INTENSITY.md has five art bands (0 Cosy to
   4 Terminal) and H keys seven game bands. Add the one-line mapping H
   uses, so Pip's artist knows which art band each game band draws from.
   For example:
   - 0-1 = Cosy / Uneasy;
   - 2 = Spooky;
   - 3-4 = between Spooky and Eldritch;
   - 5 = Eldritch;
   - 6 = Terminal.
   The palette doc keeps violet for its band 3 and up, and H first uses
   violet at band 5.

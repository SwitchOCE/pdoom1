# C. The Paperwork Desk, darker -- notes (hifi3)

This is a texture pass over the hifi C (fork/design/hifi/C/, council round 1
fixes applied) in H's grim look (fork/design/hifi3/H/). C's layout stays:
- the accounts strip, the P(Doom) dial and the reputation gauge across the
  top;
- the desk band along the bottom: card box, clipboard, the cat print, four
  shortcuts, then held-for-events and Commit;
- the work opens as paper over the room.

Files:
- concept.html: `?state=1..6`, `?still=1`, `?check=1` (writes the text
  boxes and the layout check). The stage is 1920x1080, scaled uniformly.
- assets/: the room, the cat photo and two textures. Every file is used;
  render.sh's unused check found none.
- s1..s6.png (1920x1080) and s1-720..s6-720.png. These are not for commit.
- s1..s6.webp: 1920 wide, quality 98, 171-286 KB. These are for commit.
- render.sh: one Chromium at a time, scratch deleted, and it stops if
  ~/.disk-low exists.
- measure.py: the contrast measure (method below).

## The states

The same run-state and numbers as hifi C. Revision 2 and Revision 3 are
both applied.

1. **July 4, 2017, month 1 (art band 0).**
   - The room at its lightest step. The dateline types in.
   - Accounts read $245,000 / 100 / 0 / 0. P(Doom) reads 20.0% ELEVATED,
     with "band 2 of 7" under the ladder. Reputation reads 50.
   - The Advisor's note is an aged paper slip with the game's line and a
     plain "Got it". A thin amber line points down to the card box, which
     has the only amber ring on screen.
   - The clipboard reads 12 of 12 / 8 of 8 left and "Form blank". Held 20
     hr. Commit is small, with Enter.
2. **November 1, the card drawer (band 1).**
   - The room is dimmed and the drawer opens as an opaque dark panel. Its
     header: planning pips 9 of 12 left, operating 8 of 8, money $140,000,
     research -12 in warn, and "CLOSE Esc".
   - Five rows with vertical tabs. Folders are dark files with a brass
     edge; single cards are dark index cards with an oxide rule.
   - Blocked cards are dashed and hatched, each with its reason (Soon,
     Nobody hired yet, Short N research, Submit Paper: short 27 research).
   - Safety Audit has focus, with "Add to form Enter". The menu is the top
     layer, so Commit hides its Enter.
3. **November 1, the Schedule of the Month (band 1).**
   - A paper sheet on a dark board. It lists 11 plays, each with its own
     ^ v x controls. The first up and the last down are inert.
   - Row 11 carries the spill tint and an inverted "from planning" tag.
   - Totals: 4 plan hr + 9 op hr, $102,600 + 6 rep. Below them sit Undo Z,
     Clear form C, and the spill rule in plain words.
   - The side column has:
     - founder's hours as filled-is-left boxes, with the spill box and arrow;
     - the set-aside stepper and "Held for events at Commit 7 hr";
     - "After costs" ($140,000 -> $37,400, 32 -> 26);
     - research quality.
4. **November 14, the month in play, with Talent Opportunity (band 1).**
   - A light dim. The memo is aged paper with "NEEDS YOUR ANSWER", the
     event's text and three numbered tick rows:
     - Fast-Track is ticked: $25,000 + 1 held hr;
     - Standard Hiring: $25,000 + 1 held hr;
     - Decline: free.
   - Its footer: "In hand: $37,400, 7 held hr" and "File answer Enter".
   - The teleprinter roll beside it prints the game's month messages.
   - The clipboard shows "Committed Wed 1 Nov, 11 plays" and the 22-day
     strip at day 10.
   - The held panel turns into the watch panel: "PAUSED FOR YOUR ANSWER",
     1x/2x/4x and 7 hr. Commit reads "MONTH IN PLAY" and is off.
5. **December 1, the month review (band 2).**
   - The dateline types in. The receipt (paper with torn edges) shows:
     - last month's movement;
     - money;
     - founder's hours, with the game's lapse line;
     - what happened in November, using the game's result messages and the
       14 Nov memo line.
   - The card box is closed for the month. Commit becomes "BEGIN PLANNING /
     DECEMBER 2017 Enter".
6. **April 2, 2018, home (band 3, CATASTROPHIC 81.4%).**
   - The same home as state 1, with every control in the same place. The
     room darkens as a layer: soot vignette, violet multiply, violet sky and
     glow, and a violet aura and smoke on the cat print.
   - Under the ladder it reads "Very close to game over". 17 cards, 2 on
     payroll.

## What changed from hifi C, item by item

1. **Dark palette and meters.**
   - Every instrument is a dark .pnl panel with H's tokens, grain, smut, the
     painted-metal texture and corner ticks.
   - P(Doom) is a 270-degree arc with band ticks and a 7-step ladder in the
     band colours. It replaces the CRT counter.
   - Reputation is a dark semicircle gauge.
   - Attention is shown as plan and op boxes in the two pool colours.
   - The meters keep the game's band colours. Text in a band colour is
     lifted to at least 5:1 (H's doomText).
2. **Only paper is light.** The light surfaces are the Advisor slip, the
   clipboard sheet, the schedule sheet, the memo, the teleprinter roll and
   the receipt. All use H's aged paper: gradient, grime, fold crease, darker
   inks and inverted keycaps.
   - Card tops in the box are dark.
   - Shortcuts and all desk furniture are dark plates.
   - Amber appears only on:
     - the month-1 card box ring and its pointer;
     - the focused card;
     - the ticked memo row;
     - Commit's label.
   - Warn orange appears only on negative research and on shortfalls.
3. **Dateline.** This is H's code: type-on with the ribbon wobble. It types
   in on states 1, 5 and 6 only; states 2-4 show it set. `?still=1` and
   prefers-reduced-motion show it whole.
   - The synthesised sound is H's SOUND_START..SOUND_END block, spliced
     verbatim. It is started from a click on a visible "Mock-up: type the
     date with sound" button, which is hidden under `?still=1`.
   - It replaces the tear-off calendar.
4. **Commit the Month.** A 296x60 dark plate at the bottom right. Its
   label is amber condensed caps, with Enter only when the desk is the top
   layer. "Held for events N hr" sits directly above it in its own panel.
5. **Nothing glossy.** The following are gone:
   - the glossy stamp faces;
   - the brass name plates;
   - the coloured shortcut fills;
   - the CRT glass and scanlines.
   Everything is now flat panels, hairline frames, grain and wear. Pip's
   icons sit on dark plates, slightly desaturated and dimmed (list below).
6. **Room to darken.**
   - Room filter brightness by art band 0/1/2/3: .62/.55/.46/.40. Saturation
     falls from .55 to .30, and the grade moves from warm to blood-violet.
   - Band 3 adds the late layer. TERMINAL (not shown) keeps headroom.
   - Panels and paper never darken, and no control moves between states 1
     and 6. The states share one layout and only the room layers change.
7. **Contrast.** Measured on the rendered pixels at both sizes (table
   below). No text box is under 4.5:1.
8. **Off-character mock-up inventions removed.** See "Removals".
9. **People.** Pip's Staff (ui_staff_management) and Hire (button_hire)
   icons stay. No other person or silhouette appears; there are no C.V.
   sheet or portraits.
10. **Same run-state and rules:**
    - filled = hours left;
    - only the top layer shows Enter/Esc (menus hide the desk keys; watch
      and review hide them except the review's Begin planning);
    - every play row has its own ^ v x;
    - operational text is 16px or more at 1920 (the font census in
      render.sh lists 16/18/22/28/40 only);
    - no doom deltas anywhere (the review's doom row says "HIGH -> SEVERE /
      crossed up", the game's wording);
    - no NEW chips;
    - Standard Hiring costs $25,000 + 1 held hr.

## Removals (mock-up inventions only)

- The tear-off desk calendar and its "Plan, month N" sub-labels. The
  dateline replaces them.
- The "Form A-20 / Founder's office" form number, and the "PARA. 2." prefix
  on the spill rule (the sentence stays).
- The hole punches on the schedule sheet.
- The C.V. sheet and its photo corner.
- The memo's own date line (the dateline already says it).
- The "Founder's office -- month review" header, and the "Next: the
  December form" line on the receipt.
- The brass name plates and pins on the shortcuts and the card box.
- The CRT counter: scanlines, glass glare and the VT323 type.
- The glossy rubber-stamp faces (the stamps are now flat ink in one
  colour).
- The coloured shortcut fills.
- The pencil and eraser buttons. Undo and Clear form are now plain keyed
  plates.
- Pip's ui_control up/down/remove/cancel/back/clear/confirm/pause/forward
  icons on the form and the watch panel. They are replaced by ^ v x glyphs
  and text. They read as bright glossy buttons on dark plates. This is a
  mock-up choice; the game's own controls are untouched.
- The "Held for events" line on the teleprinter feed, which was not a game
  message.

Nothing from the game was removed. Every label in Pip's UI that C shows
(card names, descriptions, messages, the Advisor line) is kept as the game
has it.

## Art that would need darker versions

These are toned in CSS here (dark plate, desaturate, dim). A real build
would want art made for a dark ground:
- ui_config_date_64 (the bright calendar "17"). It is no longer shown here,
  but the game uses it.
- The resource icons (money, compute, research, papers, reputation, doom,
  action points). Their glossy highlights fight the flat panels.
- ui_guide_resources, action_funding_loan and ui_guide_strategy: bright
  fills that stay loud even toned.
- The new_*.svg placeholders (advertise, meetup, post online, publicity,
  supplies, travel). The game has no icons for these plays; see the bugs.
- The cat photo (office_cat_doom-cat). It is used as a print with a band 3
  aura added in CSS. The live cats have no doom variants, and an eldritch
  cat for band 3+ would carry the darkening better.

## Contrast (composited pixels, every state, both sizes)

H's method:
- `?check=1` writes every visible text box.
- measure.py reads each box from the PNG, scaled to the image width.
- Background is the median luminance of the box. Text is the k-th pixel
  farthest from it, with k = max(4, 0.5% of the box).
- No CSS colour is used, so the dim, grain, grime and antialiasing all
  count.

| State | Text boxes | Lowest at 1920 | Lowest at 1280x720 | Under 4.5:1 |
|---|---|---|---|---|
| 1 | 60 | 5.01 ("PLANNING", clipboard) | 4.61 (held note) | 0 |
| 2 | 104 | 5.48 (reputation "0") | 4.63 (held note) | 0 |
| 3 | 179 | 4.58 ("op hr", totals) | 4.57 ("op hr", totals) | 0 |
| 4 | 104 | 5.00 ("14 Nov", teleprinter) | 4.62 (closed card box note) | 0 |
| 5 | 104 | 4.89 ("56.7%") | 4.62 (closed card box note) | 0 |
| 6 | 58 | 4.84 ("CATASTROPHIC") | 4.63 (held note) | 0 |

What the measure forced:
- The reputation note was renamed (.rp-note) so it no longer took the
  review's note style.
- The receipt stamp was made bold, #e39d66 (it read 4.34 at 720).
- The spill tag is now inverted: paper text on op-ink. As a hairline-boxed
  tag on paper, the box median at 720 fell between paper and ink and read
  1.69. By eye it was fine, but the inverted tag is unambiguous.
- The card tops in the box were darkened.

## Bugs and data gaps (not fixed; carried from hifi C)

- **Scouting choices have no icon.** Read the Literature, Go to Meetups and
  Post Online have no entry in icon_mapping.json. The game draws its
  magenta missing-texture checkerboard for them. The mock-up uses
  placeholders.
- **Unlock gates count workdays.** turn_min on Safety Audit (5) and
  Strategic (10) counts workdays (GameState.turn), not months.
- **Costs that live only in code:**
  - Work Your Connections has `costs: {}`; its hours and reputation cost
    are in code.
  - Advertise a Role's description names costs that its `costs` does not
    hold.
- **The cats:** the live cat photos have no doom variants, and
  assets/cats/default (five doom SVGs) is orphaned.
- **The event pictures** in assets/images/events are unused, and two show
  people.
- **Doom deltas in PLAN:** today's PLAN prints "Doom this turn: Panic +0.5
  ..." (breaks ADR-0015). Not copied.
- **"Turn" on the HUD:** the HUD counts workdays ("Turn 87" on 1 Nov 2017).
  The dateline shows the date.
- **Negative research:** research goes negative (-12) with no warning. It
  is shown here in warn, and the shortfall reasons count from it.

## Open questions

1. **Sound bus.** The dateline sound is synthesised in the page (H's block).
   In the game it would need a bus and a volume setting. Which bus, and is
   it on by default?
2. **"After costs."** Should PLAN show an "after costs" preview? The game
   has none today; state 3 shows one (costs only, from the Revision 2
   fixture).
3. **Spill attribution.** Should the spill be tied to one play (row 11's
   tag), or shown only on the hour boxes?
4. **Begin planning.** In the review it takes the Commit slot, so the
   bottom-right key does the month's next step. H puts it on the paper.
   Which reads better?
5. **Watch speeds.** C shows 1x/2x/4x (paused by the memo). H shows
   Pause/1x/2x/4x. Should Pause be a separate control?
6. **No RISING in watch.** The run-state gives no trend on day 14, so state
   4 shows none. Is the trend computed daily or only monthly?
7. **The Advisor line.** It is kept as the game has it ("the glowing
   button"), and the card box glows. Should it name the card box instead?

## Visual pass

Checked by eye at 1920 (a montage of all six) and on crops at 720:
- **State 1 against state 6:** the same layout. State 6 is clearly darker
  and violet-graded, while the panels are unchanged. Month 1 is not at the
  bottom of the scale.
- **Paper:** the only light surfaces. The aged tone keeps them from glaring
  against the room. The amber appears in only one or two places per state.
- **Menus:** the drawer and the schedule board are opaque, so no desk
  object shows through. The clipboard clip no longer pokes above the
  drawer.
- **State 2:** "Add to form Enter" now fits inside the focused card (the
  icon went from large to medium and the padding was trimmed).
- **State 4:** the memo and the roll do not overlap; the roll is unrotated
  so its lines stay level. The watch panel grows upward and Commit stays
  where it is.
- **State 5:** the receipt clears the card box and the Commit slot. The
  movement and messages columns align.
- **Layout check:** with `?check=1`, every state reports no overlaps, no
  text outside its box and no text under 16px.

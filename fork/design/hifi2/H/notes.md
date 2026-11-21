# H. The Desk, Grim -- notes (grim pass, hifi2)

Status: PASS 1 (state 3) done. States 1, 2, 4, 5 and 6 come in PASS 2.

Files: `concept.html` (`?state=3`; `?still=1` shows the dateline without its
type-on; `?check=1` runs the layout check), `s3.png` (1920x1080),
`s3-720.png` (1280x720), `s3.webp`, `assets/` (only what state 3 uses).

Alex's words this pass answers (from fork/design/hifi2/brief.md):

> "I like the meter, like the probability of doom meter, and the darker
> color tones. If we have paper on screen, it should be the only light
> thing ... light colors and bright colors kind of break that immersion ...
> the doom meter from the G is the style I want to go with pretty much for
> everything ... the calendar things feel too corny ... the commit the month
> in option A is just it's too big ... I think the main work is just
> changing the texture of it ... rather than the layouts so much."

## State 3 -- the month's plan (November 2017)

The layout is A's: the plan fills the left two thirds, P(Doom) and
reputation hang top right, the shortcut rack and the Commit column sit
bottom right. What changed is the surface. A's bakelite CRT with screws
and amber phosphor glow is now one flat near-black panel with a hairline
frame, worn brass corner ticks, film grain and a faint smut texture
(Frostpunk's dark smoky panels). Text is bone, not glowing amber; amber
survives only on the things that need attention: the open menu (PLAN in
the rack) and Commit. Planning and operating keep G's colour pair, dulled
(brass and grey-sage). The calendar is gone: "NOVEMBER 1, 2017" is typed
top left on the dark. The room behind is darker and greyer than A's, but
not at its darkest (see "Room to get darker").

Content is A's state 3 after council round 1, unchanged: 11 plays, the
Attention grid (planning 7 of 12 left with the hatched spill hour,
operating 0 of 8 left, reserve 0 hr), the spill line, each row with its
own ^ v x targets (^ inert on row 1, v on row 11), Undo [Z] / Clear [C],
queued cost $102,600 + 6 rep, AFTER COSTS $140,000 -> $37,400, 32 -> 26,
held for events 7 hr untyped, research quality Standard, "P Esc BACK TO
DESK". Commit hides Enter here (the plan owns the keys).

## Changes from A, item by item (designer brief / brief.md "What this pass makes")

1. **Layout A, smaller Commit.** A's 190px yellow dial in its 296x428
   housing is gone. Commit is a 296x60 dark button with an amber hairline
   and amber condensed caps, fixed at the bottom of the right column
   (1584,980). Above it, a small panel holds "Held for events 7 hr"; the
   panel grows upward (WATCH will add the month clock and speed there),
   so Commit never moves. Everything else keeps A's positions; the plan
   panel starts 48px lower (top 88, not 40) to give the dateline a fixed
   place.
2. **E's card file in state 2.** PASS 2.
3. **G's palette, panels and meter for every instrument.**
   - P(Doom): G's ring (flat 16px arc on a faint track, the game's doom
     stroke colour, mono percentage and band name in the lifted text
     tint, G's seven-band ladder) drawn as a 270-degree tachometer, with
     fine ticks at the six band boundaries. Level, band and "RISING" only;
     no delta (ADR-0015). Band colours kept (ThemeManager DOOM_STOPS and
     DOOM_STATUS_BANDS).
   - Reputation: the same meter as a semicircle, bone fill (band colours
     belong to doom). The one red mark is the real rule: reputation 0
     ends the run (game_state.gd:617); the panel says "0 ends the run".
   - Attention: G's flat rectangular pips; filled = hours left, empty =
     spent, hatched = the operating hour drawn from planning.
   - Panels: G's dark panel, flatter (2px radius), darker (#100e0c at
     95%), lower-contrast frame, no glow.
4. **Paper the only light thing.** State 3 has no paper and nothing light:
   the brightest surfaces are bone text. (Paper arrives in states 1, 4
   and 5: the advisor card, the event slip and the review sheet, aged.)
5. **Typewriter dateline.** "NOVEMBER 1, 2017", Courier Prime bold 28px,
   wide tracking, top left at (56,24), date only (the game names no place
   for the lab). The ribbon is worn: each strike lands a little lighter or
   a pixel low, in a fixed pattern (no randomness, so renders repeat).
   concept.html types it in (about 95 ms a key, a brief bright strike,
   then a caret that blinks out). `prefers-reduced-motion: reduce` and
   `?still=1` show it whole; the renders use `?still=1`. Sound: open item
   below, not built.
6. **Less cartoony.** Removed: the bakelite CRT body, screws, glass
   glare, phosphor glow, brass plates with bevels and highlights, the
   glossy yellow dial, rounded corners. Added: film grain (inline SVG
   noise), smut, a faint painted-metal scuff, hairline frames, worn
   corner ticks, dim light.
7. **Icons.** Pip's icons sit on 36px (rack) and 28px (headers) near-black
   plates, toned with `saturate(.42) sepia(.22) brightness(.95)`.
8. **No person or operator silhouette.** None.

## Contrast (measured)

Method: `?check=1` writes a TXT line per text box (position, computed
colour, effective opacity). A script samples the rendered s3.png inside
each box, takes the median of the half of the pixels farthest from the
text colour as the background, blends the text colour by its opacity, and
computes the WCAG ratio.

State 3: 190 text boxes, none under 4.5:1. Lowest: row number "11" on the
spill row's tint 4.88; the inert "v" on row 11 5.23; other row numbers and
"--" 5.3. P(Doom) "40.2%" and "HIGH" use the lifted text tint (aim 5:1 on
the panel). The inert ^ / v targets are told apart by a dashed hatched box,
not by fading the glyph below 4.5:1.

Note: state 3's meters, rack and Commit sit under the dim layer (the plan
is the topmost layer), as in A. They are measured as drawn there.

## Agreed rules, checked in state 3

- 16px floor: font sizes in use 16, 18, 22, 28, 40 px (check output).
- Attention bars filled = hours left: yes.
- Only the topmost layer shows Enter/Esc: the plan shows "P Esc"; Commit
  hides Enter; the rack keeps its letter keys (as in A, they are
  shortcuts, not Enter/Esc).
- Every repeated play has its own edit target: each row its own ^ v x.
- Council r1 fixes: no NEW chips (none here); others are in states 4/5.
- Layout check: no overflow, no text outside its box, nothing off stage,
  no overlaps.

## Room to get darker

The doom layer is A's (one grade, one glow, the window sky), shifted down:
room filter brightness .62 / .55 / .46 / .36 and saturation .55 / .45 /
.35 / .30 for art bands 0-3. November (band 1) is the second step, not the
floor; state 6 (band 3) takes it to .36 with the violet sky, and TERMINAL
(band 4) still has headroom below that. The panels themselves do not
darken with doom (a layer, not a repaint).

## Fixtures and data

Unchanged from A (fork/design/hifi/run-state.md, revisions 2 and 3):
NOV_QUEUE (11 plays), booking per month_plan.gd (operating work past the
operating hours spills into planning), money $140,000, reputation 32,
P(Doom) 40.2 HIGH rising, Wed 1 Nov 2017.

## Icons

Used in state 3: ui_guide_actions_64, ui_config_date_64, ui_staff_management_64,
button_upgrade_normal_64, ui_budget_finance_64, ui_guide_book_64 (rack),
new_inbox_tray.svg (rack, new art from A), doom.png, reputation.png
(meter headers).

Needs grim art (still read cartoony after toning, at 1920):
- doom.png and reputation.png: glossy round "resource orb" style.
- ui_config_date_64 (PLAN): a tear-off calendar with "17" -- the exact
  motif Alex called corny; wants a ledger or typed-sheet glyph.
- new_inbox_tray.svg: flat placeholder from A, still needs real art.

## Bugs and data gaps

None new in state 3.

## Open questions (for the report)

- Typewriter sound for the dateline: one key strike per character and a
  carriage return at the end? Which mix bus, and is it muted with UI
  sounds? Not built.
- Should the dateline also type in at game start (month 1), or only on a
  month change?
- The plan panel is no longer a "terminal" object; "LAB TERMINAL 1" is kept
  as its footer label. Keep the name, or drop it now the CRT is gone?

## Visual pass (state 3)

Looked at by eye at 1920 (full and two crops) and at 1280x720: tracking
and alignment hold at 2/3 size, nothing clipped, the dateline reads at 720
(about 19px there). The type-on animation was checked mid-run (a render
stopped at 1.1 s shows "NOVEMBER 1").

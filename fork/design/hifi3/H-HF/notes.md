# H-HF -- the desk, riveted (hifi3 addendum)

The revised H (`fork/design/hifi3/H/`) with a texture pass drawn from
HighFleet and amber control panels: worn painted steel, rivets and screws,
stencilled labels, counter windows, an analogue dial and warning plates.
Texture only. Same layout, hierarchy, colour by band, tier icons (take a),
ids and dateline as H.

- `concept.html?state=1` first screen (July, band 1), `?state=4` WATCH
  event (14 November, band 2), `?state=5` end of month (December review,
  band 3). Any other state value shows state 1.
- `?still=1` shows the dateline whole (renders); `?band=0..6` forces the
  room's doom layer only, as in H; `?check=1` runs the layout check and
  lists every text box for the contrast measure.
- `render.sh 1 4 5` renders `sN.png` (1920x1080) and `sN-720.png`
  (1280x720), runs the check and `contrast.py`, and writes `sN.webp`.
- WebP (committed): `s1.webp` 271 KB, `s4.webp` 270 KB, `s5.webp` 292 KB.
  The PNGs stay uncommitted.

The texture is one CSS block at the end of the style sheet, headed
"H-HF TEXTURE", on top of H's rules. Its tokens are `--hf-*` and
`--stencil` in a second `:root`. Every texture is drawn in the page
(SVG noise and CSS gradients). There are no image files for it, and no
pixels from any reference.

## 1. What changed from H, item by item

| # | Element | H | H-HF |
|---|---|---|---|
| 1 | Panels (`.pnl`) | warm near-black, hairline frame, smut + grain, H's metal texture image at 5% | olive-black painted steel (`--hf-paint`), dark edge, pressed rim (a groove 6-7px in), lit top lip and shadowed bottom lip; worn top coat mottle (`--hf-mottle`) with H's smut and grain; chipped paint and fine scratches (`--hf-chips`, `--hf-scratch`) masked to the outer 18-22px of each plate. H's metal texture image is gone. |
| 2 | Corner ticks (`.cn`) | brass L-ticks | domed rivets, 8px, 4px in from each corner (same elements). On the resource strip only the top two show; the lower ones give way to the warning plate. |
| 3 | Panel headers (`.ph`) | Barlow 600 on the panel | stencil caps on a slightly raised band, with a groove under it |
| 4 | Labels | Barlow Condensed caps | Big Shoulders Stencil Text 700, same sizes and colours. Two label sets moved from dim to muted, because the stencil's cut strokes measure lighter: the resource names and the band ladder. The resource cells keep H's text widths (`min-width`) so the strip does not move. |
| 5 | Numbers | plain mono | each in a dark counter window (`.ctr`): money, compute, research, papers, reputation, held hours. Money, the P(Doom) percentage and the WATCH clock also get drum seams between characters (`.ctr.drum`), like a rolling counter. Same digits, sizes and colours. |
| 6 | P(Doom) | 270-degree arc on the panel | the same arc, band ticks and colours, set in an analogue dial: steel bezel with four slotted screws, a sunk face, a fine scale every 2.5 (no numerals), a needle at the level running under the number's window, a hub, and one faint glass reflection. The ladder bars become lamps with bezels; the lit one glows in its band colour. The panel keeps its band-coloured frame and top edge. |
| 7 | "0 ends the run" | small grey text after the reputation number | the same words on a small black warning plate with a dull amber/black hazard stripe at its left end |
| 8 | Rack (`.kb`) | flat dark plates | raised push plates (lit top lip, dark bottom lip, shadow); stencil labels; key caps sunk into the steel. The hint glow (state 1), the disabled hatch (state 4) and the hidden keys are H's. |
| 9 | Commit (`.cmt`) | flat button | the same button with a bevel; when muted (idle, wait, month in play) it sits in a dark guard ring. Colours and states are H's. |
| 10 | PAUSED FOR YOU (state 4) | red-bordered strip, red dot | a warning plate: hazard stripes at both ends, a domed red lamp, stencil words. Same red border and text colour. |
| 11 | WATCH clock and speed | dark well | the well sunk deeper, the date in a drum window; the selected speed is a pressed-in segment |
| 12 | Attention pips | flat | filled pips get a lit top lip and a dark bottom lip (backlit segments); spent pips unchanged |
| 13 | Desk | dark brown gradient | a steel console sill with a riveted seam along its top |
| 14 | Event option numbers (paper, state 4) | `#c9bc9f` on the dark tab | `#e4dac4`. The rest of the paper is H's. Under the text-extent measure (below) H's "1" was 3.89:1 at 720; it is now 5.00. |
| 15 | Check mode | element boxes | each text box is the text's own extent (a DOM Range), as in G; the counter windows are exempt from the overflow check (they are drawn outside their element on purpose) |

Unchanged:
- The room and its doom layer (`DOOM_LAYER`, `room()`, `lateLayer()`).
- The paper surfaces (advisor note, event, teleprinter review), apart from item 14.
- The cat's photo and glow.
- The tier icons.
- All data and wording.
- The dateline and its sound block. The `SOUND_START..SOUND_END` block has the same sha256 as H's. `soundControl()` and the dateline code are identical; a real-time test shows the button locks on click and unlocks when the tail ends.

Layout check: every element box was compared with H's at 1920x1080, in the same state. This covered:
- each `data-el`;
- each resource cell, rack plate and ladder row;
- each header, clock, speed row and event option.

That is 36 boxes in state 1, 42 in state 4 and 36 in state 5; no box differs. The self-check is clean, with no text under 16px.

Mixer ids: the same `data-el` and ids as H for the three states: `room`, `dateline`, `doom`, `resources`, `rack`, `plan` (states 1 and 5), `feed` (state 4), `held` and `commit` (both `data-el=commit`), `advisor` (state 1), `event` (state 4), `review` (state 5), `cat`.

Texture classes the mixer can lift with a piece:
- `.pnl` with `.cn` (painted plate and rivets);
- `.ph` (stencil header);
- `.ctr` and `.ctr.drum` (counter windows);
- `.warnp` (warning plate);
- `.kb` (push plate);
- `.paused` (hazard plate);
- `.desk` (sill).

They all need the second `:root` block (the `--hf-*` tokens and `--stencil`). The dial is drawn in `doomMeter()`.

## 2. HighFleet: what I took and what I left

I looked at `research/reference-games/shots/highfleet-1..8.jpg`. No pixels were copied; every texture is drawn from noise and gradients.

**Taken:**
- Painted steel in olive and dark grey, chipped at the edges and scratched.
- Fasteners: domed rivets on plates and slotted screws on the dial bezel.
- Stencilled condensed caps for labels.
- Mechanical counters: numbers in recessed windows, with drum seams on the main ones.
- An analogue dial: bezel, sunk face, fine scale, needle and hub.
- Hazard-striped warning plates, kept for the two real warnings on screen: the pause, and "0 ends the run".
- Indicator lamps with bezels (the band ladder).
- Raised push plates (the rack).

**Left out on purpose:**
- **The density.** HighFleet fills every panel with gauges, switches and plates. H-HF adds no control, gauge, label, number or plate that H does not have.
- **Light dial faces and light metal nameplates.** Paper stays the only light thing, so every face, plate and window is dark and the numbers are bone.
- **Amber nixie digits.** In H, amber means "look here" (the hint, Commit when armed). Amber digits everywhere would spend that signal.
- **Bright yellow hazard stripes.** The stripes are dull amber (`#7a5e27`) and black, so they mark a plate without outshining P(Doom).
- **Numerals on the dial scale.** That would be new information. The fine ticks are unlabelled, and the band ticks are H's.
- **Cyrillic, serial numbers and decorative text.** Every word on screen means something in the game.
- **CRT glow and scanlines on the terminal.** They would cost contrast and add a second light source.
- **Rust, heavy dirt, the chalkboard map and the brass and red-lamp clutter.**
- **Wear on the letters themselves.** Readability comes first.

## 3. Contrast

Measured on the composited rendered pixels with `contrast.py`, which is G's method:
- each box is the text's own extent;
- the background is the box's median luminance;
- the text is the k-th pixel farthest from it.

| State | Boxes | Lowest at 1920 | Lowest at 1280x720 | Under 4.5 |
|---|---|---|---|---|
| 1 | 66 | 5.47 (held note "untyped; what events...") | 4.76 (held note) | 0 |
| 4 | 87 | 5.82 (ACTIONS, disabled rack plate) | 5.00 (event option "1") | 0 |
| 5 | 113 | 5.47 (held note) | 4.76 (held note) | 0 |

Next lowest:
- State 1 at 720: COMPUTE 4.78, RESEARCH 5.63, "Plan is empty" 6.04, HIGH 6.06.
- State 4 at 720: COMPUTE 5.19, FEED 5.25, option "2" 5.25.
- State 5 at 720: COMPUTE 5.19, SEVERE 5.49, PAPERS 5.63, 56.7% 5.63.

H's floor at 720 was 4.53, set by the held note. H-HF's is 4.76, set by the same note.

## 4. Removals

- **States 2, 3 and 6.** Their screens, their CSS and their code (`planScreen`, `attentionBars`, `handScreen`, `cardFile`, `lateScreen`) are gone. The brief asks for three states. `lateLayer()` stays, because `?band=5..6` uses it.
- **Take b, the trace windows** (`?res=trace`, `HIST`, `traceSVG`). H-HF is take a.
- **The reputation dial** (`?rep=dial`, `repMeter`).
- **H's `tex_painted_metal_panel.webp`.** H-HF draws its own steel.
- **Unused assets.** The icon table now lists only the nine icons the three states use; `assets/` holds only what the three states load (9 icons, 8 tier SVGs, the office and the cat).

## 5. Open questions

1. **Stencil legibility.** The stencil labels pass 4.5:1, but cut letters read more slowly than whole ones. Should the rack labels (the controls players read most) go back to Barlow, with the stencil kept for panel headers?
2. **Label colour.** The resource names and the band ladder moved one step brighter, from dim to muted, so that the stencil passes at 720. This flattens H's label hierarchy a little. Is that acceptable, or should those labels stay in Barlow?
3. **Drum seams with $ and commas.** Real rolling counters carry digits only, while the seams here also frame "$" and ",". Keep the drum effect for money, or use a plain window?
4. **The needle.** It shows the same level as the arc and the number; it is not a delta, so ADR-0015 holds. Is a second pointer for one value worth it? Without the needle, the dial is still a dial.
5. **Wear and the band.** The panels' wear is the same at every band (H's rule: doom is a layer on the room, not a repaint of the panels). Should the chips thicken with band, like the room's smut does?
6. **New font.** The game would have to bundle Big Shoulders Stencil Text (SIL Open Font License, from Google Fonts).
7. **Event option numbers.** Item 14 is a paper fix that H also needs under the text-extent measure. Should it be folded back into H?

## 6. Section for spec.md

The text added to `spec.md` section 8 is the short version of sections 1-2 above.

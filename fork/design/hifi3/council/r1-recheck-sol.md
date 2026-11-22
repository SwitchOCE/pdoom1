VERDICT: CHANGES NEEDED

## Scores (/10)

- **H 9/10.** The finished desk still matches its six stills. The replay control works in both motion settings.
- **C 9/10.** The new state 3 clamp clears the meter by 9 px at 1920x1080 and 6 px at 1280x720. The PNGs match fresh captures, and the before/after pixel changes are confined to the clamp. The new WebP loads in the gallery. [Clamp](/home/alex/code/pdoom1/fork/design/hifi3/C/concept.html:251), [state 3 WebP](/home/alex/code/pdoom1/fork/design/hifi3/C/s3.webp).
- **E 9/10.** The layout stays intact and the replay control locks and releases at the right points.
- **G 9/10.** The layout stays intact and the replay control also works with reduced motion.
- **Spec 9/10.** The agreed corrections match the code, H's screens, and the updated audio.
- **Page 8.5/10.** The rendering, layout, and replay fixes pass. The Another month control can still leave the demo displaying the wrong date.
- **Sound 9/10.** The new strike code gives the contact more weight, adds a 17 ms escapement tick, shortens and narrows the thump, and lifts the return slide. The low-passed room tail and 95 ms cadence match the agreed tuning. Reviewed as code and raw signal. [Sound synthesis](/home/alex/code/pdoom1/fork/design/hifi3/H/concept.html:584).

- **Sound and copies.** H, C, E, G, and the built page contain the same sound block. In real-time Chromium, each of the five controls started one play from rapid Enter and click input, stayed disabled while busy, and accepted a new play after the tail, with and without reduced motion. Direct calls during playback returned null without firing callbacks. The 44.1 kHz mono 16-bit reference is 3.288 s, with a raw peak of -2.48 dBFS, no normalisation, and zero clipped samples. Another 212 seeded renders at 44.1 and 48 kHz also stayed below full scale. Spec sections 3.3 and 6.3 match the synthesis and reference. [Replay guard](/home/alex/code/pdoom1/fork/design/hifi3/H/concept.html:628), [WAV](/home/alex/code/pdoom1/fork/design/hifi3/H/dateline-sound.wav), [sound spec](/home/alex/code/pdoom1/fork/design/hifi3/spec.md:305).
- **Spec rules and citations.** Section 1.2 states when Attention is debited, uses MonthPlan's pool totals, and limits the no-spill exception to conference travel. Section 3.8 names the `SPILL 1` tag and its display-only estimate. Section 5 maps the balances correctly, and 7.1 leaves the always-on bar to Pip. Section 7.2 gives Strategic both gates. The reputation, doom warning, and pause citations are corrected. The WATCH event hides background keycaps, and the review keeps rack letters and owns Enter. [Attention](/home/alex/code/pdoom1/fork/design/hifi3/spec.md:56), [spill tag](/home/alex/code/pdoom1/fork/design/hifi3/spec.md:448), [paper keys](/home/alex/code/pdoom1/fork/design/hifi3/spec.md:462), [balance mapping](/home/alex/code/pdoom1/fork/design/hifi3/spec.md:590), [open rules](/home/alex/code/pdoom1/fork/design/hifi3/spec.md:703).
- **Page and build.** The committed page matches a fresh build from the source, spec, demo script, and H's sound block. Q/W/E renders in bold and the displayed spec has no stray Markdown markers. With the spec open, document width equals client width at 320, 390, and 1440 px. Wide tables scroll inside their wrappers and code blocks have the same local scrolling rule. All 24 images loaded, all three gallery views showed the expected counts, and the lightbox's arrow keys, focus trap, and focus return worked. The page and WebPs total 6,255,733 bytes. [Converter](/home/alex/code/pdoom1/fork/design/hifi3/build_page.py:115), [page styles](/home/alex/code/pdoom1/fork/design/hifi3/page.src.html:115), [built page](/home/alex/code/pdoom1/fork/design/hifi3/index.html).

## Blocking items

1. **Shareable page, dateline demo with animations enabled.** Start the November playback and press **Another month** before it finishes. The display changes to `DECEMBER 1, 2017`, then the completion callback restores `NOVEMBER 1, 2017` while December remains selected. The next playback starts December even though November is on screen. This bug was present before the fix round. Have the completion callback render the currently selected date, and verify that December stays visible after the tail. [Month selector](/home/alex/code/pdoom1/fork/design/hifi3/page.src.html:352), [completion callback](/home/alex/code/pdoom1/fork/design/hifi3/demo.js:20).

## Non-blocking

None.

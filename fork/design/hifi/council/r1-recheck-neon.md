VERDICT: GOOD TO GO

## Scores (showcase-ready, /10; not a ranking)
A 9/10 . C 9/10 . E 9/10 . G 8.5/10

Checked all modified states across A, C, E and G at both 1920x1080 and 1280x720, verified all 24 WebPs are up to date (1920x1080, 3.3 MB total), verified ASCII-only across HTML and Markdown, measured C's updated P(Doom) contrast directly from the PNGs, and verified `index.html` and `run-state.md` REVISION 3. No nearby layout broke, and every number stays consistent across states 1-6 ($245,000 -> $140,000 -> $37,400 -> $12,400 -> $12,300; rep 50 -> 32 -> 26 after costs -> 34 -> 21; research 0 -> -12 -> -6 -> 4; held 17 -> 7 -> 1 used + 6 evaporated; P(Doom) 20.0 / 40.2 / 56.7 / 81.4).

## Agreed items: done or not

### All four (A, C, E, G)
1. [state 4, both sizes] Standard Hiring shows `$25,000 + 1 held hr` (E: `$25,000` + `1h held`) in `A/s4.png`, `C/s4.png`, `E/s4.png`, `G/s4.png` and all four `-720.png` renders; Decline stays free; Fast-Track stays chosen; state 5 is unchanged; `run-state.md` REVISION 3 and all four `notes.md` close the old open question. **Done.**

### A. The Desk
1. [s2, both sizes] NEW clips removed from Safety Audit and Strategic (`A/s2.png`, `A/s2-720.png`). **Done.**
2. [s4, both sizes] Fast-Track Hiring and Standard Hiring show `+1 safety researcher`; Decline Offer shows `no change`; slip still clears the P(Doom) dial (`A/s4.png`, `A/s4-720.png`). **Done.**
3. [s5, both sizes] Commit plays sit under `1 NOV -- AT COMMIT` (`01`..`11`) and the event sits under a separate `14 NOV` block (`Talent Opportunity` with no play number, plus `Held for events`); fits cleanly inside the sheet at both sizes (`A/s5.png`, `A/s5-720.png`). **Done.**

### C. The Paperwork Desk
1. [s2, s3, s5; s4 checked, both sizes] P(Doom) counter sits above the dim layer at full brightness. Measured contrast directly from the updated PNGs: `C/s2.png` and `C/s3.png` digits 6.51:1 / band 8.24:1 (was 2.39:1); `C/s5.png` digits 3.66:1 (96px display) / band 8.24:1 (was 1.70:1 / 2.74:1). **Done.**
2. [s1, both sizes] Advisor note closes with a plain `Got it` button and no `Esc` keycap (`C/s1.png`). **Done.**
3. [s2, both sizes] Dotted empty card frames in Funds, Outreach and The Lab removed; slots are plain drawer (`C/s2.png`, `C/s2-720.png`). **Done.**
4. [s4, s5, both sizes] Teleprinter and review sheet both print `"Reached out through your network -- a pre-vetted lead may surface shortly."` (`hiring_pipeline.gd:157`) with no overflow at either size (`C/s4.png`, `C/s4-720.png`, `C/s5.png`, `C/s5-720.png`). **Done.**

### E. Rooms and Stations
1. [s2, both sizes] No `NEW` badge on Strategic or `"new this month"` on Safety Audit; focused Safety Audit row shows `+` and `Enter` appears once in `[Enter] Add to plan` (`E/s2.png`, `E/s2-720.png`). **Done.**
2. [s3, both sizes] `COMMIT THE MONTH` hides its `Enter` keycap while the Plan CRT owns `[Esc] Back to desk` (`E/s3.png`, `E/s3-720.png`). **Done.**
3. [s3, both sizes] Printout retitled `AFTER COSTS` and `-12` labelled `Research (now)` (`E/s3.png`, `E/s3-720.png`). **Done.**

### G. The Existing UI, Modernised
1. [s2, both sizes] `NEW` chips removed from Safety Audit (row and detail card) and Strategic (`G/s2.png`, `G/s2-720.png`). **Done.**
2. [s3, both sizes] `Reserve hours [R]` is enabled and Attention reads `Reserved, up to 7 hr / none yet`; the `main_ui` vs core mismatch stays in `G/notes.md` Bugs (`G/s3.png`, `G/s3-720.png`). **Done.**
3. [s3, both sizes] `Read the Literature` appears as two individual rows (`2` and `3`), all 11 plays fit with zero scroll, and `Order Office Supplies` (`1 op / 1 from plan`) sits above Total at both sizes (`G/s3.png`, `G/s3-720.png`). **Done.**
4. [s3-s5, both sizes] `--held` changed to neutral silver (`#C9D2D8`); held pips in s4 and held values in s3-s5 are neutral; purple stays in s6's doom layer (`G/s3.png`..`G/s5.png`). **Done.**
5. [s4, s5, both sizes] Both states show the same four Wed 1 Nov lines word-for-word in queue order (plays 5, 8, 10, 11) under `+ 7 more lines from Wed 1 Nov` (`G/s4.png`, `G/s5.png` and `-720.png`). **Done.**

### Showcase page (`index.html`)
All items verified in `index.html` and a 1280x720 Chromium render: E's caption lists `Actions, Plan, Lab Floor, Procurement, Records`; state 3 notes today's UI pre-check refuses the spill; state 4 gives both hires `$25,000 + 1 held hour each`; lightbox backdrop is solid `#0b0c0d` (`index.html:52`), image caps at `calc(100vh - 64px)` (`index.html:57`), thumbnails are `button.thumb` with `aria-label` and focus restore (`index.html:113-117,175-177`), `Tab` stays trapped on Close while the lightbox is open (`index.html:183`), the concept view says `HTML mock-up` with repo paths and no dead local `.md` links (`index.html:148,165`), and the footer explains the uniform 2/3 scale at 1280x720 (`canvas_items`). **Done.**

## Majority decisions
- **C3 (remove dotted empty card frames; majority: opus, sol):** Accept. The plain drawer looks cleaner in `C/s2.png` and leaves the grid aligned.
- **C4 (Work Your Connections real message; majority: opus, neon):** Accept. Fits cleanly in both `C/s4.png` and `C/s5.png`.
- **G3 (two individual Read the Literature rows in s3; majority: sol, neon):** Accept. All 11 rows fit cleanly without scrolling at both sizes.
- **Non-blocking majority (retain C's mapped Publish Safety Paper icon; majority: opus, neon):** Accept.

## Blocking items

### A
None.

### C
None.

### E
None.

### G
None.

### Showcase page (`index.html`)
None.

## Non-blocking (at most 3)
1. G s4/s5: `+ 7 more lines from Wed 1 Nov` sits above plays 5, 8, 10 and 11 (since plays 6, 7 and 9 sit between them, `+ 7 other lines from Wed 1 Nov` would be exact).
2. A s4: the shortcut rack keeps letter keycaps (`F`, `E`, `L`, `F1`) visible while Talent Opportunity awaits a reply (C, E and G hide background keys during an unanswered event).
3. E s6: the mezzanine window-sky overlay (`.dl-sky`) still has a faint straight edge along the upper transom; feathering the top mask a few pixels will soften it.

## People seen (for Alex's open question)
Unchanged from round 1: all offices and WATCH event art remain figure-free across all four concepts and six states. Only Pip's `ui_staff_management` (Staff / Lab Floor) and `button_hire_normal` (Hire Staff, state 2) carry human silhouettes, kept per brief pending Alex's call.

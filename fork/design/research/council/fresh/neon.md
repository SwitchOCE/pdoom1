# Fresh council, Gemini Neon (reply to fresh-brief.md; defect list condensed, sections 2-4 near-verbatim)

VERDICT: REWORK

## 1. Visual defects (condensed; every item kept)

- `.card.door` collides with the right-column `.door` rule (plan.html:47-48, 99-107): door cards centred and vertically floating, direct cards left-aligned and top-packed.
- Door cards (Fundraising, Hire Staff, Travel): `.top` shrinks to content width, bunching icon and hotkey badge in the middle.
- Travel & Conferences: the ">" wraps onto an orphan third line.
- view-first: "Start here" tag collides with Onboard New Hires; the marker's bottom sits flush against the 1080px edge.
- view-m5: Upgrades drawer (height 320, no overflow) spills its 7th row (HPC Cluster) over the hand divider into the info bar.
- view-m5: the drawer overlaps the right third of the queue, unanchored over live content.
- view-m5: the info strip crowds the RESEARCH header and advertises "Enter: play" while Commit also advertises Enter.
- view-m5: QUEUED label collides with icons on Hire Staff, crowds Financing and Scouting.
- view-m5: Hire Staff's dotted "unavailable" border overrides the dashed door border; its text block is flush-left inside a centred box.
- Operations and Office use byte-identical icons.
- Scouting, Work Your Connections, Travel all show handshakes; Scouting's sci-fi gauntlet handshake reads nothing like reading literature.
- Icons mismatch verbs: Capability Research shows a padlock (capability control, the opposite), Strategic an emergency-stop hand, Publicity a classified folder, Publish Safety Paper a geometry checklist, Safety Research generic gears, Advertise a board meeting, Onboard a graduation cap.
- Mixed icon framing: borderless cutout, circular medallions and dark square tiles with harsh seams against the cards.
- 15 distinct font sizes (11-48px); core decision text breaks UI_STYLE_GUIDE's 16px control / 14px prose floors (QUEUED 11px, costs and reasons 12px, feedback 13px, badges/labels/segments 14px, titles 15px).
- 124px card width forces 4-5 cramped lines of 12px mono.
- SET ASIDE NOW right-aligned beside left-aligned pools; commit caption right-aligned with an orphan "events" line.
- P(Doom) tick gradient (43px) doesn't match 10% steps.
- m5 queue columns total 818px in a 1476px box; "remove" stranded mid-panel.
- Top strip leaves ~1200px empty; the empty queue is a 1476x318 void while cards are crushed to 124px.
- Focus ring crowds the 6px gap and shares teal with "queued".
- Hotkey chaos: key 3 hidden by SOON, cards 10-17 keyless, queuing hides a key; five different shortcut conventions.
- Permanent teaching prose remains ("You lose at 100%...", "You lose at 0.", "Nothing planned yet..."); an unexplained dim "Do Nothing" persists.
- "Send feedback N" hard-positioned at top: 820px; muted #5F7080 text and 0.45 opacity in the drawer fall below 4.5:1 contrast.

## 2. Why it reads as a generic dashboard

1. No physical space or phase progression. Today's game sits inside a moody, CRT-lit lab, and the repo holds a progression of offices (office_wide_dawn, office_wide_day, office_lab_aisle, office_mezzanine) plus an apocalyptic variant (office_scene.png). The mock-up replaces all of it with opaque #0E1318 web containers.
2. No tactile/terminal materials. UI_STYLE_GUIDE.md:232-281 already establishes the game's diegetic object register via MonthReviewPanel (dim manila graph paper, stained plywood, heavy drop shadows, amber CRT scanlines, monospace ASCII chrome). The mock-up uses no textures from godot/assets/textures/, mixes proportional Noto Sans web type, and reads like an analytics admin panel.
3. No operator, no cat, no "across your desk" feel. The silhouetted operator, the office cat (assets/cats/default/*.svg) and employee sprites (assets/office_floor/) are absent, leaving nowhere for doom-as-a-layer or office-as-moral-mirror to live.
4. Card hand and wargame timeline flattened into spreadsheets: 17 cramped 124px tiles; a plain text queue with no gantt bars.
5. Palette drift: warm grime (#2B221A) and deep aubergine (#170A1C) with amber as the single resting accent replaced by cold flat slate with bright teal (#1EC3B3) across six unrelated widget types.

## 3. A better direction

PLAN as sitting at the founder's desk in a living lab, with a persistent outer frame and swappable diegetic stations in the main canvas.

Constant frame:
- Top CRT header strip (subtle tex_amber_scanlines, amber on aubergine): PLAN | Jul 2017, core resources (negative values flagged), and 4 station tabs ([1] Desk, [2] Team, [3] Upgrades, [4] Records -- or F-keys so digits 1-9 stay free for actions).
- Right console column (dark aubergine / tex_painted_metal_panel, fixed across PLAN and WATCH): P(Doom) CRT instrument (level bar + band word, amber to fire via ThemeManager, sparkline once populated, no deltas, no tutorial lines); reputation meter; office cat vignette (small, swaps with doom band); the Attention budget (planning pips, operating pips, reserve) visible in every station; one COMMIT THE MONTH [Enter], bottom-right, the sole action accent.

Places in PLAN (centre-left canvas):
1. The Desk (default): the office backdrop (dawn -> day -> lab aisle -> mezzanine, grading toward office_scene at high doom) behind a smoked-glass / stained-plywood desk. Upper desk: The Month Ahead clipboard/schedule sheet (aged graph paper or amber CRT rule table) -- ordered queue with icons, costs, Undo/Clear, and gantt duration bars + ETA dates for in-flight work. Lower desk: the action hand in Pip's ABBBCCC register -- all live top-level actions directly reachable, left-bound, cards wide enough for >=16px names and costs, consistent framing, distinct icons; a door opens its B-folder over the lower-right of the desk without covering Attention or Commit; focus updates a fixed-height, tinted C-strip at the bottom (nothing jumps, #577).
2. The Lab Floor / Team (Employees + Research Quality): the office floor view with OfficeFloor preview / staff dossier cards (assets/portraits/dossier_*.png), assignments, and the Rushed/Standard/Thorough control where it belongs (pre-staging #1090). Month 1 shows only the founder and a shortcut to Hire Staff.
3. Procurement (Upgrades): full-canvas requisition sheet on dim manila/terminal stock, room for names, prices, shortfall reasons and effects at >=18px.
4. Records Room (Ledger, Guide): Pip's records art (records_crt_ranktable.webp, records_stacks.webp) behind the Liability Ledger and Player Guide.

Hand-over: Commit drops the hand/desk overlay and swivels into WATCH; the top strip and right console stay locked; the centre opens to the live OfficeFloor + backdrop + silhouetted operator framing + CRT feed; the Month Ahead sheet collapses into an in-flight progress strip; events arrive across the desk as manila/CRT slips (assets/images/events/event_*.webp) with Q/W/E choices; month end hands you the existing MonthReviewPanel clipboard while letting you inspect the feed before returning to the Desk.

## 4. What Pip would object to

1. Losing the core image and the phase-changing office (WORKSHOP_2_BACKLOG.md:701-702, 716-719).
2. A corporate web dashboard instead of terminal/mainframe pastiche and the warm-grime palette (BUILD_BRIEF; PALETTE_AND_DOOM_INTENSITY.md: warm grime #2B221A, aubergine #170A1C, amber as the sole resting accent).
3. Missing gantt duration bars (BUILD_BRIEF element 2; WORKSHOP 733-734 "exceptional"; UI_PROPOSALS D2, the #1 drift).
4. Centred vs left alignment and no ABBBCCC (UI_PASS_NOTES).
5. Sub-16px type and overflowing panels (UI_STYLE_GUIDE.md:106-120, after Pip's "cramped / hard to read" feedback).
6. Permanent screen-purpose text and the Operations/Office icon collision (UI_PASS_NOTES; UI_ARCHITECTURE_2026-08-06.md).

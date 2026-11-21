VERDICT: CHANGES NEEDED

## Scores (showcase-ready, /10; not a ranking)
A 9/10 . C 8.5/10 . E 8.5/10 . G 8/10

Checked: all 24 PNGs at 1920x1080 and the dense states (2, 3) at 1280x720;
each concept's notes; godot/data/actions/*.json, core_events.json
(talent_recruitment), balance/defaults.json, actions.gd unlock rules,
hiring_pipeline.gd, month_plan.gd, research_quality_selector.gd, the palette
doc, the r2s/r3x agreed rules. Every name, cost, hour type, choice count and
event option I checked matches the data; the November numbers ($102,600 + 6
rep, $37,400, rep 34, research -6, $12,400, 7/1/6 hours, workday 10 of 22)
agree across states 2-5 in all four. No doom deltas anywhere; the spill is
drawn per ADR-0011 in all four.

## Blocking items

### A
None.

### C
1. [states 4 and 5, both sizes] Work Your Connections reads "done" on the
   teleprinter (s4) and the review sheet (s5) -- the game has a message:
   "Reached out through your network -- a pre-vetted lead may surface
   shortly." (hiring_pipeline.gd:157), and A and E print it, so the same
   play reads differently across concepts. C's notes say "its message was
   not given" -- fix: use the game's message in both places (run-state
   REVISION 2: "use the game's message if you show one").

### E
1. [state 3, both sizes] Commit shows "Enter" while the Plan CRT is open and
   shows "[Esc] Back to desk" -- two layers show keys, against agreed rule 2
   ("only the topmost open layer shows Enter and Esc"). A and C hide
   Commit's Enter in the same state, so the side-by-side view shows the
   difference. Fix: hide Commit's Enter while a station is open.

### G
1. [states 4 and 5, both sizes] The feed's tail for Wed 1 Nov changes
   between states. s4 shows Safety audit, Networking, the first Meetups
   ("Someone unvetted ..."), Office supplies; s5 shows Safety audit,
   Networking, the second Meetups ("No leads ...") and Office supplies
   is gone. Neither follows queue order (rows 5, 8, 7, 11); E's s4 does
   (Networking, Tour Offices, Meetups 2, Supplies). Fix: list the plays in
   queue order and keep the same tail in s4 and s5.
2. [state 3, both sizes] "Reserve (needs operating hours) -- none" and a
   disabled Reserve button draw a rule the core rejects: month_plan.gd
   set_reserve (lines 235-240, "T2 DESIGN CALL") makes the reserve untyped
   and "NOT capped at the operating pool"; only today's UI disables it
   (main_ui.gd:1278). The run follows the ADR and the core over today's UI
   pre-check for the spill, and A, C and E show a live reserve stepper
   at 0. Fix: show Reserve live (up to 7 hr) like the others; keep the
   main_ui/core contradiction in the bugs list for Pip.

### Showcase page (index.html)
1. [all views] The footer links report.md (does not exist yet) and
   run-state.md, and the concept view links <L>/concept.html and
   <L>/notes.md. On a published claude.ai page these resolve only if the
   files (and each concept.html's assets/ folder) are published with it.
   Fix: publish them via `files`, or drop the links before publishing.
2. [E's caption, all views] "stations (Desk, Lab Floor, Procurement,
   Records)" -- E has no Desk station; its stations are Actions, Plan, Lab
   Floor, Procurement, Records (E/notes.md, E s1). Fix the caption.

## Non-blocking (at most 3 per concept)

A
- s4: the rack re-orders in WATCH (STAFF moves from slot 3 to 2, LEDGER
  from 5 to 3) and IN-TRAY is swapped for FEED. Keeping the home slots and
  dimming the ones WATCH disables would match "controls keep their places".
- All four scale the 1920 stage to 2/3 at 1280x720, so 16px text becomes
  about 11px; the 16px floor holds only at 1080. Worth one line on the
  showcase.

C
- s1: the Advisor note shows "Got it [Esc]" while Commit shows Enter (two
  layers with keys; A, E and G close their notes with an x).
- s5: the sheet is headed "NOVEMBER 2017"; the game's heading is "Month
  Review -- December 2017" (A, E and G use it).
- s3: the source door ("Hire Staff", "Scouting") sits inline after each
  play name in a different face, so that column is ragged; the other three
  give it its own column.

E
- The P(Doom) dial housing is purple (#4a2a50 -> #2c1733) in every state,
  from ELEVATED on. The palette doc says "reserve it for band 3+"
  (PALETTE_AND_DOOM_INTENSITY.md:156), and it blunts the change in s6. Pip's
  own button chrome uses aubergine outlines (theme_manager.gd:408), so this
  is Pip's call.
- s6: the red-purple sky is a hard-edged block: a sharp vertical edge near
  x 300 that runs above the windows into the ceiling.
- s2: two Enter targets on one layer (Safety Audit's "Enter" tab and the
  detail strip's "[Enter] Add to plan").

G
- s2: action rows have no space between them ("4 choices" sits flush
  against "Financing"). It is the densest action menu of the four.
- s4: the selected option shows no confirm key (A, C and E show Enter). s2:
  research blocks read "22 short" while Travel reads "27 research short".
- s4: held-hours pips are violet (--held #B39AC0) at HIGH, but the notes
  say purple appears only in s6.

Showcase
- State 3's caption could add "today's UI refuses this spill; the mock-ups
  follow the ADR", as the brief asks the notes to say.
- In a headless capture, thumbnails built by the page's script came out
  black (decoding="async"). The .webp files themselves decode fine. Check
  once in a real browser after publishing.

For later states: Strategic needs reputation_min 30 (core.json), so at
state 6 (rep 21) it is locked, and Team Building (staff_min 2) is
unlocked. C's "17 on file" in s6 still adds up to 17, but any s6 card file
must swap those two.

## People seen (for Alex's open question)
- A: STAFF plate `ui_staff_management` (three silhouettes), s1-6; Hire
  Staff folder `button_hire_normal` (head and shoulders), s2; handshake on
  Work Your Connections, s2. No event picture (s4 is text only). The desk
  photo is a cat only.
- C: Staff file `ui_staff_management`, s1-6; Hire Staff, s2; handshakes on
  Work Your Connections (s2-3) and Networking (s3). The s4 memo has a drawn
  CV, no face. The Doom Cat photo is a cat at a computer, no person.
- E: Lab Floor `ui_staff_management`, s1, s4, s6; Hire Staff, s2;
  handshakes on Work Your Connections and Networking, s3 and s5. s4 uses
  `event_opportunity_v2` cropped to the desk. I checked the full image: its
  two men at the window are cropped out, and the shape at the bottom right
  is a chair back.
- G: Staff rail `ui_staff_management`, every state; Hire Staff, s2;
  handshakes on Work Your Connections (s2-3) and Networking (s3). The s4
  records-room art shows a drawer, a lamp and a chair, with no figure.
- The office itself is empty and reads as eerie in all four, in every
  state.

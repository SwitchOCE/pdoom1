VERDICT: CHANGES NEEDED

## Scores (showcase-ready, /10; not a ranking)

A 7.5/10 . C 8/10 . E 7.5/10 . G 7.5/10

I reviewed all six states at 1920x1080 and 1280x720 for each concept, opened the showcase in Chromium, and checked the game rules in source. Each concept preserves room for the art on home, shows the plan and event in context, and keeps the office layout stable as doom rises. State 3 agrees across all four on $102,600 + 6 reputation, 7 planning hours left, 0 operating hours left, and 7 held at Commit. I saw no printed numeric doom deltas or ungated rival detail.

## Blocking items

**All four and the showcase, state 4, both sizes.** Standard Hiring is shown as $25,000 with no held-hour cost. Talent Opportunity is a WATCH window. `WindowResolver` applies the default 1 Attention to both hiring choices, and `event_dialog.gd` includes it in the displayed cost. Decline Offer is the free choice. Show $25,000 + 1 held hr for both hires, keep the Fast-Track outcome in state 5, and correct the shared fixture and state caption. [Event data](/home/alex/code/pdoom1/godot/data/events/core_events.json:47), [Event tiers](/home/alex/code/pdoom1/godot/scripts/core/event_tiers.gd:44), [Window resolver](/home/alex/code/pdoom1/godot/scripts/core/window_resolver.gd:165), [Dialog costs](/home/alex/code/pdoom1/godot/scripts/ui/event_dialog.gd:112), [Shared run state](/home/alex/code/pdoom1/fork/design/hifi/run-state.md)

### A

1. [States 1-6, 1280x720] The scaled stage breaks the agreed 16px operational text floor. In state 3, the play rows render at 12px and the row edit keys at 10.7px. Adapt the typography and spacing at 720p and recheck each state. [A concept](/home/alex/code/pdoom1/fork/design/hifi/A/concept.html:345)
2. [State 2, both sizes] The NEW clips imply November unlocks. Safety Audit unlocks at workday 5, and Strategic at workday 10 subject to 30 reputation. This fixture gives availability in November, with no unlock history to support the clips. Remove the clips or establish the claimed timing in the fixture. [A action slips](/home/alex/code/pdoom1/fork/design/hifi/A/concept.html:656), [Game unlock conditions](/home/alex/code/pdoom1/godot/data/actions/core.json:85)
3. [States 4-5, both sizes] State 4 uses 01 and 14 as feed dates. State 5 puts play numbers 01-11 and the event date 14 in the same unlabeled column, which reads as actions finishing on different days. Label the first block "1 Nov / At Commit" and give the event its own "14 Nov" date. Also show "+1 safety researcher" on both hiring options in state 4, where players compare the choices. [A WATCH and review](/home/alex/code/pdoom1/fork/design/hifi/A/concept.html:711)

### C

1. [States 1-6, 1280x720] The scaled stage shrinks Planning and Operating to 10.7px and Got it to 12px. Keep operational text at 16px at this viewport and recheck the form and memo after resizing. [C concept](/home/alex/code/pdoom1/fork/design/hifi/C/concept.html:684)
2. [State 1, both sizes] The advisor owns Esc while the background Commit stamp advertises Enter. If the note owns focus, suppress Commit's Enter. If it is a passive hint, use a visible dismiss control without an Esc shortcut. [C first screen](/home/alex/code/pdoom1/fork/design/hifi/C/concept.html:489)
3. [State 2, both sizes] The dotted empty card frames in Funds, Outreach and The Lab look like unfinished actions. Leave those positions plain. Publish Safety Paper uses the formal-verification icon, a graph with checkmarks. Use Pip's paper icon so the card reads as a publication. [C card grid](/home/alex/code/pdoom1/fork/design/hifi/C/concept.html:534), [C icon mapping](/home/alex/code/pdoom1/fork/design/hifi/C/concept.html:360)

### E

1. [States 1-6, 1280x720] The scaled stage renders Add to plan at 10.7px and state 3's hours-left labels at 12px. Bring operational text to 16px at this viewport, then recheck the card file and CRT rows. [E concept](/home/alex/code/pdoom1/fork/design/hifi/E/concept.html:718)
2. [State 2, both sizes] The focused Safety Audit card says "new this month" and Strategic is badged NEW. The gates are workdays, and the run gives no evidence of a November unlock. Drop the timing claims. Also show Enter once for the selected Audit, where the row and detail footer currently both advertise it. [E action file](/home/alex/code/pdoom1/fork/design/hifi/E/concept.html:541)
3. [State 3, both sizes] The open CRT owns Esc and the background Commit advertises Enter. Hide that background key hint while the CRT is open. The receipt headed "AFTER COMMIT" prints 26 reputation and -12 research, although WATCH immediately shows 34 and -6. Head the receipt "AFTER COSTS" and label the -12 as current research. [E plan and receipt](/home/alex/code/pdoom1/fork/design/hifi/E/concept.html:427)

### G

1. [States 1-6, 1280x720] Add to plan and Back render at 12px and Audit's price line at 10.7px. Preserve 16px operational labels at the smaller viewport and recheck list density. [G concept](/home/alex/code/pdoom1/fork/design/hifi/G/concept.html:712)
2. [State 2, both sizes] Remove the NEW chips on Audit and Strategic pending evidence of when they unlocked. [G action list](/home/alex/code/pdoom1/fork/design/hifi/G/concept.html:548)
3. [State 3, both sizes] The showcase still hides the two individual Read the Literature edit targets. The `&expand=read` rendering shows both, but adds a group row and pushes Order Office Supplies, the row marked with the spill, below the scroll fold. In the state 3 still, use two individual rows in place of the group so all eleven plays and their edit targets can be seen together. [G plan drawer](/home/alex/code/pdoom1/fork/design/hifi/G/concept.html:581)
4. [State 3, both sizes] "Reserve (needs operating hours)" presents the current HUD restriction as a rule. ADR-0011 and `MonthPlan.set_reserve()` explicitly allow untyped reserve from all unspent capacity. Show the same untyped reserve as the other concepts and document the current HUD discrepancy in the notes. [G Attention card](/home/alex/code/pdoom1/fork/design/hifi/G/concept.html:484), [Reserve implementation](/home/alex/code/pdoom1/godot/scripts/core/month_plan.gd:226)

### Showcase page (index.html)

1. [All lightbox states, both sizes] The image extends below the viewport. With A state 3 open, Chromium measured the bottom at y=1114 in a 1080px viewport and y=754 in a 720px viewport. The grid track sizes to the intrinsic image height. Constrain the stage and fit the image to the space below the header so Pip can see the bottom controls. [Lightbox styles](/home/alex/code/pdoom1/fork/design/hifi/index.html:52)
2. [All grid views, both sizes] Thumbnails are click-only images with `tabIndex=-1`. Use named buttons or links, move focus into the lightbox, and return focus to the thumbnail on close. Preserve focus on the selected view or state when rebuilding the controls. [Thumbnail and view code](/home/alex/code/pdoom1/fork/design/hifi/index.html:104)
3. [One concept, both sizes] "Interactive version" opens a single HTML mockup with simulated controls and no state navigation. Label it "HTML mockup" so expectations match. Check that the already-linked run report ships with the final package. [Concept view and footer](/home/alex/code/pdoom1/fork/design/hifi/index.html:138)

## Non-blocking (at most 3 per concept)

- A and C, state 5. "20 fresh decisions" matches the current review copy. "20 fresh hours" would match the units used by the plan and event.
- C and E, state 6. The sky layers and same-position controls carry the transition. The brightest violet monitor pools compete for attention at this scale. One dominant glow with dim secondary screens would land closer to Pip's lighting discipline. [Palette specification](/home/alex/code/pdoom1/docs/art/PALETTE_AND_DOOM_INTENSITY.md)
- G, state 5. The review stays compact. The feed says "+ 8 more lines from November" without naming where to find them. A destination label would help if the feed is meant to lead to a full history.

## People seen (for Alex's open question)

- No operator silhouette or person in any rendered office. No person in the WATCH art. A uses a text slip, C a portrait-free CV, E a desk crop of the Opportunity art, and G an empty chair and filing drawer.
- Pip's three-person Staff glyph is visible in A states 1, 3-6, C states 1, 4 and 6, E's Lab Floor in states 1, 4 and 6, and G states 1-6. Pip's head-and-shoulders Hire Staff glyph appears in state 2 of all four. [Staff icon](/home/alex/code/pdoom1/godot/assets/icons/main_navigation/ui_staff_management_64.png), [Hire icon](/home/alex/code/pdoom1/godot/assets/icons/buttons_normal/button_hire_normal_64.png)

VERDICT: SHORTLIST A C E

I accept A, C and E, in that order. A makes the strongest case for an office with computers under mounting pressure. C replaces B on my shortlist because the same form carries the plan through execution and month close, giving Alex a genuinely different workflow to compare. E is the best test of separate stations and still belongs in the shortlist. I accept F ahead of B for Pip's terminal direction, despite B's stronger queue controls. This is a static review of the renders, prototype source and game code. [Opus review](C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r1-opus.md) [Neon review](C:/Users/keech/Documents/pdoom1-lean-setup/research/council/concepts/r1-neon.md)

## Source rulings

- **Work Your Connections costs 2 operating hours and 6 reputation.** Opus is right. `use_connections()` spends Attention without a type argument, which defaults to operating. Zero planning hours alone cannot block it. **Onboard New Hires also spends operating hours.** The applicable step sets the time and cash costs, and the top-level action can advance more than one eligible hire. Use "Varies by step" when there is no applicable step to price, with the actual reason for unavailability. One employee alone establishes neither that onboarding is pending nor that it is complete. [Connections](C:/Users/keech/Documents/pdoom1/godot/scripts/core/hiring_pipeline.gd:135) [Onboarding costs](C:/Users/keech/Documents/pdoom1/godot/scripts/core/hiring_pipeline.gd:420) [Onboarding payment](C:/Users/keech/Documents/pdoom1/godot/scripts/core/hiring_pipeline.gd:554) [Onboard All](C:/Users/keech/Documents/pdoom1/godot/scripts/core/hiring_pipeline.gd:943) [Attention](C:/Users/keech/Documents/pdoom1/godot/scripts/core/month_plan.gd:252)
- **C's Strategic door should open.** Neon is right for the pictured balances. Corporate Espionage is $100,000, 3 operating hours and 20 reputation, against the pictured $140,000, 5 available operating hours and 32 reputation. The live selector checks current resources and typed hours. Show each option's cost and actual blocker in the door after correcting the fixture. The generic "None affordable" stamp is wrong for the displayed state. [Strategic actions](C:/Users/keech/Documents/pdoom1/godot/data/actions/strategic.json:16) [Selection checks](C:/Users/keech/Documents/pdoom1/godot/scripts/ui/submenu_controller.gd:138) [Resources](C:/Users/keech/Documents/pdoom1/godot/scripts/core/game_state.gd:527)
- **WATCH event timing and payment.** Stray Cat is exact workday 7, which is July 12 on the standard July 3 start. Talent Opportunity can be eligible in November from workday 5 subject to its normal roll and cooldown. The Keynote Slot requires reputation of at least 40, so E's pictured 32 does not qualify. For these legacy WATCH windows, handling a paid reply uses the window's default one hour of Attention, with reserve first. The free exit uses none. Thus both paid Talent Opportunity replies and both paid cat replies need the one-hour charge shown. The reserve is untyped. [Clock](C:/Users/keech/Documents/pdoom1/godot/scripts/core/clock.gd:76) [Start date](C:/Users/keech/Documents/pdoom1/godot/scripts/core/game_state.gd:222) [Stray Cat](C:/Users/keech/Documents/pdoom1/godot/data/events/core_events.json:413) [Talent Opportunity](C:/Users/keech/Documents/pdoom1/godot/data/events/core_events.json:47) [Keynote](C:/Users/keech/Documents/pdoom1/godot/data/events/core_events.json:1213) [Window presentation](C:/Users/keech/Documents/pdoom1/godot/scripts/core/window_resolver.gd:275) [Reserve](C:/Users/keech/Documents/pdoom1/godot/scripts/core/month_plan.gd:226)
- **WATCH counters should come from the pictured state.** A and E should replace stale figures. The suggested exact cash and reputation replacements are insufficiently grounded. The game executes the queued batch and publishes balances before playback. E also has a reputation gain from Go to Meetups, so subtracting only the Connections cost does not justify 26. Use counters, statuses and dated feed lines from one coherent fixture. [Commit and playback](C:/Users/keech/Documents/pdoom1/godot/scripts/game_manager.gd:710) [Meetups](C:/Users/keech/Documents/pdoom1/godot/scripts/core/actions.gd:527)

## Disposition of both fix lists

### A. The Desk

- **Opus 1 and Neon 5.** Agree on showing typed and visible costs. Use 2 operating hours + 6 reputation for Connections, and use variable operating-hour and cash pricing for Onboard. Keep July's "Nobody hired" reason.
- **Opus 2.** Disagree with requiring the operator in A's July and November PLAN. Pip's build brief locates the core silhouette in WATCH, and A's first-person desk makes the swivel meaningful. Keep the WATCH silhouette. Replacing the placeholder art is polish. [Build brief](C:/Users/keech/Documents/pdoom1/docs/game-design/BUILD_BRIEF_PLAN_WATCH_UI.md)
- **Opus 3 and 4.** Agree on giving the November Gantt dates their own lane. The WATCH choice costs already have a 16px CSS rule, so keep that size and improve readability through the layout when correcting the missing price. [A HTML](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/concept.html:270)
- **Opus 5 and Neon 7.** Agree on an eligible event and reconciled WATCH counters. Use Talent Opportunity in November, or date the cat to its eligible July workday with a corresponding state. Derive the counters from that state.
- **Opus 6 and 7.** Agree on a clear Ledger entry, removing the duplicate UPGRADES label at the drawer foot, and fitting the Scouting detail sheet to its content. Avoid promising a clean ledger from the mock-up's balances alone.
- **Neon 1 and 3.** Agree on per-play reorder and removal, plus the existing Undo/Clear controls. Derive the badges from the corrected queue in a single unit, including the seven Scouting plays shown across three action types.
- **Neon 2, 4 and 6.** Agree on a sixth July calendar row, 16px operational labels and a soft WATCH glow with no visible rectangle. The HTML stops at 35 cells, so changing height alone cannot recover July 30 and 31. Apply the 16px rule to text needed for a decision or operation. [A calendar source](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/concept.html:394)

### C. The Paperwork Desk

- **Opus 1.** Agree. The original 12 planning and 3 operating hours become 10 planning and 5 operating when only Connections is retyped. Then rebuild the fixture to use all planning hours with operating hours left.
- **Opus 2 and Neon 6.** Agree with Opus's type and blocker correction. Add the variable operating-hour and cash label in both months. A fixed "1 plan hr + money" is incorrect in either view.
- **Opus 3 and 4, Neon 5.** Agree on giving NO. and ORDER distinct columns, adding clearance between Gantt dates and the grid, and putting counts in a reserved corner away from the title and stamps. Either corner works if it is consistent and has enough width.
- **Opus 5, Neon 1 and 4.** Move the paperclip clear of the stamp and raise operational card and form text to 16px. The WATCH choice-cost rule is already 16px. Correct the missing hour on Standard Hiring and leave enough space for the longer price. [C choice styling](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/concept.html:249)
- **Opus 6, Neon 2 and 3.** Agree. Add "RISING" at 40.2%, remove the constant rule sentence from the instrument face and replace the Strategic stamp with real option states.
- **Opus 7 and Neon 7.** Keep the existing WATCH and ledger compositions. The redundant office vignette can be folded away during the look-up without adding any content. Upgrading the silhouette art and drawing extra Staff or Upgrades views are non-blocking. Document those routes, since the October ledger already supplies the alternate view.

### E. Rooms and Stations

- **Opus 1 and 2, Neon 1.** Agree on correcting Connections and redoing the full fixture. The printed 11 planning and 3 operating hours become 9 and 5 when Connections is retyped. Adding just one planning hour cannot fix it. Recalculate the cash and reputation totals from the final rows, including any actual quote or bill.
- **Opus 3 and 7, Neon 4.** Agree on one aligned action affordance per row and a visible link from OPEN to its right-hand folder. Keep the parent door inspectable. Put no-planning-hours reasons on the unaffordable role choices in the brief's role fixture, or summarise that situation on the parent without disabling inspection. Onboard is operating with variable costs.
- **Opus 4 and Neon 2.** Add the missing "RISING" and 100 endpoint. The overlap in the Desk views reaches the CRT bezel only. Keep it if the gauge reads clearly as mounted hardware, or seat it fully in the frame if the two edges look accidentally crossed.
- **Opus 5 and Neon 3.** Agree on an eligible memo, current WATCH counters, one untyped held readout and real window costs. Deemphasising the locked rack is useful composition work. Replacing it with a new camera or expanded feed is non-blocking.
- **Opus 6 and Neon 5.** Lab Floor already satisfies the required alternate-place render. Describe the existing Procurement, Records and return routes. Additional renders and major Lab Floor enrichment are non-blocking. Align the floating staff label with the associated sprite in the existing view. [Designer brief](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/brief.md:45)

Only the assigned consensus answer was written. No scratch files were created.

## Proposed joint answer

**Ranking**

1. A. The Desk. 2. C. The Paperwork Desk. 3. E. Rooms and Stations. 4. F. Pure Terminal. 5. B. The Mainframe OS. 6. D. The Card Table.

**Shortlist**

A, C, E. A offers the strongest office-and-CRT synthesis. C offers the clearest paper workflow through month review. E offers meaningful room changes with a stable frame. F's terminal hierarchy and queue editing need work, B's generic desktop and sparse WATCH weaken its sense of place, and D's invalid queued plays and inaccessible stack require more correction.

### A. The Desk

1. **July calendar and both action racks.** Render all six July rows. Keep the existing action groups spatially stable between months. Show Connections as 2 operating hours + 6 reputation, give Onboard a variable operating-hour and cash label, and raise decision-critical stamps, counts and key hints to 16px.
2. **November CRT and Scouting door.** Show per-play reorder/remove, including the repeated plays, plus Undo/Clear. Give Pay the Bill its payable amount or substitute a valid action. Derive queue totals and badges from the final plays. Give the Gantt dates clear space, keep the plan and readouts legible with a folder open, compact the detail sheet, and give Enter one active target.
3. **Drawer and WATCH.** Give the Ledger divider a clear destination and remove the duplicate Upgrades label. Match the WATCH event to an eligible state, print the actual reply prices and draw the counters from the same state. Soften the rectangle behind the operator. [A July](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/m1.png) [A November](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/m5.png) [A door](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/door.png) [A drawer](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/place2.png) [A WATCH](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/watch.png)

### C. The Paperwork Desk

1. **People tray and November form.** Correct Connections and Onboard to operating costs and remove their false planning blockers. Use actual prices for any lease or bill in the plan. Rebuild rows, totals, hours and badges together to produce zero free planning and positive free operating hours. Keep Strategic open with costed child choices.
2. **Both PLAN forms and the Scouting door.** Separate NO. and ORDER, give dates clearance from the Gantt rule, reserve a consistent badge position, and give key controls and blocker text 16px with enough contrast. Put "RISING" beside November's 40.2%.
3. **WATCH memo and October ledger.** Move the paperclip, show the one-hour window price for both paid hiring replies, and make it clear an open memo must be answered before playback resumes. Fold away the duplicate office vignette when the full office is visible. Preserve the ledger's look-back and return. [C July](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/m1.png) [C November](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/m5.png) [C door](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/door.png) [C WATCH](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/watch.png) [C ledger](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/place2.png)

### E. Rooms and Stations

1. **November CRT and time card.** Correct Connections and its blocker, show real quote and bill prices or use attainable alternatives, and derive the cash, reputation and Attention totals from a single valid queue. Show "RISING" and label both ends of the reputation gauge.
2. **July/November action rack and Lab Floor.** Give direct action rows an aligned Add affordance and label Onboard with its variable operating-hour and cash costs. Keep doors inspectable with priced choices and truthful blockers, including Hire Staff's plan-hour role choices, and tie the inset OPEN marker to the folder it opens. Add breathing room below Strategic. Align the worker label with its sprite and describe the existing F3/F4 and return routes. Keep Commit in its existing position across PLAN stations.
3. **November WATCH.** Replace the ineligible keynote, synchronise counters and feed with the pictured run state, and show untyped held Attention in one place. Use actual window presentation prices and keep the reply clear of the monitor. [E July](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/m1.png) [E November](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/m5.png) [E Lab Floor](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/place2.png) [E WATCH](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/watch.png)

**Non-blocking**

New station or drawer renders beyond the required alternate view, replacing placeholder operator art, larger WATCH composition changes, and any hybrid between concepts.

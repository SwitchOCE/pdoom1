VERDICT: CHANGES NEEDED

## Single-member findings

- **A rack rail. agree, blocking.** In m1 and m5 the rail is painted after the cards, starting 154px into a 164px card. The blocker-stamp border reaches 156px, and the add/open controls also reach into the rail. Keep their full bounds above the rail on both tiers. [November render](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/m5.png) [Card and rail source](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/concept.html:565)
- **E Scouting badges. agree, non-blocking.** The November door badges only Go to Meetups. The plan alongside it already shows Read the Literature x8 and Post Online x3, and the missing badges make no false count claim. Matching badges derived from the queue would improve consistency. [November render](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/m5.png) [Door source](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/concept.html:425)
- **E Onboard blocker. agree, blocking.** In the November rack, the HTML selects "no hires to onboard" from `S.staff` alone. The live roster checks each employee's onboarding and mentoring status. Give the fixture an explicit eligibility value and use it to choose the real blocker. The visible copy can stay if the fixture has no eligible hire. [Rack source](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/concept.html:315) [Live roster check](C:/Users/keech/Documents/pdoom1/godot/scripts/ui/hiring_panel_controller.gd:139)

## Joint blocking list

### A. The Desk

1. July and November rack. Separate the rails from the blocker stamps and add/open controls.
2. November WATCH. Mark all 13 queued plays done on Nov 1 and date their batch results accordingly. Keep the Talent Opportunity memo on Nov 14 and retain the counters from the completed batch. Show 22 for the underlying reputation of 21.5. [WATCH render](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/watch.png) [Commit sequence](C:/Users/keech/Documents/pdoom1/godot/scripts/game_manager.gd:710) [Scalar rounding](C:/Users/keech/Documents/pdoom1/godot/autoload/game_config.gd:656)

### C. The Paperwork Desk

1. November WATCH. Show 24 for the underlying reputation of 23.5. [WATCH render](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/watch.png) [HUD formatter](C:/Users/keech/Documents/pdoom1/godot/scripts/ui/main_ui.gd:1151)

### E. Rooms and Stations

1. November rack. Base the Onboard blocker on explicit fixture eligibility.
2. November WATCH. Remove the "OPS 5 left" availability claim. Show the five hours once as untyped held Attention. If the typed rows stay visible, label what was spent. [WATCH render](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/watch.png) [Reserve accounting](C:/Users/keech/Documents/pdoom1/godot/scripts/core/month_plan.gd:216)

Only the assigned consensus file was written. No scratch files.

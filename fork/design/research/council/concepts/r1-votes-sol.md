# Round 1 vote (Sol)

I confirm the shortlist A, C, E and the ranking A, C, E, F, B, D.

| Open item | My vote | Accept the majority? |
| --- | --- | --- |
| 1. A door dimmer | Blocking. The queue and instruments must stay legible in the open Scouting view. A lighter dimmer is one way to achieve it. | Yes |
| 2. WATCH counters | Use one coherent fixture for each WATCH view. | No. Hard-coding the proposed cash and reputation values is blocking for me. See below. |
| 3. A operator in PLAN | Non-blocking. The first-person desk works and the swivel reveals the operator in WATCH. | Yes |
| 4. A WATCH silhouette art | Non-blocking. Keep the silhouette and fix the hard-edged glow. Final art can follow. | Yes |
| 5. C doom label | Blocking. Replace the permanent "lose at 100%" text with "RISING" in November. | Yes |
| 6. C reorder targets | Blocking. Give the 22px up/down targets more space. A 26px target works as a design choice. | Yes |
| 7. C silhouette art | Non-blocking. The current silhouette conveys the role in both shown views. | Yes |
| 8. E held hours | Untyped. Show "Held for events: 5 hr" once, sourced from the reserve. | Yes |
| 9. E locked WATCH rack | Non-blocking. Deemphasise it if needed for the memo. Replacing it with a live view is optional. | Yes |
| 10. E extra station renders | Non-blocking. Lab Floor fulfils the alternate-place requirement. | Yes |

**Item 2.** The game executes the queued batch and publishes the resulting state before WATCH playback. The proposed $79,700 subtracts two displayed completions from $140,000 and leaves the rest of the plan unaccounted for. E's proposed reputation of 26 also misses the reputation gain from Go to Meetups. Accept exact figures once the same fixture supports the counters, queue outcomes and feed. [Commit path](C:/Users/keech/Documents/pdoom1/godot/scripts/game_manager.gd:710) [Meetups effect](C:/Users/keech/Documents/pdoom1/godot/scripts/core/actions.gd:527)

**Item 8.** `KIND_RESERVE` maps to the operating family, but reserve accounting has its own untyped balance. `set_reserve()` explicitly allows it to exceed the operating pool, and `pay_from_reserve()` updates `reserve_used` without booking to `hours_spent`. [Family map](C:/Users/keech/Documents/pdoom1/godot/scripts/core/month_plan.gd:78) [Reserve accounting](C:/Users/keech/Documents/pdoom1/godot/scripts/core/month_plan.gd:226) [Payment](C:/Users/keech/Documents/pdoom1/godot/scripts/core/month_plan.gd:339)

**Merged lists confirmed with three wording corrections.**

- A4/C5 should say to verify the 16px floor. Both WATCH choices already declare 16px cost text. Preserve that size and fit the full corrected prices. [A choice CSS](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/A/concept.html:270) [C choice CSS](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/C/concept.html:249)
- E1 should say the rows sum to 11 planning **hours** before correction. Retyping Connections gives 9 planning and 5 operating hours before rebuilding the fixture. [E queue](C:/Users/keech/Documents/pdoom1-lean-setup/research/concepts/E/concept.html:344)
- In the shared event rule and E4, apply the one-hour default to the proposed legacy windows. If a different event is chosen, use its configured window cost and actual free-exit state. [Window costs](C:/Users/keech/Documents/pdoom1/godot/scripts/core/window_resolver.gd:22)

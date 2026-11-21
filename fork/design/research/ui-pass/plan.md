# Plan: first game-UI pass on the PLAN screen (revision 2, not approved)

Written by Claude (orchestrator), 2026-11-21. Revised after a plan interrogation by a fresh agent. Every step is the orchestrator's proposal unless it quotes Alex.

## Alex's words

> "the issues with the game as I currently see them, which are mainly twofold: tutorialization and user interface. Tutorialization is going to be locked behind the user interface work to a large degree."

> "Second, we need to start the UI from first principles. What needs to be shown? What is most important, etc."

> "Commit the skills. Yeah, make the general parts global and start with a game UI pass. Use the council, get the council to agree that it's. I'm not sure what the best bar is. I'm not as familiar with this genre as Pip is. I don't know what excellent examples of comparisons for other good games that have done the UI really well. Highly reviewed, incredibly well received games in similar genres. ... We're not going to change the main gameplay loop. We are going to develop a tutorial that teaches people how these things work. It will be a separate gameplay mode. But that will still come after the UI redesign"

> "You probably won't find games where the UI is praised specifically. You'll just find games people like. People don't think about UI when it's good They just take it for granted"

## Steps

1. **Critique of today's PLAN screen (done, checkpoint).** Decisions, tier sort, glance count, findings, at month 1 and month 5, built on Pip's FRESH_EYES teardown. research/ui-pass/critique.md. Alex sees it before any mock-up.
2. **Reference games (running).** Shortlist of well-loved, structurally close games with screenshots and a draft bar. research/reference-games/.
3. **Council agrees the bar** (Opus, Sol, Neon; same delegates). Inputs: the shortlist, Pip's own named references (WORKSHOP_2_BACKLOG.md:688-712: Civ and XCOM two-screen modes, "deal the cards from the hand you've got", Euchre/Warhammer pre-commit, MTGO transitions). The bar names one or two targeted outcomes (proposed: a new player can tell what they can do and what to do next, the playtest complaint), the rest as checks. Score the critique against it.
4. **Mock-up**: static HTML at 1920x1080, game palette, today's top-level actions only (no door merges: those are Pip's). One layout in two views (first month with a "point here" marker only, no lesson content; returning player), unless Alex asks for two alternative layouts. Side by side with the reference shots.
5. **One council round** on the mock-up; findings shown to Alex with it. The full consensus loop waits for Alex's direction.
6. **Alex reacts.** Building in Godot is a later, separately approved plan.

## Out of scope for this pass

WATCH, the month review and other screens; the tutorial mode and lesson content (Alex: after the UI redesign); door merges and any change to actions, data or mechanics; any Godot code.

## Open questions for Alex

1. One layout shown in two views, or two alternative layouts to compare?
2. Research Quality: draw it where it is today, or where Pip ruled it goes (#1090, project level)?
3. The PLAN screen's content design is Pip's reserved workshop item (#1043, UI_ARCHITECTURE_2026-08-06.md:313). Send the mock-up to Pip as input to #1043 before building in the fork?
4. Pip's teardown calls the banner sentence ("lay out the month, then COMMIT THE MONTH") what makes the loop self-teaching; your rule says teaching text belongs to the tutorial. Keep a short mode label on the main screen and move the sentence to the tutorial?

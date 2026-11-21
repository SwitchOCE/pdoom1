# Fresh council: the PLAN-screen mock-up and its direction

You are one of three council members (Claude Opus, GPT Sol, Gemini Neon). You have not seen any earlier review of this work; that is on purpose. Read-only: do not edit any file in C:/Users/keech/Documents/pdoom1 or C:/Users/keech/Documents/pdoom1-lean-setup. Scratch copies elsewhere are fine.

## Background

P(Doom)1 is Pip Foweraker's Godot game (AI-safety lab management; one turn = one month; PLAN then WATCH). Alex runs a fork that may change only UI, tutorial and bug fixes, never mechanics (C:/Users/keech/Documents/pdoom1/AGENTS.md section 1). Claude (the orchestrator) made a static HTML mock-up of a redesigned PLAN screen and showed it to Alex. Alex is not happy with it.

## Alex's words (quoted, the reason for this review)

> "How does this compare to what Pip's mock-ups looked like? Did he have any mock-ups? Do you have screenshots of his existing ones? What I don't like is I feel the icons no longer match the buttons, right? And the layout on the icons is very inconsistent. Some are centralized and some are left-aligned. I'm not quite sure what's going on there and how that wasn't pointed out. Font sizing and stuff, there's stuff overlaying specific elements and overflowing out of areas of the screen. I'm not extremely impressed with this. I would say that I would want a fresh council to take a look at this because it still has a lot of issues. Some things have very much improved. I agree. But all of the flavor from the diegetic aspects are lost. Done in a smart way, the diegetic aspect could be recaptured. It may need to be a longer process that's, you know, with more screens and more flows rather than one control board. You have different aspects that you go to, and you know, parts of the thing change. But I don't think pip would be happy with this. And I don't think I am either"

Earlier, Alex on the goal: "start the UI from first principles. What needs to be shown? What is most important" and "putting up something to hate, like doing our best job of at least making a step forward ... just so we get towards something that is more user-friendly". Alex's rule (from his Bramble notes): the main screen serves the hundredth game, not the first; teaching text belongs to the tutorial. A separate tutorial mode will come after the UI redesign.

## What to look at

The mock-up (look at every image at full size):
- C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/mockups/view-first.png (month 1 with a tutorial marker)
- C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/mockups/view-returning.png (month 1, no marker)
- C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/mockups/view-m5.png (month 5, Upgrades open)
- Source: C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/mockups/plan.html (render with ?view=first|returning|m5 at 1920x1080 if you can)

Today's game, same states (scratchpad = C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/1475796a-3fb6-4331-a9c6-354740c87b80/scratchpad/shots/):
- main.png (month 1), m5_plan_queued.png (month 5), m1_event1.png (WATCH with an event), prop_m4_plan_queued.png (Pip's own hidden "proposed" layout, F9 in debug builds)

Pip's design intent (read with git from C:/Users/keech/Documents/pdoom1; some files are hidden by sparse checkout):
- `git show HEAD:docs/game-design/BUILD_BRIEF_PLAN_WATCH_UI.md` (the two-screen model, "deal the cards from the hand you've got", the silhouetted operator, terminal/mainframe pastiche, office floor, phase scaling)
- docs/game-design/WORKSHOP_2_BACKLOG.md lines 685-780 (Plan/Watch workshop beats 1-4: "the silhouetted operator ... is the CORE UI image -- never lose it", office as phase visual: garage -> warehouse -> startup office -> gilded office -> lair, earned instrumentation)
- `git show HEAD:docs/game-design/UI_PASS_NOTES_2026-07-20.md` (Pip's own play notes: the ABBBCCC menus that open out from a button, left-bound buttons, coloured zones, no permanent screen-purpose text)
- `git show HEAD:docs/game-design/UI_PROPOSALS_2026-07-22.md` (drift between intent and build)
- docs/game-design/DESIGN_PHILOSOPHY.md, docs/art/PALETTE_AND_DOOM_INTENSITY.md, godot/UI_STYLE_GUIDE.md
- Pip's art: godot/assets/images/backgrounds/ (office_wide_dawn.webp, office_wide_day.webp, office_lab_aisle.webp, office_mezzanine.webp, office_scene.png), godot/assets/images/office_cat.png, godot/assets/images/characters/, and the action icons in godot/assets/icons/ (mapping: godot/data/icon_mapping.json)
- Pip's July ASCII mock-ups are not in the repo; only the descriptions above survive.

Context, not binding: the previous council's bar for this screen, C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/bar.md; the critique of today's screen, research/ui-pass/critique.md; reference games, research/reference-games/shortlist.md and shots/. The fork's UI skill: C:/Users/keech/Documents/pdoom1/.claude/skills/game-ui/SKILL.md.

## Questions

1. **Visual defects.** List every visual defect you can see in the three renders: alignment (centred vs left), icons that do not match their card or button, inconsistent font sizes, text overlapping other elements, overflow out of its area, cramped or clipped text, inconsistent spacing. One line each, with the view and the screen location.
2. **Why it reads as a generic dashboard.** What of Pip's diegetic flavour (operator, desk, terminal pastiche, office, cat, things arriving across your desk, the office changing with the phase) is lost compared with today's game and Pip's intent?
3. **A better direction.** Alex suggests "more screens and more flows rather than one control board ... different aspects that you go to, and parts of the thing change". Propose a direction for PLAN (and how it hands over to WATCH) that keeps the gains (named actions with costs, one Attention readout, one Commit, the plan as the main thing, no permanent teaching text) and recaptures the diegetic flavour using the art that exists. Say which screens or places the player moves between, what each is for, and what stays constant. Stay inside the fork's scope: no mechanics changes, no hiding or merging actions in a normal run.
4. **What would Pip object to**, citing his own docs.

## Answer format

First line `VERDICT: REWORK` or `VERDICT: FIX AND KEEP`. Then the defect list, then sections 2-4. Keep it under about 900 words plus the defect list.

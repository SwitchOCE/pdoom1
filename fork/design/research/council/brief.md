# Council brief: three design skills for P(Doom)1 (round 1)

Read-only review. Do not edit any file in C:/Users/keech/Documents/pdoom1 or C:/Users/keech/Documents/Bramble.

## What is under review

Three new skill files, written by Claude (the orchestrator), not yet committed:

- C:/Users/keech/Documents/pdoom1/.claude/skills/game-ui/SKILL.md
- C:/Users/keech/Documents/pdoom1/.claude/skills/game-tutorial/SKILL.md
- C:/Users/keech/Documents/pdoom1/.claude/skills/ux-copy/SKILL.md

They will guide agents doing UI and tutorial work on Alex's fork of Pip Foweraker's game P(Doom)1 (Godot, AI-safety lab management, turn = one month, PLAN then WATCH). Fork rules: C:/Users/keech/Documents/pdoom1/AGENTS.md (read section 1, scope).

## The owner's (Alex's) own words

> "What I want you to do is to firstly go out and understand the game and the issues with the game as I currently see them, which are mainly twofold: tutorialization and user interface. Tutorialization is going to be locked behind the user interface work to a large degree. However, user interface design should consider tutorialization and the principles of tutorialization first, or rather, not first during design."

> "The first step is to have Gemini Neon get this YouTube video and transcribe it and get the key findings from the video that rely on any visual evidence for concrete bars. https://www.youtube.com/watch?v=-GV814cWiAw This video is the kind of template that we need to follow, or rather, indicates the methodologies that we need to follow when developing a tutorial for a complicated game."

> "Second, we need to start the UI from first principles. What needs to be shown? What is most important, etc. Look at some of the game design skills from my Bramble repo, including the design skills as they pertain to user interface. There will be some modifications from the Bramble repo that pertain only to that game. However, insofar as generalized findings can be pulled from that repo, do so. Have the council review the skills that have been generated as a result of that using the council skill"

## Sources the skills were built from

- Video findings and transcript (by Gemini Neon): C:/Users/keech/Documents/pdoom1-lean-setup/research/tutorial-video/findings.md and transcript.md
- Bramble skills: C:/Users/keech/Documents/Bramble/.claude/skills/ (design-critique, design-system, accessibility-review, ux-copy, game-design-process, README.md)
- Bramble owner notes used: C:/Users/keech/Documents/Bramble/docs/design/sources/2026-11-09e-ui-clutter-and-tutorials.md, 2026-11-09f-visual-comparison-and-reference-tribe.md, 2026-11-09i-few-evaluation-criteria.md; C:/Users/keech/Documents/Bramble/docs/AGENT-BLIND-SPOTS.md
- P(Doom)1 rules: docs/game-design/decisions/ADR-0001, 0004, 0012, 0015, 0018; docs/game-design/DESIGN_PHILOSOPHY.md; docs/game-design/ONBOARDING_STORY_DESIGN.md; godot/UI_STYLE_GUIDE.md; docs/design/NAVIGATION_AUDIT.md; docs/game-design/UI_ESCAPE_CONTRACT.md (all under C:/Users/keech/Documents/pdoom1)
- A screenshot of the current PLAN screen, turn 1, 1920x1080: C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/1475796a-3fb6-4331-a9c6-354740c87b80/scratchpad/shots/main.png

## Questions

1. Do the skills carry over what generalises from Bramble, and leave out what is Bramble-only?
2. Does game-tutorial represent the video's methods and bars faithfully (check against findings.md; spot-check timestamps against the transcript)?
3. Are the P(Doom)1 facts and constraints right (check the cited files and code)? Anything a skill tells an agent to do that would break AGENTS.md section 1 (no mechanics changes) or an ADR?
4. Would an agent following these skills produce a UI that serves both the experienced player and a tutorial (Alex's two concerns)?
5. Anything missing that is needed, or present that is not needed? Keep scope to what Alex asked: mark anything outside it as non-blocking.

## Answer format

First line: `VERDICT: GOOD TO GO` or `VERDICT: CHANGES NEEDED`.
Then blocking items, each with evidence (file:line or quote) and a concrete fix.
Then at most 3 non-blocking notes.
Then a score out of 10.

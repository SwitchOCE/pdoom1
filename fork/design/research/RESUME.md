# RESUME: P(Doom)1 UI and tutorial work (paused 2026-11-21)

Paused at Alex's request ("pause work safely with resumes"). Nothing in the game has changed yet: all work so far is research, skills and mock-ups. The problem that started it (the UI and tutorial make the game hard to learn) is not fixed.

## Alex's goal, in his words

> "the issues with the game as I currently see them, which are mainly twofold: tutorialization and user interface. Tutorialization is going to be locked behind the user interface work to a large degree."
> "we need to start the UI from first principles. What needs to be shown? What is most important"
> "putting up something to hate, like doing our best job of at least making a step forward"
> Tutorial: "It will be a separate gameplay mode. But that will still come after the UI redesign."

## Done

- Fork skills, committed on `lean` (e1c58e55, pushed): `.claude/skills/game-ui`, `game-tutorial`, `ux-copy` (council passed, 3 rounds). Sparse patterns now keep `/.claude/skills/`.
- Global skills in ~/.claude (claude-setup repo 159d257, pushed): `game-ui-design`, `game-tutorial-design`, `game-text`.
- Tutorial video research (GMTK, by Gemini Neon): research/tutorial-video/.
- Critique of today's PLAN screen and the first (rejected) mock-up: research/ui-pass/ (critique.md, bar.md, plan.md, mockups/). Alex rejected that mock-up: visual defects and lost diegetic flavour.
- Today's game screenshots (month 1, months 1-6, WATCH events, Pip's hidden "proposed" layout) and the throwaway Godot capture scripts: research/ui-pass/game-shots/ (copied from the session scratchpad, which may be wiped; briefs that cite the scratchpad path mean this folder).
- Reference games (7 well-loved, structurally close; 19 shots): research/reference-games/.
- Diegetic UI research (25 games, 10 deep dives, 12 patterns, 10 pitfalls; 20 shots): research/diegetic/findings.md.
- Fresh-council reviews of the rejected mock-up: research/council/fresh/ (opus.md, neon.md; Sol failed at capacity).
- Concepts round 1 (six concepts A-F by six designers; council ranked A, C, E, F, B, D; A, C, E passed Alex's gallery check): research/concepts/ (compare.png, gallery.html, report.md).

## Concepts: Rounds 2 and 3 DONE (2026-11-21)

Results in research/concepts/report.md (sections "Round 2" and "Round 3"). All four concepts (A, C, E, G) stay in contention; ranking E, A, C, G. Round 2: all four passed Alex's gallery bar (belongs, at least average). Round 3: silhouette removed (empty office), Pip's icons used (21-32 per concept, new ones marked "needs art"); all three members passed all four (A 8.5/9/9.5, C 8/8.5/9, E 8.5/9/9.5, G 8/8/8.5 for Opus/Sol/Neon). Before/after: concepts/round3-before-after.png. Child orchestrator thread (for any further round): [Concepts orchestrator](t3-thread://v2/72b5bc42-56a2-487a-a5c4-891b63d4c383/thread:delegated-task:command%3Amcp%3A1360b6f5-f921-40e1-a210-e1efbec1d4b0%3Adelegate-task%3A09518100-e85a-4ede-9e30-0c18d02cd3f5); its designer/council thread ids are in concepts/RESUME.md.

Open question from the council for Alex: do people in event pictures (C's memo portrait, E's memo art) and Pip's Staff (three silhouettes) and Hire (head and shoulders) icons count as "the person"?

For Pip: several of the game's icon assignments show the wrong thing (globe-and-handshake on Travel, emergency stop on Strategic); see report.md Round 3. Possible bug (unconfirmed): Hire Compute Engineer may skip the desk-cap check (godot/scripts/core/actions.gd ~400-409).

## Decisions waiting for Alex

1. Which concept to take forward (after Round 2), and whether to merge (the council floated C's printed ledger inside A).
2. Operator silhouette art: DECIDED by Alex 2026-11-21: remove the person/silhouette; the empty office is eerier, which is the game's vibe; leave the space (use decided later). Note: Pip's build brief called the silhouetted operator the core UI image, so flag this when it goes to Pip. Round 3 (queued with the concepts orchestrator): remove the silhouette and use Pip's icons from godot/assets/icons/.
3. How much office art shows on PLAN versus WATCH.
4. Fixing the UI pre-check that refuses an operating action when operating hours run out (the game allows spill into planning hours). Changes runs: needs Alex's OK and a `Ladder-Impact: bump` line.
5. Research Quality: keep on PLAN or follow Pip's ruling #1090 (project level).

## Bugs found on the way (for the backlog; not fixed)

- HUD "Turn N" counts workdays, not months; the first-run hint gate `turn < 3` likely ends after month 1.
- Errors print raw ids ("Cannot afford action: safety_research").
- A milestone popup ("Strategic moves unlocked") opens over an open submenu.
- Scouting submenu shows missing-texture icons.
- Research can go negative (-12) with no warning.
- "Plan (Enter)" tooltip claims it reserves Attention; every commit does.
- Cold open has no Esc handler; Player Guide only reachable from the main menu.
- Lose line omits reputation 0; fallback hint says hiring "lowers doom" (ADR-0015).
- Per-stream doom breakdown is shown free (ADR-0001/0004 say earned) -- Pip's call.

## Disk (research/, about 125 MB)

concepts 90 MB (gallery.png 12 MB can go; losing concepts' folders can go once one is picked), reference-games 12 MB, ui-pass 11.8 MB (game-shots 11 MB), diegetic 9.3 MB, council 0.5 MB. pdoom1 working tree clean.

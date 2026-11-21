# Council brief: agree the bar for the PLAN-screen redesign

New task for the same three council members (Opus, Sol, Neon). Read-only.

## Alex's words (quoted)

> "start with a game UI pass. Use the council, get the council to agree that it's. I'm not sure what the best bar is. I'm not as familiar with this genre as Pip is. I don't know what excellent examples of comparisons for other good games that have done the UI really well. Highly reviewed, incredibly well received games in similar genres. I mean, I'm familiar with Papers Please, but Papers Please is a simpler game with a diegetic UI."

> "You probably won't find games where the UI is praised specifically. You'll just find games people like. People don't think about UI when it's good They just take it for granted"

> "how hard is it to reconcile where pip's at against where we're at and understanding that Pip's busy and doesn't have time at the moment, for us to push forward as far as we can on putting up something to hate, like doing our best job of at least making a step forward, even if it also results in some mistakes being made, just so we get towards something that is more user-friendly, at least in the current example"

## Inputs

- Reference games research (shortlist of 7 well-loved, structurally close games + 2 contrasts, reception numbers, per-game screen notes from screenshots, and a DRAFT bar of 8 statements): C:/Users/keech/Documents/pdoom1-lean-setup/research/reference-games/shortlist.md and shots/
- Critique of today's PLAN screen (decisions, tier sort, findings): C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/critique.md
- The plan: C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/plan.md
- Pip's own ruled design for this screen, never fully built (read with git, the files are hidden by sparse checkout; run from C:/Users/keech/Documents/pdoom1):
  - `git show HEAD:docs/game-design/BUILD_BRIEF_PLAN_WATCH_UI.md` (PLAN screen elements 1-6: header with month and Attention pips, "the month ahead" queue, reserve, a hand of action cards along the bottom with Attention cost on each and greyed when unaffordable, small team panel, COMMIT; terminal/mainframe aesthetic)
  - `git show HEAD:docs/game-design/UI_PROPOSALS_2026-07-22.md` (drift table D1-D16: what was built vs intended)
  - Pip's named references: docs/game-design/WORKSHOP_2_BACKLOG.md lines 688-712 (Civ/XCOM two-screen modes, "deal the cards from the hand you've got", Euchre/Warhammer pre-commit, MTGO transitions)
- Rules: C:/Users/keech/Documents/pdoom1/.claude/skills/game-ui/SKILL.md and AGENTS.md section 1.

Orchestrator's factual note: the game already has an A/B layout switch (GameConfig.ui_layout "classic"/"proposed", Settings toggle, F9 in debug builds; scripts/ui/layout_controller.gd). The redesign is likely to be built as the "proposed" layout, so classic stays untouched for Pip to compare.

## What to produce

A bar the PLAN-screen redesign is judged against:
1. Name the one or two **targeted outcomes** for this pass (game-ui "Focus each pass").
2. At most 8 concrete, checkable statements, each traced to a reference game or to Pip's brief. Reject or rewrite draft statements that would break an ADR or the fork's scope (for example, showing a "next known event" may reveal what ADR-0001/0004 says is earned; event-dialog items belong to WATCH, outside this pass).
3. Say which reference screenshots to place beside the mock-up.

Answer format: first line `VERDICT: AGREE DRAFT WITH CHANGES` or `VERDICT: PROPOSE NEW BAR`. Then your proposed bar (outcomes + numbered statements with sources). Then at most 3 notes. Keep to Alex's scope.

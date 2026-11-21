# Council: one review round on the PLAN mock-up

Read-only. One round only (the plan defers the full consensus loop until Alex reacts). Your findings go to Alex beside the mock-up.

## Alex's words

> "for us to push forward as far as we can on putting up something to hate, like doing our best job of at least making a step forward, even if it also results in some mistakes being made, just so we get towards something that is more user-friendly, at least in the current example"

## Read

- The bar: C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/bar.md (your agreed bar; note the "Open with Sol" section).
- The mock-up source: C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/mockups/plan.html (`?view=first|returning|m5`; data comments inside say where each number comes from).
- The three renders at 1920x1080 (look at them):
  - C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/mockups/view-first.png
  - C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/mockups/view-returning.png
  - C:/Users/keech/Documents/pdoom1-lean-setup/research/ui-pass/mockups/view-m5.png
- Today's screen in matching states: C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/1475796a-3fb6-4331-a9c6-354740c87b80/scratchpad/shots/main.png and m5_plan_queued.png
- Reference shots: C:/Users/keech/Documents/pdoom1-lean-setup/research/reference-games/shots/

Orchestrator's notes (facts and choices, labelled as mine):
- Research Quality is drawn as a small inline control in the right column; where it goes is an open question for Alex (#1090), not decided.
- The month-5 state is an illustration built from a real scripted run (money, compute, research -12, reputation, doom from m5_plan_queued.png); the staff member, queue contents and in-flight items are invented to exercise the bar.
- No info control for effect text is drawn; blocked cards show a one-line reason in place of their cost.
- "Reserve now" maps to the existing explicit reserve (GameManager.set_attention_reserve / reserve_ap); the Commit note reflects end_month() holding all leftover Attention.

## Questions

1. Against each bar statement: pass, partial or fail, one line each with evidence from the renders.
2. The top 3 changes that would most improve the mock-up before Alex sees it, each small.
3. Anything in it that would change a run or break an ADR or AGENTS.md section 1.
4. Sol only: do you accept the majority on bar statement 4 (one Commit replacing all three controls), or is it blocking? If blocking, say why with code evidence.

## Answer format

First line `VERDICT: READY FOR ALEX` or `VERDICT: FIX FIRST`. Then the per-statement table, the top 3 changes, any run-changing or ADR issues, and a score out of 10. Keep to Alex's scope.

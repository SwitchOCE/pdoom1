# Council round 2: re-check

The three skill files have been revised to apply the union of the members' joint change lists (round1-findings.md plus each member's discussion reply). Members agreed on every fix in substance; they differed only on which items were blocking. All agreed items were applied, so the blocking/non-blocking label no longer changes the edit.

Files (same paths as before):
- C:/Users/keech/Documents/pdoom1/.claude/skills/game-ui/SKILL.md (rewritten)
- C:/Users/keech/Documents/pdoom1/.claude/skills/game-tutorial/SKILL.md (rewritten)
- C:/Users/keech/Documents/pdoom1/.claude/skills/ux-copy/SKILL.md (edited)

Orchestrator's factual context (labelled as mine, not a ruling): on the font floor, both rules are live. godot/UI_STYLE_GUIDE.md:106-115 still sets "no font a player reads while operating a control goes below 16 ... nothing goes under 14", and godot/tests/unit/test_font_size_ssot.gd:51 pins BODY_FLOOR := 18 for the theme's body size (base_theme.tres = 19). game-ui now states both. Neon's "#1041" issue number for the HUD "Turn" label was not verified, so it was left out. The palette section cites the two colour axes without a hue ban (Sol's narrower fix).

Applied list:
1. game-ui "Not yet" limited to read-only readouts/panels with no state yet; existing unlock gates respected; every available action keeps a visible route. New constraint "Actions are Pip's": hiding, locking, removing the route to, or re-nesting (is_submenu) an action is a proposal for Alex; moving a still-visible control is layout; door cap cited to UI_ARCHITECTURE_2026-08-06.md (#1132) and not treated as permission. Mirrored in game-tutorial methods 4-5, the "One decision first" bar and Scope.
2. game-ui WATCH: event-specific options mapped to handle/ignore; defer only for deferrable events and not in the v1 dialog. Month Review added. Esc exception #452 and P6 added; teaching overlays over an unanswered dialog close themselves without answering or closing it (also in game-tutorial "Never trapped").
3. game-ui PLAN: upgrades, Research Quality, planning/operating hours split and affordability rule added; lists marked as a starting point to re-derive from the live screen.
4. Reach tier never hover-only; affordability on the glance tier; mock-ups show the first-month view and the returning-player view (game-ui; ux-copy tooltips).
5. Sight line covers facts as well as numbers in all three skills; lethal causes legible at the free warning.
6. game-tutorial method 6: tiers and pacing across runs (F6, F7); beginner mode and faster pace are proposals. F16 now mentions guided vs learn-by-trying tracks.
7. game-tutorial bars: preamble labels the 20/40-minute cases as the video's observed failures and the bars as this skill's derived targets; "First month" accepts holding Attention back; new "Learned, not followed" (unaided repeat) and "Shown, not walled" bars; "Twenty minutes" renamed "Acting soon".
8. ONBOARDING_STORY_DESIGN: reuse plumbing, not its stale copy; goal text follows ADR-0002; check named effects against the live action. Stale fallback hint noted.
9. ambient < feed < window cited to DESIGN_PHILOSOPHY.md and event_tiers.gd; ADR-0012's overflowing backlog rule added.
10. "month" not "turn" in new text; HUD "Turn N" counts workdays, flagged as a display bug (game-ui and ux-copy).
11. ux-copy: glossary's player-facing section plus live strings and ADRs; checks add no AP, GameConfig.format_*, no unearned fact; .tscn in ASCII list; Title Case buttons with a check-the-surface caveat.
12. Few criteria: "Focus each pass" in game-ui and game-tutorial; output formats ask for the targeted one or two outcomes/bars.
13. Pause semantics and create_timer in both game-ui and game-tutorial; palette and type sources cited in game-ui.
14. game-tutorial method 10 restores "play test your tutorials. Like, a lot"; human tests ideally include someone new to strategy games. game-ui description now says it replaces design:design-critique, design-system and accessibility-review here.

## What to send back

Re-read the three files in full. First line `VERDICT: GOOD TO GO` or `VERDICT: CHANGES NEEDED`. Then any remaining blocking items (evidence and fix), at most 3 non-blocking notes, and a score out of 10. Keep to Alex's scope (brief.md). Read-only.

---

# Round 3 re-check (after Opus GOOD TO GO 9/10 and Sol CHANGES NEEDED 9/10)

Applied:
- Sol blocking: game-tutorial owner's rule and "Gone when learned" bar now say completed or dismissed lessons stay gone across runs; hints off suppresses automatic lessons in every run; with hints on, a lesson not yet met may appear on a later run when relevant; on-demand help always available.
- Sol non-blocking: "faster pace" now reads as the video's Civ "Quick" setting (shorter in-game task durations), distinct from WATCH's existing playback speed. Advisor queue and milestone hooks called proposed patterns (pseudocode); nudge plus glow and the intro version gate called built.
- Opus non-blocking: game-ui notes that a PLAN tile click queues the action, so decision info opens by focus, a selection panel or a separate info control. ux-copy example now "End Run" / "Keep Playing". "Never trapped" bar marks the cold open's missing Esc as a known failure to fix.

Re-read the changed passages (game-tutorial: owner's rule, method 6, bars, Scope; game-ui: Reach tier; ux-copy: Confirmations) and reply in the same format.

---

# Neon re-check (Opus GOOD TO GO 9.5/10, Sol GOOD TO GO 9.5/10 on round 3)

Since round 3 only: Sol's non-blocking note applied (game-ui Reach tier now says give decision info without changing a control's existing click: action tiles queue, door tiles open submenus, upgrade buttons buy) and line wrapping tidied in game-tutorial.

Gemini Neon: re-read all three skill files in full against your round-1 findings, the joint list and the changes logged above. Reply in the same format (VERDICT line, blocking items with evidence and fix, at most 3 non-blocking notes, score out of 10). Read-only.

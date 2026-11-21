# Fork backlog

One line per item. Types: bug / ui / tut. Status: todo / doing / in-lean /
sent (PR link) / merged / declined. `Refs` is Pip's issue, if any.

Format: `- [status] type -- the problem in the player's terms -- Refs #N -- branch`

## Items

(Empty. Candidates from Pip's open issues, titles only, untriaged -- check each
against AGENTS.md section 1 before taking it:
#1023 game does not initialise on launch;
#1126 Local/Global leaderboard toggle un-presses itself on fetch failure;
#1086 onboard-now tooltip omits Attention cost and prints raw money;
#1085 minimising does not minimise;
#880 Financing submenu has no icons or costs;
#603 fanfare popup has no dimming backdrop;
#936 attention items squash the action menu;
#577 UI jitter on hover;
#1223 Action Queue and Attention header contradict each other.)

## Decisions

Alex's calls on this fork, one line each, newest last:
`- YYYY-MM-DD -- the decision -- why`

- 2026-11-21 -- Fork scope is gameplay-blocking bugs, UI and tutorial only; no mechanics -- Alex's brief.
- 2026-11-21 -- Player-facing text in data JSON may be in scope (no ids, keys or numbers), but is not the focus of the first pass -- Alex.
- 2026-11-21 -- Hide Pip's governance with a sparse checkout instead of deleting it -- keeps upstreaming a plain cherry-pick.

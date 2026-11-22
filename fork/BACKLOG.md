# Fork backlog

One line per item. Types: bug / ui / tut. Status: todo / doing / in-lean /
sent (PR link) / merged / declined. `Refs` is Pip's issue, if any.

Format: `- [status] type -- the problem in the player's terms -- Refs #N -- branch`

## Items

- [in-lean] ui -- the main screen shows too much at once and the cold-open hand-off is one hint line: G desk (rail, sheets, advisor note), plain look, playable by mouse; squash 19de9ba3 -- -- ui/g-desk (deleted)
- [doing] ui -- G desk look (2a theme), WATCH faces (1c), paper, room, dateline, tier icons, motion -- -- ui/g-*
- [todo] bug -- a commit in the first seconds of a run can race BaselineSimulator's thread (engine error 'CowData was modified during destruction'); the baseline game is also folded into the live run's verification hash -- Refs #1377 --
- [todo] bug -- Undo removes the first queued copy of the last action, not the last entry (changing it is mechanics: ask Alex) -- Refs #1378 --
- [todo] bug -- queued plays never book their typed hours, so a month with 12 planning hours accepts 20 planning plays and all resolve (mechanics: Pip's call) -- Refs #1379 --

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
- 2026-11-22 -- G desk is on by default in fork builds; classic one switch away in Settings -- Alex: "G on by default (Recommended)".

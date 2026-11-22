# Council round 4 (extra round, on Alex's request)

Relayed from Alex's PC session: close out Sol's three round 3 items rather than leaving them to the build; Sol re-checks, Opus where a fix touches what Opus passed, Neon last on the whole spec.

- Writer applied the three items at 5e540c1c (spec 2.1, 12.1 item 5, 5.7.1, 12.2; section 19 now the round 3 changes table; build prompt's open-items paragraph removed).
- Sol: first answer CHANGES NEEDED, one blocker: the build prompt still pinned 505d0db9. Orchestrator moved the pin to 5e540c1c (c796e06a). Sol then: "VERDICT: GOOD TO GO | SCORE: 9/10". Sol verified `G_DESK_BEFORE_BOOT=true` on both launch paths in 4.5.1.
- Opus: GOOD TO GO, 9/10. Verified the boot order on both launch paths in 4.5.1, the Purchase Compute fixture and the icon surfaces against the data.
- Neon (last, whole spec): GOOD TO GO, 9/10. Re-ran the guard and provenance commands (all exit 0). Non-blocking notes: section 9's table still names `window_attention_for_option` where 5.5 (authoritative) uses `costs_with_window_attention`; legacy events without a window block correctly get no summary; the read-only design worktree needs `chmod -R u+w` on fork/ before `git worktree remove`.

# hifi3 council round 1: agreed list

Settled by opus, sol and neon (r1-consensus-*.md). All three agreed every
blocking item and agreed the sound tuning goes in this fix round. Two
splits are settled by majority and marked. Scores after consensus:

| Member | H | C | E | G | spec | page | sound |
|---|---|---|---|---|---|---|---|
| opus | 9 | 8 | 8.5 | 8.5 | 8.5 | 8.5 | 7.5 |
| sol | 9 | 9 | 9 | 9 | 8 | 8 | 8 |
| neon | 9 | 8 | 9 | 9 | 8 | 8 | 7 |

## 1. Sound (designer A in H; then synced to C, E, G and the page)

1.1 **Replay guard (blocking).** Put the guard inside the shared sound
    block: while a previous play is still sounding (through its scheduled
    tail), `playDateline` / `TypeSound.play` ignore the new call (return
    null or the running times; say which). Callers keep the button
    disabled until onDone, in both motion settings. No overlap can occur
    from rapid clicks or Enter presses.
1.2 **Tuning (all three: include).** Toward the spy-film title-card strike,
    no margin bell:
    - sharper metallic contact: the high-passed click brought forward
      (cutoff about 3.5-5.5 kHz, peak about 0.7-0.85, decay 8-10 ms);
      the band-passed slap tightened (about 2.6-3.2 kHz, decay 20-30 ms);
    - shorter, less pitched thump: decay about 40-50 ms, peak about
      0.65-0.7; its pitch spread narrowed to about +-2.5% (its own random
      draw); the noise layers keep their wider spread;
    - a later escapement / rebound tick: a faint narrow metallic ping
      (about 3.6-4.2 kHz) about 15-20 ms after the strike;
    - the carriage-return slide made audible (gain about 0.24-0.3, a sweep
      of about 500-600 -> 1700-1800 Hz) into the existing low stop;
    - a slightly bigger, darker room (tail about 0.7 s, wet path
      low-passed about 2.5 kHz, wet about 0.22-0.24).
    - **Cadence stays at 95 ms** (majority: opus, sol; neon proposed
      115-125 ms). It matches the silent type-on Alex approved.
1.3 **Reference WAV** re-rendered at 44.1 kHz mono 16-bit, typing
    "NOVEMBER 1, 2017"; raw peak at or below -1.5 dBFS with no
    normalisation gain (meets all three members' limits); report duration
    and peak. Neon listens again in the re-check.
1.4 Spec 3.3 (layers) and 6.3 (asset) updated to match the code and file.

## 2. Spec (designer A)

2.1 1.2 Attention rule (blocking): the game queues the declared spend and
    self-charging plays debit at execution (game_manager.gd:715-717); the
    row's spill tag is the mock-up's queue-order estimate and MonthPlan's
    pool totals are the authority; the no-spill exception is conference
    travel only (ADR-0011 :169-171).
2.2 7.2 Strategic unlock (blocking): workday 10 (turn_min) and reputation
    at least 30 (core.json :113-116); Safety Audit's own gate as is.
2.3 3.8 and section 5 (blocking): the spill tag is "SPILL 1" in the POOL
    column, as H draws it. Balances: only the card file's balance strip
    shows all four (money, compute, research, papers); the idle plan panel
    shows Attention and queued plays; the Plan sheet's AFTER COSTS shows
    money, reputation and held hours; the desk at rest shows no balances.
    Add one line to 7.1: H drops today's always-on resource bar; Pip's
    call.
2.4 Citations: game_state.gd:617 -> :791 (and death_attribution.gd:46);
    main_ui.gd:1009 -> :1010; screen_mode.gd:98 -> :101.
2.5 3.9: "no keycaps behind the paper" applies to the WATCH event only;
    under the month review the rack keeps its letters and Enter belongs to
    the sheet alone (as H s5).

## 3. Page and its build (orchestrator)

3.1 (blocking) The converter joins a list item's continuation lines before
    inline formatting; no raw `**` or stray backticks in the built page.
3.2 (blocking) At 320 px with the spec open there is no page-level
    horizontal scroll: inline code in the spec wraps; wide tables and code
    blocks scroll inside their own boxes. Verified at 320, 390 and
    desktop.
3.3 Rebuild after the spec and sound are fixed (the page takes H's block).

## 4. C state 3 (designer C) -- majority

4.1 Move the schedule board's clamp so it clears the P(DOOM) panel by a
    few pixels at 1280x720 (opus, sol: include; neon: skip). Re-render
    state 3 at both sizes and its WebP.

## 5. Sound copies in C, E and G (designers C, E, G)

5.1 After designer A finishes 1.1-1.2, copy H's new block byte for byte
    into each concept, and give each "play with sound" control the same
    lockout (disabled until onDone, both motion settings). No re-render
    needed unless the control is visible in a render.

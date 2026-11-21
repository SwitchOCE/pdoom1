# Grim pass council round 1 consensus -- neon

## Response to other members' blocking items

1. **`.dim` covers the P(Doom) and reputation meters, shortcut rack, Held panel and Commit in states 2, 3 and 5 (Sol 1, Neon 1; Opus non-blocking):** **Agree -- keep blocking.** Both Sol and I independently measured composited pixels on the rendered PNGs at 2.00:1-3.70:1 (`H/s5.png` `56.7%` 2.03:1, `SEVERE` 2.00:1, `band 4 of 7` 2.04:1; `H/s2.png`/`H/s3.png` `40.2%` 2.71:1, `HIGH` 2.63:1, `band 3 of 7` 2.06:1, Held subtext 2.19:1, `COMMIT THE MONTH` 2.82:1). Those instruments are live readouts (especially `56.7% SEVERE` in state 5 when Doom crosses up, and the lit `ACTIONS`/`PLAN` rack plate in states 2-3), and hifi A kept all of them above `.dim`. Move `add(el("div","dim"))` directly after `room()` (and in state 5 after the left terminal and cat print) so the right-hand instruments sit above `.dim` at full contrast, then re-verify on composited pixels.
2. **Dateline replays its type-on animation within November in states 2, 3 and 4 (Sol 2):** **Agree -- blocking.** Verified in `H/concept.html:510,618,763,787`: every state screen runs the strike animation unconditionally, directly contradicting `H/notes.md:197-200` ("It types in afresh only when the month changes ... Within a month the day updates in place, without the type-on") and `brief.md` item 4. Fix: pass a `typeIn` flag to `dateline(d, typeIn)` (true on month entry: states 1, 5, 6; false on in-month states 2, 3, 4), keeping `prefers-reduced-motion` and `?still=1`.
3. **State 4 clock says `PAUSED FOR YOU` right above `MONTH RUNNING` in Commit's slot (Sol 3):** **Agree -- blocking.** In `H/s4.png` (`H/concept.html:586`), the two labels sit in the same column and directly contradict each other. Replace `MONTH RUNNING` with `MONTH IN PLAY` (as in G) or `AWAITING REPLY`.

## Cheap non-blocking items worth bundling into the fix round

1. **State 4 paper 16px text in `--ink-soft` near 4.5:1 (Opus 1, Neon 2):** **Include.** Both Opus (3.9-4.4:1 on antialiased strokes) and I (4.1-4.3:1 on antialiased pixels / 4.8-4.9:1 peak) flagged `.ev-f` and 16px paper option effects over the darkened bottom inset shadow. Switching `.ev-f` and `.ev-o em` from `--ink-soft` (`#30281d`) to `--ink` (`#1e1810`) is a one-line CSS change that locks in clean contrast margin without altering the aged paper aesthetic.
2. **State 4 WATCH rack keycaps (Opus 2, Neon 1):** **Include.** At minimum, remove `[A] [P] [U]` from the three disabled WATCH plates (`ACTIONS`, `PLAN`, `UPGRADES`), and hide the remaining rack keycaps (`[F] [E] [L] [F1]`) while `Talent Opportunity` awaits a reply so modal focus matches C, E and G.
3. **Showcase toggle focus restore (`hifi2/index.html:113`, Sol non-blocking; orchestrator):** **Include.** `tab()` queries `nav button.tab`, which misses the `Show` toggle buttons inside `main`. Changing the selector to `button.tab` (or scoping within the button's parent container) fixes keyboard focus in one line.

## Keep non-blocking (out of the fix round)
- Paper fold creases, bevelled panel frames and raising state 6 room brightness from 0.36 to 0.42 (Opus 3) -- taste/art direction; all three members already judge H as belonging beside the grim gallery.
- Repeating the date across dateline, clock and event header in state 4 (Opus 2 first half) -- minor; keep for the report.
- Tear-off "17" calendar icon on `PLAN` (`ui_config_date_64`) and `"LAB TERMINAL 1"` footer label (Sol, Neon) -- already logged in `H/notes.md` under Needs grim art and Open questions.

---

## Proposed joint list

### Blocking (for the one fix round)
1. **[states 2, 3 and 5, both sizes]** Place `.dim` directly after `room()` (and in state 5 after the left terminal and cat print) so P(Doom), Reputation, the shortcut rack, Held for events and Commit sit above `.dim` at full contrast (`>= 4.5:1`), matching hifi A; re-measure contrast on composited rendered pixels.
2. **[states 2, 3 and 4, live mock-up]** Animate the typewriter dateline only on month entry (states 1, 5, 6); show the date already set on in-month states (states 2, 3, 4), keeping December's type-on, `?still=1` and `prefers-reduced-motion`.
3. **[state 4, both sizes]** Replace `MONTH RUNNING` in Commit's inert WATCH slot with `MONTH IN PLAY` (as in G) or `AWAITING REPLY` so it does not contradict `PAUSED FOR YOU`.

### Cheap non-blocking items to bundle
1. **[state 4, both sizes]** Darken 16px paper text (`.ev-f` and `.ev-o em`) from `--ink-soft` (`#30281d`) to `--ink` (`#1e1810`) so antialiased strokes clear 4.5:1 with margin.
2. **[state 4, both sizes]** Hide keycaps on disabled WATCH rack plates (`ACTIONS`, `PLAN`, `UPGRADES`) -- and ideally all background rack keycaps while `Talent Opportunity` awaits a reply.
3. **[showcase `hifi2/index.html`, orchestrator]** Restore focus to the selected version button in `Toggle, one state` (`index.html:113`).

## Score
Keep **H 8.5/10** (belongs beside the grim gallery: yes, average). Sol's dateline-replay and WATCH status contradiction are crisp, cheap fixes alongside the `.dim` contrast regression; one quick fix round brings H to 9+/10.

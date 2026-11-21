# Council round 1: all three members' findings, verbatim

Relayed by the orchestrator without edits. Skill files have NOT changed since round 1.

Reminder of scope (Alex's words, in brief.md): understand the game's UI and tutorial issues; Neon's video findings; UI from first principles; generalise from the Bramble design skills; council reviews the resulting skills. Mark anything outside that as non-blocking.

---

## Claude Opus (7.5/10)

VERDICT: CHANGES NEEDED

**Blocking**

1. **game-ui lets an agent hide or move action tiles without asking Alex.**
   - Evidence: `game-ui/SKILL.md:55-57` has a "Not yet" tier that covers all elements, controls included ("Reveal them when they first matter").
   - Evidence: `game-ui/SKILL.md:138` gives the door cap as "Pip's cap: at most 10 top-level doors (UI_ARCHITECTURE notes)", with no path and no warning.
   - Which actions are top-level and which sit inside a submenu is set in data: `godot/data/actions/core.json` has nine `"is_submenu": true` entries.
   - So moving or nesting a tile means editing a data key, which AGENTS.md section 1 forbids (copy-only edits, "no id, key or number changes"). Hiding a usable action removes an option from the player. game-tutorial already sends both cases to Alex (`game-tutorial/SKILL.md:107-111`); game-ui, the skill an agent will use for the redesign, does not.
   - Fix: in game-ui, limit "Not yet" to readouts and panels the player only reads. Add one line to the constraints: "Hiding, locking or re-nesting an action the player can use, or changing `is_submenu`, is Pip's call: bring it as a proposal." Cite the door cap as `docs/design/UI_ARCHITECTURE_2026-08-06.md` (#1132).

2. **ux-copy's "Turn" rule contradicts what the HUD shows.**
   - Evidence: `ux-copy/SKILL.md:40` says "'Turn' means one planning phase (a month) to the player."
   - The top bar prints `"Turn %d - <date>"` (`main_ui.gd:2035`), and that number counts workdays (`game_state.gd:1250`: "turn = 1 workday"; `turn_manager.gd:55` adds 1 per turn).
   - The function's own docstring shows "Turn 14 - Fri 21 Jul", which is mid-month. The screenshot shows "Turn 1 - Tue 4 Jul 2017".
   - An agent following the rule will write text where "turn" means a month next to a HUD where "Turn" counts days. AGENTS.md treats text that contradicts a display as a bug.
   - Fix: say "month" for the planning period in new text and avoid "turn". Note that the HUD's "Turn N" counts workdays today, a contradiction to flag to Alex as a bug fix in scope. Add the same note to game-ui at line 140.

3. **game-tutorial drops one of the video's five parts without saying so.**
   - The video's Pillar B (findings F6 and F7: teaching across several campaigns or runs) is absent. `game-tutorial/SKILL.md:28-74` jumps from F5 to F8.
   - P(Doom)1 is played as repeated runs, so this part is the most relevant to it. Alex named the video as the template.
   - Fix: add one method, "Teach across runs (F6, F7)". Deeper lessons appear on a later run, or after the player has played a stretch, and the player can come back for them. A stripped-back beginner mode (F7) or a quicker game pace (F9) changes the rules, so it goes to Pip as a proposal; the Scope section already covers that.

**Non-blocking**

- "ambient < feed < window" is credited to ADR-0012 (`game-ui/SKILL.md:126`). It actually comes from `DESIGN_PHILOSOPHY.md:377`, citing ADR-0009/0012. Fix the citation.
- The Bramble note `2026-11-09i-few-evaluation-criteria.md` was listed as a source but isn't applied. game-tutorial has 14 methods and 8 bars. Add: "Pick the one or two bars this change targets; don't grade every change on all of them."
- Two of the "bars" go beyond what the video says; label them as the skill's own reading:
  - The "Twenty minutes" bar (`game-tutorial/SKILL.md:95-97`): the video only reports the narrator zoning out.
  - "can say in a sentence why" in the "First month" bar: the 40-minute case was a player who couldn't find End Turn.

Checked and correct: the turn-gate claim (`main_ui.gd:1269`), the cold open having no Esc handler (Space hold-to-skip only), the Player Guide opening only from the main menu, the AP dead-word rule (`GLOSSARY.md:366`) and the playtest quotes (checked against the transcript). Leaving out Bramble's game-design-process skill and its board and tribe rules was right. The two owner rules in game-ui serve both the hundredth game and a tutorial, which answers Alex's two concerns.

Score: 7.5/10

---

## GPT Sol (7/10)

VERDICT: CHANGES NEEDED

**Blocking items**

1. **Correct the WATCH choices and the Escape rule.** The UI skill lists Handle, Defer, and Ignore as standard WATCH choices. The live dialog presents event-specific options. The ordinary path maps them to Handle or an available Ignore option, and ADR-0012 allows Defer only for deferrable events. The blanket Escape rule also conflicts with the modal stack, which consumes Escape while a required response is pending. Describe the shipped choices separately from the ADR taxonomy. Give optional teaching its own visible dismiss control and Escape path without answering, bypassing, or closing the underlying response. Attribute the ambient/feed/window distinction to `EventTiers`. [Game UI](C:/Users/keech/Documents/pdoom1/.claude/skills/game-ui/SKILL.md:35), [Window resolver](C:/Users/keech/Documents/pdoom1/godot/scripts/core/window_resolver.gd:165), [ADR-0012](C:/Users/keech/Documents/pdoom1/docs/game-design/decisions/ADR-0012-event-response-taxonomy.md:16), [Modal stack](C:/Users/keech/Documents/pdoom1/godot/scripts/ui/modal_stack.gd:162), [Event tiers](C:/Users/keech/Documents/pdoom1/godot/scripts/core/event_tiers.gd:8)

2. **Preserve informed choices when simplifying PLAN.** The UI skill allows decision information to live on hover, its accessibility check covers only actions, and the copy skill puts costs and conditions in tooltips. The current PLAN screen already directs players to hover for costs. The code also checks both total Attention and the applicable planning or operating hours, so the headline total alone cannot explain affordability. Require costs, eligibility, and consequences to be readable before commitment through a focusable or click-accessible path. In the same mockup, show the first-month cue and the experienced-player view with the cue gone. Available actions should remain reachable through stable controls in both views. [Game UI](C:/Users/keech/Documents/pdoom1/.claude/skills/game-ui/SKILL.md:41), [Accessibility check](C:/Users/keech/Documents/pdoom1/.claude/skills/game-ui/SKILL.md:102), [UX Copy](C:/Users/keech/Documents/pdoom1/.claude/skills/ux-copy/SKILL.md:54), [PLAN screenshot](C:/Users/keech/AppData/Local/Temp/claude/b9861bf4665b0039/1475796a-3fb6-4331-a9c6-354740c87b80/scratchpad/shots/main.png), [Affordability check](C:/Users/keech/Documents/pdoom1/godot/scripts/ui/main_ui.gd:1733)

3. **Apply the sight boundary to qualitative hints too.** The tutorial skill asks the advisor to name causes and directions, then describes the protection in terms of unpaid numbers. A line naming an undiscovered rival or attributing a change to a hidden source can reveal earned intelligence without printing a number. In all three skills, require advisor lines, tooltips, examples, and guide text to respect what the player can currently know. Keep lethal causes legible at the free warning threshold and describe action effects through their visible intermediaries. [Game Tutorial](C:/Users/keech/Documents/pdoom1/.claude/skills/game-tutorial/SKILL.md:51), [Scope guidance](C:/Users/keech/Documents/pdoom1/.claude/skills/game-tutorial/SKILL.md:112), [ADR-0004](C:/Users/keech/Documents/pdoom1/docs/game-design/decisions/ADR-0004-sa-channels-lead-time.md:19), [ADR-0015](C:/Users/keech/Documents/pdoom1/docs/game-design/decisions/ADR-0015-no-printed-doom-deltas.md:21)

4. **Carry over the video's proficiency tiers and test for independent play.** The methods omit F6 and reduce F16 to skip and return. The video shows players learning the basics, leaving to use them in real play, and returning for advanced lessons. It also shows guided practice followed by a similar problem the player solves independently. Add those patterns using optional lessons around normal runs. Identify F7's stripped-back campaigns as requiring a mechanics decision. Judge learning with an unaided repeat choice, and let a first-month tester explain either what they queued or why they reserved Attention. The 20- and 40-minute examples are observed failures, so label them as such. [Game Tutorial](C:/Users/keech/Documents/pdoom1/.claude/skills/game-tutorial/SKILL.md:68), [Video findings](C:/Users/keech/Documents/pdoom1-lean-setup/research/tutorial-video/findings.md:50), [Video transcript](C:/Users/keech/Documents/pdoom1-lean-setup/research/tutorial-video/transcript.md:103), [Reserve-all path](C:/Users/keech/Documents/pdoom1/godot/scripts/ui/main_ui.gd:1053)

**Non-blocking notes**

- The Bramble transfer keeps the decision-first hierarchy, stable grouping, short copy, and human playtest limits. The board, tribes, and card-text benchmarks stay out. Apply Alex's guidance to pick one or two outcomes for each iteration so the critique checklist stays manageable. [Bramble owner note](C:/Users/keech/Documents/Bramble/docs/design/sources/2026-11-09i-few-evaluation-criteria.md:7)
- The copy skill follows Pip's intended meaning of "turn." Flag that the current HUD labels the workday counter "Turn" and use "month" in commit instructions while both labels exist. [Design philosophy](C:/Users/keech/Documents/pdoom1/docs/game-design/DESIGN_PHILOSOPHY.md:428), [HUD formatter](C:/Users/keech/Documents/pdoom1/godot/scripts/ui/main_ui.gd:2021)

**Score: 7/10**

---

## Gemini Neon (7/10)

VERDICT: CHANGES NEEDED

### Blocking items

1. **`game-tutorial` drops Pillar B (F6 and F7: tiered lessons and multi-run pacing) despite promising F1-F17**
   - **Evidence:** game-tutorial/SKILL.md:13 states `(findings F1-F17 cited below)`, yet `Methods` jumps from `(F5)` at game-tutorial/SKILL.md:41 straight to `(F8)` at game-tutorial/SKILL.md:45. Pillar B (findings.md:50-67; transcript.md:61-83,186) is one of the video's three concluding takeaways (*"either across a campaign, or across multiple campaigns"*), and P(Doom)1 is a replayable time-loop game where players are expected to lose repeatedly (DESIGN_PHILOSOPHY.md:78-91) and `GameConfig.games_played` already exists. While F7's mechanics half ("a beginner mode that turns systems off") is rightly under `Stop and ask Alex` (game-tutorial/SKILL.md:108-109), **F6** (segmenting lessons by proficiency tier and kicking the player out to play between tiers) and the presentation half of **F7** (pacing deeper advisor/tutorial lessons across runs 1, 2, 3+ instead of cramming every system into run 1) are pure tutorial design and in scope.
   - **Fix:** Add a method between 5 and 6 covering F6 (tiered basics/advanced/strategy self-help or guide modules that return the player to real play between tiers) and presentation-safe F7 (pace deeper lessons across runs rather than teaching everything in run 1), cross-referencing `Scope` for any rule-changing beginner mode.

2. **Progressive UI disclosure in `game-tutorial` and `game-ui` invites hiding available turn-1 actions, breaking `AGENTS.md` section 1, P1, and fast-gate tests**
   - **Evidence:** game-tutorial/SKILL.md:41-42 asks *"for each bar, button and panel: does it need to be on screen in the first month?"* and game-tutorial/SKILL.md:84-85 sets the bar *"the rest is quiet or absent"*. game-ui/SKILL.md:55-57 defines `Not yet: elements that do not matter until later in a run` and claims *"Pip's philosophy already says the UI grows with the run's phases."* In reality, hiding any legally available turn-1 action or submenu button contradicts `Scope` (game-tutorial/SKILL.md:107-108), violates NAVIGATION_AUDIT.md:46-53 (P1: nothing hotkey-only), and fails fast-gate tests (test_navigation_principles.gd:89-106; test_action_visibility.gd:28,117). Pip's board-populating principle (DESIGN_PHILOSOPHY.md:326-331; ADR-0001:26-27) is gameplay-earned sight and existing unlock gates (`GameActions.is_action_unlocked()`), not tutorial button removal.
   - **Fix:** In both game-ui/SKILL.md:55-57 and game-tutorial/SKILL.md:41-44,84-85, explicitly separate **readouts/panels with no active state yet** (e.g., empty staff roster at 0 staff, clean ledger) or **de-emphasizing / nesting variants behind doors** (allowed) from **hiding or locking available turn-1 actions/buttons** (Stop and ask Alex; breaks P1 and fast-gate tests). Note that `Not yet` respects existing unlock gates and reserves slots rather than renumbering (UI_ARCHITECTURE_2026-08-06.md:124-126).

3. **`game-ui` contradicts the Esc contract on event dialogs (`#452`), mis-cites ADR-0012, and omits live PLAN decisions from step 1**
   - **Evidence:**
     - game-ui/SKILL.md:131-133 states *"every overlay closes with Esc and a visible button"*. NAVIGATION_AUDIT.md:122-123,241 mandates the opposite for unanswered event dialogs: they **swallow Esc** (`#452`) so players cannot dismiss mandatory events or open pause behind them. Following the skill literally introduces a mechanics-altering bug.
     - game-ui/SKILL.md:126-127 attributes `ambient < feed < window` to ADR-0012 (that taxonomy lives in DESIGN_PHILOSOPHY.md:375-377 / ARCHITECTURE.md:174-180), while omitting ADR-0012's actual UI rule: **the infinite to-do list is diegetic** (ADR-0012:32-35 -- items overflowing visibility is modeled, not a UI defect to "fix" with forced alerts).
     - game-ui/SKILL.md:37-40 lists PLAN decisions without **upgrades** (visible on PLAN in `main.png`), **Research Quality**, or the **2-way Planning vs Operating Attention split** (ADR-0011:156-167; Reserve checks `operating_hours_left` at main_ui.gd:1280), and omits **Month Review** (ARCHITECTURE.md:62). Because step 2 demotes anything not on step 1's decision list, this will mis-tier live controls.
   - **Fix:** Add the event-dialog Esc exception (`#452`) and P6 (typed text outranks shortcuts) to game-ui/SKILL.md:131-133; cite `DESIGN_PHILOSOPHY.md` for `ambient < feed < window` and add ADR-0012's diegetic-backlog rule; update game-ui/SKILL.md:37-40 to include upgrades, Research Quality, the Planning/Operating Attention split, and Month Review.

4. **`game-ui` cites an outdated 16px font floor and both `game-ui` and `game-tutorial` omit CI-enforced palette and pause-semantics rules**
   - **Evidence:**
     - game-ui/SKILL.md:134-136 states *"16px floor for anything read to operate a control"*, quoting the older section of UI_STYLE_GUIDE.md:113. Live CI pins `BODY_FLOOR := 18` (base_theme.tres:19 sets `default_font_size = 19`; test_font_size_ssot.gd:47-51,84-88,124-132) and forbids declaring any font sizes in `menu_theme.tres`.
     - Neither skill cites two UI docs explicitly required by AGENTS.md section 2: PALETTE_AND_DOOM_INTENSITY.md:81-103 (two semantic colour axes -- Catastrophe amber-to-fire and Weirdness green/blue/purple; blue and purple are never menu chrome or action accents; "Doom is a layer, not a repaint") and PAUSE_SEMANTICS.md:10,34-35,52-57 (toasts, pulses, and advisor/tutorial fades must freeze while paused; every `create_timer` must pass `process_always` explicitly, enforced by CI).
   - **Fix:** Update game-ui/SKILL.md:134-137 to state the live SSOT (`base_theme.tres` = 19, body floor 18, zero font sizes in `menu_theme.tres`, no new literal overrides), cite `PALETTE_AND_DOOM_INTENSITY.md` (two colour axes, no blue/purple chrome), and cite `PAUSE_SEMANTICS.md` + `create_timer(..., false)` in both `game-ui` and `game-tutorial`.

5. **`game-tutorial` tells agents to build on `ONBOARDING_STORY_DESIGN.md` without warning that its copy examples violate ADR-0002 and ADR-0015**
   - **Evidence:** game-tutorial/SKILL.md:114-117 says to build on ONBOARDING_STORY_DESIGN.md. That doc repeatedly uses pre-ADR-0002 / pre-ADR-0015 copy examples: *"drive doom / risk toward 0%"* (`:20,47`), *"Which button lowers doom, and by how much?"* (`:48`), and *"hire a researcher -> lowers doom"* (`:26,253,305,425`) -- phrasing that also lingers as fallback text in main_ui.gd:115. An agent copying its examples will violate ADR-0002 (you cannot win or reach 0%, only buy time) and ADR-0015 (no printed doom deltas).
   - **Fix:** Qualify game-tutorial/SKILL.md:114-117: reuse its **plumbing** (reusable advisor queue, milestone trigger hooks, `last_seen_intro_version`, nudge+glow), and explicitly reject its stale `"doom to 0%"` / `"lowers doom"` copy examples in favour of ADR-0002 and ADR-0015.

6. **`ux-copy` points agents to `docs/GLOSSARY.md` as a player-facing term dictionary, when it is a developer/release glossary**
   - **Evidence:** ux-copy/SKILL.md:25-26,77 directs agents to `Check docs/GLOSSARY.md` for consistent names across top bar, tiles, tooltips, feed, and guide, and includes `glossary term used` in `Checks`. GLOSSARY.md:1 is `# P(Doom)1 developer glossary`; 95% of its 499 lines are release-engineering terms (`epoch`, `pck`, `stage gates`, `Commissioner`), and its `Player-facing vocabulary` section (GLOSSARY.md:364-398) contains only two entries (`Attention` and `number format policy`).
   - **Fix:** Point ux-copy/SKILL.md:26 to `docs/GLOSSARY.md`'s `Player-facing vocabulary` section specifically, and direct agents to verify player-facing terms against live UI/data strings (`godot/data/actions/*.json`, `godot/scripts/ui/`) and ADRs (`ADR-0009`, `ADR-0011`, `ADR-0012`). Also update `Checks` at ux-copy/SKILL.md:77 to include `no stale AP` (test_no_stale_ap_vocabulary.gd) and `GameConfig.format_*` (no raw floats).

### Non-blocking notes

1. **Carry over Alex's `2026-11-09i-few-evaluation-criteria.md` steering:** Listed as a source in the brief, its core warning (*"Get good at one or two things and then start fixing other issues. And if you have too many rules, you're going to have impossible evaluation criteria"*) is missing from `game-ui` (7 steps + 8 critique checks + 10 constraints) and `game-tutorial` (14 methods + 8 bars). Add one line to each advising agents to target 1-2 highest-impact issues per pass rather than grading everything simultaneously.
2. **Plugin override parity and P(Doom)1 copy register:** ux-copy/SKILL.md:3 states `Use instead of design:ux-copy in this repo`, while game-ui/SKILL.md:3 omits the matching override for `design:design-critique` / `design-system` / `accessibility-review`. In `ux-copy`, also add `.tscn` to the ASCII/no-emoji list (enforced by `check_no_emoji.py` per PALETTE_AND_DOOM_INTENSITY.md:52), and note P(Doom)1's ASCII terminal chrome register (PALETTE_AND_DOOM_INTENSITY.md:39-49) and Title-case button convention (UI_STYLE_GUIDE.md:102-104 vs `"Commit the month"` at ux-copy/SKILL.md:51-52).
3. **Playtest rule and show-don't-tell bar in `game-tutorial`:** Method 9 (game-tutorial/SKILL.md:59-62) drops the second half of GMTK's rule (findings.md:182: *"play test your tutorials. Like, a lot"*), and `Bars` (game-tutorial/SKILL.md:81-97) has no concrete bar for F13/F14 (short copy / show with visual or animation instead of walls of text), which directly bears on P(Doom)1's text-heavy Player Guide and modals.

SCORE: 7/10

---

## What to send back

For each other member's item: agree, disagree, or agree with a different fix, with evidence. Keep Alex's scope in mind; mark items outside it as non-blocking. End with your proposed joint change list (numbered, one line each, blocking vs non-blocking). Read-only: do not edit any file.

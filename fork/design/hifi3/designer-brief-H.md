# hifi3: designer brief for H (finish H, then write its spec)

You built A in the hifi run and H in the grim pass. Alex picked H. This pass
finishes it and writes its design spec. Work in /home/alex/code/pdoom1
(branch `design/ui-concepts`), only in fork/design/hifi3/H/ and
fork/design/hifi3/spec.md. The orchestrator has copied H's committed files
from fork/design/hifi2/H/ into fork/design/hifi3/H/ (concept.html,
notes.md, assets/, s1..s6.webp); hifi2/H stays as it is.

## Alex's words (verbatim)

> "Okay, that is excellent. I want you to build out the spec. The icons
> don't count in response to question five. Build the others with the
> darker look as well. But I'm pretty happy with this one. The sound should
> be pretty similar to how those sounds in the movies are. The scene, I
> think, of, you know, it's like it's a typical thing, it's a trope in spy
> movies, right? if something doesn't fit the character design, like the
> lab terminal thing, it should go, I don't understand the other open
> questions. Date feels the date feels good. I like the date. Yeah, build up
> the other designs, but and then give me an artifact I can share"

His grim-pass words (fork/design/hifi2/brief.md) still hold.

## Read first

1. fork/design/hifi3/brief.md in full: "Decisions Alex made" and "What to
   make" items 1 and 3 bind you.
2. fork/design/hifi2/report.md (open questions, new art) and
   fork/design/hifi2/council/ (r1-agreed.md and the re-check answers: the
   taste notes and non-blocking items).
3. Your own fork/design/hifi2/H/notes.md and the hifi rules it lists.

## PASS 1: H finished (fork/design/hifi3/H/)

1. **Off-character leftovers out.** Remove "LAB TERMINAL 1" and its green
   light. Sweep all six states for anything else that belongs to an
   earlier look: labels for objects no longer drawn, decorative lights,
   mock brand text. Remove only mock-up inventions, never real game
   content or labels that exist in Pip's UI. List each removal in notes.md.
2. **The dateline sound.** The spy-film title-card trope: a place and date
   typing onto the screen with heavy, punchy key strikes. Build it in
   concept.html with the Web Audio API, synthesised (no recorded samples,
   nothing copied from a film):
   - a hard key strike per character, slight random pitch and timing;
   - silence on spaces;
   - an optional low carriage-return thunk at the end.
   Browsers block sound until a click, so add a visible, small "play with
   sound" control (in keeping with H, outside the game screen or clearly a
   mock-up control). The automatic type-on stays silent until it is
   pressed. Pressing it replays the dateline type-on with sound; with
   reduced motion on, it still plays the sound (it may skip the animation).
   Keep the sound code self-contained (one function block) so the
   orchestrator can reuse it on the showcase page; say where it is.
   Describe the design of the sound in notes.md (envelope, frequencies,
   timing) so it can be judged as code.
   **Also render it to a file** (correction from Alex: one council member,
   Gemini Neon, can hear audio): run the same Web Audio code through an
   OfflineAudioContext in headless Chromium, typing "NOVEMBER 1, 2017",
   and save it as fork/design/hifi3/H/dateline-sound.wav (mono, 44.1 or
   22.05 kHz, 16-bit; small, it is committed). Check the file is valid
   (duration, peak level not clipping) and report both.
3. **The icon question is closed:** Pip's Staff and Hire icons stay; they
   do not count as a person. Remove it from open questions.
4. **Taste notes** from the hifi2 council are your call: paper creases and
   edge wear, a little soot on frames, the date shown three times in state
   4, bold event costs on the paper, Commit dimmed (not hidden) while the
   month review owns the screen, the action menu's box vs A's wider frame,
   state 6 room brightness. Do what makes H better, skip the rest, and say
   which and why in notes.md.
5. Keep everything the grim-pass council agreed (hifi2/council/r1-agreed.md)
   and every hifi rule. Text at least 4.5:1 measured on composited pixels
   at both sizes.

Deliverables as before: concept.html (?state=1..6, ?still=1), assets/,
s1..s6.png at 1920x1080 and s1-720..s6-720.png (uncommitted),
s1..s6.webp (about 300 KB, committed), notes.md updated (a "hifi3" section:
removals, the sound, taste notes done/skipped, contrast table).

Reply "H FINISHED" with what changed, where the sound function is, the
contrast minimum per state, and a disk report. The orchestrator pushes a
checkpoint and starts C, E and G from your files. Then wait for "continue".

## PASS 2: the spec (fork/design/hifi3/spec.md)

A design spec that a reader (Pip, or whoever builds it later) can follow
without you. Keep it proportionate: plain language, ASCII, numbered
sections, no padding. It covers what brief.md "What to make" item 3 lists:

1. What H is for, paraphrased (do not paste Alex's dictated words), and
   what it must not change: no mechanics; ADR-0015 (no printed doom
   deltas), ADR-0001 (spending buys sight), ADR-0011's Attention rule; the
   hidden information.
2. Tokens: the palette (with the doom-band colours and how the room
   darkens by band), type scale (font sizes come from
   godot/theme/base_theme.tres and ThemeManager.get_font_size(); Pip's CI
   rejects literal font sizes), spacing, line weights, the grime and
   texture treatment, the 4.5:1 contrast floor.
3. Components and their states: P(Doom) meter, reputation tachometer,
   dateline (type-on timing and the sound, described so it can be made as
   a game audio asset), menu rack, plan panel, Commit and the
   held-for-events panel, action card file, month plan table, paper (event
   card, month review), WATCH clock and speed controls, feed.
4. The six screens: what is on each, what is one click away, keys
   (Enter/Esc only on the topmost layer; which shortcut keys are new).
5. A short table mapping H's parts onto today's Godot scene
   (godot/scenes/main.tscn, godot/scripts/ui/), reusing G's notes
   (fork/design/hifi/G/notes.md); read those files, do not edit them.
6. Assets: Pip's art and icons used; art that would need darker versions
   to match (say it that way, never "cartoony" or "corny"); the sound
   asset.
7. Open rule questions where the mock-up follows the ADR and today's UI
   differs (the Attention spill, Reserve), and the bugs found on the way.

Check every number and rule in it against godot/data/, the code and the
ADRs. Reply "SPEC DONE" with a short outline and a disk report.

## Rules

Write only in fork/design/hifi3/H/ and fork/design/hifi3/spec.md; no git;
no subagents; ASCII only in text you write; no mechanics; do not ask
questions (carry them to notes.md). Rendering as before (headless Chromium
with --no-sandbox, one at a time, scratch deleted). Every reply ends with a
disk report: everything written outside those paths, sizes, what can go.

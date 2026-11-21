---
name: ux-copy
description: Write or review P(Doom)1's player-facing text - button labels, action and event names and descriptions, tooltips, notices, empty states, confirmations, tutorial lines and the Player Guide. Use instead of design:ux-copy in this repo, whenever wording a string the player reads. Not for deciding what a screen shows (game-ui) or how a lesson is sequenced (game-tutorial).
---

# Player-facing text

Generalised from the owner's Bramble ux-copy skill; the P(Doom)1 rules are
marked. Text edits in `godot/data/` JSON are in scope only when no id, key
or number changes (AGENTS.md section 1).

## The owner's rule: say the main thing, plainly, in few words

From Bramble (owner, 8 Nov 2026): text "says the main effect plainly, in as
few words as it takes". The point of an explanation is to "make complicated
things simple", not "to handle every use case". Edge cases and implications
go to a second layer (a tooltip's detail line, the Player Guide) or stay
implied. Long, wordy text was the owner's first complaint about a build.

## Principles

1. **Clear**: say exactly what happens, in the player's terms.
2. **Short**: the fewest words that carry the main effect. Mid-month text is
   read at a glance; the guide can say more.
3. **Consistent**: one name per thing everywhere: top bar, tiles, tooltips,
   feed, guide. One verb per action. `docs/GLOSSARY.md` is mostly a
   developer glossary; use its "Player-facing vocabulary" section, and check
   other terms against the live strings (`godot/data/actions/*.json`,
   `godot/scripts/ui/`) and the ADRs that name them (ADR-0009, ADR-0011,
   ADR-0012).
4. **Useful**: every word helps the player decide or act.
5. **Human**: a person talking, not a log file. Lore and flavour live in
   names, event prose and the cold open; rules sentences and buttons stay
   plain. Keep the lore mysterious and the choices clear
   (COLD_OPEN_SEQUENCE.md).

## P(Doom)1 rules

- **No doom numbers** in action or event text (ADR-0015). Name the direction
  or the world-state effect ("draws public attention"), never "-2% doom".
- **Do not reveal what spending is meant to buy** (ADR-0001, ADR-0004). A
  string says only what the player can currently know: no number and no fact
  (an undiscovered rival, a hidden cause) they have not earned the sight of.
  Lethal causes become legible at the free becoming-lethal warning. If in
  doubt, stop and ask.
- **Goal text follows ADR-0002**: you cannot win, only buy time.
- **Dead words**: "AP" and "action points" are gone (ADR-0011; a test checks
  for them); the currency is Attention. "Onboarding" in the code usually
  means onboarding a hired researcher.
- **Say "month", not "turn"**, for the planning period. The HUD's "Turn N"
  counts workdays today (`GameState.turn`), so "turn" in new text would
  contradict it. Flag that HUD label to Alex as a display bug.
- **Numbers** follow `docs/NUMBER_FORMATS.md` and go through the
  `GameConfig.format_*` helpers (a test enforces it); no raw floats.
- **ASCII only, no emoji**, in `.gd`, `.json`, `.tscn` and `.md`
  (`scripts/check_no_emoji.py`).
- **Text that contradicts what the game does is a bug** (AGENTS.md). Check the
  code path before you write what an action does.

## Patterns

Examples are illustrations, not decided text.

- **Buttons**: a verb and its object, matching the outcome, in Title Case
  (UI_STYLE_GUIDE.md): "Commit the Month", "Hire Researcher". Check the
  surface you are editing first; some live labels differ (COMMIT THE MONTH).
  Never two buttons with different labels for one action.
- **Action and event text**: the main effect first; costs and conditions in
  the tile's tooltip, not in the name.
- **Notices**: what happened, and how to fix it if the player can, in as few
  words as that takes: "Not enough Attention." Do not repeat what the screen
  already shows.
- **Empty states**: what this is and how to start: "Actions you queue appear
  here."
- **Confirmations**: only for what cannot be undone, never for routine
  moves. Name the action and the consequence; label the buttons with the
  action ("End Run" / "Keep Playing"), not OK / Cancel.
- **Tooltips**: first line the main effect; a second, smaller line for detail
  a returning player can skip. What a player needs to decide (cost,
  eligibility, consequence) must also be readable without hover: on the tile,
  or through keyboard focus, a selection panel or a separate info control,
  never by changing what a click already does (see game-ui).
- **Tutorial lines**: one idea per line, tied to what the player is looking at
  or doing right now (see the game-tutorial skill).

## Output

```markdown
## Copy: [where it appears, player state]

Recommended: [text]
Alternatives: [one or two, with when each is better]
Why: [the player's moment, length, consistency with existing terms]
Checks: [player-facing term matches live strings | no doom number | no unearned fact | "month" not "turn" | no AP | numbers via GameConfig.format_* | ASCII | no id/key/number changed]
```

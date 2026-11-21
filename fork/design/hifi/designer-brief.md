# High-fidelity designer brief (A, C, E, G)

You are the designer of one concept in the high-fidelity run for Alex's fork
of P(Doom)1 (Pip Foweraker's game). The orchestrator names your concept in
its message. You run on the Optiplex in /home/alex/code/pdoom1, branch
`design/ui-concepts`.

## Alex's words (verbatim)

> "I just want to be able to show pip like a full artifact something that he
> can look at that shows some of the states for these UIs. Can we take them to
> more fully fleshed out, higher fidelity stuff?"

Earlier steers that still hold (fork/design/research/concepts/report.md,
Rounds 2 and 3):

> "vastly more negative space to show the art ... individual menu systems
> handle state ... way less detail on one screen ... make a complex game
> simpler, not overwhelm the player."

> "I don't like the humanoid kind of outline ... less eerie than the empty
> office, and that eeriness is the kind of vibe the game's going for."

Icons similar to Pip's own (godot/assets/icons/); every icon matches the
button it sits on. Alex rejected an earlier mock-up for: icons not matching
buttons, inconsistent alignment, inconsistent font sizes, things overlapping
and overflowing, and lost diegetic flavour. These are the defects to hunt.

## Read first

1. fork/design/hifi/brief.md -- the run's brief. Its "Higher fidelity
   means", "The states" and "Rules" sections bind you.
2. fork/design/hifi/run-state.md -- the one game you draw in every state.
   Use its numbers exactly. If the game disagrees with it, the game wins;
   say so in notes and in your final reply.
3. Your concept's history: fork/design/research/concepts/<L>/notes.md,
   concept.html, its renders and assets/; concepts/report.md (all rounds);
   council/concepts/r2s-agreed.md and r3x-agreed.md (agreed rules).
4. This repo's design skills: .claude/skills/game-ui/, game-tutorial/,
   ux-copy/ (read their SKILL.md and what they point to).
5. Before putting a number on screen: docs/game-design/decisions/ADR-0015
   and ADR-0001. For state 6: docs/art/PALETTE_AND_DOOM_INTENSITY.md.
6. Game data and art: godot/data/ (actions, events, balance), godot/assets/
   (images/backgrounds, images/events, office_floor, cats, icons).
   Paths in older files that start C:/Users/keech/Documents/pdoom1-lean-setup/
   research/ mean fork/design/research/; C:/Users/keech/Documents/pdoom1/
   means this checkout.

## What to build

Keep your concept's layout, fiction and everything the council agreed in
Rounds 2 and 3. Take it to finished, high-fidelity craft; this is the version
Pip will browse. Change structure only where a state needs a screen your
concept never drew (then draw it in the concept's own language).

In fork/design/hifi/<L>/ (create it; copy what you need from your old
folder -- do not edit fork/design/research/):

1. `concept.html`, self-contained (copied assets, relative paths, Google
   Fonts allowed, nothing else external). `?state=1` .. `?state=6` render the
   six states of run-state.md. The page draws a 1920x1080 stage and scales
   it uniformly to the window, the way the game does (project.godot:
   stretch mode canvas_items, aspect expand), so 1280x720 shows the same
   layout at 2/3 size.
2. `assets/` with only the art and icons you use (copies from godot/assets/
   plus your "new, needs art" drawings).
3. Renders, full size: `s1.png` .. `s6.png` at 1920x1080, and
   `s1-720.png` .. `s6-720.png` at 1280x720. These stay uncommitted.
4. Showcase images: `s1.webp` .. `s6.webp`, 1920 wide, about 300 KB each
   (quality ~80; check the text stays crisp). These get committed.
5. `notes.md`:
   - one paragraph per state: what the player sees and does, and how it
     follows from the state before;
   - **fixtures**: every value not from run-state.md's sourced lines or the
     data, and any place you followed the ADR over today's game (the
     Attention spill rule, at least);
   - **people**: every place a human figure appears (event pictures, Pip's
     Staff and Hire icons). Keep Pip's icons, add no new human figures;
   - **icons**: each icon used, its file and the button it sits on; the
     "new, needs art" list;
   - **bugs and data gaps** you met in the game or data (do not fix them);
   - **visual pass**: what you checked at both sizes and what you fixed.

## Rendering

Headless Chromium from Playwright's cache; one browser at a time, closed
after each batch; profile in your own scratch dir under /tmp, deleted after:

```
H=$(ls -d ~/.cache/ms-playwright/chromium_headless_shell-1254/*/chrome-headless-shell)
"$H" --no-sandbox --headless --disable-gpu --hide-scrollbars \
  --window-size=1920,1080 --virtual-time-budget=5000 \
  --user-data-dir="$SCRATCH/prof" --screenshot="$OUT/s1.png" \
  "file://$PWD/fork/design/hifi/<L>/concept.html?state=1"
```

WebP: Pillow is installed (`python3 -c "from PIL import Image ..."`), or
`convert` (ImageMagick). Do not install system packages. /tmp is a 16 GB
RAM disk shared with others: keep scratch small and delete it. If
~/.disk-low exists, stop rendering, delete your scratch, and report.

## Visual pass (every state, both sizes, before you report)

One type scale; aligned grids; consistent spacing; no overflow, overlap,
clipped text, scrollbars or placeholder text; operational text >= 16px at
1920; every icon matches its button and sits the same way in its group; no
person or operator silhouette anywhere; the office reads as empty and eerie;
numbers agree with each other and with run-state.md across all six states.
Look at every render yourself (open the PNG), and write a small DOM check in
the page or a script (text overflow, elements outside the stage, font sizes)
if it helps.

## Rules

- Write only in fork/design/hifi/<L>/. Everything else is read-only:
  godot/, scripts/, tools/, docs/, fork/design/research/, other designers'
  folders.
- No git commands that change anything (no add, commit, stash, checkout,
  push). The orchestrator commits.
- No mechanics: show the game's real rules and real content; do not invent
  numbers, actions, events or rules, and do not show what the game hides.
- ASCII only in the .md and .html text you write; no emoji.
- No subagents.
- Do not ask questions; the run is unattended. If a choice is Alex's or
  Pip's, pick the conservative option, and list it as an open question in
  notes.md.

## Final reply

1. What you built (one line per state) and the paths of the six WebPs.
2. Anything in run-state.md that the game contradicted.
3. Open questions for Alex or Pip.
4. **Disk report:** everything you wrote outside fork/design/hifi/<L>/
   (paths, sizes, whether it can go -- delete your own scratch first), and
   the size of fork/design/hifi/<L>/ split into committed-bound (html,
   notes, assets, webp) and uncommitted PNGs.

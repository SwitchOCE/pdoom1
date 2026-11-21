# Round 3 designer brief: icons and the empty office (A, C, E, G)

Alex has seen the Round 2 concepts. All four stay in contention; nothing is
cut. Keep your concept's layout, style and everything the council agreed in
Round 2 (research/council/concepts/r2s-agreed.md); change only what this
brief asks.

## Alex's words (verbatim)

> "Let's see if we can get them to work icons similar to Pip's original icons into the designs ... I don't like the humanoid kind of outline. I don't like that at all. I think we should get rid of those person, I think, is less eerie than the empty office, and that eeriness is the kind of vibe the game's going for. So, those designs are good still. I don't have any issues with them. I think they should remain in contention. But the person outlined and that can go and just we can leave that space."

## What to do (the orchestrating sessions' reading)

1. **No person anywhere.** Remove the operator silhouette (the placeholder
   person, chair-and-head shapes included) from every view: home, home-m1,
   actions, plan, door/upgrades, watch, and any other. Leave that area as
   empty office art. Do not fill it with new UI or panels; Alex will decide
   its use later. You may suggest a use in notes.md, one line, not drawn.
2. **Pip's icons.** Use Pip's own icon set from the game wherever one exists:
   C:/Users/keech/Documents/pdoom1/godot/assets/icons/ (actions_*/,
   resources/, main_navigation/, employee_roles/, status/, doom_meter/,
   risk_indicators/, and the root money/compute/research/reputation/doom/paper
   PNGs; about 255 PNGs). godot/data/icon_mapping.json says which icon the
   game uses for what, but some mappings are shared or wrong -- you decide
   by what the icon shows. Copy what you use into your concept's assets/.
   - Every icon must match the button or label it sits on (Alex's round-1
     complaint was icons that no longer matched their buttons). If no icon in
     the set fits, draw one in the same style (size, line weight, palette) and
     list it in notes.md as "new, needs art". Do not use a wrong icon.
   - Use icons consistently: the same thing gets the same icon in every view;
     one size per kind of place (e.g. all shortcut buttons the same size);
     align them the same way within a group.
   - Icons sit beside their labels; they never replace a label (names and
     costs stay readable, 16px floor for anything operated).
   - Keep the home screen sparse; icons go on existing buttons and labels, they
     do not add new elements.
3. **Re-render the same views** you have now (same file names), redo the
   visual quality pass from research/concepts/brief.md on every render, and
   add a "Round 3" list to notes.md: what you removed, which Pip icons you
   used where (file names), which icons are "new, needs art", and anything
   you could not do.

Your current home.png is already copied to round2-home.png in your
folder (the before image for this round); leave that file alone.

Same rules as before: write only in your own folder; C:/Users/keech/Documents/pdoom1
is read-only; no subagents; no mechanics changes. Finish with a disk report
(what you wrote inside and outside your folder, sizes, what can be deleted).

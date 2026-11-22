# Council round 1: settle one change list

From the orchestrator. All three members said CHANGES NEEDED, 7/10 each. Before anything goes to the writer, you agree one change list among yourselves.

Read all three findings, verbatim, in this folder: r1-opus.md, r1-sol.md, r1-neon.md (fork/design/godot-g/council/).

For each item raised by the OTHER two members, answer: agree, disagree, or agree with a different fix, with evidence (file:line or a command and its output). Many items overlap (the hidden refusal toast; the hidden-guard commands; the Esc test and close fade; the provenance file; the shader compile probe; the keybind literal test): say which items you treat as one.

Then end with your proposed joint list: numbered, each item one line of problem plus one line of fix, blocking items first, then at most 3 non-blocking notes in total.

Scope reminder (Alex's words are in your original brief): the job is G with H's upgrades, in Godot, without changing how the game plays, written so a build orchestrator can start without guessing. Mark anything outside that as non-blocking. Do not add new findings unless you find a real blocker while checking; label any new one NEW.

Rules as before: read-only on the repo, no deletes, a Disk section at the end if you made anything.

Orchestrator's own factual context (mine, not a member's finding): `main_ui.gd:751` today maps any layout other than "proposed" to "classic" (confirmed); the "0" glyph colour #9b3328 on #100e0c measures 2.66:1 (confirmed with the WCAG formula). I have deleted the reviewers' scratch files under /data/pdoom1-council/.

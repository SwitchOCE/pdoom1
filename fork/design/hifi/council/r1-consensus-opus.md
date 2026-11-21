# Round 1 consensus -- opus

## On the other members' blocking items

**Sol, all four, state 4: Standard Hiring also costs 1 held hr.** Agree.
The orchestrator confirmed it in event_dialog.gd (~100-112): a handled
option with no `attention` of its own takes the window's price; Decline
shows none. Fix in A, C, E and G s4, run-state.md and the state 4 caption.
State 5 does not change (Fast-Track was picked: 7 held, 1 used, 6
evaporated).

**Sol, A2 / E2 / G2: NEW chips on Safety Audit and Strategic.** Agree. I
checked the code. `turn_min` counts workdays (actions.gd:98,
state.turn), so Safety Audit (turn_min 5) opens in July's second week, not
November. Strategic (turn_min 10, reputation_min 30) would open in July
too at rep 50, unless reputation dipped below 30 first. Its fanfare fires
only the first time it is seen unlocked (action_bar_renderer.gd:140).
Nothing in this run shows a November unlock. Fix: drop NEW from A, E and G
s2, and E's "new this month" in the detail strip. C already leaves them
off. Correct run-state.md.

**Sol, A1 / C1 / E1 / G1: 16px floor at 1280x720.** Disagree that it
blocks. The game itself scales its 1920x1080 canvas uniformly
(project.godot: canvas_items, expand), so 720p in the game looks just like
these renders. The r2s floor was set on the 1920 reference canvas.
Re-typesetting four concepts per viewport would be a redesign of the type
system, not a fidelity fix. Settle it as: the floor applies at 1920x1080. The
showcase gets one line: "1280x720 is a uniform 2/3 scale, as in the game."
Non-blocking. Raising text size at small windows is a question for Pip.

**Sol, A3: state 5 mixes play numbers and the event date in one column.**
Agree. A/s5 numbers the plays 01-11, then puts "14" (a date) on the Talent
Opportunity row, so the event reads as play 14. Fix: give that row "14 Nov"
in its own date style, or no number. (State 4's feed dates are fine.)

**Neon, A1: the state 4 slip leaves out the option effects.** Agree. The
data has `effects: {safety_researchers: 1}`, and C, E and G print "+1
safety researcher" / "no change". Fix: add the effect to each A s4 row.
Sol's A3 asks the same.

**Sol, C2: state 1 Advisor owns Esc while Commit shows Enter.** Agree. I
had this as non-blocking, but it breaks rule 2 in the same way I blocked E
s3 for. Fix: an x close with no Esc (as A, E and G do), or hide Commit's
Enter while the note is up.

**Sol, C3a: dotted empty frames in C s2.** Agree. The dashed slots in
Funds, Outreach and The Lab look like placeholders, and the brief rules
those out. Fix: leave the slots plain.

**Sol, C3b: Publish Safety Paper icon.** Disagree that it blocks. C uses
Pip's own mapping (icon_mapping.json:25, `publish_paper` ->
formal_verification). Pip's note there says "needs dedicated publish_paper
icon". Faithful to Pip; non-blocking, and it goes on the "new, needs art" list.

**Sol, E3: Commit Enter in state 3; the "AFTER COMMIT" receipt.** Agree
with both. The Enter half is my E1. Neon reads rule 2 as allowing it
because the Plan owns no Enter. But rule 2's first sentence says "only the
topmost open layer shows Enter and Esc", and A, C and G hide it here. The
receipt is headed AFTER COMMIT but prints reputation 26 and research -12,
while s4 shows 34 and -6. REVISION 2 says to label it "after costs". Fix:
retitle it "AFTER COSTS" and mark -12 as current research.

**Sol, E2b: Enter shown twice in state 2.** Agree. It is cheap, and it sits
in the same state as the NEW fix. Keep Enter in one place.

**Sol, G3: G s3 shows Read the Literature x2 collapsed.** Disagree that it
blocks. r2s rule 4 allows "a group that expands on click into one row per
play", and G's `+` does that (`&expand=read`). Non-blocking, as Neon says.

**Sol G4 / Neon G1: Reserve gated on operating hours.** Agree. This is my
G2, so all three members agree.

**Neon, C1: the P(Doom) counter is dimmed under `.dim`.** Agree. In C/s5,
"56.7%" and SEVERE sit behind the 0.55 scrim right as the review announces
the band move; A, E and G keep their instruments lit. Fix: raise the wall
strip (at least the counter) above `.dim`.

**Neon, G2: violet held-hours pips.** Agree, so it moves up from my
non-blocking list. G's own notes contradict it ("Purple appears only here",
s6), and it is one token (`--held`). G's aubergine rail and E's purple dial
housing stay non-blocking: they are chrome, and Pip's own button style uses
aubergine (theme_manager.gd:408).

**Neon, C non-blocking 3 / my C1: Work Your Connections "done".** I still
say it blocks, as a low-cost item. The game has the message
(hiring_pipeline.gd:157), A and E print it, and run-state asks for it. In
the side-by-side view, C reads differently from the others for the same
play. If the others won't take it, I accept non-blocking.

**My G1: the feed tail changes between s4 and s5.** I keep it, as a cheap
consistency fix. If both members object, I accept non-blocking.

**Showcase.** The orchestrator owns these: E's caption, lightbox fit,
focus, link labels, the report.md link and publishing linked files. Add the
720p line above and Standard Hiring's hour to the state 4 caption.

## Proposed joint list

### All four
1. State 4: Standard Hiring shows $25,000 + 1 held hr (A, C, E, G); fix
   run-state.md and the caption.

### A
1. s2: drop the NEW clips on Safety Audit and Strategic.
2. s4: add each option's effect (+1 safety researcher x2, no change).
3. s5: the Talent Opportunity row gets "14 Nov" (or no number), not "14" in
   the play-number column.

### C
1. s1: Advisor closes with an x, no Esc (or Commit hides Enter while it
   shows).
2. s2: remove the dotted empty slot frames.
3. s2, s3, s5: P(Doom) counter and wall strip sit above the dim.
4. s4, s5: Work Your Connections uses the game's message (low cost; drop
   to non-blocking if two members object).

### E
1. s2: drop NEW and "new this month"; one Enter only.
2. s3: hide Commit's Enter while the CRT is open; retitle the receipt
   "AFTER COSTS" and mark -12 as current research.

### G
1. s2: drop the NEW chips.
2. s3: Reserve is live and untyped (up to 7 hr); keep the main_ui/core
   mismatch in the notes as a bug for Pip.
3. s3-s5: `--held` becomes a non-purple token.
4. s4, s5: feed lines in queue order, the same tail in both states (drop to
   non-blocking if two members object).

### Showcase (orchestrator)
E's caption; lightbox fit and focus; link labels; publish or drop the
linked .md and concept.html files; add "1280x720 is a uniform 2/3 scale,
as in the game"; state 4 caption with Standard Hiring's hour.

### Non-blocking (dropped from blocking)
- The 16px floor at 720p (all four).
- C's Publish Safety Paper icon (Pip's mapping).
- G s3's collapsed Read the Literature group (allowed by rule 4).
- E's purple dial housing and G's aubergine rail (chrome; Pip's call).

## Scores (revised)
A 8.5/10 . C 8/10 . E 8/10 . G 7.5/10
(Down from round 1 because of the shared items I missed: Standard
Hiring's hour, the NEW chips, A's missing effects and C's dimmed counter.
Every item above is small enough for one fix round.)

# Council round 1: agreed fix list

Sources: r1-{opus,sol,neon}.md and r1-consensus-{opus,sol,neon}.md.
Unanimous unless marked "majority". Three items were split; each is settled
by the 2-1 majority of the members' stated positions (Opus said it accepts
the majority on its split item). Members confirm in the re-check.

Scores after consensus (/10, showcase-ready, not a ranking):
opus A 8.5 . C 8 . E 8 . G 7.5; sol A 7.5 . C 8 . E 7.5 . G 7.5;
neon A 8 . C 8 . E 8.5 . G 7.5.

## All four (A, C, E, G)
1. State 4: Standard Hiring shows **$25,000 + 1 held hr** (event_dialog.gd
   folds the window's Attention price into handled options without their
   own; Decline stays free). Fast-Track stays the choice; state 5 is
   unchanged. Update notes that list this as an open question.
   (run-state.md REVISION 3.)

## A. The Desk
1. s2: drop the NEW clips on Safety Audit and Strategic (their gates count
   workdays; nothing shows a November unlock).
2. s4: each option shows its effect: "+1 safety researcher" on both hiring
   options, "no change" on Decline.
3. s5: the play list no longer shares a numbered column with the event's
   date: label the Commit block "1 Nov / at Commit" and give Talent
   Opportunity its own "14 Nov".

## C. The Paperwork Desk
1. s2, s3, s5 (and check s4): the P(Doom) counter and band (at least the
   wall strip) sit above the dimmer and stay legible.
2. s1: the Advisor note closes with a plain button or x, no Esc keycap (or
   the note owns focus and Commit hides Enter).
3. s2: remove the dotted empty card frames in Funds, Outreach and The Lab;
   leave those positions plain. (majority: opus, sol)
4. s4, s5: Work Your Connections prints the game's message: "Reached out
   through your network -- a pre-vetted lead may surface shortly."
   (hiring_pipeline.gd:157). (majority: opus, neon)

## E. Rooms and Stations
1. s2: drop NEW on Strategic and "new this month" on Safety Audit; show
   Enter once for the focused Safety Audit.
2. s3: hide Commit's Enter while the Plan CRT is open (it owns Esc).
3. s3: retitle the printout "AFTER COSTS" and label -12 as current research
   ("Research (now)").

## G. The Existing UI, Modernised
1. s2: drop the NEW chips on Safety Audit and Strategic.
2. s3: Reserve is live and untyped (up to 7 hr; enable "Reserve hours [R]",
   drop "(needs operating hours)"); keep the main_ui vs core mismatch in
   the bugs list for Pip.
3. s3: show Read the Literature as two individual rows in the still (no
   group row), with all 11 plays visible and Order Office Supplies above
   the fold. (majority: sol, neon)
4. s3-s5: --held becomes a non-purple neutral token; purple only in s6.
5. s4, s5: the Wed 1 Nov feed lines follow queue order from one shared
   list, and the same lines read the same in both states.

## Showcase page (orchestrator)
E's caption; state 4 caption (Standard Hiring's hour); lightbox fits the
viewport; keyboard-focusable thumbnails with focus in and out of the
lightbox; "HTML mock-up" label; a line that 1280x720 is a uniform 2/3 scale
as in the game; linked .md / concept files resolve in the published bundle
(or the links are dropped).

## Non-blocking (agreed)
- The 16px floor at 1280x720 (the game scales its canvas the same way; the
  floor applies at 1920x1080).
- C's Publish Safety Paper icon (Pip's own mapping; on the needs-art list).
  (majority: opus, neon)
- E's purple dial housing and G's aubergine rail (chrome; Pip's call).
- All other non-blocking notes in the r1 answers.

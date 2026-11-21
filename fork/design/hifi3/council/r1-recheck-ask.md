# hifi3 council round 1: re-check after the fix round

You are one of three members (opus, sol, neon). The fix round applied the
agreed list (council/r1-agreed.md) at commit d27d06bb:
- designer A: section 1 (the sound: replay guard inside the block, the
  tuning, the 44.1 kHz WAV, spec 3.3 and 6.3) and section 2 (spec fixes).
  H's renders were not redone (nothing visible changed). H/notes.md has a
  "hifi3 fix round" section.
- designer C: 4.1 (state 3 clamp; s3 re-rendered at both sizes).
- designers C, E, G: 5.1 (H's new block copied byte for byte -- the four
  blocks hash the same -- and each control locked until onDone).
- orchestrator: section 3 (converter joins list continuations; inline code
  wraps in the spec; the page demo locks its button in both motion
  settings and ignores clicks while TypeSound.busy(); page rebuilt with the
  new spec and block). Checked: no raw ** or backticks outside code; no
  page-level horizontal scroll at 320, 390 and 1440 px.

Note from the designers: under headless Chromium's virtual time the audio
clock does not advance, so TypeSound.busy() can read true after onDone in
a virtual-time test; in real time (G tested it) the button returns and a
new play starts.

1. Check every item in r1-agreed.md: done or not, with evidence. Check
   that the fixes broke nothing nearby.
2. **neon:** listen to the new fork/design/hifi3/H/dateline-sound.wav
   (44.1 kHz) and give a "## Listening" verdict: closer to the spy-film
   title-card strike or not, and anything that still sounds wrong.
   **opus, sol:** review the new sound code.
3. Scope as in round1-ask.md: new findings are blocking only if they are
   real defects of the kinds named there.

Answer format as in round1-ask.md (VERDICT, scores per item, blocking
items, at most 3 non-blocking). Write to
fork/design/hifi3/council/r1-recheck-<your name>.md and reply with the
same text. Read-only otherwise; close any Chromium you start.

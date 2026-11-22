# hifi3: resume notes (orchestrator)

If the orchestrator session dies, a new one can carry on from here.

Brief: fork/design/hifi3/brief.md (from Alex's PC session, ee011682), plus
the correction: Neon can hear audio, so H's sound is rendered to
H/dateline-sound.wav and Neon listens to it in the council round.

Steps:
1. Designer A finishes H in hifi3/H (designer-brief-H.md PASS 1), incl.
   the sound (between SOUND_START / SOUND_END in H/concept.html) and the
   WAV. Checkpoint commit + push.
2. Then in parallel: A writes spec.md (PASS 2); C, E, G retexture
   (designer-brief-CEG.md) in hifi3/<letter>/.
3. Orchestrator builds index.html: `python3 fork/design/hifi3/build_page.py`
   (page.src.html + spec.md + the sound block + demo.js).
4. One council round (all three), consensus, one fix round, re-check opus
   and sol, then neon last. Report in hifi3/report.md, summary on top.
5. Delete fork/design/hifi2/H/*.png once hifi3 is pushed.

Threads (all in the T3 project, delegated-task ids):
- designer A 02a86f5e-959b-47e1-a695-cd3c5fb3d92e
- designer C 948c8668-0e8c-41c4-acae-2e7c9ab69e34
- designer E 4d9dfd71-6fa4-4dcf-8ca4-0daf262c3c9e
- designer G dee22ff0-9633-40a9-b61a-e560d2758d89
- council opus a6ebb49e-1bef-4908-8faa-bac63ee44a1d
- council sol c890abfe-9d7d-4d19-9803-546e65f3f694
- council neon a50972c9-3484-4b42-bf2f-d7c0a673b953

## Addendum round (brief.md "## Addendum (2026-11-22)")

- designer A: revised H (designer-brief-H2.md), PASS 1 then spec PASS 2.
- designer G: H-HF (designer-brief-HF.md), starts when H2 is done.
- designer E: the mixer (designer-brief-mixer.md): frame + C/E/G now,
  H pieces when H2 is done, H-HF pieces when H-HF is done.
- orchestrator: page update (H, H-HF, C/E/G "earlier texture", band
  strip, resource takes side by side, mixer link), then the council round
  (round2-ask.md), one fix round, re-check opus+sol then neon, report.
- HighFleet refs: research/reference-games/shots/highfleet-1..8.jpg
  (uncommitted, excluded).

Done 2026-11-22: council round 2, fix round and re-check all GOOD TO GO;
report.md has the hand-off. Nothing left to resume.

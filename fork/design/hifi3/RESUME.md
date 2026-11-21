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

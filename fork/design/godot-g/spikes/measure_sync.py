"""Compare actual bright glyph pixels with mixed PCM in the same 60 FPS AVI."""
import csv
import re
import subprocess
import sys
import wave
from pathlib import Path

import numpy as np

FPS = 60
MIX_RATE = 48000
ROI_WIDTH = 360
ROI_HEIGHT = 36
STRIKE = re.compile(
    r"STRIKE index=(\d+) ascii=(\d+) frame=(\d+) variant=(\d+) pitch=([\d.]+) db=([-\d.]+)"
)


def decode(movie, *options):
    return subprocess.check_output(["ffmpeg", "-nostdin", "-v", "error", "-i", str(movie),
                                    *options, "-"])


def read_picture(movie):
    video = decode(movie, "-an", "-vf", f"crop={ROI_WIDTH}:{ROI_HEIGHT}:24:8",
                   "-pix_fmt", "gray", "-threads", "1", "-f", "rawvideo")
    frames = np.frombuffer(video, dtype=np.uint8).reshape(-1, ROI_HEIGHT, ROI_WIDTH)
    ink = (frames >= 140).any(axis=1)
    right_edge = np.where(ink, np.arange(ROI_WIDTH), -1).max(axis=1)
    changes = np.flatnonzero(np.diff(right_edge, prepend=-1) > 3)
    return changes, right_edge


def find_strike(audio, sample_file, pitch, visual_frame):
    with wave.open(str(sample_file), "rb") as source:
        rate = source.getframerate()
        raw = np.frombuffer(source.readframes(round(rate * .016)), dtype="<i2").astype(float)
    # Approximate the engine's pitch resampling. Correlation identifies the
    # beginning of the waveform even when a previous strike's room tail is mixed.
    step = rate * pitch / MIX_RATE
    template = np.interp(np.arange(0, raw.size - 1, step), np.arange(raw.size), raw)
    expected = round(visual_frame * MIX_RATE / FPS)
    radius = round(MIX_RATE * .048)
    lo = max(0, expected - radius)
    segment = audio[lo:expected + radius + template.size]
    energy = np.concatenate(([0.0], np.cumsum(segment ** 2, dtype=float)))
    energy = energy[template.size:] - energy[:-template.size]
    similarity = np.correlate(segment, template, mode="valid") / (
        np.linalg.norm(template) * np.sqrt(np.maximum(energy, 1e-20))
    )
    best = int(np.argmax(similarity))
    return lo + best, similarity[best]


def measure(work, clip, writer):
    movie = work / "movies" / f"{clip}.avi"
    events = STRIKE.findall((work / "logs" / f"{clip}.log").read_text())
    reveal_frames, edge = read_picture(movie)
    audio = np.frombuffer(decode(movie, "-vn", "-ac", "1", "-ar", str(MIX_RATE),
                                 "-f", "f32le"), dtype="<f4")
    skipping = clip.endswith("-skip")
    assert len(events) == (5 if skipping else 14), events
    assert len(reveal_frames) == len(events) + int(skipping), reveal_frames
    offsets = []
    for event, visual_frame in zip(events, reveal_frames):
        index, ascii_code, _, variant, pitch, _ = event
        sample_file = work / "project" / "assets" / "sfx" / f"key-{variant}.wav"
        sample, similarity = find_strike(audio, sample_file, float(pitch), visual_frame)
        assert similarity >= .75, (clip, event, similarity)
        visible_ms = visual_frame * 1000 / FPS
        audio_ms = sample * 1000 / MIX_RATE
        offset = audio_ms - visible_ms
        offsets.append(offset)
        writer.writerow([clip, index, chr(int(ascii_code)), visual_frame, f"{visible_ms:.3f}",
                         sample, f"{audio_ms:.3f}", f"{offset:+.3f}", f"{similarity:.3f}"])

    print(f"# {clip} count={len(offsets)} mean_signed_ms={np.mean(offsets):+.3f} "
          f"mean_abs_ms={np.mean(np.abs(offsets)):.3f} "
          f"max_abs_ms={np.max(np.abs(offsets)):.3f}")
    if skipping:
        skip_frame = reveal_frames[-1]
        bright_after = int(np.min(edge[skip_frame:]))
        assert bright_after == edge[skip_frame], edge[skip_frame:]
        # Stopping the players can have a short mixer ramp. Check the sustained
        # silence separately from the callback's active-player count.
        last_audible = int(np.flatnonzero(np.abs(audio) > 1e-4)[-1])
        stop_ms = (last_audible / MIX_RATE - skip_frame / FPS) * 1000
        assert stop_ms < 50, stop_ms
        print(f"# skip_reveal_frame={skip_frame} remaining_glyphs_appear_together=true "
              f"last_audio_minus_reveal_ms={stop_ms:+.3f} cutoff=-80dBFS")
    return edge[-1]


if __name__ == "__main__":
    writer = csv.writer(sys.stdout, lineterminator="\n")
    writer.writerow(["clip", "character_index", "character", "video_frame", "visible_ms",
                     "audio_sample", "audio_ms", "audio_minus_visible_ms", "correlation"])
    work = Path(sys.argv[1])
    full_edge = measure(work, "dateline", writer)
    skip_edge = measure(work, "dateline-skip", writer)
    assert full_edge == skip_edge, (full_edge, skip_edge)

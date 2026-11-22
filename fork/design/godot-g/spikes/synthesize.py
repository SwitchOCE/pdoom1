"""Re-render the five TypeSound strike layers and its bell-free carriage."""
import math
import sys
import wave
from pathlib import Path

import numpy as np

RATE = 44100
FLOOR = 0.0001
ROOM_SECONDS = 0.7


def count(seconds):
    return round(seconds * RATE)


def envelope(length, attack, peak, decay):
    samples = np.arange(length)
    return np.interp(samples, [0, count(attack), count(attack + decay)],
                     np.log([FLOOR, peak, FLOOR]), right=-np.inf)


def biquad(signal, kind, frequency, q):
    omega = 2 * np.pi * np.asarray(frequency) / RATE
    cosine = np.cos(omega)
    alpha = np.sin(omega) / (2 * q)
    if kind == "low":
        b0, b1, b2 = (1 - cosine) / 2, 1 - cosine, (1 - cosine) / 2
    elif kind == "high":
        b0, b1, b2 = (1 + cosine) / 2, -(1 + cosine), (1 + cosine) / 2
    else:
        b0, b1, b2 = alpha, np.zeros_like(alpha), -alpha
    coeffs = [np.broadcast_to(c / (1 + alpha), signal.shape)
              for c in [b0, b1, b2, -2 * cosine, 1 - alpha]]
    result = np.empty_like(signal)
    x1 = x2 = y1 = y2 = 0.0
    for i, (x, b0, b1, b2, a1, a2) in enumerate(zip(signal, *coeffs)):
        y = b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2
        result[i] = y
        x1, x2, y1, y2 = x, x1, y, y1
    return result


def noise(rng, kind, hz, q, attack, peak, decay):
    length = count(attack + decay)
    return (biquad(rng.uniform(-1, 1, length), kind, hz, q)
            * np.exp(envelope(length, attack, peak, decay)))


def tone(f0, f1, glide, attack, peak, decay):
    length = count(attack + decay)
    glide_progress = np.minimum(np.arange(length) / count(glide), 1)
    pitch = f0 * (f1 / f0) ** glide_progress
    radians = np.cumsum(pitch) * (math.tau / RATE)
    return np.sin(radians) * np.exp(envelope(length, attack, peak, decay))


def add(target, waveform, start):
    index = count(start)
    target[index:index + waveform.size] += waveform


def strike(rng):
    sound = np.zeros(count(0.08))
    strength = rng.uniform(.85, 1.15)
    clack_pitch = rng.uniform(.94, 1.06)
    thump_pitch = rng.uniform(.975, 1.025)
    add(sound, noise(rng, "high", 4500 * clack_pitch, .7, .0005, .8 * strength, .009), 0)
    add(sound, noise(rng, "band", 2900 * clack_pitch, 1.4, .001, .85 * strength, .025), 0)
    add(sound, tone(170 * thump_pitch, 62 * thump_pitch, .04, .002, .68 * strength, .045), 0)
    add(sound, noise(rng, "band", 900 * clack_pitch, 4, .003, .12 * strength, .07), .004)
    add(sound, noise(rng, "band", 3900 * clack_pitch, 14, .001, .20 * strength, .012), .017)
    return sound


def carriage(rng):
    sound = np.zeros(count(.59))
    length = count(.24)
    cutoff = 550 * (1750 / 550) ** np.minimum(np.arange(length) / count(.22), 1)
    slide = biquad(rng.uniform(-1, 1, length), "low", cutoff, 2)
    shape = np.interp(np.arange(length), [0, count(.18), length], np.log([FLOOR, .27, FLOOR]))
    add(sound, slide * np.exp(shape), 0)
    add(sound, tone(95, 42, .12, .003, 1.0, .32), .24)
    add(sound, noise(rng, "band", 300, 1, .002, .4, .08), .24)
    return sound


def finish(dry, impulse):
    length = dry.size + impulse.size - 1
    fft_length = 1 << (length - 1).bit_length()
    reverb = np.fft.irfft(np.fft.rfft(dry, fft_length) * np.fft.rfft(impulse, fft_length))[:length]
    signal = np.pad(dry, (0, length - dry.size)) + 0.23 * reverb
    attack = math.exp(-1 / count(.002))
    release = math.exp(-1 / count(.120))
    level = 0.0
    for i, sample in enumerate(signal):
        magnitude = abs(sample)
        coefficient = attack if magnitude > level else release
        level = coefficient * level + (1 - coefficient) * magnitude
        excess_db = max(20 * math.log10(max(level, FLOOR)) + 18, 0)
        signal[i] = sample * 0.84 * 10 ** (-0.75 * excess_db / 20)
    # Attenuate only if a render would exceed the asset ceiling.
    peak = max(abs(signal))
    return signal * min(1, 10 ** (-1.5 / 20) / peak)


def main(destination, reference):
    with wave.open(str(reference), "rb") as source:
        assert (source.getnchannels(), source.getsampwidth(), source.getframerate()) == (1, 2, RATE)
        print(f"Reference {source.getnframes()} samples at {RATE} Hz, mono PCM16")
    rng = np.random.default_rng(1917)
    length = count(ROOM_SECONDS)
    tail = rng.uniform(-1, 1, length) * (1 - np.arange(length) / length) ** 4
    tail = biquad(tail, "low", 2500, .7)
    tail /= np.linalg.norm(tail)
    destination.mkdir(parents=True, exist_ok=True)
    clips = {f"key-{i}.wav": strike(rng) for i in range(6)}
    clips["carriage.wav"] = carriage(rng)
    for name, dry in clips.items():
        samples = finish(dry, tail)
        path = destination / name
        with wave.open(str(path), "wb") as target:
            target.setparams((1, 2, RATE, len(samples), "NONE", "not compressed"))
            target.writeframes(np.round(samples * 32767).astype("<i2").tobytes())
        print(f"{name} {path.stat().st_size} bytes {len(samples) / RATE:.3f} s "
              f"{20 * math.log10(np.max(np.abs(samples))):.2f} dBFS")


if __name__ == "__main__":
    main(Path(sys.argv[1]), Path(sys.argv[2]))

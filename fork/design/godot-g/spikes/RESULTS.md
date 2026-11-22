# Godot 4.5.1 spike results

All three spikes ran on Linux under Xvfb with the official
`4.5.1.stable.official.f62fdbde1` binary. Run from the repository root:

```bash
bash fork/design/godot-g/spikes/run.sh all
```

The runner stages the project under `/data/pdoom1-spikes/project`, isolates
Godot's profile, checks the pinned font files, and writes logs and captures
under `/data/pdoom1-spikes`. It needs Xvfb, curl on a cold font cache,
Python 3 with NumPy, and FFmpeg.

## 1. Doom room layer

[doom_layer.gdshader](doom_layer.gdshader) and [main.gd](main.gd) apply a
single CanvasItem material to the same `office_wide_day.webp` used by
`main.tscn`. H's mock-up uses the dawn variant. The material samples the
art once and applies H section 2.4's seven brightness, saturation,
contrast, tint, vignette, and grain steps. Its floating-point `band`
uniform blends those steps. The benchmark toggles the material on the
same unmodulated backdrop. The window, monitor glow, smut, and late-band
art layers are outside this spike.

```bash
bash fork/design/godot-g/spikes/run.sh shader
bash fork/design/godot-g/spikes/run.sh shader-compat
```

| Run at 1920 x 1080 | Driver | Adapter |
|---|---|---|
| Project default, Forward+ | Vulkan 1.4.335 | llvmpipe (LLVM 21.1.8, 256 bits), vendor reported Unknown |
| Forced Compatibility | OpenGL 4.5 Core, Mesa 26.0.8 | llvmpipe (LLVM 21.1.8, 256 bits), vendor Mesa |

The verbose Vulkan log reports `No DRI3 support detected - required for
presentation` and lists the Intel UHD Graphics 630 as unsupported for
this Xvfb run. It selected the CPU device while keeping Vulkan.
Compatibility rendered the graded room and tween on software OpenGL.

| Forward+ wall-clock frame time | Frames | Mean | p95 |
|---|---:|---:|---:|
| Plain backdrop | 240 | 21.977 ms | 32.622 ms |
| Graded backdrop, band 3 | 240 | 31.700 ms | 51.571 ms |

VSync was disabled. Each run of 120 samples followed 45 warm-up frames,
in plain, shader, shader, plain order. Forward+ sampled average RGB luma
of 0.1749, 0.0609, and 0.0138 at bands 0, 3, and 6. The 400 ms tween from
0 to 3 rendered luma 0.1036 at uniform 1.737. Compatibility rendered the
same ordering and an intermediate luma of 0.1123 at uniform 1.517.

[Band 0](shots/room-0.webp) | [Band 3](shots/room-3.webp) | [Band 6](shots/room-6.webp)

On Alex's desktop, compare plain and graded versions of the full UI at
1920 x 1080 on the GPU, with the same resolution and VSync settings.
Check the terminal grade with the production monitor, window, and fire
lighting in place. The day art was already very dark at band 6 without
those lights. The table measures wall-clock frames under llvmpipe.

## 2. Type steps and bundled faces

[base_theme.tres](base_theme.tres) is copied unchanged.
[theme_manager.gd](theme_manager.gd) retains the game's size methods,
offsets, and fallback. It leaves out the palette, theme settings and
persistence, and UI factory and styling methods. The specimen theme
makes IBM Plex Sans the default and assigns the other three faces to
named Label variations. The variation sizes come from
`ThemeManager.get_font_size()`.

```bash
bash fork/design/godot-g/spikes/run.sh font
```

| Token | Logical px | Face | TTF bytes |
|---|---:|---|---:|
| small | 15 | IBM Plex Mono Medium | 136,704 |
| body | 19 | IBM Plex Sans Regular | 207,768 |
| header | 27 | Courier Prime Bold | 72,856 |
| title | 35 | Barlow Condensed SemiBold | 109,428 |

All four imported as FontFile resources under SIL OFL 1.1. Pinned
upstream URLs and SHA-256s are in [assets.tsv](assets.tsv), with the
[license texts](licenses/) beside the project. The 4.5.1 importer used
grayscale antialiasing, light hinting, and Auto subpixel positioning for
these faces. Its setting is Auto Except Pixel Fonts. Forced autohinting,
mipmaps, and MSDF were off. [Godot font importer reference](https://docs.godotengine.org/en/4.5/classes/class_resourceimporterdynamicfont.html)

The steps stayed at 15 / 19 / 27 / 35 in the 1920 x 1080 logical viewport
of both windows. At 1280 x 720, the specimen stayed sharp enough to read
in isolation, but the small row has a 10-pixel-tall band of ink including
descenders. Test dense UI copy at that window size. Small is already one
logical pixel below H's 16 px floor, and the production token set has no
22 px step.

[1920 x 1080](shots/font-1920.webp) | [1280 x 720](shots/font-1280.webp)

## 3. Dateline strikes

[synthesize.py](synthesize.py) re-renders H's TypeSound recipe with
NumPy 2.3.5 and Python's wave module, using H's WAV as the source
reference. The six variants each have five sound layers, baked room
tail and compression. Each is 68,838 bytes (0.780 s), with peaks from
-4.95 to -1.80 dBFS. The bell-free slide and stop is 113,820 bytes
(1.290 s), peaking at -3.88 dBFS. Total 526,848 bytes, mono 44.1 kHz
PCM16 WAV. Godot's default import used Quite OK Audio compression.

[dateline.gd](dateline.gd) uses one Tween to reveal a glyph and schedule
its strike in the same callback. Spaces are silent. All strikes and the
carriage use bus 1, SFX, copied from the game. Godot 4.5.1's
AudioStreamRandomizer playback consumes the engine's global RNG even at
neutral pitch and volume settings. The spike stores the WAV variants in
that resource, then uses a local RandomNumberGenerator to pick the WAV
and set player pitch and volume. Use this routing if the build must
preserve the engine's global RNG sequence.
[Godot 4.5.1 randomizer source](https://github.com/godotengine/godot/blob/4.5.1-stable/servers/audio/audio_stream.cpp)

```bash
bash fork/design/godot-g/spikes/run.sh dateline
```

[measure_sync.py](measure_sync.py) read glyphs from actual 60 fps Movie
Maker frames and cross-correlated their strikes in the same capture's
48 kHz PCM. The 14 audible characters had mean audio lag **5.042 ms**
and max **11.375 ms**. Each was within one video frame. Offsets in ms,
in print order:

| Glyph | N | O | V | E | M | B | E | R | 1 | comma | 2 | 0 | 1 | 7 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Audio minus picture | +3.375 | +5.375 | +2.708 | +4.708 | +11.375 | +1.375 | +9.375 | +5.375 | +5.375 | +2.708 | +2.708 | +3.375 | +5.375 | +7.375 |

The duplicate request for the same date was ignored while typing and
during the carriage tail. A different date requested mid-animation
stopped the players and displayed the new date whole. The separate Space
test triggered after five strikes and revealed the full date in one frame,
with zero remaining players or later strikes. The old mixed tail dropped
below -80 dBFS about 19.2 ms after that frame.

Movie Maker with the Dummy driver measures the generated picture and
Godot's software mix on the same timeline. The visual measurement has
16.7 ms frame granularity. Check speaker latency, mix level and sync under
load on Alex's normal audio driver.
[Godot Movie Maker reference](https://docs.godotengine.org/en/4.5/tutorials/animation/creating_movies.html)

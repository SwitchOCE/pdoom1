P(Doom) -- G desk test build
============================

What this is
------------
A Windows build of P(Doom) with the G desk: an optional, simpler main screen
for the same game. Made by Alex (SwitchOCE) with Claude, from Alex's fork:

  https://github.com/SwitchOCE/pdoom1  branch lean, commit 431ea001

Base: your main at 4119ddcb (v0.14.5). Exported with Godot 4.5.1, preset
"Windows Desktop", release mode.

Not 0.15.0: the code has had a text merge only, against your main at
9ef96f64 (v0.15.0). It has not been booted or tested on 0.15.0, alone or with
skins (#1372).

How to run
----------
Unzip to a folder you can write to and keep the files together. Then:

1. play-separate-profile.bat (recommended). It starts PDoom.exe with its own
   profile folder, "profile", next to the exe, so your normal profile is not
   touched. It does this by setting APPDATA for this one run: Godot keeps
   user:// under %APPDATA% on Windows, and your scripts/run_godot_tests.py
   notes "Only APPDATA works on Windows". Tested on Windows 11: the game's
   user folder is created next to the exe and the normal profile is
   untouched.

2. PDoom.exe on its own uses your normal profile:
     %APPDATA%\Godot\app_userdata\P(Doom)
   (same project name and no custom user dir, as in your 0.15.0). It reads
   and writes your settings and saves there and adds one file, g_ui.cfg.
   Settings or saves written by 0.15.0 may not load cleanly in this
   0.14.5-based build.

G on and off
------------
G starts ON for a fresh profile. To switch it off:
  Settings > ALL PROTOCOLS > G desk options > "G desk (the new main screen)" off
That restores the saved layout, which defaults to classic (today's screen).
It applies the next time the game screen opens (New Game or Continue from
the main menu). The same switch turns G back on.

Same-seed check
---------------
Month 1 of seed g-parity-1, played along one input path, ends in the same
game state in classic, in G and in your 0.14.5 base 4119ddcb. That is what
was checked; how to run it yourself is in the proposal.

Network
-------
The launch update check, the anonymous launch ping and leaderboard sync are
your 0.14.5 code, unchanged by G. The ping is on by default
(godot/autoload/game_config.gd:134, send_launch_ping = true), so a fresh
profile -- which play-separate-profile.bat gives you -- sends it on its first
start. To turn it off: Settings > ALL PROTOCOLS > "Anonymous launch ping"
off; it stays off for that profile. The update notice will probably offer
0.15.0.

Files
-----
play-separate-profile.bat   start here: the game with its own profile folder
PDoom.exe, PDoom.pck        the game (PDoom.exe alone uses your normal profile)
README.txt                  this file

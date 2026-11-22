P(Doom) -- G desk test build
============================

What this is
------------
A Windows build of P(Doom) with the G desk: an optional, simpler main screen
for the same game. Made by Alex (SwitchOCE) with Claude, from Alex's fork:

  https://github.com/SwitchOCE/pdoom1  branch lean, commit 431ea001

Base: your main at 4119ddcb (v0.14.5). Your main is now v0.15.0; this build
does not have 0.15.0's changes (skins #1372, the fire/depart fix #1369, ...).
Exported with Godot 4.5.1, preset "Windows Desktop", release mode.

How to run
----------
Unzip anywhere and run PDoom.exe (keep PDoom.pck next to it).

G is ON by default. To switch back to today's screen (classic):
  Settings > G desk options > "G desk (the new main screen)": off
It applies the next time the game screen opens (New Game or Continue from
the main menu). The same switch turns G back on.

The game rules are not changed: with the same seed and the same inputs, a run
plays out the same in classic and in G (same-seed check in the proposal).

Your profile -- read this first
-------------------------------
This build uses the SAME profile folder as your normal P(Doom) install:

  %APPDATA%\Godot\app_userdata\P(Doom)

(project name "P(Doom)", no custom user dir -- same as your 0.15.0.) It reads
and writes your settings and saves there, and adds one file, g_ui.cfg, for
the G options. Settings or saves written by 0.15.0 may not load cleanly in
this 0.14.5-based build.

To keep it apart, run play-separate-profile.bat instead of PDoom.exe: it sets
APPDATA to a "profile" folder next to the exe, so nothing touches your normal
profile. (This is the same APPDATA override the fork's test tools use; the
.bat itself was not tested on Windows.)

Network: the launch update check, the anonymous ping (your privacy settings
apply) and leaderboard sync are your 0.14.5 code, unchanged by G. Expect the
update notice to offer 0.15.0.

Files
-----
PDoom.exe, PDoom.pck   the game
play-separate-profile.bat   runs it with its own profile folder
README.txt   this file

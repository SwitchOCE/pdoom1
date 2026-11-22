@echo off
rem Run P(Doom) G desk build with its own profile folder next to the exe.
set "APPDATA=%~dp0profile"
if not exist "%APPDATA%" mkdir "%APPDATA%"
start "" "%~dp0PDoom.exe"

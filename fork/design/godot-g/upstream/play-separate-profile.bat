@echo off
setlocal
rem P(Doom) G desk build: start the game with its own profile folder next to the exe,
rem so your normal profile under %APPDATA%\Godot\app_userdata is not touched.
cd /d "%~dp0"
set "APPDATA=%~dp0profile"
if not exist "%APPDATA%\" mkdir "%APPDATA%"
if exist "%APPDATA%\" goto run
echo Could not create the profile folder:
echo   "%APPDATA%"
echo The game was not started. Unzip to a folder you can write to and try again.
pause
exit /b 1
:run
start "" "%~dp0PDoom.exe"
endlocal

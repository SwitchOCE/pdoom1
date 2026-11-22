@echo off
setlocal
rem P(Doom) G desk build: start the game with its own profile folder next to the exe,
rem so your normal profile under %APPDATA%\Godot\app_userdata is not touched.
cd /d "%~dp0"
set "APPDATA=%~dp0profile"
if not exist "%APPDATA%\" mkdir "%APPDATA%"
if not exist "%APPDATA%\" goto fail
rem Check the folder can be written to, not only that it exists.
type nul >"%APPDATA%\.write-test" 2>nul || goto fail
del "%APPDATA%\.write-test" >nul 2>&1
goto run
:fail
echo Could not create or write to the profile folder:
echo   "%APPDATA%"
echo The game was not started. Unzip to a folder you can write to and try again.
pause
exit /b 1
:run
start "" "%~dp0PDoom.exe"
endlocal

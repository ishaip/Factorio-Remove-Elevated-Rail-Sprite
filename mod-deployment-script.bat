@echo off
setlocal enabledelayedexpansion

REM Usage: mod-deployment-script.bat <input> <output> <target>
REM input  - folder or file to zip
REM output - name of the zip file (with or without .zip extension)
REM target - directory to copy the zip file to

REM Read version from changelog.txt (first occurrence only)
set version=
for /f "tokens=2" %%a in ('findstr /r "^Version:" changelog.txt 2^>nul') do (
    if "!version!"=="" set version=%%a
)

REM Check if version was found
if "!version!"=="" (
    echo Error: Could not find version in changelog.txt
    echo Expected format: "Version: x.x.x"
    echo Please check your changelog.txt formatting
    pause
    exit /b 1
)
REM Read mod name from info.json
set modname=
for /f "tokens=2 delims=:," %%a in ('findstr /r "\"name\":" info.json 2^>nul') do (
    set modname=%%a
    set modname=!modname:"=!
    set modname=!modname: =!
)

REM Check if mod name was found
if "!modname!"=="" (
    echo Error: Could not find mod name in info.json
    echo Expected format: "name": "mod-name"
    echo Please check your info.json formatting
    pause
    exit /b 1
)

REM Display found values for confirmation
echo Found mod name: !modname!
echo Found version: !version!

set input=.
set output=!modname!_!version!
set target=%appdata%\Factorio\mods

REM Ensure output ends with .zip
set zipname=!output!
if /I not "!zipname:~-4!"==".zip" set zipname=!zipname!.zip

REM Remove output zip if it already exists in current directory
if exist "!zipname!" del /f /q "!zipname!"

echo Creating mod archive: !zipname!

REM Create zip archive excluding .gitignore and deployment script
powershell -Command "Get-ChildItem -Path '.' -Recurse | Where-Object { $_.Name -ne '.gitignore' -and $_.Name -ne 'mod-deployment-script.bat' } | Compress-Archive -DestinationPath '!zipname!' -Force"

REM Copy zip to target directory, overwrite if exists
copy /Y "!zipname!" "%target%\!zipname!"

echo Deployment complete: !zipname! copied to %target%
pause
endlocal
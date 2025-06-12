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

set foldername=!modname!_!version!
set zipname=!foldername!.zip
set target=%appdata%\Factorio\mods

REM Remove existing folder and zip if they exist
if exist "!foldername!" rmdir /s /q "!foldername!"
if exist "!zipname!" del /f /q "!zipname!"

echo Creating mod folder: !foldername!

REM Create the mod folder
mkdir "!foldername!"

REM Copy all files except .gitignore, .git folder, and deployment script
echo Copying files to mod folder...
for /f "delims=" %%i in ('dir /b /a-d') do (
    if /I not "%%i"==".gitignore" (
        if /I not "%%i"=="mod-deployment-script.bat" (
            copy "%%i" "!foldername!\" >nul
        )
    )
)

REM Copy all directories except .git and existing mod folders
for /f "delims=" %%i in ('dir /b /ad') do (
    if /I not "%%i"==".git" (
        if /I not "%%i"=="!foldername!" (
            xcopy "%%i" "!foldername!\%%i\" /e /i /q >nul
        )
    )
)

echo Creating zip archive: !zipname!

REM Create zip archive from the folder
powershell -Command "Compress-Archive -Path '!foldername!' -DestinationPath '!zipname!' -Force"

REM Copy zip to target directory, overwrite if exists
copy /Y "!zipname!" "!target!\!zipname!"

REM Clean up - remove the temporary folder
rmdir /s /q "!foldername!"

echo Deployment complete: !zipname! copied to !target!
pause
endlocal
@echo off
setlocal enabledelayedexpansion

:: OpenToonz Community Pack Installer
:: Copies community assets into the user's OpenToonz stuff folder.

set "script_version=1.5"
set "default_stuff=C:\OpenToonz stuff"
set "stuff_folder=%default_stuff%"

echo OpenToonz Community Pack Installer v%script_version%
echo.
echo This will install community assets into your OpenToonz stuff folder.
echo Default path: %default_stuff%
echo.
set /p "confirm=Is this correct? (Y/N): "
if /i not "!confirm!"=="Y" (
    set /p "stuff_folder=Please enter the path to your OpenToonz stuff folder: "
    if "!stuff_folder!"=="" (
        echo No path entered. Exiting.
        pause
        exit /b 1
    )
)

if "!stuff_folder:~-1!"=="\" set "stuff_folder=!stuff_folder:~0,-1!"
set "target=!stuff_folder!\config\qss"

pushd "%~dp0" >nul 2>&1
if errorlevel 1 (
    echo Failed to change directory to script folder.
    pause
    exit /b 1
)

if not exist "!target!" (
    mkdir "!target!"
    if errorlevel 1 (
        echo Failed to create target directory: !target!
        popd
        pause
        exit /b 1
    )
)

set "themes_dir=themes"
if not exist "!themes_dir!" (
    echo themes directory not found in: %cd%
    popd
    pause
    exit /b 1
)

echo.
echo Installing asset folders...
for /d %%d in ("!themes_dir!\*") do (
    set "folder_name=%%~nxd"
    set "dest_folder=!target!\!folder_name!"
    if not exist "!dest_folder!" mkdir "!dest_folder!" 2>nul
    xcopy "%%d\*" "!dest_folder!\" /s /e /y /i /q >nul
    if errorlevel 1 (
        echo Failed to copy: !folder_name!
    ) else (
        echo Successfully installed/updated: !folder_name!
    )
)

echo.
set "default_src=!themes_dir!\Default\imgs"
set "default_dest=!target!\Default\imgs"

if not exist "!default_dest!" (
    mkdir "!default_dest!" 2>nul
    if errorlevel 1 (
        echo Failed to create Default image directory: !default_dest!
        popd
        pause
        exit /b 1
    )
)

if exist "!default_src!" (
    xcopy "!default_src!\*" "!default_dest!\" /s /e /y /i /q >nul
)

echo Community image assets for themes successfully installed/updated in: !target!\Default\imgs
echo.
echo Installation complete.
echo.
popd
pause
exit /b 0

@echo off
setlocal
title WOLF FREE PERM
echo.
echo.

CD /D "%~dp0"
REM Check if the UTIL folder exists
if not exist "UTIL\" (
    echo Please extract the folder, it MUST NOT be run without extracting.
    pause
    exit /b
)

endlocal

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    cd /d "%~dp0"

cd /d "UTIL"

setlocal enabledelayedexpansion

:ask
set "response="
set /p "response=Would you like to randomize serials? (y): "
set "response=!response:~0,1!"
color b
if /i "!response!"=="y" (
    echo randomizing...
    WOLF /BM "To Be Filled By O.E.M."
    WOLF /SM "To Be Filled By O.E.M."
    WOLF /SS "W%RANDOM%%RANDOM%"
    WOLF /BS "W%RANDOM%%RANDOM%"
    WOLF /BP "W%RANDOM%%RANDOM%-73Z-%RANDOM%%RANDOM%-XN%RANDOM%"
    WOLF /SP "W%RANDOM%%RANDOM%-P5A-%RANDOM%%RANDOM%-XN%RANDOM%"
    WOLF /PSN "W%RANDOM%%RANDOM%"
    WOLF /SU auto
    timeout /T 3 >nul
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo Done.
    echo Please restart your PC.
    echo Made by WOLF.
    echo Join our community at discord.gg/YOURSERVER!
    echo Press any key to exit!
    pause >nul
    exit /B
)

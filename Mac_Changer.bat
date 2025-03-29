@echo off
:: BatchGotAdmin
color 1
cls
title MAC CHANGER BY UltraWolf9111  https://discord.gg/RGkM4GtePf
:CHECKADMIN
REM --> Check for admin permissions
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting Admin...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params= %*
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
pushd "%CD%"
CD /D "%~dp0"

SETLOCAL ENABLEDELAYEDEXPANSION
SETLOCAL ENABLEEXTENSIONS

:SHOWCURRENTMAC
cls



echo                                         MAC Address Changer made by UltraWolf9111            

                                                                                                  
                                                                                                            

echo.
for /f "tokens=2 delims==" %%a in ('"wmic nicconfig where (ipenabled=true) get macaddress /format:list"') do set currentMAC=%%a
echo Your current MAC address is: %currentMAC%
echo.

:MENU
echo 1. Randomize MAC address
echo 2. Enter custom MAC address
echo 3. Reset MAC address to original
echo 4. Exit
echo.
set /p choice="Choose an option (1-4): "

if "%choice%"=="1" goto RANDOMIZE
if "%choice%"=="2" goto CUSTOMMAC
if "%choice%"=="3" goto RESETMAC
if "%choice%"=="4" goto END
echo Invalid choice, please choose 1, 2, 3, or 4.
goto MENU

:RANDOMIZE
echo Randomizing MAC address...
FOR /F "tokens=1" %%a IN ('wmic nic where physicaladapter^=true get deviceid ^| findstr [0-9]') DO (
    CALL :MAC
    FOR %%b IN (0 00 000) DO (
        REG QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a >NUL 2>NUL && REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a /v NetworkAddress /t REG_SZ /d !MAC! /f >NUL 2>NUL
    )
)
echo.
echo Your new randomized MAC address is: !MAC!
goto RESETNIC

:CUSTOMMAC
set /p customMAC="Enter the custom MAC address (12 characters without dashes or colons): "
if not "%customMAC:~12,1%"=="" (
    echo Invalid MAC address. Please ensure it is exactly 12 characters long.
    goto CUSTOMMAC
)
FOR /F "tokens=1" %%a IN ('wmic nic where physicaladapter^=true get deviceid ^| findstr [0-9]') DO (
    FOR %%b IN (0 00 000) DO (
        REG QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a >NUL 2>NUL && REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a /v NetworkAddress /t REG_SZ /d %customMAC% /f >NUL 2>NUL
    )
)
echo.
echo Your new custom MAC address is: %customMAC%
goto RESETNIC

:RESETMAC
echo Resetting MAC address to original...
FOR /F "tokens=1" %%a IN ('wmic nic where physicaladapter^=true get deviceid ^| findstr [0-9]') DO (
    FOR %%b IN (0 00 000) DO (
        REG DELETE HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a /v NetworkAddress /f >NUL 2>NUL
    )
)
echo.
echo MAC address has been reset to original.
goto RESETNIC

:RESETNIC

FOR /F "tokens=2 delims=, skip=2" %%a IN ('"wmic nic where (netconnectionid like '%%') get netconnectionid,netconnectionstatus /format:csv"') DO (
    netsh interface set interface name="%%a" disable >NUL 2>NUL
    netsh interface set interface name="%%a" enable >NUL 2>NUL
)
echo Operation completed.
timeout /t 2 >NUL
goto SHOWCURRENTMAC

:MAC
:: Generates semi-random value of a length according to the "if !COUNT!" line, minus one, and from the characters in the GEN variable
SET COUNT=0
SET GEN=ABCDEF0123456789
SET GEN2=26AE
SET MAC=
:MACLOOP
SET /a COUNT+=1
SET RND=%random%
:: %%n, where the value of n is the number of characters in the GEN variable minus one. So if you have 15 characters in GEN, set the number as 14
SET /A RND=RND%%16
SET RNDGEN=!GEN:~%RND%,1!
SET /A RND2=RND%%4
SET RNDGEN2=!GEN2:~%RND2%,1!
IF "!COUNT!"  EQU "2" (SET MAC=!MAC!!RNDGEN2!) ELSE (SET MAC=!MAC!!RNDGEN!)
IF !COUNT!  LEQ 11 GOTO MACLOOP
GOTO :EOF

:END
ENDLOCAL
echo Goodbye!
exit /B

@echo off
setlocal enabledelayedexpansion

:: Main Menu
:mainMenu
cls
echo ================================
echo       MAC Spoofer Menu
echo ================================
echo 1. Spoof MAC (Intel)
echo 2. Spoof MAC (AMD)
echo 3. Restore Original MAC
echo 4. Show MAC Address
echo 5. Exit
echo ================================
set /p choice=Select an option: 

if "%choice%"=="1" goto spoofIntel
if "%choice%"=="2" goto spoofAMD
if "%choice%"=="3" goto restore
if "%choice%"=="4" goto showMAC
if "%choice%"=="5" exit
goto mainMenu

:: ===== Intel Spoofing =====
:spoofIntel
set "spoofType=Intel"
goto spoof

:: ===== AMD Spoofing =====
:spoofAMD
set "spoofType=AMD"
goto spoof

:spoof
cls
echo [INFO] Spoofing MAC (%spoofType%-style)...

:: === Auto-detect adapter ===
set "adapterName="
set "origMAC="
for /f "skip=1 tokens=1,2 delims=," %%A in ('"getmac /v /fo csv"') do (
    set "adapterName=%%~A"
    set "origMAC=%%~B"
    if defined adapterName if not "!adapterName!"=="Media disconnected" (
        goto foundAdapter
    )
)
:foundAdapter

if not defined adapterName (
    echo [ERROR] Could not detect active adapter.
    pause
    goto mainMenu
)

:: === Store original MAC in variable ===
set "originalMAC=!origMAC!"

:: === OUIs ===
if /i "%spoofType%"=="Intel" (
    set OUIs[0]=3C:FD:FE
    set OUIs[1]=00:1B:21
    set OUIs[2]=00:13:E8
    set OUIs[3]=F4:6D:04
    set OUIs[4]=10:AE:60
) else (
    set OUIs[0]=00:1D:0F
    set OUIs[1]=00:0E:2E
    set OUIs[2]=00:14:22
    set OUIs[3]=00:17:A4
    set OUIs[4]=00:1A:92
)

set /a pick=%random% %% 5
call set "OUI=%%OUIs[%pick%]%%"

:: === Generate last 3 bytes ===
set chars=0123456789ABCDEF
set "randMAC="
for /L %%i in (1,1,6) do (
    set /a rand=!random! %% 16
    set "randMAC=!randMAC!!chars:~!rand!,1!"
)

:: === Format full MAC ===
set "mac=%OUI%:%randMAC:~0,2%:%randMAC:~2,2%:%randMAC:~4,2%"
set "formattedMAC=%mac::=-%"
set "rawMAC=%mac::=%"
echo [INFO] New MAC: %formattedMAC%

:: === Locate Registry Key ===
set "regKey="
for /f "tokens=*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /f "DriverDesc" ^| findstr /i /c:"!adapterName!"') do (
    set "regKey=%%~dpA"
)
if not defined regKey (
    echo [ERROR] Registry key not found for adapter.
    pause
    goto mainMenu
)
set "regKey=!regKey:~0,-1!"

:: === Write new MAC to registry ===
reg add "!regKey!" /v "NetworkAddress" /d "!rawMAC!" /f >nul

:: === Restart adapter with PowerShell ===
echo [INFO] Restarting adapter "!adapterName!"...
powershell -Command "Get-NetAdapter -Name '!adapterName!' | Disable-NetAdapter -Confirm:$false"
timeout /t 3 >nul
powershell -Command "Get-NetAdapter -Name '!adapterName!' | Enable-NetAdapter -Confirm:$false"

echo [SUCCESS] MAC changed to: %formattedMAC%
pause
goto mainMenu

:restore
cls
echo [INFO] Restoring original MAC...

:: === Auto-detect adapter again ===
set "adapterName="
for /f "skip=1 tokens=1 delims=," %%A in ('"getmac /v /fo csv"') do (
    set "adapterName=%%~A"
    if defined adapterName if not "!adapterName!"=="Media disconnected" (
        goto restoreFound
    )
)
:restoreFound

if not defined adapterName (
    echo [ERROR] Could not detect active adapter.
    pause
    goto mainMenu
)

echo [INFO] Restoring to original MAC: %originalMAC%

:: === Locate Registry Key ===
set "regKey="
for /f "tokens=*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /f "DriverDesc" ^| findstr /i /c:"!adapterName!"') do (
    set "regKey=%%~dpA"
)
if not defined regKey (
    echo [ERROR] Registry key not found for adapter.
    pause
    goto mainMenu
)
set "regKey=!regKey:~0,-1!"

:: === Restore original MAC ===
reg add "!regKey!" /v "NetworkAddress" /d "%originalMAC%" /f >nul

:: === Restart adapter ===
echo [INFO] Restarting adapter "!adapterName!"...
powershell -Command "Get-NetAdapter -Name '!adapterName!' | Disable-NetAdapter -Confirm:$false"
timeout /t 3 >nul
powershell -Command "Get-NetAdapter -Name '!adapterName!' | Enable-NetAdapter -Confirm:$false"

echo [SUCCESS] Restored to original MAC: %originalMAC%
pause
goto mainMenu

:showMAC
cls
echo [INFO] Displaying MAC addresses...

:: Ensure that the original MAC address is set
if not defined originalMAC (
    echo [ERROR] Original MAC address not found. Please spoof a MAC first.
    pause
    goto mainMenu
)

:: Display original MAC
echo.
echo [INFO] Original MAC: 
color 0C
echo !originalMAC!

:: Display spoofed MAC
if defined formattedMAC (
    echo.
    echo [INFO] New MAC: 
    color 0A
    echo !formattedMAC!
) else (
    echo.
    echo [INFO] No spoofed MAC address found.
)

:: Reset color
color 07
pause
goto mainMenu

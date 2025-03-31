@echo off
title  EAC CLEANER
echo ========== STARTING SUPREME EAC CLEANER ==========
echo.

:: Stop EAC & related services
echo [*] Stopping Easy Anti-Cheat Services...
net stop EasyAntiCheat /y
taskkill /F /IM EasyAntiCheat.exe /T >nul 2>&1

:: Remove EAC Registry Entries
echo [*] Removing EAC Registry Entries...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\EasyAntiCheat" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EAC" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\EAC" /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\Software\EasyAntiCheat" /f >nul 2>&1

:: Remove EAC Log Files, Drivers, and Configurations
echo [*] Removing EAC Files...
del /s /q "C:\Program Files (x86)\EasyAntiCheat" >nul 2>&1
del /s /q "C:\Windows\System32\drivers\EasyAntiCheat.sys" >nul 2>&1
del /s /q "%APPDATA%\EasyAntiCheat" >nul 2>&1
del /s /q "%LOCALAPPDATA%\EasyAntiCheat" >nul 2>&1
del /s /q "C:\Users\Public\Public Documents\EAC" >nul 2>&1
del /s /q "C:\ProgramData\EasyAntiCheat" >nul 2>&1

:: Clean Temp Files & Logs
echo [*] Cleaning Temp Files & Logs...
del /s /q "%TEMP%\*" >nul 2>&1
del /s /q "%WINDIR%\Temp\*" >nul 2>&1

:: Delete System Event Logs
echo [*] Wiping Event Logs...
wevtutil cl "Microsoft-Windows-Security-Auditing" >nul 2>&1
wevtutil cl "Microsoft-Windows-Eventlog" >nul 2>&1
wevtutil cl "System" >nul 2>&1

:: Flush Network & DNS Traces
echo [*] Flushing DNS & Resetting Network...
ipconfig /flushdns
netsh winsock reset
netsh int ip reset

:: Force Delete Any Remaining Hidden Logs
echo [*] Deleting Hidden Logs...
del /s /q "%PROGRAMDATA%\EasyAntiCheat" >nul 2>&1
del /s /q "%LOCALAPPDATA%\Temp" >nul 2>&1
del /s /q "C:\Windows\Prefetch\EasyAntiCheat" >nul 2>&1

:: Final Reboot to Apply Changes
echo [!] CLEANUP COMPLETE. Restarting in 10 seconds...
timeout /t 10
shutdown /r /f /t 0

::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFBxVQAuMAES0A5EO4f7+086CsUYJW/IDfILN5qecI9wH71bwO5M10xo=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
title Cleaning Script by 2kyoo
color 0A
mode con: cols=80 lines=25

:: Request administrator permissions
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator permissions...
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)

cls

:: Ensure we have administrator permissions
net session >nul 2>&1
if %ErrorLevel% neq 0 (
    echo "You are not an Administrator"
    goto END
)

:START_CLEANUP

:: Display starting message
echo Starting cleanup process...

:: Deleting Windows Defender history using IObitUnlocker
echo Deleting Windows Defender history...
IObitUnlocker.exe /Delete /Advanced "%systemdrive%\ProgramData\Microsoft\Windows Defender\Scans\History\Service" "%systemdrive%\ProgramData\Microsoft\Windows Defender\Scans\mpenginedb.db" >nul 2>&1
if %ErrorLevel% equ 0 (
    echo "Windows Defender history deleted successfully."
) else (
    echo "Failed to delete Windows Defender history. Checking paths..."
    echo Paths:
    echo %systemdrive%\ProgramData\Microsoft\Windows Defender\Scans\History\Service
    echo %systemdrive%\ProgramData\Microsoft\Windows Defender\Scans\mpenginedb.db
    pause
)

:: Create necessary directory
mkdir "%systemdrive%\ProgramData\Microsoft\Windows Defender\Scans\History\Service" >nul 2>&1

:: Restart Windows Defender service
powershell -command "Start-Service -Name WinDefend -ErrorAction SilentlyContinue" || sc start WinDefend >nul 2>&1 || net start WinDefend >nul 2>&1

:: Cleaning Xbox services
echo Cleaning Xbox services...
powershell -Command "& {Get-AppxPackage -AllUsers xbox | Remove-AppxPackage}" >nul 2>&1
sc stop XblAuthManager >nul 2>&1
sc stop XblGameSave >nul 2>&1
sc stop XboxNetApiSvc >nul 2>&1
sc stop XboxGipSvc >nul 2>&1
sc delete XblAuthManager >nul 2>&1
sc delete XblGameSave >nul 2>&1
sc delete XboxNetApiSvc >nul 2>&1
sc delete XboxGipSvc >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /f >nul 2>&1
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /disable >nul 2>&1
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTaskLogon" /disable >nul 2>&1
echo Xbox services cleaned.
pause

:: Add entries to the hosts file
echo Adding entries to hosts file...
set hostspath=%windir%\System32\drivers\etc\hosts
echo 127.0.0.1 xboxlive.com >> %hostspath%
echo 127.0.0.1 user.auth.xboxlive.com >> %hostspath%
echo 127.0.0.1 presence-heartbeat.xboxlive.com >> %hostspath%
echo Hosts file updated.
pause

:: Deleting various registry keys and directories
echo Deleting registry keys and cleaning directories...

:: General registry keys
reg delete "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache: loader" /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppSwitched: 0x00000002" /f >nul 2>&1
reg delete "Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >nul 2>&1
reg delete "Computer\HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List" /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\SOFTWARE\WinRAR\ArcHistory" /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" /f >nul 2>&1

:: Windows Defender real-time protection disable
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f >nul 2>&1

:: Clean Discord Cache
echo Cleaning Discord cache...
rd /s /q "%APPDATA%\discord\Cache" >nul 2>&1
rd /s /q "%APPDATA%\discord\Code Cache" >nul 2>&1
rd /s /q "%APPDATA%\discord\GPUCache" >nul 2>&1
rd /s /q "%APPDATA%\discord\Local Storage" >nul 2>&1
rd /s /q "%APPDATA%\discord\ShaderCache" >nul 2>&1
pause

:: Clean ShimCache (AppCompatCache)
echo Cleaning ShimCache...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache32" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache64" /f >nul 2>&1
pause

:: Clean Windows Search logs/history
echo Cleaning Windows Search logs...
del /s /q "%localappdata%\Microsoft\Windows\ConnectedSearch\History\*" >nul 2>&1
if %ErrorLevel% neq 0 (
    echo Failed to delete Windows Search History. Path: %localappdata%\Microsoft\Windows\ConnectedSearch\History
) else (
    echo Windows Search History deleted successfully.
)
del /s /q "%localappdata%\Microsoft\Windows\ConnectedSearch\Logs\*" >nul 2>&1
if %ErrorLevel% neq 0 (
    echo Failed to delete Windows Search Logs. Path: %localappdata%\Microsoft\Windows\ConnectedSearch\Logs
) else (
    echo Windows Search Logs deleted successfully.
)

:: Clean User Assist
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" /f >nul 2>&1

:: Clean BAM/DAM logs/history
del /s /q "%localappdata%\Microsoft\Windows\Explorer\*.{4234d49b-0245-4df3-b780-3893943456e1}" >nul 2>&1

:: Clean MRU logs/history
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1

:: Clean Windows/Microsoft Recent Items
del /s /q "%APPDATA%\Microsoft\Windows\Recent\*" >nul 2>&1

:: Clean System Root history
del /s /q "%systemroot%\system32\config\*.log" >nul 2>&1

:: Clean cookies
del /s /q "%APPDATA%\Microsoft\Windows\Cookies\*" >nul 2>&1

:: Clean event logs
wevtutil el | ForEach-Object {wevtutil cl "$_"} >nul 2>&1

:: Clean temp directories
echo Cleaning temp directories...
rd /s /q %temp% >nul 2>&1
mkdir %temp% >nul 2>&1
takeown /f "%temp%" /r /d y >nul 2>&1
takeown /f "C:\Windows\Temp" /r /d y >nul 2>&1
rd /s /q C:\Windows\Temp >nul 2>&1
mkdir C:\Windows\Temp >nul 2>&1
takeown /f "C:\Windows\Temp" /r /d y >nul 2>&1
pause

:: Delete logs from root
echo Deleting log files from root...
cd/
del *.log /a /s /q /f >nul 2>&1
pause

echo.
echo Restarting explorer.exe...
start explorer.exe >nul 2>&1

echo.
echo Cleaning Completed. Press Enter to close this window.
pause >nul

:END
echo.
echo Press Enter to close this window
pause >nul
exit

@echo off
setlocal
title HMI Launcher v2
cd /d "%~dp0"
set "HMI_APP_DIR=%~dp0"
echo Starting HMI v2...
echo Keep this window open while the HMI is running.
echo.
if not exist "%~dp0HMI-Windows.ps1" (
  echo ERROR: HMI-Windows.ps1 is missing.
  echo Extract ALL files from the ZIP into the same folder first.
  pause
  exit /b 1
)
powershell.exe -NoLogo -NoProfile -STA -Command "$ErrorActionPreference='Stop'; try { $p=Join-Path $env:HMI_APP_DIR 'HMI-Windows.ps1'; $code=[System.IO.File]::ReadAllText($p); & ([scriptblock]::Create($code)) } catch { Write-Host 'HMI STARTUP ERROR:' -ForegroundColor Red; Write-Host ($_ | Out-String); Write-Host $_.ScriptStackTrace; exit 1 }"
set "HMI_RESULT=%ERRORLEVEL%"
echo.
if "%HMI_RESULT%"=="0" (
  echo HMI window closed normally.
) else (
  echo HMI failed. Exit code: %HMI_RESULT%
  echo Please send the error text above for troubleshooting.
)
pause
exit /b %HMI_RESULT%

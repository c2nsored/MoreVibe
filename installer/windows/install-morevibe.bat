@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title MoreVibe Installer

set "SCRIPT_DIR=%~dp0"
set "POWERSHELL_SCRIPT=%SCRIPT_DIR%install-morevibe.ps1"
if not exist "%POWERSHELL_SCRIPT%" set "POWERSHELL_SCRIPT=%SCRIPT_DIR%installer\windows\install-morevibe.ps1"

if not exist "%POWERSHELL_SCRIPT%" (
  echo.
  echo [ERROR] MoreVibe installer script not found.
  echo %POWERSHELL_SCRIPT%
  echo.
  pause
  exit /b 1
)

if not "%~1"=="" goto run_direct

echo.
echo ==========================================
echo           MoreVibe Installer
echo ==========================================
echo.
echo Recommended setup:
echo   1. Extract this package anywhere you want.
echo   2. Run this installer from the extracted folder.
echo   3. Enter your real project root path when asked.
echo.
echo This installer can set up MoreVibe for:
echo   1. Codex
echo   2. Claude Code
echo   3. Antigravity
echo.
echo You can install one target or all targets.
echo.
choice /C YN /M "Do you want to continue with installation"
if errorlevel 2 (
  echo.
  echo Installation cancelled.
  echo.
  pause
  exit /b 0
)

echo.
echo Select targets:
echo   A = Install all
echo   C = Codex only
echo   L = Claude Code only
echo   G = Antigravity only
echo   M = Manually choose multiple targets
echo.
choice /C ACLGM /M "Choose installation mode"

set "INSTALL_ARGS=-ProjectPath ""%PROJECT_PATH%"""
set "TARGET_SUMMARY="

if errorlevel 5 goto choose_multiple
if errorlevel 4 goto antigravity_only
if errorlevel 3 goto claude_only
if errorlevel 2 goto codex_only
if errorlevel 1 goto all_targets

:all_targets
set "INSTALL_ARGS=%INSTALL_ARGS% -InstallCodex -InstallClaudeCode -InstallAntigravity"
set "TARGET_SUMMARY=Codex, Claude Code, Antigravity"
goto confirm_run

:codex_only
set "INSTALL_ARGS=%INSTALL_ARGS% -InstallCodex"
set "TARGET_SUMMARY=Codex"
goto confirm_run

:claude_only
set "INSTALL_ARGS=%INSTALL_ARGS% -InstallClaudeCode"
set "TARGET_SUMMARY=Claude Code"
goto confirm_run

:antigravity_only
set "INSTALL_ARGS=%INSTALL_ARGS% -InstallAntigravity"
set "TARGET_SUMMARY=Antigravity"
goto confirm_run

:choose_multiple
echo.
choice /C YN /M "Install Codex"
if errorlevel 1 if not errorlevel 2 set "INSTALL_ARGS=%INSTALL_ARGS% -InstallCodex" & set "TARGET_SUMMARY=!TARGET_SUMMARY!Codex, "
choice /C YN /M "Install Claude Code"
if errorlevel 1 if not errorlevel 2 set "INSTALL_ARGS=%INSTALL_ARGS% -InstallClaudeCode" & set "TARGET_SUMMARY=!TARGET_SUMMARY!Claude Code, "
choice /C YN /M "Install Antigravity"
if errorlevel 1 if not errorlevel 2 set "INSTALL_ARGS=%INSTALL_ARGS% -InstallAntigravity" & set "TARGET_SUMMARY=!TARGET_SUMMARY!Antigravity, "

if "!TARGET_SUMMARY!"=="" (
  echo.
  echo [ERROR] No installation target selected.
  echo.
  pause
  exit /b 1
)

if "!TARGET_SUMMARY:~-2!"==", " set "TARGET_SUMMARY=!TARGET_SUMMARY:~0,-2!"
goto confirm_run

:confirm_run
echo.
echo Enter the project root path where you want MoreVibe to create .morevibe/.
echo Leave this blank if you only want global tool setup right now.
echo.
set "PROJECT_PATH="
set /p "PROJECT_PATH=Project root path (optional): "

set "INSTALL_ARGS="
if not "%PROJECT_PATH%"=="" set "INSTALL_ARGS=-ProjectPath ""%PROJECT_PATH%"""

echo ------------------------------------------
if "%PROJECT_PATH%"=="" (
  echo Project path : [skip project bootstrap]
) else (
  echo Project path : %PROJECT_PATH%
)
echo Targets      : %TARGET_SUMMARY%
echo ------------------------------------------
echo.
choice /C YN /M "Start installation now"
if errorlevel 2 (
  echo.
  echo Installation cancelled.
  echo.
  pause
  exit /b 0
)

echo.
echo Running MoreVibe installer...
echo.
powershell -ExecutionPolicy Bypass -File "%POWERSHELL_SCRIPT%" %INSTALL_ARGS%
set "EXIT_CODE=%ERRORLEVEL%"
goto finish

:run_direct
powershell -ExecutionPolicy Bypass -File "%POWERSHELL_SCRIPT%" %*
set "EXIT_CODE=%ERRORLEVEL%"

:finish
echo.
if not "%EXIT_CODE%"=="0" (
  echo [FAILED] MoreVibe installer ended with exit code %EXIT_CODE%.
  echo Please review the messages above and try again.
  echo.
  pause
  exit /b %EXIT_CODE%
)

echo [DONE] MoreVibe installer finished successfully.
echo You can now start a new AI session in the selected tool(s).
echo.
pause
exit /b 0

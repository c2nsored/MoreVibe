@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "POWERSHELL_SCRIPT=%SCRIPT_DIR%install-morevibe.ps1"

if not exist "%POWERSHELL_SCRIPT%" (
  echo MoreVibe installer script not found:
  echo %POWERSHELL_SCRIPT%
  exit /b 1
)

if "%~1"=="" (
  set "DEFAULT_PROJECT=%CD%"
  echo.
  set /p "PROJECT_PATH=Project path for .morevibe bootstrap (press Enter for current directory: %DEFAULT_PROJECT%): "
  if "%PROJECT_PATH%"=="" set "PROJECT_PATH=%DEFAULT_PROJECT%"
  powershell -ExecutionPolicy Bypass -File "%POWERSHELL_SCRIPT%" -ProjectPath "%PROJECT_PATH%"
) else (
  powershell -ExecutionPolicy Bypass -File "%POWERSHELL_SCRIPT%" %*
)
set "EXIT_CODE=%ERRORLEVEL%"

if not "%EXIT_CODE%"=="0" (
  echo.
  echo MoreVibe installer failed with exit code %EXIT_CODE%.
  exit /b %EXIT_CODE%
)

echo.
echo MoreVibe installer finished successfully.
exit /b 0

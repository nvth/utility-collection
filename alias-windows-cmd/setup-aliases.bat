@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "REG_FILE=%SCRIPT_DIR%autorun-hkcu.reg"

set "ALIAS_DIR=C:\alias"
set "CMD_FILE=%ALIAS_DIR%\cmd.cmd"

if not exist "%ALIAS_DIR%" (
  mkdir "%ALIAS_DIR%"
  if errorlevel 1 (
    echo Failed to create "%ALIAS_DIR%".
    exit /b 1
  )
)

> "%CMD_FILE%" (
  echo @echo off
  echo DOSKEY ls=dir /B $*
)

> "%REG_FILE%" (
  echo Windows Registry Editor Version 5.00
  echo.
  echo ; Auto-run C:\\alias\\cmd.cmd to load DOSKEY aliases for the current user.
  echo [HKEY_CURRENT_USER\Software\Microsoft\Command Processor]
  echo "AutoRun"="C:\\alias\\cmd.cmd"
)

reg import "%REG_FILE%" >nul
if errorlevel 1 (
  echo Failed to import "%REG_FILE%".
  exit /b 1
)

echo Installed. Edit "%CMD_FILE%" to add more aliases.

@echo off
setlocal EnableExtensions

set "ALIAS_DIR=C:\alias"
set "CMD_FILE=%ALIAS_DIR%\cmd.cmd"

set "USER_BASE=%USERPROFILE%\.cmd-aliases"
set "SYS_BASE=C:\ProgramData\cmd-aliases"

echo Removing AutoRun (if managed by this installer)...
call :remove_autorun "HKEY_CURRENT_USER\Software\Microsoft\Command Processor"
call :remove_autorun "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor"

echo.
echo Removing wrapper folders...
call :remove_dir "%USER_BASE%"
call :remove_dir "%SYS_BASE%"

echo.
echo Removing cmd alias file...
if exist "%CMD_FILE%" (
  del /f /q "%CMD_FILE%" >nul 2>&1
  if exist "%CMD_FILE%" (
    echo Failed to remove "%CMD_FILE%".
  ) else (
    echo Removed "%CMD_FILE%".
  )
) else (
  echo Not found: "%CMD_FILE%".
)

if exist "%ALIAS_DIR%" (
  rmdir "%ALIAS_DIR%" >nul 2>&1
)

echo.
echo Uninstall finished.
exit /b 0

:remove_autorun
set "ROOT=%~1"
set "AUTORUN="
for /f "tokens=1,2,*" %%A in ('reg query "%ROOT%" /v AutoRun 2^>nul ^| findstr /i AutoRun') do set "AUTORUN=%%C"
if not defined AUTORUN (
  echo No AutoRun value in %ROOT%.
  exit /b 0
)
if /i "%AUTORUN%"=="C:\alias\cmd.cmd" (
  reg delete "%ROOT%" /v AutoRun /f >nul 2>&1
  if errorlevel 1 (
    echo Failed to remove AutoRun in %ROOT%. Try running as Administrator.
  ) else (
    echo Removed AutoRun in %ROOT%.
  )
) else (
  echo AutoRun in %ROOT% not managed by this installer. Skipped.
)
exit /b 0

:remove_dir
set "DIR=%~1"
if not exist "%DIR%" exit /b 0
rmdir /s /q "%DIR%" >nul 2>&1
if exist "%DIR%" (
  echo Failed to remove "%DIR%". Try running as Administrator.
) else (
  echo Removed "%DIR%".
)
exit /b 0

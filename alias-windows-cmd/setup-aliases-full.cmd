@echo off
setlocal EnableExtensions

set "TARGET=current"

:parse
if "%~1"=="" goto parsed
if /i "%~1"=="/all" set "TARGET=all" & shift & goto parse
if /i "%~1"=="/system" set "TARGET=all" & shift & goto parse
if /i "%~1"=="/machine" set "TARGET=all" & shift & goto parse
if /i "%~1"=="/?" goto usage
echo Unknown option: %~1
exit /b 2

:parsed
set "ALIAS_DIR=C:\alias"
set "CMD_FILE=%ALIAS_DIR%\cmd.cmd"

if /i "%TARGET%"=="all" (
  call :require_admin || exit /b 1
  set "BASE=C:\ProgramData\cmd-aliases"
  set "CMD_BASE=C:\ProgramData\cmd-aliases"
  set "REG_ROOT=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor"
) else (
  set "BASE=%USERPROFILE%\.cmd-aliases"
  set "CMD_BASE=%%USERPROFILE%%\.cmd-aliases"
  set "REG_ROOT=HKEY_CURRENT_USER\Software\Microsoft\Command Processor"
)
set "BIN=%BASE%\bin"

if not exist "%ALIAS_DIR%" (
  mkdir "%ALIAS_DIR%" >nul 2>&1
  if errorlevel 1 (
    echo Failed to create "%ALIAS_DIR%".
    exit /b 1
  )
)

if not exist "%BIN%" (
  mkdir "%BIN%" >nul 2>&1
  if errorlevel 1 (
    echo Failed to create "%BIN%".
    exit /b 1
  )
)

call :write_wrappers
call :write_cmd

reg add "%REG_ROOT%" /v AutoRun /t REG_SZ /d "%CMD_FILE%" /f >nul
if errorlevel 1 (
  echo Failed to set AutoRun in "%REG_ROOT%".
  exit /b 1
)

echo Installed. Restart Command Prompt to load aliases.
exit /b 0

:usage
echo Usage: %~nx0 [/all]
echo   /all     Install for all users (requires Admin)
exit /b 0

:require_admin
net session >nul 2>&1
if errorlevel 1 (
  echo This option requires administrative privileges.
  exit /b 1
)
exit /b 0

:write_wrappers
> "%BIN%\rm.cmd" (
  echo @echo off
  echo setlocal EnableExtensions EnableDelayedExpansion
  echo.
  echo set "recursive=0"
  echo set "force=0"
  echo.
  echo :parse
  echo if "%%~1"=="" goto run
  echo set "arg=%%~1"
  echo if "!arg:~0,1!"=="-" ^(
  echo   echo !arg! ^| findstr /i "r" ^>nul ^&^& set "recursive=1"
  echo   echo !arg! ^| findstr /i "f" ^>nul ^&^& set "force=1"
  echo   shift
  echo   goto parse
  echo ^)
  echo.
  echo :run
  echo if "%%~1"=="" exit /b 0
  echo.
  echo :loop
  echo if "%%~1"=="" exit /b 0
  echo.
  echo if exist "%%~1\" ^(
  echo   if "!recursive!"=="1" ^(
  echo     rmdir /s /q "%%~1" 2^>nul
  echo   ^) else ^(
  echo     echo rm: cannot remove '%%~1': Is a directory
  echo     exit /b 1
  echo   ^)
  echo ^) else ^(
  echo   if "!force!"=="1" ^(
  echo     del /f /q "%%~1" 2^>nul
  echo   ^) else ^(
  echo     del /f "%%~1"
  echo   ^)
  echo ^)
  echo.
  echo shift
  echo goto loop
)

> "%BIN%\mkdir.cmd" (
  echo @echo off
  echo setlocal EnableExtensions
  echo.
  echo if "%%~1"=="" exit /b 0
  echo if "%%~1"=="-p" shift
  echo.
  echo :loop
  echo if "%%~1"=="" exit /b 0
  echo mkdir "%%~1" 2^>nul
  echo shift
  echo goto loop
)

> "%BIN%\rmdir.cmd" (
  echo @echo off
  echo setlocal EnableExtensions
  echo.
  echo if "%%~1"=="" exit /b 0
  echo if "%%~1"=="-p" shift
  echo.
  echo :loop
  echo if "%%~1"=="" exit /b 0
  echo rmdir "%%~1"
  echo shift
  echo goto loop
)

> "%BIN%\cp.cmd" (
  echo @echo off
  echo setlocal EnableExtensions EnableDelayedExpansion
  echo.
  echo set "recursive=0"
  echo.
  echo :parse
  echo if "%%~1"=="" goto usage
  echo if /i "%%~1"=="-r" set "recursive=1" ^& shift ^& goto parse
  echo if /i "%%~1"=="-R" set "recursive=1" ^& shift ^& goto parse
  echo if /i "%%~1"=="-a" set "recursive=1" ^& shift ^& goto parse
  echo.
  echo set "src=%%~1"
  echo set "dest=%%~2"
  echo if "%%dest%%"=="" goto usage
  echo.
  echo if exist "%%src%%\" ^(
  echo   if "%%recursive%%"=="1" ^(
  echo     xcopy "%%src%%" "%%dest%%" /E /I /H /Y ^>nul
  echo   ^) else ^(
  echo     echo cp: -r not specified; omitting directory '%%src%%'
  echo     exit /b 1
  echo   ^)
  echo ^) else ^(
  echo   copy /Y "%%src%%" "%%dest%%" ^>nul
  echo ^)
  echo.
  echo exit /b 0
  echo.
  echo :usage
  echo echo usage: cp [-rR] SOURCE DEST
  echo exit /b 2
)

> "%BIN%\find.cmd" (
  echo @echo off
  echo setlocal EnableExtensions
  echo.
  echo REM supports: find ^<path^> -name ^<pattern^>
  echo set "path=%%~1"
  echo if "%%path%%"=="" set "path=."
  echo.
  echo if /i "%%~2"=="-name" ^(
  echo   dir /s /b "%%path%%\%%~3"
  echo ^) else ^(
  echo   dir /s /b "%%path%%\*%%~2*"
  echo ^)
  echo.
  echo endlocal
)
exit /b 0

:write_cmd
> "%CMD_FILE%" (
  echo @echo off
  echo set "BASE=%CMD_BASE%"
  echo set "BIN=%%BASE%%\bin"
  echo if not exist "%%BIN%%" mkdir "%%BIN%%" ^>nul 2^>^&1
  echo.
  echo set "PATH=%%BIN%%;%%PATH%%"
  echo.
  echo doskey ls=dir /b $*
  echo doskey ll=dir $*
  echo doskey la=dir /a $*
  echo doskey pwd=cd
  echo.
  echo doskey cat=type $*
  echo doskey less=more $*
  echo doskey grep=findstr $*
  echo doskey grepr=findstr /s $*
  echo.
  echo doskey ps=tasklist
  echo doskey kill=taskkill /PID $* /F
  echo doskey top=tasklist /v
  echo.
  echo doskey ss=netstat -ano
  echo doskey ip=ipconfig
  echo doskey ifconfig=ipconfig
  echo doskey ipr=route print
  echo doskey ping=ping $*
  echo doskey curl=curl $*
  echo.
  echo doskey rm="%%BIN%%\rm.cmd" $*
  echo doskey mkdir="%%BIN%%\mkdir.cmd" $*
  echo doskey rmdir="%%BIN%%\rmdir.cmd" $*
  echo doskey cp="%%BIN%%\cp.cmd" $*
  echo doskey mv=move $*
  echo doskey find="%%BIN%%\find.cmd" $*
)
exit /b 0

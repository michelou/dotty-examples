@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _EXITCODE=0

set _BASENAME=%~n0

rem ##########################################################################
rem ## Main

for %%i in (%*) do (
    set __FILE=%%i
    if not exist "!__FILE!" (
        for %%i in ("!__FILE!") do set __PARENT_DIR=%%~dpi
        if %_DEBUG%==1 echo [%_BASENAME%] __PARENT_DIR=!__PARENT_DIR!
        echo.> !__PARENT_DIR!!__FILE!
        echo created file !__PARENT_DIR!!__FILE! 1>&2
    )
    call :touch_file "!__FILE!"
    if not !_EXITCODE!==0 goto end
)
goto end

rem ##########################################################################
rem ## Subroutines

rem input parameter: %1=input file
:touch_file
set __FILE=%~1

set __PS1_SCRIPT= ^
if (%_DEBUG% -eq 1) { Get-ItemProperty '%__FILE%' ^| Select LastWriteTime } ^
[System.IO.Directory]::SetLastWriteTime('%__FILE%', (Get-Date)); ^
if (%_DEBUG% -eq 1) { Get-ItemProperty %__FILE% ^| Select LastWriteTime }

if %_DEBUG%==1 echo [%_BASENAME%] powershell -c "..."
powershell -c "%__PS1_SCRIPT%"
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] Execution of ps1 cmdlet failed
    set _EXITCODE=1
    goto :eof
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal

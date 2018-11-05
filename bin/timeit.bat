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

for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIME_START=%%i

if "%1"=="" (
    echo Error: timeit expects a single command or several chained commands 1>&2
    set _EXITCODE=1
    goto end
)

set _CMDS=%1
shift
:loop
if "%1"=="" goto loop_end
    set "_CMDS=!_CMDS:&=^&! %1"
    shift
    goto loop
)
:loop_end
set _CH1=%_CMDS:~0,1%
if not [%_CH1:"=@%]==[@] set _CMDS="%_CMDS:^^=%"

if %_DEBUG%==1 echo [%_BASENAME%] cmd /c %_CMDS%
cmd /c %_CMDS%
if not %ERRORLEVEL%==0 (
    echo Error: Failed to execute commands 1>&2
    set _EXITCODE=1
    call :execution_time "%_TIME_START%"
    goto end
)
call :execution_time "%_TIME_START%"

goto end

rem ##########################################################################
rem ## Subroutines

:execution_time
set __TIME_START=%~1
for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIME_END=%%i

call :duration "%__TIME_START%" "%__TIME_END%"
echo Execution time: %_DURATION%
goto :eof

rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal

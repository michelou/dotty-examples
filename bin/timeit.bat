@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIME_START=%%i

if "%1"=="" (
    echo %_ERROR_LABEL% timeit expects a single command or several chained commands 1>&2
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

if %_DEBUG%==1 echo %_DEBUG_LABEL% cmd /c %_CMDS%
cmd /c %_CMDS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute commands 1>&2
    set _EXITCODE=1
    call :execution_time "%_TIME_START%"
    goto end
)
call :execution_time "%_TIME_START%"

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameter(s): _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _RESET=[0m
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m
goto :eof

:execution_time
set __TIME_START=%~1
for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIME_END=%%i

call :duration "%__TIME_START%" "%__TIME_END%"
echo Execution time: %_DURATION%
goto :eof

@rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

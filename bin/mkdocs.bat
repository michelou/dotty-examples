@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)
if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_GENERATE%==1 (
    call :generate
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
for %%f in ("%~dp0..") do set "_ROOT_DIR=%%~dpf"

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

set _AWK_CMD=awk.exe

set "_AWK_SCRIPT_FILE=%~dp0%_BASENAME%.awk"
if not exist "%_AWK_SCRIPT_FILE%" (
    echo %_ERROR_LABEL% Awk script file not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_DOTTY_DIR=%_ROOT_DIR%\dotty"

set "_INPUT_DIR=%_DOTTY_DIR%\docs\_site"
if not exist "%_INPUT_DIR%\" (
    echo %_ERROR_LABEL% Input directory not found ^(%_INPUT_DIR%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_OUTPUT_DIR=%_DOTTY_DIR%\out\docs_site"
if not exist "%_OUTPUT_DIR%" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% mkdir "%_OUTPUT_DIR%" 1>&2
    mkdir "%_OUTPUT_DIR%"
)
goto :eof

@rem input parameter: %*
@rem output parameter(s): _CLEAN, _DEBUG, _TIMER, _VERBOSE
:args
set _CLEAN=0
set _GENERATE=1
set _HELP=0
set _TIMER=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
   )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="generate" ( set _GENERATE=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _GENERATE=%_GENERATE% 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __BEG_N=%_NORMAL_FG_YELLOW%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __BEG_N=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-debug%__END%      show commands executed by this script
echo     %__BEG_O%-timer%__END%      display total elapsed time
echo     %__BEG_O%-verbose%__END%    display download progress
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        display this help message
echo     %__BEG_O%generate%__END%    generate HTML documentation
goto :eof

:clean
call :rmdir "%_OUTPUT_DIR%"
goto :eof

@rem input parameter(s): %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:generate
if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /q /s /y "%_INPUT_DIR%" "%_OUTPUT_DIR%\" 1>&2
xcopy /q /s /y "%_INPUT_DIR%" "%_OUTPUT_DIR%\" 1>NUL
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to copy files to directory "!_OUTPUT_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto end
)
set __N=0
for /f %%f in ('where /r "%_OUTPUT_DIR%" *.html') do (
    call "%_AWK_CMD%" -v DEBUG=%_DEBUG% -f "%_AWK_SCRIPT_FILE%" "%%f"
    if not !ERRORLEVEL!==0 (
        set _EXITCODE=1
    ) else if exist "%%f.tmp" (
        if %_DEBUG%==1 move "%%f" "%%f.txt" 1>NUL
        move "%%f.tmp" "%%f" 1>NUL
        echo Updated file %%f
        set /a __N+=1
    )
)
echo %__N% file^(s^) have been updated.
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
if %_TIMER%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total elapsed time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

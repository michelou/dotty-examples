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
set _PATH=C:\opt
for /f "delims=" %%f in ('dir /ad /b "%_PATH%\scala-2*" 2^>NUL') do (
    call :asm_version "%_PATH%\%%f"
    if not !_EXITCODE!==0 goto end
)
for /f "delims=" %%f in ('dir /ad /b "%_PATH%\scala3-3*" 2^>NUL') do (
    call :asm_version "%_PATH%\%%f"
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0
set _TIMER=0

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

if not exist "%JAVA_HOME%\bin\jar.exe" (
    echo %_ERROR_LABEL% Java SDK installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_JAR_CMD=%JAVA_HOME%\bin\jar.exe"
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

:args
set _HELP=0
set _RUN=0
set _TIMER=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
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
    if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="run" ( set _RUN=1
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
set _STDOUT_REDIRECT=1^>NUL
if %_DEBUG%==1 set _STDOUT_REDIRECT=

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Properties : _DEBUG=%_DEBUG% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _HELP=%_HELP% _RUN=%_RUN% 1>&2
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
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-debug%__END%     show commands executed by this script
echo     %__BEG_O%-timer%__END%     display total elapsed time
echo     %__BEG_O%-verbose%__END%   display progress messages
echo.
echo   %__BEG_P%Commands:%__END%
echo     %__BEG_O%run%__END%        extract ASM version from installed Scala 2 distributions
goto :eof

@rem input parameter: %1=Scala 2 installation path
:asm_version
set "__SCALA_HOME=%~1"

if "%__SCALA_HOME:scala3=%"=="%__SCALA_HOME%" (
    set __JAR_PREFIX=scala-compiler
    set __SCALA_VERSION=2
) else (
    set __JAR_PREFIX=scala-asm
    set __SCALA_VERSION=3
)
set __JAR_FILE=
for /f "delims=" %%f in ('dir /b /s "%__SCALA_HOME%\lib\%__JAR_PREFIX%*.jar"') do set "__JAR_FILE=%%f"
if not defined __JAR_FILE (
    echo %_ERROR_LABEL% Scala %__SCALA_VERSION% archive file not found 1>&2
    set _EXITCODE=1
	goto :eof
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAR_CMD%" tf "%__JAR_FILE%" ^| findstr asm*.properties 1>&2
) else if %_VERBOSE%==1 ( echo Search ASM property file in archive file "!__JAR_FILE!" 1>&2
)
set _PROP_FILE=
for /f %%f in ('call "%_JAR_CMD%" tf "%__JAR_FILE%" ^| findstr asm*.properties') do set "_PROP_FILE=%%f"
if not defined _PROP_FILE (
    echo %_ERROR_LABEL% ASM property file not found 1>&2
    set _EXITCODE=1
    goto end
)
pushd "%TEMP%"
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAR_CMD%" xf "%__JAR_FILE%" %_PROP_FILE% 1>&2
) else if %_VERBOSE%==1 ( echo Extract ASM property file from archive file "!__JAR_FILE!" 1>&2
)
call "%_JAR_CMD%" xf "%__JAR_FILE%" %_PROP_FILE%
popd
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% findstr /b version "%TEMP%\%_PROP_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Extract ASM version for property file "%_PROP_FILE%" 1>&2
)
set _ASM_VERSION=
for /f "delims=^= tokens=1,*" %%i in ('findstr /b version "%TEMP%\%_PROP_FILE%"') do set "_ASM_VERSION=%%j"
if not defined _ASM_VERSION (
    echo %_DEBUG_LABEL% echo %_DEBUG_LABEL% Version number not found 1>&2
    set _EXITCODE=1
    goto end
) 
echo Found ASM version "%_ASM_VERSION%" in Scala %__SCALA_VERSION% installation is "%__SCALA_HOME%"
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
    echo Total execution time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

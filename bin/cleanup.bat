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
for %%i in (cdsexamples examples myexamples) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :clean_dir "%_ROOT_DIR%%%i" 1>&2
    call :clean_dir "%_ROOT_DIR%%%i"
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
for %%f in ("%~dp0..") do set "_ROOT_DIR=%%~sf\"
@rem when using virtual drives substitute ":\\" by ":\".
set "_ROOT_DIR=%_ROOT_DIR::\\=:\%"

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
@rem background colors: 46m = Cyan (normal) 
@rem foreground colors: 32m = Green (normal),  91m = Red (strong), 93m = Yellow (strong)
set _COLOR_START=[32m
set _COLOR_END=[0m
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:
goto :eof


@rem input parameter: %*
:args
set _HELP=0
set _TIMER=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-help" ( set _HELP=1
    ) else if /i "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if /i "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto :args_loop
:args_done
if %_DEBUG%==1 echo %_DEBUG_LABEL% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug       show commands executed by this script
echo     -help        display this help message
echo     -timer       display total elapsed time
echo     -verbose     display progress messages
echo.
echo   Subcommands:
echo     help         display this help message
goto :eof

@rem input parameter: %1=parent directory
:clean_dir
set __PARENT_DIR=%~1
if not exist "%__PARENT_DIR%" (
    echo %_WARNING_LABEL% Directory not found ^(%__PARENT_DIR%^) 1>&2
	set _EXITCODE=1
	goto :eof
)
set __N=0
for /f %%i in ('dir /ad /b "%__PARENT_DIR%" ^| findstr -v bin') do (
    set "_BUILD_FILE=%__PARENT_DIR%\%%i\build.bat"
    if exist "!_BUILD_FILE!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% _BUILD_FILE=!_BUILD_FILE! 1>&2
        call "!_BUILD_FILE!" clean
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to clean up directory %__PARENT_DIR%\%%i 1>&2
            set _EXITCODE=1
        )
        set /a __N+=1
    ) else (
       if %_DEBUG%==1 echo %_DEBUG_LABEL% File !_BUILD_FILE! not found 1>&2
    )
)
echo Finished to clean up %__N% subdirectories in %__PARENT_DIR%
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

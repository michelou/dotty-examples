@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do set "_ROOT_DIR=%%~sf"

call :env %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

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
echo %__N% files have been updated.
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
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
    echo %_ERROR_LABEL% Input directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_OUTPUT_DIR=%_DOTTY_DIR%\out\docs_site"
if not exist "%_OUTPUT_DIR%" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% mkdir "%_OUTPUT_DIR%" 1>&2
    mkdir "%_OUTPUT_DIR%"
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

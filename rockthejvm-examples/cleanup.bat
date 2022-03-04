@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

call :clean_projects
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

set _DEBUG_LABEL=[%_BASENAME%]
set _ERROR_LABEL=Error:
goto :eof

:clean_projects
for /f "delims=" %%f in ('dir /b /s "%_ROOT_DIR%\build.bat"') do (
    set "__BATCH_FILE=%%f"
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%__BATCH_FILE%" clean 1>&2
    ) else ( echo Execute command "!__BATCH_FILE:%_ROOT_DIR%=!" clean 1>&2
    )
    call "!__BATCH_FILE!" clean
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
exit /b %_EXITCODE%

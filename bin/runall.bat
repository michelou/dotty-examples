@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..\") do set _ROOT_DIR=%%~sf

call :env
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

for %%i in (examples myexamples) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :run "%_ROOT_DIR%%%i" 1>&2
    call :run "%_ROOT_DIR%%%i"
)
goto end

rem ##########################################################################
rem ## Subroutines

rem output parameter(s): _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:
goto :eof

:run
set __PARENT_DIR=%~1
set __N=0
for /f %%i in ('dir /ad /b "%__PARENT_DIR%" ^| findstr -v bin') do (
    echo Running example %%i
    set _BUILD_FILE=%__PARENT_DIR%\%%i\build.bat
    if exist "!_BUILD_FILE!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% "!_BUILD_FILE!" clean run 1>&2
        call "!_BUILD_FILE!" clean run >NUL
        if not !ERRORLEVEL!==0 (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% Failed to run directory %__PARENT_DIR%\%%i 1>&2
            set _EXITCODE=1
        )
        set /a __N+=1
    ) else (
       if %_DEBUG%==1 echo %_DEBUG_LABEL% File !_BUILD_FILE! not found 1>&2
    )
)
echo Finished to run %__N% examples in directory %__PARENT_DIR%
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

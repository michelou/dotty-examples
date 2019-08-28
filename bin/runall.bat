@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..\") do set _ROOT_DIR=%%~sf

rem ##########################################################################
rem ## Main

for %%i in (examples myexamples) do (
    if %_DEBUG%==1 echo [%_BASENAME%] call :run "%_ROOT_DIR%%%i" 1>&2
    call :run "%_ROOT_DIR%%%i"
)
goto end

rem ##########################################################################
rem ## Subroutines

:run
set __PARENT_DIR=%~1
set __N=0
for /f %%i in ('dir /ad /b "%__PARENT_DIR%" ^| findstr -v bin') do (
    echo Running example %%i
    set _BUILD_FILE=%__PARENT_DIR%\%%i\build.bat
    if exist "!_BUILD_FILE!" (
        if %_DEBUG%==1 echo [%_BASENAME%] call "!_BUILD_FILE!" clean run 1>&2
        call "!_BUILD_FILE!" clean run >NUL
        if not !ERRORLEVEL!==0 (
            if %_DEBUG%==1 echo [%_BASENAME%] Failed to run directory %__PARENT_DIR%\%%i 1>&2
            set _EXITCODE=1
        )
        set /a __N+=1
    ) else (
       if %_DEBUG%==1 echo [%_BASENAME%] File !_BUILD_FILE! not found 1>&2
    )
)
echo Finished to run %__N% examples in directory %__PARENT_DIR%
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

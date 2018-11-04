@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do set _ROOT_DIR=%%~sf

rem ##########################################################################
rem ## Main

for %%i in (examples myexamples) do (
    if %_DEBUG%==1 echo [%_BASENAME%] call :clean_dir "%_ROOT_DIR%\%%i"
    call :clean_dir "%_ROOT_DIR%\%%i"
)
goto end

rem ##########################################################################
rem ## Subroutines

:clean_dir
set __PARENT_DIR=%~1
set __N=0
for /f %%i in ('dir /ad /b "%__PARENT_DIR%" ^| findstr -v bin') do (
    set _BUILD_FILE=%__PARENT_DIR%\%%i\build.bat
    if exist "!_BUILD_FILE!" (
        if %_DEBUG%==1 echo [%_BASENAME%] _BUILD_FILE=!_BUILD_FILE!
        call "!_BUILD_FILE!" clean
        if not !ERRORLEVEL!==0 (
            if %_DEBUG%==1 echo [%_BASENAME%] Failed to clean up directory %__PARENT_DIR%\%%i
            set _EXITCODE=1
        )
        set /a __N+=1
    ) else (
       if %_DEBUG%==1 echo [%_BASENAME%] File !_BUILD_FILE! not found
    )
)
echo Finished to clean up %__N% subdirectories in %__PARENT_DIR%
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal

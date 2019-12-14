@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do set _ROOT_DIR=%%~sf\
rem when using virtual drives substitute ":\\" by ":\".
set _ROOT_DIR=%_ROOT_DIR::\\=:\%

call :env
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

for %%i in (cdsexamples examples myexamples) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :clean_dir "%_ROOT_DIR%%%i" 1>&2
    call :clean_dir "%_ROOT_DIR%%%i"
)
goto end

rem ##########################################################################
rem ## Subroutines

rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
rem background colors: 46m = Cyan (normal) 
rem foreground colors: 32m = Green (normal),  91m = Red (strong), 93m = Yellow (strong)
set _COLOR_START=[32m
set _COLOR_END=[0m
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:
goto :eof

rem input parameter: %1=parent directory
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

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

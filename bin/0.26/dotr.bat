@echo off
setlocal enabledelayedexpansion

rem ##########################################################################
rem ## Environment setup

set _EXITCODE=0

if not "%~dp0"=="%CD%\" ( set "_PROG_HOME=%~dp0"
) else ( for /f %%f in ('where "%0"') do set "_PROG_HOME=%%~dpf"
)
call "%_PROG_HOME%\common.bat"
if not %_EXITCODE%==0 goto end

call :args %*

rem ##########################################################################
rem ## Main

set _CASE_1=0
if %_EXECUTE_REPL%==1 set _CASE_1=1
if %_EXECUTE_RUN%==0 if not defined _RESIDUAL_ARGS set _CASE_1=1

set _CASE_2=0
if %_EXECUTE_RUN%==1 set _CASE_2=1
if defined _RESIDUAL_ARGS set _CASE_2=1

rem if [ $execute_repl == true ] || ([ $execute_run == false ] && [ $options_indicator == 0 ]); then
if %_CASE_1%==1 (
    set _DOTC_ARGS=
    if defined _CLASS_PATH set _DOTC_ARGS=-classpath "%_CLASS_PATH%"
    set _DOTC_ARGS=!_DOTC_ARGS! %_JAVA_OPTS% -repl %_RESIDUAL_ARGS%
    echo Starting dotty REPL...
    call "%_PROG_HOME%\dotc.bat" !_DOTC_ARGS!
rem elif [ $execute_repl == true ] || [ ${#residual_args[@]} -ne 0 ]; then
) else if %_CASE_2%==1 (
    set _CP_ARG=%_DOTTY_LIB%%_PSEP%%_SCALA_LIB%
    if defined _CLASS_PATH ( set _CP_ARG=!_CP_ARG!%_PSEP%%_CLASS_PATH%
    ) else ( set _CP_ARG=!_CP_ARG!%_PSEP%.
    )
    if %_CLASS_PATH_COUNT% gtr 1 (
        echo Warning: Multiple classpaths are found, dotr only use the last one. 1>&2
    )
    if %_WITH_COMPILER%==1 (
        set _CP_ARG=!_CP_ARG!%_PSEP%%_DOTTY_COMP%%_PSEP%%_TASTY_CORE%%_PSEP%%_DOTTY_INTF%%_PSEP%%_SCALA_ASM%%_PSEP%%_DOTTY_STAGING%%_PSEP%%_DOTTY_TASTY_INSPECTOR%
    )
    set _JAVA_ARGS=%_JAVA_DEBUG% -classpath "!_CP_ARG!" %_JVM_OPTS% %_RESIDUAL_ARGS%
    call "%_JAVACMD%" !_JAVA_ARGS!
    if not !ERRORLEVEL!==0 ( set _EXITCODE=1& goto end )
) else (
    echo Warning: Command option is not correct. 1>&2
)

goto end

rem ##########################################################################
rem ## Subroutines

:args
set _RESIDUAL_ARGS=
set _EXECUTE_REPL=0
set _EXECUTE_RUN=0
set _WITH_COMPILER=0
set _JAVA_DEBUG=
set _CLASS_PATH_COUNT=0
set _CLASS_PATH=
set _JVM_OPTS=
set _JAVA_OPTS=

:args_loop
if "%~1"=="" goto args_done
set "__ARG=%~1"
if /i "%__ARG%"=="-repl" (
    set _EXECUTE_REPL=1
) else if /i "%__ARG%"=="-run" (
    set _EXECUTE_RUN=1
) else if /i "%__ARG%"=="-classpath" (
    set _CLASS_PATH=%~2
    set /a _CLASS_PATH_COUNT+=1
    shift
) else if /i "%__ARG%"=="-cp" (
    set _CLASS_PATH=%~2
    set /a _CLASS_PATH_COUNT+=1
    shift
) else if /i "%__ARG%"=="-with-compiler" (
    set _WITH_COMPILER=1
) else if /i "%__ARG%"=="-d" (
    set _JAVA_DEBUG=%_DEBUG_STR%
) else if /i "%__ARG:~0,2%"=="-J" (
    set _JVM_OPTS=!_JVM_OPTS! %__ARG:~2%
    set _JAVA_OPTS=!_JAVA_OPTS! %__ARG%
) else (
    set _RESIDUAL_ARGS=%_RESIDUAL_ARGS% %__ARG%
)
shift
goto args_loop
:args_done
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
exit /b %_EXITCODE%
endlocal

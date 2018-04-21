@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _EXITCODE=0

set _BASENAME=%~n0

for %%f in ("%~dp0..") do set _PROG_HOME=%%~sf

call %_PROG_HOME%\bin\common.bat
if not %_EXITCODE%==0 goto end

call :args %*

rem ##########################################################################
rem ## Main

call :classpathArgs

if defined JAVA_OPTS ( set _JAVA_OPTS=%JAVA_OPTS%
) else ( set _JAVA_OPTS=-Xmx768m -Xms768m
)
if %_DEBUG%==1 echo [%_BASENAME%] %_JAVACMD% %_JAVA_OPTS% %_JAVA_DEBUG% %_JVM_CP_ARGS% %_JAVA_ARGS%
%_JAVACMD% %_JAVA_OPTS% %_JAVA_DEBUG% %_JVM_CP_ARGS% %_JAVA_ARGS%
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto end
)
goto end

rem ##########################################################################
rem ## Subroutines

:args
set _JAVA_DEBUG=
set _JAVA_ARGS=
:args_loop
if "%~1"=="" goto args_done
set _ARG=%~1
if %_DEBUG%==1 echo [%_BASENAME%] _ARG=%_ARG%
if "%_ARG%"=="--" (
    rem for arg; do addResidual "$arg"; done; set -- ;;
) else if /i "%_ARG%"=="-debug" (
    set _JAVA_DEBUG=%_DEBUG_STR%
) else (
    call :addJava "%_ARG%"
)
shift
goto args_loop
:args_done
goto :eof

rem output parameter: _JAVA_ARGS
:addJava
set _JAVA_ARGS=%_JAVA_ARGS% %~1
if %_DEBUG%==1 echo [%_BASENAME%] _JAVA_ARGS=%_JAVA_ARGS%
goto :eof

rem output parameter: _JVM_CP_ARGS
:classpathArgs
rem echo dotty-compiler: %_DOTTY_COMP%
rem echo dotty-interface: %_DOTTY_INTF%
rem echo dotty-library: %_DOTTY_LIB%
rem echo scala-asm: %_SCALA_ASM%
rem echo scala-lib: %_SCALA_LIB%
rem echo scala-xml: %_SCALA_XML%
rem echo sbt-intface: %_SBT_INTF%

set __TOOLCHAIN=%_SCALA_LIB%%_PSEP%
set __TOOLCHAIN=%__TOOLCHAIN%%_DOTTY_LIB%%_PSEP%
set __TOOLCHAIN=%__TOOLCHAIN%%_SCALA_ASM%%_PSEP%
set __TOOLCHAIN=%__TOOLCHAIN%%_SBT_INTF%%_PSEP%
set __TOOLCHAIN=%__TOOLCHAIN%%_DOTTY_INTF%%_PSEP%
set __TOOLCHAIN=%__TOOLCHAIN%%_DOTTY_LIB%%_PSEP%
set __TOOLCHAIN=%__TOOLCHAIN%%_DOTTY_COMP%

if not defined _BOOTCP (
    set _JVM_CP_ARGS=-Xbootclasspath/a:%__TOOLCHAIN%
) else (
    set _JVM_CP_ARGS=-classpath %__TOOLCHAIN%
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal


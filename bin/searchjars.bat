@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

set _CLASS_NAME=%~1
if not defined _CLASS_NAME (
    echo Warning: No class name specified; defaulting to 'Jar'. 1>&2
    set _CLASS_NAME=Jar
)

rem ##########################################################################
rem ## Main

call :init
if not %_EXITCODE%==0 goto end

call :search "%_DOTTY_HOME%\lib"
if not %_EXITCODE%==0 goto end

call :search "%_SCALA_HOME%\lib"
if not %_EXITCODE%==0 goto end

call :search "%_JAVA_HOME%\lib"
if not %_EXITCODE%==0 goto end

goto end

rem ##########################################################################
rem ## Subroutines

rem output parameters: _JAR_CMD, _JAVA_HOME, _DOTTY_HOME, _SCALA_HOME
:init
where /q jar.exe
if not %ERRORLEVEL%==0 (
    echo Error: jar command not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _JAR_CMD=jar.exe
for /f "delims=" %%i in ('where "%_JAR_CMD%"') do (
    for %%f in ("%%~dpi..") do set _JAVA_HOME=%%~sf
)
if not exist "%_JAVA_HOME%\lib\" (
    echo Error: Java library directory not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)

where /q dotc.bat
if not %ERRORLEVEL%==0 (
    echo Error: dotc command not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims=" %%i in ('where dotc.bat') do (
    for %%f in ("%%~dpi..") do set _DOTTY_HOME=%%~sf
)
if not exist "%_DOTTY_HOME%\lib\" (
    echo Error: Dotty library directory not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)

where /q scalac.bat
if not %ERRORLEVEL%==0 (
    echo Error: scalac command not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims=" %%i in ('where scalac.bat') do (
    for %%f in ("%%~dpi..") do set _SCALA_HOME=%%~sf
)
if not exist "%_SCALA_HOME%\lib\" (
    echo Error: Scala library directory not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

rem input parameter: %1=lib directory
:search
set __LIB_DIR=%~1
echo Searching for class %_CLASS_NAME% in library files %__LIB_DIR%\*.jar
for /f %%i in ('dir /b "%__LIB_DIR%\*.jar" 2^>NUL') do (
    set _JAR_FILE=%__LIB_DIR%\%%i
    for %%f in (!_JAR_FILE!) do set _JAR_FILENAME=%%~nxf
    if %_DEBUG%==1 echo [%_BASENAME%] %_JAR_CMD% -tvf "!_JAR_FILE!" ^| findstr "%_CLASS_NAME%"
    for /f "delims=" %%f in ('%_JAR_CMD% -tvf "!_JAR_FILE!" ^| findstr "%_CLASS_NAME%"') do (
        for %%x in (%%f) do set _LAST=%%x
        echo   !_JAR_FILENAME!:!_LAST!
    )
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal

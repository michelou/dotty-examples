@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

set _JAR_CMD=jar.exe

set _CLASS_NAME=%~1
if not defined _CLASS_NAME set _CLASS_NAME=Jar

if defined DOTTY_HOME (
    set _DOTTY_HOME=%DOTTY_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable DOTTY_HOME
) else (
    where /q dotc.bat
    if !ERRORLEVEL!==0 (
        for /f "delims=" %%i in ('where /f dotc.bat') do set _DOTTY_BIN_DIR=%%~dpsi
        for /f %%f in ("!_DOTTY_BIN_DIR!..") do set _DOTTY_HOME=%%~sf
        if %_DEBUG%==1 echo [%_BASENAME%] Using path of dotc executable found in PATH
    ) else (
        set _PATH=C:\opt
        for /f %%f in ('dir /ad /b "!_PATH!\dotty-*" 2^>NUL') do set _DOTTY_HOME=!_PATH!\%%f
        if defined _DOTTY_HOME (
            rem path name of installation directory may contain spaces
            for /f "delims=" %%f in ("!_DOTTY_HOME!") do set _DOTTY_HOME=%%~sf
            if %_DEBUG%==1 echo [%_BASENAME%] Using default Dotty installation directory !_DOTTY_HOME!
        )
    )
)
if not exist "%_DOTTY_HOME%\bin\dotc.bat" (
    if %_DEBUG%==1 echo [%_BASENAME%] Dotty installation directory %_DOTTY_HOME% not found
    set _EXITCODE=1
    goto end
)
set _DOTTY_LIB_DIR=%_DOTTY_HOME%\lib

if defined SCALA_HOME (
    set _SCALA_HOME=%SCALA_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable SCALA_HOME
) else (
    where /q scalac.bat
    if !ERRORLEVEL!==0 (
        for /f "delims=" %%i in ('where /f scalac.bat') do set _SCALA_BIN_DIR=%%~dpsi
        for /f %%f in ("!_SCALA_BIN_DIR!..") do set _SCALA_HOME=%%~sf
        if %_DEBUG%==1 echo [%_BASENAME%] Using path of scalac executable found in PATH
    ) else (
        set _PATH=C:\opt
        for /f %%f in ('dir /ad /b "!_PATH!\scala-*" 2^>NUL') do set _SCALA_HOME=!_PATH!\%%f
        if defined _SCALA_HOME (
            rem path name of installation directory may contain spaces
            for /f "delims=" %%f in ("!_SCALA_HOME!") do set _SCALA_HOME=%%~sf
            if %_DEBUG%==1 echo [%_BASENAME%] Using default Scala installation directory !_SCALA_HOME!
        )
    )
)
if not exist "%_SCALA_HOME%\bin\scalac.bat" (
    if %_DEBUG%==1 echo [%_BASENAME%] Scala installation directory %_SCALA_HOME% not found
    set _EXITCODE=1
    goto end
)
set _SCALA_LIB_DIR=%_SCALA_HOME%\lib

rem ##########################################################################
rem ## Main

echo Search for class %_CLASS_NAME% in library files %_DOTTY_LIB_DIR%\*.jar
for /f %%i in ('dir /b "%_DOTTY_LIB_DIR%\*.jar"') do (
    set _JAR_FILE=%_DOTTY_LIB_DIR%\%%i
    for %%f in (!_JAR_FILE!) do set _JAR_FILENAME=%%~nxf
    if %_DEBUG%==1 echo [%_BASENAME%] %_JAR_CMD% -tvf "!_JAR_FILE!" ^| findstr "%_CLASS_NAME%"
    for /f "delims=" %%f in ('%_JAR_CMD% -tvf "!_JAR_FILE!" ^| findstr "%_CLASS_NAME%"') do (
        for %%x in (%%f) do set _LAST=%%x
        echo   !_JAR_FILENAME!:!_LAST!
    )
)

echo Search for class %_CLASS_NAME% in library files %_SCALA_LIB_DIR%\*.jar
for /f %%i in ('dir /b "%_SCALA_LIB_DIR%\*.jar"') do (
    set _JAR_FILE=%_SCALA_LIB_DIR%\%%i
    for %%f in (!_JAR_FILE!) do set _JAR_FILENAME=%%~nxf
    if %_DEBUG%==1 echo [%_BASENAME%] %_JAR_CMD% -tvf "!_JAR_FILE!" ^| findstr "%_CLASS_NAME%"
    for /f "delims=" %%f in ('%_JAR_CMD% -tvf "!_JAR_FILE!" ^| findstr "%_CLASS_NAME%"') do (
        for %%j in (%%f) do set _LAST=%%j
        echo   !_JAR_FILENAME!:!_LAST!
    )
)
goto end

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal

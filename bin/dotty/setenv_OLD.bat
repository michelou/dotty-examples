@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

call :args %*
if not %_EXITCODE%==0 goto end
if defined _HELP call :help & exit /b %_EXITCODE%

rem ##########################################################################
rem ## Main

set _JDK_PATH=
set _SBT_PATH=
set _GIT_PATH=

call :jdk
if not %_EXITCODE%==0 goto end

call :jdk11
if not %_EXITCODE%==0 goto end

call :sbt
if not %_EXITCODE%==0 goto end

call :git
if not %_EXITCODE%==0 goto end

if defined _UPDATE (
    where /q git.exe
    if !ERRORLEVEL!==0 ( set __GIT_CMD=git.exe
    ) else ( set __GIT_CMD=%_GIT_HOME%\bin\git.exe
    )
    "!__GIT_CMD!" remote add upstream https://github.com/lampepfl/dotty.git
    "!__GIT_CMD!" fetch upstream
)

goto end

rem ##########################################################################
rem ## Subroutines

rem input parameter: %*
rem output parameter: _HELP, _VERBOSE, _UPDATE
:args
set _HELP=
set _VERBOSE=0
set _UPDATE=

:args_loop
set __ARG=%~1
if not defined __ARG goto args_done
if /i "%__ARG%"=="help" ( set _HELP=1& goto :eof
) else if /i "%__ARG%"=="update" ( set _UPDATE=1
) else if /i "%__ARG%"=="-debug" ( set _DEBUG=1
) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
) else (
    echo Error: Unknown subcommand %__ARG% 1>&2
    set _EXITCODE=1
    goto :eof
)
shift
goto args_loop
:args_done
goto :eof

:help
echo Usage: %_BASENAME% { options ^| subcommands }
echo   Options:
echo     -verbose         display environment settings
echo   Subcommands:
echo     help             display this help message
echo     update           update repository from remote master
goto :eof

rem output parameter(s): _JDK_HOME, _JDK_PATH
:jdk
set _JDK_HOME=
set _JDK_PATH=

set __JAVAC_CMD=
for /f %%f in ('where javac.exe 2^>NUL') do set __JAVAC_CMD=%%f
if defined __JAVAC_CMD (
    if %_DEBUG%==1 echo [%_BASENAME%] Using path of javac executable found in PATH 1>&2
    rem keep _JDK_PATH undefined since executable already in path
    goto :eof
) else if defined JDK_HOME (
    set "_JDK_HOME=%JDK_HOME%"
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable JDK_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\jdk-1.8*" 2^>NUL') do set _JDK_HOME=!__PATH!\%%f
    if not defined _JDK_HOME (
        set __PATH=C:\Progra~1\Java
        for /f %%f in ('dir /ad /b "!__PATH!\jdk-1.8*" 2^>NUL') do set _JDK_HOME=!__PATH!\%%f
    )
    if defined _JDK_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Java SDK installation directory !_JDK_HOME! 1>&2
    )
)
if not exist "%_JDK_HOME%\bin\javac.exe" (
    echo Error: javac executable not found ^(%_JDK_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
rem variable _JDK_PATH is prepended to PATH, so path separator must appear as last character
set "_JDK_PATH=%_JDK_HOME%\bin;"
goto :eof

rem output parameter(s): _JDK11_HOME
:jdk11
set _JDK11_HOME=

set __JAVAC_CMD=
for /f %%f in ('where javac.exe 2^>NUL') do set __JAVAC_CMD=%%f
if defined __JAVAC_CMD (
    call :is_java11 "%__JAVAC_CMD%"
    if defined _IS_JAVA11 (
        for %%i in ("%__JAVAC_CMD%") do set __BIN_DIR=%%~dpsi
        for %%f in ("%__BIN_DIR%") do set _JDK11_HOME=%%~dpsi
    )
)
if not defined _JDK11_HOME if defined JDK_HOME (
    call :is_java11 "%JDK_HOME%\bin\javac.exe"
    if defined _IS_JAVA11 (
        set _JDK11_HOME=%JDK_HOME%
        if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable JDK_HOME 1>&2
    )
)
if not defined _JDK11_HOME (
    set __PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\jdk-11*" 2^>NUL') do set _JDK11_HOME=!__PATH!\%%f
)
if not defined _JDK11_HOME (
    set __PATH=C:\Progra~1\Java
    for /f %%f in ('dir /ad /b "!__PATH!\jdk-11*" 2^>NUL') do set _JDK11_HOME=!__PATH!\%%f
)
if not exist "%_JDK11_HOME%\bin\javac.exe" (
    echo Error: javac executable not found ^(%_JDK11_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

rem input parameter(s): %1 = javac file path
rem output parameter(s): _IS_JAVA11
:is_java11
set _IS_JAVA11=

set __JAVAC_CMD=%~1
if not exist "%__JAVAC_CMD%" goto :eof

set __JAVA_VERSION=
for /f "tokens=1,*" %%i in ('%__JAVAC_CMD% -version 2^>^&1') do set __JAVA_VERSION=%%j
if not "!__JAVA_VERSION:~0,2!"=="11" goto :eof
set _IS_JAVA11=1
goto :eof

rem output parameter(s): _SBT_PATH
:sbt
set _SBT_PATH=

set __SBT_HOME=
set __SBT_CMD=
for /f %%f in ('where sbt.bat 2^>NUL') do set __SBT_CMD=%%f
if defined __SBT_CMD (
    if %_DEBUG%==1 echo [%_BASENAME%] Using path of sbt executable found in PATH 1>&2
    rem keep _SBT_PATH undefined since executable already in path
    goto :eof
) else if defined SBT_HOME (
    set "__SBT_HOME=%SBT_HOME%"
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable SBT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\sbt\" ( set "__SBT_HOME=!__PATH!\sbt"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\sbt-1*" 2^>NUL') do set "__SBT_HOME=!__PATH!\%%f"
        if not defined __SBT_HOME (
            set __PATH=C:\Progra~1
            for /f %%f in ('dir /ad /b "!__PATH!\sbt-1*" 2^>NUL') do set "__SBT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%__SBT_HOME%\bin\sbt.bat" (
    echo Error: sbt executable not found ^(%__SBT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SBT_PATH=;%__SBT_HOME%\bin"
goto :eof

rem output parameter(s): _GIT_PATH
:git
set _GIT_PATH=

set __GIT_HOME=
set __GIT_EXE=
for /f %%f in ('where git.exe 2^>NUL') do set __GIT_EXE=%%f
if defined __GIT_EXE (
    if %_DEBUG%==1 echo [%_BASENAME%] Using path of Git executable found in PATH 1>&2
    rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "__GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable GIT_HOME
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set "__GIT_HOME=!__PATH!\Git"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "__GIT_HOME=!__PATH!\%%f"
        if not defined __GIT_HOME (
            set __PATH=C:\Progra~1
            for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "__GIT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%__GIT_HOME%\bin\git.exe" (
    echo Error: Git executable not found ^(%__GIT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
rem path name of installation directory may contain spaces
for /f "delims=" %%f in ("%__GIT_HOME%") do set __GIT_HOME=%%~sf
if %_DEBUG%==1 echo [%_BASENAME%] Using default Git installation directory %__GIT_HOME% 1>&2

set "_GIT_PATH=;%__GIT_HOME%\bin;%__GIT_HOME%\usr\bin;%__GIT_HOME%\mingw64\bin"
goto :eof

rem output parameter: _SBT_VERSION
rem Note: SBT requires special handling to know its version (no comment)
:sbt_version
set _SBT_VERSION=x.x.x
goto :eof
for /f %%i in ('where sbt.bat') do for %%f in ("%%~dpi..") do set __SBT_LAUNCHER=%%~sf\bin\sbt-launch.jar
for /f "tokens=1,*" %%i in ('java.exe -jar "%__SBT_LAUNCHER%" sbtVersion ^| findstr [0-9].[0-9]') do set _SBT_VERSION=%%j
for /f "tokens=1,*" %%i in ('java.exe -jar "%__SBT_LAUNCHER%" scalaVersion ^| findstr [0-9].[0-9]') do set _SBT_VERSION=%_SBT_VERSION%/%%j
goto :eof

:print_env
set __VERBOSE=%1
set __VERSIONS_LINE1=
set __VERSIONS_LINE2=
set __WHERE_ARGS=
where /q javac.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('javac.exe -version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% javac %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% javac.exe
)
where /q java.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('java.exe -version 2^>^&1 ^| findstr version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% java %%~k,"
    set __WHERE_ARGS=%__WHERE_ARGS% java.exe
)
where /q "%JDK11_HOME%\bin:javac.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%JDK11_HOME%\bin\javac.exe" -version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% javac %%j"
    set __WHERE_ARGS=%__WHERE_ARGS% "%JDK11_HOME%\bin:javac.exe"
)
call :sbt_version
if defined _SBT_VERSION (
    set __VERSIONS_LINE2=%__VERSIONS_LINE2% sbt %_SBT_VERSION%,
    set __WHERE_ARGS=%__WHERE_ARGS% sbt.bat
)
where /q git.exe
if %ERRORLEVEL%==0 (
   for /f "tokens=1,2,*" %%i in ('git.exe --version') do set __VERSIONS_LINE2=%__VERSIONS_LINE2% git %%k,
    set __WHERE_ARGS=%__WHERE_ARGS% git.exe
)
where /q diff.exe
if %ERRORLEVEL%==0 (
   for /f "tokens=1-3,*" %%i in ('diff.exe --version ^| findstr diff') do set __VERSIONS_LINE2=%__VERSIONS_LINE2% diff %%l
    set __WHERE_ARGS=%__WHERE_ARGS% diff.exe
)
echo Tool versions:
echo   %__VERSIONS_LINE1%
echo   %__VERSIONS_LINE2%
if %__VERBOSE%==1 (
    rem if %_DEBUG%==1 echo [%_BASENAME%] where %__WHERE_ARGS%
    echo Tool paths:
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do echo    %%p
)

set __BRANCH_NAME=unknown
for /f %%i in ('git.exe rev-parse --abbrev-ref HEAD') do set __BRANCH_NAME=%%i
echo Current Git branch:
echo   %__BRANCH_NAME%
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
endlocal & (
    if not defined JAVA_HOME set JAVA_HOME=%_JDK_HOME%
    if not defined JDK_HOME set JDK_HOME=%_JDK_HOME%
    if not defined JDK11_HOME set JDK11_HOME=%_JDK11_HOME%
    set "PATH=%_JDK_PATH%%PATH%%_SBT_PATH%%_GIT_PATH%;%~dp0project\scripts"
    call :print_env %_VERBOSE%
    if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)

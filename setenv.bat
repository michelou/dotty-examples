@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

if defined _HELP (
    call :help
    exit /b !_EXITCODE!
)

set _ANT_PATH=
set _BLOOP_PATH=
set _CFR_PATH=
set _DOTTY_PATH=
set _GIT_PATH=
set _GRADLE_PATH=
set _JDK_PATH=
set _JMC_PATH=
set _MILL_PATH=
set _MVN_PATH=
set _PYTHON_PATH=
set _SBT_PATH=
set _SCALA_PATH=
set _VSCODE_PATH=

call :jdk
if not %_EXITCODE%==0 goto end

call :jdk11
if not %_EXITCODE%==0 goto end

call :scalac
if not %_EXITCODE%==0 goto end

call :dotc
if not %_EXITCODE%==0 goto end

call :sbt
if not %_EXITCODE%==0 goto end

call :ant
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Ant installation not found 1>&2
    set _EXITCODE=0
)
call :bloop
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Bloop installation not found 1>&2
    set _EXITCODE=0
)
call :cfr
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% CFR installation not found 1>&2
    set _EXITCODE=0
)
call :gradle
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Gradle installation not found 1>&2
    set _EXITCODE=0
)
call :jmc
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Java Mission Control installation not found 1>&2
    set _EXITCODE=0
)
call :mill
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Mill installation not found 1>&2
    set _EXITCODE=0
)
call :mvn
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Maven installation not found 1>&2
    set _EXITCODE=0
)
call :vscode
if not %_EXITCODE%==0 goto end

call :git
if not %_EXITCODE%==0 goto end

if "%~1"=="clean" call :clean

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

for /f "tokens=1,* delims=:" %%i in ('chcp') do set _CODE_PAGE_DEFAULT=%%j
@rem make sure we use UTF-8 encoding for console outputs
chcp 65001 1>NUL
goto :eof

@rem input parameter: %*
@rem output parameter: _HELP, _VERBOSE
:args
set _HELP=
set _BASH=0
set _VERBOSE=0

:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if /i "%__ARG%"=="-bash" ( set _BASH=1
    ) else if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if /i "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto args_loop
:args_done
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -bash       start Git bash shell instead of Windows command prompt
echo     -debug      show commands executed by this script
echo     -verbose    display environment settings
echo.
echo   Subcommands:
echo     help        display this help message
goto :eof

@rem output parameter(s): _JDK_HOME
:jdk
set _JDK_HOME=

set __JAVAC_CMD=
for /f %%f in ('where javac.exe 2^>NUL') do set __JAVAC_CMD=%%f
if defined __JAVAC_CMD (
    call :is_java11 "%__JAVAC_CMD%"
    if not defined _IS_JAVA11 (
        for %%i in ("%__JAVAC_CMD%") do set "__BIN_DIR=%%~dpsi"
        for %%f in ("%__BIN_DIR%") do set "_JDK_HOME=%%~dpsi"
    )
)
if defined JDK_HOME (
    set "_JDK_HOME=%JDK_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JDK_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!_PATH!\jdk-1.8*" 2^>NUL') do set "_JDK_HOME=!_PATH!\%%f"
    if not defined _JDK_HOME (
        set "_PATH=%ProgramFiles%\Java"
        for /f %%f in ('dir /ad /b "!_PATH!\jdk1.8*" 2^>NUL') do set "_JDK_HOME=!_PATH!\%%f"
    )
    if defined _JDK_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Java SDK installation directory !_JDK_HOME! 1>&2
    )
)
if not exist "%_JDK_HOME%\bin\javac.exe" (
    echo %_ERROR_LABEL% javac executable not found ^(%_JDK_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem variable _JDK_PATH is prepended to PATH, so path separator must appear as last character
set "_JDK_PATH=%_JDK_HOME%\bin;"
goto :eof

@rem output parameter(s): _JDK11_HOME
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
        set "_JDK11_HOME=%JDK_HOME%"
        if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable JDK_HOME 1>&2
    )
)
if not defined _JDK11_HOME (
    set __PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\jdk-11*" 2^>NUL') do set "_JDK11_HOME=!__PATH!\%%f"
)
if not defined _JDK11_HOME (
    set "__PATH=%ProgramFiles%\Java"
    for /f %%f in ('dir /ad /b "!__PATH!\jdk-11*" 2^>NUL') do set "_JDK11_HOME=!__PATH!\%%f"
)
if not exist "%_JDK11_HOME%\bin\javac.exe" (
    echo Error: javac executable not found ^(%_JDK11_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter(s): %1 = javac file path
@rem output parameter(s): _IS_JAVA11
:is_java11
set _IS_JAVA11=

set __JAVAC_CMD=%~1
if not exist "%__JAVAC_CMD%" goto :eof

set __JAVA_VERSION=
for /f "tokens=1,*" %%i in ('%__JAVAC_CMD% -version 2^>^&1') do set __JAVA_VERSION=%%j
if not "!__JAVA_VERSION:~0,2!"=="11" goto :eof
set _IS_JAVA11=1
goto :eof

:scalac
where /q scalac.bat
if %ERRORLEVEL%==0 goto :eof

if defined SCALA_HOME (
    set "_SCALA_HOME=%SCALA_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SCALA_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\scala-2*" 2^>NUL') do set _SCALA_HOME=!_PATH!\%%f
    if defined _SCALA_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Scala installation directory !_SCALA_HOME!
    )
)
if not exist "%_SCALA_HOME%\bin\scalac.bat" (
    echo %_ERROR_LABEL% Scala executable not found ^(%_SCALA_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SCALA_PATH=;%_SCALA_HOME%\bin"
goto :eof

@rem output parameter(s): _DOTTY_HOME, _DOTTY_PATH
:dotc
set _DOTTY_HOME=
set _DOTTY_PATH=

set __DOTC_CMD=
for /f %%f in ('where dotc.bat 2^>NUL') do set "__DOTC_CMD=%%f"
if defined __DOTC_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Dotty executable found in PATH 1>&2
    for %%i in ("%__DOTC_CMD%") do set "__DOTTY_BIN_DIR=%%~dpi"
    for %%f in ("!__DOTTY_BIN_DIR!..") do set "_DOTTY_HOME=%%f"
    @rem keep _DOTTY_PATH undefined since executable already in path
    goto :eof
) else if defined DOTTY_HOME (
    set "_DOTTY_HOME=%DOTTY_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable DOTTY_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\dotty*" 2^>NUL') do set "_DOTTY_HOME=!_PATH!\%%f"
    if defined _DOTTY_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Dotty installation directory !_DOTTY_HOME! 1>&2
    )
)
if not exist "%_DOTTY_HOME%\bin\dotc.bat" (
    echo %_ERROR_LABEL% Dotty executable not found ^(%_DOTTY_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_DOTTY_PATH=;%_DOTTY_HOME%\bin"
goto :eof

@rem output parameter(s): _SBT_PATH
:sbt
set _SBT_PATH=

set __SBT_HOME=
set __SBT_CMD=
for /f %%f in ('where sbt.bat 2^>NUL') do set "__SBT_CMD=%%f"
if defined __SBT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of sbt executable found in PATH 1>&2
    rem keep _SBT_PATH undefined since executable already in path
    goto :eof
) else if defined SBT_HOME (
    set "__SBT_HOME=%SBT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SBT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\sbt\" ( set "__SBT_HOME=!__PATH!\sbt"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\sbt-1*" 2^>NUL') do set "__SBT_HOME=!__PATH!\%%f"
        if not defined __SBT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\sbt-1*" 2^>NUL') do set "__SBT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%__SBT_HOME%\bin\sbt.bat" (
    echo %_ERROR_LABEL% sbt executable not found ^(%__SBT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SBT_PATH=;%__SBT_HOME%\bin"
goto :eof

@rem output parameter(s): _ANT_HOME, _ANT_PATH
:ant
set _ANT_HOME=
set _ANT_PATH=

set __ANT_CMD=
for /f %%f in ('where ant.bat 2^>NUL') do set "__ANT_CMD=%%f"
if defined __ANT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Ant executable found in PATH 1>&2
    for %%i in ("%__ANT_CMD%") do set "__ANT_BIN_DIR=%%~dpi"
    for %%f in ("!__ANT_BIN_DIR!..") do set "_ANT_HOME=%%f"
    rem keep _ANT_PATH undefined since executable already in path
    goto :eof
) else if defined ANT_HOME (
    set "_ANT_HOME=%ANT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable ANT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\apache-ant\" ( set _ANT_HOME=!__PATH!\apache-ant
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\apache-ant-*" 2^>NUL') do set "_ANT_HOME=!__PATH!\%%f"
        if not defined _ANT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\apache-ant-*" 2^>NUL') do set "_ANT_HOME=!__PATH!\%%f"
        )
    )
    if defined _ANT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Ant installation directory !_ANT_HOME! 1>&2
    )
)
if not exist "%_ANT_HOME%\bin\ant.cmd" (
    echo %_ERROR_LABEL% Ant executable not found ^(%_ANT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_ANT_PATH=;%_ANT_HOME%\bin"
goto :eof

rem http://www.benf.org/other/cfr/
:cfr
where /q cfr.bat
if %ERRORLEVEL%==0 goto :eof

if defined CFR_HOME (
    set "_CFR_HOME=%CFR_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable CFR_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\cfr*" 2^>NUL') do set "_CFR_HOME=!_PATH!\%%f"
    if defined _CFR_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default cfr installation directory !_CFR_HOME! 1>&2
    )
)
if not exist "%_CFR_HOME%\bin\cfr.bat" (
    echo %_ERROR_LABEL% cfr executable not found ^(%_CFR_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CFR_PATH=;%_CFR_HOME%\bin"
goto :eof

:gradle
where /q gradle.bat
if %ERRORLEVEL%==0 goto :eof

if defined GRADLE_HOME (
    set _GRADLE_HOME=%GRADLE_HOME%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GRADLE_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\gradle\" ( set _GRADLE_HOME=!__PATH!\gradle
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\gradle-*" 2^>NUL') do set "_GRADLE_HOME=!__PATH!\%%f"
        if not defined _GRADLE_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\gradle-*" 2^>NUL') do set "_GRADLE_HOME=!__PATH!\%%f"
        )
    )
    if defined _GRADLE_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Gradle installation directory !_GRADLE_HOME! 1>&2
    )
)
if not exist "%_GRADLE_HOME%\bin\gradle.bat" (
    echo %_ERROR_LABEL% Gradle executable not found ^(%_GRADLE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GRADLE_PATH=;%_GRADLE_HOME%\bin"
goto :eof

@rem output parameter(s): _JMC_HOME, _JMC_PATH
:jmc
set _JMC_HOME=
set _JMC_PATH=

set __JMC_CMD=
for /f %%f in ('where jmc.exe 2^>NUL') do set "__JMC_CMD=%%f"
if defined __JMC_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of JMC executable found in PATH 1>&2
    for %%i in ("%__JMC_CMD%") do set "__JMC_BIN_DIR=%%~dpi"
    for %%f in ("!__JMC_JMC_DIR!..") do set "_JMC_HOME=%%f"
    rem keep _JMC_PATH undefined since executable already in path
    goto :eof
) else if defined JMC_HOME (
    set "_JMC_HOME=%JMC_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JMC_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\jmc\" ( set "_JMC_HOME=!__PATH!\jmc"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\jmc-*" 2^>NUL') do set "_JMC_HOME=!__PATH!\%%f"
        if not defined _JMC_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\jmc-*" 2^>NUL') do set "_JMC_HOME=!__PATH!\%%f"
        )
    )
    if defined _JMC_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default JMC installation directory !_JMC_HOME! 1>&2
    )
)
if not exist "%_JMC_HOME%\bin\jmc.exe" (
    echo %_ERROR_LABEL% JMC executable not found ^(%_JMC_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_JMC_PATH=;%_JMC_HOME%\bin"
goto :eof

:mill
where /q mill.bat
if %ERRORLEVEL%==0 goto :eof

if defined MILL_HOME (
    set "_MILL_HOME=%MILL_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MILL_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\mill\" ( set _MILL_HOME=!__PATH!\mill
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\mill-*" 2^>NUL') do set "_MILL_HOME=!__PATH!\%%f"
        if not defined _MILL_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\mill-*" 2^>NUL') do set "_MILL_HOME=!__PATH!\%%f"
        )
    )
    if defined _MILL_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Mill installation directory !_MILL_HOME! 1>&2
    )
)
if not exist "%_MILL_HOME%\mill.bat" (
    echo %_ERROR_LABEL% Mill executable not found ^(%_MILL_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MILL_PATH=;%_MILL_HOME%"
goto :eof

:mvn
where /q mvn.cmd
if %ERRORLEVEL%==0 goto :eof

if defined MAVEN_HOME (
    set "_MVN_HOME=%MAVEN_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MAVEN_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\apache-maven-*" 2^>NUL') do set "_MVN_HOME=!_PATH!\%%f"
    if defined _MVN_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Maven installation directory !_MVN_HOME! 1>&2
    )
)
if not exist "%_MVN_HOME%\bin\mvn.cmd" (
    echo %_ERROR_LABEL% Maven executable not found ^(%_MVN_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MVN_PATH=;%_MVN_HOME%\bin"
goto :eof

rem output parameter(s): _PYTHON_PATH
:python
set _PYTHON_PATH=

set __PYTHON_HOME=
set __PYTHON_CMD=
for /f %%f in ('where python.exe 2^>NUL ^| findstr /v WindowsApps') do set "__PYTHON_CMD=%%f"
if defined __PYTHON_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Python executable found in PATH 1>&2
    rem keep _PYTHON_PATH undefined since executable already in path
    goto :eof
) else if defined PYTHON_HOME (
    set "__PYTHON_HOME=%PYTHON_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable PYTHON_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\Python*" 2^>NUL') do set "__PYTHON_HOME=!_PATH!\%%f"
    if defined __PYTHON_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Python installation directory !__PYTHON_HOME! 1>&2
    )
)
if not exist "%__PYTHON_HOME%\python.exe" (
    echo %_ERROR_LABEL% Python executable not found ^(%__PYTHON_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem variable _PYTHON_PATH is prepended to PATH, so path separator must appear as last character
set "_PYTHON_PATH=%__PYTHON_HOME%;"
goto :eof

@rem output parameter(s): _BLOOP_PATH
:bloop
set _BLOOP_PATH=

@rem bloop depends on python
call :python
if not %_EXITCODE%==0 goto :eof

set __BLOOP_HOME=
set __BLOOP_CMD=
for /f %%f in ('where bloop.cmd 2^>NUL') do set "__BLOOP_CMD=%%f"
if defined __BLOOP_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of bloop executable found in PATH 1>&2
    rem keep _BLOOP_PATH undefined since executable already in path
    goto :eof
) else if defined BLOOP_HOME (
    set "__BLOOP_HOME=%BLOOP_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable BLOOP_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\bloop*" 2^>NUL') do set "__BLOOP_HOME=!_PATH!\%%f"
    if defined __BLOOP_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Bloop installation directory !__BLOOP_HOME! 1>&2
    )
)
if not exist "%__BLOOP_HOME%\bloop.cmd" (
    echo %_ERROR_LABEL% bloop executable not found ^(%__BLOOP_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_BLOOP_PATH=;%__BLOOP_HOME%"
goto :eof

@rem output parameter(s): _VSCODE_PATH
:vscode
set _VSCODE_PATH=

set __VSCODE_HOME=
set __CODE_CMD=
for /f %%f in ('where code.exe 2^>NUL') do set "__CODE_CMD=%%f"
if defined __CODE_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of VSCode executable found in PATH 1>&2
    @rem keep _VSCODE_PATH undefined since executable already in path
    goto :eof
) else if defined VSCODE_HOME (
    set "__VSCODE_HOME=%VSCODE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable VSCODE_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\VSCode\" ( set "__VSCODE_HOME=!__PATH!\VSCode"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\VSCode-1*" 2^>NUL') do set "__VSCODE_HOME=!__PATH!\%%f"
        if not defined __VSCODE_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\VSCode-1*" 2^>NUL') do set "__VSCODE_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%__VSCODE_HOME%\code.exe" (
    echo %_ERROR_LABEL% VSCode executable not found ^(%__VSCODE_HOME%^) 1>&2
    if exist "%__VSCODE_HOME%\Code - Insiders.exe" (
        echo %_WARNING_LABEL% It looks like you've installed an Insider version of VSCode 1>&2
    )
    set _EXITCODE=1
    goto :eof
)
set "_VSCODE_PATH=;%__VSCODE_HOME%"
goto :eof

@rem output parameter(s): _GIT_HOME, _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    for %%i in ("%__GIT_CMD%") do set __GIT_BIN_DIR=%%~dpsi
    for %%f in ("!__GIT_BIN_DIR!..") do set "_GIT_HOME=%%f"
    rem Executable git.exe is present both in bin\ and \mingw64\bin\
    if not "!_GIT_HOME:mingw=!"=="!_GIT_HOME!" (
        for %%f in ("!_GIT_HOME!\..") do set "_GIT_HOME=%%f"
    )
    rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "_GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set "_GIT_HOME=!__PATH!\Git"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        )
    )
    if defined _GIT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Git installation directory "!_GIT_HOME!" 1>&2
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo %_ERROR_LABEL% Git executable not found ^(%_GIT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\mingw64\bin;%_GIT_HOME%\usr\bin"
goto :eof

:clean
for %%f in ("%~dp0") do set __ROOT_DIR=%%~sf
for /f %%i in ('dir /ad /b "%__ROOT_DIR%\" 2^>NUL') do (
    for /f %%j in ('dir /ad /b "%%i\target\scala-*" 2^>NUL') do (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% rmdir /s /q %__ROOT_DIR%%%i\target\%%j\classes 1^>NUL 2^>^&1 1>&2
        rmdir /s /q "%__ROOT_DIR%%%i\target\%%j\classes" 1>NUL 2>&1
    )
)
goto :eof

:print_env
set __VERBOSE=%1
set __GIT_HOME=%~2
set __VERSIONS_LINE1=
set __VERSIONS_LINE2=
set __VERSIONS_LINE3=
set __VERSIONS_LINE4=
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
where /q scalac.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,4,*" %%i in ('scalac.bat -version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% scalac %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% scalac.bat
)
where /q dotc.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,4,*" %%i in ('dotc.bat -version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% dotc %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% dotc.bat
)
where /q ant.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,4,*" %%i in ('ant.bat -version ^| findstr version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% ant %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% ant.bat
)
where /q gradle.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('gradle.bat -version ^| findstr Gradle') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% gradle %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% gradle.bat
)
where /q mill.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=*" %%i in ('mill.bat -i version 2^>NUL') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% mill %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% mill.bat
)
where /q mvn.cmd
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('mvn.cmd -version ^| findstr Apache') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% mvn %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% mvn.cmd
)
where /q sbt.bat
if %ERRORLEVEL%==0 (
    for /f "delims=: tokens=1,*" %%i in ('sbt.bat -V ^| findstr version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% sbt%%~j,"
    set __WHERE_ARGS=%__WHERE_ARGS% sbt.bat
)
where /q cfr.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('cfr.bat 2^>^&1 ^| findstr /b CFR') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% cfr %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% cfr.bat
)
where /q python.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('python.exe --version 2^>^&1') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% python %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% python.exe
)
where /q bloop.cmd
if %ERRORLEVEL%==0 (
    start /min "bloop_8212" bloop.cmd server
    timeout /t 2 /nobreak 1>NUL
    for /f "tokens=1,*" %%i in ('bloop.cmd about --version 2^>^&1 ^| findstr /b bloop') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% bloop %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% bloop.cmd
    taskkill.exe /fi "WindowTitle eq bloop_8212*" /t /f 1>NUL
)
where /q git.exe
if %ERRORLEVEL%==0 (
   for /f "tokens=1,2,*" %%i in ('git.exe --version') do set "__VERSIONS_LINE4=%__VERSIONS_LINE4% git %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% git.exe
)
where /q diff.exe
if %ERRORLEVEL%==0 (
   for /f "tokens=1-3,*" %%i in ('diff.exe --version ^| findstr diff') do set "__VERSIONS_LINE4=%__VERSIONS_LINE4% diff %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% diff.exe
)
where /q "%__GIT_HOME%\bin":bash.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,4,*" %%i in ('"%__GIT_HOME%\bin\bash.exe" --version ^| findstr bash') do set "__VERSIONS_LINE4=%__VERSIONS_LINE4% bash %%l"
    set __WHERE_ARGS=%__WHERE_ARGS% "%__GIT_HOME%\bin:bash.exe"
)
echo Tool versions:
echo   %__VERSIONS_LINE1%
echo   %__VERSIONS_LINE2%
echo   %__VERSIONS_LINE3%
echo   %__VERSIONS_LINE4%
if %__VERBOSE%==1 (
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do echo    %%p 1>&2
    echo Environment variables: 1>&2
    if defined ANT_HOME echo    ANT_HOME=%ANT_HOME% 1>&2
    if defined DOTTY_HOME echo    DOTTY_HOME=%DOTTY_HOME% 1>&2
    if defined JAVA_HOME echo    JAVA_HOME=%JAVA_HOME% 1>&2
    if defined JAVA11_HOME echo    JAVA11_HOME=%JAVA11_HOME% 1>&2
    if defined SCALA_HOME echo    SCALA_HOME=%SCALA_HOME% 1>&2
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if %_EXITCODE%==0 (
        if not defined ANT_HOME set "ANT_HOME=%_ANT_HOME%"
        if not defined DOTTY_HOME set "DOTTY_HOME=%_DOTTY_HOME%"
        if not defined JAVA_HOME set "JAVA_HOME=%_JDK_HOME%"
        if not defined JAVA11_HOME set "JAVA11_HOME=%_JDK11_HOME%"
        if not defined SCALA_HOME set "SCALA_HOME=%_SCALA_HOME%"
        set "PATH=%_JDK_PATH%%_PYTHON_PATH%%PATH%%_SCALA_PATH%%_DOTTY_PATH%%_ANT_PATH%%_GRADLE_PATH%%_JMC_PATH%%_MILL_PATH%%_MVN_PATH%%_SBT_PATH%%_CFR_PATH%%_BLOOP_PATH%%_VSCODE_PATH%%_GIT_PATH%;%~dp0bin"
        call :print_env %_VERBOSE% "%_GIT_HOME%"
        if %_BASH%==1 (
            @rem see https://conemu.github.io/en/GitForWindows.html
            if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_HOME%\usr\bin\bash.exe --login 1>&2
            cmd.exe /c "%_GIT_HOME%\usr\bin\bash.exe --login"
        )
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)

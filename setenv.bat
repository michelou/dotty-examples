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

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)

set _ANT_PATH=
set _BAZEL_PATH=
set _BLOOP_PATH=
set _GIT_PATH=
set _GRADLE_PATH=
set _JMC_PATH=
set _MAKE_PATH=
set _MAVEN_PATH=
set _MILL_PATH=
set _SBT_PATH=
set _VSCODE_PATH=

@rem %1=vendor, %2=version
@rem eg. "" (Oracle), bellsoft, corretto, bellsoft, openj9, redhat, sapmachine, zulu
call :jdk "" 11
if not %_EXITCODE%==0 goto end

call :scala2
if not %_EXITCODE%==0 goto end

call :scalafmt
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Scalafmt installation not found 1>&2
    set _EXITCODE=0
)
call :scala3
if not %_EXITCODE%==0 goto end

call :sbt
if not %_EXITCODE%==0 goto end

call :ant
if not %_EXITCODE%==0 goto end

call :bazel
if not %_EXITCODE%==0 goto end

@rem bloop depends on python
call :python 3
if not %_EXITCODE%==0 goto end

call :bloop
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Bloop installation not found 1>&2
    set _EXITCODE=0
)
call :cfr
if not %_EXITCODE%==0 goto end

call :gradle
if not %_EXITCODE%==0 goto end

call :jacoco
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% JaCoCo installation not found 1>&2
    set _EXITCODE=0
)
call :javafx
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% JavaFX installation not found 1>&2
    set _EXITCODE=0
)
call :jmc
if not %_EXITCODE%==0 (
    @rem optional
    echo %_WARNING_LABEL% Java Mission Control installation not found 1>&2
    set _EXITCODE=0
)
call :make
if not %_EXITCODE%==0 goto end

call :maven
if not %_EXITCODE%==0 goto end

call :mill
if not %_EXITCODE%==0 goto end

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
set _DRIVE_NAME=W
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _RESET=[0m
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m
goto :eof

@rem input parameter: %*
@rem output parameter: _HELP, _VERBOSE
:args
set _BASH=0
set _HELP=0
set _VERBOSE=0

:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-bash" ( set _BASH=1
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto args_loop
:args_done
call :subst %_DRIVE_NAME% "%_ROOT_DIR%"
if not %_EXITCODE%==0 goto :eof
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options  : _HELP=%_HELP% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Variables: _DRIVE_NAME=%_DRIVE_NAME% 1>&2
)
goto :eof

@rem input parameter(s): %1: drive letter, %2: path to be substituted
:subst
set __DRIVE_NAME=%~1
set "__GIVEN_PATH=%~2"

if not "%__DRIVE_NAME:~-1%"==":" set __DRIVE_NAME=%__DRIVE_NAME%:
if /i "%__DRIVE_NAME%"=="%__GIVEN_PATH:~0,2%" goto :eof

if "%__GIVEN_PATH:~-1%"=="\" set "__GIVEN_PATH=%__GIVEN_PATH:~0,-1%"
if not exist "%__GIVEN_PATH%" (
    echo %_ERROR_LABEL% Provided path does not exist ^(%__GIVEN_PATH%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "tokens=1,2,*" %%f in ('subst ^| findstr /b "%__DRIVE_NAME%" 2^>NUL') do (
    set "__SUBST_PATH=%%h"
    if "!__SUBST_PATH!"=="!__GIVEN_PATH!" (
        set __MESSAGE=
        for /f %%i in ('subst ^| findstr /b "%__DRIVE_NAME%\"') do "set __MESSAGE=%%i"
        if defined __MESSAGE (
            if %_DEBUG%==1 ( echo %_DEBUG_LABEL% !__MESSAGE! 1>&2
            ) else if %_VERBOSE%==1 ( echo !__MESSAGE! 1>&2
            )
        )
        goto :eof
    )
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% subst "%__DRIVE_NAME%" "%__GIVEN_PATH%" 1>&2
) else if %_VERBOSE%==1 ( echo Assign path %__GIVEN_PATH% to drive %__DRIVE_NAME% 1>&2
)
subst "%__DRIVE_NAME%" "%__GIVEN_PATH%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to assigned drive %__DRIVE_NAME% to path 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%%_UNDERSCORE%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __BEG_N=%_NORMAL_FG_YELLOW%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __BEG_N=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-bash%__END%       start Git bash shell instead of Windows command prompt
echo     %__BEG_O%-debug%__END%      show commands executed by this script
echo     %__BEG_O%-verbose%__END%    display environment settings
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        display this help message
goto :eof

@rem output parameter(s): _PYTHON_HOME, _PYTHON_PATH
:python
set _PYTHON_HOME=
set _PYTHON_PATH=

set _PYTHON_CMD=
for /f %%f in ('where python.exe 2^>NUL') do set "_PYTHON_CMD=%%f"
if defined _PYTHON_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Python executable found in PATH 1>&2
    for %%i in ("%_PYTHON_CMD%") do set "_PYTHON_HOME=%%~dpi"
    goto :eof
) else if defined PYTHON_HOME (
    set "_PYTHON_HOME=%PYTHON_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable PYTHON_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Python\" ( set "_PYTHON_HOME=!__PATH!\Python"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\Python-3*" 2^>NUL') do set "_PYTHON_HOME=!__PATH!\%%f"
        if not defined _PYTHON_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\Python-3*" 2^>NUL') do set "_PYTHON_HOME=!__PATH!\%%f"
        )
    )
    if defined _PYTHON_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Python installation directory "!_PYTHON_HOME!" 1>&2
    )
)
if not exist "%_PYTHON_HOME%\python.exe" (
    echo %_ERROR_LABEL% Python executable not found ^(%_PYTHON_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_PYTHON_PATH=;%_PYTHON_HOME%;%_PYTHON_HOME%\Scripts"
goto :eof

@rem output parameter(s): _BLOOP_PATH
:bloop
set _BLOOP_PATH=

set __BLOOP_HOME=
set __BLOOP_CMD=
for /f %%f in ('where bloop.cmd 2^>NUL') do set "__BLOOP_CMD=%%f"
if defined __BLOOP_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of bloop executable found in PATH 1>&2
    @rem keep _BLOOP_PATH undefined since executable already in path
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

@rem input parameter: %1=vendor %1^=required version
@rem output parameter(s): _JDK_HOME
:jdk
set _JDK_HOME=

set __VENDOR=%~1
set __VERSION=%~2
if not defined __VENDOR ( set __JDK_NAME=jdk-%__VERSION%
) else ( set __JDK_NAME=jdk-%__VENDOR%-%__VERSION%
)
set __JAVAC_CMD=
for /f %%f in ('where javac.exe 2^>NUL') do set "__JAVAC_CMD=%%f"
if defined __JAVAC_CMD (
    call :jdk_version "%__JAVAC_CMD%"
    if !_JDK_VERSION!==%__VERSION% (
        for %%i in ("%__JAVAC_CMD%") do set "__BIN_DIR=%%~dpi"
        for %%f in ("%__BIN_DIR%") do set "_JDK_HOME=%%~dpf"
    ) else (
        echo %_ERROR_LABEL% Required JDK installation not found ^(%__JDK_NAME%^) 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
if defined JDK_HOME (
    set "_JDK_HOME=%JDK_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JDK_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!_PATH!\%__JDK_NAME%*" 2^>NUL') do set "_JDK_HOME=!_PATH!\%%f"
    if not defined _JDK_HOME (
        set "_PATH=%ProgramFiles%\Java"
        for /f %%f in ('dir /ad /b "!_PATH!\%__JDK_NAME%*" 2^>NUL') do set "_JDK_HOME=!_PATH!\%%f"
    )
    if defined _JDK_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Java SDK installation directory !_JDK_HOME! 1>&2
    )
)
if not exist "%_JDK_HOME%\bin\javac.exe" (
    echo %_ERROR_LABEL% Executable javac.exe not found ^(%_JDK_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter(s): %1=javac file path
@rem output parameter(s): _JDK_VERSION
:jdk_version
set "__JAVAC_CMD=%~1"
if not exist "%__JAVAC_CMD%" (
    echo %_ERROR_LABEL% Command javac.exe not found ^("%__JAVAC_CMD%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set __JAVAC_VERSION=
for /f "usebackq tokens=1,*" %%i in (`"%__JAVAC_CMD%" -version 2^>^&1`) do set __JAVAC_VERSION=%%j
if "!__JAVAC_VERSION:~0,2!"=="14" ( set _JDK_VERSION=14
) else if "!__JAVAC_VERSION:~0,2!"=="11" ( set _JDK_VERSION=11
) else if "!__JAVAC_VERSION:~0,3!"=="1.8" ( set _JDK_VERSION=8
) else if "!__JAVAC_VERSION:~0,3!"=="1.7" ( set _JDK_VERSION=7
) else (
    set _JDK_VERSION=
    echo %_ERROR_LABEL% Unsupported JDK version %__JAVAC_VERSION% 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: SCALA_HOME
:scala2
set _SCALA_HOME=

set __SCALAC_CMD=
for /f %%f in ('where scalac.bat 2^>NUL') do (
    set __VERSION=
    for /f "tokens=1,2,3,4,*" %%i in ('scalac.bat -version') do set "__VERSION=%%l"
    if defined __VERSION if "!__VERSION:~0,1!"=="2" set "__SCALAC_CMD=%%f"
)
if defined __SCALAC_CMD (
    for %%i in ("%__SCALAC_CMD%") do set "__SCALA_BIN_DIR=%%~dpi"
    for %%f in ("!__SCALA_BIN_DIR!..") do set "_SCALA_HOME=%%f"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Scala 2 executable found in PATH 1>&2
    goto :eof
) else if defined SCALA_HOME (
    set "_SCALA_HOME=%SCALA_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SCALA_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\scala-2*" 2^>NUL') do set _SCALA_HOME=!_PATH!\%%f
    if defined _SCALA_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Scala 2 installation directory !_SCALA_HOME!
    )
)
if not exist "%_SCALA_HOME%\bin\scalac.bat" (
    echo %_ERROR_LABEL% Scala executable not found ^(%_SCALA_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter(s): _SCALAFMT_HOME
:scalafmt
set _SCALAFMT_HOME=

set __SCALAFMT_CMD=
for /f %%f in ('where scalafmt.bat 2^>NUL') do set "__SCALAFMT_CMD=%%f"
if defined __SCALAFMT_CMD (
    for %%i in ("%__SCALAFMT_CMD%") do set "__SCALAFMT_BIN_DIR=%%~dpi"
    for %%f in ("!__SCALAFMT_BIN_DIR!\.") do set "_SCALAFMT_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Scalafmt executable found in PATH 1>&2
    goto :eof
) else if defined SCALAFMT_HOME (
    set "_SCALAFMT_HOME=%SCALAFMT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SCALAFMT_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\scalafmt*" 2^>NUL') do set "_SCALAFMT_HOME=!_PATH!\%%f"
    if defined _SCALAFMT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Scalafmt installation directory !_SCALAFMT_HOME! 1>&2
    )
)
if not exist "%_SCALAFMT_HOME%\bin\scalafmt.bat" (
    set _SCALAFMT_HOME=
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter(s): _SCALA3_HOME
:scala3
set _SCALA3_HOME=

set __DOTC_CMD=
for /f %%f in ('where scalac.bat 2^>NUL') do (
    set __VERSION=
    for /f "tokens=1,2,3,4,*" %%i in ('scalac.bat -version') do set "__VERSION=%%l"
    if defined __VERSION if "!__VERSION:~0,1!"=="3" set "__DOTC_CMD=%%f"
)
if defined __DOTC_CMD (
    for %%i in ("%__DOTC_CMD%") do set "__SCALA3_BIN_DIR=%%~dpi"
    for %%f in ("!__SCALA3_BIN_DIR!..") do set "_SCALA3_HOME=%%f"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Scala 3 executable found in PATH 1>&2
    goto :eof
) else if defined SCALA3_HOME (
    set "_SCALA3_HOME=%SCALA3_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SCALA3_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\scala-3*" 2^>NUL') do set "_SCALA3_HOME=!_PATH!\%%f"
    if defined _SCALA3_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Scala 3 installation directory !_SCALA3_HOME! 1>&2
    )
)
if not exist "%_SCALA3_HOME%\bin\scalac.bat" (
    echo %_ERROR_LABEL% Scala 3 executable not found ^(%_SCALA3_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter(s): _SBT_HOME, _SBT_PATH
:sbt
set _SBT_HOME=
set _SBT_PATH=

set __SBT_CMD=
for /f %%f in ('where sbt.bat 2^>NUL') do set "__SBT_CMD=%%f"
if defined __SBT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of sbt executable found in PATH 1>&2
    @rem keep _SBT_PATH undefined since executable already in path
    goto :eof
) else if defined SBT_HOME (
    set "_SBT_HOME=%SBT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SBT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\sbt\" ( set "_SBT_HOME=!__PATH!\sbt"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\sbt-1*" 2^>NUL') do set "_SBT_HOME=!__PATH!\%%f"
        if not defined _SBT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\sbt-1*" 2^>NUL') do set "_SBT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_SBT_HOME%\bin\sbt.bat" (
    echo %_ERROR_LABEL% sbt executable not found ^(%_SBT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SBT_PATH=;%_SBT_HOME%\bin"
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
    for %%f in ("!__ANT_BIN_DIR!\.") do set "_ANT_HOME=%%~dpf"
    @rem keep _ANT_PATH undefined since executable already in path
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

@rem output parameter(s): _BAZEL_PATH
:bazel
set _BAZEL_PATH=

set __BAZEL_HOME=
set __BAZEL_CMD=
for /f %%f in ('where bazel.exe 2^>NUL') do set "__BAZEL_CMD=%%f"
if defined __BAZEL_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Bazel executable found in PATH 1>&2
    for /f "delims=" %%i in ("%__BAZEL_CMD%") do set "__BAZEL_HOME=%%~dpi"
    @rem keep _BAZEL_PATH undefined since executable already in path
    goto :eof
) else if defined BAZEL_HOME (
    set "__BAZEL_HOME=%BAZEL_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable BAZEL_HOME 1>&2
) else (
    set "__PATH=%ProgramFiles%"
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\bazel-*" 2^>NUL') do set "__BAZEL_HOME=!__PATH!\%%f"
    if not defined __BAZEL_HOME (
        set __PATH=C:\opt
        for /f %%f in ('dir /ad /b "!__PATH!\bazel-*" 2^>NUL') do set "__BAZEL_HOME=!__PATH!\%%f"
    )
)
if not exist "%__BAZEL_HOME%\bazel.exe" (
    echo %_ERROR_LABEL% Bazel executable not found ^("%__BAZEL_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_BAZEL_PATH=;%__BAZEL_HOME%"
goto :eof

@rem http://www.benf.org/other/cfr/
@rem output parameter: _CFR_HOME
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
goto :eof

:gradle
where /q gradle.bat
if %ERRORLEVEL%==0 goto :eof

if defined GRADLE_HOME (
    set "_GRADLE_HOME=%GRADLE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GRADLE_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\gradle\" ( set "_GRADLE_HOME=!__PATH!\gradle"
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


@rem output parameter(s): _JACOCO_HOME
:jacoco
set _JACOCO_HOME=

if defined JACOCO_HOME (
    set "_JACOCO_HOME=%JACOCO_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JACOCO_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\jacoco\" ( set "_JACOCO_HOME=!__PATH!\jmc"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\jacoco-*" 2^>NUL') do set "_JACOCO_HOME=!__PATH!\%%f"
        if not defined _JACOCO_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\jacoco-*" 2^>NUL') do set "_JACOCO_HOME=!__PATH!\%%f"
        )
    )
    if defined _JACOCO_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default JaCoCo installation directory !_JACOCO_HOME! 1>&2
    )
)
if not exist "%_JACOCO_HOME%\lib\jacococli.jar" (
    echo %_ERROR_LABEL% JaCoCo library not found ^(%_JACOCO_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _JAVAFX_HOME
:javafx
if defined JAVAFX_HOME (
    set "_JAVAFX_HOME=%JAVAFX_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JAVAFX_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\javafx\" ( set "_JAVAFX_HOME=!__PATH!\javafx"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\javafx-*" 2^>NUL') do set "_JAVAFX_HOME=!__PATH!\%%f"
        if not defined _JAVAFX_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\javafx-*" 2^>NUL') do set "_JAVAFX_HOME=!__PATH!\%%f"
        )
    )
    if defined _JAVAFX_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default JavaFX installation directory "!_JAVAFX_HOME!" 1>&2
    )
)
if not exist "%_JAVAFX_HOME%\lib\javafx.graphics.jar" (
    echo %_ERROR_LABEL% JavaFX Graphics library not found ^(%_JAVAFX_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
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
    @rem keep _JMC_PATH undefined since executable already in path
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
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default JMC installation directory "!_JMC_HOME!" 1>&2
    )
)
if not exist "%_JMC_HOME%\bin\jmc.exe" (
    echo %_ERROR_LABEL% JMC executable not found ^(%_JMC_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_JMC_PATH=;%_JMC_HOME%\bin"
goto :eof

@rem output parameter(s): _MAKE_PATH
:make
set _MAKE_PATH=

set __MAKE_HOME=
set __MAKE_CMD=
for /f %%f in ('where make.exe 2^>NUL') do set "__MAKE_CMD=%%f"
if defined __MAKE_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Make executable found in PATH 1>&2
    rem keep _MAKE_PATH undefined since executable already in path
    goto :eof
) else if defined MAKE_HOME (
    set "__MAKE_HOME=%MAKE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MAKE_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\make-3*" 2^>NUL') do set "__MAKE_HOME=!_PATH!\%%f"
    if defined __MAKE_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Make installation directory !__MAKE_HOME! 1>&2
    )
)
if not exist "%__MAKE_HOME%\bin\make.exe" (
    echo %_ERROR_LABEL% Make executable not found ^(%__MAKE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MAKE_PATH=;%__MAKE_HOME%\bin"
goto :eof

@rem output parameter(s): _MAVEN_PATH
:maven
where /q mvn.cmd
if %ERRORLEVEL%==0 goto :eof

if defined MAVEN_HOME (
    set "_MAVEN_HOME=%MAVEN_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MAVEN_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\apache-maven-*" 2^>NUL') do set "_MAVEN_HOME=!_PATH!\%%f"
    if defined _MAVEN_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Maven installation directory !_MAVEN_HOME! 1>&2
    )
)
if not exist "%_MAVEN_HOME%\bin\mvn.cmd" (
    echo %_ERROR_LABEL% Maven executable not found ^(%_MAVEN_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MAVEN_PATH=;%_MAVEN_HOME%\bin"
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

@rem output parameter(s): _PYTHON_HOME
set _PYTHON_HOME=

set __PYTHON_CMD=
for /f %%f in ('where python.exe 2^>NUL ^| findstr /v WindowsApps') do set "__PYTHON_CMD=%%f"
if defined __PYTHON_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Python executable found in PATH 1>&2
    goto :eof
) else if defined PYTHON_HOME (
    set "_PYTHON_HOME=%PYTHON_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable PYTHON_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\Python*" 2^>NUL') do set "_PYTHON_HOME=!_PATH!\%%f"
    if defined _PYTHON_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Python installation directory !_PYTHON_HOME! 1>&2
    )
)
if not exist "%_PYTHON_HOME%\python.exe" (
    echo %_ERROR_LABEL% Python executable not found ^(%_PYTHON_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
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
    for %%i in ("%__GIT_CMD%") do set "__GIT_BIN_DIR=%%~dpi"
    for %%f in ("!__GIT_BIN_DIR!..") do set "_GIT_HOME=%%f"
    @rem Executable git.exe is present both in bin\ and \mingw64\bin\
    if not "!_GIT_HOME:mingw=!"=="!_GIT_HOME!" (
        for %%f in ("!_GIT_HOME!\..") do set "_GIT_HOME=%%f"
    )
    @rem keep _GIT_PATH undefined since executable already in path
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
where /q "%JAVA_HOME%\bin:javac.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%JAVA_HOME%\bin\javac.exe" -version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% javac %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%JAVA_HOME%\bin:javac.exe"
)
where /q "%JAVA_HOME%\bin:java.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('"%JAVA_HOME%\bin\java.exe" -version 2^>^&1 ^| findstr version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% java %%~k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%JAVA_HOME%\bin:java.exe"
)
where /q "%SCALA_HOME%\bin:scalac.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,4,*" %%i in ('"%SCALA_HOME%\bin\scalac.bat" -version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% scalac %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%SCALA_HOME%\bin:scalac.bat"
)
where /q "%SCALA3_HOME%\bin:scalac.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,4,*" %%i in ('"%SCALA3_HOME%\bin\scalac.bat" -version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% scalac %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%SCALA3_HOME%\bin:scalac.bat"
)
where /q "%ANT_HOME%\bin:ant.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,4,*" %%i in ('"%ANT_HOME%\bin\ant.bat" -version ^| findstr version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% ant %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%ANT_HOME%\bin:ant.bat"
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
where /q "%SBT_HOME%\bin:sbt.bat"
if %ERRORLEVEL%==0 (
    @rem retrieve version of sbt installation WITHOUT starting sbt (costly)
    pushd "%TEMP%"
    call "%JAVA_HOME%\bin\jar.exe" xf "%SBT_HOME%\bin\sbt-launch.jar" sbt/sbt.boot.properties
    popd
    set "__PS1_SCRIPT=$s=select-string -path '%TEMP%\sbt\sbt.boot.properties' -pattern 'sbt.version';if($s -match '.*\[([0-9.]+)\].*'){$matches[1]}else{'unknown'}"
    for /f "usebackq" %%i in (`powershell -c "!__PS1_SCRIPT!"`) do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% sbt %%i,"
    del "%TEMP%\sbt\sbt.boot.properties" 1>NUL 2>&1
    set __WHERE_ARGS=%__WHERE_ARGS% "%SBT_HOME%\bin:sbt.bat"
)
where /q bazel.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('bazel.exe --version') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% bazel %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% bazel.exe
)
@rem where /q bloop.cmd
@rem if %ERRORLEVEL%==0 (
@rem     start /min "bloop_8212" bloop.cmd server
@rem     timeout /t 2 /nobreak 1>NUL
@rem     for /f "tokens=1,*" %%i in ('bloop.cmd about --version 2^>^&1 ^| findstr /b bloop') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% bloop %%j,"
@rem     set __WHERE_ARGS=%__WHERE_ARGS% bloop.cmd
@rem     taskkill.exe /fi "WindowTitle eq bloop_8212*" /t /f 1>NUL
@rem )
where /q "%CFR_HOME%\bin:cfr.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('"%CFR_HOME%\bin\cfr.bat" 2^>^&1 ^| findstr /b CFR') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% cfr %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%CFR_HOME%\bin:cfr.bat"
)
where /q make.exe
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('make.exe --version 2^>^&1 ^| findstr Make') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% make %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% make.exe
)
where /q "%PYTHON_HOME%:python.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('"%PYTHON_HOME%\python.exe" --version 2^>^&1') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% python %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%PYTHON_HOME%:python.exe"
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
where /q "%__GIT_HOME%\bin:bash.exe"
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
    if defined GIT_HOME echo    GIT_HOME=%GIT_HOME% 1>&2
    if defined JAVA_HOME echo    JAVA_HOME=%JAVA_HOME% 1>&2
    if defined JAVACOCO_HOME echo    JAVACOCO_HOME=%JAVACOCO_HOME% 1>&2
    if defined JAVA11_HOME echo    JAVA11_HOME=%JAVA11_HOME% 1>&2
    if defined JAVAFX_HOME echo    JAVAFX_HOME=%JAVAFX_HOME% 1>&2
    if defined PYTHON_HOME echo    PYTHON_HOME=%PYTHON_HOME% 1>&2
    if defined SBT_HOME echo    SBT_HOME=%SBT_HOME% 1>&2
    if defined SCALA_HOME echo    SCALA_HOME=%SCALA_HOME% 1>&2
    if defined SCALA3_HOME echo    SCALA3_HOME=%SCALA3_HOME% 1>&2
    if defined SCALAFMT_HOME echo    SCALAFMT_HOME=%SCALAFMT_HOME% 1>&2
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if %_EXITCODE%==0 (
        if not defined ANT_HOME set "ANT_HOME=%_ANT_HOME%"
        if not defined CFR_HOME set "CFR_HOME=%_CFR_HOME%"
        if not defined GIT_HOME set "GIT_HOME=%_GIT_HOME%"
        if not defined JACOCO_HOME set "JACOCO_HOME=%_JACOCO_HOME%"
        if not defined JAVA_HOME set "JAVA_HOME=%_JDK_HOME%"
        if not defined JAVA11_HOME set "JAVA11_HOME=%_JDK11_HOME%"
        if not defined JAVAFX_HOME set "JAVAFX_HOME=%_JAVAFX_HOME%"
        if not defined PYTHON_HOME set "PYTHON_HOME=%_PYTHON_HOME%"
        if not defined SBT_HOME set "SBT_HOME=%_SBT_HOME%"
        if not defined SCALA_HOME set "SCALA_HOME=%_SCALA_HOME%"
        if not defined SCALA3_HOME set "SCALA3_HOME=%_SCALA3_HOME%"
        if not defined SCALAFMT_HOME set "SCALAFMT_HOME=%_SCALAFMT_HOME%"
        set "PATH=%PATH%%_ANT_PATH%%_BAZEL_PATH%%_GRADLE_PATH%%_JMC_PATH%%_MAKE_PATH%%_MAVEN_PATH%%_MILL_PATH%%_SBT_PATH%%_BLOOP_PATH%%_VSCODE_PATH%%_GIT_PATH%;%~dp0bin"
        call :print_env %_VERBOSE% "%_GIT_HOME%"
        if %_BASH%==1 (
            @rem see https://conemu.github.io/en/GitForWindows.html
            if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_HOME%\usr\bin\bash.exe --login 1>&2
            cmd.exe /c "%_GIT_HOME%\usr\bin\bash.exe --login"
        ) else if not "%CD:~0,2%"=="%_DRIVE_NAME%:" (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% cd /d %_DRIVE_NAME%: 1>&2
            cd /d %_DRIVE_NAME%:
        )
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)

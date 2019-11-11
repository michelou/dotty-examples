@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end
if defined _HELP call :help & exit /b %_EXITCODE%

rem ##########################################################################
rem ## Main

set _JDK_PATH=
set _SCALA_PATH=
set _DOTTY_PATH=
set _ANT_PATH=
set _GRADLE_PATH=
set _MILL_PATH=
set _MVN_PATH=
set _SBT_PATH=
set _CFR_PATH=
set _PYTHON_PATH=
set _BLOOP_PATH=
set _GIT_PATH=

call :javac
if not %_EXITCODE%==0 goto end

call :scalac
if not %_EXITCODE%==0 goto end

call :dotc
if not %_EXITCODE%==0 goto end

call :ant
rem optional
rem if not %_EXITCODE%==0 goto end
set _EXITCODE=0

call :gradle
rem optional
rem if not %_EXITCODE%==0 goto end
set _EXITCODE=0

call :mill
rem optional
rem if not %_EXITCODE%==0 goto end
set _EXITCODE=0

call :mvn
rem optional
rem if not %_EXITCODE%==0 goto end
set _EXITCODE=0

call :sbt
rem optional
rem if not %_EXITCODE%==0 goto end
set _EXITCODE=0

call :cfr
rem optional
rem if not %_EXITCODE%==0 goto end
set _EXITCODE=0

call :bloop
rem optional
rem if not %_EXITCODE%==0 goto end
set _EXITCODE=0

call :git
if not %_EXITCODE%==0 goto end

if "%~1"=="clean" call :clean

goto end

rem ##########################################################################
rem ## Subroutines

rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

for /f "tokens=1,* delims=:" %%i in ('chcp') do set _CODE_PAGE_DEFAULT=%%j
rem make sure we use UTF-8 encoding for console outputs
chcp 65001 1>NUL
goto :eof

rem input parameter: %*
rem output parameter: _HELP, _VERBOSE
:args
set _HELP=
set _VERBOSE=0

:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    rem option
	if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    rem subcommand
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
echo     -debug      show commands executed by this script
echo     -verbose    display environment settings
echo.
echo   Subcommands:
echo     help        display this help message
goto :eof

:javac
where /q javac.exe
if %ERRORLEVEL%==0 goto :eof

if defined JDK_HOME (
    set _JDK_HOME=%JDK_HOME%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JDK_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!_PATH!\jdk-1.8*" 2^>NUL') do set _JDK_HOME=!_PATH!\%%f
    if not defined _JDK_HOME (
        set _PATH=C:\Progra~1\Java
        for /f %%f in ('dir /ad /b "!_PATH!\jdk1.8*" 2^>NUL') do set _JDK_HOME=!_PATH!\%%f
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
rem variable _JDK_PATH is prepended to PATH, so path separator must appear as last character
set "_JDK_PATH=%_JDK_HOME%\bin;"
goto :eof

:scalac
where /q scalac.bat
if %ERRORLEVEL%==0 goto :eof

if defined SCALA_HOME (
    set _SCALA_HOME=%SCALA_HOME%
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

:dotc
where /q dotc.bat
if %ERRORLEVEL%==0 goto :eof

if defined DOTTY_HOME (
    set _DOTTY_HOME=%DOTTY_HOME%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable DOTTY_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b /od "!_PATH!\dotty*" 2^>NUL') do set "_DOTTY_HOME=!_PATH!\%%f"
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

:ant
where /q ant.cmd
if %ERRORLEVEL%==0 goto :eof

if defined ANT_HOME (
    set _ANT_HOME=%ANT_HOME%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable ANT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\apache-ant\" ( set _ANT_HOME=!__PATH!\apache-ant
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\apache-ant-*" 2^>NUL') do set "_ANT_HOME=!__PATH!\%%f"
        if not defined _ANT_HOME (
            set __PATH=C:\Progra~1
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
            set __PATH=C:\Progra~1
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

:mill
where /q mill.bat
if %ERRORLEVEL%==0 goto :eof

if defined MILL_HOME (
    set _MILL_HOME=%MILL_HOME%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MILL_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\mill\" ( set _MILL_HOME=!__PATH!\mill
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\mill-*" 2^>NUL') do set "_MILL_HOME=!__PATH!\%%f"
        if not defined _MILL_HOME (
            set __PATH=C:\Progra~1
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
    set _MVN_HOME=%MAVEN_HOME%
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

:sbt
where /q sbt.bat
if %ERRORLEVEL%==0 goto :eof

if defined SBT_HOME (
    set _SBT_HOME=%SBT_HOME%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SBT_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\sbt-1*" 2^>NUL') do set "_SBT_HOME=!_PATH!\%%f"
    if defined _SBT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default sbt installation directory !_SBT_HOME! 1>&2
    )
)
if not exist "%_SBT_HOME%\bin\sbt.bat" (
    echo %_ERROR_LABEL% sbt executable not found ^(%_SBT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SBT_PATH=;%_SBT_HOME%\bin"
goto :eof

rem http://www.benf.org/other/cfr/
:cfr
where /q cfr.bat
if %ERRORLEVEL%==0 goto :eof

if defined CFR_HOME (
    set _CFR_HOME=%CFR_HOME%
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

:python
where /q python.exe
if %ERRORLEVEL%==0 goto :eof

if defined PYTHON_HOME (
    set _PYTHON_HOME=%PYTHON_HOME%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable PYTHON_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\Python*" 2^>NUL') do set "_PYTHON_HOME=!_PATH!\%%f"
    if defined _PYTHON_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Python installation directory !_PYTHON_HOME! 1>&2
    )
)
if not exist "%_PYTHON_HOME%\python.exe" (
    echo %_ERROR_LABEL% python executable not found ^(%_PYTHON_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_PYTHON_PATH=;%_PYTHON_HOME%"
goto :eof

:bloop
rem bloop depends on python
call :python
if not %_EXITCODE%==0 goto :eof

where /q bloop.cmd
if %ERRORLEVEL%==0 goto :eof

if defined BLOOP_HOME (
    set _BLOOP_HOME=%BLOOP_HOME%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable BLOOP_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\bloop*" 2^>NUL') do set "_BLOOP_HOME=!_PATH!\%%f"
    if defined _BLOOP_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Bloop installation directory !_BLOOP_HOME! 1>&2
    )
)
if not exist "%_BLOOP_HOME%\bloop.cmd" (
    echo %_ERROR_LABEL% bloop executable not found ^(%_BLOOP_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_BLOOP_PATH=;%_BLOOP_HOME%"
goto :eof

:git
where /q git.exe
if %ERRORLEVEL%==0 goto :eof

if defined GIT_HOME (
    set _GIT_HOME=%GIT_HOME%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set _GIT_HOME=!__PATH!\Git
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set __PATH=C:\Progra~1
            for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        )
    )
    if defined _GIT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Git installation directory !_GIT_HOME! 1>&2
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo %_ERROR_LABEL% Git executable not found ^(%_GIT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\usr\bin"
goto :eof

:clean
for %%f in ("%~dp0") do set __ROOT_DIR=%%~sf
for /f %%i in ('dir /ad /b "%__ROOT_DIR%\" 2^>NUL') do (
    for /f %%j in ('dir /ad /b "%%i\target\scala-*" 2^>NUL') do (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% rmdir /s /q %__ROOT_DIR%%%i\target\%%j\classes 1^>NUL 2^>^&1 1>&2
        rmdir /s /q %__ROOT_DIR%%%i\target\%%j\classes 1>NUL 2>&1
    )
)
goto :eof

rem output parameter: _SBT_VERSION
rem Note: SBT requires special handling to know its version (no comment)
:sbt_version
set _SBT_VERSION=
for /f %%i in ('where sbt.bat') do for %%f in ("%%~dpi..") do set __SBT_LAUNCHER=%%~sf\bin\sbt-launch.jar
for /f "tokens=1,*" %%i in ('java.exe -jar "%__SBT_LAUNCHER%" sbtVersion ^| findstr [0-9].[0-9]') do set _SBT_VERSION=%%j
for /f "tokens=1,*" %%i in ('java.exe -jar "%__SBT_LAUNCHER%" scalaVersion ^| findstr [0-9].[0-9]') do set _SBT_VERSION=%_SBT_VERSION%/%%j
goto :eof

:print_env
set __VERBOSE=%1
set __VERSIONS_LINE1=
set __VERSIONS_LINE2=
set __VERSIONS_LINE3=
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
    for /f "tokens=1,2,3,4,*" %%i in ('dotc.bat -version 2^>^&1') do set __VERSIONS_LINE1=%__VERSIONS_LINE1% dotc %%l,
    set __WHERE_ARGS=%__WHERE_ARGS% dotc.bat
)
where /q ant.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,4,*" %%i in ('ant.bat -version ^| findstr version') do set __VERSIONS_LINE2=%__VERSIONS_LINE2% ant %%l,
    set __WHERE_ARGS=%__WHERE_ARGS% ant.bat
)
where /q gradle.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('gradle.bat -version ^| findstr Gradle') do set __VERSIONS_LINE2=%__VERSIONS_LINE2% gradle %%j,
    set __WHERE_ARGS=%__WHERE_ARGS% gradle.bat
)
where /q mill.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=*" %%i in ('mill.bat -i version 2^>NUL') do set __VERSIONS_LINE2=%__VERSIONS_LINE2% mill %%i,
    set __WHERE_ARGS=%__WHERE_ARGS% mill.bat
)
where /q mvn.cmd
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('mvn.cmd -version ^| findstr Apache') do set __VERSIONS_LINE2=%__VERSIONS_LINE2% mvn %%k,
    set __WHERE_ARGS=%__WHERE_ARGS% mvn.cmd
)
call :sbt_version
if defined _SBT_VERSION (
    set __VERSIONS_LINE2=%__VERSIONS_LINE2% sbt %_SBT_VERSION%,
    set __WHERE_ARGS=%__WHERE_ARGS% sbt.bat
)
where /q cfr.bat
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('cfr.bat 2^>^&1 ^| findstr /b CFR') do set __VERSIONS_LINE3=%__VERSIONS_LINE3% cfr %%j,
    set __WHERE_ARGS=%__WHERE_ARGS% cfr.bat
)
where /q bloop.cmd
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('bloop.cmd about 2^>^&1 ^| findstr /b bloop') do set __VERSIONS_LINE3=%__VERSIONS_LINE3% bloop %%j,
    set __WHERE_ARGS=%__WHERE_ARGS% bloop.cmd
)
where /q git.exe
if %ERRORLEVEL%==0 (
   for /f "tokens=1,2,*" %%i in ('git.exe --version') do set __VERSIONS_LINE3=%__VERSIONS_LINE3% git %%k,
    set __WHERE_ARGS=%__WHERE_ARGS% git.exe
)
where /q diff.exe
if %ERRORLEVEL%==0 (
   for /f "tokens=1-3,*" %%i in ('diff.exe --version ^| findstr diff') do set __VERSIONS_LINE3=%__VERSIONS_LINE3% diff %%l
    set __WHERE_ARGS=%__WHERE_ARGS% diff.exe
)
echo Tool versions:
echo   %__VERSIONS_LINE1%
echo   %__VERSIONS_LINE2%
echo   %__VERSIONS_LINE3%
if %__VERBOSE%==1 (
    rem if %_DEBUG%==1 echo %_DEBUG_LABEL% where %__WHERE_ARGS%
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do echo    %%p 1>&2
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
endlocal & (
    if not defined ANT_HOME set ANT_HOME=%_ANT_HOME%
    if not defined JAVA_HOME set JAVA_HOME=%_JDK_HOME%
    if not defined SCALA_HOME set SCALA_HOME=%_SCALA_HOME%
    if not defined DOTTY_HOME set DOTTY_HOME=%_DOTTY_HOME%
    set "PATH=%_JDK_PATH%%PATH%%_SCALA_PATH%%_DOTTY_PATH%%_ANT_PATH%%_GRADLE_PATH%%_MILL_PATH%%_MVN_PATH%%_SBT_PATH%%_CFR_PATH%%_PYTHON_PATH%%_BLOOP_PATH%%_GIT_PATH%;%~dp0bin"
    if %_EXITCODE%==0 call :print_env %_VERBOSE%
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)

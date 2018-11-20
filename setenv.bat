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
set _SCALA_PATH=
set _DOTTY_PATH=
set _ANT_PATH=
set _GRADLE_PATH=
set _MVN_PATH=
set _SBT_PATH=
set _CFR_PATH=
set _GIT_PATH=

call :javac
if not %_EXITCODE%==0 goto end

call :scalac
if not %_EXITCODE%==0 goto end

call :dotc
if not %_EXITCODE%==0 goto end

call :ant
rem optional
set _EXITCODE=0
rem if not %_EXITCODE%==0 goto end

call :gradle
rem optional
set _EXITCODE=0
rem if not %_EXITCODE%==0 goto end

call :mvn
rem optional
set _EXITCODE=0
rem if not %_EXITCODE%==0 goto end

call :sbt
rem optional
set _EXITCODE=0
rem if not %_EXITCODE%==0 goto end

call :cfr
rem optional
set _EXITCODE=0
rem if not %_EXITCODE%==0 goto end

call :git
rem optional
rem set _EXITCODE=0
if not %_EXITCODE%==0 goto end

if "%~1"=="clean" call :clean

goto end

rem ##########################################################################
rem ## Subroutines

rem input parameter: %*
rem output parameter: _HELP, _VERBOSE
:args
set _HELP=
set _VERBOSE=0

:args_loop
set __ARG=%~1
if not defined __ARG goto args_done
if /i "%__ARG%"=="help" ( set _HELP=1& goto :eof
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
goto :eof

:javac
where /q javac.exe
if %ERRORLEVEL%==0 goto :eof

if defined JDK_HOME (
    set _JDK_HOME=%JDK_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable JDK_HOME
) else (
    set _PATH=C:\Progra~1\Java
    for /f "delims=" %%f in ('dir /ad /b "!_PATH!\jdk1.8*" 2^>NUL') do set _JDK_HOME=!_PATH!\%%f
    if not defined _JDK_HOME (
        set _PATH=C:\opt
        for /f %%f in ('dir /ad /b "!_PATH!\jdk1.8*" 2^>NUL') do set _JDK_HOME=!_PATH!\%%f
    )
    if defined _JDK_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Java SDK installation directory !_JDK_HOME!
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

:scalac
where /q scalac.bat
if %ERRORLEVEL%==0 goto :eof

if defined SCALA_HOME (
    set _SCALA_HOME=%SCALA_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable SCALA_HOME
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\scala-2*" 2^>NUL') do set _SCALA_HOME=!_PATH!\%%f
    if defined _SCALA_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Scala installation directory !_SCALA_HOME!
    )
)
if not exist "%_SCALA_HOME%\bin\scalac.bat" (
    echo Error: Scala executable not found ^(%_SCALA_HOME%^) 1>&2
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
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable DOTTY_HOME
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b /od "!_PATH!\dotty*" 2^>NUL') do set _DOTTY_HOME=!_PATH!\%%f
    if defined _DOTTY_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Dotty installation directory !_DOTTY_HOME!
    )
)
if not exist "%_DOTTY_HOME%\bin\dotc.bat" (
    echo Error: Dotty executable not found ^(%_DOTTY_HOME%^) 1>&2
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
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable ANT_HOME
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\apache-ant\" ( set _ANT_HOME=!__PATH!\apache-ant
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\apache-ant-*" 2^>NUL') do set _ANT_HOME=!__PATH!\%%f
        if not defined _ANT_HOME (
            set __PATH=C:\Progra~1
            for /f %%f in ('dir /ad /b "!__PATH!\apache-ant-*" 2^>NUL') do set _ANT_HOME=!__PATH!\%%f
        )
    )
    if defined _ANT_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Ant installation directory !_ANT_HOME!
    )
)
if not exist "%_ANT_HOME%\bin\ant.cmd" (
    echo Error: Ant executable not found ^(%_ANT_HOME%^) 1>&2
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
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable GRADLE_HOME
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\gradle\" ( set _GRADLE_HOME=!__PATH!\gradle
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\gradle-*" 2^>NUL') do set _GRADLE_HOME=!__PATH!\%%f
        if not defined _GRADLE_HOME (
            set __PATH=C:\Progra~1
            for /f %%f in ('dir /ad /b "!__PATH!\gradle-*" 2^>NUL') do set _GRADLE_HOME=!__PATH!\%%f
        )
    )
    if defined _GRADLE_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Gradle installation directory !_GRADLE_HOME!
    )
)
if not exist "%_GRADLE_HOME%\bin\gradle.bat" (
    echo Error: Gradle executable not found ^(%_GRADLE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GRADLE_PATH=;%_GRADLE_HOME%\bin"
goto :eof

:mvn
where /q mvn.cmd
if %ERRORLEVEL%==0 goto :eof

if defined MAVEN_HOME (
    set _MVN_HOME=%MAVEN_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable MAVEN_HOME
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\apache-maven-*" 2^>NUL') do set _MVN_HOME=!_PATH!\%%f
    if defined _MVN_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Maven installation directory !_MVN_HOME!
    )
)
if not exist "%_MVN_HOME%\bin\mvn.cmd" (
    echo Error: Maven executable not found ^(%_MVN_HOME%^) 1>&2
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
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable SBT_HOME
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\sbt-1*" 2^>NUL') do set _SBT_HOME=!_PATH!\%%f
    if defined _SBT_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default sbt installation directory !_SBT_HOME!
    )
)
if not exist "%_SBT_HOME%\bin\sbt.bat" (
    echo Error: sbt executable not found ^(%_SBT_HOME%^) 1>&2
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
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable CFR_HOME
) else (
    set _PATH=C:\opt
    for /f %%f in ('dir /ad /b "!_PATH!\cfr*" 2^>NUL') do set _CFR_HOME=!_PATH!\%%f
    if defined _CFR_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default cfr installation directory !_CFR_HOME!
    )
)
if not exist "%_CFR_HOME%\bin\cfr.bat" (
    echo Error: cfr executable not found ^(%_CFR_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CFR_PATH=;%_CFR_HOME%\bin"
goto :eof

:git
where /q git.exe
if %ERRORLEVEL%==0 goto :eof

if defined GIT_HOME (
    set _GIT_HOME=%GIT_HOME%
    if %_DEBUG%==1 echo [%_BASENAME%] Using environment variable GIT_HOME
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set _GIT_HOME=!__PATH!\Git
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set _GIT_HOME=!__PATH!\%%f
        if not defined _GIT_HOME (
            set __PATH=C:\Progra~1
            for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set _GIT_HOME=!__PATH!\%%f
        )
    )
    if defined _GIT_HOME (
        if %_DEBUG%==1 echo [%_BASENAME%] Using default Git installation directory !_GIT_HOME!
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo Error: Git executable not found ^(%_GIT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\usr\bin"
goto :eof

:clean
for %%f in ("%~dp0") do set __ROOT_DIR=%%~sf
for /f %%i in ('dir /ad /b "%__ROOT_DIR%\" 2^>NUL') do (
    for /f %%j in ('dir /ad /b "%%i\target\scala-*" 2^>NUL') do (
        if %_DEBUG%==1 echo [%_BASENAME%] rmdir /s /q %__ROOT_DIR%%%i\target\%%j\classes 1^>NUL 2^>^&1
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
    rem if %_DEBUG%==1 echo [%_BASENAME%] where %__WHERE_ARGS%
    echo Tool paths:
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do echo    %%p
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
endlocal & (
    if not defined JAVA_HOME set JAVA_HOME=%_JDK_HOME%
    if not defined SCALA_HOME set SCALA_HOME=%_SCALA_HOME%
    if not defined DOTTY_HOME set DOTTY_HOME=%_DOTTY_HOME%
    set "PATH=%_JDK_PATH%%PATH%%_SCALA_PATH%%_DOTTY_PATH%%_ANT_PATH%%_GRADLE_PATH%%_MVN_PATH%%_SBT_PATH%%_CFR_PATH%%_GIT_PATH%;%~dp0bin"
    call :print_env %_VERBOSE%
    if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)

@echo off

rem ##########################################################################
rem ## This batch file is based on configuration file .drone.yml

setlocal enabledelayedexpansion

rem only for interactive debugging
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

if defined _HELP (
    call :help
    exit /b !_EXITCODE!
)
call :init
if not %_EXITCODE%==0 goto end

if defined _CLEAN (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if defined _UPDATE (
    call :update
    if not !_EXITCODE!==0 goto end
)
if defined _CLONE (
    call :clone
    if not !_EXITCODE!==0 goto end
)
if defined _COMPILE (
    call :test
    if not !_EXITCODE!==0 goto end
)
if defined _TEST_JAVA11 (
    call :test_java11
    if not !_EXITCODE!==0 goto end
)
if defined _BOOTSTRAP (
    call :test_bootstrapped
    rem if not !_EXITCODE!==0 goto end
    if not !_EXITCODE!==0 (
        if defined _IGNORE ( echo ###### Warning: _EXITCODE=!_EXITCODE! ####### 1>&2
        ) else ( goto end
        )
    )
)
if defined _COMMUNITY (
    call :community_build
    if not !_EXITCODE!==0 goto end
)
if defined _TEST_SBT (
    call :test_sbt
    if not !_EXITCODE!==0 goto end
)
if defined _DOCUMENTATION (
    call :documentation
    if not !_EXITCODE!==0 goto end
)
if defined _ARCHIVES (
    call :archives
    if not !_EXITCODE!==0 goto end
)
goto end

rem ##########################################################################
rem ## Subroutines

rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL, _SCRIPTS_DIR,
rem                    _DRONE_BUILD_EVENT, _DRONE_REMOTE_URL, _DRONE_BRANCH
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

set _SCRIPTS_DIR=%_ROOT_DIR%\project\scripts

call %_SCRIPTS_DIR%\common.bat
if not %_EXITCODE%==0 goto :eof

rem set _DRONE_BUILD_EVENT=pull_request
set _DRONE_BUILD_EVENT=
set _DRONE_REMOTE_URL=
set _DRONE_BRANCH=
goto :eof

rem input parameter: %*
rem output parameters: _CLONE, _COMPILE, _DOCUMENTATION, _SBT, _TIMER, _VERBOSE
:args
set _ARCHIVES=
set _BOOTSTRAP=
set _COMPILE=
set _CLEAN=
set _CLONE=
set _COMMUNITY=
set _DOCUMENTATION=
set _HELP=
set _TEST_JAVA11=
set _TEST_SBT=
set _TIMER=0
set _UPDATE=
set _VERBOSE=0

set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    rem option
    if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto :args_done
    )
) else (
    rem subcommand
    set /a __N+=1
    if /i "%__ARG:~0,4%"=="arch" (
        if not "%__ARG:~-5%"=="-only" set _CLONE=1& set _COMPILE=1& set _BOOTSTRAP=1
        set _ARCHIVES=1
    ) else if /i "%__ARG:~0,4%"=="boot" (
        if not "%__ARG:~-5%"=="-only" set _CLONE=1& set _COMPILE=1
        set _BOOTSTRAP=1
    ) else if /i "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if /i "%__ARG%"=="clone" ( set _CLONE=1
    ) else if /i "%__ARG:~0,7%"=="compile" (
        if not "%__ARG:~-5%"=="-only" set _CLONE=1
        set _COMPILE=1
    ) else if /i "%__ARG:~0,9%"=="community" (
        rem if not "%__ARG:~-5%"=="-only" set _CLONE=1& set _COMPILE=1& set _BOOTSTRAP=1
        set _COMMUNITY=1
    ) else if /i "%__ARG:~0,3%"=="doc" (
        if not "%__ARG:~-5%"=="-only" set _CLONE=1& set _COMPILE=1& set _BOOTSTRAP=1
        set _DOCUMENTATION=1
    ) else if /i "%__ARG%"=="help" ( set _HELP=1
    ) else if /i "%__ARG%"=="java11" ( set _CLONE=1& set _TEST_JAVA11=1
    ) else if /i "%__ARG%"=="sbt" (
        set _CLONE=1& set _COMPILE=1& set _BOOTSTRAP=1& set _TEST_SBT=1
    ) else if /i "%__ARG%"=="sbt-only" (
        set _TEST_SBT=1
    ) else if /i "%__ARG%"=="update" ( set _UPDATE=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto :args_done
    )
)
shift
goto args_loop
:args_done
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -timer                display total execution time
echo     -verbose              display environment settings
echo.
echo   Subcommands:
echo     arch[ives]            generate gz/zip archives ^(after bootstrap^)
echo     boot[strap]           generate+test bootstrapped compiler ^(after compile^)
echo     clean                 clean up project
echo     clone                 update submodules
echo     compile               generate+test 1st stage compiler ^(after clone^)
echo     community             test community-build
echo     doc[umentation]       generate documentation ^(after bootstrap^)
echo     help                  display this help message
echo     java11                generate+test Dotty compiler with Java 11
echo     sbt                   test sbt-dotty ^(after bootstrap^)
echo     update                fetch/merge upstream repository
echo.
echo   Advanced subcommands (no deps):
echo     arch[ives]-only       generate ONLY gz/zip archives
echo     boot[strap]-only      generate+test ONLY bootstrapped compiler
echo     compile-only          generate+test ONLY 1st stage compiler
echo     doc[umentation]-only  generate ONLY documentation
echo     sbt-only              test ONLY sbt-dotty

goto :eof

:init
if %_VERBOSE%==1 (
    for /f "delims=" %%i in ('where git.exe') do (
        if not defined __GIT_CMD1 set __GIT_CMD1=%%i
    )
    for /f "delims=" %%i in ('where java.exe') do (
        if not defined __JAVA_CMD1 set __JAVA_CMD1=%%i
    )
    set __SBT_BUILD_VERSION=unknown
    for /f %%i in ('findstr /c:"sbt.version" "%_ROOT_DIR%\project\build.properties"') do set __SBT_BUILD_VERSION=%%i
    set __BRANCH_NAME=unknown
    for /f %%i in ('!__GIT_CMD1! rev-parse --abbrev-ref HEAD') do set __BRANCH_NAME=%%i
    echo Tool paths
    echo    GIT_CMD=!__GIT_CMD1!
    echo    JAVA_CMD=!__JAVA_CMD1!
    echo    SBT_CMD=%_SBT_CMD%
    echo Tool options
    echo    JAVA_OPTS=%JAVA_OPTS%
    echo    SBT_OPTS=%SBT_OPTS%
    echo Sbt build version ^(build.properties^):
    echo    !__SBT_BUILD_VERSION!
    echo Current Git branch:
    echo    !__BRANCH_NAME!
    echo.
)
goto :eof

:clean
echo %_COLOR_START%run sbt clean%_COLOR_END%
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SBT_CMD%" clean 1>&2
call "%_SBT_CMD%" clean
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
rem if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_CMD% clean -xdf --exclude=*.bat --exclude=*.ps1 1>&2
rem call "%_GIT_CMD%" clean -xdf --exclude=*.bat --exclude=*.ps1
rem if not %ERRORLEVEL%==0 (
rem     set _EXITCODE=1
rem     goto :eof
rem )
goto :eof

:update
if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_CMD% fetch upstream master 1>&2
call "%_GIT_CMD%" fetch upstream master
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to fetch changes from upstream repository 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_CMD% merge upstream/master 1>&2
call "%_GIT_CMD%" merge upstream/master
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to merge changes from upstream repository 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:clone
if "%_DRONE_BUILD_EVENT%"=="pull_request" if defined _DRONE_REMOTE_URL (
    %_GIT_CMD% config user.email "dotty.bot@epfl.ch"
    %_GIT_CMD% config user.name "Dotty CI"
    %_GIT_CMD% pull "%_DRONE_REMOTE_URL%" "%_DRONE_BRANCH%"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_CMD% submodule sync 1>&2
call "%_GIT_CMD%" submodule sync
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to synchronize Git submodules 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_CMD% submodule update --init --recursive --jobs 7 1>&2
call "%_GIT_CMD%" submodule update --init --recursive --jobs 7
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to update Git submodules 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:test
echo %_COLOR_START%sbt compile and sbt test%_COLOR_END%
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SBT_CMD%" ;compile ;test 1>&2
call "%_SBT_CMD%" ";compile ;test"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to run sbt command ";compile ;test" 1>&2
    set _EXITCODE=1
    goto :eof
)

rem see shell script project/scripts/cmdTests
if %_DEBUG%==1 echo %_DEBUG_LABEL% %_SCRIPTS_DIR%\cmdTests.bat 1>&2
call %_SCRIPTS_DIR%\cmdTests.bat
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to run cmdTest.bat 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:test_bootstrapped
echo %_COLOR_START%sbt dotty-bootstrapped/compile and sbt dotty-bootstrapped/test%_COLOR_END%
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SBT_CMD%" ";dotty-bootstrapped/compile ;dotty-bootstrapped/test ;dotty-staging/test ;sjsSandbox/run;sjsSandbox/test;sjsJUnitTests/test"
call "%_SBT_CMD%" ";dotty-bootstrapped/compile ;dotty-bootstrapped/test ;dotty-staging/test ;sjsSandbox/run;sjsSandbox/test;sjsJUnitTests/test" 1>&2
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to run sbt command ";dotty-bootstrapped/compile ;dotty-bootstrapped/test ;dotty-staging/test ;sjsSandbox/run;sjsSandbox/test;sjsJUnitTests/test" 1>&2
    set _EXITCODE=1
    goto :eof
)

rem see shell script project/scripts/bootstrapCmdTests
if %_DEBUG%==1 echo %_DEBUG_LABEL% %_SCRIPTS_DIR%\bootstrapCmdTests.bat 1>&2
call %_SCRIPTS_DIR%\bootstrapCmdTests.bat
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to run bootstrapCmdTests.bat 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:community_build
echo %_COLOR_START%sbt community-build/test%_COLOR_END%
if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_CMD% submodule sync 1>&2
call "%_GIT_CMD%" submodule sync
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to synchronize Git submodules 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_CMD% submodule update --init --recursive --jobs 7 1>&2
call "%_GIT_CMD%" submodule update --init --recursive --jobs 7
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to update Git submodules 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SBT_CMD%" "-Dsbt.cmd=%_SBT_CMD%" community-build/test 1>&2
call "%_SBT_CMD%" "-Dsbt.cmd=%_SBT_CMD%" community-build/test
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to run sbt command community-build/test 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:test_sbt
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SBT_CMD%" sbt-dotty/scripted 1>&2
call "%_SBT_CMD%" sbt-dotty/scripted
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to run sbt command sbt-dotty/scripted 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:test_java11
echo %_COLOR_START%sbt compile and sbt test ^(Java 11^)%_COLOR_END%
if not defined JAVA11_HOME (
    echo %_ERROR_LABEL% Environment variable JAVA11_HOME is undefined 1>&2
    set _EXITCODE=1
    goto :eof
)
if not exist "%JAVA11_HOME%\bin\javac.exe" (
    echo %_ERROR_LABEL% Java SDK 11 installation directory is invalid 1>&2
    set _EXITCODE=1
    goto :eof
)
setlocal
rem export PATH="/usr/lib/jvm/java-11-openjdk-amd64/bin:$PATH"
set "PATH=%__JAVA11_HOME%\bin;%PATH%"
rem ./project/scripts/sbt "compile ;test"
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SBT_CMD%" ";compile ;test" 1>&2
call "%_SBT_CMD%" ;compile ;test
if not %ERRORLEVEL%==0 (
    endlocal
    echo %_ERROR_LABEL% Failed to run sbt command ";compile ;test" 1>&2
    set _EXITCODE=1
    goto :eof
)
endlocal
goto :eof

:documentation
rem see shell script project/scripts/genDocs
if %_DEBUG%==1 echo %_DEBUG_LABEL% %_SCRIPTS_DIR%\genDocs.bat 1>&2
call %_SCRIPTS_DIR%\genDocs.bat
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to run genDocs.bat 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:archives
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SBT_CMD%" dist-bootstrapped/packArchive 1>&2
call "%_SBT_CMD%" dist-bootstrapped/packArchive
rem output directory for gz/zip archives
set __TARGET_DIR=%_ROOT_DIR%\dist-bootstrapped\target
if not exist "%__TARGET_DIR%\" (
    echo %_ERROR_LABEL% Directory target not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 (
    echo. 1>&2
    echo Output directory: %__TARGET_DIR%\ 1>&2
    dir /b /a-d "%__TARGET_DIR%"
)
goto :eof

rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total elasped time: !_DURATION!
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

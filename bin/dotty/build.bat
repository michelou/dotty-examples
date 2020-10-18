@echo off

@rem #########################################################################
@rem ## This batch file is based on configuration file .drone.yml

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
    @rem if not !_EXITCODE!==0 goto end
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

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL, _SCRIPTS_DIR,
@rem                    _DRONE_BUILD_EVENT, _DRONE_REMOTE_URL, _DRONE_BRANCH
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
set _COLOR_START=%_NORMAL_FG_GREEN%
set _COLOR_END=%_RESET%

set "_SCRIPTS_DIR=%_ROOT_DIR%\project\scripts"
if not exist "%_SCRIPTS_DIR%\cmdTestsCommon.inc.bat" (
    echo %_ERROR_LABEL% Common batch file not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SCRIPTS_DIR%\cmdTestsCommon.inc.bat" 1>&2
call "%_SCRIPTS_DIR%\cmdTestsCommon.inc.bat"
if not %_EXITCODE%==0 goto :eof

@rem set _DRONE_BUILD_EVENT=pull_request
set _DRONE_BUILD_EVENT=
set _DRONE_REMOTE_URL=
set _DRONE_BRANCH=
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
@rem output parameters: _CLONE, _COMPILE, _DOCUMENTATION, _SBT, _TIMER, _VERBOSE
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
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %_STRONG_FG_GREEN%%__ARG%%__END% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG:~0,4%"=="arch" (
        if not "%__ARG:~-5%"=="-only" set _CLONE=1& set _COMPILE=1& set _BOOTSTRAP=1
        set _ARCHIVES=1
    ) else if "%__ARG:~0,4%"=="boot" (
        if not "%__ARG:~-5%"=="-only" set _CLONE=1& set _COMPILE=1
        set _BOOTSTRAP=1
    ) else if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="clone" ( set _CLONE=1
    ) else if "%__ARG:~0,7%"=="compile" (
        if not "%__ARG:~-5%"=="-only" set _CLONE=1
        set _COMPILE=1
    ) else if "%__ARG:~0,9%"=="community" (
        rem if not "%__ARG:~-5%"=="-only" set _CLONE=1& set _COMPILE=1& set _BOOTSTRAP=1
        set _COMMUNITY=1
    ) else if "%__ARG:~0,3%"=="doc" (
        if not "%__ARG:~-5%"=="-only" set _CLONE=1& set _COMPILE=1& set _BOOTSTRAP=1
        set _DOCUMENTATION=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="java11" ( set _CLONE=1& set _TEST_JAVA11=1
    ) else if "%__ARG%"=="sbt" (
        set _CLONE=1& set _COMPILE=1& set _BOOTSTRAP=1& set _TEST_SBT=1
    ) else if "%__ARG%"=="sbt-only" (
        set _TEST_SBT=1
    ) else if "%__ARG%"=="update" ( set _UPDATE=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %_STRONG_FG_GREEN%%__ARG%%__END% 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
if %_VERBOSE%==1 call :print_env
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:print_env
set __SBT_BUILD_VERSION=unknown
if exist "%_ROOT_DIR%\project\build.properties" (
    for /f %%i in ('findstr /c:"sbt.version" "%_ROOT_DIR%\project\build.properties"') do set __SBT_BUILD_VERSION=%%i
)
set __BRANCH_NAME=unknown
for /f %%i in ('"%_GIT_CMD%" rev-parse --abbrev-ref HEAD') do set __BRANCH_NAME=%%i

echo Tool paths 1>&2
echo    GIT_CMD="%_GIT_CMD%"
echo    JAVA_CMD="%JAVA_HOME%\bin\java.exe"
echo    SBT_CMD="%_SBT_CMD%"
echo Tool options
echo    JAVA_OPTS=%JAVA_OPTS%
echo    SBT_OPTS=%SBT_OPTS%
echo Sbt build version ^(build.properties^):
echo    %__SBT_BUILD_VERSION%
echo Current Git branch:
echo    %__BRANCH_NAME%
echo.
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
echo     %__BEG_O%-timer%__END%                display total execution time
echo     %__BEG_O%-verbose%__END%              display environment settings
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%arch[ives]%__END%            generate gz/zip archives ^(after bootstrap^)
echo     %__BEG_O%boot[strap]%__END%           generate+test bootstrapped compiler ^(after %__BEG_O%compile%__END%^)
echo     %__BEG_O%clean%__END%                 clean up project
echo     %__BEG_O%clone%__END%                 update submodules
echo     %__BEG_O%compile%__END%               generate+test 1st stage compiler ^(after %__BEG_O%clone%__END%^)
echo     %__BEG_O%community%__END%             test community-build
echo     %__BEG_O%doc[umentation]%__END%       generate documentation ^(after %__BEG_O%bootstrap%__END%^)
echo     %__BEG_O%help%__END%                  display this help message
echo     %__BEG_O%java11%__END%                generate+test Dotty compiler with Java 11
echo     %__BEG_O%sbt%__END%                   test sbt-dotty ^(after bootstrap^)
echo     %__BEG_O%update%__END%                fetch/merge upstream repository
echo.
echo   %__BEG_P%Advanced subcommands (no deps):%__END%
echo     %__BEG_O%arch[ives]-only%__END%       generate ONLY gz/zip archives
echo     %__BEG_O%boot[strap]-only%__END%      generate+test ONLY bootstrapped compiler
echo     %__BEG_O%compile-only%__END%          generate+test ONLY 1st stage compiler
echo     %__BEG_O%doc[umentation]-only%__END%  generate ONLY documentation
echo     %__BEG_O%sbt-only%__END%              test ONLY sbt-dotty
goto :eof

:clean
echo %_COLOR_START%run sbt clean%_COLOR_END%
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SBT_CMD%" ";clean ;scala3-bootstrapped/clean" 1>&2
call "%_SBT_CMD%" ";clean ;scala3-bootstrapped/clean"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
@rem if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_CMD% clean -xdf --exclude=*.bat --exclude=*.ps1 1>&2
@rem call "%_GIT_CMD%" clean -xdf --exclude=*.bat --exclude=*.ps1
@rem if not %ERRORLEVEL%==0 (
@rem     set _EXITCODE=1
@rem     goto :eof
@rem )
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
    call "%_GIT_CMD%" config user.email "dotty.bot@epfl.ch"
    call "%_GIT_CMD%" config user.name "Dotty CI"
    call "%_GIT_CMD%" pull "%_DRONE_REMOTE_URL%" "%_DRONE_BRANCH%"
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
call "%_SBT_CMD%" ;compile ;test
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to run sbt command ";compile ;test" 1>&2
    set _EXITCODE=1
    goto :eof
)

rem see shell script project/scripts/cmdTests
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SCRIPTS_DIR%\cmdTests.bat" 1>&2
call "%_SCRIPTS_DIR%\cmdTests.bat"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to run cmdTest.bat 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:test_bootstrapped
echo %_COLOR_START%sbt scala3-bootstrapped/compile and sbt scala3-bootstrapped/test%_COLOR_END%
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SBT_CMD%" ";scala3-bootstrapped/compile ;scala3-bootstrapped/test ;scala3-staging/test ;sjsSandbox/run;sjsSandbox/test;sjsJUnitTests/test"
call "%_SBT_CMD%" ";scala3-bootstrapped/compile ;scala3-bootstrapped/test ;scala3-staging/test ;sjsSandbox/run;sjsSandbox/test;sjsJUnitTests/test" 1>&2
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to run sbt command ";scala3-bootstrapped/compile ;scala3-bootstrapped/test ;scala3-staging/test ;sjsSandbox/run;sjsSandbox/test;sjsJUnitTests/test" 1>&2
    set _EXITCODE=1
    goto :eof
)

@rem see shell script project/scripts/bootstrapCmdTests
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SCRIPTS_DIR%\bootstrapCmdTests.bat" 1>&2
call "%_SCRIPTS_DIR%\bootstrapCmdTests.bat"
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
@rem export PATH="/usr/lib/jvm/java-11-openjdk-amd64/bin:$PATH"
set "PATH=%__JAVA11_HOME%\bin;%PATH%"
@rem ./project/scripts/sbt "compile ;test"
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
@rem see shell script project/scripts/genDocs
if %_DEBUG%==1 echo %_DEBUG_LABEL% %_SCRIPTS_DIR%\genDocs.bat 1>&2
call "%_SCRIPTS_DIR%\genDocs.bat"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to run genDocs.bat 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:archives
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SBT_CMD%" dist/packArchive 1>&2
call "%_SBT_CMD%" dist/packArchive
@rem output directory for gz/zip archives
set "__TARGET_DIR=%_ROOT_DIR%dist\target"
if not exist "%__TARGET_DIR%\" (
    echo %_ERROR_LABEL% Directory target not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 (
    echo. 1>&2
    echo Output directory: "%__TARGET_DIR%" 1>&2
    dir /b /a-d "%__TARGET_DIR%"
)
goto :eof

@rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total elasped time: !_DURATION!
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

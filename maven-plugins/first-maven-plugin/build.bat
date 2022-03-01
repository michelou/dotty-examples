@echo off 
setlocal enabledelayedexpansion

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
for %%i in (%_COMMANDS%) do (
    call :%%i
    if not !_EXITCODE!==0 goto end
)

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

set "_TARGET_DIR=%_ROOT_DIR%target"
set "_TEST_DIR=%_ROOT_DIR%test"
set "_CLASSES_DIR=%_TARGET_DIR%\classes"

set _DEBUG_LABEL=[%_BASENAME%]
set _ERROR_LABEL=Error:

if not exist "%MAVEN_HOME%\bin\mvn.cmd" (
    echo %_ERROR_LABEL% Maven installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MVN_CMD=%MAVEN_HOME%\bin\mvn.cmd"
goto :eof

:args
set _COMMANDS=
set _HELP=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _COMMANDS=help
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _COMMANDS=!_COMMANDS! clean
    ) else if "%__ARG%"=="compile" ( set _COMMANDS=!_COMMANDS! compile
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="install" ( set _COMMANDS=!_COMMANDS! install
    ) else if "%__ARG%"=="pack" ( set _COMMANDS=!_COMMANDS! pack
    ) else if "%__ARG%"=="test" ( set _COMMANDS=!_COMMANDS! test
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
if %_DEBUG%==1 ( set _MVN_OPTS=
) else ( set _MVN_OPTS=-q
)
for %%i in ("%~dp0.") do set "_PROJECT_NAME=%%~ni"

if %_DEBUG%==1 (
     echo %_DEBUG_LABEL% Options    : _VERBOSE=%_VERBOSE% 1>&2
     echo %_DEBUG_LABEL% Subcommands: %_COMMANDS% 1>&2
     echo %_DEBUG_LABEL% Variables  : "MAVEN_HOME=%MAVEN_HOME%" 1>&2
     echo %_DEBUG_LABEL% Variables  : "_PROJECT_NAME=%_PROJECT_NAME%" 1>&2
)
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-debug%__END%      show commands executed by this script
echo     %__BEG_O%-verbose%__END%    display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%       delete generated files
echo     %__BEG_O%compile%__END%     generate class files
echo     %__BEG_O%install%__END%     install JAR artifact to local Maven repository
echo     %__BEG_O%pack%__END%        generate JAR artifact
echo     %__BEG_O%test%__END%        delete generated files
goto :eof

:clean
if %_DEBUG%==1 ( echo "%_MVN_CMD%" %_MVN_OPTS% clean 1>&2
) else if %_VERBOSE%==1 ( echo Delete generated files 1>&2
)
call "%_MVN_CMD%" %_MVN_OPTS% clean
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to delete generated files 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
set "__TIMESTAMP_FILE=%_TARGET_DIR%\.latest-build"

call :action_required "%__TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\java\*.java"
if %_ACTION_REQUIRED%==0 goto :eof

if %_DEBUG%==1 ( echo "%_MVN_CMD%" %_MVN_OPTS% compile 1>&2
) else if %_VERBOSE%==1 ( echo Compile Java source files 1>&2
)
call "%_MVN_CMD%" %_MVN_OPTS% compile
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile Java source files 1>&2
    set _EXITCODE=1
    goto :eof
)
echo.> "%__TIMESTAMP_FILE%"
goto :eof

:pack
for /f "delims=" %%f in ('dir /b /s "%_TARGET_DIR%\%_PROJECT_NAME%*.jar" 2^>NUL') do (
    call :action_required "%%f" "%_CLASSES_DIR%\*.class" "%_ROOT_DIR%pom.xml"
    if %_ACTION_REQUIRED%==0 goto :eof
)
if %_DEBUG%==1 ( echo "%_MVN_CMD%" %_MVN_OPTS% package 1>&2
) else if %_VERBOSE%==1 ( echo Generate JAR artifact 1>&2
)
call "%_MVN_CMD%" %_MVN_OPTS% package
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to generate JAR artifact 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:install
set __JAR_FILE=
for /f "delims=" %%f in ('dir /b /s "%_TARGET_DIR%\*.jar"') do set "__JAR_FILE=%%f"
if not defined __JAR_FILE (
    echo %_ERROR_LABEL% JAR artifact not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __GROUP_ID=org.sonatype.mavenbook.plugins
set __ARTIFACT_ID=first-maven-plugin

if %_DEBUG%==1 ( echo "%_MVN_CMD%" %_MVN_OPTS% install:install-file "-Dfile=%__JAR_FILE%" "-DgroupId=%__GROUP_ID%" "-DartifactId=%__ARTIFACT_ID%" ... 1>&2
) else if %_VERBOSE%==1 ( echo Install artifact "!__JAR_FILE:%_ROOT_DIR%=!" 1>&2
)
call "%_MVN_CMD%" %_MVN_OPTS% install:install-file "-Dfile=%__JAR_FILE%" "-DgroupId=%__GROUP_ID%" "-DartifactId=%__ARTIFACT_ID%" -Dversion=1.0-SNAPSHOT -Dpackaging=jar -DcreateChecksum=true
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to install Java archive file 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:test
set __POM_FILE=
for /f "delims=" %%f in ('dir /b /s "%_TEST_DIR%\pom.xml"') do set "__POM_FILE=%%f"
if not defined __POM_FILE (
    echo %_ERROR_LABEL% POM file not found in directory "!_TEST_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set __MVN_OPTS=-f "%__POM_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MVN_CMD%" %__MVN_OPTS% compile 1>&2
) else if %_VERBOSE%==1 ( echo Execute test 1>&2
)
call "%_MVN_CMD%" %__MVN_OPTS% compile
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to install Java archive file 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: 1=target file 2,3,..=path (wildcards accepted)
@rem output parameter: _ACTION_REQUIRED
:action_required
set "__TARGET_FILE=%~1"

set __PATH_ARRAY=
set __PATH_ARRAY1=
:action_path
shift
set "__PATH=%~1"
if not defined __PATH goto action_next
set __PATH_ARRAY=%__PATH_ARRAY%,'%__PATH%'
set __PATH_ARRAY1=%__PATH_ARRAY1%,'!__PATH:%_ROOT_DIR%=!'
goto action_path

:action_next
set __TARGET_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -path '%__TARGET_FILE%' -ea Stop | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
     set __TARGET_TIMESTAMP=%%i
)
set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -recurse -path %__PATH_ARRAY:~1% -ea Stop | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
    set __SOURCE_TIMESTAMP=%%i
)
call :newer %__SOURCE_TIMESTAMP% %__TARGET_TIMESTAMP%
set _ACTION_REQUIRED=%_NEWER%
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% %__TARGET_TIMESTAMP% Target : '%__TARGET_FILE%' 1>&2
    echo %_DEBUG_LABEL% %__SOURCE_TIMESTAMP% Sources: %__PATH_ARRAY:~1% 1>&2
    echo %_DEBUG_LABEL% _ACTION_REQUIRED=%_ACTION_REQUIRED% 1>&2
) else if %_VERBOSE%==1 if %_ACTION_REQUIRED%==0 if %__SOURCE_TIMESTAMP% gtr 0 (
    echo No action required ^(%__PATH_ARRAY1:~1%^) 1>&2
)
goto :eof

@rem output parameter: _NEWER
:newer
set __TIMESTAMP1=%~1
set __TIMESTAMP2=%~2

set __DATE1=%__TIMESTAMP1:~0,8%
set __TIME1=%__TIMESTAMP1:~-6%

set __DATE2=%__TIMESTAMP2:~0,8%
set __TIME2=%__TIMESTAMP2:~-6%

if %__DATE1% gtr %__DATE2% ( set _NEWER=1
) else if %__DATE1% lss %__DATE2% ( set _NEWER=0
) else if %__TIME1% gtr %__TIME2% ( set _NEWER=1
) else ( set _NEWER=0
)
goto :eof

@rem #########################################################################
@rem ## 

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

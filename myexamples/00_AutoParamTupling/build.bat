@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _EXITCODE=0

set _BASENAME=%~n0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

call :env
if not %_EXITCODE%==0 goto end

call :props
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)
if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    call :compile
    if not !_EXITCODE!==0 goto end
)
if %_DOC%==1 (
    call :doc
    if not !_EXITCODE!==0 goto end
)
if %_RUN%==1 (
    call :run
    if not !_EXITCODE!==0 goto end
)
if %_TEST%==1 (
    call :test
    if not !_EXITCODE!==0 goto end
)
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

set _SOURCE_DIR=%_ROOT_DIR%src
set _TARGET_DIR=%_ROOT_DIR%target
set _LIBS_DIR=%_TARGET_DIR%\libs
set _CLASSES_DIR=%_TARGET_DIR%\classes
set _TASTY_CLASSES_DIR=%_TARGET_DIR%\classes-tasty
set _DOCS_DIR=%_ROOT_DIR%site-root\docs
goto :eof

rem output parameters: _COMPILE_CMD_DEFAULT, _DOC_CMD_DEFAULT, _MAIN_CLASS_DEFAULT
:props
set _COMPILE_CMD_DEFAULT=dotc.bat
set _DOC_CMD_DEFAULT=dotd.bat
set _MAIN_CLASS_DEFAULT=myexamples.Main
set _MAIN_ARGS_DEFAULT=

set __PROPS_FILE=%_ROOT_DIR%project\build.properties
if exist "%__PROPS_FILE%" (
    for /f "tokens=1,* delims==" %%i in (%__PROPS_FILE%) do (
        set _NAME=%%~i
        set _VALUE=%%~j
        set _NAME=!_NAME:.=_!
        if not "!_NAME!"=="" (
            rem trim value
            for /f "tokens=*" %%v in ("!_VALUE!") do set _VALUE=%%v
            set _!_NAME: =!=!_VALUE!
        )
    )
    if defined _compiler_cmd set _COMPILE_CMD_DEFAULT=!_compiler_cmd!
    if defined _main_class set _MAIN_CLASS_DEFAULT=!_main_class!
    if defined _main_args set _MAIN_ARGS_DEFAULT=!_main_args!
)
goto :eof

rem input parameter: %*
:args
set _CLEAN=0
set _COMPILE=0
set _COMPILE_CMD=%_COMPILE_CMD_DEFAULT%
set _COMPILE_OPTS=-deprecation -feature
set _COMPILE_TIME=0
set _DOC=0
set _DOC_CMD=%_DOC_CMD_DEFAULT%
set _HELP=0
set _MAIN_CLASS=%_MAIN_CLASS_DEFAULT%
set _MAIN_ARGS=%_MAIN_ARGS_DEFAULT%
set _RUN=0
set _RUN_CMD=dotr
set _TEST=0
set _TASTY=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    rem options
    if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-explain" ( set _COMPILE_OPTS=!_COMPILE_OPTS! -explain
    ) else if /i "%__ARG%"=="-explain-types" (
        if "%_COMPILE_CMD:~0,3%"=="dot" ( set _COMPILE_OPTS=!_COMPILE_OPTS! -explain-types
        ) else ( set _COMPILE_OPTS=!_COMPILE_OPTS! -explaintypes
        )
    ) else if /i "%__ARG%"=="-help" ( set _HELP=1
    ) else if /i "%__ARG%"=="-tasty" ( set _TASTY=1
    ) else if /i "%__ARG%"=="-timer" ( set _COMPILE_TIME=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else if /i "%__ARG:~0,10%"=="-compiler:" (
        call :set_compiler "!__ARG:~10!"
        if not !_EXITCODE!== 0 goto args_done
    ) else if /i "%__ARG:~0,6%"=="-main:" (
        call :set_main "!__ARG:~6!"
        if not !_EXITCODE!== 0 goto args_done
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    rem subcommands
    set /a __N+=1
    if /i "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if /i "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if /i "%__ARG%"=="doc" ( set _DOC=1
    ) else if /i "%__ARG%"=="help" ( set _HELP=1
    ) else if /i "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
    ) else if /i "%__ARG%"=="test" ( set _COMPILE=1& set _TEST=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto :args_loop
:args_done
if %_DEBUG%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TOTAL_TIME_START=%%i
    echo %_DEBUG_LABEL% _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _COMPILE_CMD=%_COMPILE_CMD% _DOC=%_DOC% _RUN=%_RUN% _RUN_CMD=%_RUN_CMD%
)
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug           show commands executed by this script
echo     -explain         set compiler option -explain
echo     -explain-types   set compiler option -explain-types
echo     -compiler:^<name^> select compiler ^(scala^|scalac^|dotc^|dotty^), default:%_COMPILE_CMD_DEFAULT%
echo     -main:^<name^>     define main class name
echo     -tasty           compile both from source and TASTy files
echo     -timer           display compile time
echo     -verbose         display progress messages
echo.
echo   Subcommands:
echo     clean            delete generated class files
echo     compile          compile source files ^(Java and Scala^)
echo     doc              generate documentation
echo     help             display this help message
echo     run              execute main class
echo     test             execute JUnit tests
echo.
echo   Properties:
echo   ^(to be defined in SBT configuration file project\build.properties^)
echo     compiler.cmd     alternative to option -compiler
echo     main.class       alternative to option -main
echo     main.args        list of arguments to be passed to main class
goto :eof

rem output parameter(s): _COMPILE_CMD, _RUN_CMD
:set_compiler
set __VALUE=%~1
if /i "%__VALUE%"=="scala" (
    set _COMPILE_CMD=scalac.bat
    set _DOC_CMD=scaladoc.bat
    set _RUN_CMD=scala.bat
) else if /i "%__VALUE%"=="scalac" (
    set _COMPILE_CMD=scalac.bat
    set _DOC_CMD=scaladoc.bat
    set _RUN_CMD=scala.bat
) else if /i "%__VALUE%"=="dotc" (
    set _COMPILE_CMD=dotc.bat
    set _DOC_CMD=dotd.bat
    set _RUN_CMD=dotr.bat
) else if /i "%__VALUE%"=="dotty" (
    set _COMPILE_CMD=dotc.bat
    set _DOC_CMD=dotd.bat
    set _RUN_CMD=dotr.bat
) else (
    echo %_ERROR_LABEL% Unknown target %__VALUE% ^(scala^|scalac^|dotc^|dotty^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

rem output parameter: _MAIN_CLASS
:set_main
set __ARG=%~1
set __VALID=0
for /f %%i in ('powershell -C "$s='%__ARG%'; if($s -match '^[\w$]+(\.[\w$]+)*$'){1}else{0}"') do set __VALID=%%i
rem if %_DEBUG%==1 echo %_DEBUG_LABEL% __ARG=%__ARG% __VALID=%__VALID%
if %__VALID%==0 (
    echo %_ERROR_LABEL% Invalid class name passed to option "-main" ^(%__ARG%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _MAIN_CLASS=%__ARG%
goto :eof

:clean
for %%m in (out target) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% forfiles /s /p %_ROOT_DIR% /m %%m /c "cmd /c echo @path" 2^>NUL
    for /f %%i in ('forfiles /s /p %_ROOT_DIR% /m %%m /c "cmd /c if @isdir==TRUE echo @path" 2^>NUL') do (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% rmdir /s /q %%i
        rmdir /s /q %%i
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to clean directory %%i 1>&2
            set _EXITCODE=1
        )
    )
)
goto :eof

rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

:compile
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%" 1>NUL

set __TIMESTAMP_FILE=%_CLASSES_DIR%\.latest-build

set __JAVA_SOURCE_FILES=
for /f %%i in ('dir /s /b "%_SOURCE_DIR%\main\java\*.java" 2^>NUL') do (
    set __JAVA_SOURCE_FILES=!__JAVA_SOURCE_FILES! %%i
)
set __SCALA_SOURCE_FILES=
for /f %%i in ('dir /s /b "%_SOURCE_DIR%\main\scala\*.scala" 2^>NUL') do (
    set __SCALA_SOURCE_FILES=!__SCALA_SOURCE_FILES! %%i
)
for /f %%i in ('dir /s /b "%_SOURCE_DIR%\test\scala\*.scala" 2^>NUL') do (
    set __SCALA_SOURCE_FILES=!__SCALA_SOURCE_FILES! %%i
)

call :compile_required "%__TIMESTAMP_FILE%" "%__JAVA_SOURCE_FILES% %__SCALA_SOURCE_FILES%"
if %_COMPILE_REQUIRED%==0 goto :eof

if %_COMPILE_TIME%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __COMPILE_TIME_START=%%i
)
call :libs_cpath

if not defined __JAVA_SOURCE_FILES goto compile_scala
set _JAVAC_CMD=javac.exe
set _JAVAC_OPTS=-classpath "%_LIBS_CPATH%%_CLASSES_DIR%" -d %_CLASSES_DIR%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_JAVAC_CMD% %_JAVAC_OPTS% %__JAVA_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile Java sources to !_CLASSES_DIR:%_ROOT_DIR%=! 1>&2
)
%_JAVAC_CMD% %_JAVAC_OPTS% %__JAVA_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Java compilation failed 1>&2
    set _EXITCODE=1
    goto :eof
)
:compile_scala
where /q %_COMPILE_CMD%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% %_COMPILE_CMD% compiler not found 1>&2
    set _EXITCODE=1
    goto :eof
)
rem see https://docs.scala-lang.org/overviews/compiler-options/index.html
set __COMPILE_OPTS=%_COMPILE_OPTS% -classpath "%_LIBS_CPATH%%_CLASSES_DIR%" -d %_CLASSES_DIR% -explain

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_COMPILE_CMD% %__COMPILE_OPTS% %__SCALA_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile Scala sources to !_CLASSES_DIR:%_ROOT_DIR%=! 1>&2
)
call %_COMPILE_CMD% %__COMPILE_OPTS% %__SCALA_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Scala compilation failed 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f %%i in ('powershell -C "Get-Date -uformat %%Y%%m%%d%%H%%M%%S"') do (
    echo %%i> %__TIMESTAMP_FILE%
)
if %_COMPILE_TIME%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __COMPILE_TIME_END=%%i
    call :duration "%__COMPILE_TIME_START%" "!__COMPILE_TIME_END!"
    echo Compile time: !_DURATION! 1>&2
)
if %_TASTY%==1 (
    if not exist "%_TASTY_CLASSES_DIR%\" mkdir "%_TASTY_CLASSES_DIR%"
    set __CLASS_NAMES=
    for /f %%f in ('dir /b "%_CLASSES_DIR%\*.tasty" 2^>NUL') do (
        set __CLASS_NAME=%%f
        set __CLASS_NAMES=!__CLASS_NAMES! !__CLASS_NAME:~0,-6!
    )
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_COMPILE_CMD% -from-tasty !__CLASS_NAMES! -classpath %_CLASSES_DIR% -d %_TASTY_CLASSES_DIR% 1>&2
    ) else if %_VERBOSE%==1 ( echo Compile TASTy files to !_TASTY_CLASSES_DIR:%_ROOT_DIR%=! 1>&2
    )
    call %_COMPILE_CMD% -from-tasty !__CLASS_NAMES! -classpath %_CLASSES_DIR% -d %_TASTY_CLASSES_DIR%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Scala compilation from TASTy files failed 1>&2
        set _EXITCODE=1
    )
    if not !_EXITCODE!==0 goto :eof
)
goto :eof

rem input parameter: 1=timestamp file 2=source files
rem output parameter: _COMPILE_REQUIRED
:compile_required
set __TIMESTAMP_FILE=%~1
set __SOURCE_FILES=%~2

set __SOURCE_TIMESTAMP=00000000000000
set __N=0
for %%i in (%__SOURCE_FILES%) do (
    call :timestamp "%%i"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% !_TIMESTAMP! %%i 1>&2
    call :newer !_TIMESTAMP! !__SOURCE_TIMESTAMP!
    if !_NEWER!==1 set __SOURCE_TIMESTAMP=!_TIMESTAMP!
    set /a __N=!__N!+1
)
if exist "%__TIMESTAMP_FILE%" ( set /p __CLASS_TIMESTAMP=<%__TIMESTAMP_FILE%
) else ( set __CLASS_TIMESTAMP=00000000000000
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% %__CLASS_TIMESTAMP% %__TIMESTAMP_FILE% 1>&2

call :newer %__SOURCE_TIMESTAMP% %__CLASS_TIMESTAMP%
set _COMPILE_REQUIRED=%_NEWER%
if %_COMPILE_REQUIRED%==0 (
    if %_RUN%==0 echo No compilation needed ^(%__N% source files^)
)
goto :eof

rem output parameter: _NEWER
:newer
set __TIMESTAMP1=%~1
set __TIMESTAMP2=%~2

set __TIMESTAMP1_DATE=%__TIMESTAMP1:~0,8%
set __TIMESTAMP1_TIME=%__TIMESTAMP1:~-6%

set __TIMESTAMP2_DATE=%__TIMESTAMP2:~0,8%
set __TIMESTAMP2_TIME=%__TIMESTAMP2:~-6%

if %__TIMESTAMP1_DATE% gtr %__TIMESTAMP2_DATE% ( set _NEWER=1
) else if %__TIMESTAMP1_DATE% lss %__TIMESTAMP2_DATE% ( set _NEWER=0
) else if %__TIMESTAMP1_TIME% gtr %__TIMESTAMP2_TIME% ( set _NEWER=1
) else ( set _NEWER=0
)
goto :eof

rem input parameter: 1=file path
rem output parameter: _TIMESTAMP
:timestamp
set __FILE_PATH=%~1

set _TIMESTAMP=00000000000000
for /f %%i in ('powershell -C "(Get-ChildItem '%__FILE_PATH%').LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S"') do (
    set _TIMESTAMP=%%i
)
goto :eof

rem output parameter: _LIBS_CPATH
:libs_cpath
set _LIBS_CPATH=

if not exist "%_LIBS_DIR%" mkdir "%_LIBS_DIR%"

set __CURL_CMD=curl.exe
set __CURL_OPTS=
if not %_DEBUG%==1 set __CURL_OPTS=--silent

:libs_standalone
set __STANDALONE_JAR_NAME=junit-platform-console-standalone-1.5.0.jar
set __STANDALONE_JAR_URL=https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.5.0/%__STANDALONE_JAR_NAME%
set __STANDALONE_JAR_FILE=%_LIBS_DIR%\%__STANDALONE_JAR_NAME%
if not exist "%__STANDALONE_JAR_FILE%" (
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %__CURL_CMD% %__CURL_OPTS% --output %__STANDALONE_JAR_FILE% %__STANDALONE_JAR_URL% 1>&2
    ) else if %_VERBOSE%==1 ( echo Download dependency file %__STANDALONE_JAR_NAME% to directory !_LIBS_DIR:%_ROOT_DIR%=! 1>&2
    )
    call %__CURL_CMD% %__CURL_OPTS% --output %__STANDALONE_JAR_FILE% %__STANDALONE_JAR_URL%
    if not !ERRORLEVEL!==0 (
        set _EXITCODE=1
    )
)
if exist "%_LIBS_DIR%\" (
    for /f %%i in ('dir /b "%_LIBS_DIR%\*.jar" 2^>NUL') do (
        set _LIBS_CPATH=!_LIBS_CPATH!%_LIBS_DIR%\%%i;
    )
)
goto :eof

:doc
if not exist "%_DOCS_DIR%" mkdir "%_DOCS_DIR%" 1>NUL

set __TIMESTAMP_FILE=%_DOCS_DIR%\.latest-build

set __SCALA_SOURCE_FILES=
for /f %%i in ('dir /s /b "%_ROOT_DIR%src\main\scala\*.scala" 2^>NUL') do (
    set __SCALA_SOURCE_FILES=!__SCALA_SOURCE_FILES! %%i
)

for %%i in ("%~dp0\.") do set __PROJECT=%%~ni
set __DOC_OPTS=-siteroot %_ROOT_DIR%site-root -d %_DOCS_DIR% -project %__PROJECT% -project-version 0.1-SNAPSHOT

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_DOC_CMD% %__DOC_OPTS% %__SCALA_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Generate Dotty documentation into directory !_DOCS_DIR:%_ROOT_DIR%=! 1>&2
)
call %_DOC_CMD% %__DOC_OPTS% %__SCALA_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Scala documentation generation failed 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:run
set __MAIN_CLASS_FILE=%_CLASSES_DIR%\%_MAIN_CLASS:.=\%.class
if not exist "%__MAIN_CLASS_FILE%" (
    echo %_ERROR_LABEL% Main class '%_MAIN_CLASS%' not found ^(%__MAIN_CLASS_FILE%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set __RUN_OPTS=-classpath "%_LIBS_CPATH%%_CLASSES_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_RUN_CMD% %__RUN_OPTS% %_MAIN_CLASS% %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Scala main class %_MAIN_CLASS% 1>&2
)
call %_RUN_CMD% %__RUN_OPTS% %_MAIN_CLASS% %_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Program execution failed ^(%_MAIN_CLASS%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_TASTY%==1 (
    if not exist "%_TASTY_CLASSES_DIR%" (
        echo %_WARNING_LABEL% TASTy output directory not found 1>&2
        set _EXITCODE=1
        goto :eof
    )
    set __RUN_OPTS=-classpath "%_LIBS_CPATH%%_TASTY_CLASSES_DIR%;%_CLASSES_DIR%"

    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_RUN_CMD% !__RUN_OPTS! %_MAIN_CLASS% %_MAIN_ARGS% 1>&2
    ) else if %_VERBOSE%==1 ( echo Execute Scala main class %_MAIN_CLASS% ^(compiled from TASTy^) 1>&2
    )
    call %_RUN_CMD% !__RUN_OPTS! %_MAIN_CLASS% %_MAIN_ARGS%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Program execution failed ^(%_MAIN_CLASS%^) 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

:test
call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set __RUN_CMD=java.exe
set __RUN_OPTS=-classpath %_LIBS_CPATH%

set __TEST_MAIN_CLASS=hello.Tests

rem JUnit 4
rem set __JUNIT_MAIN_CLASS=org.junit.runner.JUnitCore
rem JUnit 5
set __JUNIT_MAIN_CLASS=org.junit.platform.console.ConsoleLauncher
set __JUNIT_MAIN_ARGS=--disable-banner --classpath %_CLASSES_DIR% --select-package=myexamples --include-classname=.*Tests

if %_DEBUG%==1 echo %_DEBUG_LABEL% %__RUN_CMD% %__RUN_OPTS% %__JUNIT_MAIN_CLASS% %__JUNIT_MAIN_ARGS% 1>&2
call %__RUN_CMD% %__RUN_OPTS% %__JUNIT_MAIN_CLASS% %__JUNIT_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Test execution failed ^(%__TEST_MAIN_CLASS%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TOTAL_TIME_END=%%i
    call :duration "%_TOTAL_TIME_START%" "!_TOTAL_TIME_END!"
    echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% _DURATION=!_DURATION! 1>&2
)
exit /b %_EXITCODE%
endlocal

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

set _TARGET_DIR=%_ROOT_DIR%target
set _CLASSES_DIR=%_TARGET_DIR%\classes
set _TASTY_CLASSES_DIR=%_TARGET_DIR%\tasty-classes
set _TEST_CLASSES_DIR=%_TARGET_DIR%\test-classes
set _TARGET_DOCS_DIR=%_TARGET_DIR%\docs
set _TARGET_LIB_DIR=%_TARGET_DIR%\lib
goto :eof

rem output parameters: _COMPILE_CMD_DEFAULT, _DOC_CMD_DEFAULT, _MAIN_CLASS_DEFAULT
:props
set _COMPILE_CMD_DEFAULT=dotc
set _DOC_CMD_DEFAULT=dotd
set _MAIN_CLASS_DEFAULT=Main
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
    if defined _doc_cmd set _DOC_CMD_DEFAULT=!_doc_cmd!
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
set _TASTY=0
set _TEST=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _COMPILE=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    rem option
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
        if not !_EXITCODE!== 0 goto :eof
    ) else if /i "%__ARG:~0,6%"=="-main:" (
        call :set_main "!__ARG:~6!"
        if not !_EXITCODE!== 0 goto :eof
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    rem subcommand
    set /a __N+=1
    if /i "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if /i "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if /i "%__ARG%"=="doc" ( set _DOC=1
    ) else if /i "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
    ) else if /i "%__ARG%"=="help" ( set _HELP=1
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
    echo %_DEBUG_LABEL% _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _COMPILE_CMD=%_COMPILE_CMD% _DOC=%_DOC% _RUN=%_RUN% 1>&2
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
echo     test             execute tests
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
call :rmdir "%_ROOT_DIR%out"
call :rmdir "%_TARGET_DIR%"
goto :eof

rem input parameter(s): %1=directory path
:rmdir
set __DIR=%~1
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory !__DIR:%_ROOT_DIR%=! 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
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
for %%i in (%_ROOT_DIR%src\main\java\*.java) do (
    set __JAVA_SOURCE_FILES=!__JAVA_SOURCE_FILES! %%i
)
set __SCALA_SOURCE_FILES=
for %%i in (%_ROOT_DIR%src\main\scala\*.scala) do (
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
) else if %_VERBOSE%==1 ( echo Compile Java source files to directory !_CLASSES_DIR:%_ROOT_DIR%=! 1>&2
)
%_JAVAC_CMD% %_JAVAC_OPTS% %__JAVA_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Compilation of main Java source files failed 1>&2
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
set __COMPILE_OPTS=%_COMPILE_OPTS% -classpath "%__PROJECT_JARS%%_CLASSES_DIR%" -d %_CLASSES_DIR%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_COMPILE_CMD% %__COMPILE_OPTS% %__SCALA_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile main Scala source files to directory !_CLASSES_DIR:%_ROOT_DIR%=! 1>&2
)
call %_COMPILE_CMD% %__COMPILE_OPTS% %__SCALA_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Compilation of main Scala source files failed 1>&2
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
    for %%f in (%_CLASSES_DIR%\*.tasty) do (
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
    if %_RUN%==0 if %_TEST%==0 echo No compilation needed ^(%__N% source files^)
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

rem input parameter: %1=include Dotty libs
rem output parameter: _LIBS_CPATH
:libs_cpath
set __INCLUDE_DOTTY=%~1

set __MAVEN_REPO=%USERPROFILE%\.m2\repository

for %%f in ("%~dp0\..") do set __PARENT_DIR=%%~sf
if not exist "%__PARENT_DIR%\lib" mkdir "%__PARENT_DIR%\lib"

set _LIBS_CPATH=

set __JUNIT_VERSION=4.12
set __JUNIT_NAME=junit-%__JUNIT_VERSION%.jar
set __JUNIT_PATH=junit\junit
set __JUNIT_FILE=
for /f %%f in ('where /r "%__MAVEN_REPO%\%__JUNIT_PATH%" %__JUNIT_NAME%') do (
    set __JUNIT_FILE=%%f
)
if not exist "%__JUNIT_FILE%" (
    echo %_ERROR_LABEL% Java archive file not found ^(%__JUNIT_NAME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_LIBS_CPATH=%_LIBS_CPATH%%__JUNIT_FILE%;"

set __JUNIT_INTF_VERSION=0.11
set __JUNIT_INTF_NAME=junit-interface-%__JUNIT_INTF_VERSION%.jar
set __JUNIT_INTF_PATH=com\novocode
set __JUNIT_INTF_FILE=
for /f %%f in ('where /r "%__MAVEN_REPO%\%__JUNIT_INTF_PATH%" %__JUNIT_INTF_NAME%') do (
    set __JUNIT_INTF_FILE=%%f
)
if not exist "%__JUNIT_INTF_FILE%" (
    echo %_ERROR_LABEL% Java archive file not found ^(%__JUNIT_INTF_NAME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_LIBS_CPATH=%_LIBS_CPATH%%__JUNIT_INTF_FILE%;"

set __SCALATEST_VERSION=3.1.0
set __SCALATEST_NAME=scalatest_2.13-%__SCALATEST_VERSION%.jar
set __SCALATEST_PATH=org\scalatest\scalatest_2.13
set __SCALATEST_FILE=
for /f %%f in ('where /r "%__MAVEN_REPO%\%__SCALATEST_PATH%" %__SCALATEST_NAME%') do (
    set __SCALATEST_FILE=%%f
)
if not exist "%__SCALATEST_FILE%" (
    echo %_ERROR_LABEL% Java archive file not found ^(%__SCALATEST_NAME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_LIBS_CPATH=%_LIBS_CPATH%%__SCALATEST_FILE%;"

rem https://mvnrepository.com/artifact/org.scalactic
set __SCALACTIC_VERSION=3.2.0-M2
set __SCALACTIC_NAME=scalactic_0.17-%__SCALACTIC_VERSION%.jar
set __SCALACTIC_PATH=org\scalactic\scalactic_0.17
set __SCALACTIC_FILE=
for /f %%f in ('where /r "%__MAVEN_REPO%\%__SCALACTIC_PATH%" %__SCALACTIC_NAME% 2^>^NUL') do (
    set __SCALACTIC_FILE=%%f
)
if not exist "%__SCALACTIC_FILE%" (
    set __SCALACTIC_URL=https://repo1.maven.org/maven2/org/scalactic/scalactic_0.17/%__SCALACTIC_VERSION%/%__SCALACTIC_NAME%
    set __SCALACTIC_FILE=%__PARENT_DIR%\lib\%__SCALACTIC_NAME%
    if not exist "!__SCALACTIC_FILE!" (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% powershell -c "Invoke-WebRequest -Uri !__SCALACTIC_URL! -Outfile !__SCALACTIC_FILE!" 1>&2
        ) else if %_VERBOSE%==1 ( echo Download file %__SPECS2_JUNIT_NAME% to directory !_TARGET_LIB_DIR:%_ROOT_DIR%=! 1>&2
        )
        powershell -c "$progressPreference='silentlyContinue';Invoke-WebRequest -Uri !__SCALACTIC_URL! -Outfile !__SCALACTIC_FILE!"
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to download file %__SCALACTIC_NAME% 1>&2
            set _EXITCODE=1
            goto :eof
        )
    )
)
set "_LIBS_CPATH=%_LIBS_CPATH%%__SCALACTIC_FILE%;"

rem https://github.com/etorreborre/specs2/releases
set __SPECS2_VERSION=4.8.1
set __SPECS2_NAME=specs2-core_2.13-%__SPECS2_VERSION%.jar
set __SPECS2_PATH=org\specs2
set __SPECS2_FILE=
for /f %%f in ('where /r "%__MAVEN_REPO%\%__SPECS2_PATH%" %__SPECS2_NAME% 2^>^NUL') do (
    set __SPECS2_FILE=%%f
)
if not exist "%__SPECS2_FILE%" (
    set __SPECS2_URL=https://repo1.maven.org/maven2/org/specs2/specs2-core_2.13/%__SPECS2_VERSION%/%__SPECS2_NAME%
    set __SPECS2_FILE=%__PARENT_DIR%\lib\%__SPECS2_NAME%
    if not exist "!__SPECS2_FILE!" (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% powershell -c "Invoke-WebRequest -Uri !__SPECS2_URL! -Outfile !__SPECS2_FILE!" 1>&2
        ) else if %_VERBOSE%==1 ( echo Download file %__SPECS2_JUNIT_NAME% to directory !_TARGET_LIB_DIR:%_ROOT_DIR%=! 1>&2
        )
        powershell -c "$progressPreference='silentlyContinue';Invoke-WebRequest -Uri !__SPECS2_URL! -Outfile !__SPECS2_FILE!"
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to download file %__SPECS2_NAME% 1>&2
            set _EXITCODE=1
            goto :eof
        )
    )
)
set "_LIBS_CPATH=%_LIBS_CPATH%%__SPECS2_FILE%;"

set __SPECS2_JUNIT_VERSION=4.8.1
set __SPECS2_JUNIT_NAME=specs2-junit_2.13-%__SPECS2_JUNIT_VERSION%.jar
set __SPECS2_JUNIT_PATH=org\specs2
set __SPECS2_JUNIT_FILE=
for /f %%f in ('where /r "%__MAVEN_REPO%\%__SPECS2_JUNIT_PATH%" %__SPECS2_JUNIT_NAME% 2^>^NUL') do (
    set __SPECS2_JUNIT_FILE=%%f
)
if not exist "%__SPECS2_JUNIT_FILE%" (
    set __SPECS2_JUNIT_URL=https://repo1.maven.org/maven2/org/specs2/specs2-junit_2.13/%__SPECS2_JUNIT_VERSION%/%__SPECS2_JUNIT_NAME%
    set __SPECS2_JUNIT_FILE=%__PARENT_DIR%\lib\%__SPECS2_JUNIT_NAME%
    if not exist "!__SPECS2_JUNIT_FILE!" (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% powershell -c "Invoke-WebRequest -Uri !__SPECS2_JUNIT_URL! -Outfile !__SPECS2_JUNIT_FILE!" 1>&2
        ) else if %_VERBOSE%==1 ( echo Download file %__SPECS2_JUNIT_NAME% to directory !_TARGET_LIB_DIR:%_ROOT_DIR%=! 1>&2
        )
        powershell -c "$progressPreference='silentlyContinue';Invoke-WebRequest -Uri !__SPECS2_JUNIT_URL! -Outfile !__SPECS2_JUNIT_FILE!"
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to download file %__SPECS2_JUNIT_NAME% 1>&2
            set _EXITCODE=1
            goto :eof
        )
    )
)
set "_LIBS_CPATH=%_LIBS_CPATH%%__SPECS2_JUNIT_FILE%;"
goto :eof

:doc
if not exist "%_TARGET_DOCS_DIR%" mkdir "%_TARGET_DOCS_DIR%" 1>NUL

set __TIMESTAMP_FILE=%_TARGET_DOCS_DIR%\.latest-build

set __SCALA_SOURCE_FILES=
for %%i in (%_ROOT_DIR%src\main\scala\*.scala) do (
    set __SCALA_SOURCE_FILES=!__SCALA_SOURCE_FILES! %%i
)

for %%i in ("%~dp0\.") do set __PROJECT=%%~ni
set __DOC_OPTS=-siteroot %_TARGET_DOCS_DIR% -project %__PROJECT% -project-version 0.1-SNAPSHOT

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_DOC_CMD% %__DOC_OPTS% %__SCALA_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Generate Dotty documentation into !_TARGET_DOCS_DIR:%_ROOT_DIR%=! 1>&2
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
set __RUN_OPTS=-classpath "%_LIBS_CPATH%%_CLASSES_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_RUN_CMD% %__RUN_OPTS% %_MAIN_CLASS% %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Scala main class %_MAIN_CLASS% 1>&2
)
call %_RUN_CMD% %__RUN_OPTS% %_MAIN_CLASS% %_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Execution failed ^(%_MAIN_CLASS%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_TASTY%==1 (
    if not exist "%_TASTY_CLASSES_DIR%" (
        echo Warning: TASTy output directory not found 1>&2
        set _EXITCODE=1
        goto :eof
    )
    set __RUN_OPTS=-classpath "%_LIBS_CPATH%%_TASTY_CLASSES_DIR%;%_CLASSES_DIR%"

    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_RUN_CMD% !__RUN_OPTS! %_MAIN_CLASS% %_MAIN_ARGS% 1>&2
    ) else if %_VERBOSE%==1 ( echo Execute Scala main class %_MAIN_CLASS% ^(compiled from TASTy^) 1>&2
    )
    call %_RUN_CMD% !__RUN_OPTS! %_MAIN_CLASS% %_MAIN_ARGS%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Execution failed ^(%_MAIN_CLASS%^) 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

:compile_test
if not exist "%_TEST_CLASSES_DIR%" mkdir "%_TEST_CLASSES_DIR%" 1>NUL

set __TIMESTAMP_FILE=%_TEST_CLASSES_DIR%\.latest-build

set __TEST_SOURCE_FILES=
for %%i in (%_ROOT_DIR%src\test\scala\*.scala) do (
    set __TEST_SOURCE_FILES=!__TEST_SOURCE_FILES! %%i
)

call :compile_required "%__TIMESTAMP_FILE%" "%__TEST_SOURCE_FILES%"
if %_COMPILE_REQUIRED%==0 goto :eof

call :libs_cpath 1
set __TEST_COMPILE_OPTS=%_COMPILE_OPTS% -classpath "%_LIBS_CPATH%%_CLASSES_DIR%;%_TEST_CLASSES_DIR%" -d %_TEST_CLASSES_DIR%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_COMPILE_CMD% %__TEST_COMPILE_OPTS% %__TEST_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile Scala test sources to !_TEST_CLASSES_DIR:%_ROOT_DIR%=! 1>&2
)
call %_COMPILE_CMD% %__TEST_COMPILE_OPTS% %__TEST_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Compilation of test Scala sources failed 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:test
call :compile_test
if not %_EXITCODE%==0 goto :eof

where /q java.exe
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Java executable not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __JAVA_CMD=java.exe

call :libs_cpath 1
set __TEST_RUN_OPTS=-classpath "%_LIBS_CPATH%%_CLASSES_DIR%;%_TEST_CLASSES_DIR%"

rem see https://github.com/junit-team/junit4/wiki/Getting-started
for %%i in (%_TEST_CLASSES_DIR%\*Test.class) do (
    set __MAIN_CLASS=%%~ni
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% java %__TEST_RUN_OPTS% org.junit.runner.JUnitCore !__MAIN_CLASS! 1>&2
    ) else if %_VERBOSE%==1 ( echo Execute test !__MAIN_CLASS! 1>&2
    )
    %__JAVA_CMD% %__TEST_RUN_OPTS% org.junit.runner.JUnitCore !__MAIN_CLASS!
    if not !ERRORLEVEL!==0 (
        set _EXITCODE=1
        goto :eof
    )
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

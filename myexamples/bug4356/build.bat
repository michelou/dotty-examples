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
goto end

rem ##########################################################################
rem ## Subroutines

rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
rem                    _CLASSES_DIR, _DOCS_DIR, _TASTY_CLASSES_DIR
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

set _CLASSES_DIR=%_ROOT_DIR%target\classes
set _TASTY_CLASSES_DIR=%_ROOT_DIR%target\classes-tasty
set _DOCS_DIR=%_ROOT_DIR%target\docs
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
set _VERBOSE=0
set __N=0
:args_loop
set __ARG=%~1
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
    echo %_DEBUG_LABEL% _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _COMPILE_CMD=%_COMPILE_CMD% _DOC=%_DOC% _RUN=%_RUN%
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

rem output parameter: _CLASSES_DIR
:classes_dir
if /i "%_COMPILE_CMD:~0,5%"=="scala" (
   set __DIR=%_ROOT_DIR%target\scala
   set __CMD=scalac.bat
) else if /i "%_COMPILE_CMD:~0,3%"=="dot" (
   set __DIR=%_ROOT_DIR%target\dotty
   set __CMD=dotc.bat
) else (
   echo Invalid compiler command %_COMPILE_CMD% 1>&2
   set _EXITCODE=1
   goto :eof
)
set __TARGET_DIR=
for /f %%i in ('dir /s /ad /b "%__DIR%*" 2^>NUL') do set __TARGET_DIR=%%i
if not defined __TARGET_DIR (
    set __CMD_VERSION=2.10
    for /f "delims=-" %%s in ('%__CMD% -version 2^>^&1') do (
        for %%j in (%%s) do set __VERSION=%%j
        for /f "tokens=1,2,* delims=." %%k in ("!__VERSION!") do set __CMD_VERSION=%%k.%%l
    )
    set __TARGET_DIR=%__DIR%-!__CMD_VERSION!
)
set _CLASSES_DIR=%__TARGET_DIR%\classes
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%" 1>NUL
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
call :classes_dir
if not %_EXITCODE%==0 goto :eof

set __TIMESTAMP_FILE=%_CLASSES_DIR%\.latest-build

set __JAVA_SOURCE_FILES=
for /f %%i in ('dir /s /b "%_ROOT_DIR%src\main\java\*.java" 2^>NUL') do (
    set __JAVA_SOURCE_FILES=!__JAVA_SOURCE_FILES! %%i
)
set __SCALA_SOURCE_FILES=
for /f %%i in ('dir /s /b "%_ROOT_DIR%src\main\scala\*.scala" 2^>NUL') do (
    set __SCALA_SOURCE_FILES=!__SCALA_SOURCE_FILES! %%i
)

call :compile_required "%__TIMESTAMP_FILE%" "%__JAVA_SOURCE_FILES% %__SCALA_SOURCE_FILES%"
if %_COMPILE_REQUIRED%==0 goto :eof

if %_COMPILE_TIME%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __COMPILE_TIME_START=%%i
)
call :libs_cpath

rem if not defined __JAVA_SOURCE_FILES goto compile_scala
rem see https://github.com/lampepfl/dotty/issues/4356
goto compile_scala
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
set __COMPILE_OPTS=%_COMPILE_OPTS% -classpath "%_LIBS_CPATH%%_CLASSES_DIR%" -d %_CLASSES_DIR%

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
    if %_DEBUG%==1 echo %_DEBUG_LABEL% !_TIMESTAMP! %%i
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
rem for /f %%i in ('where dotc.bat') do set __DOTTY_BIN_DIR=%%~dpi
rem for /f %%f in ("!__DOTTY_BIN_DIR!..") do set __DOTTY_HOME=%%~sf
rem for /f %%i in ('dir /b "!__DOTTY_HOME!\lib\dotty*.jar"') do (
rem     set _LIBS_CPATH=!_LIBS_CPATH!!__DOTTY_HOME!\lib\%%i;
rem )
if exist "%USERPROFILE%\.m2\repository\" (
    for /f %%i in ('where /r "%USERPROFILE%\.m2\repository" apiguardian*1.1.0.jar junit-jupiter*5.5.2.jar') do (
	    set _LIBS_CPATH=!_LIBS_CPATH!%%i;
	)
)
if exist "%_ROOT_DIR%\lib\" (
    for /f %%i in ('dir /b "%_ROOT_DIR%\lib\*.jar" 2^>NUL') do (
        set _LIBS_CPATH=!_LIBS_CPATH!%_ROOT_DIR%\lib\%%i;
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
set __DOC_OPTS=-siteroot %_DOCS_DIR% -project %__PROJECT% -project-version 0.1-SNAPSHOT

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_DOC_CMD% %__DOC_OPTS% %__SCALA_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Generate Dotty documentation into !_DOCS_DIR:%_ROOT_DIR%=! 1>&2
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
    echo %_ERROR_LABEL% Main class '%_MAIN_CLASS%' not found ^(!__MAIN_CLASS_FILE:%_ROOT_DIR%=!^) 1>&2
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
        echo %_ERROR_LABEL% Execution failed ^(%_MAIN_CLASS%^) 1>&2
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

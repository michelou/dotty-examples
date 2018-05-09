@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _EXITCODE=0

set _BASENAME=%~n0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

call :props
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    call :compile
    if not !_EXITCODE!==0 goto end
)
if %_RUN%==1 (
    call :run
    if not !_EXITCODE!==0 goto end
)
goto end

rem ##########################################################################
rem ## Subroutines

rem output parameters: _COMPILE_CMD_DEFAULT, _MAIN_CLASS_DEFAULT
:props
set _COMPILE_CMD_DEFAULT=dotc
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
set _COMPILE_OPTS=
set _COMPILE_TIME=0
set _MAIN_CLASS=%_MAIN_CLASS_DEFAULT%
set _MAIN_ARGS=%_MAIN_ARGS_DEFAULT%
set _RUN=0
set _RUN_CMD=dot
set __N=0
:args_loop
set __ARG=%~1
if not defined __ARG (
    if !__N!==0 call :help
    goto args_done
) else if not "%__ARG:~0,1%"=="-" (
    set /a __N=!__N!+1
)
if /i "%__ARG%"=="clean" ( set _CLEAN=1
) else if /i "%__ARG%"=="compile" ( set _COMPILE=1
) else if /i "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
) else if /i "%__ARG%"=="help" ( call :help & goto :eof
) else if /i "%__ARG%"=="-debug" ( set _DEBUG=1
) else if /i "%__ARG%"=="-deprecation" ( set _COMPILE_OPTS=!_COMPILE_OPTS! -deprecation
) else if /i "%__ARG%"=="-explain" ( set _COMPILE_OPTS=!_COMPILE_OPTS! -explain
) else if /i "%__ARG%"=="-timer" ( set _COMPILE_TIME=1
) else if /i "%__ARG:~0,10%"=="-compiler:" (
    call :set_compiler "!__ARG:~10!"
    if not !_EXITCODE!== 0 goto :eof
) else if /i "%__ARG:~0,6%"=="-main:" (
    call :set_main "!__ARG:~6!"
    if not !_EXITCODE!== 0 goto :eof
) else (
    echo %_BASENAME%: Unknown subcommand %__ARG%
    set _EXITCODE=1
    goto :eof
)
shift
goto :args_loop
:args_done
if %_DEBUG%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TOTAL_TIME_START=%%i
    echo [%_BASENAME%] _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _COMPILE_CMD=%_COMPILE_CMD% _RUN=%_RUN%
)
goto :eof

:help
echo Usage: build { options ^| subcommands }
echo   Options:
echo     -debug           show commands executed by this script
echo     -deprecation     set compiler option -deprecation
echo     -explain         set compiler option -explain
echo     -compiler:^<name^> select compiler ^(scala^|scalac^|dotc^|dotty^), default:%_COMPILE_CMD_DEFAULT%
echo     -main:^<name^>     define main class name
echo     -timer           display compile time
echo   Subcommands:
echo     clean            delete generated class files
echo     compile          compile source files ^(Java and Scala^)
echo     help             display this help message
echo     run              execute main class
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
    set _RUN_CMD=scala.bat
) else if /i "%__VALUE%"=="scalac" (
    set _COMPILE_CMD=scalac.bat
    set _RUN_CMD=scala.bat
) else if /i "%__VALUE%"=="dotc" (
    set _COMPILE_CMD=dotc.bat
    set _RUN_CMD=dot.bat
) else if /i "%__VALUE%"=="dotty" (
    set _COMPILE_CMD=dotc.bat
    set _RUN_CMD=dot.bat
) else (
    echo Unknown target %__VALUE% ^(scala^|scalac^|dotc^|dotty^)
    set _EXITCODE=1
    goto :eof
)
goto :eof

rem output parameter: _MAIN_CLASS
:set_main
set __ARG=%~1
set __VALID=0
for /f %%i in ('powershell -C "$s='%__ARG%'; if($s -match '^[\w$]+(\.[\w$]+)*$'){1}else{0}"') do set __VALID=%%i
rem if %_DEBUG%==1 echo [%_BASENAME%] __ARG=%__ARG% __VALID=%__VALID%
if %__VALID%==0 (
    echo Invalid class name passed to option "-main" ^(%__ARG%^)
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
   echo Invalid compiler command %_COMPILE_CMD%
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
if %_DEBUG%==1 echo [%_BASENAME%] forfiles /s /p %_ROOT_DIR% /m target /c "cmd /c echo @path" 2^>NUL
for /f %%i in ('forfiles /s /p %_ROOT_DIR% /m target /c "cmd /c if @isdir==TRUE echo @path" 2^>NUL') do (
    rmdir /s /q %%i
    if not !ERRORLEVEL!==0 (
        if %_DEBUG%==1 echo [%_BASENAME%] Failed to clean directory %%i
        set _EXITCODE=1
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
for /f %%i in ('where dotc.bat') do set _DOTTY_BIN_DIR=%%~dpi
for /f %%f in ("%_DOTTY_BIN_DIR%..") do set _DOTTY_HOME=%%~sf
set _DOTTY_LIB_DIR=%_DOTTY_HOME%\lib
set _DOTTY_JARS=
for /f %%i in ('dir /b "%_DOTTY_LIB_DIR%\dotty*.jar"') do (
    set _DOTTY_JARS=!_DOTTY_JARS!%_DOTTY_LIB_DIR%\%%i;
)
set __PROJECT_JARS=
if exist "%_ROOT_DIR%\lib\" (
    for /f %%i in ('dir /b "%_ROOT_DIR%\lib\*.jar"') do (
        set __PROJECT_JARS=!__PROJECT_JARS!%_ROOT_DIR%\lib\%%i;
    )
)

if not defined __JAVA_SOURCE_FILES goto compile_scala
set _JAVAC_CMD=javac.exe
set _JAVAC_OPTS=-classpath "%_DOTTY_JARS%%__PROJECT_JARS%%_CLASSES_DIR%" -d %_CLASSES_DIR%

if %_DEBUG%==1 echo [%_BASENAME%] %_JAVAC_CMD% %_JAVAC_OPTS% %__JAVA_SOURCE_FILES%
%_JAVAC_CMD% %_JAVAC_OPTS% %__JAVA_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] Java compilation failed
    set _EXITCODE=1
    goto :eof
)
:compile_scala
where /q %_COMPILE_CMD%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] %_COMPILE_CMD% compiler not found
    set _EXITCODE=1
    goto :eof
)
set __COMPILE_OPTS=%_COMPILE_OPTS% -classpath "%__PROJECT_JARS%%_CLASSES_DIR%" -d %_CLASSES_DIR%

if %_DEBUG%==1 echo [%_BASENAME%] %_COMPILE_CMD% %__COMPILE_OPTS% %__SCALA_SOURCE_FILES%
call %_COMPILE_CMD% %__COMPILE_OPTS% %__SCALA_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] Scala compilation failed
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
    if %_DEBUG%==1 echo [%_BASENAME%] !_TIMESTAMP! %%i
    call :newer !_TIMESTAMP! !__SOURCE_TIMESTAMP!
    if !_NEWER!==1 set __SOURCE_TIMESTAMP=!_TIMESTAMP!
    set /a __N=!__N!+1
)
if exist "%__TIMESTAMP_FILE%" ( set /p __CLASS_TIMESTAMP=<%__TIMESTAMP_FILE%
) else ( set __CLASS_TIMESTAMP=00000000000000
)
if %_DEBUG%==1 echo [%_BASENAME%] %__CLASS_TIMESTAMP% %__TIMESTAMP_FILE%

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

:run
set __MAIN_CLASS_FILE=%_CLASSES_DIR%\%_MAIN_CLASS:.=\%.class
if not exist "%__MAIN_CLASS_FILE%" (
    echo Main class '%_MAIN_CLASS%' not found ^(%__MAIN_CLASS_FILE%^)
    set _EXITCODE=1
    goto :eof
)
set __PROJECT_JARS=
if exist "%_ROOT_DIR%\lib\" (
    for /f %%i in ('dir /b "%_ROOT_DIR%\lib\*.jar"') do (
        set __PROJECT_JARS=!__PROJECT_JARS!%_ROOT_DIR%\lib\%%i;
    )
)
set __RUN_OPTS=-classpath "%__PROJECT_JARS%%_CLASSES_DIR%"

if %_DEBUG%==1 echo [%_BASENAME%] %_RUN_CMD% %__RUN_OPTS% %_MAIN_CLASS% %_MAIN_ARGS%
call %_RUN_CMD% %__RUN_OPTS% %_MAIN_CLASS% %_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    if %_DEBUG%==1 echo [%_BASENAME%] Execution failed
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
    echo [%_BASENAME%] _EXITCODE=%_EXITCODE% _DURATION=!_DURATION!
)
exit /b %_EXITCODE%
endlocal

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
if %_TEST%==1 (
    call :test
    if not !_EXITCODE!==0 goto end
)
if %_PROTOC%==1 (
    call :protoc
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
@rem                    _CLASSES_DIR, _TARGET_DIR
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"
set _TIMER=0

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_ROOT_DIR=%~dp0"
set "_CLI_SOURCE_DIR=%_ROOT_DIR%cli\src\main\scala"
set "_EXAMPLE_SOURCE_DIR=%_ROOT_DIR%example\src\main\scala"
set "_CLI_TARGET_DIR=%_ROOT_DIR%cli\target"
set "_EXAMPLE_TARGET_DIR=%_ROOT_DIR%example\target"

set _MAIN_CLASS=tool.Main

if not exist "%SCALA_HOME%\bin\scalac.bat" (
    echo %_ERROR_LABEL% Scala installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SCALA_CMD=%SCALA_HOME%\bin\scala.bat"
set "_SCALAC_CMD=%SCALA_HOME%\bin\scalac.bat"

if not exist "%LOCALAPPDATA%\Coursier\data\bin\metac.bat" (
    echo %_ERROR_LABEL% metac executable not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_METAC_CMD=%LOCALAPPDATA%\Coursier\data\bin\metac.bat"

if not exist "%LOCALAPPDATA%\Coursier\data\bin\metap.bat" (
    echo %_ERROR_LABEL% metap executable not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_METAP_CMD=%LOCALAPPDATA%\Coursier\data\bin\metap.bat"

set _PROTOC_CMD=
if exist "%PROTOC_HOME%\bin\protoc.exe" (
    set "_PROTOC_CMD=%PROTOC_HOME%\bin\protoc.exe"
)
set _PROTO_PATH=
for %%f in ("%~dp0.") do set "_PROTO_PATH=%%~dpf\protos"
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
:args
set _CLEAN=0
set _COMPILE=0
set _FORMAT=-compact
set _HELP=0
set _PROTOC=0
set _RUN=0
set _TEST=0
set _TIMER=0
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
    ) else if "%__ARG%"=="-detailed" ( set _FORMAT=-detailed
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-proto" ( set _FORMAT=-proto
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="protoc" ( set _COMPILE=1& set _PROTOC=1
    ) else if "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
    ) else if "%__ARG%"=="test" ( set _COMPILE=1& set _TEST=1
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
if %_PROTOC%==1 (
    if not defined _PROTOC_CMD (
        echo %_WARNING_LABEL% protoc subcommand disabled 1>&2
        set _PROTOC=0
    )
    if not exist "%_PROTO_PATH%\" (
        echo %_WARNING_LABEL% Prototype directory not found 1>&2
        set _PROTOC=0
    )
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _PROTOC=%_PROTOC% _RUN=%_RUN% _TEST=%_TEST% 1>&2
    echo %_DEBUG_LABEL% Variables  : "JAVA_HOME=%JAVA_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "SCALA_HOME=%SCALA_HOME%" 1>&2
    if defined _PROTOC_CMD echo %_DEBUG_LABEL% Variables  : "PROTOC_HOME=%PROTOC_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : _MAIN_CLASS=%_MAIN_CLASS% 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
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
echo     %__BEG_O%-debug%__END%      print commands executed by this script
echo     %__BEG_O%-timer%__END%      print total execution time
echo     %__BEG_O%-verbose%__END%    print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%       delete generated files
echo     %__BEG_O%compile%__END%     compile Scala source files
echo     %__BEG_O%help%__END%        print this help message
echo     %__BEG_O%run%__END%         execute main %__BEG_O%%_MAIN_CLASS%%__END%
echo     %__BEG_O%test%__END%        execute unit tests
goto :eof

:clean
call :rmdir "%_CLI_TARGET_DIR%"
call :rmdir "%_EXAMPLE_TARGET_DIR%"
goto :eof

@rem input parameter(s): %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
call :compile_example
if not %_EXITCODE%==0 goto :eof

call :compile_cli
if not %_EXITCODE%==0 goto :eof

goto :eof

:compile_example
set "__CLASSES_DIR=%_EXAMPLE_TARGET_DIR%\classes"
if not exist "%__CLASSES_DIR%" mkdir "%__CLASSES_DIR%"

set "__TIMESTAMP_FILE=%_EXAMPLE_TARGET_DIR%\.latest-build"

call :action_required "%__TIMESTAMP_FILE%" "%_EXAMPLE_SOURCE_DIR%\*.scala"
if %_ACTION_REQUIRED%==0 goto :eof

set __SOURCE_FILES=
set __N=0
for /f "delims=" %%f in ('dir /s /b "%_EXAMPLE_SOURCE_DIR%\*.scala" 2^>NUL') do (
    set __SOURCE_FILES=!__SOURCE_FILES! "%%f"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Scala source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% Scala source file
) else ( set __N_FILES=%__N% Scala source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_METAC_CMD%" -d "%__CLASSES_DIR%" %__SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Generate SemanticDB data for %__N_FILES% into directory "!__CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_METAC_CMD%" -d "%__CLASSES_DIR%" %__SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    echo %_DEBUG_LABEL% Failed to generate SemanticDB data for  %__N_FILES% into directory "!__CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
echo. > "%__TIMESTAMP_FILE%"
goto :eof

:compile_cli
set "__CLASSES_DIR=%_CLI_TARGET_DIR%\classes"
if not exist "%__CLASSES_DIR%" mkdir "%__CLASSES_DIR%"

set "__TIMESTAMP_FILE=%_CLI_TARGET_DIR%\.latest-build"

call :action_required "%__TIMESTAMP_FILE%" "%_CLI_SOURCE_DIR%\*.scala"
if %_ACTION_REQUIRED%==0 goto :eof

call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set "__OPTS_FILE=%_CLI_TARGET_DIR%\scalac_opts.txt"
set "__CPATH=%_LIBS_CPATH%%__CLASSES_DIR%"
echo -deprecation -classpath "%__CPATH:\=\\%" -d "%__CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

set "__SOURCES_FILE=%_CLI_TARGET_DIR%\scalac_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f "delims=" %%f in ('dir /s /b "%_CLI_SOURCE_DIR%\*.scala" 2^>NUL') do (
    echo %%f >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Scala source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% Scala source file
) else ( set __N_FILES=%__N% Scala source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directory "!__CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directory "!_CLI_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
echo. > "%__TIMESTAMP_FILE%"
goto :eof

:run
call :libs_cpath
if not %_EXITCODE%==0 goto :eof

set "__CPATH=%_LIBS_CPATH%%_CLI_TARGET_DIR%\classes"

if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_SCALA_CMD%" -cp "%__CPATH%" %_MAIN_CLASS% "%_EXAMPLE_TARGET_DIR%\classes" 1>&2
) else if %_VERBOSE%==1 ( echo Execute main program "%_MAIN_CLASS%" 1>&2
)
call "%_SCALA_CMD%" -cp "%__CPATH%" %_MAIN_CLASS% "%_EXAMPLE_TARGET_DIR%\classes"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute main program "%_MAIN_CLASS%" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:test
set __METAP_OPTS=%_FORMAT%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_METAP_CMD%" %__METAP_OPTS% "%_EXAMPLE_TARGET_DIR%\classes" 1>&2
) else if %_VERBOSE%==1 ( echo Pretty print contents of semanticdb files 1>&2
)
call "%_METAP_CMD%" %__METAP_OPTS% "%_EXAMPLE_TARGET_DIR%\classes"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to pretty print contents of semanticdb files 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_PROTOC%==1 (
    call :protoc
    if not !_EXITCODE!==0 goto :eof
)
goto :eof

:protoc
set __SEMANTICDB_FILES=
set __N=0
for /f "delims=" %%f in ('dir /a-d /b /s "%_EXAMPLE_TARGET_DIR%\classes\*.semanticdb"') do (
    set __SEMANTICDB_FILES=!__SEMANTICDB_FILES! "%%f"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No SemanticDB file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% SemanticDB file
) else ( set __N_FILES=%__N% SemanticDB files
)
for %%i in (java kotlin) do (
    set __LANG=%%i
    set "__OUTPUT_DIR=%_EXAMPLE_TARGET_DIR%\!__LANG!"
    if not exist "!__OUTPUT_DIR!" mkdir "!__OUTPUT_DIR!"

    set __PROTOC_OPTS="--proto_path=%_PROTO_PATH%" semanticdb.proto "--!__LANG!_out=!__OUTPUT_DIR!"

    for %%f in (%__SEMANTICDB_FILES%) do (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_PROTOC_CMD%" !__PROTOC_OPTS! ^< %%f 1>&2
        ) else if %_VERBOSE%==1 ( echo Print protobuf 1>&2
        )
        call "%_PROTOC_CMD%" !__PROTOC_OPTS! < %%f
        if not !ERRORLEVEL!==0 (
           set _EXITCODE=1
           goto :eof
        )
    )
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

@rem input parameter: %1=flag to add Scala 3 libs
@rem output parameter: _LIBS_CPATH
:libs_cpath
set __ADD_SCALA3_LIBS=%~1

for /f "delims=" %%f in ("%~dp0\.") do set "__BATCH_FILE=%%~dpfcpath.bat"
if not exist "%__BATCH_FILE%" (
    echo %_ERROR_LABEL% Batch file "%__BATCH_FILE%" not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%__BATCH_FILE%" %_DEBUG% 1>&2
call "%__BATCH_FILE%" %_DEBUG%
set "_LIBS_CPATH=%_CPATH%"

if defined __ADD_SCALA3_LIBS (
    if not defined SCALA3_HOME (
        echo %_ERROR_LABEL% Variable SCALA3_HOME not defined 1>&2
        set _EXITCODE=1
        goto :eof
    )
    for /f "delims=" %%f in ("%SCALA3_HOME%\lib\*.jar") do (
        set "_LIBS_CPATH=!_LIBS_CPATH!%%f;"
    )
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
    echo Total execution time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

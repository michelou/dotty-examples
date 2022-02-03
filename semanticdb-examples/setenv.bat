@echo off
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

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)
set _COURSIER_PATH=
set _PROTOC_PATH=

call :kotlin
if not %_EXITCODE%==0 goto end

call :protoc
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
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
@rem output parameter: _HELP, _VERBOSE
:args
set _HELP=0
set _VERBOSE=0

:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto args_loop
:args_done
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options  : _HELP=%_HELP% _VERBOSE=%_VERBOSE% 1>&2
)
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
echo     %__BEG_O%-debug%__END%      show commands executed by this script
echo     %__BEG_O%-verbose%__END%    display environment settings
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        display this help message
goto :eof

@rem output parameter: _KOTLIN_HOME
:kotlin
set _KOTLIN_HOME=

set __KOTLINC_CMD=
for /f %%f in ('where kotlinc.bat 2^>NUL') do set "__KOTLINC_CMD=%%f"
@rem We need to differentiate kotlinc-jvm from kotlinc-native
if defined __KOTLINC_CMD (
    for /f "tokens=1,2,*" %%i in ('%__KOTLINC_CMD% -version 2^>^&1') do (
        if not "%%j"=="kotlinc-jvm" set __KOTLINC_CMD=
    )
)
if defined __KOTLINC_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Kotlin executable found in PATH 1>&2
    for %%i in ("%__KOTLINC_CMD%") do set "__KOTLINC_BIN_DIR=%%~dpi"
    for %%f in ("!__KOTLINC_BIN_DIR!\.") do set "_KOTLIN_HOME=%%~dpf"
    goto :eof
) else if defined KOTLIN_HOME (
    set "_KOTLIN_HOME=%KOTLIN_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable KOTLIN_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\kotlinc*" 2^>NUL') do set "_KOTLIN_HOME=!__PATH!\%%f"
    if not defined _KOTLIN_HOME (
        set "__PATH=%ProgramFiles%"
        for /f %%f in ('dir /ad /b "!__PATH!\kotlinc*" 2^>NUL') do set "_KOTLIN_HOME=!__PATH!\%%f"
    )
)
if not exist "%_KOTLIN_HOME%\bin\kotlinc.bat" (
    echo kotlinc not found in Kotlin installation directory ^(%_KOTLIN_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _PROTOC_HOME
:protoc
set _PROTOC_HOME=

set __PROTOC_CMD=
for /f %%f in ('where protoc.exe 2^>NUL') do set "__PROTOC_CMD=%%f"
if defined __PROTOC_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Protoc executable found in PATH 1>&2
    for %%i in ("%__PROTOC_CMD%") do set "_PROTOC_HOME=%%~dpi"
    goto :eof
) else if defined PROTOC_HOME (
    set "_PROTOC_HOME=%PROTOC_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable PROTOC_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\protoc\" ( set "_PROTOC_HOME=!__PATH!\protoc"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\protoc-3*" 2^>NUL') do set "_PROTOC_HOME=!__PATH!\%%f"
        if not defined _PROTOC_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\protoc-3*" 2^>NUL') do set "_PROTOC_HOME=!__PATH!\%%f"
        )
    )
    if defined _PROTOC_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Protoc installation directory "!_PROTOC_HOME!" 1>&2
    )
)
if not exist "%_PROTOC_HOME%\bin\protoc.exe" (
    echo %_ERROR_LABEL% Protoc executable not found ^(%_PROTOC_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:print_env
set __VERBOSE=%1
set __VERSIONS_LINE1=
set __VERSIONS_LINE2=
set __VERSIONS_LINE3=
set __WHERE_ARGS=
where /q "%JAVA_HOME%\bin:java.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('"%JAVA_HOME%\bin\java.exe" -version 2^>^&1 ^| findstr version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% java %%~k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%JAVA_HOME%\bin:java.exe"
)
where /q "%JAVA_HOME%\bin:javac.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%JAVA_HOME%\bin\javac.exe" -version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% javac %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%JAVA_HOME%\bin:javac.exe"
)
where /q "%SCALA3_HOME%\bin:scalac.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,4,*" %%i in ('"%SCALA3_HOME%\bin\scalac.bat" -version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% scalac %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%SCALA3_HOME%\bin:scalac.bat"
)
goto xxx
set "__METAC_CMD=%LOCALAPPDATA%\Coursier\data\bin\metac.bat"
if exist "%__METAC_CMD%" (
    for /f "tokens=1-3,4,*" %%i in ('"%__METAC_CMD%" -version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% metac %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%__METAC_CMD:bin\=bin:%"
)
echo 11111111111111
set "__METAP_CMD=%LOCALAPPDATA%\Coursier\data\bin\metap.bat"
if exist "%__METAP_CMD%" (
    for /f "tokens=1,2,*" %%i in ('"%__METAP_CMD%" -version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% metap %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%__METAP_CMD:bin\=bin:%"
)
:xxx
where /q "%PROTOC_HOME%\bin:protoc.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,*" %%i in ('"%PROTOC_HOME%\bin\protoc.exe" --version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% protoc %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%PROTOC_HOME%\bin:protoc.exe"
)
set "__COURSIER_CMD=%LOCALAPPDATA%\Coursier\data\bin\cs.bat"
if exist "%__COURSIER_CMD%" (
    for /f %%i in ('"%__COURSIER_CMD%" --version 2^>^&1') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% cs %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%__COURSIER_CMD:bin\=bin:%"
)
where /q "%KOTLIN_HOME%\bin:kotlinc.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('"%KOTLIN_HOME%\bin\kotlinc.bat" -version 2^>^&1 ^| findstr kotlinc') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% kotlinc %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%KOTLIN_HOME%\bin:kotlinc.bat"
)
where /q "%GIT_HOME%\bin:git.exe"
if %ERRORLEVEL%==0 (
   for /f "tokens=1,2,*" %%i in ('"%GIT_HOME%\bin\git.exe" --version') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% git %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:git.exe"
)
where /q "%GIT_HOME%\usr\bin:diff.exe"
if %ERRORLEVEL%==0 (
   for /f "tokens=1-3,*" %%i in ('"%GIT_HOME%\usr\bin\diff.exe" --version ^| findstr diff') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% diff %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\usr\bin:diff.exe"
)
where /q "%GIT_HOME%\bin:bash.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,4,*" %%i in ('"%GIT_HOME%\bin\bash.exe" --version ^| findstr bash') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% bash %%l"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:bash.exe"
)
echo Tool versions:
echo   %__VERSIONS_LINE1%
echo   %__VERSIONS_LINE2%
echo   %__VERSIONS_LINE3%
if %__VERBOSE%==1 (
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do echo    %%p 1>&2
    echo Environment variables: 1>&2
    if defined COURSIER_HOME echo    "COURSIER_HOME=%COURSIER_HOME%" 1>&2
    if defined GIT_HOME echo    "GIT_HOME=%GIT_HOME%" 1>&2
    if defined JAVA_HOME echo    "JAVA_HOME=%JAVA_HOME%" 1>&2
    if defined KOTLIN_HOME echo    "KOTLIN_HOME=%KOTLIN_HOME%" 1>&2
    if defined PROTOC_HOME echo    "PROTOC_HOME=%PROTOC_HOME%" 1>&2
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if %_EXITCODE%==0 (
        if not defined COURSIER_HOME set "COURSIER_HOME=%_COURSIER_HOME%"
        if not defined GIT_HOME set "GIT_HOME=%_GIT_HOME%"
        if not defined JAVA_HOME set "JAVA_HOME=%_JAVA_HOME%"
        if not defined KOTLIN_HOME set "KOTLIN_HOME=%_KOTLIN_HOME%"
        if not defined PROTOC_HOME set "PROTOC_HOME=%_PROTOC_HOME%"
        set "PATH=%PATH%%_GIT_PATH%;%~dp0bin"
        call :print_env %_VERBOSE%
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)

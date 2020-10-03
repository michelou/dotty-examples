@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
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
if %_DOWNLOAD_ONLY%==1 (
    call :download
    if not !_EXITCODE!==0 goto end
    goto end
)

call :backup_dotty
if not %_EXITCODE%==0 goto end

if %_ACTIVATE_NIGHTLY%==1 (
    call :download
    if not !_EXITCODE!==0 goto end

    @rem if defined _NIGHTLY_UPTODATE goto end

    call :backup_nightly
    if not !_EXITCODE!==0 goto end

    call :activate_nightly
    if not !_EXITCODE!==0 goto end
) else (
    call :activate_dotty
    if not !_EXITCODE!==0 goto end
)

goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0
for %%f in ("%~dp0\.") do set "_ROOT_DIR=%%~dpf"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_PS1_FILE=%_ROOT_DIR%bin\%_BASENAME%.ps1"
if not exist "%_PS1_FILE%" (
    echo %_ERROR_LABEL% PS1 file %_PS1_FILE% not found 1>&2
    set _EXITCODE=1
    goto :eof
)

set "_OUTPUT_DIR=%_ROOT_DIR%out\nightly-jars"
if not exist "%_OUTPUT_DIR%" mkdir "%_OUTPUT_DIR%" 1>NUL

if not exist "%DOTTY_HOME%\bin\dotc.bat" (
    echo %_ERROR_LABEL% Scala 3 installation not found ^(run setenv.bat^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if not exist "%DOTTY_HOME%\lib\" (
    echo %_ERROR_LABEL% Dotty library directory not found ^(run setenv.bat^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if not exist "%DOTTY_HOME%\VERSION" (
    echo %_ERROR_LABEL%: Dotty version file not found ^(run setenv.bat^) 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims== tokens=1,*" %%i in (%DOTTY_HOME%\VERSION) do (
    set __NAME=%%i
    set __VALUE=%%j
    if not "!__NAME:version=!"=="!__NAME!" set _DOTTY_VERSION=!__VALUE!
)
set _NIGHTLY_VERSION=unknown
if exist "%DOTTY_HOME%\VERSION-NIGHTLY" (
    set /p _NIGHTLY_VERSION=< "%DOTTY_HOME%\VERSION-NIGHTLY"
    if not exist "%DOTTY_HOME%\lib\!_NIGHTLY_VERSION!\" (
        del "%DOTTY_HOME%\VERSION-NIGHTLY" 1>NUL
        set _NIGHTLY_VERSION=unknown
    )
)
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
@rem output parameter: _HELP, _TIMER, _VERBOSE
:args
set _ACTIVATE_NIGHTLY=0
set _DOWNLOAD_ONLY=1
set _HELP=0
set _TIMER=0
set _VERBOSE=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto :args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="download" ( set _DOWNLOAD_ONLY=1
    ) else if "%__ARG%"=="activate" (
        set _DOWNLOAD_ONLY=0
        set _ACTIVATE_NIGHTLY=1
    ) else if "%__ARG%"=="reset" (
        set _DOWNLOAD_ONLY=0
        set _ACTIVATE_NIGHTLY=0
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto :args_done
    )
)
shift
goto args_loop
:args_done
if %_DEBUG%==1 ( set _STDOUT_REDIRECT=1^>CON
) else ( set _STDOUT_REDIRECT=1^>NUL
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _DOWNLOAD_ONLY=%_DOWNLOAD_ONLY% _ACTIVATE_NIGHTLY=%_ACTIVATE_NIGHTLY% _NIGHTLY_VERSION=%_NIGHTLY_VERSION% 1>&2
    echo %_DEBUG_LABEL% Variables  : DOTTY_HOME="%DOTTY_HOME%" 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
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
echo     %__BEG_O%-timer%__END%      display total elapsed time
echo     %__BEG_O%-verbose%__END%    display download progress
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%activate%__END%    activate the nightly build library files
echo     %__BEG_O%download%__END%    download nighty build files and quit (default)
echo     %__BEG_O%help%__END%        display this help message
echo     %__BEG_O%reset%__END%       restore the default Dotty library files
goto :eof

@rem input parameter: 1=file path
@rem output parameter: _FILE_SIZE
:file_size
set __FILE=%~1

set __PS1_SCRIPT= ^
$size=(Get-Item '%__FILE%').length; ^
If ($size -ge 1073741824) { $n = $size / 1073741824; $unit='Gb' } ^
Elseif ($size -ge 1048576) {  $n = $size / 1048576; $unit='Mb' } ^
Else { $n = $size/1024; $unit='Kb' } ^
Write-Host ([math]::Round($n,1))" "$unit

set _FILE_SIZE=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -C "..." 1>&2
for /f "delims=" %%i in ('powershell -C "%__PS1_SCRIPT%"') do set _FILE_SIZE=%%i
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Execution of ps1 cmdlet failed 1>&2
    set _EXITCODE=1
    goto :eof
)
set _FILE_SIZE=%_FILE_SIZE:,=.%
goto :eof

@rem output parameter: _NIGHTLY_VERSION, _NIGHTLY_UPTODATE
:download
@rem set _NIGHTLY_UPTODATE=

if not exist "%_OUTPUT_DIR%\*.jar" goto :download_check

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% del /f /q "%_OUTPUT_DIR%\*.jar" 1>&2
) else if %_VERBOSE%==1 ( echo Delete Java archive files in directory "!_OUTPUT_DIR:%_ROOT_DIR%=!" 1>&2
)
del /f /q "%_OUTPUT_DIR%\*.jar" 1>NUL 2>&1
if not !ERRORLEVEL!==0 (
    set _EXITCODE=1
    goto :eof
)

:download_check
set __N=0
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% powershell -ExecutionPolicy ByPass -File "%_PS1_FILE%" %_DEBUG% 1>&2
) else if %_VERBOSE%== 1 ( echo Check for nightly files on Maven repository 1>&2
)
for /f "delims=" %%i in ('powershell -ExecutionPolicy ByPass -File "%_PS1_FILE%" %_DEBUG%') do (
    @rem set __URL=http://central.maven.org/maven2/%%i
    set __URL=https://repo.maven.apache.org/maven2/%%i
    for %%f in ("%%i") do set "__FILE_BASENAME=%%~nxf"
    if defined _NIGHTLY_VERSION if not "!__FILE_BASENAME:%_NIGHTLY_VERSION%=!"=="!__FILE_BASENAME!" (
        echo Nightly build files already present locally
        echo ^(directory %DOTTY_HOME%\lib\%_NIGHTLY_VERSION%^)
        goto :eof
    )
    if %_VERBOSE%==1 <NUL set /p=Downloading file !__FILE_BASENAME! ... 
    set "__JAR_FILE=%_OUTPUT_DIR%\!__FILE_BASENAME!"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -c "Invoke-WebRequest -Uri !__URL! -Outfile !__JAR_FILE!" 1>&2
    powershell -c "$progressPreference='silentlyContinue';Invoke-WebRequest -Uri !__URL! -Outfile '!__JAR_FILE!'"
    if not !ERRORLEVEL!==0 (
        echo.
        echo %_ERROR_LABEL% Failed to download file "!__JAR_FILE!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
    if %_VERBOSE%==1 (
        call :file_size "!__JAR_FILE!"
        echo !_FILE_SIZE!
    )
    set /a __N+=1
)
echo Finished to download %__N% files to directory %_OUTPUT_DIR%
for /f %%i in ('dir /b "%_OUTPUT_DIR%\dotty-compiler_*.jar" 2^>NUL') do (
    set _NIGHTLY_VERSION=%%~ni
    set _NIGHTLY_VERSION=!_NIGHTLY_VERSION:~20!
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Nightly version is %_NIGHTLY_VERSION% 1>&2
) else if %_VERBOSE%==1 ( echo Nightly version is %_NIGHTLY_VERSION% 1>&2
)
@rem set _NIGHTLY_UPTODATE=1
goto :eof

@rem global variable: _DOTTY_HOME
:backup_dotty
set __DOTTY_BAK_DIR=%DOTTY_HOME%\lib\%_DOTTY_VERSION%
if not exist "%__DOTTY_BAK_DIR%\" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% mkdir "%__DOTTY_BAK_DIR%" 1<&2
    mkdir "%__DOTTY_BAK_DIR%"
    for %%i in (%DOTTY_HOME%\lib\^*%_DOTTY_VERSION%.jar) do (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% copy %%i "%__DOTTY_BAK_DIR%\" 1>&2
        copy %%i "%__DOTTY_BAK_DIR%\" 1>NUL
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to backup file %%i 1>&2
            set _EXITCODE=1
        )
    )
)
goto :eof

@rem global variables: _DOTTY_HOME, _OUTPUT_DIR
@rem output parameter: _NIGHTLY_VERSION
:backup_nightly
set __OLD_NIGHTLY_VERSION=unknown
if exist "%DOTTY_HOME%\VERSION-NIGHTLY" (
    set /p __OLD_NIGHTLY_VERSION=<%DOTTY_HOME%\VERSION-NIGHTLY
    if "%__OLD_NIGHTLY_VERSION%"=="%_NIGHTLY_VERSION%" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Nightly version and old version are equal ^(%_NIGHTLY_VERSION%^) 1>&2
        goto :eof
    )
) else (
    set __OLD_NIGHTLY_VERSION=%_DOTTY_VERSION%
)
echo Local nightly version has changed from %__OLD_NIGHTLY_VERSION% to %_NIGHTLY_VERSION%
echo %_NIGHTLY_VERSION%>%DOTTY_HOME%\VERSION-NIGHTLY

set "__NIGHTLY_BAK_DIR=%DOTTY_HOME%\lib\%_NIGHTLY_VERSION%"
if not exist "%__NIGHTLY_BAK_DIR%\" (
    mkdir "%__NIGHTLY_BAK_DIR%"
    for %%i in (%_OUTPUT_DIR%\^*%_NIGHTLY_VERSION%.jar) do (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% copy %%i "%__NIGHTLY_BAK_DIR%\" 1>&2
        copy %%i "%__NIGHTLY_BAK_DIR%\" 1>NUL
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to backup file %%i 1>&2
            set _EXITCODE=1
        )
    )
)
goto :eof

@rem global variable: _DOTTY_HOME
:activate_version
set __OLD_VERSION=%~1
set __NEW_VERSION=%~2
echo Activate nightly build libraries: %__NEW_VERSION%

set "__FROM_DIR=%DOTTY_HOME%\lib\%__NEW_VERSION%"
set "__TO_DIR=%DOTTY_HOME%\lib"
if %_DEBUG%==1 echo %_DEBUG_LABEL% del %__TO_DIR%\*%__OLD_VERSION%.jar 1>&2 
del "%__TO_DIR%\*%__OLD_VERSION%.jar" 1>NUL 2>&1
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% copy "%__FROM_DIR%\*.jar" "%__TO_DIR%\" 1>&2
) else if %_VERBOSE%==1 ( echo Copy "!__FROM_DIR:%DOTTY_HOME%\=!\*.jar" "!__TO_DIR:%DOTTY_HOME%\=!\" 1>&2
)
copy "%__FROM_DIR%\*.jar" "%__TO_DIR%\" %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to copy files from "%__FROM_DIR%\" 1>&2
    set _EXITCODE=1
    goto :eof
)
set __OLD_DIR=
for /f %%f in ('dir /b /ad "%DOTTY_HOME%\lib\*-NIGHTLY" 2^>NUL') do set "__OLD_DIR=%DOTTY_HOME%\lib\%%f"
if not defined __OLD_DIR goto :eof
for /f %%f in ('dir /b "%__OLD_DIR%\*.jar" 2^>NUL') do (
    if exist "%__TO_DIR%\%%f" del "%__TO_DIR%\%%f"
)
goto :eof

@rem global variables: _DOTTY_VERSION, _NIGHTLY_VERSION
:activate_nightly
call :activate_version "%_DOTTY_VERSION%" "%_NIGHTLY_VERSION%"
if not !_EXITCODE!==0 (
    echo.
    goto :eof
)
goto :eof

@rem global variables: _DOTTY_VERSION, _NIGHTLY_VERSION
:activate_dotty
call :activate_version "%_NIGHTLY_VERSION%" "%_DOTTY_VERSION%"
if not !_EXITCODE!==0 (
    echo.
    goto :eof
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
    echo Total elapsed time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

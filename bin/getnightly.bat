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
if %_DOWNLOAD%==1 (
    call :download
    if not !_EXITCODE!==0 goto end
)
if %_ACTIVATE%==1 (
    call :activate
    if not !_EXITCODE!==0 goto end
)
if %_RESTORE%==1 (
    call :restore
    if not !_EXITCODE!==0 goto end
)

goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0
for %%f in ("%~dp0\.") do set "_ROOT_DIR=%%~dpf"
set _TIMER=0

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
if not exist "%GIT_HOME%\usr\bin\unix2dos.exe" (
    set _EXITCODE=1
    goto :eof
)
set "_CURL_CMD=%GIT_HOME%\mingw64\bin\curl.exe"
set "_GIT_CMD=%GIT_HOME%\bin\git.exe"
set "_SED_CMD=%GIT_HOME%\usr\bin\sed.exe"
set "_UNIX2DOS_CMD=%GIT_HOME%\usr\bin\unix2dos.exe"

set "_NIGHTLY_DIR=%_ROOT_DIR%out\nightly"
set "_NIGHTLY_BIN_DIR=%_NIGHTLY_DIR%\bin"
set "_NIGHTLY_LIB_DIR=%_NIGHTLY_DIR%\lib"
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
set _ACTIVATE=0
set _DOWNLOAD=0
set _HELP=0
set _RESTORE=0
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
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="download" ( set _DOWNLOAD=1
    ) else if "%__ARG%"=="activate" ( set _DOWNLOAD=1& set _ACTIVATE=1
    ) else if "%__ARG%"=="restore" ( set _RESTORE=1
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
if %_DEBUG%==1 ( set _STDOUT_REDIRECT=1^>CON
) else ( set _STDOUT_REDIRECT=1^>NUL
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _DOWNLOAD=%_DOWNLOAD% _ACTIVATE=%_ACTIVATE% _RESTORE=%_RESTORE% 1>&2
    if defined SCALA3_HOME echo %_DEBUG_LABEL% Variables  : "SCALA3_HOME=%SCALA3_HOME%" 1>&2
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
echo     %__BEG_O%restore%__END%     restore the default Scala library files
goto :eof

@rem input parameter: 1=file path
@rem output parameter: _FILE_SIZE
:file_size
set "__FILE=%~1"

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

@rem input parameter(s): %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _NIGHTLY_VERSION
:download
set _NIGHTLY_VERSION=

call :rmdir "%_NIGHTLY_DIR%"
if not %_EXITCODE%==0 goto :eof

:download_nightly
if not exist "%_NIGHTLY_LIB_DIR%" mkdir "%_NIGHTLY_LIB_DIR%" 1>NUL
set __N=0
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% powershell -ExecutionPolicy ByPass -File "%_PS1_FILE%" %_DEBUG% 1>&2
) else if %_VERBOSE%== 1 ( echo Download Scala 3 nightly files from Maven repository 1>&2
)
for /f "delims=" %%i in ('powershell -ExecutionPolicy ByPass -File "%_PS1_FILE%" %_DEBUG%') do (
    @rem set __URL=http://central.maven.org/maven2/%%i
    set __URL=https://repo.maven.apache.org/maven2/%%i
    for %%f in ("%%i") do set "__FILE_BASENAME=%%~nxf"
    if defined _NIGHTLY_VERSION if not "!__FILE_BASENAME:%_NIGHTLY_VERSION%=!"=="!__FILE_BASENAME!" (
        echo Nightly build files already present locally
        echo ^(directory %SCALA3_HOME%\lib\%_NIGHTLY_VERSION%^)
        goto :eof
    )
    if %_VERBOSE%==1 <NUL set /p=Downloading file !__FILE_BASENAME! ... 
    set "__JAR_FILE=%_NIGHTLY_LIB_DIR%\!__FILE_BASENAME!"
    @rem NB. curl is faster than wget
    @rem if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -c "wget -uri !__URL! -Outfile '!__JAR_FILE!'" 1>&2
    @rem powershell -c "$progressPreference='silentlyContinue';wget -uri !__URL! -Outfile '!__JAR_FILE!'"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_CURL_CMD%" --silent --url "!__URL!" ^> "!__JAR_FILE!" 1>&2
    call "%_CURL_CMD%" --silent --url "!__URL!" > "!__JAR_FILE!"
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
if %__N%==0 (
    echo %_ERROR_LABEL% No nightly file found ^(check issue in script %_BASENAME%.ps1^) 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f %%i in ('dir /b "%_NIGHTLY_LIB_DIR%\scala3-compiler_3-*.jar" 2^>NUL') do (
    set _NIGHTLY_VERSION=%%~ni
    set _NIGHTLY_VERSION=!_NIGHTLY_VERSION:~18!
)
:download_deps
set "__LST_FILE=%~dp0%_BASENAME%.lst"
if not exist "%__LST_FILE%" (
    echo %_ERROR_LABEL% File "%_BASENAME%.lst" is missing 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem if %_VERBOSE%== 1 echo Download library files from Maven repository and script files from GitHub project 1>&2
for /f "tokens=1,*" %%i in (%__LST_FILE%) do (
    set "__DIR=%%i"
    if not "!__DIR:~0,1!"=="#" (
        set "__URI=%%j"
        call :name_from_url "%%j"
        if not exist "%_NIGHTLY_DIR%\!__DIR!" mkdir "%_NIGHTLY_DIR%\!__DIR!" 1>NUL
        if %_VERBOSE%==1 <NUL set /p=Downloading file !__NAME! ... 
        set "__OUTFILE=%_NIGHTLY_DIR%\!__DIR!\!__NAME!"
        @rem NB. curl is faster than wget
        @rem if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -C "wget -uri '!__URI!' -outfile '!__OUTFILE!'"
        @rem powershell -C "$progressPreference='silentlyContinue';wget -uri '!__URI!' -outfile '!__OUTFILE!'"
        if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_CURL_CMD%" --silent --url "!__URI!" ^> "!__OUTFILE!" 1>&2
        call "%_CURL_CMD%" --silent --url "!__URI!" > "!__OUTFILE!"
        if !ERRORLEVEL!==0  if "!__NAME:~-4!"==".bat" (
            if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_UNIX2DOS_CMD%" "!__OUTFILE!" 1^>NUL 1>&2
            @rem ) else if %_VERBOSE%==1 ( echo Convert file !__NAME! to DOS format 2>&2
            )
            call "%_UNIX2DOS_CMD%" "!__OUTFILE!" 2>NUL
        )
        if %_VERBOSE%==1 (
            call :file_size "!__OUTFILE!"
            echo !_FILE_SIZE!
        )
        set /a __N+=1
    )
)
if %_VERBOSE%==1 echo Finished to download %__N% files to directory "!_NIGHTLY_DIR:%_ROOT_DIR%=!" 1>&2

@rem create VERSION file in %__NIGHTLY_HOME% directory.
call :github_revision "%_NIGHTLY_VERSION%"
if not %_EXITCODE%==0 goto :eof

for /f "usebackq delims=" %%i in (`powershell -C "Get-Date -Format 'yyyy-MM-dd HH:mm:ssK'"`) do set "__BUILD_TIME=%%i"
(
    echo version:=%_NIGHTLY_VERSION%
    echo revision:=%_GITHUB_REVISION%
    echo buildTime:=%__BUILD_TIME%
) > "%_NIGHTLY_DIR%\VERSION"
set /a __SHOW=%_VERBOSE%+%_DEBUG%
if not %__SHOW%==0 (
    echo File "!_NIGHTLY_DIR:%_ROOT_DIR%=!\VERSION": 1>&2
    type "%_NIGHTLY_DIR%\VERSION" 1>&2
)
goto :eof

@rem input parameter: %1=URL
@rem output parameter: __NAME
:name_from_url
set "__URL=%~1"
set __NAME=
:extract_loop
for /f "delims=/ tokens=1,*" %%i in ("%__URL%") do (
    set "__NAME=%%i"
    set "__URL=%%j"
    goto extract_loop
)
goto :eof

@rem input parameter: %1=nightly version
@rem output parameter: _GITHUB_REVISION
:github_revision
set "__NIGHTLY_VERSION=%~1"
set "__HASH=!__NIGHTLY_VERSION:-NIGHTLY=!"
set "__HASH=%__HASH:~-7%"
set "__URL=https://github.com/lampepfl/dotty/commit/%__HASH%"
set "__OUTPUT_FILE=%TEMP%\%_BASENAME%_curl.txt"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CURL_CMD%" --silent --url "%__URL%"^| "%_SED_CMD%" -e "s#/><#\n#g" ^> "%__OUTPUT_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Retrieve revision for hash "%__HASH%" from GitHub repository "lampepfl/dotty" 1>&2
)
call "%_CURL_CMD%" --silent --url "%__URL%" | "%_SED_CMD%" -e "s#/><#\n#g" > "%__OUTPUT_FILE%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
@rem Make sure findstr output does NOT contain any '<' or '>' characters
for /f "delims=^= tokens=1,2,*" %%i in ('findstr og:url "%__OUTPUT_FILE%"') do (
    set _GITHUB_REVISION=%%~k
    set "_GITHUB_REVISION=!_GITHUB_REVISION:"=!"
    set "_GITHUB_REVISION=!_GITHUB_REVISION:/lampepfl/dotty/commit/=!"
)
goto :eof

@rem output parameter: _SCALA3_HOME
:activate
if not exist "%_NIGHTLY_DIR%\VERSION" (
    echo %_ERROR_LABEL% File VERSION not found in directory "%_NIGHTLY_DIR%" 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims=^:^= tokens=1,*" %%i in ('findstr version "%_NIGHTLY_DIR%\VERSION"') do (
    set "__NIGHTLY_VERSION=%%j"
)
set "__NIGHTLY_HOME=C:\opt\scala3-%__NIGHTLY_VERSION%"
if /i "%SCALA3_HOME%"=="%__NIGHTLY_HOME%" goto :eof

if not exist "%__NIGHTLY_HOME%\lib" mkdir "%__NIGHTLY_HOME%\lib"
if not exist "%__NIGHTLY_HOME%\bin" mkdir "%__NIGHTLY_HOME%\bin"

@rem copy lib\ directory
xcopy /q /y "%_NIGHTLY_LIB_DIR%\*.jar" "%__NIGHTLY_HOME%\lib\" 1>NUL

@rem copy bin\ directory
xcopy /q /y "%_NIGHTLY_BIN_DIR%\common*" "%__NIGHTLY_HOME%\bin\" 1>NUL
xcopy /q /y "%_NIGHTLY_BIN_DIR%\scala*" "%__NIGHTLY_HOME%\bin\" 1>NUL

@rem copy VERSION file
xcopy /q /y "%_NIGHTLY_DIR%\VERSION" "%__NIGHTLY_HOME%\VERSION"
if defined SCALA3_HOME (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Create file "%__NIGHTLY_HOME%\SCALA3_HOME_BACKUP" 1>&2
    echo %SCALA3_HOME%> "%__NIGHTLY_HOME%\SCALA3_HOME_BACKUP"
    call :version
    echo Active Scala 3 installation is %__NIGHTLY_VERSION% ^(was !_VERSION!^)
)
set "_SCALA3_HOME=%__NIGHTLY_HOME%"
goto :eof

@rem output parameter: _VERSION
:version
set _VERSION=unknown
for /f "tokens=1-3,4,*" %%i in ('"%SCALA3_HOME%\bin\scalac.bat" -version 2^>^&1') do set _VERSION=%%l
goto :eof

@rem output parameter: _SCALA3_HOME
:restore
if exist "%SCALA3_HOME%\SCALA3_HOME_BACKUP" (
    set /p _SCALA3_HOME=< "%SCALA3_HOME%\SCALA3_HOME_BACKUP"
) else if exist "%SCALA3_HOME%\bin\scala.bat" (
    set "_SCALA3_HOME=%SCALA3_HOME%"
) else (
    echo %_ERROR_LABEL% Scala installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
call :version
echo Active Scala 3 installation is %_VERSION%
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
endlocal & (
    if defined _SCALA3_HOME (
        set "SCALA3_HOME=%_SCALA3_HOME%"
        echo Variable SCALA3_HOME is defined as "!SCALA3_HOME!"
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    exit /b %_EXITCODE%
)

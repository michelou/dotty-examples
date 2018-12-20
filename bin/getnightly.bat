@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do set _ROOT_DIR=%%~sf

call :args %*
if not %_EXITCODE%==0 goto end
if defined _HELP call :help & exit /b %_EXITCODE%

set _PS1_FILE=%_ROOT_DIR%\bin\%_BASENAME%.ps1
if not exist "%_PS1_FILE%" (
    echo Error: PS1 file %_PS1_FILE% not found 1>&2
    set _EXITCODE=1
    goto end
)

set _OUTPUT_DIR=%_ROOT_DIR%\out\nightly-jars
if not exist "%_OUTPUT_DIR%" mkdir "%_OUTPUT_DIR%" 1>NUL

rem ##########################################################################
rem ## Main

call :init
if not %_EXITCODE%==0 goto end

if defined _DOWNLOAD_ONLY (
    call :download
    if not !_EXITCODE!==0 goto end
    goto end
)

call :backup_dotty
if not %_EXITCODE%==0 goto end

if defined _ACTIVATE_NIGHTLY (
    call :download
    if not !_EXITCODE!==0 goto end

    call :backup_nightly
    if not !_EXITCODE!==0 goto end

    call :activate_nightly
    if not !_EXITCODE!==0 goto end
) else (
    call :activate_dotty
    if not !_EXITCODE!==0 goto end
)

goto end

rem ##########################################################################
rem ## Subroutines

rem input parameter: %*
rem output parameter: _HELP, _VERBOSE
:args
set _ACTIVATE_NIGHTLY=
set _DOWNLOAD_ONLY=1
set _HELP=
set _VERBOSE=0

:args_loop
set __ARG=%~1
if not defined __ARG goto args_done
if /i "%__ARG%"=="help" ( set _HELP=1& goto :eof
) else if /i "%__ARG%"=="download" ( set _DOWNLOAD_ONLY=1
) else if /i "%__ARG%"=="activate" (
    set _DOWNLOAD_ONLY=
    set _ACTIVATE_NIGHTLY=1
) else if /i "%__ARG%"=="reset" (
    set _DOWNLOAD_ONLY=
    set _ACTIVATE_NIGHTLY=
) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
) else (
    echo Error: Unknown subcommand %__ARG% 1>&2
    set _EXITCODE=1
    goto :eof
)
shift
goto args_loop
:args_done
if %_DEBUG%==1 (
    rem for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TOTAL_TIME_START=%%i
    echo [%_BASENAME%] _DOWNLOAD_ONLY=%_DOWNLOAD_ONLY% _ACTIVATE_NIGHTLY=%_ACTIVATE_NIGHTLY%
)
goto :eof

:help
echo Usage: %_BASENAME% { options ^| subcommands }
echo   Options:
echo     -verbose         display download progress
echo   Subcommands:
echo     activate         activate the nightly build library files
echo     download         download nighty build files and quit (default)
echo     help             display this help message
echo     reset            restore the default Dotty library files
goto :eof

rem output parameters: _DOTTY_HOME, _DOTTY_VERSION, _NIGHTLY_VERSION
:init
where /q dotc.bat
if not %ERRORLEVEL%==0 (
    echo Error: dotc command not found ^(run setenv.bat^) 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f %%i in ('where dotc.bat') do (
    for %%f in ("%%~dpi..") do set _DOTTY_HOME=%%~sf
)
if not exist "%_DOTTY_HOME%\lib\" (
    echo Error: Dotty library directory not found ^(run setenv.bat^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if not exist "%_DOTTY_HOME%\VERSION" (
    echo Error: Dotty version file not found ^(run setenv.bat^) 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims== tokens=1,*" %%i in (%_DOTTY_HOME%\VERSION) do (
    set __NAME=%%i
    set __VALUE=%%j
    if not "!__NAME:version=!"=="!__NAME!" set _DOTTY_VERSION=!__VALUE!
)
set _NIGHTLY_VERSION=unknown
if exist "%_DOTTY_HOME%\VERSION-NIGHTLY" (
    set /p _NIGHTLY_VERSION=<%_DOTTY_HOME%\VERSION-NIGHTLY
    if not exist "%_DOTTY_HOME%\lib\!_NIGHTLY_VERSION!\" (
        del "%_DOTTY_HOME%\VERSION-NIGHTLY" 1>NUL
        set _NIGHTLY_VERSION=unknown
    )
)
goto :eof

rem input parameter: 1=file path
rem output parameter: _FILE_SIZE
:file_size
set __FILE=%~1

set __PS1_SCRIPT= ^
$size=(Get-Item '%__FILE%').length; ^
If ($size -ge 1073741824) { $n = $size / 1073741824; $unit='Gb' } ^
Elseif ($size -ge 1048576) {  $n = $size / 1048576; $unit='Mb' } ^
Else { $n = $size/1024; $unit='Kb' } ^
Write-Host ([math]::Round($n,1))" "$unit

set _FILE_SIZE=0
if %_DEBUG%==1 echo [%_BASENAME%] powershell -C "..."
for /f "delims=" %%i in ('powershell -C "%__PS1_SCRIPT%"') do set _FILE_SIZE=%%i
if not %ERRORLEVEL%==0 (
    echo Error: Execution of ps1 cmdlet failed 1>&2
    set _EXITCODE=1
    goto :eof
)
set _FILE_SIZE=%_FILE_SIZE:,=.%
goto :eof

rem output parameter: _NIGHTLY_VERSION
:download
if %_DEBUG%==1 echo [%_BASENAME%] del /f /q %_OUTPUT_DIR%\*.jar 1^>NUL 2^>^&1
del /f /q %_OUTPUT_DIR%\*.jar 1>NUL 2>&1

set __N=0
if %_DEBUG%==1 echo [%_BASENAME%] powershell -ExecutionPolicy ByPass -File "%_PS1_FILE%"
for /f "delims=" %%i in ('powershell -ExecutionPolicy ByPass -File "%_PS1_FILE%"') do (
    set __URL=http://central.maven.org/maven2/%%i
    for %%f in ("%%i") do set __FILE_BASENAME=%%~nxf
    if defined _NIGHTLY_VERSION if not "!__FILE_BASENAME:%_NIGHTLY_VERSION%=!"=="!__FILE_BASENAME!" (
        echo Nightly build files already present locally
        echo ^(see directory %_DOTTY_HOME%\%_NIGHTLY_VERSION%^)
        goto :eof
    )
    if %_VERBOSE%==1 <NUL set /p=Downloading file !__FILE_BASENAME! ... 
    set __JAR_FILE=%_OUTPUT_DIR%\!__FILE_BASENAME!
    if %_DEBUG%==1 echo [%_BASENAME%] powershell -c "Invoke-WebRequest -Uri !__URL! -Outfile !__JAR_FILE!"
    powershell -c "$progressPreference='silentlyContinue';Invoke-WebRequest -Uri !__URL! -Outfile !__JAR_FILE!"
    if not !ERRORLEVEL!==0 (
        echo.
        echo Error: Failed to download file !__JAR_FILE! 1>&2
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
for /f %%i in ('dir /b "%_OUTPUT_DIR%\dotty-interfaces-*.jar" 2^>NUL') do (
    set _NIGHTLY_VERSION=%%~ni
    set _NIGHTLY_VERSION=!_NIGHTLY_VERSION:~17!
)
goto :eof

rem global variable: _DOTTY_HOME
:backup_dotty
set __DOTTY_BAK_DIR=%_DOTTY_HOME%\lib\%_DOTTY_VERSION%
if not exist "%__DOTTY_BAK_DIR%\" (
    mkdir "%__DOTTY_BAK_DIR%"
    for %%i in (%_DOTTY_HOME%\lib\^*%_DOTTY_VERSION%.jar) do (
        if %_DEBUG%==1 echo [%_BASENAME%] copy %%i "%__DOTTY_BAK_DIR%\" 1^>NUL
        copy %%i "%__DOTTY_BAK_DIR%\" 1>NUL
        if not !ERRORLEVEL!==0 (
            echo Error: Failed to backup file %%i 1>&2
            set _EXITCODE=1
        )
    )
)
goto :eof

rem global variables: _DOTTY_HOME, _OUTPUT_DIR
rem output parameter: _NIGHTLY_VERSION
:backup_nightly
set __OLD_NIGHTLY_VERSION=unknown
if exist "%_DOTTY_HOME%\VERSION-NIGHTLY" (
    set /p __OLD_NIGHTLY_VERSION=<%_DOTTY_HOME%\VERSION-NIGHTLY
)
if "%__OLD_NIGHTLY_VERSION%"=="%_NIGHTLY_VERSION%" goto :eof

echo Local nightly version has changed from %__OLD_NIGHTLY_VERSION% to %_NIGHTLY_VERSION%
echo %_NIGHTLY_VERSION%>%_DOTTY_HOME%\VERSION-NIGHTLY

set __NIGHTLY_BAK_DIR=%_DOTTY_HOME%\lib\%_NIGHTLY_VERSION%
if not exist "%__NIGHTLY_BAK_DIR%\" (
    mkdir "%__NIGHTLY_BAK_DIR%"
    for %%i in (%_OUTPUT_DIR%\^*%_NIGHTLY_VERSION%.jar) do (
        if %_DEBUG%==1 echo [%_BASENAME%] copy %%i "%__NIGHTLY_BAK_DIR%\" 1^>NUL
        copy %%i "%__NIGHTLY_BAK_DIR%\" 1>NUL
        if not !ERRORLEVEL!==0 (
            echo Error: Failed to backup file %%i 1>&2
            set _EXITCODE=1
        )
    )
)
goto :eof

rem global variable: _DOTTY_HOME
:activate_version
set __OLD_VERSION=%~1
set __NEW_VERSION=%~2

set __FROM_DIR=%_DOTTY_HOME%\lib\%__NEW_VERSION%
set __TO_DIR=%_DOTTY_HOME%\lib
if %_DEBUG%==1 echo [%_BASENAME%] del %__TO_DIR%\*%__OLD_VERSION%.jar 1^>NUL 
del %__TO_DIR%\*%__OLD_VERSION%.jar 1>NUL 2>&1
if %_DEBUG%==1 echo [%_BASENAME%] copy "%__FROM_DIR%\*.jar" "%__TO_DIR%\" 1^>NUL
copy "%__FROM_DIR%\*.jar" "%__TO_DIR%\" 1>NUL
if not %ERRORLEVEL%==0 (
    echo Error: Failed to copy files from %__FROM_DIR%\ 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

rem global variables: _DOTTY_VERSION, _NIGHTLY_VERSION
:activate_nightly
<NUL set /p=Activate nightly build libraries
call :activate_version "%_DOTTY_VERSION%" "%_NIGHTLY_VERSION%"
if not !_EXITCODE!==0 (
    echo.
    goto :eof
)
echo : %_NIGHTLY_VERSION%
goto :eof

rem global variables: _DOTTY_VERSION, _NIGHTLY_VERSION
:activate_dotty
<NUL set /p=Activate default Dotty libraries
call :activate_version "%_NIGHTLY_VERSION%" "%_DOTTY_VERSION%"
if not !_EXITCODE!==0 (
    echo.
    goto :eof
)
echo : %_DOTTY_VERSION%
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal

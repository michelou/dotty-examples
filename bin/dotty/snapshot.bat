@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

set _EIGHT=bellsoft-08 corretto-08 dragonwell-08 graalvm-ce-08 openj9-08 openjdk-08 redhat-08 zulu-08
set _ELEVEN=bellsoft-11 bellsoft-nik-11 corretto-11 dcevm-11 dragonwell-11 graalvm-ce-11 microsoft-11 openj9-11 openjdk-11 redhat-11 sapmachine-11 zulu-11
set _SEVENTEEN=bellsoft-17 bellsoft-nik-17 corretto-17 graalvm-ce-17 microsoft-17 openjdk-17 sapmachine-17 zulu-17

@rem for %%i in (%_EIGHT% %_ELEVEN% %_SEVENTEEN%) do (
for %%i in (%_EIGHT%) do (
    call :build_snapshot "%%i"
    if not !_EXITCODE!==0 goto end
    call :save_snapshot "%%i"
    if not !_EXITCODE!==0 goto end
    timeout /t 20 /nobreak 1>NUL
)
goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

set _DEBUG_LABEL=[%_BASENAME%]
set _ERROR_LABEL=Error:
set _WARNING_LABEL=Warning:

set "_TARGET_DIR=%_ROOT_DIR%dist\target"
set "_SNAPSHOT_DIR=%_ROOT_DIR%__SNAPSHOT_LOCAL"
set "_LOG_FILE=%_SNAPSHOT_DIR%\snapshot_log.txt"

@rem map distro name to distro installation path
call :env_set bellsoft-08 "c:\opt\jdk-bellsoft-1.8*"
call :env_set bellsoft-11 "c:\opt\jdk-bellsoft-11*"
call :env_set bellsoft-17 "c:\opt\jdk-bellsoft-17*"

call :env_set bellsoft-nik-11 "c:\opt\jdk-bellsoft-nik-java11*"
call :env_set bellsoft-nik-17 "c:\opt\jdk-bellsoft-nik-java17*"

call :env_set corretto-08 "c:\opt\jdk-corretto-1.8*"
call :env_set corretto-11 "c:\opt\jdk-corretto-11*"
call :env_set corretto-17 "c:\opt\jdk-corretto-17*"

call :env_set dragonwell-08 "c:\opt\jdk-dragonwell-1.8*"
call :env_set dragonwell-11 "c:\opt\jdk-dragonwell-11*"

call :env_set dcevm-11 "c:\opt\jdk-dcevm-11*"

call :env_set graalvm-ce-08 "c:\opt\graalvm-ce-java8*"
call :env_set graalvm-ce-11 "c:\opt\graalvm-ce-java11*"
call :env_set graalvm-ce-17 "c:\opt\graalvm-ce-java17*"

call :env_set microsoft-11 "c:\opt\jdk-microsoft-11*"
call :env_set microsoft-17 "c:\opt\jdk-microsoft-17*"

call :env_set openj9-08 "c:\opt\jdk-openj9-1.8*"
call :env_set openj9-11 "c:\opt\jdk-openj9-11*"

call :env_set openjdk-08 "c:\opt\jdk-openjdk-1.8*"
call :env_set openjdk-11 "c:\opt\jdk-openjdk-11*"
call :env_set openjdk-17 "c:\opt\jdk-openjdk-17*"

call :env_set redhat-08 "c:\opt\jdk-redhat-1.8*"
call :env_set redhat-11 "c:\opt\jdk-redhat-11*"

call :env_set sapmachine-11 "c:\opt\jdk-sapmachine-11*"
call :env_set sapmachine-17 "c:\opt\jdk-sapmachine-17*"

call :env_set zulu-08 "c:\opt\jdk-zulu-1.8*"
call :env_set zulu-11 "c:\opt\jdk-zulu-11*"
call :env_set zulu-17 "c:\opt\jdk-zulu-17*"

if not exist "%_ROOT_DIR%build.bat" (
    echo %_ERROR_LABEL% Batch file build.bat not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_BUILD_BAT=%_ROOT_DIR%build.bat"

if not exist "%_ROOT_DIR%project\Build.scala" (
    echo %_ERROR_LABEL% SBT file Build.scala not found 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem https://newbedev.com/what-are-the-undocumented-features-and-limitations-of-the-windows-findstr-command
for /f "delims=^= tokens=1,*" %%i in ('findstr /i "val.baseVersion" "%_ROOT_DIR%project\Build.scala"') do (
    set __VERSION=%%j
    set __VERSION=!__VERSION:"=!
    set _BASE_VERSION=!__VERSION: =!
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _BASE_VERSION=%_BASE_VERSION% 1>&2
goto :eof

@rem input parameter: %1=distro name, %2=file pattern
:env_set
set "__DISTRO_NAME=%~1"
set "__FILE_PATTERN=%~2"
if not exist "%__FILE_PATTERN%" (
    echo %_WARNING_LABEL% No installation path found for "%__DISTRO_NAME%" distribution 1>&2
    goto :eof
)
for /f %%d in ('dir /ad /b "%__FILE_PATTERN%"') do set "_MAP[%__DISTRO_NAME%]=c:\opt\%%d"
goto :eof

:build_snapshot
set __DISTRO_NAME=%~1

set "__JAVA_HOME=!_MAP[%__DISTRO_NAME%]!"
if not exist "!__JAVA_HOME!\bin\java.exe" (
    echo %_ERROR_LABEL% Java executable not found ^("!__DISTRO_NAME!"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 (
    if defined JAVA_OPTS echo %_DEBUG_LABEL% JAVA_OPTS=%JAVA_OPTS% 1>&2
    if defined SBT_OPTS echo %_DEBUG_LABEL% SBT_OPTS=%SBT_OPTS% 1>&2
)
setlocal
set "JAVA_HOME=%__JAVA_HOME%"
echo.
call "%_BUILD_BAT%" clean
for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
@rem the 2 subcommands are run in 2 steps since a few tests are still failing on Windows
call "%_BUILD_BAT%" boot
call "%_BUILD_BAT%" arch-only
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to create .tar.gz/.zip files in directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
call :duration "%_TIMER_START%" "%__TIMER_END%"
for /f "delims=" %%i in ('powershell -c "(Get-Date -Format 'yyyy-MM-dd hh:mm')"') do set "__TS=%%i"
@rem for all distros name length is 6 < n < 14
set "__PAD_RIGHT=%__DISTRO_NAME%        "
echo [%__TS%] DISTRO_NAME=%__PAD_RIGHT:~0,15% DURATION=%_DURATION% JAVA_HOME=!JAVA_HOME!>> "%_LOG_FILE%"
endlocal
goto :eof

:save_snapshot
set __DISTRO_NAME=%~1
set __SNAPSHOT_BASENAME=scala3-%_BASE_VERSION%-bin-SNAPSHOT

if not exist "%_SNAPSHOT_DIR%" mkdir "%_SNAPSHOT_DIR%"
for %%j in (.tar.gz .zip) do (
    if not exist "%_TARGET_DIR%\%__SNAPSHOT_BASENAME%%%j" (
        echo %_ERROR_LABEL% Archive file "%__SNAPSHOT_BASENAME%%%j" not found 1>&2
        set _EXITCODE=1
        goto :eof
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% copy /y "%_TARGET_DIR%\%__SNAPSHOT_BASENAME%%%j" "%_SNAPSHOT_DIR%\%__SNAPSHOT_BASENAME%-%__DISTRO_NAME%%%j" 1^>NUL 1>&2
    copy /y "%_TARGET_DIR%\%__SNAPSHOT_BASENAME%%%j" "%_SNAPSHOT_DIR%\%__SNAPSHOT_BASENAME%-%__DISTRO_NAME%%%j" 1>NUL
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to copy file "%__SNAPSHOT_BASENAME%%%j" into directory "%_SNAPSHOT_DIR%" 1>&2
        set _EXITCODE=1
        goto :eof
    )
    del "%_TARGET_DIR%\%__SNAPSHOT_BASENAME%%%j"
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

:end_cleanup
@rem core.20210414.110041.2036.0001.dmp
if exist "%_ROOT_DIR%core.*.dmp" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% del "%_ROOT_DIR%core.*.dmp" 1>&2
    del "%_ROOT_DIR%core.*.dmp"
)
@rem heapdump.20210414.110041.2036.0002.phd
if exist "%_ROOT_DIR%headdump.*.phd" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% del "%_ROOT_DIR%headdump.*.phd" 1>&2
    del "%_ROOT_DIR%headdump.*.phd"
)
@rem javacore.20210414.110041.2036.0003.txt
if exist "%_ROOT_DIR%javacore.*.txt" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% del "%_ROOT_DIR%javacore.*.txt" 1>&2
    del "%_ROOT_DIR%javacore.*.txt"
)
@rem Snap.20210414.110041.2036.0004.trc
if exist "%_ROOT_DIR%Snap.*.trc" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% del "%_ROOT_DIR%Snap.*.trc" 1>&2
    del "%_ROOT_DIR%Snap.*.trc"
)
@rem .git\config.lock
if exist "%_ROOT_DIR%.git\config.lock" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% del "%_ROOT_DIR%.git\config.lock" 1>&2
    del "%_ROOT_DIR%.git\config.lock"
)
goto :eof

:end
call :end_cleanup
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b 0

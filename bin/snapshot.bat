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

set _REFERENCE_VERSION=3.0.1
set _BASE_VERSION=3.0.2-RC1

set _EIGHT=bellsoft-08 dragonwell-08 openj9-08 openjdk-08 redhat-08 zulu-08 zulu-08
set _ELEVEN=bellsoft-11 corretto-11 dcevm-11 dragonwell-11 openj9-11 openjdk-11 redhat-11 sapmachine-11 zulu-11
set _SEVENTEEN=openjdk-17 sapmachine-17 zulu-17

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

set "_TARGET_DIR=%_ROOT_DIR%dist\target"
set "_SNAPSHOT_DIR=%_ROOT_DIR%__SNAPSHOT_LOCAL"

@rem map distro name to distro installation path
for /f %%d in ('dir /ad /b "c:\opt\jdk-bellsoft-1.8*"') do set "_MAP[bellsoft-08]=c:\opt\%%d"
for /f %%d in ('dir /ad /b "c:\opt\jdk-bellsoft-11*"') do set "_MAP[bellsoft-11]=c:\opt\%%d"

for /f %%d in ('dir /ad /b "c:\opt\jdk-corretto-11*"') do set "_MAP[corretto-11]=c:\opt\%%d"

for /f %%d in ('dir /ad /b "c:\opt\jdk-dragonwell-1.8*"') do set "_MAP[dragonwell-08]=c:\opt\%%d"
for /f %%d in ('dir /ad /b "c:\opt\jdk-dragonwell-11*"') do set "_MAP[dragonwell-11]=c:\opt\%%d"

for /f %%d in ('dir /ad /b "c:\opt\jdk-dcevm-11*"') do set "_MAP[dcevm-11]=c:\opt\%%d"

for /f %%d in ('dir /ad /b "c:\opt\jdk-openj9-1.8*"') do set "_MAP[openj9-08]=c:\opt\%%d"
for /f %%d in ('dir /ad /b "c:\opt\jdk-openj9-11*"') do set "_MAP[openj9-11]=c:\opt\%%d"

for /f %%d in ('dir /ad /b "c:\opt\jdk-openjdk-1.8*"') do set "_MAP[openjdk-08]=c:\opt\%%d"
for /f %%d in ('dir /ad /b "c:\opt\jdk-openjdk-11*"') do set "_MAP[openjdk-11]=c:\opt\%%d"
for /f %%d in ('dir /ad /b "c:\opt\jdk-openjdk-17*"') do set "_MAP[openjdk-17]=c:\opt\%%d"

for /f %%d in ('dir /ad /b "c:\opt\jdk-redhat-1.8*"') do set "_MAP[redhat-08]=c:\opt\%%d"
for /f %%d in ('dir /ad /b "c:\opt\jdk-redhat-11*"') do set "_MAP[redhat-11]=c:\opt\%%d"

for /f %%d in ('dir /ad /b "c:\opt\jdk-sapmachine-11*"') do set "_MAP[sapmachine-11]=c:\opt\%%d"
for /f %%d in ('dir /ad /b "c:\opt\jdk-sapmachine-17*"') do set "_MAP[sapmachine-17]=c:\opt\%%d"

for /f %%d in ('dir /ad /b "c:\opt\jdk-zulu-1.8*"') do set "_MAP[zulu-08]=c:\opt\%%d"
for /f %%d in ('dir /ad /b "c:\opt\jdk-zulu-11*"') do set "_MAP[zulu-11]=c:\opt\%%d"
for /f %%d in ('dir /ad /b "c:\opt\jdk-zulu-17*"') do set "_MAP[zulu-17]=C:\opt\%%d"

if not exist "%_ROOT_DIR%build.bat" (
    echo %_ERROR_LABEL% Batch file build.bat not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_BUILD_BAT=%_ROOT_DIR%build.bat"
goto :eof

:build_snapshot
set __DISTRO_NAME=%~1

set "__JAVA_HOME=!_MAP[%__DISTRO_NAME%]!"
if not exist "!__JAVA_HOME!\bin\java.exe" (
    echo %_ERROR_LABEL% Java executable not found ^(__JAVA_HOME="!__JAVA_HOME!"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
setlocal
set "JAVA_HOME=%__JAVA_HOME%"
echo.
call "%_BUILD_BAT%" -timer -verbose clean boot
call "%_BUILD_BAT%" -timer -verbose arch-only
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to create .tar.gz/.zip files in directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
echo JAVA_HOME="!JAVA_HOME!" DISTRO_NAME=%__DISTRO_NAME% 1>&2
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
goto :eof

:end
call :end_cleanup
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b 0

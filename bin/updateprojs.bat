@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do set _ROOT_DIR=%%~sf

rem file build.sbt
set _DOTTY_VERSION_OLD="0.16.0-RC3"
set _DOTTY_VERSION_NEW="0.17.0-RC1"

rem file project\build.properties
set _SBT_VERSION_OLD=sbt.version=1.2.7
set _SBT_VERSION_NEW=sbt.version=1.2.8

rem file project\plugins.sbt
rem see https://search.maven.org/artifact/ch.epfl.lamp/sbt-dotty/
set _SBT_DOTTY_VERSION_OLD="0.3.1"
set _SBT_DOTTY_VERSION_NEW="0.3.3"

rem file build.sc
set _MILL_DOTTY_VERSION_OLD="0.16.0-RC3"
set _MILL_DOTTY_VERSION_NEW="0.17.0-RC1"

rem ##########################################################################
rem ## Main

for %%i in (examples myexamples) do (
    if %_DEBUG%==1 echo [%_BASENAME%] call :update_project "%_ROOT_DIR%\%%i"
    call :update_project "%_ROOT_DIR%\%%i"
)
goto end

rem ##########################################################################
rem ## Subroutines

:replace
set __FILE=%~1
set __PATTERN_FROM=%~2
set __PATTERN_TO=%~3

set __PS1_SCRIPT= ^
(Get-Content '%__FILE%') ^| ^
Foreach { $_.Replace('%__PATTERN_FROM%', '%__PATTERN_TO%') } ^| ^
Set-Content '%__FILE%'

if %_DEBUG%==1 echo [%_BASENAME%] powershell -C "%__PS1_SCRIPT%"
powershell -C "%__PS1_SCRIPT%"
if not %ERRORLEVEL%==0 (
    echo Error: Execution of ps1 cmdlet failed 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:update_project
set __PARENT_DIR=%~1
set __N1=0
set __N2=0
set __N3=0
set __N4=0
echo Parent directory: %__PARENT_DIR%
for /f %%i in ('dir /ad /b "%__PARENT_DIR%"') do (
    set __BUILD_SBT=%__PARENT_DIR%\%%i\build.sbt
    if exist "!__BUILD_SBT!" (
        if %_DEBUG%==1 echo [%_BASENAME%] call :replace "!__BUILD_SBT!" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%"
        call :replace "!__BUILD_SBT!" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%"
        set /a __N1+=1
    ) else (
       echo    Warning: Could not find file %%i\build.sbt 1>&2
    )
    set __BUILD_PROPS=%__PARENT_DIR%\%%i\project\build.properties
    if exist "!__BUILD_PROPS!" (
        if %_DEBUG%==1 echo [%_BASENAME%] call :replace "!__BUILD_PROPS!" "%_SBT_VERSION_OLD%" "%_SBT_VERSION_NEW%"
        call :replace "!__BUILD_PROPS!" "%_SBT_VERSION_OLD%" "%_SBT_VERSION_NEW%"
        set /a __N2+=1
    ) else (
       echo    Warning: Could not find file %%i\project\build.properties 1>&2
    )
    set __PLUGINS_SBT=%__PARENT_DIR%\%%i\project\plugins.sbt
    if exist "!__PLUGINS_SBT!" (
        if %_DEBUG%==1 echo [%_BASENAME%] call :replace "!__PLUGINS_SBT!" "%_SBT_DOTTY_VERSION_OLD%" "%_SBT_DOTTY_VERSION_NEW%"
        call :replace "!__PLUGINS_SBT!" "%_SBT_DOTTY_VERSION_OLD%" "%_SBT_DOTTY_VERSION_NEW%"
        set /a __N3+=1
    ) else (
       echo    Warning: Could not find file %%i\project\plugins.sbt 1>&2
    )
	set __BUILD_SC=%__PARENT_DIR%\%%i\build.sc
    if exist "!__BUILD_SC!" (
        if %_DEBUG%==1 echo [%_BASENAME%] call :replace "!__BUILD_SC!" "%_MILL_DOTTY_VERSION_OLD%" "%_MILL_DOTTY_VERSION_NEW%"
        call :replace "!__BUILD_SC!" "%_MILL_DOTTY_VERSION_OLD%" "%_MILL_DOTTY_VERSION_NEW%"
        set /a __N4+=1
    ) else (
       echo    Warning: Could not find file %%i\build.sc 1>&2
    )
)
echo    Updated %__N1% build.sbt files
echo    Updated %__N2% project\build.properties files
echo    Updated %__N3% project\plugins.sbt files
echo    Updated %__N4% build.sc files
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal

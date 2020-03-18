@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do set _ROOT_DIR=%%~sf
rem remove trailing backslash for virtual drives
if "%_ROOT_DIR:~-2%"==":\" set "_ROOT_DIR=%_ROOT_DIR:~0,-1%"

rem files build.sbt, build.sc and ivy.xml
set _DOTTY_VERSION_OLD="0.22.0-RC1"
set _DOTTY_VERSION_NEW="0.23.0-RC1"

rem files project\build.properties
set _SBT_VERSION_OLD=sbt.version=1.3.7
set _SBT_VERSION_NEW=sbt.version=1.3.8

rem files project\plugins.sbt
rem see https://search.maven.org/artifact/ch.epfl.lamp/sbt-dotty/
set _SBT_DOTTY_VERSION_OLD="0.3.4"
set _SBT_DOTTY_VERSION_NEW="0.4.0"

rem files ivy.xml (NB. PS regex)
set _IVY_DOTTY_VERSION_OLD=^(dotty-[a-z]+^)_0.22
set _IVY_DOTTY_VERSION_NEW=$1_0.23

call :env
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

for %%i in (examples myexamples cdsexamples) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :update_project "%_ROOT_DIR%\%%i" 1>&2
    call :update_project "%_ROOT_DIR%\%%i"
)
goto end

rem ##########################################################################
rem ## Subroutines

rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:
goto :eof

:replace
set __FILE=%~1
set __PATTERN_FROM=%~2
set __PATTERN_TO=%~3

set __PS1_SCRIPT= ^
(Get-Content '%__FILE%') ^| ^
Foreach { $_ -replace '%__PATTERN_FROM%','%__PATTERN_TO%' } ^| ^
Set-Content '%__FILE%'

if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -C "%__PS1_SCRIPT%" 1>&2
powershell -C "%__PS1_SCRIPT%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Execution of ps1 cmdlet failed 1>&2
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
set __N5=0
echo Parent directory: %__PARENT_DIR%
for /f %%i in ('dir /ad /b "%__PARENT_DIR%" ^| findstr /v /c:"lib"') do (
    set "__BUILD_SBT=%__PARENT_DIR%\%%i\build.sbt"
    if exist "!__BUILD_SBT!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__BUILD_SBT!" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%" 1>&2
        call :replace "!__BUILD_SBT!" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%"
        set /a __N1+=1
    ) else (
       echo    Warning: Could not find file %%i\build.sbt 1>&2
    )
    set "__BUILD_PROPS=%__PARENT_DIR%\%%i\project\build.properties"
    if exist "!__BUILD_PROPS!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__BUILD_PROPS!" "%_SBT_VERSION_OLD%" "%_SBT_VERSION_NEW%" 1>&2
        call :replace "!__BUILD_PROPS!" "%_SBT_VERSION_OLD%" "%_SBT_VERSION_NEW%"
        set /a __N2+=1
    ) else (
       echo    Warning: Could not find file %%i\project\build.properties 1>&2
    )
    set "__PLUGINS_SBT=%__PARENT_DIR%\%%i\project\plugins.sbt"
    if exist "!__PLUGINS_SBT!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PLUGINS_SBT!" "%_SBT_DOTTY_VERSION_OLD%" "%_SBT_DOTTY_VERSION_NEW%" 1>&2
        call :replace "!__PLUGINS_SBT!" "%_SBT_DOTTY_VERSION_OLD%" "%_SBT_DOTTY_VERSION_NEW%"
        set /a __N3+=1
    ) else (
       echo    Warning: Could not find file %%i\project\plugins.sbt 1>&2
    )
	set "__BUILD_SC=%__PARENT_DIR%\%%i\build.sc"
    if exist "!__BUILD_SC!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__BUILD_SC!" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%" 1>&2
        call :replace "!__BUILD_SC!" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%"
        set /a __N4+=1
    ) else (
       echo    Warning: Could not find file %%i\build.sc 1>&2
    )
)
rem Configuration files common to all projects
set "__IVY_XML=%__PARENT_DIR%\ivy.xml"
if exist "%__IVY_XML%" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__IVY_XML%" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%" 1>&2
    call :replace "%__IVY_XML%" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%"
    set /a __N5+=1
	if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__IVY_XML%" "%_IVY_DOTTY_VERSION_OLD%" "%_IVY_DOTTY_VERSION_NEW%" 1>&2
	call :replace "%__IVY_XML%" "%_IVY_DOTTY_VERSION_OLD%" "%_IVY_DOTTY_VERSION_NEW%"
) else (
   echo    Warning: Could not find file %__IVY_XML% 1>&2
)

echo    Updated %__N1% build.sbt files
echo    Updated %__N2% project\build.properties files
echo    Updated %__N3% project\plugins.sbt files
echo    Updated %__N4% build.sc files
echo    Updated %__N5% ivy.xml files
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

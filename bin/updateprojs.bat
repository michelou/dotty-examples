@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

for %%f in ("%~dp0\.") do set "_ROOT_DIR=%%~dpf"
@rem remove trailing backslash for virtual drives
if "%_ROOT_DIR:~-2%"==":\" set "_ROOT_DIR=%_ROOT_DIR:~0,-1%"

@rem files build.sbt, build.sc and ivy.xml
set _DOTTY_VERSION_OLD="0.25.0-RC1"
set _DOTTY_VERSION_NEW="0.25.0-RC2"

@rem files project\build.properties
set _SBT_VERSION_OLD=sbt.version=1.3.11
set _SBT_VERSION_NEW=sbt.version=1.3.12

@rem files project\plugins.sbt
@rem see https://search.maven.org/artifact/ch.epfl.lamp/sbt-dotty/
set _SBT_DOTTY_VERSION_OLD="0.4.0"
set _SBT_DOTTY_VERSION_NEW="0.4.1"

@rem files ivy.xml (NB. PS regex)
set _IVY_DOTTY_VERSION_OLD=^(dotty-[a-z]+^)_0.24
set _IVY_DOTTY_VERSION_NEW=$1_0.25

set _IVY_TASTY_VERSION_OLD=^(tasty-[a-z]+^)_0.24
set _IVY_TASTY_VERSION_NEW=$1_0.25

@rem files pom.xml (NB. PS regex)
set _POM_DOTTY_VERSION_OLD=scala.version^>0.25.0-RC1
set _POM_DOTTY_VERSION_NEW=scala.version^>0.25.0-RC2

call :env
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

for %%i in (cdsexamples examples meta-examples myexamples) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :update_project "%_ROOT_DIR%\%%i" 1>&2
    call :update_project "%_ROOT_DIR%\%%i"
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0

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
set __N6=0
echo Parent directory: %__PARENT_DIR%
for /f %%i in ('dir /ad /b "%__PARENT_DIR%" ^| findstr /v /c:"lib"') do (
    set "__BUILD_SBT=%__PARENT_DIR%\%%i\build.sbt"
    if exist "!__BUILD_SBT!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__BUILD_SBT!" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%" 1>&2
        call :replace "!__BUILD_SBT!" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%"
        set /a __N1+=1
    ) else (
       echo    %_WARNING_LABEL% Could not find file %%i\build.sbt 1>&2
    )
    set "__BUILD_PROPS=%__PARENT_DIR%\%%i\project\build.properties"
    if exist "!__BUILD_PROPS!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__BUILD_PROPS!" "%_SBT_VERSION_OLD%" "%_SBT_VERSION_NEW%" 1>&2
        call :replace "!__BUILD_PROPS!" "%_SBT_VERSION_OLD%" "%_SBT_VERSION_NEW%"
        set /a __N2+=1
    ) else (
       echo    %_WARNING_LABEL% Could not find file %%i\project\build.properties 1>&2
    )
    set "__PLUGINS_SBT=%__PARENT_DIR%\%%i\project\plugins.sbt"
    if exist "!__PLUGINS_SBT!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__PLUGINS_SBT!" "%_SBT_DOTTY_VERSION_OLD%" "%_SBT_DOTTY_VERSION_NEW%" 1>&2
        call :replace "!__PLUGINS_SBT!" "%_SBT_DOTTY_VERSION_OLD%" "%_SBT_DOTTY_VERSION_NEW%"
        set /a __N3+=1
    ) else (
       echo    %_WARNING_LABEL% Could not find file %%i\project\plugins.sbt 1>&2
    )
    set "__BUILD_SC=%__PARENT_DIR%\%%i\build.sc"
    if exist "!__BUILD_SC!" (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "!__BUILD_SC!" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%" 1>&2
        call :replace "!__BUILD_SC!" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%"
        set /a __N4+=1
    ) else (
       echo    %_WARNING_LABEL% Could not find file %%i\build.sc 1>&2
    )
)
@rem Configuration files common to all projects
set "__IVY_XML=%__PARENT_DIR%\ivy.xml"
if exist "%__IVY_XML%" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__IVY_XML%" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%" 1>&2
    call :replace "%__IVY_XML%" "%_DOTTY_VERSION_OLD%" "%_DOTTY_VERSION_NEW%"
    set /a __N5+=1
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__IVY_XML%" "%_IVY_DOTTY_VERSION_OLD%" "%_IVY_DOTTY_VERSION_NEW%" 1>&2
    call :replace "%__IVY_XML%" "%_IVY_DOTTY_VERSION_OLD%" "%_IVY_DOTTY_VERSION_NEW%"
) else (
   echo    %_WARNING_LABEL% Could not find file %__IVY_XML% 1>&2
)
set "__POM_XML=%__PARENT_DIR%\pom.xml"
if exist "%__POM_XML%" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__POM_XML%" "%_POM_DOTTY_VERSION_OLD%" "%_POM_DOTTY_VERSION_NEW%" 1>&2
    call :replace "%__POM_XML%" "%_POM_DOTTY_VERSION_OLD%" "%_POM_DOTTY_VERSION_NEW%"
    set /a __N6+=1
    @rem e.g. dotty-library_0.25
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__POM_XML%" "%_IVY_DOTTY_VERSION_OLD%" "%_IVY_DOTTY_VERSION_NEW%" 1>&2
    call :replace "%__POM_XML%" "%_IVY_DOTTY_VERSION_OLD%" "%_IVY_DOTTY_VERSION_NEW%"
    @rem e.g. tasty-core_0.25
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :replace "%__POM_XML%" "%_IVY_TASTY_VERSION_OLD%" "%_IVY_TASTY_VERSION_NEW%" 1>&2
    call :replace "%__POM_XML%" "%_IVY_TASTY_VERSION_OLD%" "%_IVY_TASTY_VERSION_NEW%"
) else (
   echo    %_WARNING_LABEL% Could not find file %__POM_XML% 1>&2
)

call :message %__N1% "build.sbt"
call :message %__N2% "project\build.properties"
call :message %__N3% "project\plugins.sbt"
call :message %__N4% "build.sc"
call :message %__N5% "ivy.xml"
call :message %__N6% "pom.xml"
goto :eof

@rem input parameters: %1=nr of updates, %2=file name
:message
set __N=%~1
set __FILE_NAME=%~2
if %__N% gtr 1 ( set __STR=files ) else ( set __STR=file )
echo    Updated %__N% %__FILE_NAME% %__STR%
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

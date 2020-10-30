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

if defined _HELP (
    call :help
    exit /b !_EXITCODE!
)
if exist "%SCALA3_HOME%\lib\" (
    call :search "%SCALA3_HOME%\lib" 1
    if not !_EXITCODE!==0 goto end
)
if exist "%SCALA_HOME%\lib\" (
    call :search "%SCALA_HOME%\lib" 1
    if not !_EXITCODE!==0 goto end
)
if exist "%JAVA_HOME%\lib\" (
    @rem get rid of surrounding double quotes if any
    for %%i in (%JAVA_HOME%) do set "__JAVA_HOME=%%~i"
    call :search "!__JAVA_HOME!\lib"
    if not !_EXITCODE!==0 goto end
)
if exist "%JAVA_HOME%\jre\lib\" (
    call :search "%JAVA_HOME%\jre\lib"
    if not !_EXITCODE!==0 goto end
)
if exist "%JAVAFX_HOME%\lib\" (
    call :search "%JAVAFX_HOME%\lib"
    if not !_EXITCODE!==0 goto end
)
if exist "%CD%\lib\*" (
    call :search "%CD%\lib" 1
    if not !_EXITCODE!==0 goto end
)
if defined _IVY if exist "%USERPROFILE%\.ivy2\" (
    call :search "%USERPROFILE%\.ivy2\cache" 1
    if not !_EXITCODE!==0 goto end
)
if defined _MAVEN if exist "%USERPROFILE%\.m2\" (
    call :search "%USERPROFILE%\.m2\repository" 1
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
@rem                    _JAR_CMD, _JAVA_HOME, _SCALA3_HOME, _SCALA_HOME
:env
set _BASENAME=%~n0
for %%f in ("%~dp0..") do set "_ROOT_DIR=%%~dpf"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

if not exist "%JAVA_HOME%\bin\jar.exe" (
    echo %_ERROR_LABEL% Java SDK installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_JAR_CMD=%JAVA_HOME%\bin\jar.exe"
set "_JAVAP_CMD=%JAVA_HOME%\bin\javap.exe"

if not exist "%SCALA3_HOME%\lib\scala3-library_*.jar" (
    echo %_ERROR_LABEL% Scala 3 installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if not exist "%SCALA_HOME%\lib\scala-library.jar" (
    echo %_ERROR_LABEL% Scala 2 installation not found 1>&2
    set _EXITCODE=1
    goto :eof
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
@rem output parameter: _HELP, _VERBOSE
:args
set _CLASS_NAME=
set _IVY=
set _MAVEN=
set _METH_NAME=
set _HELP=
set _VERBOSE=0

:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-artifact" ( set _IVY=1& set _MAVEN=1
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-ivy" ( set _IVY=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-maven" ( set _MAVEN=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto :args_done
    )
) else (
    if not defined _CLASS_NAME ( set _CLASS_NAME=%__ARG%
    ) else if not defined _METH_NAME ( set _METH_NAME=%__ARG%
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto :args_done
    )
)
shift
goto args_loop
:args_done
if %_DEBUG%==1 echo %_DEBUG_LABEL% _CLASS_NAME=%_CLASS_NAME% _METH_NAME=%_METH_NAME% _MAVEN=%_MAVEN% 1>&2
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
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> } ^<class_name^> [ ^<meth_name^> ]%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-artifact%__END%        include %__BEG_O%~\.ivy2%__END% and %__BEG_O%~\.m2%__END% directories
echo     %__BEG_O%-debug%__END%           show commands executed by this script
echo     %__BEG_O%-help%__END%            display this help message
echo     %__BEG_O%-ivy%__END%             include %__BEG_O%~\.ivy%__END% directory
echo     %__BEG_O%-maven%__END%           include %__BEG_O%~\.m2%__END% directory
echo     %__BEG_O%-verbose%__END%         display download progress
echo.
echo   %__BEG_P%Arguments:%__END%
echo     %__BEG_O%^<class_name^>%__END%     class name
goto :eof

@rem input parameter: %1=lib directory, %2=traverse recursively
:search
set __LIB_DIR=%~1
set __RECURSIVE=%~2

if defined __RECURSIVE ( set __DIR_OPTS=/s /b
) else ( set __DIR_OPTS=/b
)
echo Searching for class name %_CLASS_NAME% in archive files !__LIB_DIR:%USERPROFILE%=%%USERPROFILE%%!\*.jar
for /f %%i in ('dir %__DIR_OPTS% "%__LIB_DIR%\*.jar" 2^>NUL') do (
    if defined __RECURSIVE ( set "__JAR_FILE=%%i"
    ) else ( set "__JAR_FILE=%__LIB_DIR%\%%i"
    )
    for %%f in (!__JAR_FILE!) do set _JAR_FILENAME=%%~nxf
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_JAR_CMD% -tvf "!__JAR_FILE!" ^| findstr ".*%_CLASS_NAME%.*\.class$" 1>&2
    ) else if %_VERBOSE%==1 ( echo Search for class name %_CLASS_NAME% in archive !__JAR_FILE! 1>&2
    )
    for /f "delims=" %%f in ('powershell -c "%_JAR_CMD% -tvf "!__JAR_FILE!" | Where {$_.endsWith('class') -And $_.split('/.')[-2].contains('%_CLASS_NAME%')}"') do (
        for %%x in (%%f) do set __LAST=%%x
        if defined _METH_NAME (
            set __CLASS_NAME=!__LAST:~0,-6!
            if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_JAVAP_CMD% -cp "!__JAR_FILE!" "!__CLASS_NAME:/=.!" ^| findstr "%_METH_NAME%" 1>&2
            else if %_VERBOSE%==1 ( echo Search for method %_METH_NAME% in class !__CLASS_NAME:/=.! 1>&2
            )
            for /f "delims=" %%y in ('%_JAVAP_CMD% -cp "!__JAR_FILE!" "!__CLASS_NAME:/=.!" ^| findstr "%_METH_NAME%"') do (
                echo   !_JAR_FILENAME!:!__LAST!
                echo   %%y
            )
        ) else (
            echo   !_JAR_FILENAME!:!__LAST!
        )
    )
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

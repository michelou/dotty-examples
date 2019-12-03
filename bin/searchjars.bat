@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do set _ROOT_DIR=%%~sf

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

if defined _HELP (
    call :help
    exit /b !_EXITCODE!
)
if exist "%_DOTTY_HOME%\lib\" (
    call :search "%_DOTTY_HOME%\lib" 1
    if not !_EXITCODE!==0 goto end
)
if exist "%_SCALA_HOME%\lib\" (
    call :search "%_SCALA_HOME%\lib" 1
    if not !_EXITCODE!==0 goto end
)
if exist "%_JAVA_HOME%\lib\" (
    call :search "%_JAVA_HOME%\lib"
    if not !_EXITCODE!==0 goto end
)
if exist "%_JAVA_HOME%\jre\lib\" (
    call :search "%_JAVA_HOME%\jre\lib"
    if not !_EXITCODE!==0 goto end
)
for /f %%f in ('cd') do set _CWD=%%~sf
if exist "%_CWD%\lib\*" (
    call :search "%_CWD%\lib" 1
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

rem ##########################################################################
rem ## Subroutines

rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
rem                    _JAR_CMD, _JAVA_HOME, _DOTTY_HOME, _SCALA_HOME
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

where /q jar.exe
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% jar command not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _JAR_CMD=jar.exe
set _JAVAP_CMD=javap.exe
for /f "delims=" %%i in ('where "%_JAR_CMD%"') do (
    for %%f in ("%%~dpi..") do set _JAVA_HOME=%%~sf
)
if not exist "%_JAVA_HOME%\lib\" (
    echo %_ERROR_LABEL% Java library directory not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)

rem determine location of Dotty installation directory
where /q dotc.bat
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% dotc command not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims=" %%i in ('where dotc.bat') do (
    for %%f in ("%%~dpi..") do set _DOTTY_HOME=%%~sf
)
if not exist "%_DOTTY_HOME%\lib\" (
    echo %_ERROR_LABEL% Dotty library directory not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)

rem determine location of Scala installation directory
where /q scalac.bat
if not %ERRORLEVEL%==0 (
    echo Error: scalac command not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims=" %%i in ('where scalac.bat') do (
    for %%f in ("%%~dpi..") do set _SCALA_HOME=%%~sf
)
if not exist "%_SCALA_HOME%\lib\" (
    echo %_ERROR_LABEL% Scala library directory not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

rem input parameter: %*
rem output parameter: _HELP, _VERBOSE
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
    rem option
    if /i "%__ARG%"=="-artifact" ( set _IVY=1& set _MAVEN=1
    ) else if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-ivy" ( set _IVY=1
    ) else if /i "%__ARG%"=="-help" ( set _HELP=1
    ) else if /i "%__ARG%"=="-maven" ( set _MAVEN=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
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
echo Usage: %_BASENAME% { ^<option^> } ^<class_name^> [ ^<meth_name^> ]
echo.
echo   Options:
echo     -artifact        include ~\.ivy2 and ~\.m2 directories
echo     -help            display this help message
echo     -ivy             include ~\.ivy directory
echo     -maven           include ~\.m2 directory
echo     -verbose         display download progress
echo.
echo   Arguments:
echo     ^<class_name^>     class name
goto :eof

rem input parameter: %1=lib directory, %2=traverse recursively
:search
set __LIB_DIR=%~1
set __RECURSIVE=%~2

if defined __RECURSIVE ( set __DIR_OPTS=/s /b
) else ( set __DIR_OPTS=/b
)
echo Searching for class %_CLASS_NAME% in library files !__LIB_DIR:%USERPROFILE%=%%USERPROFILE%%!\*.jar
for /f %%i in ('dir %__DIR_OPTS% "%__LIB_DIR%\*.jar" 2^>NUL') do (
    if defined __RECURSIVE ( set __JAR_FILE=%%i
    ) else ( set __JAR_FILE=%__LIB_DIR%\%%i
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

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

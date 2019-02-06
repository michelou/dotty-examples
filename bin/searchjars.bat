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

rem ##########################################################################
rem ## Main

call :init
if not %_EXITCODE%==0 goto end

call :search "%_DOTTY_HOME%\lib" 1
if not %_EXITCODE%==0 goto end

call :search "%_SCALA_HOME%\lib" 1
if not %_EXITCODE%==0 goto end

call :search "%_JAVA_HOME%\lib"
if not %_EXITCODE%==0 goto end

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
set __ARG=%~1
if not defined __ARG goto args_done
if /i "%__ARG%"=="-artifact" ( set _IVY=1& set _MAVEN=1
) else if /i "%__ARG%"=="-ivy" ( set _IVY=1
) else if /i "%__ARG%"=="-help" ( set _HELP=1& goto :eof
) else if /i "%__ARG%"=="-maven" ( set _MAVEN=1
) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
) else (
    if not defined _CLASS_NAME ( set _CLASS_NAME=%__ARG%
    ) else if not defined _METH_NAME ( set _METH_NAME=%__ARG%
    ) else (
        echo [91mError[0m: Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto :args_done
    )
)
shift
goto args_loop
:args_done
if %_DEBUG%==1 echo [%_BASENAME%] _CLASS_NAME=%_CLASS_NAME% _METH_NAME=%_METH_NAME%
goto :eof

:help
echo Usage: %_BASENAME% { options ^| subcommands }
echo   Options:
echo     -artifact        include ~\.ivy2 and ~\.m2 directories
echo     -help            display this help message
echo     -ivy             include ~\.ivy directory
echo     -maven           include ~\.m2 directory
echo     -verbose         display download progress
echo   Arguments:
echo     ^<class_name^>     class name
goto :eof

rem output parameters: _JAR_CMD, _JAVA_HOME, _DOTTY_HOME, _SCALA_HOME
:init
where /q jar.exe
if not %ERRORLEVEL%==0 (
    echo [91mError[0m: jar command not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _JAR_CMD=jar.exe
set _JAVAP_CMD=javap.exe
for /f "delims=" %%i in ('where "%_JAR_CMD%"') do (
    for %%f in ("%%~dpi..") do set _JAVA_HOME=%%~sf
)
if not exist "%_JAVA_HOME%\lib\" (
    echo [91mError[0m: Java library directory not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)

rem determine location of Dotty installation directory
where /q dotc.bat
if not %ERRORLEVEL%==0 (
    echo [91mError[0m: dotc command not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims=" %%i in ('where dotc.bat') do (
    for %%f in ("%%~dpi..") do set _DOTTY_HOME=%%~sf
)
if not exist "%_DOTTY_HOME%\lib\" (
    echo [91mError[0m: Dotty library directory not found ^(check your PATH variable^) 1>&2
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
    echo [91mError[0m: Scala library directory not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

rem input parameter: %1=lib directory
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
    if %_DEBUG%==1 echo [%_BASENAME%] %_JAR_CMD% -tvf "!__JAR_FILE!" ^| findstr ".*%_CLASS_NAME%.*\.class$"
    for /f "delims=" %%f in ('powershell -c "%_JAR_CMD% -tvf "!__JAR_FILE!" | Where {$_.endsWith('class') -And $_.split('/.')[-2].contains('%_CLASS_NAME%')}"') do (
        for %%x in (%%f) do set __LAST=%%x
        if defined _METH_NAME (
            set __CLASS_NAME=!__LAST:~0,-6!
		    if %_VERBOSE%==1 echo Searching for method %_METH_NAME% in class !__CLASS_NAME:/=.!
            if %_DEBUG%==1 echo [%_BASENAME%] %_JAVAP_CMD% -cp "!__JAR_FILE!" "!__CLASS_NAME:/=.!" ^| findstr "%_METH_NAME%"
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
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal

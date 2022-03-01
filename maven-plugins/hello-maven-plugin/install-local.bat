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

call :install
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

set "_TEST_DIR=%_ROOT_DIR%test"

set _DEBUG_LABEL=[%_BASENAME%]
set _ERROR_LABEL=Error:

if not exist "%MAVEN_HOME%\bin\mvn.cmd" (
    echo %_ERROR_LABEL% Maven installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MVN_CMD=%MAVEN_HOME%\bin\mvn.cmd"
goto :eof

:install
set __JAR_FILE=
for /f "delims=" %%f in ('dir /b /s "%_TARGET_DIR%\*.jar"') do set "__JAR_FILE=%%f"
if not defined __JAR_FILE (
    echo %_ERROR_LABEL% JAR artifact not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __GROUP_ID=sample.plugin
set __ARTIFACT_ID=hello-maven-plugin
set __VERSION=1.0-SNAPSHOT

set "__LOCAL_REPO=%_TEST_DIR%\lib"

if %_DEBUG%==1 ( echo "%_MVN_CMD%" %_MVN_OPTS% install:install-file "-Dfile=%__JAR_FILE%" "-DgroupId=%__GROUP_ID%" "-DartifactId=%__ARTIFACT_ID%" ... 1>&2
) else if %_VERBOSE%==1 ( echo Install artifact "!__JAR_FILE:%_ROOT_DIR%=!" 1>&2
)
call "%_MVN_CMD%" %_MVN_OPTS% install:install-file "-Dfile=%__JAR_FILE%" "-DgroupId=%__GROUP_ID%" "-DartifactId=%__ARTIFACT_ID%" "-Dversion=%__VERSION%" -Dpackaging=jar -DcreateChecksum=true "-DlocalRepositoryPath=%__LOCAL_REPO%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to install Java archive file 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
exit /b %_EXITCODE%
endlocal

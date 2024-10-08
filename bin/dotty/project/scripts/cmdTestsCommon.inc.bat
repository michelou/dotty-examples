@rem #########################################################################
@rem ## This code is called in build.bat, cmdTests.bat and bootstrapCmdTest.bat

@rem Flag set to ensure common code is run only once
set __COMMON__=

set _BOT_TOKEN=dotty-token

set _SOURCE=tests\pos\HelloWorld.scala
set _MAIN=HelloWorld
set _TASTY=HelloWorld.tasty
set _EXPECTED_OUTPUT=hello world

if exist "C:\Temp\" ( set _TMP_DIR=C:\Temp
) else ( set "_TMP_DIR=%TEMP%"
)
set "_OUT_DIR=%_TMP_DIR%\scala3_out"
if not exist "%_OUT_DIR%" mkdir "%_OUT_DIR%"

set "_OUT1_DIR=%_TMP_DIR%\scala3_out1"
if not exist "%_OUT1_DIR%" mkdir "%_OUT1_DIR%"

set "_TMP_FILE=%_TMP_DIR%\scala3_tmp.txt"

where /q git.exe
if not %ERRORLEVEL%==0 (
    echo Error: Git command not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem full path
for /f "delims=" %%i in ('where git.exe') do set "_GIT_CMD=%%i"

where /q sbt.bat
if not %ERRORLEVEL%==0 (
    echo Error: SBT command not found ^(check your PATH variable^) 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem full path is required for sbt to run successfully
for /f "delims=" %%i in ('where sbt.bat') do set "_SBT_CMD=%%i"

@rem see file project/scripts/sbt
@rem SBT uses the value of the JAVA_OPTS environment variable if defined, rather than the config.
set JAVA_OPTS=-Xmx4096m ^
-XX:ReservedCodeCacheSize=2048m

set "_USER_HOME=%USERPROFILE%"
for /f "delims=\" %%i in ('subst ^| findstr /e "%_USER_HOME%"') do (
    set _USER_HOME=%%i
)
set SBT_OPTS=-Xmx4096m ^
-XX:ReservedCodeCacheSize=512m ^
-Ddotty.drone.mem=4096m ^
-Dsbt.ivy.home=%_USER_HOME%\.ivy2\ ^
-DSBT_PGP_USE_GPG=false ^
-Dsbt.log.noformat=true

@rem this batch file was executed successfully
set __COMMON__=1

@rem ## Batch file based on shell script project/scripts/cmdTests.

@echo off
setlocal enabledelayedexpansion

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

@rem # check that `sbt scalac` compiles and `sbt scala` runs it
echo testing sbt scalac and scala
call "%_SBT_CMD%" ";scalac %_SOURCE% -d %_OUT_DIR% ;scala -classpath %_OUT_DIR% %_MAIN%" > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 (
    if exist "%_TMP_FILE%" type "%_TMP_FILE%" | findstr /b "\[error\]"
    set _EXITCODE=1& goto end
)
call :grep "%_EXPECTED_OUTPUT%" "%_TMP_FILE%"
if not %_EXITCODE%==0 goto end

@rem # check that `sbt scalac` compiles and `sbt scala` runs it
echo testing sbt scalac -from-tasty and scala -classpath
call :clear_out "%_OUT_DIR%"
call "%_SBT_CMD%" ";scalac %_SOURCE% -d %_OUT_DIR% ;scalac -from-tasty -classpath %_OUT_DIR% -d %_OUT1_DIR% %_MAIN% ;scala -classpath %_OUT1_DIR% %_MAIN%" > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 (
    if exist "%_TMP_FILE%" type "%_TMP_FILE%" | findstr /b "\[error\]"
    set _EXITCODE=1& goto end
)
call :grep "%_EXPECTED_OUTPUT%" "%_TMP_FILE%"
if not %_EXITCODE%==0 goto end

echo testing sbt scalac -from-tasty from a jar and scala -classpath
call :clear_out "%_OUT_DIR%"
call "%_SBT_CMD%" ";scalac -d %_OUT_DIR%\out.jar %_SOURCE% ;scalac -from-tasty -d %_OUT1_DIR% %_OUT_DIR%\out.jar ;scala -classpath %_OUT1_DIR% %_MAIN%" > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 (
    if exist "%_TMP_FILE%" type "%_TMP_FILE%" | findstr /b "\[error\]"
    set _EXITCODE=1& goto end
)
call :grep "%_EXPECTED_OUTPUT%" "%_TMP_FILE%"
if not %_EXITCODE%==0 goto end

@rem # check that `sbt scalac -decompile` runs
echo testing sbt scalac -decompile
call "%_SBT_CMD%" ";scalac %_SOURCE% -d %_OUT_DIR% ;scalac -decompile -color:never -classpath %_OUT_DIR% %_MAIN%" > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 (
    if exist "%_TMP_FILE%" type "%_TMP_FILE%" | findstr /b "\[error\]"
    set _EXITCODE=1& goto end
)
call :grep "def main(args: scala.Array\[scala.Predef.String\]): scala.Unit =" "%_TMP_FILE%"
if not %_EXITCODE%==0 goto end

echo testing sbt scalac -decompile from file
call "%_SBT_CMD%" ";scalac -decompile -color:never -classpath %_OUT_DIR% %_OUT_DIR%\%_TASTY%" > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 (
    if exist "%_TMP_FILE%" type "%_TMP_FILE%" | findstr /b "\[error\]"
    set _EXITCODE=1& goto end
)
call :grep "def main(args: scala.Array\[scala.Predef.String\]): scala.Unit =" "%_TMP_FILE%"
if not %_EXITCODE%==0 goto end

echo testing sbt scala with no -classpath
call :clear_out "%_OUT_DIR%"
call "%_SBT_CMD%" ";scalac %_SOURCE% ; scala %_MAIN%" > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 (
    if exist "%_TMP_FILE%" type "%_TMP_FILE%" | findstr /b "\[error\]"
    set _EXITCODE=1& goto end
)
call :grep "%_EXPECTED_OUTPUT%" "%_TMP_FILE%"
if not %_EXITCODE%==0 goto end

echo testing loading tasty from .tasty file in jar
call :clear_out "%_OUT_DIR%"
call "%_SBT_CMD%" ";scalac -d %_OUT_DIR%\out.jar %_SOURCE%; scalac -decompile -classpath %_OUT_DIR%\out.jar -color:never %_MAIN%" > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 (
    if exist "%_TMP_FILE%" type "%_TMP_FILE%" | findstr /b "\[error\]"
    set _EXITCODE=1& goto end
)
call :grep "def main(args: scala.Array\[scala.Predef.String\]): scala.Unit =" "%_TMP_FILE%"
if not %_EXITCODE%==0 goto end

echo testing sbt scalac with suspension
call :clear_out "%_OUT_DIR%"
call "%_SBT_CMD%" "scala3-compiler-bootstrapped/scalac -d %_OUT_DIR% tests/pos-macros/macros-in-same-project-1/Bar.scala tests/pos-macros/macros-in-same-project-1/Foo.scala" > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 (
    if exist "%_TMP_FILE%" type "%_TMP_FILE%" | findstr /b "\[error\]"
    set _EXITCODE=1& goto end
)

@rem # check that missing source file does not crash message rendering
echo testing that missing source file does not crash message rendering
call :clear_out "%_OUT_DIR%"
call :clear_out "%_OUT1_DIR%"
@rem https://stackoverflow.com/questions/33752732/xcopy-still-asking-f-file-d-directory-confirmation
echo F | xcopy /f /q /y "%_ROOT_DIR%\tests\neg\i6371\A_1.scala" "%_OUT_DIR%\A.scala" 1>NUL
echo F | xcopy /f /q /y "%_ROOT_DIR%\tests\neg\i6371\B_2.scala" "%_OUT_DIR%\B.scala" 1>NUL
call "%_SBT_CMD%" "scalac %_OUT_DIR%\A.scala -d %_OUT1_DIR%"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )
del /q "%_OUT_DIR%\A.scala"
call "%_SBT_CMD%" "scalac -classpath %_OUT1_DIR% -d %_OUT1_DIR% %_OUT_DIR%\B.scala" > "%_TMP_FILE%" 2>&1 || ( set ERRORLEVEL=0& echo "ok" )
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )
call :grep "B.scala:2:7" "%_TMP_FILE%"
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

:env
for %%f in ("%~dp0..") do set "_ROOT_DIR=%%~dpf"
set "_SCRIPTS_DIR=%_ROOT_DIR%\project\scripts"

if not defined __COMMON__ (
    call "%_SCRIPTS_DIR%\cmdTestsCommon.inc.bat"
    if not !_EXITCODE!==0 goto :eof
)
goto :eof

:clear_out
set "__OUT_DIR=%~1"

if exist "%__OUT_DIR%\" (
    del /s /q "%__OUT_DIR%\*" 1>NUL
)
goto :eof

:grep 
set __PATTERN=%~1
set "__FILE=%~2"

findstr "%__PATTERN%" "%__FILE%"
if not %ERRORLEVEL%==0 (
    echo Error: Failed to find pattern "%__PATTERN%" in file "%__FILE%" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
exit /b %_EXITCODE%
endlocal



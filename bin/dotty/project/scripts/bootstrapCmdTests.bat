@rem ## Batch file based on bash script project/scripts/bootstrapCmdTests.

@echo off
setlocal enabledelayedexpansion

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

@rem # check that benchmarks can run
call "%_SBT_CMD%" "dotty-bench/jmh:run 1 1 tests/pos/alias.scala"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )

@rem # The above is here as it relies on the bootstrapped library.
call "%_SBT_CMD%" "dotty-bench-bootstrapped/jmh:run 1 1 tests/pos/alias.scala"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )

call "%_SBT_CMD%" "dotty-bench-bootstrapped/jmh:run 1 1 -with-compiler compiler/src/dotty/tools/dotc/core/Types.scala"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )

echo testing scala.quoted.Expr.run from sbt dotr
call "%_SBT_CMD%" ";dotty-compiler-bootstrapped/dotc tests/run-staging/quote-run.scala; dotty-compiler-bootstrapped/dotr -with-compiler Test" > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )
call :grep "val a: scala.Int = 3" "%_TMP_FILE%"
if not %_EXITCODE%==0 goto end

@rem # setup for `dotc`/`dotr` script tests
call "%_SBT_CMD%" dist/pack
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )

@rem # check that `dotc` compiles and `dotr` runs it
echo testing ./bin/dotc and ./bin/dotr
call :clear_out "%_OUT_DIR%"
call %_BIN_DIR%\dotc.bat "%_SOURCE%" -d "%_OUT_DIR%"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )
call %_BIN_DIR%\dotr.bat -classpath "%_OUT_DIR%" "%_MAIN%" > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )
call :test_pattern "%_EXPECTED_OUTPUT%" "%_TMP_FILE%"
if not %_EXITCODE%==0 goto end

@rem # check that `dotc` and `dotr` works for staging
call :clear_out "%_OUT_DIR%"
call %_BIN_DIR%\dotc.bat tests/run-staging/i4044f.scala -d "%_OUT_DIR%"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )
call %_BIN_DIR%\dotr.bat -with-compiler -classpath "%_OUT_DIR%" Test > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )
call %_BIN_DIR%\dotd.bat -project Staging -siteroot "%_OUT_DIR%" "tests/run-staging/i4044f.scala"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )

rem # check that `dotc -from-tasty` compiles and `dotr` runs it
echo testing ./bin/dotc -from-tasty and dotr -classpath
call :clear_out "%_OUT1_DIR%"
call %_BIN_DIR%\dotc.bat -from-tasty -classpath "%_OUT_DIR%" -d "%_OUT1_DIR%" "%_MAIN%"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )
call %_BIN_DIR%\dotr.bat -classpath "%_OUT1_DIR%" "%_MAIN%" > "%_TMP_FILE%"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )
call :test_pattern "%_EXPECTED_OUTPUT%" "%_TMP_FILE%"
if not %_EXITCODE%==0 goto end

echo testing ./bin/dotd
call :clear_out "%_OUT_DIR%"
call %_BIN_DIR%\dotd.bat -project Hello -siteroot "%_OUT_DIR%" "%_SOURCE%"
if not %ERRORLEVEL%==0 ( set _EXITCODE=1& goto end )

goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0

for %%f in ("%~dp0..") do set "_ROOT_DIR=%%~dpf"
set "_SCRIPTS_DIR=%_ROOT_DIR%\project\scripts"
set "_BIN_DIR=%_ROOT_DIR%\bin"

if not defined __COMMON__ (
    call "%_SCRIPTS_DIR%\cmdTestsCommon.inc.bat"
    if not !_EXITCODE!==0 goto end
)
goto :eof

:clear_out
set __OUT_DIR=%~1

if exist "%__OUT_DIR%\" (
    del /s /q "%__OUT_DIR%\*" 1>NUL
)
goto :eof

:grep 
set __PATTERN=%~1
set __FILE=%~2

findstr "%__PATTERN%" "%__FILE%"
if not %ERRORLEVEL%==0 (
    echo Error: Failed to find pattern "%__PATTERN%" in file %__FILE% 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:test_pattern
set __PATTERN=%~1
set __FILE=%~2

set /p __PATTERN2=<"%__FILE%"
if not "%__PATTERN2%"=="%__PATTERN%" (
    echo Error: Failed to find pattern "%__PATTERN%" in file %__FILE% 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
exit /b %_EXITCODE%
endlocal

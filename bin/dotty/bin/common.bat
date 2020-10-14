@echo off
setlocal enabledelayedexpansion

@rem # Wrapper for the published dotc/dotr script that check for file changes
@rem # and use sbt to re build the compiler as needed.

@rem #########################################################################
@rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0.") do set "_ROOT_DIR=%%~dpf"

@rem # Marker file used to obtain the date of latest call to sbt-back
set "_VERSION=%_ROOT_DIR%dist\target\pack\VERSION"

@rem #########################################################################
@rem ## Main

@rem # Create the target if absent or if file changed in ROOT/compiler
call :new_files "%_VERSION%"

if exist "%_VERSION%" if %_NEW_FILES%==0 goto target
echo Building Dotty...
pushd "%_ROOT%"
call sbt.bat "dist/pack" 1>NUL 2>&1
popd

:target
call %*

goto end

@rem #########################################################################
@rem ## Subroutines

@rem input parameter: %1=version file
@rem Output parameter: _NEW_FILES
:new_files
set "__VERSION_FILE=%~1"

call :compile_required "%__VERSION_FILE%" "%_ROOT_DIR%compiler\*.java" "%_ROOT_DIR%compiler\*.scala"
set _NEW_FILES=%_COMPILE_REQUIRED%
goto :eof

@rem input parameter: 1=target file 2,3,..=path (wildcards accepted)
@rem output parameter: _COMPILE_REQUIRED
:compile_required
set "__TARGET_FILE=%~1"

set __PATH_ARRAY=
set __PATH_ARRAY1=
:compile_path
shift
set __PATH=%~1
if not defined __PATH goto :compile_next
set __PATH_ARRAY=%__PATH_ARRAY%,'%__PATH%'
set __PATH_ARRAY1=%__PATH_ARRAY1%,'!__PATH:%_ROOT_DIR%=!'
goto :compile_path

:compile_next
set __TARGET_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -path '%__TARGET_FILE%' -ea Stop | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
     set __TARGET_TIMESTAMP=%%i
)
set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -recurse -path %__PATH_ARRAY:~1% -ea Stop | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
    set __SOURCE_TIMESTAMP=%%i
)
call :newer %__SOURCE_TIMESTAMP% %__TARGET_TIMESTAMP%
set _COMPILE_REQUIRED=%_NEWER%
goto :eof

@rem output parameter: _NEWER
:newer
set __TIMESTAMP1=%~1
set __TIMESTAMP2=%~2

set __DATE1=%__TIMESTAMP1:~0,8%
set __TIME1=%__TIMESTAMP1:~-6%

set __DATE2=%__TIMESTAMP2:~0,8%
set __TIME2=%__TIMESTAMP2:~-6%

if %__DATE1% gtr %__DATE2% ( set _NEWER=1
) else if %__DATE1% lss %__DATE2% ( set _NEWER=0
) else if %__TIME1% gtr %__TIME2% ( set _NEWER=1
) else ( set _NEWER=0
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
exit /b %_EXITCODE%
endlocal
@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do set _ROOT_DIR=%%~sf

set _PS1_FILE=%_ROOT_DIR%\bin\%_BASENAME%.ps1
if not exist "%_PS1_FILE%" (
    echo Error: PS1 file %_PS1_FILE% not found 1>&2
    set _EXITCODE=1
    goto end
)

set _OUTPUT_DIR=%_ROOT_DIR%\nightly-jars
if not exist "%_OUTPUT_DIR%" mkdir "%_OUTPUT_DIR%"1>NUL

rem ##########################################################################
rem ## Main

if %_DEBUG%==1 echo [%_BASENAME%] powershell -ExecutionPolicy ByPass -File "%_PS1_FILE%"
for /f "delims=" %%i in ('powershell -ExecutionPolicy ByPass -File "%_PS1_FILE%"') do (
   set __URL=http://central.maven.org/maven2/%%i
   for %%f in ("%%i") do set __FILE_BASENAME=%%~nxf
   set __JAR_FILE=%_OUTPUT_DIR%\!__FILE_BASENAME!
   if %_DEBUG%==1 echo [%_BASENAME%] powershell -c "Invoke-WebRequest -Uri !__URL! -Outfile !__JAR_FILE!"
   powershell -c "$progressPreference='silentlyContinue';Invoke-WebRequest -Uri !__URL! -Outfile !__JAR_FILE!"
   if not !ERRORLEVEL!==0 (
       echo Error: Failed to download file !__JAR_FILE! 1>&2
       set _EXITCODE=1
       goto end
   )
)

goto end

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal

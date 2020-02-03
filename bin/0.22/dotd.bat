@echo off
setlocal enabledelayedexpansion

rem ##########################################################################
rem ## Environment setup

set _EXITCODE=0

for %%f in ("%~dp0..") do set _PROG_HOME=%%~sf

call %_PROG_HOME%\bin\common.bat
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

call :javaClassPath

"%_JAVACMD%" -Dscala.usejavacp=true -classpath "%_CLASS_PATH%" dotty.tools.dottydoc.Main %*
if not %ERRORLEVEL%==0 (
    rem echo Error: Dottydoc execution failed 1>&2
    set _EXITCODE=1
    goto end
)
goto end

rem ##########################################################################
rem ## Subroutines

rem output parameter: _CLASS_PATH
:javaClassPath
set __LIB_DIR=%_PROG_HOME%\lib

rem Set dotty-doc dep:
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*dotty-doc*"') do set _DOTTY_DOC_LIB=%__LIB_DIR%\%%f

rem Set flexmark deps:
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-0*"')                     do set _FLEXMARK_LIBS=%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-ext-anchorlink*"')        do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-ext-autolink*"')          do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-ext-emoji*"')             do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-ext-gfm-strikethrough*"') do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-ext-gfm-tables*"')        do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-ext-gfm-tasklist*"')      do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-ext-ins*"')               do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-ext-superscript*"')       do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-ext-tables*"')            do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-ext-wikilink*"')          do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-ext-yaml-front-matter*"') do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-formatter*"')             do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-jira-converter*"')        do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*flexmark-util*"')                  do set _FLEXMARK_LIBS=%_FLEXMARK_LIBS%%__LIB_DIR%\%%f%_PSEP%

rem Set jackson deps:
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*jackson-annotations*"')     do set _JACKSON_LIBS=%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*jackson-core*"')            do set _JACKSON_LIBS=%_JACKSON_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*jackson-databind*"')        do set _JACKSON_LIBS=%_JACKSON_LIBS%%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*jackson-dataformat-yaml*"') do set _JACKSON_LIBS=%_JACKSON_LIBS%%__LIB_DIR%\%%f%_PSEP%

rem Set liqp dep:
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*liqp*"') do set _LIQP_LIB=%__LIB_DIR%\%%f%_PSEP%

rem Set ANTLR dep:
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*antlr-3*"') do set _ANTLR_LIB=%__LIB_DIR%\%%f%_PSEP%
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*antlr-runtime-3*"') do set _ANTLR_RUNTIME_LIB=%__LIB_DIR%\%%f%_PSEP%

rem Set autolink dep:
rem conflict with flexmark-ext-autolink-0.11
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*autolink-0.6*"') do set _AUTOLINK_LIB=%__LIB_DIR%\%%f

rem Set snakeyaml dep:
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*snakeyaml*"') do set _SNAKEYAML_LIB=%__LIB_DIR%\%%f%_PSEP%

rem Set ST4 dep:
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*ST4*"') do set _ST4_LIB=%__LIB_DIR%\%%f%_PSEP%

rem Set jsoup dep:
for /f %%f in ('dir /a-d /b "%__LIB_DIR%\*jsoup*"') do set _JSOUP_LIB=%__LIB_DIR%\%%f%_PSEP%

set _CLASS_PATH=%_DOTTY_LIB%%_PSEP%%_DOTTY_COMP%%_PSEP%%_TASTY_CORE%%_PSEP%%_DOTTY_DOC_LIB%%_PSEP%%_DOTTY_INTF%%_PSEP%%_SBT_INTF%%_PSEP%%_DOTTY_STAGING%
set _CLASS_PATH=%_CLASS_PATH%%_PSEP%%_SCALA_LIB%
set _CLASS_PATH=%_CLASS_PATH%%_PSEP%%_FLEXMARK_LIBS%
set _CLASS_PATH=%_CLASS_PATH%%_PSEP%%_JACKSON_LIBS%
set _CLASS_PATH=%_CLASS_PATH%%_PSEP%%_LIQP_LIB%
set _CLASS_PATH=%_CLASS_PATH%%_PSEP%%_ANTLR_LIB%%_PSEP%%_ANTLR_RUNTIME_LIB%
set _CLASS_PATH=%_CLASS_PATH%%_PSEP%%_AUTOLINK_LIB%
set _CLASS_PATH=%_CLASS_PATH%%_PSEP%%_SNAKEYAML_LIB%
set _CLASS_PATH=%_CLASS_PATH%%_PSEP%%_ST4_LIB%
set _CLASS_PATH=%_CLASS_PATH%%_PSEP%%_JSOUP_LIB%
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
exit /b %_EXITCODE%
endlocal

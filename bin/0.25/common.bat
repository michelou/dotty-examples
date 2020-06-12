rem ##########################################################################
rem ## Code common to dotc.bat, dotd.bat and dotr.bat

if defined JAVACMD (
    set _JAVACMD=%JAVACMD%
) else if defined JAVA_HOME (
    set _JAVACMD=%JAVA_HOME%\bin\java.exe
) else if defined JDK_HOME (
    set _JAVACMD=%JDK_HOME%\bin\java.exe
) else (
    where /q java.exe
    if !ERRORLEVEL!==0 (
        set __JAVA_BIN_DIR=
        for /f "delims=" %%i in ('where /f java.exe') do (
            set __PATH=%%~dpsi
            rem we take first occurence and ignore Oracle path for java executable
            if not defined __JAVA_BIN_DIR if "!__PATH!"=="!__PATH:javapath=!" set "__JAVA_BIN_DIR=!__PATH!"
        )
        if defined __JAVA_BIN_DIR set "_JAVACMD=!__JAVA_BIN_DIR!\java.exe"
    )
    if not defined _JAVACMD (
        set "__PATH=%ProgramFiles%\Java"
        for /f %%f in ('dir /ad /b "!__PATH!\jre*" 2^>NUL') do set "_JAVA_HOME=!__PATH!\%%f"
        if not defined _JAVA_HOME (
           set __PATH=C:\opt
           for /f %%f in ('dir /ad /b "!__PATH!\jdk*" 2^>NUL') do set "_JAVA_HOME=!__PATH!\%%f\jre"
        )
        if defined _JAVA_HOME set "_JAVACMD=!_JAVA_HOME!\bin\java.exe"
    )
)
if not exist "%_JAVACMD%" (
   echo Error: Java executable not found ^(%_JAVACMD%^) 1>&2
   set _EXITCODE=1
   goto :eof
)

if defined DOTTY_HOME (
    set _LIB_DIR=%DOTTY_HOME%\lib
) else (
    if not defined _PROG_HOME for %%f in ("%~dp0..") do set _PROG_HOME=%%~sf
    set _LIB_DIR=!_PROG_HOME!\lib
)

set _PSEP=;

for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*dotty-compiler*"')        do set _DOTTY_COMP=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*dotty-interfaces*"')      do set _DOTTY_INTF=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*dotty-library*"')         do set _DOTTY_LIB=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*dotty-staging*"')         do set _DOTTY_STAGING=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*dotty-tasty-inspector*"') do set _DOTTY_TASTY_INSPECTOR=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*tasty-core*"')            do set _TASTY_CORE=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*scala-asm*"')             do set _SCALA_ASM=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*scala-library*"')         do set _SCALA_LIB=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*compiler-interface*"')    do set _SBT_INTF=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*jline-reader-3*"')        do set _JLINE_READER=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*jline-terminal-3*"')      do set _JLINE_TERMINAL=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*jline-terminal-jna-3*"')  do set _JLINE_TERMINAL_JNA=%_LIB_DIR%\%%f
for /f %%f in ('dir /a-d /b "%_LIB_DIR%\*jna-5*"')                 do set _JNA=%_LIB_DIR%\%%f

rem debug
set _DEBUG_STR=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005

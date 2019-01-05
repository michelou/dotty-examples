@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _BASENAME=%~n0

set _EXITCODE=0

for %%f in ("%~dp0..") do set _ROOT_DIR=%%~sf

set _OUT_DIR=%_ROOT_DIR%\out\data-sharing
if not exist "%_OUT_DIR%" mkdir "%_OUT_DIR%"

set _LOG_DIR=%_OUT_DIR%\logs
if not exist "%_LOG_DIR%" mkdir "%_LOG_DIR%"

set _CDS_NAME=dotty-cds

set _COMPILER_NAME=%_CDS_NAME%-compiler
set _COMPILER_CLASSLIST_FILE=%_OUT_DIR%\%_COMPILER_NAME%.classlist
set _COMPILER_CLASSLIST_LOG_FILE=%_LOG_DIR%\%_COMPILER_NAME%_classlist.log
set _COMPILER_JSA_FILE=%_OUT_DIR%\%_COMPILER_NAME%.jsa
set _COMPILER_JSA_LOG_FILE=%_LOG_DIR%\%_COMPILER_NAME%-jsa.log

set _REPL_NAME=%_CDS_NAME%-repl
set _REPL_CLASSLIST_FILE=%_OUT_DIR%\%_REPL_NAME%.classlist
set _REPL_CLASSLIST_LOG_FILE=%_LOG_DIR%\%_REPL_NAME%_classlist.log
set _REPL_JSA_FILE=%_OUT_DIR%\%_REPL_NAME%.jsa
set _REPL_JSA_LOG_FILE=%_LOG_DIR%\%_REPL_NAME%_jsa.log
set _REPL_SHARE_LOG_FILE=%_LOG_DIR%\%_REPL_NAME%-share.log

set _MAIN_CLASS_NAME=Main
set _MAIN_PKG_NAME=cds
set _APP_MAIN_CLASS=%_MAIN_PKG_NAME%.%_MAIN_CLASS_NAME%
set _APP_JAR_FILE=%_OUT_DIR%\%_CDS_NAME%.jar

call :args %*
if not %_EXITCODE%==0 goto end
if defined _HELP call :help & exit /b %_EXITCODE%

rem ##########################################################################
rem ## Main

call :init
if not %_EXITCODE%==0 goto end

if defined _DUMP_ONLY (
    call :dump
    if not !_EXITCODE!==0 goto end
    goto end
)

if defined _TEST_ONLY (
    call :test
    if not %_EXITCODE%==0 goto end
    goto end
)

if defined _ACTIVATE (
    call :dump
    if not %_EXITCODE%==0 goto end

    call :test
    if not %_EXITCODE%==0 goto end

    call :activate
    if not %_EXITCODE%==0 goto end
) else if defined _RESET (
    call :reset
    if not %_EXITCODE%==0 goto end
)
goto end

rem ##########################################################################
rem ## Subroutines

rem input parameter: %*
rem output parameter: _HELP, _VERBOSE, _SHARE_FLAG, _SHARE_TEXT
:args
set _HELP=
set _ACTIVATE=
set _DUMP_ONLY=
set _RESET=
set _SHARE_FLAG=off
set _TEST_ONLY=
set _VERBOSE=0

:args_loop
set __ARG=%~1
if not defined __ARG goto args_done
if /i "%__ARG%"=="help" ( set _HELP=1& goto :eof
) else if /i "%__ARG%"=="activate" ( set _ACTIVATE=1
) else if /i "%__ARG%"=="dump" ( set _DUMP_ONLY=1
) else if /i "%__ARG%"=="reset" ( set _RESET=1
) else if /i "%__ARG%"=="test" ( set _TEST_ONLY=1
) else if /i "%__ARG%"=="-debug" ( set _DEBUG=1
) else if /i "%__ARG%"=="-share" ( set _SHARE_FLAG=on
) else if /i "%__ARG%"=="-share:on" ( set _SHARE_FLAG=on
) else if /i "%__ARG%"=="-share:off" ( set _SHARE_FLAG=off
) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
) else (
    echo Error: Unknown subcommand %__ARG% 1>&2
    set _EXITCODE=1
    goto :eof
)
shift
goto args_loop
:args_done
if /i "%_SHARE_FLAG%"=="on" ( set _SHARE_TEXT=WITH
) else ( set _SHARE_TEXT=[41mWITHOUT[0m
)
goto :eof

:help
echo Usage: %_BASENAME% { options ^| subcommands }
echo   Options:
echo     -share[:on^|off]  set the share flag (default:off)
echo     -verbose         display generation progress
echo   Subcommands:
echo     activate         install the Java shared archive
echo     dump             create the Java shared archive
echo     help             display this help message
echo     reset            uninstall the Java share archive
echo     test             execute test application (depends on dump)
goto :eof

rem output parameters: _JAVAC_CMD, _JAVA_HOME, _JAVA_CLASSLIST_FILE, _DOTTY_HOME, _CDS_INSTALL_NAME
:init
where /q javac.exe
if not %ERRORLEVEL%==0 (
    echo Error: Java compiler not found ^(run setenv.bat^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _JAVAC_CMD=javac.exe
set _JAR_CMD=jar.exe

where /q java.exe
if not %ERRORLEVEL%==0 (
    echo Error: Java executable not found ^(run setenv.bat^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _JAVA_CMD=java.exe

for /f %%i in ('where "%_JAVA_CMD%" ^| findstr /v javapath') do (
    for %%f in ("%%~dpi..") do set _JAVA_HOME=%%~sf
)

set __JAVA_11=
for /f "tokens=1,2,3,*" %%i in ('%_JAVA_CMD% -version 2^>^&1 ^| findstr version 2^>^&1') do (
    set __JAVA_VERSION=%%~k
    for /f %%j in ('echo %%~k ^| findstr "^1[1-9]\. ^1[1-9]-ea" 2^>NUL') do set __JAVA_11=1
)
if not defined __JAVA_11 (
    echo Error: Java 11 LTS or newer is required ^(found %__JAVA_VERSION%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _JAVA_CLASSLIST_FILE=%_JAVA_HOME%\lib\classlist
if not exist "%_JAVA_CLASSLIST_FILE%" (
    echo Error: File not found ^(%_JAVA_CLASSLIST_FILE%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
where /q dotc.bat
if not %ERRORLEVEL%==0 (
    echo Error: Scala compiler not found ^(run setenv.bat^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _COMPILER_CMD=dotc.bat
set _REPL_CMD=dotr.bat

for /f %%i in ('where "%_COMPILER_CMD%"') do (
    for %%f in ("%%~dpi..") do set _DOTTY_HOME=%%~sf
)
for /f %%i in ('dir /b /a-d "%_DOTTY_HOME%\lib\dotty-library*.jar"') do set _LIB_NAME=%%~ni
if not exist "%_DOTTY_HOME%\lib\%_LIB_NAME%.jar" (
    echo Error: Installation directory not found ^(%_DOTTY_HOME%\lib^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _CDS_INSTALL_NAME=%_LIB_NAME:library=cds%
goto :eof

rem globals: _COMPILER_CMD, _JAR_CMD, _REPL_CMD, _OUT_DIR, _COMPILER_JSA_FILE, _REPL_JSA_FILE
:dump
set __SRC_DIR=%_OUT_DIR%\src\%_MAIN_PKG_NAME%
if not exist "%__SRC_DIR%" mkdir "%__SRC_DIR%"

set __SOURCE_FILE=%__SRC_DIR%\%_MAIN_CLASS_NAME%.scala
(
    echo package %_MAIN_PKG_NAME%
    echo object %_MAIN_CLASS_NAME% {
    echo   def main(args: Array[String]^): Unit = {
    echo     println("Support files for Java class sharing:"^)
    echo     val jarUrl = getClass^(^).getProtectionDomain(^).getCodeSource(^).getLocation(^)
    echo     val libDir = java.nio.file.Paths.get(jarUrl.toURI(^)^).getParent(^).toFile(^)
    echo     val files = libDir.listFiles.filter^(_.getName.startsWith("%_CDS_NAME%"^)^)
    echo     files.foreach(f =^> println("   "+f.getName(^)+" ("+(f.length(^)/1024^)+" Kb)"^)^)
    echo   }
    echo }
) > %__SOURCE_FILE%

set __CLASSES_DIR=%_OUT_DIR%\classes
if not exist "%__CLASSES_DIR%" mkdir "%__CLASSES_DIR%"

set __JAVA_TOOL_OPTS="-J-XX:DumpLoadedClassList=%_COMPILER_CLASSLIST_FILE%"
if %_DEBUG%==1 (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-J-Xlog:class+path=info"
) else if %_VERBOSE%==1 (
    rem !!! Ignore drive letter (temporary hack, see JDK-8215398)
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-J-Xlog:class+path:file=%_COMPILER_CLASSLIST_LOG_FILE:~2%"
) else (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! -J-Xlog:disable
)
if %_DEBUG%==1 ( echo [%_BASENAME%] call %_COMPILER_CMD% %__JAVA_TOOL_OPTS% -d %__CLASSES_DIR% %__SOURCE_FILE%
) else ( echo Create class list file !_COMPILER_CLASSLIST_FILE:%_ROOT_DIR%\=!
)
call %_COMPILER_CMD% %__JAVA_TOOL_OPTS% -d %__CLASSES_DIR% %__SOURCE_FILE%
if not %ERRORLEVEL%==0 (
    echo Error: Failed to compile source file %__SOURCE_FILE% 1>&2
    set _EXITCODE=1
    goto :eof
)

set __MANIFEST_FILE=%_OUT_DIR%\MANIFEST.MF
(
    echo Manifest-Version: 1.0
    echo Built-By: %USERNAME%
    echo Build-Jdk: %_JAVA_VERSION%
    echo Specification-Title: %_MAIN_PKG_NAME%
    echo Specification-Version: 0.1-SNAPSHOT
    echo Implementation-Title: %_MAIN_PKG_NAME%
    echo Implementation-Version: 0.1-SNAPSHOT
    echo Main-Class: %_APP_MAIN_CLASS%
) > %__MANIFEST_FILE%
if %_DEBUG%==1 ( echo [%_BASENAME%] %_JAR_CMD% cfm %_APP_JAR_FILE% %__MANIFEST_FILE% -C %__CLASSES_DIR% .
) else if %_VERBOSE%==1 ( echo Create Java archive !_APP_JAR_FILE:%_ROOT_DIR%=!
)
%_JAR_CMD% cfm %_APP_JAR_FILE% %__MANIFEST_FILE% -C %__CLASSES_DIR% .
if not %ERRORLEVEL%==0 (
    echo Error: Failed to generate Java archive %_APP_JAR_FILE% 1>&2
    set _EXITCODE=1
    goto :eof
)

if %_DEBUG%==1 ( set __REDIRECT_STDOUT=
) else ( set __REDIRECT_STDOUT=1^>NUL
)

set __JAVA_TOOL_OPTS=-J-Xshare:dump "-J-XX:SharedClassListFile=%_COMPILER_CLASSLIST_FILE%" -J-XX:+UnlockDiagnosticVMOptions "-J-XX:SharedArchiveFile=%_COMPILER_JSA_FILE%"
if %_DEBUG%==1 (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-J-Xlog:class+path=info"
) else if %_VERBOSE%==1 (
    rem !!! We ignore drive letter in file path (temporary hack, see JDK-8215398)
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-J-Xlog:class+path:file=%_COMPILER_JSA_LOG_FILE:~2%"
) else (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! -J-Xlog:disable
)
if %_DEBUG%==1 ( echo [%_BASENAME%] call %_COMPILER_CMD% %__JAVA_TOOL_OPTS% -d %__CLASSES_DIR% %__SOURCE_FILE%
) else ( echo Create Java shared archive !_COMPILER_JSA_FILE:%_ROOT_DIR%\=!
)
call %_COMPILER_CMD% %__JAVA_TOOL_OPTS% -d %__CLASSES_DIR% %__SOURCE_FILE% %__REDIRECT_STDOUT%
if not %ERRORLEVEL%==0 (
    echo Error: Failed to compile source file %__SOURCE_FILE% 1>&2
    set _EXITCODE=1
    goto :eof
)

set __JAVA_TOOL_OPTS="-J-XX:DumpLoadedClassList=%_REPL_CLASSLIST_FILE%"
if %_DEBUG%==1 (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-J-Xlog:class+path=info"
) else if %_VERBOSE%==1 (
    rem !!! We ignore drive letter in file path (temporary hack, see JDK-8215398)
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-J-Xlog:class+path:file=%_REPL_CLASSLIST_LOG_FILE:~2%"
) else (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! -J-Xlog:disable
)
if %_DEBUG%==1 ( echo [%_BASENAME%] call %_REPL_CMD% %__JAVA_TOOL_OPTS% -classpath %__CLASSES_DIR% %_APP_MAIN_CLASS%
) else ( echo Create class list file !_REPL_CLASSLIST_FILE:%_ROOT_DIR%\=!
)
call %_REPL_CMD% %__JAVA_TOOL_OPTS% -classpath %__CLASSES_DIR% %_APP_MAIN_CLASS% %__REDIRECT_STDOUT%
if not %ERRORLEVEL%==0 (
    echo Error: Failed to execute Scala class %_APP_MAIN_CLASS% 1>&2
    set _EXITCODE=1
    goto :eof
)

set __JAVA_TOOL_OPTS=-J-Xshare:dump "-J-XX:SharedClassListFile=%_REPL_CLASSLIST_FILE%" -J-XX:+UnlockDiagnosticVMOptions "-J-XX:SharedArchiveFile=%_REPL_JSA_FILE%"
if %_DEBUG%==1 (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-J-Xlog:class+path=info"
) else if %_VERBOSE%==1 (
    rem !!! We ignore drive letter in file path (temporary hack, see JDK-8215398)
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-J-Xlog:class+path:file=%_REPL_JSA_LOG_FILE:~2%"
) else (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! -J-Xlog:disable
)
set __CDS_JAR_FILE=%_DOTTY_HOME%\lib\%_CDS_INSTALL_NAME%.jar
copy /y "%_APP_JAR_FILE%" "%__CDS_JAR_FILE%" 1>NUL

if %_DEBUG%==1 ( echo [%_BASENAME%] call %_REPL_CMD% %__JAVA_TOOL_OPTS% -classpath %__CDS_JAR_FILE% %_APP_MAIN_CLASS%
) else ( echo Create Java shared archive !_REPL_JSA_FILE:%_ROOT_DIR%\=!
)
call %_REPL_CMD% %__JAVA_TOOL_OPTS% -classpath %__CDS_JAR_FILE% %_APP_MAIN_CLASS% %__REDIRECT_STDOUT%
if not %ERRORLEVEL%==0 (
    echo Error: Failed to execute Scala class %_APP_MAIN_CLASS% 1>&2
    set _EXITCODE=1
    goto :eof
)
rem Only subcommand 'activate' does modify Scala installation
del "%__CDS_JAR_FILE%" 1>NUL
goto :eof

:test
set __CDS_COPIED=0
set __CDS_JAR_FILE=%_DOTTY_HOME%\lib\%_CDS_INSTALL_NAME%.jar
if not exist "%__CDS_JAR_FILE%" (
    if not exist "%_APP_JAR_FILE%" (
        echo Error: Java archive file %__CDS_JAR_FILE% not found 1>&2
        echo ^(hint: run subcommand 'dump' first^)
        set _EXITCODE=1
        goto :eof
    )
    if %_DEBUG%==1 echo [%_BASENAME%] copy /y "%_APP_JAR_FILE%" "%__CDS_JAR_FILE%"
    copy /y "%_APP_JAR_FILE%" "%__CDS_JAR_FILE%" 1>NUL
    if %_DEBUG%==1 echo [%_BASENAME%] copy /y "%_OUT_DIR%\%_CDS_NAME%-*" "%_DOTTY_HOME%\lib\"
    copy /y "%_OUT_DIR%\%_CDS_NAME%*" "%_DOTTY_HOME%\lib\" 1>NUL
    set __CDS_COPIED=1
)

set __JAVA_TOOL_OPTS=-J-Xshare:%_SHARE_FLAG% -J-XX:+UnlockDiagnosticVMOptions "-J-XX:SharedArchiveFile=%_DOTTY_HOME%\lib\%_REPL_NAME%.jsa"
if %_DEBUG%==1 (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-J-Xlog:class+load=info"
) else if %_VERBOSE%==1 (
    rem !!! We ignore drive letter in file path (temporary hack, see JDK-8215398)
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-J-Xlog:class+load:file=%_REPL_SHARE_LOG_FILE:~2%"
) else (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! -J-Xlog:disable
)

if %_DEBUG%==1 ( echo [%_BASENAME%] call %_REPL_CMD% !__JAVA_TOOL_OPTS! -classpath %__CDS_JAR_FILE% %_APP_MAIN_CLASS%
) else if %_VERBOSE%==1 ( echo Execute test application with Scala REPL %_SHARE_TEXT% Java shared archive
)
call %_REPL_CMD% !__JAVA_TOOL_OPTS! -classpath %__CDS_JAR_FILE% %_APP_MAIN_CLASS%
if not %ERRORLEVEL%==0 (
    if %__CDS_COPIED%==1 del "%_DOTTY_HOME%\lib\%_CDS_NAME%*"
    rem Error message below is redundant
    rem echo Error: Failed to execute test application %_APP_MAIN_CLASS% 1>&2
    set _EXITCODE=1
    goto :eof
)
if %__CDS_COPIED%==1 del "%_DOTTY_HOME%\lib\%_CDS_NAME%*"

if %_VERBOSE%==1 (
    if %_DEBUG%==1 echo [%_BASENAME%] call :stats "%_REPL_SHARE_LOG_FILE%"
    call :stats "%_REPL_SHARE_LOG_FILE%"
)
goto :eof

rem input parameter: %1=share log file
:stats
set __SHARE_LOG_FILE=%~1
if not exist "%__SHARE_LOG_FILE%" (
    echo Error: Share log file %__SHARE_LOG_FILE% not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __N_SHARED=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr shared "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr shared "%__SHARE_LOG_FILE%"') do (
    set /a __N_SHARED+=1
    if %_DEBUG%==1 echo %%i
)
set __N_FILE=0
set __FILE_URLS=
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"file:/" "%__SHARE_LOG_FILE%"
for /f "tokens=1,*" %%i in ('findstr /c:"file:/" "%__SHARE_LOG_FILE%"') do (
    set /a __N_FILE+=1
    if %_DEBUG%==1 echo %%j
	if !__N_FILE! lss 2 ( set __FILE_URLS=!__FILE_URLS! %%j
	) else if not "!__FILE_URLS:...=!"=="!__FILE_URLS!" ( set __FILE_URLS=!__FILE_URLS! ...
	)
)
set __N_JRT=0
set __JRT_URLS=
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"jrt:/" "%__SHARE_LOG_FILE%"
for /f "tokens=1,*" %%i in ('findstr /c:"jrt:/" "%__SHARE_LOG_FILE%"') do (
    set /a __N_JRT+=1
    if %_DEBUG%==1 echo %%j
    if !__N_JRT! lss 2 ( set __JRT_URLS=!__JRT_URLS! %%j
    ) else if not "!__JRT_URLS:...=!"=="!__JRT_URLS!" ( set __JRT_URLS=!__JRT_URLS! ...
    )
)

set __N_MAIN=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] %_MAIN_PKG_NAME%." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] %_MAIN_PKG_NAME%." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: %_MAIN_PKG_NAME%."') do (
    set /a __N_MAIN+=1
)

rem Java libraries
set __N_JAVA_IO=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] java.io." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] java.io." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.io."') do (
    set /a __N_JAVA_IO+=1
)
set __N_JAVA_LANG=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] java.lang." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] java.lang." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.lang."') do (
    set /a __N_JAVA_LANG+=1
)
set __N_JAVA_NET=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] java.net." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] java.net." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.net."') do (
    set /a __N_JAVA_NET+=1
)
set __N_JAVA_NIO=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] java.nio." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] java.nio." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.nio."') do (
    set /a __N_JAVA_NIO+=1
)
set __N_JAVA_SECURITY=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] java.security." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] java.security." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.security."') do (
    set /a __N_JAVA_SECURITY+=1
)
set __N_JAVA_UTIL=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] java.util." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] java.util." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.util."') do (
    set /a __N_JAVA_UTIL+=1
)
set __N_JDK=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] jdk." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] jdk." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: jdk."') do (
    set /a __N_JDK+=1
)
set __N_SUN=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] sun." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] sun." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: sun."') do (
    set /a __N_SUN+=1
)

rem Scala libraries
set __N_SCALA=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] scala." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] scala." "%__SHARE_LOG_FILE%" ^| findstr /v "scala.collection scala.io scala.math scala.reflect scala.runtime scala.sys scala.util"') do (
    set /a __N_SCALA+=1
)
set __N_SCALA_COLLECTION=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] scala.collection." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] scala.collection." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: scala.collection."') do (
    set /a __N_SCALA_COLLECTION+=1
)
set __N_SCALA_COMPAT=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] scala.compat." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] scala.compat." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: scala.compat."') do (
    set /a __N_SCALA_COMPAT+=1
)
set __N_SCALA_IO=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] scala.io." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] scala.io." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: scala.io."') do (
    set /a __N_SCALA_IO+=1
)
set __N_SCALA_MATH=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] scala.math." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] scala.math." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: scala.math."') do (
    set /a __N_SCALA_MATH+=1
)
set __N_SCALA_REFLECT=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] scala.reflect." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] scala.reflect." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: scala.reflect."') do (
    set /a __N_SCALA_REFLECT+=1
)
set __N_SCALA_RUNTIME=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] scala.runtime." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] scala.runtime." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: scala.runtime."') do (
    set /a __N_SCALA_RUNTIME+=1
)
set __N_SCALA_SYS=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] scala.sys." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] scala.sys." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: scala.sys."') do (
    set /a __N_SCALA_SYS+=1
)
set __N_SCALA_UTIL=0
if %_DEBUG%==1 echo [%_BASENAME%] findstr /c:"] scala.util." "%__SHARE_LOG_FILE%"
for /f "delims=" %%i in ('findstr /c:"] scala.util." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: scala.util."') do (
    set /a __N_SCALA_UTIL+=1
)

set __LOAD_TIME=999.999s
for /f "delims=[]" %%i in ('powershell -c "Get-Content %__SHARE_LOG_FILE% | select -Last 1"') do (
    set __LOAD_TIME=%%i
)
if "%_SHARE_FLAG%"=="off" ( set __FILE_TEXT=%__N_FILE%
) else if %__N_FILE% gtr 0 ( set __FILE_TEXT=%__N_FILE% ^(%__FILE_URLS:~1%^)
) else ( set __FILE_TEXT=%__N_FILE%
)
if "%_SHARE_FLAG%"=="off" ( set __JRT_TEXT=%__N_JRT%
) else if %__N_JRT% gtr 0 ( set __JRT_TEXT=%__N_JRT% ^(%__JRT_URLS:~1%^)
) else ( set __JRT_TEXT=%__N_JRT%
)
set /a __N_PACKAGES=__N_MAIN
rem Java libraries
set /a __N_PACKAGES=__N_PACKAGES+__N_JAVA_IO+__N_JAVA_LANG+__N_JAVA_NET+__N_JAVA_NIO
set /a __N_PACKAGES=__N_PACKAGES+__N_JAVA_SECURITY+__N_JAVA_UTIL+__N_JDK+__N_SUN
rem Scala libraries
set /a __N_PACKAGES=__N_PACKAGES+__N_SCALA+__N_SCALA_COLLECTION+__N_SCALA_COMPAT+__N_SCALA_IO
set /a __N_PACKAGES=__N_PACKAGES+__N_SCALA_MATH+__N_SCALA_REFLECT
set /a __N_PACKAGES=__N_PACKAGES+__N_SCALA_RUNTIME+__N_SCALA_SYS+__N_SCALA_UTIL
echo [96mStatistics ^(see !__SHARE_LOG_FILE:%_ROOT_DIR%\=!^)[0m
echo    Share flag      : %_SHARE_FLAG%
echo    Shared archive  : !_REPL_JSA_FILE:%_ROOT_DIR%\=!
echo    Shared classes  : %__N_SHARED%
echo    File classes    : %__FILE_TEXT%
echo    jrt images      : %__JRT_TEXT%
echo    Load time       : %__LOAD_TIME%
echo [96mClasses per package ^(!__N_PACKAGES!^):[0m
echo    java.io.* ^(%__N_JAVA_IO%^), java.lang.* ^(%__N_JAVA_LANG%^), java.net.* ^(%__N_JAVA_NET%^), java.nio.* ^(%__N_JAVA_NIO%^)
echo    java.security.* ^(%__N_JAVA_SECURITY%^), java.util.* ^(%__N_JAVA_UTIL%^), jdk.* ^(%__N_JDK%^), sun.* ^(%__N_SUN%^)
echo    [APP] %_MAIN_PKG_NAME%.* ^(%__N_MAIN%^)
echo    scala.* ^(%__N_SCALA%^), scala.collection.* ^(%__N_SCALA_COLLECTION%^), scala.compat.* ^(%__N_SCALA_COMPAT%^)
echo    scala.io.* ^(%__N_SCALA_IO%^), scala.math.* ^(%__N_SCALA_MATH%^), scala.reflect.* ^(%__N_SCALA_REFLECT%^)
echo    scala.runtime.* ^(%__N_SCALA_RUNTIME%^), scala.sys.* ^(%__N_SCALA_SYS%^), scala.util.* ^(%__N_SCALA_UTIL%^)
goto :eof

rem Add the Java shared archive to the Scala installation directory
rem globals: _APP_JAR_FILE, _COMPILER_CLASSLIST_FILE, _COMPILER_JSA_FILE, _REPL_CLASSLIST_FILE, _REPL_JSA_FILE
:activate
if not exist "%_APP_JAR_FILE%" (
    echo Error: Java archive  file %_APP_JAR_FILE% not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __CDS_JAR_FILE=%_DOTTY_HOME%\lib\%_CDS_INSTALL_NAME%.jar
if %_DEBUG%==1 echo [%_BASENAME%] copy "%_APP_JAR_FILE%" "%__CDS_JAR_FILE%"
copy /y "%_APP_JAR_FILE%" "%__CDS_JAR_FILE%" 1>NUL
if not exist "%_COMPILER_CLASSLIST_FILE%" (
    echo Error: Classlist file %_COMPILER_CLASSLIST_FILE% not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo [%_BASENAME%] copy "%_COMPILER_CLASSLIST_FILE%" "%_DOTTY_HOME%\lib\"
copy /y "%_COMPILER_CLASSLIST_FILE%" "%_DOTTY_HOME%\lib\" 1>NUL
if not %ERRORLEVEL%==0 (
    echo Error: Failed to copy %_COMPILER_CLASSLIST_FILE% to %_DOTTY_HOME%\lib\ 1>&2
    set _EXITCODE=1
    goto :eof
)

if not exist "%_COMPILER_JSA_FILE%" (
    echo Error: Java shared archive %_COMPILER_JSA_FILE% not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo [%_BASENAME%] copy "%_COMPILER_JSA_FILE%" "%_DOTTY_HOME%\lib\"
copy /y "%_COMPILER_JSA_FILE%" "%_DOTTY_HOME%\lib\" 1>NUL
if not %ERRORLEVEL%==0 (
    echo Error: Failed to copy %_COMPILER_JSA_FILE% to %_DOTTY_HOME%\lib\ 1>&2
    set _EXITCODE=1
    goto :eof
)

if not exist "%_REPL_CLASSLIST_FILE%" (
    echo Error: Classlist file %_REPL_CLASSLIST_FILE% not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo [%_BASENAME%] copy "%_REPL_CLASSLIST_FILE%" "%_DOTTY_HOME%\lib\"
copy /y "%_REPL_CLASSLIST_FILE%" "%_DOTTY_HOME%\lib\" 1>NUL
if not %ERRORLEVEL%==0 (
    echo Error: Failed to copy classlist file %_REPL_CLASSLIST_FILE% to %_DOTTY_HOME%\lib\ 1>&2
    set _EXITCODE=1
    goto :eof
)
if not exist "%_REPL_JSA_FILE%" (
    echo Error: Java shared archive %_REPL_JSA_FILE% not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo [%_BASENAME%] copy /y "%_REPL_JSA_FILE%" "%_DOTTY_HOME%\lib\"
copy /y "%_REPL_JSA_FILE%" "%_DOTTY_HOME%\lib\" 1>NUL
if not %ERRORLEVEL%==0 (
    echo Error: Failed to copy %_REPL_JSA_FILE% to %_DOTTY_HOME%\lib\ 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo [%_BASENAME%] copy "%_APP_JAR_FILE%" "%_DOTTY_HOME%\lib\%_CDS_INSTALL_NAME%.jar"
copy /y "%_APP_JAR_FILE%" "%_DOTTY_HOME%\lib\%_CDS_INSTALL_NAME%.jar" 1>NUL
if not %ERRORLEVEL%==0 (
    echo Error: Failed to copy %_CDS_INSTALL_NAME%.jar% to %_DOTTY_HOME%\lib\ 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:reset
set __N_REMOVED=0
for %%i in (%_COMPILER_NAME%.classlist %_COMPILER_NAME%.jsa %_REPL_NAME%.classlist %_REPL_NAME%.jsa %_CDS_INSTALL_NAME%.jar) do (
    if exist "%_DOTTY_HOME%\lib\%%i" (
        if %_DEBUG%==1 echo [%_BASENAME%] del "%_DOTTY_HOME%\lib\%%i"
        del "%_DOTTY_HOME%\lib\%%i"
        set /a __N_REMOVED+=1
    )
)
if %_VERBOSE%==1 (
   if %__N_REMOVED%==0 ( echo No file to delete in directory %_DOTTY_HOME%\lib
   ) else ( echo Deleted %__N_REMOVED% files in directory %_DOTTY_HOME%\lib
   )
)
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 echo [%_BASENAME%] _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal

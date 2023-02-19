@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :props
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)
if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    call :compile
    if not !_EXITCODE!==0 goto end
)
if %_DOC%==1 (
    call :doc
    if not !_EXITCODE!==0 goto end
)
if %_RUN%==1 (
    call :run
    if not !_EXITCODE!==0 goto end
)

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
@rem                    _SCALAC_CMD, _SCALADOC_CMD, _JAR_CMD, _JAVA_CMD, _RUN_CMD
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_DOCS_DIR=%_TARGET_DIR%\docs"
set "_CLASSES_DIR=%_TARGET_DIR%\classes"
set "_LOG_DIR=%_TARGET_DIR%\logs"

set _MAIN_CLASS_NAME=Main
set _MAIN_PKG_NAME=cdsexamples
set _MAIN_CLASS=%_MAIN_PKG_NAME%.%_MAIN_CLASS_NAME%

set _APP_NAME=JavaExample
set _APP_VERSION=1.0-SNAPSHOT

set "_JAR_FILE=%_TARGET_DIR%\%_APP_NAME%.jar"
set "_CLASSLIST_FILE=%_TARGET_DIR%\%_APP_NAME%.classlist"
set "_JSA_FILE=%_TARGET_DIR%\%_APP_NAME%.jsa"

if not exist "%JAVA_HOME%\bin\java.exe" (
    echo %_ERROR_LABEL% Java SDK installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_JAR_CMD=%JAVA_HOME%\bin\jar.exe"
set "_JAVA_CMD=%JAVA_HOME%\bin\java.exe"
set "_JAVAC_CMD=%JAVA_HOME%\bin\javac.exe"
set "_JAVADOC_CMD=%JAVA_HOME%\bin\javadoc.exe"

for /f "tokens=1,2,*" %%i in ('call "%_JAVA_CMD%" -XshowSettings 2^>^&1^|findstr /c:"java.version ="') do (
    set _JAVA_VERSION=%%k
)
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _RESET=[0m
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m
goto :eof

:props
set _RUN_ITER_DEFAULT=1
goto :eof

@rem input parameter: %*
:args
set _CLEAN=0
set _COMPILE=0
set _DOC=0
set _HELP=0
set _RUN=0
set _RUN_ARGS=
set _RUN_ITER=%_RUN_ITER_DEFAULT%
set _SHARE_FLAG=off
set _TIMER=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    @rem options
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG:~0,6%"=="-iter:" (
        call :iter "%__ARG:~6%"
        if not !_EXITCODE!==0 goto args_done
    ) else if "%__ARG%"=="-share" ( set _SHARE_FLAG=on
    ) else if "%__ARG%"=="-share:off" ( set _SHARE_FLAG=off
    ) else if "%__ARG%"=="-share:on" ( set _SHARE_FLAG=on
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommands
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if "%__ARG%"=="doc" ( set _DOC=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG:~0,4%"=="run:" (
        set _RUN_ARGS=%__ARG:~4%& set _COMPILE=1& set _RUN=1
    ) else if "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
if %_DEBUG%==1 ( set _REDIRECT_STDOUT=
) else ( set _REDIRECT_STDOUT=1^>NUL
)
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Properties : _JAVA_VERSION=%_JAVA_VERSION% 1>&2
    echo %_DEBUG_LABEL% Options    : _ITER=%_RUN_ITER% _SHARE=%_SHARE_FLAG% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DOC=%_DOC% _RUN=%_RUN% _RUN_ARGS=%_RUN_ARGS% 1>&2
    echo %_DEBUG_LABEL% Variables  : "JAVA_HOME=%JAVA_HOME%" 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __BEG_N=%_NORMAL_FG_YELLOW%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __BEG_N=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-iter:1..99%__END%        set number of run iterations ^(default:%__BEG_O%%_RUN_ITER_DEFAULT%%__END%^)
echo     %__BEG_O%-share[:^(on^|off^)]%__END%  enable/disable data sharing ^(default:%__BEG_O%off%__END%^)
echo     %__BEG_O%-timer%__END%             display total elapsed time
echo     %__BEG_O%-verbose%__END%           display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%              delete generated files
echo     %__BEG_O%compile%__END%            compile Java source files
echo     %__BEG_O%doc%__END%                generate HTML documentation
echo     %__BEG_O%help%__END%               display this help message
echo     %__BEG_O%run[:arg]%__END%          execute main class with 1 optional argument
goto :eof

:iter
set /a __ITER=%~1
if %__ITER% geq 100 set __ITER=0
if %__ITER% lss 1 (
    echo %_ERROR_LABEL% Iteration value "%~1" is out of range ^(0..99^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _RUN_ITER=%__ITER%
goto :eof

:clean
call :rmdir "%_TARGET_DIR%"
@rem mill -> out\, sbt -> project\target\
call :rmdir "%_ROOT_DIR%out"
call :rmdir "%_ROOT_DIR%project\target"
goto :eof

@rem input parameter: %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
if not exist "%_CLASSES_DIR%\" mkdir "%_CLASSES_DIR%" 1>NUL

set "__TIMESTAMP_FILE=%_CLASSES_DIR%\.latest-build"

call :action_required "%__TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\java\*.java"
if %_ACTION_REQUIRED%==0 goto :eof

set "__SOURCES_FILE=%_TARGET_DIR%\javac_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f %%i in ('dir /s /b "%_SOURCE_DIR%\main\java\*.java" 2^>NUL') do (
    echo %%i >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo "%_WARNING_LABEL% No Java source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% Java source files
) else ( set __N_FILES=%__N% Java source file
)
set "__OPTS_FILE=%_TARGET_DIR%\javac_opts.txt"
echo -deprecation -d "%_CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directory "!_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_JAVAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directory "!_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__MANIFEST_FILE=%_TARGET_DIR%\MANIFEST.MF"
(
    echo Manifest-Version: 1.0
    echo Built-By: %USERNAME%
    echo Build-Jdk: %_JAVA_VERSION%
    echo Specification-Title: %_MAIN_PKG_NAME%
    echo Specification-Version: %_APP_VERSION%
    echo Implementation-Title: %_MAIN_PKG_NAME%
    echo Implementation-Version: %_APP_VERSION%
    echo Main-Class: %_MAIN_CLASS%
) > "%__MANIFEST_FILE%"
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAR_CMD%" cfm "%_JAR_FILE%" "%__MANIFEST_FILE%" -C "%_CLASSES_DIR%" . 1>&2
) else if %_VERBOSE%==1 ( echo Create Java archive file "!_JAR_FILE:%_ROOT_DIR%=!" 1>&2
)
call "%_JAR_CMD%" cfm "%_JAR_FILE%" "%__MANIFEST_FILE%" -C "%_CLASSES_DIR%" .
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to generate Java archive file "%_JAR_FILE%" 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem Important: options containing an "=" character must be quoted
set __JAVA_TOOL_OPTS="-XX:DumpLoadedClassList=%_CLASSLIST_FILE%"
if %_DEBUG%==1 (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-Xlog:class+path^=info"
) else if %_VERBOSE%==1 (
    set "__LOG_FILE=%_LOG_DIR%\log_classlist.log"
    if not exist "%_LOG_DIR%\" mkdir "%_LOG_DIR%" 1>NUL
    @rem !!! Ignore drive letter (temporary hack, see JDK-8215398)
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-Xlog:class+path:file=!__LOG_FILE:~2!"
) else (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! -Xlog:disable
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVA_CMD%" %__JAVA_TOOL_OPTS% -jar %_JAR_FILE% 1>&2
) else if %_VERBOSE%==1 ( echo Create class list file !_CLASSLIST_FILE:%_ROOT_DIR%=! 1>&2
)
call "%_JAVA_CMD%" %__JAVA_TOOL_OPTS% -jar "%_JAR_FILE%" %_REDIRECT_STDOUT%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to create file %_CLASSLIST_FILE% 1>&2
    set _EXITCODE=1
    goto :eof
)
set __JAVA_TOOL_OPTS=-Xshare:dump "-XX:SharedClassListFile=%_CLASSLIST_FILE%" "-XX:SharedArchiveFile=%_JSA_FILE%"
if %_DEBUG%==1 (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-Xlog:class+path=info"
) else if %_VERBOSE%==1 (
    set "__LOG_FILE=%_LOG_DIR%\log_dump.log"
    if not exist "%_LOG_DIR%\" mkdir "%_LOG_DIR%" 1>NUL
    @rem !!! Ignore drive letter (temporary hack, see JDK-8215398)
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-Xlog:class+path:file=!__LOG_FILE:~2!"
) else (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! -Xlog:disable
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVA_CMD%" %__JAVA_TOOL_OPTS% -classpath %_JAR_FILE% 1>&2
) else if %_VERBOSE%==1 ( echo Create Java shared archive !_JSA_FILE:%_ROOT_DIR%=! 1>&2
)
call "%_JAVA_CMD%" %__JAVA_TOOL_OPTS% -classpath "%_JAR_FILE%" %_REDIRECT_STDOUT%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to create shared archive "%_JAR_FILE%" 1>&2
    set _EXITCODE=1
    goto :eof
)
echo. > "%__TIMESTAMP_FILE%"
goto :eof

@rem input parameter: 1=target file 2=path (wildcards accepted)
@rem output parameter: _ACTION_REQUIRED
:action_required
set __TARGET_FILE=%~1
set __PATH=%~2

set __TARGET_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -path '%__TARGET_FILE%' -ea Stop | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
     set __TARGET_TIMESTAMP=%%i
)
set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -recurse -path '%__PATH%' -ea Stop | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
    set __SOURCE_TIMESTAMP=%%i
)
call :newer %__SOURCE_TIMESTAMP% %__TARGET_TIMESTAMP%
set _ACTION_REQUIRED=%_NEWER%
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% %__TARGET_TIMESTAMP% Target : "%__TARGET_FILE%" 1>&2
    echo %_DEBUG_LABEL% %__SOURCE_TIMESTAMP% Sources: "%__PATH%" 1>&2
    echo %_DEBUG_LABEL% _ACTION_REQUIRED=%_ACTION_REQUIRED% 1>&2
) else if %_VERBOSE%==1 if %_ACTION_REQUIRED%==0 if %__SOURCE_TIMESTAMP% gtr 0 (
    echo No action required ^("!__PATH:%_ROOT_DIR%=!"^) 1>&2
)
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

:doc
if not exist "%_DOCS_DIR%" mkdir "%_DOCS_DIR%" 1>NUL

set __DOC_TIMESTAMP_FILE=%_DOCS_DIR%\.latest-build"

call :action_required "%__DOC_TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\java\*.java"
if %_ACTION_REQUIRED%==0 goto :eof

set "__SOURCES_FILE=%_TARGET_DIR%\javadoc_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
for /f %%i in ('dir /s /b "%_SOURCE_DIR%\main\java\*.java" 2^>NUL') do (
    echo %%i >> "%__SOURCES_FILE%"
)
set __OPTS_QUIET=
if not %_DEBUG%==1 if not %_VERBOSE%==1 set __OPTS_QUIET=-quiet
for %%i in ("%~dp0\.") do set __PROJECT=%%~ni
set "__OPTS_FILE=%_TARGET_DIR%\javadoc_opts.txt"
echo %__OPTS_QUIET% -d "%_DOCS_DIR:\=\\%" -windowtitle %__PROJECT% -doctitle "<h1>%__PROJECT%</h1>" > "%__OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVADOC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Generate HTML documentation into directory "!_DOCS_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_JAVADOC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to generate HTML documentation 1>&2
    set _EXITCODE=1
    goto :eof
)
echo. > "%__DOC_TIMESTAMP_FILE%"
goto :eof

:run
set __SHARE_LOG_FILE=%_LOG_DIR%\log_share_%_SHARE_FLAG%.log
@rem Important: options containing an "=" character must be quoted
set __JAVA_TOOL_OPTS=-Xshare:%_SHARE_FLAG% -XX:+UnlockDiagnosticVMOptions -XX:SharedArchiveFile=%_JSA_FILE%
if %_DEBUG%==1 (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-verbose:class"
) else if %_VERBOSE%==1 (
    if not exist "%_LOG_DIR%\" mkdir "%_LOG_DIR%" 1>NUL
    @rem !!! Ignore drive letter (temporary hack, see JDK-8215398)
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! "-Xlog:class+load:file=!__SHARE_LOG_FILE:~2!"
) else (
    set __JAVA_TOOL_OPTS=!__JAVA_TOOL_OPTS! -Xlog:disable
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAVA_CMD%" %__JAVA_TOOL_OPTS% -jar "%_JAR_FILE%" %_RUN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Java archive "!_JAR_FILE:%_ROOT_DIR%=!" %_RUN_ARGS% 1>&2
)
echo #iterations=%_RUN_ITER%
set __N=1
:run_iter
call "%_JAVA_CMD%" %__JAVA_TOOL_OPTS% -jar "%_JAR_FILE%" %_RUN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute class "%_MAIN_CLASS%" 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_VERBOSE%==1 (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% call :report "%__SHARE_LOG_FILE%" "%__N%" 1>&2
    call :report "%__SHARE_LOG_FILE%" "%__N%"
)
if %__N% lss %_RUN_ITER% (
    set /a __N+=1
    goto :run_iter
)
goto :eof

@rem input parameter: %1=share log file %2=n-th iteration
:report
set __SHARE_LOG_FILE=%~1
set __N=%~2
if not exist "%__SHARE_LOG_FILE%" (
    echo %_ERROR_LABEL% Share log file %__SHARE_LOG_FILE% not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __N_SHARED=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr shared "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr shared "%__SHARE_LOG_FILE%"') do (
    set /a __N_SHARED+=1
    if %_DEBUG%==1 echo %%i
)
set __N_FILE=0
set __FILE_URLS=
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"file:/" "%__SHARE_LOG_FILE%" 1>&2
for /f "tokens=1,*" %%i in ('findstr /c:"file:/" "%__SHARE_LOG_FILE%"') do (
    set /a __N_FILE+=1
    if %_DEBUG%==1 echo %%j
    if !__N_FILE! lss 2 ( set __FILE_URLS=!__FILE_URLS! %%j
    ) else if not "!__FILE_URLS:...=!"=="!__FILE_URLS!" ( set __FILE_URLS=!__FILE_URLS! ...
    )
)
set __N_JRT=0
set __JRT_URLS=
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"jrt:/" "%__SHARE_LOG_FILE%" 1>&2
for /f "tokens=1,*" %%i in ('findstr /c:"jrt:/" "%__SHARE_LOG_FILE%"') do (
    set /a __N_JRT+=1
    if %_DEBUG%==1 echo %%j 1>&2
    if !__N_JRT! lss 2 ( set __JRT_URLS=!__JRT_URLS! %%j
    ) else if not "!__JRT_URLS:...=!"=="!__JRT_URLS!" ( set __JRT_URLS=!__JRT_URLS! ...
    )
)

set __N_MAIN=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"] %_MAIN_PKG_NAME%." "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr /c:"] %_MAIN_PKG_NAME%." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: %_MAIN_PKG_NAME%."') do (
    set /a __N_MAIN+=1
)

@rem Java libraries
set __N_JAVA_IO=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"] java.io." "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr /c:"] java.io." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.io."') do (
    set /a __N_JAVA_IO+=1
)
set __N_JAVA_LANG=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"] java.lang." "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr /c:"] java.lang." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.lang."') do (
    set /a __N_JAVA_LANG+=1
)
set __N_JAVA_MATH=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"] java.math." "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr /c:"] java.math." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.math."') do (
    set /a __N_JAVA_MATH+=1
)
set __N_JAVA_NET=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"] java.net." "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr /c:"] java.net." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.net."') do (
    set /a __N_JAVA_NET+=1
)
set __N_JAVA_NIO=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"] java.nio." "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr /c:"] java.nio." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.nio."') do (
    set /a __N_JAVA_NIO+=1
)
set __N_JAVA_SECURITY=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"] java.security." "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr /c:"] java.security." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.security."') do (
    set /a __N_JAVA_SECURITY+=1
)
set __N_JAVA_UTIL=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"] java.util." "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr /c:"] java.util." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: java.util."') do (
    set /a __N_JAVA_UTIL+=1
)
set __N_JDK=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"] jdk." "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr /c:"] jdk." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: jdk."') do (
    set /a __N_JDK+=1
)
set __N_SUN=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"] sun." "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr /c:"] sun." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: sun."') do (
    set /a __N_SUN+=1
)

@rem Scala libraries
set __N_SCALA=0
if %_DEBUG%==1 echo %_DEBUG_LABEL% findstr /c:"] scala." "%__SHARE_LOG_FILE%" 1>&2
for /f "delims=" %%i in ('findstr /c:"] scala." "%__SHARE_LOG_FILE%" ^| findstr /v /c:"source: scala."') do (
    set /a __N_SCALA+=1
)
set __LOAD_TIME[%__N%]=999.999s
for /f "delims=[]" %%i in ('powershell -c "Get-Content %__SHARE_LOG_FILE% | select -Last 1"') do (
    set _T_SECS=%%i
    set __LOAD_TIME[%__N%]=!_T_SECS:s=!
)
if %__N% equ %_RUN_ITER% (
    if "%_SHARE_FLAG%"=="off" ( set __FILE_TEXT=%__N_FILE%
    ) else if %__N_FILE% gtr 0 ( set __FILE_TEXT=%__N_FILE% ^(%__FILE_URLS:~1%^)
    ) else ( set __FILE_TEXT=%__N_FILE%
    )
    if "%_SHARE_FLAG%"=="off" ( set __JRT_TEXT=%__N_JRT%
    ) else if %__N_JRT% gtr 0 ( set __JRT_TEXT=%__N_JRT% ^(%__JRT_URLS:~1%^)
    ) else ( set __JRT_TEXT=%__N_JRT%
    )
    if %_RUN_ITER%==1 ( set __TIME_TEXT=Load time        : !__LOAD_TIME[1]!
    ) else (
        call :average
        set __TIME_TEXT=Average load time: !_AVERAGE!s
    )
    set /a __N_PACKAGES=__N_MAIN
    @rem Java libraries
    set /a __N_PACKAGES=__N_PACKAGES+__N_JAVA_IO+__N_JAVA_LANG+__N_JAVA_MATH+__N_JAVA_NET+__N_JAVA_NIO
    set /a __N_PACKAGES=__N_PACKAGES+__N_JAVA_SECURITY+__N_JAVA_UTIL+__N_JDK+__N_SCALA+__N_SUN
    echo [96mExecution report:[0m
    echo    Share flag       : %_SHARE_FLAG%
    echo    Shared archive   : !_JSA_FILE:%_ROOT_DIR%=!
    echo    Shared classes   : %__N_SHARED%
    echo    File classes     : !__FILE_TEXT!
    echo    jrt images       : !__JRT_TEXT!
    echo    !__TIME_TEXT!
    echo    #iteration^(s^)    : %_RUN_ITER%
    echo    Execution logs   : !__SHARE_LOG_FILE:%_ROOT_DIR%=!
    echo [96mClasses per package ^(!__N_PACKAGES!^):[0m
    echo    java.io.* ^(%__N_JAVA_IO%^), java.lang.* ^(%__N_JAVA_LANG%^), java.math.* ^(%__N_JAVA_MATH%^), java.net.* ^(%__N_JAVA_NET%^)
    echo    java.nio.* ^(%__N_JAVA_NIO%^), java.security.* ^(%__N_JAVA_SECURITY%^), java.util.* ^(%__N_JAVA_UTIL%^)
    echo    jdk.* ^(%__N_JDK%^), scala.* ^(%__N_SCALA%^), sun.* ^(%__N_SUN%^)
    echo    [APP] %_MAIN_PKG_NAME%.* ^(%__N_MAIN%^)
)
goto :eof

@rem output parameter: _AVERAGE
:average
@rem we construct string __LIST to be passed into the ps1 script
set __LIST=
for /l %%i in (1, 1, %_RUN_ITER%) do set __LIST=!__LIST!,!__LOAD_TIME[%%i]!
set __PS1_SCRIPT= ^
$array=%__LIST:~1%; ^
$avgObj=$array ^| Measure-Object -Average; ^
[math]::Round($avgObj.Average,3)

set _AVERAGE=0.000
if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -c "..." 1>&2
for /f %%i in ('powershell -c "%__PS1_SCRIPT%"') do set _AVERAGE=%%i
set _AVERAGE=%_AVERAGE:,=.%
if %_DEBUG%==1 echo %_DEBUG_LABEL% __LIST=%__LIST% _AVERAGE=%_AVERAGE% 1>&2
goto :eof

@rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total execution time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

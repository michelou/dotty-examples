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
if %_PACK%==1 (
    call :pack
    if not !_EXITCODE!==0 goto end
)
if %_TEST%==1 (
    call :test
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
@rem                    _CLASSES_DIR, _TARGET_DIR, _TARGET_DOCS_DIR, _TASTY_CLASSES_DIR
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_CLASSES_DIR=%_TARGET_DIR%\classes"
set "_TASTY_CLASSES_DIR=%_TARGET_DIR%\tasty-classes"
set "_TEST_CLASSES_DIR=%_TARGET_DIR%\test-classes"
set "_TARGET_DOCS_DIR=%_TARGET_DIR%\docs"

if not exist "%JAVA_HOME%\bin\javac.exe" (
   echo %_ERROR_LABEL% Java SDK installation not found 1>&2
   set _EXITCODE=1
   goto :eof
)
set "_JAR_CMD=%JAVA_HOME%\bin\jar.exe"
set "_JAVA_CMD=%JAVA_HOME%\bin\java.exe"
set "_JAVAC_CMD=%JAVA_HOME%\bin\javac.exe"

if not exist "%SCALA3_HOME%\bin\scalac.bat" (
   echo %_ERROR_LABEL% Scala 3 installation not found 1>&2
   set _EXITCODE=1
   goto :eof
)
set "_SCALA_CMD=%SCALA3_HOME%\bin\scala.bat"
set "_SCALAC_CMD=%SCALA3_HOME%\bin\scalac.bat"
set "_SCALADOC_CMD=%SCALA3_HOME%\bin\scaladoc.bat"

if not exist "%CFR_HOME%\bin\cfr.bat" (
   echo %_ERROR_LABEL% CFR installation not found 1>&2
   set _EXITCODE=1
   goto :eof
)
set "_CFR_CMD=%CFR_HOME%\bin\cfr.bat"

@rem use newer PowerShell version if available
where /q pwsh.exe
if %ERRORLEVEL%==0 ( set _PWSH_CMD=pwsh.exe
) else ( set _PWSH_CMD=powershell.exe
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

@rem output parameters: _PLUGIN_CLASS_NAME, _PLUGIN_NAME, _PLUGIN_JAR_FILE
:props
set _PLUGIN_CLASS_NAME=multiplyone.MultiplyOne
@rem must match plugin name defined in class %_PLUGIN_CLASS_NAME%
set _PLUGIN_NAME=multiplyOne

for %%i in ("%~dp0\.") do set "_PROJECT_NAME=%%~ni"
set _PROJECT_URL=github.com/%USERNAME%/dotty-examples
set _PROJECT_VERSION=1.0-SNAPSHOT

set "__PROPS_FILE=%_ROOT_DIR%project\build.properties"
if exist "%__PROPS_FILE%" (
    for /f "tokens=1,* delims==" %%i in (%__PROPS_FILE%) do (
        for /f "delims= " %%n in ("%%i") do set __NAME=%%n
        @rem line comments start with "#"
        if not "!__NAME!"=="" if not "!__NAME:~0,1!"=="#" (
            @rem trim value
            for /f "tokens=*" %%v in ("%%~j") do set __VALUE=%%v
            set "_!__NAME:.=_!=!__VALUE!"
        )
    )
    if defined _plugin_class_name set _PLUGIN_CLASS_NAME=!_plugin_class_name!
    if defined _plugin_name set _PLUGIN_NAME=!_plugin_name!
    if defined _project_name set _PROJECT_NAME=!_project_name!
    if defined _project_url set _PROJECT_URL=!_project_url!
    if defined _project_version set _PROJECT_VERSION=!_project_version!
)
set "_PLUGIN_JAR_FILE=%_TARGET_DIR%\%_PLUGIN_NAME%.jar"
goto :eof

@rem input parameter: %*
:args
set _CLEAN=0
set _COMPILE=0
set _DOC=0
set _HELP=0
set _PACK=0
set _SCALAC_OPTS=-deprecation -feature
set _SCALAC_OPTS_EXPLAIN=0
set _SCALAC_OPTS_EXPLAIN_TYPES=0
set _TEST=0
set _TEST_PLUGIN=1
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
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-explain" ( set _SCALAC_OPTS_EXPLAIN=1
    ) else if "%__ARG%"=="-explain-types" ( set _SCALAC_OPTS_EXPLAIN_TYPES=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if "%__ARG%"=="doc" ( set _DOC=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="pack" ( set _COMPILE=1& set _PACK=1
    ) else if "%__ARG%"=="test" ( set _COMPILE=1& set _PACK=1& set _TEST=1
    ) else if "%__ARG%"=="test:noplugin" ( set _COMPILE=1& set _PACK=1& set _TEST=1& set _TEST_PLUGIN=0
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
set _STDERR_REDIRECT=2^>NUL
set _STDOUT_REDIRECT=1^>NUL
if %_DEBUG%==1 (
    set _STDERR_REDIRECT=
    set _STDOUT_REDIRECT=1^>^&2
)
if %_VERBOSE%==0 set _SCALAC_OPTS=%_SCALAC_OPTS% -nowarn
if %_SCALAC_OPTS_EXPLAIN%==1 set _SCALAC_OPTS=%_SCALAC_OPTS% -explain
if %_SCALAC_OPTS_EXPLAIN_TYPES%==1 set _SCALAC_OPTS=%_SCALAC_OPTS% -explain-types

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _EXPLAIN=%_SCALAC_OPTS_EXPLAIN% _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DOC=%_DOC% _PACK=%_PACK% _TEST=%_TEST% _TEST_PLUGIN=%_TEST_PLUGIN% 1>&2
	if defined _CFR_CMD echo %_DEBUG_LABEL% Variables  : "CFR_HOME=%CFR_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "JAVA_HOME=%JAVA_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "SCALA3_HOME=%SCALA3_HOME%" 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('call "%_PWSH_CMD%" -c "(Get-Date)"') do set _TIMER_START=%%i
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
echo     %__BEG_O%-debug%__END%           print commands executed by this script
echo     %__BEG_O%-explain%__END%         set compiler option %__BEG_O%-explain%__END%
echo     %__BEG_O%-explain-types%__END%   set compiler option %__BEG_O%-explain-types%__END%
echo     %__BEG_O%-tasty%__END%           compile both from source and TASTy files
echo     %__BEG_O%-timer%__END%           print total execution time
echo     %__BEG_O%-verbose%__END%         print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%            delete generated class files
echo     %__BEG_O%compile%__END%          compile Scala source files
echo     %__BEG_O%doc%__END%              generate documentation
echo     %__BEG_O%help%__END%             print this help message
echo     %__BEG_O%pack%__END%             create Java archive file
echo     %__BEG_O%test%__END%             execute unit tests
echo     %__BEG_O%test:noplugin%__END%    execute unit tests with NO plugin
goto :eof

:clean
call :rmdir "%_ROOT_DIR%out"
call :rmdir "%_TARGET_DIR%"
goto :eof

@rem input parameter(s): %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%" 1>NUL

set "__TIMESTAMP_FILE=%_CLASSES_DIR%\.latest-build"

call :action_required "%__TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\scala\*.scala"
if %_ACTION_REQUIRED%==1 (
    call :compile_scala
    if not !_EXITCODE!==0 goto :eof
)
echo. > "%__TIMESTAMP_FILE%"
goto :eof

:compile_scala
set "__OPTS_FILE=%_TARGET_DIR%\scalac_opts.txt"
echo %_SCALAC_OPTS% -language:implicitConversions -classpath "%_CLASSES_DIR:\=\\%" -d "%_CLASSES_DIR:\=\\%" > "%__OPTS_FILE%"

set "__SOURCES_FILE=%_TARGET_DIR%\scalac_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f "delims=" %%i in ('dir /s /b "%_SOURCE_DIR%\main\scala\*.scala" 2^>NUL') do (
    echo %%i >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Scala source files found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% Scala source file
) else ( set __N_FILES=%__N% Scala source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directory "!_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directory "!_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: 1=target file 2,3,..=path (wildcards accepted)
@rem output parameter: _ACTION_REQUIRED
:action_required
set "__TARGET_FILE=%~1"

set __PATH_ARRAY=
set __PATH_ARRAY1=
:action_path
shift
set __PATH=%~1
if not defined __PATH goto action_next
set __PATH_ARRAY=%__PATH_ARRAY%,'%__PATH%'
set __PATH_ARRAY1=%__PATH_ARRAY1%,'!__PATH:%_ROOT_DIR%=!'
goto action_path

:action_next
set __TARGET_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "gci -path '%__TARGET_FILE%' -ea Stop | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
     set __TARGET_TIMESTAMP=%%i
)
set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "gci -recurse -path %__PATH_ARRAY:~1% -ea Stop | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
    set __SOURCE_TIMESTAMP=%%i
)
call :newer %__SOURCE_TIMESTAMP% %__TARGET_TIMESTAMP%
set _ACTION_REQUIRED=%_NEWER%
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% %__TARGET_TIMESTAMP% Target : '%__TARGET_FILE%' 1>&2
    echo %_DEBUG_LABEL% %__SOURCE_TIMESTAMP% Sources: %__PATH_ARRAY:~1% 1>&2
    echo %_DEBUG_LABEL% _ACTION_REQUIRED=%_ACTION_REQUIRED% 1>&2
) else if %_VERBOSE%==1 if %_ACTION_REQUIRED%==0 if %__SOURCE_TIMESTAMP% gtr 0 (
    echo No action required ^(%__PATH_ARRAY1:~1%^) 1>&2
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

@rem input parameter: %1=flag to add Dotty libs
@rem output parameter: _LIBS_CPATH
:libs_cpath
set __ADD_DOTTY_LIBS=%~1

for /f "delims=" %%f in ("%~dp0\.") do set "__BATCH_FILE=%%~dpfcpath.bat"
if not exist "%__BATCH_FILE%" (
    echo %_ERROR_LABEL% Batch file "%__BATCH_FILE%" not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% "%__BATCH_FILE%" %_DEBUG% 1>&2
call "%__BATCH_FILE%" %_DEBUG%
set _LIBS_CPATH=%_CPATH%

if defined __ADD_DOTTY_LIBS (
    if not defined SCALA3_HOME (
        echo %_ERROR_LABEL% Variable SCALA3_HOME not defined 1>&2
        set _EXITCODE=1
        goto :eof
    )
    for /f "delims=" %%f in ("%SCALA3_HOME%\lib\*.jar") do (
        set _LIBS_CPATH=!_LIBS_CPATH!%%f;
    )
)
goto :eof

:doc
if not exist "%_TARGET_DOCS_DIR%" mkdir "%_TARGET_DOCS_DIR%" 1>NUL

set "__DOC_TIMESTAMP_FILE=%_TARGET_DOCS_DIR%\.latest-build"

call :action_required "%__DOC_TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\scala\*.scala"
if %_ACTION_REQUIRED%==0 goto :eof

set "__OPTS_FILE=%_TARGET_DIR%\scaladoc_opts.txt"
echo -siteroot "%_TARGET_DOCS_DIR%" -project "%_PROJECT_NAME%" -project-url "%_PROJECT_URL%" -project-version "%_PROJECT_VERSION%" > "%__OPTS_FILE%"

set "__SOURCES_FILE=%_TARGET_DIR%\scaladoc_sources.txt"
for /f "delims=" %%i in ('dir /s /b "%_SOURCE_DIR%\main\scala\*.scala" 2^>NUL') do (
    echo %%i>> "%__SOURCES_FILE%"
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALADOC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Generate HTML documentation into directory "!_TARGET_DOCS_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_SCALADOC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Generation of HTML documentation failed 1>&2
    set _EXITCODE=1
    goto :eof
)
echo. > "%__DOC_TIMESTAMP_FILE%"
goto :eof

@rem https://docs.oracle.com/javase/7/docs/technotes/tools/windows/jar.html
:pack
call :action_required "%_PLUGIN_JAR_FILE%" "%_CLASSES_DIR%\*.class"
if %_ACTION_REQUIRED%==0 goto :eof

set __JAR_OPTS=cfm
if %_DEBUG%==1 set __JAR_OPTS=v%__JAR_OPTS%
)
set __PROP_FILENAME=plugin.properties
set "__PROP_FILEPATH=%_TARGET_DIR%\%__PROP_FILENAME%"
(
    echo pluginClass=%_PLUGIN_CLASS_NAME%
) > "%__PROP_FILEPATH%"

call :pack_manifest
if not %_EXITCODE%==0 goto :eof

set __FILES=-C "%_TARGET_DIR%" "%__PROP_FILENAME%"
for /f "delims=" %%f in ('dir /s /b "%_CLASSES_DIR%\*.class" 2^>NUL') do (
    set "__CLASS_FILE=%%f"
    set __FILES=!__FILES! -C "%_CLASSES_DIR%" "!__CLASS_FILE:%_CLASSES_DIR%\=!"
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_JAR_CMD%" %__JAR_OPTS% "%_PLUGIN_JAR_FILE%" "%_MANIFEST_FILE%" %__FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Create Java archive "!_PLUGIN_JAR_FILE:%_ROOT_DIR%=!" 1>&2
)
call "%_JAR_CMD%" %__JAR_OPTS% "%_PLUGIN_JAR_FILE%" "%_MANIFEST_FILE%" %__FILES% %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _MANIFEST_FILE
:pack_manifest
set "_MANIFEST_FILE=%_TARGET_DIR%\Manifest.txt"
echo Manifest-Version: 1.0> "%_MANIFEST_FILE%"

for /f "usebackq tokens=1,*" %%i in (`"%_JAVAC_CMD%" -version 2^>^&1`) do set __JAVAC_VERSION=%%j
@rem Starting with Java 11 java.exe accepts a single Java source file
@rem (Java versions prior to version 11 contain a dot in position 1)
if not "!__JAVAC_VERSION:~1,1!"=="." set _JAVAC_CMD=

set "__JAVA_FILE=%_SOURCE_DIR%\build\Manifest.java"
if not exist "%__JAVA_FILE%" (
    echo %_ERROR_LABEL% Java file "!__JAVA_FILE:%_ROOT_DIR%=!" not found 1>&2
    set _EXITCODE=1
    goto :eof
)
if defined _JAVAC_CMD (
    set "__TMP_DIR=%_TARGET_DIR%\tmp"
    if not exist "!__TMP_DIR!" mkdir "!__TMP_DIR!" 1>NUL
    call "%_JAVAC_CMD%" -d "!__TMP_DIR!" "%__JAVA_FILE%"
    for /f "usebackq delims=" %%i in (`call "%_JAVA_CMD%" -cp "!__TMP_DIR!" Manifest`) do (
        echo %%i>> "%_MANIFEST_FILE%"
    )
) else (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_JAVA_CMD%" "%__JAVA_FILE%" 1>&2
    for /f "usebackq delims=" %%i in (`call "%_JAVA_CMD%" "%__JAVA_FILE%"`) do (
        echo %%i>> "%_MANIFEST_FILE%"
    )
)
for /f "tokens=1,2,3,4,*" %%i in ('call "%_SCALAC_CMD%" -version 2^>^&1') do set __SCALA_VERSION=%%l
echo Scala-Version: %__SCALA_VERSION%>> "%_MANIFEST_FILE%"
goto :eof

:compile_test
if not exist "%_TEST_CLASSES_DIR%" mkdir "%_TEST_CLASSES_DIR%" 1>NUL

@rem Test source files must be compiled as the plugin can be enabled/disabled
@rem set "__TEST_TIMESTAMP_FILE=%_TEST_CLASSES_DIR%\.latest-build"

@rem call :action_required "%__TEST_TIMESTAMP_FILE%" "%_SOURCE_DIR%\test\scala\*.scala"
@rem if %_ACTION_REQUIRED%==0 goto :eof

set "__SOURCES_FILE=%_TARGET_DIR%\test_scalac_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%" 1>NUL
set __N=0
for /f "delims=" %%i in ('dir /s /b "%_SOURCE_DIR%\test\scala\*.scala" 2^>NUL') do (
    echo %%i >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No Scala test source files found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% Scala test source file
) else ( set __N_FILES=%__N% Scala test source files
)
if %_TEST_PLUGIN%==0 ( set __SCALAC_OPTS=%_SCALAC_OPTS%
) else ( set __SCALAC_OPTS=%_SCALAC_OPTS% -Xplugin:"%_PLUGIN_JAR_FILE%" -Xplugin-require:%_PLUGIN_NAME% -P:"%_PLUGIN_NAME%:opt1=1"
)
set "__OPTS_FILE=%_TARGET_DIR%\test_scalac_opts.txt"
echo %__SCALAC_OPTS% -classpath "%_CLASSES_DIR%;%_TEST_CLASSES_DIR%" -d "%_TEST_CLASSES_DIR%" > "%__OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALAC_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% to directory "!_TEST_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
)
call %_SCALAC_CMD% "@%__OPTS_FILE%" "@%__SOURCES_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to "!_TEST_CLASSES_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem echo. > "%__TEST_TIMESTAMP_FILE%"
goto :eof

:decompile_test
set "__LIB_PATH=%SCALA3_HOME%\lib"
for /f "tokens=1,2,3,4,*" %%i in ('%SCALA3_HOME%\bin\scalac.bat -version 2^>^&1') do (
    set "__VERSION_STRING=scala3_%%l"
)
@rem keep only "-NIGHTLY" in version suffix when compiling with a nightly build 
if "%__VERSION_STRING:NIGHTLY=%"=="%__VERSION_STRING%" (
    set __VERSION_SUFFIX=_%__VERSION_STRING%
) else (
    for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "$s='%__VERSION_STRING%';$i=$s.indexOf('-bin',0); $s.substring(0, $i)"`) do (
        set __VERSION_SUFFIX=_%%i-NIGHTLY
    )
)
set __EXTRA_CPATH=
for /f "delims=" %%f in (%__LIB_PATH%\*.jar) do set "__EXTRA_CPATH=!__EXTRA_CPATH!%%f;"
set "__OUTPUT_DIR=%_TARGET_DIR%\cfr-sources"
if not exist "%__OUTPUT_DIR%" mkdir "%__OUTPUT_DIR%"

set __CFR_OPTS=--extraclasspath "%__EXTRA_CPATH%" --outputdir "%__OUTPUT_DIR%"

set "__CLASS_DIRS=%_TEST_CLASSES_DIR%"
for /f "delims=" %%f in ('dir /b /s /ad "%_TEST_CLASSES_DIR%" 2^>NUL') do (
    set __CLASS_DIRS=!__CLASS_DIRS! "%%f"
)
if %_VERBOSE%==1 echo Decompile Java bytecode to directory "!__OUTPUT_DIR:%_ROOT_DIR%=!" 1>&2
for %%i in (%__CLASS_DIRS%) do (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% "%_CFR_CMD%" %__CFR_OPTS% "%%i\*.class" 1>&2
    call "%_CFR_CMD%" %__CFR_OPTS% "%%i"\*.class %_STDERR_REDIRECT%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to decompile generated code in directory "%%i" 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
@rem output file contains Scala and CFR headers
set "__OUTPUT_FILE=%_TARGET_DIR%\cfr-sources%__VERSION_SUFFIX%.java"
echo // Compiled with %__VERSION_STRING% > "%__OUTPUT_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% type "%__OUTPUT_DIR%\*.java" ^>^> "%__OUTPUT_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Save generated Java source files to directory "!__OUTPUT_FILE:%_ROOT_DIR%=!" 1>&2
)
set __JAVA_FILES=
for /f "delims=" %%f in ('dir /b /s "%__OUTPUT_DIR%\*.java" 2^>NUL') do (
    set __JAVA_FILES=!__JAVA_FILES! "%%f"
)
if defined __JAVA_FILES type %__JAVA_FILES% >> "%__OUTPUT_FILE%" 2>NUL

set __DIFF_CMD=diff.exe
set __DIFF_OPTS=--strip-trailing-cr

set "__CHECK_FILE=%_SOURCE_DIR%\build\cfr-sources%__VERSION_SUFFIX%.java"
if exist "%__CHECK_FILE%" (
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%__DIFF_CMD%" %__DIFF_OPTS% "%__OUTPUT_FILE%" "%__CHECK_FILE%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Compare output file with check file "!__CHECK_FILE:%_ROOT_DIR%=!" 1>&2
    )
    call "%__DIFF_CMD%" %__DIFF_OPTS% "%__OUTPUT_FILE%" "%__CHECK_FILE%"
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Output file and check file differ 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

:test
call :compile_test
if not %_EXITCODE%==0 goto :eof

set __TEST_SCALA_OPTS=-classpath "%_CLASSES_DIR%;%_TEST_CLASSES_DIR%"

@rem see https://github.com/junit-team/junit4/wiki/Getting-started
for /f "delims=" %%i in (%_TEST_CLASSES_DIR%\*Test.class) do (
    set "__MAIN_CLASS=%%~ni"
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SCALA_CMD%" %__TEST_SCALA_OPTS% !__MAIN_CLASS! 1>&2
    ) else if %_VERBOSE%==1 ( echo Execute test "!__MAIN_CLASS!" 1>&2
    )
    call "%_SCALA_CMD%" %__TEST_SCALA_OPTS% !__MAIN_CLASS!
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to execute test "!__MAIN_CLASS!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
call :decompile_test
if not %_EXITCODE%==0 goto :eof
goto :eof

@rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('call "%_PWSH_CMD%" -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('call "%_PWSH_CMD%" -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total execution time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal

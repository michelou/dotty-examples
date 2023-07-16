@echo off
setlocal enabledelayedexpansion

@rem output parameter: _CPATH

if not defined _DEBUG set _DEBUG=%~1
if not defined _MVN_CMD set "_MVN_CMD=%MAVEN_HOME%\bin\mvn.cmd"

if %_DEBUG%==1 ( set _MVN_OPTS=
) else ( set _MVN_OPTS=--quiet
)
set __CENTRAL_REPO=https://repo1.maven.org/maven2
set "__LOCAL_REPO=%USERPROFILE%\.m2\repository"

set "__TEMP_DIR=%TEMP%\lib"
if not exist "%__TEMP_DIR%" mkdir "%__TEMP_DIR%"

set _LIBS_CPATH=

set __SCALA_BINARY_VERSION=2.13
set __SCALATEST_VERSION=3.2.16

@rem https://mvnrepository.com/artifact/org.scala-lang/scala-reflect
@rem import scala.reflect.runtime.universe._
call :add_jar "org.scala-lang" "scala-reflect" "2.13.10"

@rem https://mvnrepository.com/artifact/org.portable-scala
call :add_jar "org.portable-scala" "portable-scala-reflect_%__SCALA_BINARY_VERSION%" "1.1.2"

@rem https://mvnrepository.com/artifact/org.scala-lang.modules/scala-xml
call :add_jar "org.scala-lang.modules" "scala-xml_3" "2.2.0"

@rem https://mvnrepository.com/artifact/junit/junit
call :add_jar "junit" "junit" "4.13.2"

@rem https://mvnrepository.com/artifact/org.hamcrest/hamcrest
@rem JUnit 2 depends on Hamcrest version 1.3
call :add_jar "org.hamcrest" "hamcrest-core" "1.3"

@rem https://mvnrepository.com/artifact/com.novocode/junit-interface
call :add_jar "com.novocode" "junit-interface" "0.11"

@rem https://mvnrepository.com/artifact/org.junit.jupiter/junit-jupiter-engine
call :add_jar "org.junit.jupiter" "junit-jupiter-engine" "5.9.3"

@rem https://mvnrepository.com/artifact/org.scalatest/scalatest-compatible
call :add_jar "org.scalatest" "scalatest-compatible" "%__SCALATEST_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalatest/scalatest-core
call :add_jar "org.scalatest" "scalatest-core_3" "%__SCALATEST_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalatest/scalatest-funsuite
call :add_jar "org.scalatest" "scalatest-funsuite_3" "%__SCALATEST_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalatest/scalatest-funspec
call :add_jar "org.scalatest" "scalatest-funspec_3" "%__SCALATEST_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalatest/scalatest
call :add_jar "org.scalatest" "scalatest_3" "%__SCALATEST_VERSION%"

@rem https://mvnrepository.com/artifact/org.scalactic
call :add_jar "org.scalactic" "scalactic_3" "%__SCALATEST_VERSION%"

@rem Scala binary 2.13 -> 4.17.0, Scala binary 3 -> 5.0.7, 5.1.0, 5.2.0
set __SPECS2_VERSION=5.2.0

@rem https://mvnrepository.com/artifact/org.specs2/specs2-core
call :add_jar "org.specs2" "specs2-core_3" "%__SPECS2_VERSION%"

@rem https://mvnrepository.com/artifact/org.specs2/specs2-common
call :add_jar "org.specs2" "specs2-common_3" "%__SPECS2_VERSION%"

@rem https://mvnrepository.com/artifact/org.specs2/specs2-junit
call :add_jar "org.specs2" "specs2-junit_3" "%__SPECS2_VERSION%"

@rem https://mvnrepository.com/artifact/org.specs2/specs2-junit
call :add_jar "org.specs2" "specs2-matcher_3" "%__SPECS2_VERSION%"

@rem https://mvnrepository.com/artifact/org.specs2/specs2-fp
call :add_jar "org.specs2" "specs2-fp_3" "%__SPECS2_VERSION%"

goto end

@rem #########################################################################
@rem ## Subroutines

@rem input parameters: %1=group ID, %2=artifact ID, %3=version
@rem global variable: _LIBS_CPATH
:add_jar
@rem https://mvnrepository.com/artifact/org.portable-scala
set __GROUP_ID=%~1
set __ARTIFACT_ID=%~2
set __VERSION=%~3

set __JAR_NAME=%__ARTIFACT_ID%-%__VERSION%.jar
set __JAR_PATH=%__GROUP_ID:.=\%\%__ARTIFACT_ID:/=\%
set __JAR_FILE=
for /f "usebackq delims=" %%f in (`where /r "%__LOCAL_REPO%\%__JAR_PATH%" %__JAR_NAME% 2^>NUL`) do (
    set "__JAR_FILE=%%f"
)
if not exist "%__JAR_FILE%" (
    set __JAR_URL=%__CENTRAL_REPO%/%__GROUP_ID:.=/%/%__ARTIFACT_ID%/%__VERSION%/%__JAR_NAME%
    set "__JAR_FILE=%__TEMP_DIR%\%__JAR_NAME%"
    if not exist "!__JAR_FILE!" (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% powershell -c "Invoke-WebRequest -Uri '!__JAR_URL!' -Outfile '!__JAR_FILE!'" 1>&2
        ) else if %_VERBOSE%==1 ( echo Download file "%__JAR_NAME%" to directory "!__TEMP_DIR:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
        )
        powershell -c "$progressPreference='silentlyContinue';Invoke-WebRequest -Uri '!__JAR_URL!' -Outfile '!__JAR_FILE!'"
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to download file "%__JAR_NAME%" 1>&2
            set _EXITCODE=1
            goto :eof
        )
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MVN_CMD%" %_MVN_OPTS% install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar 1>&2
        ) else if %_VERBOSE%==1 ( echo Install Maven artifact into directory "!__LOCAL_REPO:%USERPROFILE%=%%USERPROFILE%%!\%__SCALA_XML_PATH%" 1>&2
        )
        @rem see https://stackoverflow.com/questions/16727941/how-do-i-execute-cmd-commands-through-a-batch-file
        call "%_MVN_CMD%" %_MVN_OPTS% install:install-file -Dfile="!__JAR_FILE!" -DgroupId="%__GROUP_ID%" -DartifactId=%__ARTIFACT_ID% -Dversion=%__VERSION% -Dpackaging=jar
        if not !ERRORLEVEL!==0 (
            echo %_ERROR_LABEL% Failed to install Maven artifact into directory "!__LOCAL_REPO:%USERPROFILE%=%%USERPROFILE%%!" ^(error:!ERRORLEVEL!^) 1>&2
        )
        for /f "usebackq delims=" %%f in (`where /r "%__LOCAL_REPO%\%__JAR_PATH%" %__JAR_NAME% 2^>NUL`) do (
            set "__JAR_FILE=%%f"
        )
    )
)
set "_LIBS_CPATH=%_LIBS_CPATH%%__JAR_FILE%;"
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    set "_CPATH=%_LIBS_CPATH%"
)
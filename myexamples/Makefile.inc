ifeq ($(OS),Windows_NT)
JAVAC      = javac.exe
JAVA       = java.exe
SCALAC     = dotc.bat
SCALADOC   = dotd.bat
SCALA      = dotr.bat
LOCAL_REPO = $(subst \,/,$(USERPROFILE)/.m2/repository)
PSEP       = ;
else
JAVAC      = javac
JAVA       = java
SCALAC     = dotc
SCALADOC   = dotd
SCALA      = dotr
LOCAL_REPO = $(HOME)/.m2/repository
PSEP       = :
endif

SCALA_LIB_JAR      = $(shell find "$(LOCAL_REPO)/org/scala-lang" -name scala-library-2.13.3.jar)
DOTTY_LIB_JAR      = $(shell find "$(LOCAL_REPO)/ch/epfl/lamp" -name dotty-library_0.27-0.27.0-RC1.jar)
HAMCREST_JAR       = $(shell find "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-core-2.2.jar)
JUNIT_JAR          = $(shell find "$(LOCAL_REPO)/junit/junit" -name junit-4.13.jar)
JUNIT_INTF_JAR     = $(shell find "$(LOCAL_REPO)/com/novocode" -name junit-interface-0.11.jar)
SCALATEST_JAR      = $(shell find "$(LOCAL_REPO)/org/scalatest" -name scalatest_2.13-3.2.2.jar)
SCALACTIC_JAR      = $(shell find "$(LOCAL_REPO)/org/scalactic" -name scalactic_2.13-3.2.2.jar)
SPECS2_CORE_JAR    = $(shell find "$(LOCAL_REPO)/org/specs2" -name specs2-core_2.13-4.10.3.jar)
SPECS2_JUNIT_JAR   = $(shell find "$(LOCAL_REPO)/org/specs2" -name specs2-junit_2.13-4.10.3.jar)
SPECS2_MATCHER_JAR = $(shell find "$(LOCAL_REPO)/org/specs2" -name specs2-matcher_2.13-4.10.3.jar)
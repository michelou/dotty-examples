ifeq ($(OS),Windows_NT)
JAVAC      = javac.exe
JAVA       = java.exe
SCALAC     = dotc.bat
SCALA      = dotr.bat
LOCAL_REPO = $(subst \,/,$(USERPROFILE)/.m2/repository)
PSEP       = ;
else
JAVAC      = javac
JAVA       = java
SCALAC     = dotc
SCALA      = dotr
LOCAL_REPO = $(HOME)/.m2/repository
PSEP       = :
endif

SCALA_LIB_JAR  = $(shell find "$(LOCAL_REPO)/org/scala-lang" -name scala-library-2.13.2.jar)
DOTTY_LIB_JAR  = $(shell find "$(LOCAL_REPO)/ch/epfl/lamp" -name dotty-library_0.25-0.25.0-RC2.jar)
HAMCREST_JAR   = $(shell find "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-core-1.3.jar)
JUNIT_JAR      = $(shell find "$(LOCAL_REPO)/junit/junit" -name junit-4.13.jar)
JUNIT_INTF_JAR = $(shell find "$(LOCAL_REPO)/com/novocode" -name junit-interface-0.11.jar)

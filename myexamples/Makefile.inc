ifndef GIT_HOME
$(error Variable GIT_HOME is not set)
endif
ifndef JAVA_HOME
$(error Variable JAVA_HOME is not set)
endif
ifndef SCALA3_HOME
$(error Variable SCALA3_HOME is not set)
endif

ifeq ($(OS),Windows_NT)
JAVA       = $(subst \,/,$(JAVA_HOME))/bin/java.exe
JAVAC      = $(subst \,/,$(JAVA_HOME))/bin/javac.exe
SCALA      = $(subst \,/,$(SCALA3_HOME))/bin/scala.bat
SCALAC     = $(subst \,/,$(SCALA3_HOME))/bin/scalac.bat
SCALADOC   = $(subst \,/,$(SCALA3_HOME))/bin/scaladoc.bat
SCALAFMT   = $(subst \,/,$(LOCALAPPDATA))/Coursier/data/bin/scalafmt.bat
LOCAL_REPO = $(subst \,/,$(USERPROFILE))/.m2/repository
PSEP       = ;
CP         = $(subst \,/,$(GIT_HOME))/usr/bin/cp.exe
ECHO       = $(subst \,/,$(GIT_HOME))/usr/bin/echo.exe
FIND       = $(subst \,/,$(GIT_HOME))/usr/bin/find.exe
MKDIR      = $(subst \,/,$(GIT_HOME))/usr/bin/mkdir.exe
RM         = $(subst \,/,$(GIT_HOME))/usr/bin/rm.exe
TOUCH      = $(subst \,/,$(GIT_HOME))/usr/bin/touch.exe
else
JAVA       = $(JAVA_HOME)/bin/java
JAVAC      = $(JAVA_HOME)/bin/javac
SCALA      = $(SCALA3_HOME)/bin/scala
SCALAC     = $(SCALA3_HOME)/bin/scalac
SCALADOC   = $(SCALA3_HOME)/bin/scaladoc
SCALAFMT   = $(HOME)/.local/share/coursier/bin/scalafmt
LOCAL_REPO = $(HOME)/.m2/repository
PSEP       = :
CP         = cp
ECHO       = echo
FIND       = find
MKDIR      = mkdir
RM         = rm
TOUCH      = touch
endif

SCALA_LIB_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/org/scala-lang" -name scala-library-2.13.8.jar)
SCALA3_LIB_JAR        = $(shell $(FIND) "$(LOCAL_REPO)/org/scala-lang" -name scala3-library_3-3.1.2-RC1.jar)
HAMCREST_JAR          = $(shell $(FIND) "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-2.2.jar)
HAMCREST_ALL_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-all-1.3.jar)
JUNIT_JAR             = $(shell $(FIND) "$(LOCAL_REPO)/junit/junit" -name junit-4.13.2.jar)
JUNIT_INTF_JAR        = $(shell $(FIND) "$(LOCAL_REPO)/com/novocode" -name junit-interface-0.11.jar)
SCALATEST_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/org/scalatest" -name scalatest_3-3.2.11.jar)
SCALATEST_FUNSPEC_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/scalatest" -name scalatest-funspec_3-3.2.11.jar)
SCALACTIC_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/org/scalactic" -name scalactic_3-3.2.11.jar)
SPECS2_COMMON_JAR     = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name specs2-common_2.13-4.14.0.jar)
SPECS2_CORE_JAR       = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name specs2-core_2.13-4.14.0.jar)
SPECS2_JUNIT_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name specs2-junit_2.13-4.14.0.jar)
SPECS2_MATCHER_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name specs2-matcher_2.13-4.14.0.jar)

ifeq (,$(wildcard $(SCALA3_LIB_JAR)))
$(error Variable SCALA3_LIB_JAR is not set)
endif
ifeq (,$(wildcard $(SCALATEST_JAR)))
$(error Variable SCALATEST_JAR is not set)
endif
ifeq (,$(wildcard $(SPECS2_COMMON_JAR)))
$(error Variable SPECS2_COMMON_JAR is not set)
endif

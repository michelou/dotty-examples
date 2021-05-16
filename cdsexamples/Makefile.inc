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
LOCAL_REPO = $(subst \,/,$(USERPROFILE))/.m2/repository
PSEP       = ;
FIND       = $(subst \,/,$(GIT_HOME))/usr/bin/find.exe
MKDIR      = $(subst \,/,$(GIT_HOME))/usr/bin/mkdir.exe
TOUCH      = $(subst \,/,$(GIT_HOME))/usr/bin/touch.exe
else
JAVA       = $(JAVA_HOME)/bin/java
JAVAC      = $(JAVA_HOME)/bin/javac
SCALA      = $(SCALA3_HOME)/bin/scala
SCALAC     = $(SCALA3_HOME)/bin/scalac
SCALADOC   = $(SCALA3_HOME)/bin/scaladoc
LOCAL_REPO = $(HOME)/.m2/repository
PSEP       = :
FIND       = find
MKDIR      = mkdir
TOUCH      = touch
endif

SCALA_LIB_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/scala-lang" -name scala-library-2.13.5.jar)
SCALA3_LIB_JAR     = $(shell $(FIND) "$(LOCAL_REPO)/org/scala-lang" -name scala3-library_3.0.0-*.jar)
HAMCREST_JAR       = $(shell $(FIND) "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-2.2.jar)
JUNIT_JAR          = $(shell $(FIND) "$(LOCAL_REPO)/junit/junit" -name junit-4.13.2.jar)
JUNIT_INTF_JAR     = $(shell $(FIND) "$(LOCAL_REPO)/com/novocode" -name junit-interface-0.11.jar)
SCALATEST_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/scalatest" -name scalatest_3-3.2.9.jar)
SCALACTIC_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/scalactic" -name scalactic_3-3.2.9.jar)
SPECS2_CORE_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name specs2-core_2.13-4.11.0.jar)
SPECS2_JUNIT_JAR   = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name specs2-junit_2.13-4.11.0.jar)
SPECS2_MATCHER_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name specs2-matcher_2.13-4.11.0.jar)
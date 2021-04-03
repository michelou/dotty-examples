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
## We grab Cygwin version instead of C:\Windows\System32\find.exe
FIND_CMD   = /usr/bin/find.exe
else
JAVA       = $(JAVA_HOME)/bin/java
JAVAC      = $(JAVA_HOME)/bin/javac
SCALA      = $(SCALA3_HOME)/bin/scala
SCALAC     = $(SCALA3_HOME)/bin/scalac
SCALADOC   = $(SCALA3_HOME)/bin/scaladoc
LOCAL_REPO = $(HOME)/.m2/repository
PSEP       = :
FIND_CMD   = find
endif

SCALA_LIB_JAR      = $(shell $(FIND_CMD) "$(LOCAL_REPO)/org/scala-lang" -name scala-library-2.13.5.jar)
SCALA3_LIB_JAR     = $(shell $(FIND_CMD) "$(LOCAL_REPO)/org/scala-lang" -name scala3-library_3.0.0-RC2-3.0.0-RC2.jar)
HAMCREST_JAR       = $(shell $(FIND_CMD) "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-2.2.jar)
JUNIT_JAR          = $(shell $(FIND_CMD) "$(LOCAL_REPO)/junit/junit" -name junit-4.13.2.jar)
JUNIT_INTF_JAR     = $(shell $(FIND_CMD) "$(LOCAL_REPO)/com/novocode" -name junit-interface-0.11.jar)
SCALATEST_JAR      = $(shell $(FIND_CMD) "$(LOCAL_REPO)/org/scalatest" -name scalatest_2.13-3.2.6.jar)
SCALACTIC_JAR      = $(shell $(FIND_CMD) "$(LOCAL_REPO)/org/scalactic" -name scalactic_2.13-3.2.6.jar)
SPECS2_CORE_JAR    = $(shell $(FIND_CMD) "$(LOCAL_REPO)/org/specs2" -name specs2-core_2.13-4.10.6.jar)
SPECS2_JUNIT_JAR   = $(shell $(FIND_CMD) "$(LOCAL_REPO)/org/specs2" -name specs2-junit_2.13-4.10.6.jar)
SPECS2_MATCHER_JAR = $(shell $(FIND_CMD) "$(LOCAL_REPO)/org/specs2" -name specs2-matcher_2.13-4.10.6.jar)
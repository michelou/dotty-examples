MAIN_CLASS  = myexamples.HelloWorld

TARGET_DIR       = target
CLASSES_DIR      = $(TARGET_DIR)/classes
TARGET           = $(TARGET_DIR)/.latest-build
TEST_CLASSES_DIR = $(TARGET_DIR)/test-classes
TEST_TARGET      = $(TARGET_DIR)/.latest-test-build

ifeq ($(OS),Windows_NT)
SCALAC     = dotc.bat
SCALA      = dotr.bat
JAVA       = java.exe
LOCAL_REPO = $(subst \,/,$(USERPROFILE)/.m2/repository)
PSEP       = ;
else
SCALAC     = dotc
SCALA      = dotr
JAVA       = java
LOCAL_REPO = $(HOME)/.m2/repository
PSEP       = :
endif
SCALAC_FLAGS = -deprecation -feature
SCALA_FLAGS  = -classpath "$(CLASSES_DIR)"

JUNIT_JAR          = $(wildcard $(LOCAL_REPO)/junit/junit/4.12/junit-*.jar)
JUNIT_INTF_JAR     = $(wildcard $(LOCAL_REPO)/com/novocode/junit-interface/0.11/junit-interface*.jar)
SCALATEST_JAR      = $(wildcard $(LOCAL_REPO)/org/scalatest/scalatest_2.13/3.1.1/scalatest*.jar)
SCALACTIC_JAR      = $(wildcard $(LOCAL_REPO)/org/scalactic/scalactic_2.13/3.1.1/scalactic*.jar)
SPECS2_CORE_JAR    = $(wildcard $(LOCAL_REPO)/org/specs2/specs2-core_2.13/4.9.2/specs2-core*.jar)
SPECS2_JUNIT_JAR   = $(wildcard $(LOCAL_REPO)/org/specs2/specs2-junit_2.13/4.9.2/specs2-junit*.jar)
SPECS2_MATCHER_JAR = $(wildcard $(LOCAL_REPO)/org/specs2/specs2-matcher_2.13/4.9.2/specs2-matcher*.jar)

TEST_CPATH         = $(JUNIT_JAR)$(PSEP)$(JUNIT_INTF_JAR)$(PSEP)$(SCALATEST_JAR)$(PSEP)$(SCALACTIC_JAR)$(PSEP)$(SPECS2_CORE_JAR)$(PSEP)$(SPECS2_JUNIT_JAR)$(PSEP)$(SPECS2_MATCHER_JAR)$(PSEP)$(CLASSES_DIR)$(PSEP)$(TEST_CLASSES_DIR)

SCALAC_TEST_FLAGS  = -classpath "$(TEST_CPATH)"
JAVA_TEST_FLAGS    = -classpath "$(TEST_CPATH)"

all: build

build: $(TARGET)
	@echo "" > "$(TARGET)"

$(TARGET): src/main/scala/*.scala
	[ -d "$(CLASSES_DIR)" ] || mkdir -p "$(CLASSES_DIR)"
	$(SCALAC) $(SCALAC_FLAGS) -d "$(CLASSES_DIR)" $^

clean:
	rm -rf "$(TARGET_DIR)"

run: build
	$(SCALA) $(SCALA_FLAGS) $(MAIN_CLASS)

test_build: build $(TEST_TARGET)
	echo "" > "$(TEST_TARGET)"

$(TEST_TARGET): src/test/scala/*.scala
	[ -d "$(TEST_CLASSES_DIR)" ] || mkdir -p "$(TEST_CLASSES_DIR)"
	$(SCALAC) $(SCALAC_TEST_FLAGS) -d "$(TEST_CLASSES_DIR)" $^

test: build test_build
	$(JAVA) $(JAVA_TEST_FLAGS) org.junit.runner.JUnitCore ColorJUnitTest

.PHONY: all build clean run test test_build

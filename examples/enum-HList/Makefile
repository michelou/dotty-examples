SOURCE_DIR  = src
SOURCES     = $(shell find $(SOURCE_DIR)/main -name *.scala)

TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes
TARGET      = $(TARGET_DIR)/.latest-build

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

##############################################################################
## main rules

MAIN_CLASS = Main
MAIN_ARGS ?= 

all: build

build: $(TARGET)

$(TARGET): $(SOURCES)
	[ -d "$(CLASSES_DIR)" ] || mkdir -p "$(CLASSES_DIR)"
	@echo "$(SCALAC_FLAGS) -d \"$(CLASSES_DIR)\"" > "$(TARGET_DIR)/scalac_opts.txt"
	@echo "$(SOURCES)" > "$(TARGET_DIR)/scalac_sources.txt"
	$(SCALAC) "@$(TARGET_DIR)/scalac_opts.txt" "@$(TARGET_DIR)/scalac_sources.txt"
	@echo "" > "$(TARGET)"

clean:
	rm -rf "$(TARGET_DIR)"

run: build
	$(SCALA) $(SCALA_FLAGS) $(MAIN_CLASS) $(MAIN_ARGS)

##############################################################################
## test rules

SCALA_LIB_JAR  = $(shell find "$(LOCAL_REPO)/org/scala-lang" -name scala-library-2.13.2.jar)
DOTTY_LIB_JAR  = $(shell find "$(LOCAL_REPO)/ch/epfl/lamp" -name dotty-library_0.25-0.25.0-RC2.jar)
HAMCREST_JAR   = $(shell find "$(LOCAL_REPO)/org/hamcrest" -name hamcrest-core-1.3.jar)
JUNIT_JAR      = $(shell find "$(LOCAL_REPO)/junit/junit" -name junit-4.13.jar)
JUNIT_INTF_JAR = $(shell find "$(LOCAL_REPO)/com/novocode" -name junit-interface-0.11.jar)

TEST_CPATH     = $(SCALA_LIB_JAR)$(PSEP)$(DOTTY_LIB_JAR)$(PSEP)$(HAMCREST_JAR)$(PSEP)$(JUNIT_JAR)$(PSEP)$(JUNIT_INTF_JAR)$(PSEP)$(CLASSES_DIR)
TEST_SOURCES   = $(shell find $(SOURCE_DIR)/test -name *.scala)
TEST_TARGET    = $(TARGET_DIR)/.latest-test-build

$(TEST_TARGET): $(TEST_SOURCES)
	[ -d "$(CLASSES_DIR)" ] || mkdir -p "$(CLASSES_DIR)"
	@echo "$(SCALAC_FLAGS) -classpath \"$(TEST_CPATH)\" -d \"$(CLASSES_DIR)\"" > "$(TARGET_DIR)/scalac_test_opts.txt"
	@echo "$(TEST_SOURCES)" > "$(TARGET_DIR)/scalac_test_sources.txt"
	$(SCALAC) "@$(TARGET_DIR)/scalac_test_opts.txt" "@$(TARGET_DIR)/scalac_test_sources.txt"
	@echo "" > "$(TEST_TARGET)"

test: build $(TEST_TARGET)
	$(JAVA) -classpath "$(TEST_CPATH)" org.junit.runner.JUnitCore $(MAIN_CLASS)Test

##############################################################################
## phony

.PHONY: all build clean run test

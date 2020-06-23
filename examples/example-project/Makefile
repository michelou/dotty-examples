include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

SCALAC_FLAGS = -deprecation -feature
SCALA_FLAGS  = -classpath "$(CLASSES_DIR)"

##############################################################################
## main rules

MAIN_CLASS = hello.Hello
MAIN_ARGS ?= 

SOURCES    = $(shell find $(SOURCE_DIR)/main -name *.scala)
TARGET     = $(TARGET_DIR)/.latest-build

all: build

build: $(JAVA_TARGET) $(TARGET)

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

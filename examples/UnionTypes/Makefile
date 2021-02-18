include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

SCALAC_FLAGS = -deprecation -feature
SCALA_FLAGS  = -classpath "$(CLASSES_DIR)"

##############################################################################
## main rules

SOURCES = $(shell find $(SOURCE_DIR)/main -name *.scala)
TARGET  = $(TARGET_DIR)/.latest-build

OPTS_FILE    = $(TARGET_DIR)/scalac_opts.txt
SOURCES_FILE = $(TARGET_DIR)/scalac_sources.txt

MAIN_CLASS = Main
MAIN_ARGS ?= 

all: build

build: $(JAVA_TARGET) $(TARGET)

$(TARGET): $(SOURCES)
	[ -d "$(CLASSES_DIR)" ] || mkdir -p "$(CLASSES_DIR)"
	@echo "$(SCALAC_FLAGS) -d \"$(CLASSES_DIR)\"" > "$(OPTS_FILE)"
	@echo "$(SOURCES)" > "$(SOURCES_FILE)"
	$(SCALAC) "@$(OPTS_FILE)" "@$(SOURCES_FILE)"
	@echo "" > "$(TARGET)"

clean:
	rm -rf "$(TARGET_DIR)"

run: build
	$(SCALA) $(SCALA_FLAGS) $(MAIN_CLASS) $(MAIN_ARGS)

##############################################################################
## test rules

TEST_SOURCES = $(shell find $(SOURCE_DIR)/test -name *.scala)
TEST_TARGET  = $(TARGET_DIR)/.latest-test-build

TEST_OPTS_FILE    = $(TARGET_DIR)/scalac_test_opts.txt
TEST_SOURCES_FILE = $(TARGET_DIR)/scalac_test_sources.txt

TEST_MAIN_CLASS  = $(MAIN_CLASS)Test
TEST_CLASSES_DIR = $(TARGET_DIR)/test-classes
TEST_CPATH       = $(SCALA_LIB_JAR)$(PSEP)$(SCALA3_LIB_JAR)$(PSEP)$(HAMCREST_JAR)$(PSEP)$(JUNIT_JAR)$(PSEP)$(JUNIT_INTF_JAR)$(PSEP)$(CLASSES_DIR)$(PSEP)$(TEST_CLASSES_DIR)

$(TEST_TARGET): $(TEST_SOURCES)
	[ -d "$(TEST_CLASSES_DIR)" ] || mkdir -p "$(TEST_CLASSES_DIR)"
	@echo "$(SCALAC_FLAGS) -classpath \"$(TEST_CPATH)\" -d \"$(TEST_CLASSES_DIR)\"" > "$(TEST_OPTS_FILE)"
	@echo "$(TEST_SOURCES)" > "$(TEST_SOURCES_FILE)"
	$(SCALAC) "@$(TEST_OPTS_FILE)" "@$(TEST_SOURCES_FILE)"
	@echo "" > "$(TEST_TARGET)"

test: build $(TEST_TARGET)
	$(JAVA) -classpath "$(TEST_CPATH)" org.junit.runner.JUnitCore $(TEST_MAIN_CLASS)

##############################################################################
## phony

.PHONY: all build clean run test

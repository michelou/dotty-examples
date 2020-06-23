MAIN_CLASS = Main
MAIN_ARGS ?= 

SOURCE_DIR  = src
SOURCES     = $(shell find $(SOURCE_DIR)/main -name *.scala)

TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes
TARGET      = $(TARGET_DIR)/.latest-build

OPTS_FILE   = $(TARGET_DIR)/scalac_opts.txt
SOURCES_FILE = $(TARGET_DIR)/scalac_sources.txt

ifeq ($(OS),Windows_NT)
SCALAC     = dotc.bat
SCALA      = dotr.bat
else
SCALAC     = dotc
SCALA      = dotr
endif
SCALAC_FLAGS = -deprecation -feature
SCALA_FLAGS  = -classpath "$(CLASSES_DIR)"

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

.PHONY: all build clean run

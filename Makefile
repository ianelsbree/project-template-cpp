#*##############################################################################
#* Automatic C++ Project Makefile
#* By Ian Elsbree
#* v2023.02.16
#*
#* This makefile is set up to build a C++ project. The only configuration needed
#* is marked by "#?" comments. It will automatically detect source files and
#* generate dependencies as needed. Look through it to see how it works.
#*##############################################################################

#? Project name, e.g. My Project
PROJECTNAME=
ifndef PROJECTNAME
$(error PROJECTNAME is not defined)
endif

PROJNAME=$(shell echo "$(PROJECTNAME)" | tr '[:upper:] ' '[:lower:]_')

# Relevant directories
VPATH=config data doc src target

#? Executable name, e.g. target/executable
BINARY=
ifndef BINARY
$(error BINARY is not defined)
endif

BINARY:=target/$(BINARY)

# Relevant files
SOURCES=$(wildcard src/*.cpp)
OBJECTS=$(patsubst src%,target%,$(patsubst %.cpp,%.o,$(SOURCES)))
DEPENDS=$(patsubst src%,target%,$(patsubst %.cpp,%.d,$(SOURCES)))

#? Compiler settings
CC=g++
CSTD=c++11
OPT=0
CFLAGS=-O$(OPT) -g -Wextra -Werror -Wall -std=$(CSTD) -pedantic -MD -MP -Isrc

#? Valgrind settings (optional)
VALGRIND=valgrind -q --leak-check=full --show-reachable=yes --tool=memcheck

all: $(BINARY) doc/refman.pdf $(PROJNAME).zip

# Build targets
$(BINARY): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^

target/%.o: src/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Cleanup
clean:
	rm -rf $(BINARY) $(OBJECTS) $(DEPENDS)

# Documentation and exportation targets
doc/refman.pdf: config/Doxyfile $(SOURCES) $(wildcard src/*.h) Makefile
	(cat $< ; echo "PROJECT_NAME=\"$(PROJECTNAME)\"") | doxygen -
	(cd latex; make > /dev/null)
	cp latex/refman.pdf doc/refman.pdf
	rm -r latex

typescript: $(BINARY)
	$(info ERROR: typescript needs to be made interactively:)
	$(info -------------------------------------------------)
	$(info $$ script)
	$(info $$ config/script.sh)
	$(info $$ exit)
	$(info -------------------------------------------------)
	$(error ERROR: typescript needs to be made interactively)

$(PROJNAME).zip: $(SOURCES) $(wildcard src/*.h)
	zip $(PROJNAME).zip -j $^

# Testing targets
test:
# todo:	make clean
# todo:	make $(BINARY)
# todo: $(BINARY) args | diff output.txt -
# todo: $(VALGRIND) $(BINARY) 1>/dev/null

setup:
ifeq ($(wildcard $(VPATH)),)
	mkdir $(VPATH)
	doxygen -g config/Doxyfile > /dev/null
	echo "QUIET                  = YES" >> config/Doxyfile
	echo "INPUT                  = src" >> config/Doxyfile
	echo "GENERATE_HTML          = NO" >> config/Doxyfile
	echo "COMPACT_LATEX          = YES" >> config/Doxyfile
	echo "PAPER_TYPE             = letter" >> config/Doxyfile
	touch config/script.sh
	echo "#!/usr/bin/bash" > config/script.sh
	chmod +x config/script.sh
	@echo Project directory initialized.
else
	@echo Project structure already exists. To reinitialize,  delete all \
	directories created during setup.
endif

-include $(DEPENDS)
.PHONY: test setup

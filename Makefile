#*##############################################################################
#* Automatic C Project Makefile
#* By Ian Elsbree
#* v2022.10.26
#* 
#* This makefile is set up to build a C project. The only configuration needed
#* is marked by "#?" comments. It will automatically detect source files and
#* generate dependencies as needed. Look through it to see how it works.
#*##############################################################################

#? Project name, e.g. My Project
PROJECTNAME=

PROJNAME=$(shell echo "$(PROJECTNAME)" | tr '[:upper:] ' '[:lower:]_')

# Relevant directories
VPATH=config data doc src target

#? Executable name, e.g. target/executable
BINARY=

BINARY:=target/$(BINARY)

# Relevant files
SOURCES=$(wildcard src/*.c)
OBJECTS=$(patsubst src%,target%,$(patsubst %.c,%.o,$(SOURCES)))
DEPENDS=$(patsubst src%,target%,$(patsubst %.c,%.d,$(SOURCES)))

#? Compiler settings
CC=gcc
CSTD=c90
OPT=0
CFLAGS=-g -O -Wextra -Werror -Wall -std=$(CSTD) -pedantic -O$(OPT) -MD -MP -Isrc

#? Valgrind settings (optional)
VALGRIND=valgrind -q --leak-check=full --show-reachable=yes --tool=memcheck 

all: $(BINARY)

# Build targets
$(BINARY): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^

target/%.o: src/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Cleanup
clean:
	rm -rf $(BINARY) $(OBJECTS) $(DEPENDS)

# Documentation and exportation targets
doc/refman.pdf: config/Doxyfile $(SOURCES) Makefile
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

$(PROJNAME).zip: $(SOURCES) src/*.h doc/refman.pdf typescript
	zip $(PROJNAME).zip -j $^

# Testing targets
test:
# todo:	make clean
# todo:	make $(BINARY)
# todo: $(BINARY) args | diff output.txt -
# todo: $(VALGRIND) $(BINARY) 1>/dev/null

setup:
	mkdir data doc src target

-include $(DEPENDS)
.PHONY: test setup

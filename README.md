# C++ Project Template

This folder contains a template structure for a moderate-complexity C++ project. The makefile is where the important stuff is. It's configured for automatic source file detection and dependency generation. There are some directories set up here, and you should probably keep them how they are unless you know how to properly modify the makefile.

## Setup

Download the makefile (named `Makefile`). Run `make setup` to create the necessary directories. Place your source files in the `src/` directory. Look at the makefile to see what needs to be edited there. Enjoy.

## Directories

- config/
  - Contains the `Doxyfile` and `script.sh`
- data/
  - For your `.txt` files for sample inputs and outputs
- doc/
  - For the documentation for the project including the handout and refman PDFs
- src/
  - For all of your `.cpp` and `.h` files
- target/
  - Where the object files, dependency files, and output binary will be placed

## Makefile

Use the makefile to make all the different components of the project. You can read through it to see what the different targets available are.

---
By Ian Elsbree, 2023-02-16

ianelsbree@gmail.com

ian.elsbree@digipen.edu

#!/bin/bash

# Program name "GNU Sort Debugger"
# Author: Konner Rigby
# Author Email: rigbykonner@csu.fullerton.edu or rigbykonner@gmail.com
# CWID: 884547654
# Class: 240-03 Section 03
# This file is the script file that accompanies the "GNU Sort Debugger" program.
# Prepare for execution in normal mode (not gdb mode).


echo "--- Cleaning old files ---"
rm -f *.o *.lis gdb-learn

echo "--- Assembling Assembly Modules ---"
nasm -f elf64 -g -F dwarf -o manager.o manager.asm -l manager.lis
nasm -f elf64 -g -F dwarf -o inputarray.o inputarray.asm -l inputarray.lis
nasm -f elf64 -g -F dwarf -o outputarray.o outputarray.asm -l outputarray.lis
nasm -f elf64 -g -F dwarf -o sum.o sum.asm -l sum.lis
nasm -f elf64 -g -F dwarf -o swap.o swap.asm -l swap.lis
nasm -f elf64 -g -F dwarf -o isfloat.o isfloat.asm -l isfloat.lis

echo "--- Compiling C Modules ---"
gcc -c -m64 -g -o executive.o executive.c -fno-pie -no-pie
gcc -c -m64 -g -o sort.o sort.c -fno-pie -no-pie

echo "--- Linking All Object Files ---"
gcc -m64 -g -o gdb-learn executive.o manager.o inputarray.o outputarray.o sort.o swap.o sum.o isfloat.o -fno-pie -no-pie

echo "--- Build complete. Executable is 'gdb-learn' ---"
echo
echo "--- Now launching GDB... ---"
echo "You can now enter the GDB commands for the assignment."

gdb ./gdb-learn
#!/bin/bash

# Program name: Sum of Values Build Script
# Author: konner rigby
# Email: rigbykonner@csu.fullerton.edu
# CWID: 884547654
# Class: 240-03 Section 03

# This script assembles, links, and runs the Sum of Values assignment.

echo "--- Assembling modules ---"

nasm -f elf64 -o arithmetic.o arithmetic.asm -l arithmetic.lis
nasm -f elf64 -o adder.o adder.asm -l adder.lis
nasm -f elf64 -o get_numbers.o get_numbers.asm -l get_numbers.lis
nasm -f elf64 -o display_array.o display_array.asm -l display_array.lis
nasm -f elf64 -o ftoa.o ftoa.asm -l ftoa.lis
nasm -f elf64 -o getline.o getline.asm -l getline.lis
nasm -f elf64 -o getchar.o getchar.asm -l getchar.lis
nasm -f elf64 -o atof.o atof.asm -l atof.lis
nasm -f elf64 -o isfloat.o isfloat.asm -l isfloat.lis

echo "--- Linking executable ---"
ld -o sum_app arithmetic.o adder.o get_numbers.o display_array.o ftoa.o getline.o getchar.o atof.o isfloat.o

echo "--- Build complete. Running program... ---"
echo ""
./sum_app
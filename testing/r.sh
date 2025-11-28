#!/bin/bash

# Program name "Array of Floats"
# Author: Konner Rigby
# Author Email: rigbykonner@csu.fullerton.edu or rigbykonner@gmail.com
# CWID: 884547654
# Class: 240-03 Section 03
# This file is the script file that accompanies the "Arrays of Floating Point Numbers" program.
# Prepare for execution in normal mode (not gdb mode).

echo "--- Cleaning old files ---"
# Use -f to suppress errors if files don't exist
rm -f *.o *.lis arrays

echo "--- Assembling Assembly Modules ---"
nasm -f elf64 -g -o manager.o manager.asm -l manager.lis
nasm -f elf64 -g -o input_array.o input_array.asm -l input_array.lis
nasm -f elf64 -g -o isfloat.o isfloat.asm -l isfloat.lis
nasm -f elf64 -g -o magnitude.o magnitude.asm -l magnitude.lis
nasm -f elf64 -g -o append.o append.asm -l append.lis
nasm -f elf64 -g -o mean.o mean.asm -l mean.lis

echo "--- Compiling C Modules ---"
# Based on your file list, you are using main.c
gcc -c -m64 -g -o main.o main.c -fno-pie -no-pie
gcc -c -m64 -g -o display_array.o display_array.c -fno-pie -no-pie

echo "--- Linking All Object Files ---"
# Since main.c is used, we link with gcc.
# Listing all .o files explicitly is safer than using *.o
gcc -m64 -g -o arrays main.o display_array.o manager.o input_array.o isfloat.o magnitude.o append.o mean.o -fno-pie -no-pie -lm

echo "--- Executing the Program ---"
./arrays

echo "--- This bash script will now terminate. ---"


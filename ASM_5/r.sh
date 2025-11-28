#!/bin/bash

# Program name: Non-deterministic Random Numbers
# Author: Konner Rigby
# Class: 240-03 Section 03
#
# This script file compiles and links all "pure assembly" syscall modules.

echo "--- Cleaning old files ---"
rm -f *.o *.lis random_gen

echo "--- Assembling Assembly Modules ---"
nasm -f elf64 -g -o executive.o executive.asm -l executive.lis
nasm -f elf64 -g -o fill_random_array.o fill_random_array.asm -l fill_random_array.lis
nasm -f elf64 -g -o isnan.o isnan.asm -l isnan.lis
nasm -f elf64 -g -o show_array.o show_array.asm -l show_array.lis
nasm -f elf64 -g -o normalize_array.o normalize_array.asm -l normalize_array.lis
nasm -f elf64 -g -o atoi.o atoi.asm -l atoi.lis
nasm -f elf64 -g -o ftoa.o ftoa.asm -l ftoa.lis
nasm -f elf64 -g -o qword_to_hex.o qword_to_hex.asm -l qword_to_hex.lis

echo "--- Linking All Object Files ---"
# We use 'ld' (the linker) directly for a true 'syscall' executable
# We specify the entry point as '_start'
ld -g -o random_gen executive.o fill_random_array.o isnan.o show_array.o normalize_array.o atoi.o ftoa.o qword_to_hex.o

echo "--- Executing the Program ---"
./random_gen

echo "--- This bash script will now terminate. ---"
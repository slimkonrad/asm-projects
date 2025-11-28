#!/bin/bash

# Author: Konner Rigby
# Program name: Assignment 5: Non-deterministic Random Numbers
# Purpose: This Bash script compiles, links, and runs the modular pure assembly program 'assign5'.

echo "🧹 Cleaning up previous build files..."
rm -f *.o assign5

# 1. Assemble the main executive file
echo "Assembling executive.asm..."
nasm -f elf64 -o executive.o executive.asm

# 2. Assemble the PURE ASM Output Helper
echo "Assembling write_string.asm (Output Utility)..."
nasm -f elf64 -o write_string.o write_string.asm

# 3. Assemble the NaN check routine
echo "Assembling isnan.asm (NaN Check)..."
nasm -f elf64 -o isnan.o isnan.asm

# 4. Assemble the random number generation routine
echo "Assembling fill_random_array.asm (RNG)..."
nasm -f elf64 -o fill_random_array.o fill_random_array.asm

# 5. Assemble the normalization routine
echo "Assembling normalize_array.asm (Normalization)..."
nasm -f elf64 -o normalize_array.o normalize_array.asm

# 6. Assemble the hexadecimal output routine
echo "Assembling show_array.asm (Hex Output)..."
nasm -f elf64 -o show_array.o show_array.asm


# Link all object files into the executable, explicitly setting the entry point
echo "🔗 Linking all object files into assign5..."
ld -o assign5 executive.o write_string.o isnan.o fill_random_array.o normalize_array.o show_array.o -e executive

# Run the program
echo "🚀 Running the program:"
./assign5
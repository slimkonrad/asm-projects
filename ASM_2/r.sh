#!/bin/bash
set -e
echo "--- Assembling NASM files ---"
nasm -f elf64 -g -F dwarf -o manager.o manager.asm
nasm -f elf64 -g -F dwarf -o input_array.o input_array.asm
nasm -f elf64 -g -F dwarf -o isfloat.o isfloat.asm
nasm -f elf64 -g -F dwarf -o magnitude.o magnitude.asm
nasm -f elf64 -g -F dwarf -o append.o append.asm
nasm -f elf64 -g -F dwarf -o mean.o mean.asm
echo "--- Compiling C files ---"
gcc -c -g -o main.o main.c -Wall -m64 -no-pie -std=c11
gcc -c -g -o display_array.o display_array.c -Wall -m64 -no-pie -std=c11
echo "--- Linking object files ---"
gcc -g -m64 -no-pie -o arr.out main.o manager.o input_array.o isfloat.o display_array.o magnitude.o append.o mean.o -lm
echo "--- Running the program ---"
./arr.out
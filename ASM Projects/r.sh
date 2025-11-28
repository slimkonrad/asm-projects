#!/bin/bash

#//****************************************************************************************************************************
#//* Program name: Arrays of floats                                                                                         *
#//* Copyright (C) 2025 Daniel Shively.                                                                                           *
#//* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
#//* version 3 as published by the Free Software Foundation. This program is distributed in the hope that it will be useful,   *
#//* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See    *
#//* the GNU General Public License for more details. A copy of the GNU General Public License v3 is available here:            *
#//* https://www.gnu.org/licenses/.                                                                                           *
#//****************************************************************************************************************************
#
#//========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3
#// Author information
#// Author: Daniel Shively
#// Author Email: danielshively36@gmail.com
#// CWID: 845182641
#//
#// Program information
#//   Program name: Sum of Values
#//   Programming languages: X86-64 Assembly, Bash
#//   Date program began: 2025-Sep-15
#//   Date of last update: 2025-Nov-02
#//   Files in this program: arithmetic.asm, adder.asm, get_numbers.asm, display_array.asm, ftoa.asm, getline.asm, getchar.asm,
#//   atof.asm, isfloat.asm, r.sh
#//   Status: Ready for release.
#//
#// Purpose
#//   This program demonstrates systems programming by managing an array of floating-point numbers using only x86-64 assembly
#//   and Linux syscalls.
#//
#// This file
#//   File name: r.sh
#//   Language: Bash
#//   Purpose: This script assembles all .asm modules, links them into an executable, and runs the program.
#//========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3

echo "--- Assembling modules ---"

nasm -f elf64 -g -F dwarf -o arithmetic.o arithmetic.asm -l arithmetic.lis
nasm -f elf64 -g -F dwarf -o adder.o adder.asm -l adder.lis
nasm -f elf64 -g -F dwarf -o get_numbers.o get_numbers.asm -l get_numbers.lis
nasm -f elf64 -g -F dwarf -o display_array.o display_array.asm -l display_array.lis
nasm -f elf64 -g -F dwarf -o ftoa.o ftoa.asm -l ftoa.lis
nasm -f elf64 -g -F dwarf -o getline.o getline.asm -l getline.lis
nasm -f elf64 -g -F dwarf -o getchar.o getchar.asm -l getchar.lis
nasm -f elf64 -g -F dwarf -o atof.o atof.asm -l atof.lis
nasm -f elf64 -g -F dwarf -o isfloat.o isfloat.asm -l isfloat.lis

echo "--- Linking executable ---"
ld -g -o sum_app arithmetic.o adder.o get_numbers.o display_array.o ftoa.o getline.o getchar.o atof.o isfloat.o

echo "--- Build complete. Running program... ---"
echo ""
./sum_app
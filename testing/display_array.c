//****************************************************************************************************************************
//* Program name: Arrays of floats                                                                                         *
//* Copyright (C) 2025 Konner Rigby.                                                                                           *
//* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//* version 3 as published by the Free Software Foundation. This program is distributed in the hope that it will be useful,   *
//* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See    *
//* the GNU General Public License for more details. A copy of the GNU General Public License v3 is available here:            *
//* <https://www.gnu.org/licenses/>.                                                                                           *
//****************************************************************************************************************************

//========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
// Author information
// Author: Konner Rigby
// Author Email: rigbykonner@csu.fullerton.edu or rigbykonner@gmail.com
// CWID: 884547654
// Class: 240-03 Section 03
//
// Program information
//   Program name: Arrays of floats
//   Programming languages: C, x86-64 Assembly, Bash
//   Date program began: 2025-Sep-10
//   Date of last update: 2025-Sep-17
//   Files in this program: main.c, manager.asm, input_array.asm, isfloat.asm, display_array.c, append.asm, magnitude.asm, 
//   mean.asm, r.sh.
//   Status: Ready for release.
//
// Purpose
//   This program demonstrates hybrid programming by managing arrays of floating-point numbers using both C and Assembly.
//
// This file
//   File name: display_array.c
//   Language: C
//   Compile: gcc -c -g -o display_array.o display_array.c
//   Purpose: A C function that receives a pointer to an array and its size, then prints the contents to the console.
//========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
#include <stdio.h>

// Receives a pointer to the array (array_of_floats) and its size (size).
void display_array(double array_of_floats[], long size) {
    printf("These numbers were received and placed into the array:\n");
    for (long i = 0; i < size; ++i) {
        // Print each float with 5 decimal places, followed by tabs for spacing.
        printf("%.5f\t", array_of_floats[i]);
    }
    printf("\n"); // Newline after printing all elements.
}
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
//
// Program information
//   Program name: Arrays of Integers
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
//   File name: main.c
//   Language: C
//   Compile: gcc -c -g -o main.o main.c
//   Purpose: The main C driver. Per assignment rules, it only contains the welcome/goodbye messages ("advertising") and 
//   the initial call to the assembly manager function.
//========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
#include <stdio.h>

// Prototype for the external assembly function.
extern double manager();

int main() {
    // Print the welcome message (Pink section)
    printf("Welcome to Arrays of Integers\n");
    printf("Brought to you by Konner Rigby \n\n");

    // Call the main assembly module, which runs the core logic.
    double final_result = manager();

    // Print the final message after returning from the manager (Pink section)
    printf("Main received %.10f, and will keep it for future use.\n", final_result);
    printf("Main will return 0 to the operating system.   Bye.\n");
    printf("============================================================\n");

    return 0;
}
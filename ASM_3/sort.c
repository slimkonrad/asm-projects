//****************************************************************************************************************************
//* Program name: GNU Sort Debugger                                                                                          *
//* Copyright (C) 2025 Konner Rigby.                                                                                         *
//* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//* version 3 as published by the Free Software Foundation. This program is distributed in the hope that it will be useful,   *
//* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See    *
//* the GNU General Public License for more details. A copy of the GNU General Public License v3 is available here:          *
//* <https://www.gnu.org/licenses/>.                                                                                         *
//****************************************************************************************************************************

//========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
// Author information
// Author: Konner Rigby
// Author Email: rigbykonner@csu.fullerton.edu or rigbykonner@gmail.com
// CWID: 884547654
// Class: 240-03 Section 03
//
// Program information
//   Program name: GNU Sort Debugger
//   Programming languages: C, x86-64 Assembly, Bash
//   Date program began: 2025-Oct-03
//   Date of last update: 2025-Oct-10
//   Files in this program: executive.c, manager.asm, inputarray.asm, outputarray.asm, sum.asm, sort.c, swap.asm,
//                          isfloat.asm, backuprestore.inc, r.sh
//   Status: Ready for GDB debugging.
//
// Purpose
//   This program serves as a workspace to experiment with and learn the capabilities of the GNU Debugger (GDB).
//
// This file
//   File name: sort.c
//   Language: C
//   Compile: gcc -c -g -m64 -o sort.o sort.c -fno-pie -no-pie
//   Purpose: A C function to sort an array of doubles. It calls an external assembly function to perform the swaps.
//========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

#include <stdio.h>

// Declaration of the external assembly function 'swap'
extern void swap(double *a, double *b);

// This function sorts an array of doubles using the Bubble Sort algorithm.
void sort(double array[], long int size) {
    long int i, j;
    for (i = 0; i < size - 1; i++) {
        for (j = 0; j < size - i - 1; j++) {
            if (array[j] > array[j + 1]) {
                // Call the assembly function to swap the two elements
                swap(&array[j], &array[j + 1]);
            }
        }
    }
}
;****************************************************************************************************************************
;Program name: "Arrays of floats".  This program takes floating point number inputs from the user and puts them in an array. The array values are then printed, along with the variance of the numbers.
; Copyright (C) 2025  Konner Rigby.          *
;                                                                                                                           *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
;but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
;the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
;<https://www.gnu.org/licenses/>.                                                                                           *
;****************************************************************************************************************************




;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; Author information
; Author: Konner Rigby
; Author Email: rigbykonner@csu.fullerton.edu or rigbykonner@gmail.com
; CWID: 884547654
; Class: 240-03 Section 03
;
;Program information
;  Program name: Arrays of floats
;  Programming languages: Two modules in C, six in x86, and one in bash
;  Date program began: 2025-Sep-16
;  Date of last update: 2025-Sep-17
;  Files in this program: main.cpp, manager.asm, input_array.asm, mean.asm, isfloat.asm,
;  display_array.c, magnitude.asm, append.asm, r.sh.
;  Testing: Alpha testing completed.  All functions are correct.
;  Status: Ready for release to customers
;
;Purpose
;  This program takes floating point number inputs from the user and puts them in an array. The array
;  values are then printed, along with the variance of the numbers.
;
;This file:
;  File name: mean.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -l input.lis -o input.o input_array.asm
;  Assemble (debug): nasm -f elf64 -gdwarf -l input.lis -o input.o input_array.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: extern double input_array();
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

; mean.asm
; mean.asm
global mean

segment .text
mean:
    ; === Standard Prologue ===
    push    rbp
    mov     rbp, rsp
    push    r12
    push    r13
    push    r14

    mov     r12, rdi      ; array pointer
    mov     r13, rsi      ; size
    xor     r14, r14      ; loop counter
    xorpd   xmm0, xmm0    ; accumulator (REPLACED pxor)

    cmp     r13, 0
    je      finish

sum_loop_mean:
    cmp     r14, r13
    jge     calculate_mean
    addsd   xmm0, [r12 + r14 * 8]
    inc     r14
    jmp     sum_loop_mean

calculate_mean:
    cvtsi2sd xmm1, rsi
    divsd   xmm0, xmm1

finish:
    ; === Standard Epilogue ===
    pop     r14
    pop     r13
    pop     r12
    pop     rbp
    ret
;****************************************************************************************************************************
;* Program name: Arrays of floats                                                                                           *
;* Copyright (C) 2025 Konner Rigby.                                                                                         *
;* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;* version 3 as published by the Free Software Foundation. This program is distributed in the hope that it will be useful,   *
;* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See    *
;* the GNU General Public License for more details. A copy of the GNU General Public License v3 is available here:          *
;* <https://www.gnu.org/licenses/>.                                                                                         *
;****************************************************************************************************************************

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; Author information
; Author: Konner Rigby
; Author Email: rigbykonner@csu.fullerton.edu or rigbykonner@gmail.com
; CWID: 884547654
; Class: 240-03 Section 03
;
; Program information
;   Program name: Arrays of floats
;   Programming languages: C, x86-64 Assembly, Bash
;   Date program began: 2025-Sep-10
;   Date of last update: 2025-Sep-17
;   Files in this program: main.cpp, manager.asm, input_array.asm, isfloat.asm, display_array.c, append.asm, magnitude.asm,
;   mean.asm, r.sh.
;   Status: Ready for release.
;
; Purpose
;   This program demonstrates hybrid programming by managing arrays of floating-point numbers using both C and Assembly.
;
; This file
;   File name: magnitude.asm
;   Language: x86-64 Assembly (NASM)
;   Assemble: nasm -f elf64 -g -o magnitude.o magnitude.asm
;   Purpose: An assembly function that calculates the mathematical magnitude (Euclidean norm) of an array of floats.
;   The formula is sqrt(a_1^2 + a_2^2 + ... + a_n^2).
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

global magnitude

segment .text
magnitude:
    ; === Standard Prologue ===
    push    rbp
    mov     rbp, rsp
    push    r12
    push    r13
    push    r14

    mov     r12, rdi        ; r12 = array address (1st argument)
    mov     r13, rsi        ; r13 = array size (2nd argument)
    xor     r14, r14        ; r14 = loop counter, initialized to 0
    xorpd   xmm0, xmm0      ; xmm0 = accumulator for sum of squares, initialized to 0.0

sum_squares_loop:
    cmp     r14, r13        ; Compare counter (r14) with size (r13)
    jge     calculate_sqrt  ; If counter >= size, jump to finish

    ; Load the current float from the array
    movsd   xmm1, [r12 + r14 * 8]

    ; Square the number (xmm1 = xmm1 * xmm1)
    mulsd   xmm1, xmm1

    ; Add the squared number to our running total
    addsd   xmm0, xmm1

    inc     r14             ; Increment loop counter
    jmp     sum_squares_loop

calculate_sqrt:
    ; Calculate the square root of the sum of squares
    sqrtsd  xmm0, xmm0      ; xmm0 = sqrt(xmm0)

    ; The result is now in xmm0, which is the return register for floats.

    ; === Standard Epilogue ===
    pop     r14
    pop     r13
    pop     r12
    pop     rbp
    ret
;****************************************************************************************************************************
;* Program name: Arrays of floats                                                                                          *
;* Copyright (C) 2025 Daniel Shively.                                                                                      *
;* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License *
;* version 3 as published by the Free Software Foundation. This program is distributed in the hope that it will be useful,  *
;* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See   *
;* the GNU General Public License for more details. A copy of the GNU General Public License v3 is available here:           *
;* https://www.gnu.org/licenses/.                                                                                           *
;****************************************************************************************************************************

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3
; Author information
;   Author: Daniel Shively
;   Email: danielshively36@gmail.com
;   CWID: 845182641
;
; Program information
;   Program name: Sum of Values
;   Language: x86-64 Assembly (NASM)
;   Date program began: 2025-Sep-15
;   Date of last update: 2025-Nov-02
;   Files: arithmetic.asm, adder.asm, get_numbers.asm, display_array.asm, ftoa.asm,
;          getline.asm, getchar.asm, atof.asm, isfloat.asm, r.sh
;   Status: Ready for release.
;
; Purpose:
;   This module sums all the 64-bit floating-point numbers in a given array.
;
; File information:
;   File name: adder.asm
;   Compile: nasm -f elf64 -g -F dwarf -o adder.o adder.asm -l adder.lis
;   Purpose: Sums the array of floats.
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3

global adder

segment .text
adder:
    ; set up stack frame
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14

    ; rdi = array pointer
    ; rsi = count
    mov r12, rdi        ; save array pointer
    mov r13, rsi        ; save count
    mov r14, 0          ; index = 0
    xorpd xmm0, xmm0    ; sum = 0.0

adder_sum_loop:
    cmp r14, r13        ; check if index >= count
    jge adder_end_sum_loop

    addsd xmm0, [r12 + r14 * 8] ; sum += array[i]
    inc r14             ; i++
    jmp adder_sum_loop  ; continue loop

adder_end_sum_loop:
    ; result (sum) is in xmm0

    ; restore registers and return
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

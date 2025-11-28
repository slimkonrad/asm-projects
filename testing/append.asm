;****************************************************************************************************************************
;* Program name: Arrays of floats                                                                                     *
;* Copyright (C) 2025 Konner Rigby.                                                                                           *
;* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;* version 3 as published by the Free Software Foundation. This program is distributed in the hope that it will be useful,   *
;* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See    *
;* the GNU General Public License for more details. A copy of the GNU General Public License v3 is available here:            *
;* <https://www.gnu.org/licenses/>.                                                                                           *
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
;   File name: append.asm
;   Language: x86-64 Assembly (NASM)
;   Assemble: nasm -f elf64 -g -o append.o append.asm
;   Purpose: An assembly function that appends two source arrays into a single destination array.
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

; append.asm
; append.asm
global append

segment .text
append:
    ; === Standard Prologue ===
    push    rbp
    mov     rbp, rsp
    push    r12
    push    r13

    ; rdi=array1, rsi=size1, rdx=array2, rcx=size2, r8=dest_array
    xor     r12, r12   ; Loop counter
    xor     r13, r13   ; Destination index

copy_loop1:
    cmp     r12, rsi
    jge     end_loop1
    movsd   xmm0, [rdi + r12 * 8]  ; Load float into an xmm register
    movsd   [r8 + r13 * 8], xmm0   ; Store float from xmm register
    inc     r12
    inc     r13
    jmp     copy_loop1
end_loop1:
    xor     r12, r12

copy_loop2:
    cmp     r12, rcx
    jge     end_loop2
    movsd   xmm0, [rdx + r12 * 8]  ; Load float into an xmm register
    movsd   [r8 + r13 * 8], xmm0   ; Store float from xmm register
    inc     r12
    inc     r13
    jmp     copy_loop2
end_loop2:

    ; === Standard Epilogue ===
    pop     r13
    pop     r12
    pop     rbp
    ret
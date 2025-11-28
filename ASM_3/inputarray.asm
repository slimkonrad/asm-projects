;****************************************************************************************************************************
;* Program name: GNU Sort Debugger                                                                                          *
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
;   Program name: GNU Sort Debugger
;   Programming languages: C, x86-64 Assembly, Bash
;   Date program began: 2025-Oct-03
;   Date of last update: 2025-Oct-10
;   Files in this program: executive.c, manager.asm, inputarray.asm, outputarray.asm, sum.asm, sort.c, swap.asm,
;                          isfloat.asm, backuprestore.inc, r.sh
;   Status: Ready for GDB debugging.
;
; Purpose
;   This program serves as a workspace to experiment with and learn the capabilities of the GNU Debugger (GDB).
;
; This file
;   File name: inputarray.asm
;   Language: x86-64 Assembly
;   Assemble: nasm -f elf64 -g -F dwarf -o inputarray.o inputarray.asm
;   Purpose: An assembly function to read and validate a series of floating-point numbers from the user.
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

global input_array
%include "backuprestore.inc"

extern printf
extern scanf
extern atof
extern isfloat
extern stdin

segment .data
    floatformat   db  "%s", 0
    not_a_float   db  "The last input was invalid and not entered into the array", 10, 0
    full_message  db  "The array has been filled.", 10, 0

segment .bss
    buffer resb 800

segment .text
input_array:
    backup

    mov r15, rdi
    mov r14, rsi
    xor r13, r13

check_capacity:
    cmp r13, r14
    jge is_full

    mov rdi, floatformat
    mov rsi, buffer
    xor rax, rax
    call scanf

    cmp eax, -1
    je control_d

    mov rdi, buffer
    call isfloat
    cmp rax, 0
    je not_float

    mov rdi, buffer
    xor rax, rax
    call atof
    movsd xmm15, xmm0

    movsd [r15 + r13 * 8], xmm15

    inc r13
    jmp check_capacity

is_full:
    mov rdi, full_message
    xor rax, rax
    call printf
    jmp exit

not_float:
    mov rdi, not_a_float
    xor rax, rax
    call printf
    jmp check_capacity

control_d:
    jmp exit

exit:
    mov rax, r13

    restore
    ret
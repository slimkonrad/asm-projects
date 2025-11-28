;****************************************************************************************************************************
;* Program name: "Array of floats".  This program takes floating point number inputs from the user and puts them in an array. The array values are then printed, along with the variance of the numbers.
;* Copyright (C) 2025  Konner Rigby.                                                                                         *
;* *
;* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;* version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,  *
;* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See  *
;* the GNU General public license for more details A copy of the GNU General Public License v3 is available here:           *
;* <https://www.gnu.org/licenses/>.                                                                                           *
;****************************************************************************************************************************

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; Author information
; Author: Konner Rigby
; Author Email: rigbykonner@csu.fullerton.edu or rigbykonner@gmail.com
; CWID: 884547654
; Class: 204-03 Section 03
;
;Program information
;  Program name: Array of floats
;  Programming languages: Two modules in C, six in x86, and one in bash
;  Date program began: 2025-Sep-16
;  Date of last update: 2025-Sep-19
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
;  File name: input_array.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -l input.lis -o input.o input_array.asm
;  Assemble (debug): nasm -f elf64 -gdwarf -l input.lis -o input.o input_array.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: extern double input_array();
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; input_array.asm
global input_array
%include "backuprestore.inc"

extern printf
extern scanf
extern atof
extern isfloat
extern clearerr, stdin

segment .data
  floatformat   db  "%s", 0
  not_a_float   db  "The last input was invalid and not entered into the array", 10, 0
  full_message  db  "The array has been filled.", 10, 0

segment .bss
  buffer resb 800

segment .text
input_array:

; --- Standard Prologue ---
backup

; --- Save Arguments and Initialize Counters ---
mov r15, rdi      ; r15 = array address (1st argument)
mov r14, rsi      ; r14 = max size (2nd argument)
xor r13, r13      ; r13 = loop counter, initialized to 0

check_capacity:
    ; Compare the counter to the max array size
    cmp r13, r14
    jge is_full       ; If full, jump to the end message

    ; Prepare for scanf
    mov rdi, floatformat
    mov rsi, buffer
    xor rax, rax
    call scanf

    ; Check for EOF (Control-D) using eax, as per the rules
    cmp eax, -1
    je control_d

    ; Check if user's input is a valid float
    mov rdi, buffer
    call isfloat
    cmp rax, 0
    je not_float

    ; Convert the valid string to a float
    mov rdi, buffer
    xor rax, rax
    call atof
    movsd xmm15, xmm0 ; Save result to a non-volatile xmm register.

    ; Store the floating point number into the array at the correct index
    movsd [r15 + r13 * 8], xmm15

    ; Increase the counter and loop back
    inc r13
    jmp check_capacity

is_full:
    ; Inform user that the array is now full
    mov rdi, full_message
    xor rax, rax
    call printf
    jmp exit

not_float:
    ; Inform user that the input is invalid
    mov rdi, not_a_float
    xor rax, rax
    call printf
    jmp check_capacity

control_d:
    jmp exit

exit:
    ; Store the final count in rax to be returned
    mov rax, r13

; --- Standard Epilogue ---
restore
ret
;****************************************************************************************************************************
;* Program name: GNU Sort Debugger                                                                                          *
;* Copyright (C) 2025 Konner Rigby.                                                                                         *
;* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;* version 3 as published by the Free Software Foundation. This program is distributed in the hope that it will be useful,   *
;* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See    *
;* the GNU General Public License for more details. A copy of the GNU General Public License v3 is available here:          *
;* <https://www.gnu.org/licenses/>.                                                                                         *
;****************************************************************************************************************************

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; Author information
; Author: Konner Rigby
; Author Email: rigbykonner@csu.fullerton.edu or rigbykonner@gmail.com
; CWID: 884547654
; Class: 240-03 Section 03
;
; Program information
;   Program name: GNU Sort Debugger
;   Programming languages: C, x86-64 Assembly, Bash
;   Date program began: 2025-Oct-03
;   Date of last update: 2025-Oct-10
;   Files in this program: executive.c, manager.asm, inputarray.asm, outputarray.asm, sum.asm, sort.c, swap.asm,
;                          isfloat.asm, backuprestore.inc, r.sh
;   Status: Ready for GDB debugging.
;
; Purpose
;   This program serves as a workspace to experiment with and learn the capabilities of the GNU Debugger (GDB).
;
; This file
;   File name: fill_random_array.asm
;   Language: x86-64 Assembly
;   Assemble: nasm -f elf64 -o fill_random_array.o fill_random_array.asm
;   Purpose: A function to fill an array with cryptographically-secure random 64-bit integers
;           and validate that the integer, when interpreted as a double, is not a NaN.
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

extern printf
extern isnan

global fill_random_array
%include "backuprestore.inc"

segment .data
intformat db 10, "%d  %d", 10, 0 
int_float dq "%18.13g",0

segment .bss

segment .text
fill_random_array:

; Function Prologue: Save used non-volatile GPRs
backup

; RDI (array address) -> R15
; RSI (array count) -> R14
mov r15, rdi
mov r14, rsi

; R13 is the loop counter (index)
mov r13, 0

; --- Array Fill Loop Start ---
check_capacity:
; Check if loop counter (R13) is less than array count (R14)
cmp r13, r14
jl is_less

; If R13 >= R14, exit the function
jmp exit

is_less:

; --- Generate and Validate Random Number ---
fill_array:
mov rax, 0
; Use RDRAND instruction to generate a 64-bit random number into R12
rdrand r12

push r12
movsd xmm15, [rsp]
pop r12

; Check if the generated number (in XMM15) is a NaN
movsd xmm0, xmm15 ; Pass value to XMM0 for the 'isnan' call
call isnan
cmp rax, 0
je fill_array ; If return value is 0 (is NaN), try again

; If number is valid (not NaN), store into array
movsd [r15+r13*8], xmm15
    
; Increment loop counter and check capacity again
inc r13
jmp check_capacity

; --- Array Fill Loop End ---
exit:
; Function Epilogue: Restore used non-volatile GPRs
restore
ret
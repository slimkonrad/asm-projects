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
;   File name: normalize_array.asm
;   Language: X86-64 Assembly
;   Assemble: nasm -f elf64 -o normalize_array.o normalize_array.asm
;   Purpose: A function to normalize a 64-bit float array by setting the exponent field to 0x3FF,
;           which effectively scales each value to the range [1.0, 2.0).
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

global normalize_array
%include "backuprestore.inc"
segment .data

segment .bss

segment .text
normalize_array:

; Function Prologue: Save all GPRs
backup

; RDI (array address) -> R15 (non-volatile)
; RSI (array count) -> R14 (non-volatile)
mov r15, rdi
mov r14, rsi

; R13 is the loop counter (index)
mov r13, 0

; --- Normalization Loop Start ---
check_capacity:
; Check if loop counter (R13) is less than array count (R14)
cmp r13, r14
jl is_less

; If R13 >= R14, exit the function
jmp exit

is_less:
; Load 64-bit double from array into XMM15
movsd xmm15, [r15+r13*8]

; Move XMM15 content (double) into R12 (integer view) via stack
push qword 0
movsd [rsp], xmm15
pop r12

; Mask off the sign and exponent bits (top 12 bits) of the 64-bit value
shl r12, 12
shr r12, 12

; Load the new canonical exponent for normalization (0x3FF0000000000000)
mov rax, 0x3ff0000000000000

; OR the new exponent/sign with the masked mantissa in R12
or r12, rax

; Move the normalized 64-bit integer back to XMM15 (double view) via stack
push r12
movsd xmm15, [rsp]
pop r12

; Store the normalized double back into the array
movsd [r15+r13*8], xmm15
  
; Increment loop counter
inc r13
jmp check_capacity

; --- Normalization Loop End ---
exit:
; Function Epilogue: Restore all GPRs
restore
ret
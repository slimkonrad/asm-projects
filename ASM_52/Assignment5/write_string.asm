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
;   File name: write_string.asm
;   Language: x86-64 Assembly
;   Assemble: nasm -f elf64 -o write_string.o write_string.asm
;   Purpose: A utility function to print a null-terminated string to standard output (STDOUT) using the sys_write syscall.
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

global write_string

segment .text
write_string:
    ; Function Prologue: Save used GPRs
    push rbp
    mov rbp, rsp
    push rbx
    push rdi          
    
    ; RDI holds the address of the string
    mov rbx, rdi      

; --- Calculate String Length ---
.count_loop:
    cmp byte [rbx], 0
    je .count_done
    inc rbx
    jmp .count_loop

.count_done:
    ; RDX = length of the string
    sub rbx, rdi
    mov rdx, rbx

    ; --- Perform sys_write ---
    mov rax, 1        ; syscall number for sys_write
    pop rsi           ; RSI is the string address (restored RDI)
    mov rdi, 1        ; File Descriptor for stdout
    
    syscall           

    ; Function Epilogue: Restore used GPRs
    pop rbx
    pop rbp
    ret
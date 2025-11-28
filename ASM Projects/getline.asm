; //****************************************************************************************************************************
; //* Program name: Arrays of floats                                                                                         *
; //* Copyright (C) 2025 Daniel Shively.                                                                                           *
; //* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
; //* version 3 as published by the Free Software Foundation. This program is distributed in the hope that it will be useful,   *
; //* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See    *
; //* the GNU General Public License for more details. A copy of the GNU General Public License v3 is available here:            *
; //* https://www.gnu.org/licenses/.                                                                                           *
; //****************************************************************************************************************************

; //========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3
; // Author information
; // Author: Daniel Shively
; // Author Email: danielshively36@gmail.com
; // CWID: 845182641
; //
; // Program information
; //   Program name: Sum of Values
; //   Programming languages: X86-64 Assembly
; //   Date program began: 2025-Sep-15
; //   Date of last update: 2025-Nov-02
; //   Files in this program: arithmetic.asm, adder.asm, get_numbers.asm, display_array.asm, ftoa.asm, getline.asm, getchar.asm,
; //   atof.asm, isfloat.asm, r.sh
; //   Status: Ready for release.
; //
; // Purpose
; //   This module reads a full line of text from standard input using syscalls.
; //
; // This file
; //   File name: getline.asm
; //   Language: x86-64 Assembly (NASM)
; //   Compile: nasm -f elf64 -g -F dwarf -o getline.o getline.asm -l getline.lis
; //   Purpose: Reads a line of text from stdin.
; //========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3

global getline
extern getchar

segment .text
getline:
    ; Prologue
    push rbp
    mov rbp, rsp
    push r12
    push r13

    ; rdi = buffer pointer
    ; rsi = max size
    mov r12, rdi                ; Save buffer pointer
    mov r13, 0                  ; index

getline_read_loop:
    call getchar
    
    ; Check for EOF (returns 0)
    cmp rax, 0
    je getline_end_getline

    ; Check for newline (returns 0x0A)
    cmp rax, 0x0A
    je getline_store_newline_and_end

    ; Check buffer overflow
    cmp r13, rsi
    jge getline_end_getline             ; Silently drop chars if buffer is full

    ; Store char
    mov [r12 + r13], al
    inc r13
    jmp getline_read_loop

getline_store_newline_and_end:
    mov [r12 + r13], al         ; Store the newline
    inc r13

getline_end_getline:
    mov byte [r12 + r13], 0     ; Null terminate
    mov rax, r13                ; Return number of chars read (including newline)

    ; Epilogue
    pop r13
    pop r12
    pop rbp
    ret
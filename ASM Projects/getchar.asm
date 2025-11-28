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
; //   This module reads a single character from standard input using a Linux syscall.
; //
; // This file
; //   File name: getchar.asm
; //   Language: x86-64 Assembly (NASM)
; //   Compile: nasm -f elf64 -g -F dwarf -o getchar.o getchar.asm -l getchar.lis
; //   Purpose: Reads a single character from stdin.
; //========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3

global getchar

segment .bss
    char_buffer: resb 1

segment .text
getchar:
    ; Prologue
    push rbp
    mov rbp, rsp

    ; Syscall read
    mov rax, 0                  ; sys_read
    mov rdi, 0                  ; stdin
    mov rsi, char_buffer
    mov rdx, 1                  ; Read 1 byte
    syscall

    ; rax = bytes read
    ; If 0 or less (EOF/error), return 0
    cmp rax, 0
    jle getchar_return_eof

    ; Success, return the character
    movzx rax, byte [char_buffer]
    jmp getchar_end

getchar_return_eof:
    xor rax, rax                ; Return 0 for EOF

getchar_end:
    ; Epilogue
    pop rbp
    ret
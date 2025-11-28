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
; //   This module manages the user input loop for gathering float numbers.
; //
; // This file
; //   File name: get_numbers.asm
; //   Language: x86-64 Assembly (NASM)
; //   Compile: nasm -f elf64 -g -F dwarf -o get_numbers.o get_numbers.asm -l get_numbers.lis
; //   Purpose: Reads, validates, and stores floats in an array.
; //========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3

global get_numbers

extern getline
extern isfloat
extern atof

segment .data
    invalid_msg: db "Invalid float. Please try again.", 0x0A, 0
    invalid_len: equ $ - invalid_msg

segment .bss
    input_buffer: resb 100

segment .text
get_numbers:
    ; Prologue
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    ; rdi = array pointer
    ; rsi = max numbers
    mov r12, rdi                ; array pointer
    mov r13, 0                  ; number count (index)
    mov r15, rsi                ; max numbers

get_loop:
    cmp r13, r15                ; count < max
    jge end_get_loop

    ; Get line
    mov rdi, input_buffer
    mov rsi, 100
    call getline
    mov r14, rax                ; Save length in r14

    ; Check for EOF (Ctrl+D) ONLY
    cmp r14, 0
    je end_get_loop
    
not_empty_line:
    ; Stomp newline
    cmp byte [input_buffer + r14 - 1], 0x0A
    jne not_newline
    mov byte [input_buffer + r14 - 1], 0
    dec r14
    not_newline:

    ; Check for empty string *after stomping newline*
    cmp r14, 0
    je invalid_input

    ; Validate float
    ; isfloat saves and restores all GPRs
    mov rdi, input_buffer
    call isfloat
    
    cmp rax, 0                  ; Check if false
    je invalid_input

    ; --- Valid float, convert ---
    ; stringtof (atof) saves and restores all GPRs
    mov rdi, input_buffer
    call atof
    
    ; Store float in array
    movsd [r12 + r13 * 8], xmm0 
    inc r13
    jmp get_loop

invalid_input:
    ; Print "Invalid float"
    mov rax, 1
    mov rdi, 1
    mov rsi, invalid_msg
    mov rdx, invalid_len
    syscall
    jmp get_loop

end_get_loop:
    mov rax, r13                ; Return number of floats read

    ; Epilogue
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
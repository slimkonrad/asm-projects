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
; //   This module displays the contents of the float array to the console.
; //
; // This file
; //   File name: display_array.asm
; //   Language: x86-64 Assembly (NASM)
; //   Compile: nasm -f elf64 -g -F dwarf -o display_array.o display_array.asm -l display_array.lis
; //   Purpose: Displays the array of floats.
; //========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3

global display_array

extern ftoa

segment .data
    newline: db 0x0A, 0

segment .text
display_array:
    ; Prologue
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15                ; <<< FIX: Save r15 (clobbered by ftoa)
    push rbx

    ; rdi = array pointer
    ; rsi = count
    mov r12, rdi                ; array
    mov r13, rsi                ; count
    mov r14, 0                  ; index (i)

display_loop:
    cmp r14, r13                ; i < count
    jge end_display_loop

    ; 1. Convert float to string
    movsd xmm0, [r12 + r14 * 8] ; Load float
    
    ; Save loop registers (r12, r13, r14)
    ; ftoa clobbers them
    push r12
    push r13
    push r14
    
    call ftoa
    
    mov rbx, rax ; rax holds pointer to string from ftoa
    
    ; Restore loop registers
    pop r14
    pop r13
    pop r12

    ; 2. Get length of string
    mov rdi, rbx                ; rdi = string pointer
    call display_strlen         ; <<< RENAMED
    mov rdx, rax                ; Length for sys_write

    ; 3. Print float string
    mov rax, 1
    mov rdi, 1
    mov rsi, rbx                ; rsi = string pointer
    syscall

    ; 4. Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    inc r14
    jmp display_loop

end_display_loop:
    ; Epilogue
    pop rbx
    pop r15                ; 
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

; Local strlen function
; Input: rdi (string pointer)
; Output: rax (length)
display_strlen:             ; 
    push rdi
    push rbx
    mov rbx, rdi
    mov rax, 0
display_strlen_loop:        ;
    cmp byte [rbx + rax], 0
    je display_strlen_end
    inc rax
    jmp display_strlen_loop
display_strlen_end:         ; 
    pop rbx
    pop rdi
    ret
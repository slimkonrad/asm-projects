;****************************************************************************************************************************
;* Program name: Arrays of floats                                                                                           *
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
;   File name: manager.asm
;   Language: x86-64 Assembly (NASM)
;   Assemble: nasm -f elf64 -g -o manager.o manager.asm
;   Purpose: The main assembly module. It controls the program flow by calling all other functions to get input,
;   perform calculations, and display results.
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


; manager.asm
global manager
extern printf, input_array, display_array, append, magnitude, mean
extern clearerr, stdin

segment .data
    msg_header      db "This program will manage your arrays of 64-bit floats", 10, 0
    prompt_a        db "For array A enter a sequence of 64-bit floats separated by white space.", 10
                    db "After the last input press enter followed by Control+D:", 10, 0
    prompt_b        db 10, "For array B enter a sequence of 64-bit floats separated by white space.", 10
                    db "After the last input press enter followed by Control+D:", 10, 0
    magnitude_a_msg db "The magnitude of array A is %f", 10, 0
    magnitude_b_msg db "The magnitude of this array B is %f", 10, 0
    append_msg      db 10, "Arrays A and B have been appended and given the name A⊕B.", 10
                    db "A⊕B contains", 10, 0
    magnitude_ab_msg db "The magnitude of A⊕B is %f", 10, 0
    mean_ab_msg      db "The mean of A⊕B is %f", 10, 0

segment .bss
    array_a resq 100
    array_b resq 100
    array_ab resq 200
    size_a resq 1
    size_b resq 1
    magnitude_val resq 1

segment .text
manager:
    ; === Standard Prologue ===
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    r12
    push    r13
    sub     rsp, 8          ; Align stack and reserve 8 bytes for saving a float value

    ; Print header
    mov     rdi, msg_header
    xor     rax, rax
    call    printf

    ; === Process Array A ===
    mov     rdi, prompt_a
    xor     rax, rax
    call    printf
    mov     rdi, array_a
    mov     rsi, 100
    call    input_array
    mov     [size_a], rax
    mov     rdi, array_a
    mov     rsi, [size_a]
    call    display_array
    mov     rdi, array_a
    mov     rsi, [size_a]
    call    magnitude
    mov     rdi, magnitude_a_msg
    mov     rax, 1
    call    printf

    ; === Clear the EOF flag from stdin before reading again ===
    mov     rdi, [rel stdin]
    call    clearerr

    ; === Process Array B ===
    mov     rdi, prompt_b
    xor     rax, rax
    call    printf
    mov     rdi, array_b
    mov     rsi, 100
    call    input_array
    mov     [size_b], rax
    mov     rdi, array_b
    mov     rsi, [size_b]
    call    display_array
    mov     rdi, array_b
    mov     rsi, [size_b]
    call    magnitude
    mov     rdi, magnitude_b_msg
    mov     rax, 1
    call    printf

    ; === Append Arrays and Process Result ===
    mov     rdi, append_msg
    xor     rax, rax
    call    printf
    mov     rdi, array_a
    mov     rsi, [size_a]
    mov     rdx, array_b
    mov     rcx, [size_b]
    mov     r8, array_ab
    call    append
    mov     r12, [size_a]
    add     r12, [size_b]
    mov     r13, r12
    mov     rdi, array_ab
    mov     rsi, r13
    call    display_array
    
    ; Calculate magnitude and save it
    mov     rdi, array_ab
    mov     rsi, r13
    call    magnitude            ; xmm0 holds the magnitude
    movsd   [rel magnitude_val], xmm0  ; Save the magnitude to memory
    
    ; Display the magnitude
    mov     rdi, magnitude_ab_msg
    mov     rax, 1
    call    printf
    
    ; Calculate and display the mean, but don't save its return value
    mov     rdi, array_ab
    mov     rsi, r13
    call    mean
    mov     rdi, mean_ab_msg
    mov     rax, 1
    call    printf
    
    ; Restore the magnitude value to xmm0 for return to main
    movsd   xmm0, [rel magnitude_val]
    
    ; === Standard Epilogue ===
    add     rsp, 8
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    ret
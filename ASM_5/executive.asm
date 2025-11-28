;****************************************************************************************************************************
;* Program name: Non-deterministic Random Numbers                                                                           *
;* Copyright (C) 2025 Konner Rigby.                                                                                           *
;* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;* version 3 as published by the Free Software Foundation. This program is distributed in the hope that it will be useful,    *
;* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See    *
;* the GNU General Public License for more details. A copy of the GNU General Public License v3 is available here:            *
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
;   Program name: Non-deterministic Random Numbers
;   Programming languages: x86-64 Assembly, Bash
;   Date program began: 2025-Nov-12
;   Date of last update: 2025-Nov-12
;   Files in this program: executive.asm, fill_random_array.asm, isnan.asm,
;   show_array.asm, normalize_array.asm, atoi.asm, ftoa.asm, qword_to_hex.asm, r.sh
;   Status: Ready for release.
;
; Purpose
;   This program demonstrates using the rdrand instruction to generate
;   an array of non-deterministic random 64-bit floating point numbers.
;
; This file
;   File name: executive.asm
;   Function: _start (main entry point)
;   Purpose: Serves as the main driver for the program. (Syscall version)
;   Language: x86-64 Assembly
;   Syntax: Intel
;   Assembler: nasm -f elf64 -g -o executive.o executive.asm
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

; === Declarations ===
global _start
extern fill_random_array, show_array, normalize_array, atoi
; _start is the default entry point for the linker

; === System Call Constants ===
SYS_READ  equ 0
SYS_WRITE equ 1
SYS_EXIT  equ 60
STDIN     equ 0
STDOUT    equ 1

; === Initialized Data ===
segment .data
    msg_welcome_1:  db "Welcome to Random Products, LLC.", 10
    len_welcome_1:  equ $ - msg_welcome_1
    
    msg_welcome_2:  db "This software is maintained by Albert Einstein", 10, 10
    len_welcome_2:  equ $ - msg_welcome_2
    
    prompt_name:    db "Please enter your name: "
    len_prompt_name:equ $ - prompt_name
    
    prompt_title:   db "Please enter your title (Mr,Ms,Sargent,Chief,Project Leader,etc): "
    len_prompt_title:equ $ - prompt_title
    
    msg_greeting_1: db "Nice to meet you "
    len_greeting_1: equ $ - msg_greeting_1
    msg_greeting_2: db " "
    len_greeting_2: equ $ - msg_greeting_2
    msg_greeting_3: db 10, 10
    len_greeting_3: equ $ - msg_greeting_3

    msg_intro:      db "This program will generate 64-bit IEEE float numbers.", 10
    len_intro:      equ $ - msg_intro
    
    prompt_how_many:db "How many numbers do you want. Today’s limit is 100 per customer. "
    len_how_many:   equ $ - prompt_how_many
    
    msg_error:      db 10, "Invalid input. Please enter a number between 1 and 100.", 10
    len_error:      equ $ - msg_error
    
    msg_stored:     db "Your numbers have been stored in an array. Here is that array.", 10, 10
    len_stored:     equ $ - msg_stored
    
    msg_normalize:  db 10, "The array will now be normalized to the range 1.0 to 2.0. Here is the normalized array", 10, 10
    len_normalize:  equ $ - msg_normalize
    
    msg_goodbye_1:  db 10, "Good bye "
    len_goodbye_1:  equ $ - msg_goodbye_1
    msg_goodbye_2:  db ". You are welcome any time.", 10, 10
    len_goodbye_2:  equ $ - msg_goodbye_2
    
    msg_farewell_1: db "Oh, "
    len_farewell_1: equ $ - msg_farewell_1
    msg_farewell_2: db ". We hope you enjoyed your arrays.", 10
    len_farewell_2: equ $ - msg_farewell_2
    
    msg_zero:       db "A zero will be returned to the operating system.", 10
    len_zero:       equ $ - msg_zero

    MAX_SIZE:       dq 100

; === Uninitialized Data ===
segment .bss
    user_name:      resb 128    ; Buffer for name
    len_user_name:  resq 1
    user_title:     resb 128    ; Buffer for title
    len_user_title: resq 1
    input_buffer:   resb 128    ; Buffer for numeric input
    num_to_generate:resq 1       ; Storage for the validated count
    number_array:   resq 100    ; Storage for the random numbers (100 * 8 bytes)

; === Macro for sys_write ===
; Writes a string (arg1 = address, arg2 = length) to STDOUT
%macro sys_write 2
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, %1         ; Message address
    mov     rdx, %2         ; Message length
    syscall
%endmacro

; === Code ===
segment .text
_start:
    ; === Standard Prologue ===
    ; We don't need a C-style prologue for syscall
    push    rbp
    mov     rbp, rsp
    push    r12             ; Callee-saved register for user_name
    push    r13             ; Callee-saved register for user_title
    push    r14             ; Callee-saved register for num_to_generate
    push    r15             ; Callee-saved register for number_array base
    
    ; === Store buffer addresses for later use ===
    lea     r12, [user_name]
    lea     r13, [user_title]
    lea     r15, [number_array]

    ; === Block: Display Welcome Banner ===
    sys_write msg_welcome_1, len_welcome_1
    sys_write msg_welcome_2, len_welcome_2

    ; === Block: Get User Name ===
    sys_write prompt_name, len_prompt_name
    
    mov     rax, SYS_READ
    mov     rdi, STDIN
    mov     rsi, r12        ; user_name buffer
    mov     rdx, 128        ; max length
    syscall
    mov     [len_user_name], rax ; Save length (e.g., "Sam\n" = 4)

    ; === Block: Get User Title ===
    sys_write prompt_title, len_prompt_title

    mov     rax, SYS_READ
    mov     rdi, STDIN
    mov     rsi, r13        ; user_title buffer
    mov     rdx, 128
    syscall
    mov     [len_user_title], rax ; Save length
    
    ; === Block: Display Greeting ===
    sys_write msg_greeting_1, len_greeting_1
    
    mov     rdx, [len_user_title]
    dec     rdx                     ; Remove newline
    sys_write r13, rdx              ; Print title
    
    sys_write msg_greeting_2, len_greeting_2
    
    mov     rdx, [len_user_name]
    dec     rdx                     ; Remove newline
    sys_write r12, rdx              ; Print name
    
    sys_write msg_greeting_3, len_greeting_3

    ; === Block: Get and Validate Array Size ===
    sys_write msg_intro, len_intro

get_count_loop:
    sys_write prompt_how_many, len_how_many

    mov     rax, SYS_READ
    mov     rdi, STDIN
    lea     rsi, [input_buffer]
    mov     rdx, 128
    syscall
    ; rax now holds length of the number string (e.g., "6\n")
    
    lea     rdi, [input_buffer]
    call    atoi                ; Call our new atoi function
    mov     [num_to_generate], rax ; Save integer result
    mov     r14, rax            ; Move validated count to r14
    
    cmp     r14, 1
    jl      invalid_input       ; Use signed jump (jl)
    cmp     r14, [MAX_SIZE]
    jg      invalid_input       ; Use signed jump (jg)
    
    jmp     valid_input_done

invalid_input:
    sys_write msg_error, len_error
    jmp     get_count_loop
    
valid_input_done:
    sys_write msg_stored, len_stored

    ; === Block: Fill Random Array ===
    mov     rdi, r15        ; number_array
    mov     rsi, r14        ; count
    call    fill_random_array

    ; === Block: Display Initial Array ===
    mov     rdi, r15        ; number_array
    mov     rsi, r14        ; count
    call    show_array

    ; === Block: Normalize Array ===
    sys_write msg_normalize, len_normalize
    
    mov     rdi, r15        ; number_array
    mov     rsi, r14        ; count
    call    normalize_array

    ; === Block: Display Normalized Array ===
    mov     rdi, r15        ; number_array
    mov     rsi, r14        ; count
    call    show_array

    ; === Block: Display Farewell Messages ===
    sys_write msg_goodbye_1, len_goodbye_1
    
    mov     rdx, [len_user_title]
    dec     rdx
    sys_write r13, rdx              ; Print title
    
    sys_write msg_goodbye_2, len_goodbye_2
    
    sys_write msg_farewell_1, len_farewell_1
    
    mov     rdx, [len_user_name]
    dec     rdx
    sys_write r12, rdx              ; Print name
    
    sys_write msg_farewell_2, len_farewell_2
    
    sys_write msg_zero, len_zero

    ; === Standard Epilogue ===
    mov     rax, SYS_EXIT
    mov     rdi, 0          ; Return 0
    syscall
    
    ; We never reach 'ret', but we pop to be tidy
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbp
    ret
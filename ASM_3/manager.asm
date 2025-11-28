;****************************************************************************************************************************
;* Program name: GNU Sort Debugger                                                                                          *
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
;   Program name: GNU Sort Debugger
;   Programming languages: C, x86-64 Assembly, Bash
;   Date program began: 2025-Oct-03
;   Date of last update: 2025-Oct-10
;   Files in this program: executive.c, manager.asm, inputarray.asm, outputarray.asm, sum.asm, sort.c, swap.asm,
;                          isfloat.asm, backuprestore.inc, r.sh
;   Status: Ready for GDB debugging.
;
; Purpose
;   This program serves as a workspace to experiment with and learn the capabilities of the GNU Debugger (GDB).
;
; This file
;   File name: manager.asm
;   Language: x86-64 Assembly
;   Assemble: nasm -f elf64 -g -F dwarf -o manager.o manager.asm
;   Purpose: The central assembly module. It orchestrates the program flow by calling all other functions.
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

extern printf, fgets, input_array, outputarray, sum, sort, stdin
global manager

section .data
    prompt_name         db "Please enter your name: ", 0
    thank_you_name      db "Thank you %s", 0
    prompt_occupation   db "Please enter your future occupation: ", 0
    thank_you_occ       db "Thank you. We like %s", 0
    prompt_numbers      db "Please enter float numbers separated by ws. Press enter followed by cont-d to terminate.", 10, 0
    entered_numbers_msg db "Thank you. You entered these numbers:", 10, 0
    sum_msg             db "The sum of values in this array is %.1f", 10, 0
    sorting_msg         db "The array will now be sorted.", 10, 0
    sorted_array_msg    db "These are the current values in the array:", 10, 0
    terminate_msg       db "This program will terminate.", 10, 0
    nice_day_msg        db "Have a nice day %s", 10, 0
    invite_msg          db "Invite a %s to come with you next time.", 10, 0
    newline             db 10, 0

section .bss
    user_name       resb 100
    user_occupation resb 100
    go              resq 50

section .text

remove_newline:
    push    rcx
    mov     rcx, 0
find_newline_loop:
    cmp     byte [rdi + rcx], 10
    je      replace_newline
    cmp     byte [rdi + rcx], 0
    je      newline_not_found
    inc     rcx
    jmp     find_newline_loop
replace_newline:
    mov     byte [rdi + rcx], 0
newline_not_found:
    pop     rcx
    ret

manager:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 8
    push    rbx
    push    r12
    push    r13

    mov     rdi, prompt_name
    mov     rax, 0
    call    printf
    mov     rdi, user_name
    mov     rsi, 100
    mov     rdx, [stdin]
    call    fgets
    mov     rdi, thank_you_name
    mov     rsi, user_name
    mov     rax, 0
    call    printf

    mov     rdi, prompt_occupation
    mov     rax, 0
    call    printf
    mov     rdi, user_occupation
    mov     rsi, 100
    mov     rdx, [stdin]
    call    fgets
    mov     rdi, thank_you_occ
    mov     rsi, user_occupation
    mov     rax, 0
    call    printf
    mov     rdi, newline
    mov     rax, 0
    call    printf

    mov     rdi, prompt_numbers
    mov     rax, 0
    call    printf
    mov     rdi, go
    mov     rsi, 50
    call    input_array
    mov     r12, rax

    mov     rdi, entered_numbers_msg
    mov     rax, 0
    call    printf
    mov     rdi, go
    mov     rsi, r12
    call    outputarray

    mov     rdi, go
    mov     rsi, r12
    call    sum
    movsd   [rbp - 8], xmm0
    mov     rdi, sum_msg
    mov     rax, 1
    call    printf

    mov     rdi, sorting_msg
    mov     rax, 0
    call    printf
    mov     rdi, go
    mov     rsi, r12
    call    sort

    mov     rdi, sorted_array_msg
    mov     rax, 0
    call    printf
    mov     rdi, go
    mov     rsi, r12
    call    outputarray

    mov     rdi, terminate_msg
    mov     rax, 0
    call    printf
    mov     rdi, user_name
    call    remove_newline
    mov     rdi, nice_day_msg
    mov     rsi, user_name
    mov     rax, 0
    call    printf
    mov     rdi, user_occupation
    call    remove_newline
    mov     rdi, invite_msg
    mov     rsi, user_occupation
    mov     rax, 0
    call    printf

    movsd   xmm0, [rbp - 8]

    pop     r13
    pop     r12
    pop     rbx
    mov     rsp, rbp
    pop     rbp
    ret
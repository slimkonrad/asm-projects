;****************************************************************************************************************************
;* Program name: Non-deterministic Random Numbers                                                                           *
;* Copyright (C) 2025 Konner Rigby.                                                                                           *
;* This file is part of the Non-deterministic Random Numbers program.                                                       *
;****************************************************************************************************************************
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; Author information
; Author: Konner Rigby
; Author Email: rigbykonner@csu.fullerton.edu or rigbykonner@gmail.com
; CWID: 884547654
; Class: 240-03 Section 03
;
; This file
;   File name: strip_newline.asm
;   Function: strip_newline
;   Purpose: Finds the first newline ('\n') character in a string
;            and replaces it with a null terminator ('\0').
;   Language: x86-64 Assembly
;   Syntax: Intel
;   Assembler: nasm -f elf64 -g -o strip_newline.o strip_newline.asm
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

; === Declarations ===
global strip_newline
segment .bss
    ; This section is empty.
segment .data
    ; This section is empty.

; === Code ===
segment .text
strip_newline:
    ; === Standard Prologue ===
    push    rbp
    mov     rbp, rsp
    
    ; RDI = string buffer
    xor     rax, rax        ; Use RAX as loop counter 'i'

find_loop:
    ; === Find either newline or null terminator ===
    cmp     byte [rdi + rax], 10  ; Check for newline (ASCII 10)
    je      found_newline
    cmp     byte [rdi + rax], 0   ; Check for null terminator (ASCII 0)
    je      done
    
    inc     rax
    jmp     find_loop

found_newline:
    ; === Replace newline with null terminator ===
    mov     byte [rdi + rax], 0

done:
    ; === Standard Epilogue ===
    pop     rbp
    ret
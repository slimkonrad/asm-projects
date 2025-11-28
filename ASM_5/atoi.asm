;****************************************************************************************************************************
;* Program name: Non-deterministic Random Numbers                                                                           *
;* Copyright (C) 2025 Konner Rigby.                                                                                           *
;* This file is part of the Non-deterministic Random Numbers program.                                                       *
;****************************************************************************************************************************

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; Author information
; Author: Konner Rigby
;
; This file
;   File name: atoi.asm
;   Function: atoi
;   Purpose: Converts an ASCII string to a 64-bit integer.
;            Stops on the first non-digit character (like a newline).
;   Language: x86-64 Assembly
;   Syntax: Intel
;   Assembler: nasm -f elf64 -g -o atoi.o atoi.asm
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

global atoi

segment .text
atoi:
    ; rdi = pointer to string
    ; returns integer in rax
    
    push    rbp
    mov     rbp, rsp
    
    xor     rax, rax        ; rax = 0 (our accumulator)
    xor     rcx, rcx        ; rcx = 0 (our loop index)
    mov     r10, 10         ; for multiplication

parse_loop:
    movzx   r8, byte [rdi + rcx] ; Get current char

    ; Check for null terminator or newline
    cmp     r8, 0
    je      done
    cmp     r8, 10
    je      done

    ; Check if it's a digit (ASCII '0' to '9')
    cmp     r8, '0'
    jl      done            ; Not a digit (use signed jump)
    cmp     r8, '9'
    jg      done            ; Not a digit (use signed jump)

    ; It's a digit. Convert from ASCII to integer.
    sub     r8, '0'         ; r8 = r8 - 48
    
    ; Update accumulator: rax = (rax * 10) + digit
    mul     r10             ; rdx:rax = rax * 10 (we assume no overflow)
    add     rax, r8         ; Add the new digit

    inc     rcx
    jmp     parse_loop

done:
    pop     rbp
    ret
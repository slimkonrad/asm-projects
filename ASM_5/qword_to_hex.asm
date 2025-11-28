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
;   File name: qword_to_hex.asm
;   Function: qword_to_hex
;   Purpose: Converts a 64-bit integer into a 16-char hex string.
;            Uses only allowed GPR instructions.
;   Language: x86-64 Assembly
;   Syntax: Intel
;   Assembler: nasm -f elf64 -g -o qword_to_hex.o qword_to_hex.asm
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

global qword_to_hex

segment .data
    hex_digits: db "0123456789ABCDEF"

segment .text
qword_to_hex:
    ; rdi = 64-bit integer to convert
    ; rsi = pointer to 16-byte buffer
    
    push    rbp
    mov     rbp, rsp
    push    r12             ; Save callee-saved register
    
    mov     r12, rdi        ; r12 = our number
    mov     rdi, rsi        ; rdi = buffer pointer
    mov     r9, 16          ; r9 = loop counter
    mov     cl, 60          ; cl = initial shift amount

convert_loop:
    ; === This logic correctly runs 16 times ===
    ; It processes the nibble at shift `cl` (60, 56, ..., 4, 0)
    
    mov     rax, r12
    shr     rax, cl         ; Isolate the top nibble
    and     rax, 0x0F       ; Mask to get just that nibble
    
    lea     r8, [hex_digits]
    mov     al, [r8 + rax]  ; Get the ASCII hex char (using al is allowed)
    
    mov     [rdi], al       ; Store the char in the buffer
    
    inc     rdi             ; Increment buffer pointer
    sub     cl, 4           ; Decrement shift amount
    dec     r9
    jnz     convert_loop    ; jne is on the allowed list

    ; Loop finishes after 16 iterations
    
    pop     r12
    pop     rbp
    ret
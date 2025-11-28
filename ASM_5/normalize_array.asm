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
;   File name: normalize_array.asm
;   Function: normalize_array
;   Purpose: Normalizes an array of 64-bit doubles to the
;            range [1.0, 2.0) using bitwise manipulation.
;   Language: x86-64 Assembly
;   Syntax: Intel
;   Assembler: nasm -f elf64 -g -o normalize_array.o normalize_array.asm
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

; === Declarations ===
global normalize_array

; === Initialized Data ===
segment .data
    ; Mask to extract the 52-bit mantissa
    mantissa_mask:  dq 0x000FFFFFFFFFFFFF
    ; The new sign (0) and exponent (0x3FF) to apply
    new_exponent:   dq 0x3FF0000000000000
segment .bss
    ; This section is empty.

; === Code ===
segment .text
normalize_array:
    ; === Standard Prologue ===
    push    rbp
    mov     rbp, rsp
    push    r12             ; Callee-saved register for array base
    push    r13             ; Callee-saved register for count
    push    r14             ; Callee-saved register for loop counter

    ; === Save passed-in values ===
    mov     r12, rdi        ; r12 = array address
    mov     r13, rsi        ; r13 = count
    xor     r14, r14        ; r14 = loop counter i = 0

normalize_loop:
    ; === Begin main loop to normalize array ===
    cmp     r14, r13        ; Compare i with count
    jge     normalize_done  ; (using signed jump)
    
    ; Load the current random number's integer representation
    mov     rax, [r12 + r14 * 8]
    
    ; === Isolate original mantissa ===
    mov     rcx, [mantissa_mask]
    and     rax, rcx        ; RAX now holds only the mantissa
    
    ; === Combine mantissa with new exponent [1.0, 2.0) ===
    mov     rcx, [new_exponent]
    or      rax, rcx        ; RAX is now 0x3FF... | original_mantissa
    
    ; === Store normalized number back into array ===
    mov     [r12 + r14 * 8], rax
    
    inc     r14             ; i++
    jmp     normalize_loop

normalize_done:
    ; === Standard Epilogue ===
    pop     r14
    pop     r13
    pop     r12
    pop     rbp
    ret
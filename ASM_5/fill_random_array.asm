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
; This file
;   File name: fill_random_array.asm
;   Function: fill_random_array
;   Purpose: Fills a given array with 'n' valid 64-bit random numbers.
;            It calls isnan to check for NaNs.
;   Language: x86-64 Assembly
;   Syntax: Intel
;   Assembler: nasm -f elf64 -g -o fill_random_array.o fill_random_array.asm
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

; === Declarations ===
global fill_random_array
extern isnan

; === Uninitialized Data ===
segment .bss
    temp_double: resq 1 ; 8-byte scratch space for rax -> xmm0

; === Code ===
segment .text
fill_random_array:
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

main_fill_loop:
    ; === Begin main loop to fill array ===
    cmp     r14, r13        ; Compare i with count
    jge     fill_done       ; If i >= count, we are done

get_random_num_loop:
    ; === Obtain a valid random number ===
    rdrand  rax             ; Generate 64-bit random number in RAX
    jnc     get_random_num_loop ; If Carry Flag=0, rdrand failed, try again

    ; === Check if the random number is a NaN ===
    ; isnan expects the float in XMM0.
    ; We must move the bits from RAX -> memory -> XMM0
    
    mov     [temp_double], rax    ; Store 64-bit integer to memory
    movsd   xmm0, [temp_double]   ; Load it into XMM0 (This is an allowed instruction)
    
    ; Save registers before call
    push    rax
    push    r12
    push    r13
    push    r14
    
    call    isnan           ; isnan returns 1 in RAX if NaN, 0 otherwise
    
    pop     r14
    pop     r13
    pop     r12
    pop     rcx             ; Pop original random number (from rax) into RCX
    
    cmp     rax, 1          ; Did isnan return 1 (true)?
    je      get_random_num_loop ; If yes, it was a NaN. Discard and get new number.

    ; === Store valid number in array ===
    ; The valid number's bits are in RCX
    mov     [r12 + r14 * 8], rcx ; Store the 64-bit number in array[i]
    
    inc     r14             ; i++
    jmp     main_fill_loop

fill_done:
    ; === Standard Epilogue ===
    pop     r14
    pop     r13
    pop     r12
    pop     rbp
    ret
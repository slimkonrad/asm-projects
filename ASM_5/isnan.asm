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
;   File name: isnan.asm
;   Function: isnan
;   Purpose: This function will determine if an IEEE float number is a nan
;            by checking the exponent bits.
;   Language: x86-64 Assembly
;   Syntax: Intel
;   Assembler: nasm -f elf64 -g -o isnan.o isnan.asm
;   Source: CPSC 240 Website (Public Domain, F. Holliday)
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

global isnan

segment .data
    ;Empty
segment .bss
    ;Empty
segment .text
isnan:
    ; === Standard Prologue ===
    ; Back up the GPRs (General Purpose Registers)
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    pushf

    ; === Copy the incoming parameter to a GPR ===
    ; We need a temporary 8-byte slot on the stack.
    ; This is a very clever way to move xmm0 -> r8.
    push qword 0
    movsd [rsp], xmm0
    pop r8

    ; === Use shift instructions to isolate the stored exponent ===
    shl r8, 1           ; Shift left 1 (removes sign bit)
    shr r8, 53          ; Shift right 53 (isolates 11 exponent bits)

    ; === Is r8 equal to 2047 (0x7FF) or not? ===
    cmp r8, 2047
    je  it_is_a_nan
    mov rax, 0          ; 0 = false (not a NaN)
    jmp next
it_is_a_nan:
    mov rax, 1          ; 1 = true (is a NaN or Infinity)
next:

    ; The result (0 or 1) is now in rax

    ; === Standard Epilogue ===
    popf
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret
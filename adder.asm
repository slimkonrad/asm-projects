; //****************************************************************************************************************************
; //Program name: "adder". This program receives a pointer to an array of 64-bit floats and a count.
; //              It sums all the floats in the array and returns the result in xmm0.
; //
; //This file is part of the software program "Sum of Values".
; //****************************************************************************************************************************
; //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**//
;
; //Author information
; //  Author name: konner rigby
; //  Author email: rigbykonner@csu.fullerton.edu
; //  CWID: 884547654
; //  Class: 240-03 Section 03
; //
; //Program information
; //  Program name: Sum of Values
; //  Programming languages: X86 Assembly (NASM)
; //
; //Purpose
; //  The purpose of this file is to compute the sum of an array of 64-bit floating-point numbers.
; //
; //This file
; //   File name: adder.asm
; //   Language: x86 (NASM syntax)
; //   Compile: nasm -f elf64 -o adder.o -l adder.lis adder.asm
; //
; //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; //
; //
; //===== Begin code area ===========================================================================================================

global adder

segment .text
adder:
    ; Prologue
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14

    ; rdi = array pointer
    ; rsi = count
    mov r12, rdi                ; array pointer
    mov r13, rsi                ; count
    mov r14, 0                  ; index (i)
    xorpd xmm0, xmm0             ; sum = 0.0

sum_loop:
    cmp r14, r13                ; i < count
    jge end_sum_loop

    addsd xmm0, [r12 + r14 * 8] ; sum += array[i]
    inc r14
    jmp sum_loop

end_sum_loop:
    ; Result is already in xmm0

    ; Epilogue
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
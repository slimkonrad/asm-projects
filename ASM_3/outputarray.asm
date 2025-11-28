;******************************************************************************************************************
;Program name: "Array Management".  This program demonstrates how to pass an array to a called subprogram.        *
;Copyright (C) 2020 Floyd Holliday                                                                                *
;                                                                                                                 *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public*
;License version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it *
;will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A  *
;PARTICULAR PURPOSE.  See the GNU General Public License for more details.  A copy of the GNU General Public      *
;License v3 is available here:  <https://www.gnu.org/licenses/>.                                                  *
;******************************************************************************************************************

;The blank line separates the notice of copyright (rights reserved to the author) from the notice of license 
;(rights reserved to the people).  The actual license itself never appears in source code but is type found in an
;accompanying text file.

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2
;
;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu
;
;Program information
;  Program name: Array Management
;  Programming languages: Two modules in C, two modules in X86
;  Date program began:     2022-Mar-04
;  Date program completed: 2022-Mar-06
;  Date comments upgraded: 2022-Mar-06
;  Files in this program: director.c, supervisor.asm, output_array.asm, input_array.c, director.c 
;  Status: Complete.  Alpha testing is finished.  Extreme cases were tested and errors resolved.
;
;References for this program
;  Jorgensen, X86-64 Assembly Language Programming with Ubuntu
;
;Purpose (academic)
;  Show how to pass an array from a caller function to a called function.
;
;This file
;   File name: output_array.asm
;   Language: i-series microprocessor assembly
;   Syntax: Intel
;   Max page width: 116 columns
;   Assemble: nasm -f elf64 -o super.o supervisor.asm -l super.lis
;   Link: gcc -m64 -no-pie -o arr.out -std=c17 director.o super.o input.o output.o 
;   Reference regarding -no-pie: Jorgensen, page 226.
;   Prototype of this function:  long showlumber(double * trees, long count);
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2
;
;
;
;
;===== Begin code area ================================================================================================

;Declarations are collected together in this area
default rel
extern printf
global outputarray

segment .data
num_fmt db "%0.5lf", 10, 0        ; print a double then newline

segment .text
; void outputarray(const double* arr, uint64_t n)
;   rdi = arr, rsi = n
outputarray:
    push    rbp
    mov     rbp, rsp
    push    r12
    push    r13
    push    r14
    sub     rsp, 8                ; keep rsp%16==8 before calls

    mov     r12, rdi              ; arr base
    mov     r13, rsi              ; length
    xor     r14, r14              ; i = 0

.loop:
    cmp     r14, r13
    jge     .done

    movsd   xmm0, [r12 + r14*8]   ; load arr[i] (double)
    lea     rdi, [rel num_fmt]    ; format string
    mov     eax, 1                ; 1 FP arg in xmm0 for printf
    call    printf

    inc     r14
    jmp     .loop

.done:
    add     rsp, 8
    pop     r14
    pop     r13
    pop     r12
    pop     rbp
    xor     eax, eax              ; return 0
    ret
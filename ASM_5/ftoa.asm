;************************************************************************************************************
;* Program name: "Ftoa". "Flote to Analog". This program accepts a 64-bit                                   *
;* float number in IEEE754 format and converts it decimal-based string-formated representation of that number.*
;* Copyright (C) 2024 by Floyd Holliday                                                                     *
;* *
;* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General *
;* Public License version 3 as published by the Free Software Foundation. This program is distributed in the  *
;* hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY*
;* or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details  A copy of the    *
;* GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                         *
;************************************************************************************************************

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1
; Author information
;   Name: Floyd Holliday
;   Contact: holliday@fullerton.edu
;
; Program information
;   Program name: Test Ftoa
;   Programming languages: X86 (ftoa),  C++ (driver)
;   Date program development began Dec 28, 2024
;   Date of most recent update: Jan 20, 2025
;   Files: driver.cpp, ftoa.asm
;
; Function ftoa information
;   Function name: ftoa, an acronym for Float to Analog.
;   Version number: 1.0
;   License: GPL3.
;   Programming language: X86
;   Syntax:  Intel
;   Assemble instruction: nasm -f elf64 -l ftoa.lis -o ftoa.o ftoa.asm
;   Status: Final release.
;
; Prototype of ftoa:  char * ftoa(double x);
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2

;Declarations
ascii_zero equ 48
ascii_dot equ  46
integer_ten equ 10
string_len equ 64     ;The next programmer should take charge of setting string length
null equ 0
global ftoa

segment .data
   
    mark db "one",0

segment .bss
    number_string resb string_len

segment .text
ftoa:
    ; === Standard Prologue ===
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15

    ; Copy the passed in float number to xmm8
    movsd   xmm8, xmm0

    ; === Block: Determine the sign of the incoming number ===
    mov     r15, 0          ; r15 is the sign flag. 0 = positive
    xorpd   xmm0, xmm0      ; Create a temporary zero in xmm0
    ucomisd xmm8, xmm0
    ja      continue
    mov     r15, 1          ; 1 = negative
continue:

    ; === Block: Replace xmm8 with its absolute value ===
    xorpd   xmm0, xmm0
    subsd   xmm0, xmm8
    maxsd   xmm8, xmm0

    ; === Block: Extract integral part ===
    ; Remove the integral part of xmm8 and save that part as an unsigned integer in rax
    roundsd xmm6, xmm8, 3   ; 3 = truncate towards zero
    cvtsd2si rax, xmm6

    mov     r12, 0          ; r12 will count the number of digits in the integral part
    lea     r13, [number_string] ; r13 = pointer to our output string

beginleftsideofdot:
    cmp     r12, string_len - 1 ; Check for space available in the string r13
    jge     append_null
    cmp     rax, 0          ; If rax == 0 then break out of the loop
    je      outofloop
    
    ; Use div to get the last digit
    mov     r10, integer_ten
    xor     rdx, rdx        ; Clear rdx for 64-bit division
    div     r10             ; rax = rax / 10, rdx = remainder
    
    push    rdx             ; Push the remainder value
    inc     r12             ; Increment digit count
    jmp     beginleftsideofdot
outofloop:
    ; rax is now 0; r12 has counted the number of pushes onto the stack

    ; Let r14 be the index into the array r13
    xor     r14, r14

    ; === Block: Handle negative sign ===
    cmp     r15, 0
    je      positive
    mov     byte [r13], '-'
    inc     r14
    inc     r12             ; Account for the '-' char
positive:

    ; === Block: Pop digits and build integer-part string ===
leftsideofdot:
    cmp     r14, string_len
    jge     append_null
    cmp     r14, r12
    jge     appenddot
    pop     rax             ; The number popped is one of the decimal digits: 0..9
    add     al, ascii_zero  ; 48 equals the ascii value of zero
    mov     byte [r13 + r14], al
    inc     r14
    jmp     leftsideofdot

appenddot:
    ; Append one dot
    mov     byte [r13 + r14], ascii_dot
    inc     r14

    ; === Block: Convert fractional part ===
    ; Subtract the whole part from the original number leaving only the fractional part in xmm8.
    subsd   xmm8, xmm6

    ; Establish the constant 10.0 (ten decimal float)
    mov     r10, 10
    cvtsi2sd xmm10, r10     ; xmm10 is the constant 10.0

begin_fractional_loop:
    ; If the fractional part is 0.0, it is time to leave this loop.
    xorpd   xmm0, xmm0
    ucomisd xmm8, xmm0
    je      out_of_loop

    ; If there is no available space in the destination array r13 then this loop must stop.
    cmp     r14, string_len - 1
    jge     out_of_loop

    mulsd   xmm8, xmm10     ; Multiply fraction by 10 (e.g., 0.456 -> 4.56)
    roundsd xmm9, xmm8, 3   ; Truncate to get the whole part (e.g., 4.0)
    cvtsd2si r9, xmm9       ; Convert to integer (e.g., 4)
    add     r9, ascii_zero  ; Convert to char '4'
    mov     [r13 + r14], r9b ; Store '4' in string
    inc     r14
    subsd   xmm8, xmm9      ; Subtract whole part (e.g., 4.56 - 4.0 = 0.56)

    jmp     begin_fractional_loop

out_of_loop:
    ; --- trim trailing zeros from fractional part ---
.trim:
    cmp     r14, 0
    je      .maybe_add_zero
    cmp     byte [r13 + r14 - 1], '0'
    jne     .check_dot
    dec     r14
    jmp     .trim

.check_dot:
    ; if we stopped on '.', drop it (e.g., "10." -> "10")
    cmp     byte [r13 + r14 - 1], ascii_dot
    jne     .maybe_add_zero
    dec     r14

.maybe_add_zero:
    ; if the last char is a '.', append a single '0' (e.g., "4." -> "4.0")
    cmp     r14, 0
    je      append_null
    cmp     byte [r13 + r14 - 1], ascii_dot
    jne     append_null
    mov     byte [r13 + r14], ascii_zero
    inc     r14

append_null:
    ; Append the null char
    mov     byte [r13 + r14], null
    inc     r14

    mov     rax, r13        ; Send the string pointer back to the driver
    
    ; === Standard Epilogue ===
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    ret
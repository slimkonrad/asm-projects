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
;   File name: show_array.asm
;   Function: show_array
;   Purpose: Displays the array of 64-bit floats. (Syscall version)
;            Calls qword_to_hex and ftoa to print real values.
;   Language: x86-64 Assembly
;   Syntax: Intel
;   Assembler: nasm -f elf64 -g -o show_array.o show_array.asm
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

; === Declarations ===
global show_array
extern qword_to_hex, ftoa
; We removed 'extern strlen' because it is now in this file.

; === System Call Constants ===
SYS_WRITE equ 1
STDOUT    equ 1

; === Macro for sys_write ===
%macro sys_write 2
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, %1
    mov     rdx, %2
    syscall
%endmacro

; === Initialized Data ===
segment .data
    header:     db "IEEE754 form", 9, 9, "Standard Decimal", 10
    len_header: equ $ - header
    
    hex_prefix: db "0x"
    len_prefix: equ $ - hex_prefix
    
    ; Using two tabs for better spacing
    tab:        db 9, 9
    len_tab:    equ $ - tab
    
    newline:    db 10
    len_newline:equ $ - newline

; === Uninitialized Data ===
segment .bss
    hex_buffer:     resb 16 ; 16 hex chars (no null)

; === Code ===
segment .text
show_array:
    ; === Standard Prologue ===
    push    rbp
    mov     rbp, rsp
    push    r12             ; Callee-saved register for array base
    push    r13             ; Callee-saved register for count
    push    r14             ; Callee-saved register for loop counter
    push    r15             ; Callee-saved register for string pointer

    ; === Save passed-in values ===
    mov     r12, rdi        ; r12 = array address
    mov     r13, rsi        ; r13 = count
    
    ; === Print the two-column header ===
    sys_write header, len_header

    ; === Begin main loop to print array ===
    xor     r14, r14        ; r14 = loop counter i = 0

output_loop:
    cmp     r14, r13        ; Compare i with count
    jge     output_done     ; (using signed jump)

    ; --- Print Hex Value ---
    sys_write hex_prefix, len_prefix
    
    mov     rdi, [r12 + r14 * 8] ; Pass the 64-bit integer
    lea     rsi, [hex_buffer]    ; Pass the buffer
    call    qword_to_hex         ; Convert
    
    sys_write hex_buffer, 16     ; Write 16 hex chars

    ; --- Print Tab ---
    sys_write tab, len_tab
    
    ; --- Print Real Decimal Value using ftoa ---
    movsd   xmm0, [r12 + r14 * 8] ; Load float into xmm0
    
    ; Save registers before call
    push    r12
    push    r13
    push    r14
    
    call    ftoa            ; Call professor's ftoa function
    mov     r15, rax        ; Save the string pointer returned in rax
    
    ; We need the length of the string
    mov     rdi, rax
    call    strlen          ; Get string length (returns in rax)
    
    ; Restore registers
    pop     r14
    pop     r13
    pop     r12
    
    ; Print the string
    sys_write r15, rax      ; (rsi = pointer, rdx = length)
    
    ; --- Print Newline ---
    sys_write newline, len_newline

    inc     r14             ; i++
    jmp     output_loop

output_done:
    ; === Standard Epilogue ===
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbp
    ret

; === strlen function ===
; This is the helper function, now part of this file.
; It counts the number of bytes in a string until
; the null terminator.
; Input: RDI = pointer to string
; Output: RAX = length
strlen:
    push    rbp
    mov     rbp, rsp
    
    xor     rax, rax        ; rax = 0 (our counter)

count_loop:
    cmp     byte [rdi + rax], 0
    je      done
    inc     rax
    jmp     count_loop
    
done:
    pop     rbp
    ret
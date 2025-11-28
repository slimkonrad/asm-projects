;****************************************************************************************************************************
;* Program name: GNU Sort Debugger                                                                                          *
;* Copyright (C) 2025 Konner Rigby.                                                                                         *
;* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;* version 3 as published by the Free Software Foundation. This program is distributed in the hope that it will be useful,   *
;* but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See    *
;* the GNU General Public License for more details. A copy of the GNU General Public License v3 is available here:          *
;* <https://www.gnu.org/licenses/>.                                                                                         *
;****************************************************************************************************************************

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; Author information
; Author: Konner Rigby
; Author Email: rigbykonner@csu.fullerton.edu or rigbykonner@gmail.com
; CWID: 884547654
; Class: 240-03 Section 03
;
; Program information
;   Program name: GNU Sort Debugger
;   Programming languages: C, x86-64 Assembly, Bash
;   Date program began: 2025-Oct-03
;   Date of last update: 2025-Oct-10
;   Files in this program: executive.c, manager.asm, inputarray.asm, outputarray.asm, sum.asm, sort.c, swap.asm,
;                          isfloat.asm, backuprestore.inc, r.sh
;   Status: Ready for GDB debugging.
;
; Purpose
;   This program serves as a workspace to experiment with and learn the capabilities of the GNU Debugger (GDB).
;
; This file
;   File name: show_array.asm
;   Language: x86-64 Assembly
;   Assemble: nasm -f elf64 -o show_array.o show_array.asm
;   Purpose: A function to display the contents of a 64-bit float array by representing each double in
;           its 16-character hexadecimal IEEE754 format.
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

extern write_string 

global show_array
%include "backuprestore.inc"

segment .data
    header_msg db "IEEE754 form", 10, 0
    newline_char db 10, 0
    
segment .bss
    ; Buffer for "0x" + 16 hex chars + null terminator = 19 bytes
    output_buffer resb 19

segment .text

; --- I made a Helper Function: Convert 64-bit Integer (RDX) to 16-char Hex String (RDI) ---
; RDX: 64-bit value to convert
; RDI: Pointer to output buffer (19 bytes: "0x" + 16 chars + '\0')
hex_to_string:
    push rbp
    mov rbp, rsp
    push rax
    push rbx
    push rcx
    
    mov rbx, 16
    mov rcx, 4
    ; RDI is the buffer start, point RSI to the end for reverse filling
    mov rsi, rdi
    add rsi, 17

.loop:
    ; Isolate the current 4-bit nibble (0-15) by shifting
    mov rax, rdx          
    shl rax, 60
    shr rax, 60
    
    ; Convert nibble to ASCII hex digit
    cmp al, 9
    jle .add_digit      ; If 0-9, just add '0' (0x30)
    add al, 7           ; If A-F, add 7 for 'A' through 'F' (0x37 = 7)
    
.add_digit:
    add al, 0x30        ; Convert 0-F to '0'-'9' or 'A'-'F'
    
    mov byte [rsi], al  ; Store character in buffer
    
    shr rdx, 4          ; Move to the next nibble
    dec rsi             ; Move buffer pointer backward
    dec rbx
    
    jnz .loop
    
    ; Add "0x" prefix and null terminator
    mov byte [rdi], '0'
    mov byte [rdi+1], 'x'
    mov byte [rdi+18], 0
    
    pop rcx
    pop rbx
    pop rax
    pop rbp
    ret


show_array:
    ; Function Prologue: Save used GPRs
    backup
    
    ; RDI (array address) -> R15
    ; RSI (array count) -> R14
    mov r15, rdi
    mov r14, rsi
    
    ; Print header
    mov rdi, header_msg
    call write_string
    
    mov r13, 0 ; Loop counter (index)
    
print_loop:
    ; Check if counter < count
    cmp r13, r14 
    jge print_exit 
    
    ; Load 64-bit double value into RDX for conversion
    mov rdx, [r15 + r13 * 8] 
    
    ; RDI is the output buffer for hex_to_string
    mov rdi, output_buffer 
    
    ; Convert RDX (value) to RDI (hex string)
    call hex_to_string
    
    ; Print the hex string
    call write_string
    
    ; Print a newline after the value
    mov rdi, newline_char
    call write_string
    
    inc r13
    jmp print_loop
    
print_exit:
    ; Function Epilogue: Restore GPRs
    restore
    ret
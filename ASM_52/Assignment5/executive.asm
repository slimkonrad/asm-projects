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
;   File name: executive.asm
;   Language: x86-64 Assembly
;   Assemble: nasm -f elf64 -o executive.o executive.asm
;   Purpose: The main entry point and logic for array management, I/O, and function calls.
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


extern write_string
extern fill_random_array
extern show_array
extern normalize_array

global executive

%define MAX_COUNT 100
%define ARRAY_SIZE MAX_COUNT * 8
%define STRING_SIZE 48
%define INPUT_BUFFER_SIZE 32

segment .data
    
    welcome_msg db "Welcome to Random Products, LLC.", 10, 0
    maintainer_msg db "This software is maintained by Albert Einstein", 10, 10, 0
    
    prompt_for_name db "Please enter your name: ", 0
    prompt_for_title db "Please enter your title (Mr,Ms,Sargent,Chief,Project Leader,etc): ", 10, 0
    
    nice_to_meet_you_part1 db "Nice to meet you ", 0
    space_char db " ", 0
    newline_char_x2 db 10, 10, 0
    
    program_msg db "This program will generate 64-bit IEEE float numbers.", 10, 0
    amount db "How many numbers do you want. Today's limit is 100 per customer. ", 0
    bad_size db "Size not in range (0 < N <= 100). Try again.", 10, 0

    stored_msg db "Your numbers have been stored in an array. Here is that array.", 10, 10, 0
    normalized_msg db 10, "The array will now be normalized to the range 1.0 to 2.0. Here is the normalized array.", 10, 10, 0
    
    goodbye_msg db 10, "Good bye ", 0
    welcome_msg_end db ". You are welcome any time.", 10, 10, 0
    hope_enjoyed db " Oh, ", 0
    hope_enjoyed_end db ". We hope you enjoyed your arrays.", 10, 0
    zero_return_msg db "A zero will be returned to the operating system.", 10, 0

segment .bss
    align 64
    backup_storage_area resb 832

    user_name resb STRING_SIZE
    user_title resb STRING_SIZE
    input_buffer resb INPUT_BUFFER_SIZE
    my_array resq MAX_COUNT 
    
    array_count resq 1

segment .text

; --- Helper Function: Read String from STDIN and Convert to Unsigned 64-bit Integer ---
read_uint_from_stdin:
    
    ; Save callee-saved registers
    push r12
    push r13
    
    ; *** 1. Read Input from STDIN ***
    mov rax, 0              ; sys_read
    mov rdi, 0              ; FD for stdin
    mov rsi, input_buffer   ; Buffer address
    mov rdx, INPUT_BUFFER_SIZE 
    syscall                 
    
    mov r12, rax            ; R12 holds the number of bytes read
    
    ; Check for read error or zero bytes read
    cmp r12, 0
    jle .read_error
    
    ; *** 2. Null-terminate Input by replacing newline ***
    mov r9, input_buffer    
    add r9, r12             
    
    cmp byte [r9-1], 0xA    ; Check for newline (0xA)
    jne .skip_null_term     
    
    mov byte [r9-1], 0x0    ; Replace newline with null terminator (0x0)

.skip_null_term:
    ; R9 is now pointing to input_buffer

    ; --- 3. Skip leading whitespace/control characters ---
    mov r9, input_buffer 
    
.skip_whitespace:
    movzx rdx, byte [r9] 
    
    cmp rdx, 0x0         
    je .conversion_end   
    
    cmp rdx, 0x20        
    jle .is_whitespace   
    
    ; Start conversion if non-whitespace character is found
    jmp .start_conversion_loop 

.is_whitespace:
    inc r9
    jmp .skip_whitespace

.start_conversion_loop:
    ; --- 4. String to Integer Conversion Logic ---
    mov rax, 0              ; RAX = result
    mov r8, 10              ; R8 = 10 (Multiplier)
    ; R9 points to the first digit
    
.conversion_loop:
    movzx rdx, byte [r9]    ; Load byte, zero-extend
    
    ; Check if character is a digit (0-9)
    cmp rdx, 0x30           
    jl .conversion_end      
    cmp rdx, 0x39           
    jg .conversion_end
    
    sub rdx, 0x30           ; RDX = digit value (0-9)
    
    mov rcx, rdx            ; Save digit value
    
    mul r8                  ; RDX:RAX = RAX * 10
    
    add rax, rcx            ; Add the digit to the total
    
    inc r9
    jmp .conversion_loop

.conversion_end:
    ; Restore registers and return result in RAX
    pop r13
    pop r12
    ret
    
.read_error:
    mov rax, 0              ; Return 0 if read failed
    pop r13
    pop r12
    ret


executive:
    ; Function Prologue: Save all GPRs and FPU/SSE state
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

    ;mov rax,7
    ;mov rdx, 0
   ;xsave [backup_storage_area]


    ; --- I/O: Welcome and Maintainer Messages ---
    mov rdi, welcome_msg
    call write_string
    mov rdi, maintainer_msg
    call write_string

    ; --- Get User Name (sys_read) ---
    mov rdi, prompt_for_name
    call write_string
    
    mov rax, 0 ; sys_read
    mov rdi, 0 ; stdin
    mov rsi, user_name
    mov rdx, STRING_SIZE
    syscall
    
    ; Null terminate user name input
    mov rbx, user_name
    add rbx, rax
    mov byte [rbx-1], 0

    ; --- Get User Title (sys_read) ---
    mov rdi, prompt_for_title
    call write_string
    
    mov rax, 0
    mov rdi, 0
    mov rsi, user_title
    mov rdx, STRING_SIZE
    syscall
    
    ; Null terminate user title input
    mov rbx, user_title
    add rbx, rax
    mov byte [rbx-1], 0

    ; --- Print Greeting Message (Title + Name) ---
    mov rdi, nice_to_meet_you_part1
    call write_string
    mov rdi, user_title
    call write_string
    mov rdi, space_char
    call write_string
    mov rdi, user_name
    call write_string
    mov rdi, newline_char_x2
    call write_string


    ; --- Obtain Array Size from User ---
get_size:
    ; Zero out the input buffer
    mov rdi, input_buffer 
    mov rsi, INPUT_BUFFER_SIZE  
.zero_loop:
    mov byte [rdi], 0x0
    inc rdi
    dec rsi
    jnz .zero_loop
    
    mov rdi, program_msg
    call write_string
    mov rdi, amount
    call write_string
    
    ; Call function to read and convert input
    call read_uint_from_stdin
    
    mov r15, rax ; R15 = array size N
    
    ; Validation: 0 < N <= 100
    cmp r15, 0
    jle wrong_size
    cmp r15, MAX_COUNT
    jg wrong_size
    jmp continue

wrong_size:
    mov rdi, bad_size
    call write_string
    jmp get_size


continue:
    ; --- 1. Fill Array with Random IEEE754 Doubles ---
    mov rdi, my_array
    mov rsi, r15
    call fill_random_array

    ; --- Print Initial Array Contents ---
    mov rdi, stored_msg
    call write_string
    mov rdi, my_array
    mov rsi, r15
    call show_array


    ; --- 2. Normalize Array to [1.0, 2.0) Range ---
    mov rdi, my_array
    mov rsi, r15
    call normalize_array

    ; --- Print Normalized Array Contents ---
    mov rdi, normalized_msg
    call write_string
    mov rdi, my_array
    mov rsi, r15
    call show_array

    ; --- Exit Messages ---
    mov rdi, goodbye_msg
    call write_string
    mov rdi, user_title
    call write_string
    mov rdi, welcome_msg_end
    call write_string
    
    mov rdi, hope_enjoyed
    call write_string
    mov rdi, user_name
    call write_string
    mov rdi, hope_enjoyed_end
    call write_string
    
    mov rdi, zero_return_msg
    call write_string

    ; --- Final Exit: Return 0 to OS ---
    mov rax, 60 ; sys_exit
    mov rdi, 0  ; return code 0
    syscall

    ; Function Epilogue: Restore FPU/SSE state and all GPRs
    ;mov rax,7
    ;mov rdx,0
    ;rstor [backup_storage_area]

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
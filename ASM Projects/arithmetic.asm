;****************************************************************************************************************************
;Program name: "arithmetic". This program is the main supervisor module. It controls the overall flow of the
;              application, including getting user input, calling other modules to process data, and exiting.
;
;This file is part of the software program "Sum of Values".
;****************************************************************************************************************************
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**//
;
;Author information
;  Author name: konner rigby
;  Author email: rigbykonner@csu.fullerton.edu
;  CWID: 884547654
;  Class: 240-03 Section 03
;
;Program information
;  Program name: Sum of Values
;  Programming languages: X86 Assembly (NASM)
;  Files in this program: arithmetic.asm, adder.asm, get_numbers.asm, display_array.asm,
;                         ftoa.asm, getline.asm, getchar.asm, atof.asm, isfloat.asm
;
;Purpose
;  The purpose of this file is to serve as the entry point and main controller for the application.
;  It manages I/O for the user's name, prompts for numbers, and coordinates calls to other
;  modules to get numbers, display the array, sum the array, and display the result.
;
;This file
;   File name: arithmetic.asm
;   Language: x86 (NASM syntax)
;   Compile: nasm -f elf64 -o arithmetic.o -l arithmetic.lis arithmetic.asm
;****************************************************************************************************************************

global _start

extern getline
extern get_numbers
extern display_array
extern adder
extern ftoa

segment .data
    welcome_msg: db "Welcome. Please enter your full name: ", 0
    welcome_len: equ $ - welcome_msg

    prompt_floats: db "Please enter some float numbers each one separated by a press of the enter key. Terminate by pressing Ctrl+D on an empty line.", 0x0A, 0
    prompt_floats_len: equ $ - prompt_floats

    thanks_msg: db 0x0A, "Thank you. You entered:", 0x0A, 0
    thanks_len: equ $ - thanks_msg

    sum_msg: db 0x0A, "The sum is ", 0
    sum_len: equ $ - sum_msg

    goodbye_msg: db 0x0A, "Have a nice day, ", 0
    goodbye_len: equ $ - goodbye_msg

    newline: db 0x0A, 0
    newline_len: equ 1

segment .bss
    user_name: resb 100         ; buffer for user's name
    float_array: resb 800       ; buffer for up to 100 floats (8 bytes each)
    float_buffer: resb 100      ; buffer for float-to-string conversion

segment .text
_start:
    ; setup stack frame
    push rbp
    mov rbp, rsp

    ; print welcome message
    mov rax, 1
    mov rdi, 1
    mov rsi, welcome_msg
    mov rdx, welcome_len
    syscall

    ; get user name
    mov rdi, user_name
    mov rsi, 100
    call getline
    mov r14, rax                ; save name length

    ; remove newline from name
    cmp byte [user_name + r14 - 1], 0x0A
    jne name_newline_done
    mov byte [user_name + r14 - 1], 0
    dec r14
name_newline_done:

    ; prompt for floats
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_floats
    mov rdx, prompt_floats_len
    syscall

    ; read float numbers
    mov rdi, float_array
    mov rsi, 100
    call get_numbers
    mov r15, rax                ; number of floats entered

    ; print thank you message
    mov rax, 1
    mov rdi, 1
    mov rsi, thanks_msg
    mov rdx, thanks_len
    syscall

    ; display the array
    mov rdi, float_array
    mov rsi, r15
    call display_array

    ; calculate the sum
    mov rdi, float_array
    mov rsi, r15
    call adder
    movsd xmm1, xmm0            ; store sum

    ; print "The sum is "
    mov rax, 1
    mov rdi, 1
    mov rsi, sum_msg
    mov rdx, sum_len
    syscall

    ; convert sum to string and print it
    movsd xmm0, xmm1
    call ftoa                   ; returns pointer to string in rax
    mov r12, rax

    ; get length of string
    mov rdi, r12
    call strlen_local
    mov rdx, rax

    ; print the sum string
    mov rax, 1
    mov rdi, 1
    mov rsi, r12
    syscall

    ; print goodbye message
    mov rax, 1
    mov rdi, 1
    mov rsi, goodbye_msg
    mov rdx, goodbye_len
    syscall

    ; print user's name
    mov rax, 1
    mov rdi, 1
    mov rsi, user_name
    mov rdx, r14
    syscall

    ; print final newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall

    ; exit program
    mov rax, 60
    xor rdi, rdi
    syscall

; strlen_local: returns length of a null-terminated string
; input:  rdi = pointer to string
; output: rax = string length
strlen_local:
    push rdi
    mov rax, 0
strlen_loop:
    cmp byte [rdi + rax], 0
    je strlen_end
    inc rax
    jmp strlen_loop
strlen_end:
    pop rdi
    ret

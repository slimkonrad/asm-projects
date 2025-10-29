; //****************************************************************************************************************************
; //Program name: "arithmetic". This program is the main supervisor module. It controls the overall flow of the
; //              application, including getting user input, calling other modules to process data, and exiting.
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
; //  Files in this program: arithmetic.asm, adder.asm, get_numbers.asm, display_array.asm,
; //                         ftoa.asm, getline.asm, getchar.asm, atof.asm, isfloat.asm
; //
; //Purpose
; //  The purpose of this file is to serve as the entry point and main controller for the application.
; //  It manages I/O for the user's name, prompts for numbers, and coordinates calls to other
; //  modules to get numbers, display the array, sum the array, and display the result.
; //
; //This file
; //   File name: arithmetic.asm
; //   Language: x86 (NASM syntax)
; //   Compile: nasm -f elf64 -o arithmetic.o -l arithmetic.lis arithmetic.asm
; //
; //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; //
; //
; //===== Begin code area ===========================================================================================================

global _start

extern getline
extern get_numbers
extern display_array
extern adder
extern ftoa

segment .data
    welcome_msg: db "Welcome. Please enter your full name: ", 0
    welcome_len: equ $ - welcome_msg

    ; --- THIS PROMPT MENTIONS Ctrl+D ---
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
    user_name: resb 100         ; Buffer for user's name
    float_array: resb 800       ; Array for floats (100 floats * 8 bytes)
    float_buffer: resb 100      ; Buffer for float-to-string conversion

segment .text
_start:
    ; Prologue
    push rbp
    mov rbp, rsp

    ; 1. Welcome and get name
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; stdout
    mov rsi, welcome_msg
    mov rdx, welcome_len
    syscall

    mov rdi, user_name          ; Buffer
    mov rsi, 100                ; Max length
    call getline
    mov r14, rax                ; Save length of name

    ; Stomp newline from name
    cmp byte [user_name + r14 - 1], 0x0A
    jne name_newline_done
    mov byte [user_name + r14 - 1], 0
    dec r14                     ; Decrement length
    name_newline_done:

    ; 2. Prompt for numbers
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_floats
    mov rdx, prompt_floats_len
    syscall

    ; 3. Get numbers
    mov rdi, float_array
    mov rsi, 100                ; Max 100 floats
    call get_numbers
    mov r15, rax                ; Save number of floats in r15

    ; 4. "Thank you. You entered:"
    mov rax, 1
    mov rdi, 1
    mov rsi, thanks_msg
    mov rdx, thanks_len
    syscall

    ; 5. Display array
    mov rdi, float_array
    mov rsi, r15                ; Count
    call display_array

    ; 6. Call adder
    mov rdi, float_array
    mov rsi, r15                ; Count
    call adder
    movsd xmm1, xmm0            ; Save sum in xmm1

    ; 7. Print "The sum is "
    mov rax, 1
    mov rdi, 1
    mov rsi, sum_msg
    mov rdx, sum_len
    syscall

    ; 8. Convert sum to string and print
    movsd xmm0, xmm1            ; Restore sum from xmm1
    mov rdi, float_buffer
    call ftoa

    mov rdi, float_buffer       ; Get length of the sum string
    call strlen_local
    mov rdx, rax                ; Length is in rax

    mov rax, 1                  ; sys_write
    mov rdi, 1
    mov rsi, float_buffer
    syscall                     ; rdx already has length

    ; 9. "Have a nice day, [name]"
    mov rax, 1
    mov rdi, 1
    mov rsi, goodbye_msg
    mov rdx, goodbye_len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, user_name
    mov rdx, r14                ; Use saved name length
    syscall

    ; 10. Print final newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall

    ; 11. Exit
    mov rax, 60
    xor rdi, rdi
    syscall

; Local strlen function
; Input: rdi (string pointer)
; Output: rax (length)
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
; //****************************************************************************************************************************
; //Program name: "getline". This program reads a line of text from stdin (fd 0)
; //              until a newline or EOF is encountered. It stores the result in a
; //              null-terminated string.
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
; //  The purpose of this file is to provide a simple 'getline' function using the 'getchar'
; //  module, which relies on raw Linux syscalls.
; //
; //This file
; //   File name: getline.asm
; //   Language: x86 (NASM syntax)
; //   Compile: nasm -f elf64 -o getline.o -l getline.lis getline.asm
; //
; //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; //
; //
; //===== Begin code area ===========================================================================================================

global getline
extern getchar

segment .text
getline:
    ; Prologue
    push rbp
    mov rbp, rsp
    push r12
    push r13

    ; rdi = buffer pointer
    ; rsi = max size
    mov r12, rdi                ; Save buffer pointer
    mov r13, 0                  ; index

read_loop:
    call getchar
    
    ; Check for EOF (returns 0)
    cmp rax, 0
    je end_getline

    ; Check for newline (returns 0x0A)
    cmp rax, 0x0A
    je store_newline_and_end

    ; Check buffer overflow
    cmp r13, rsi
    jge end_getline             ; Silently drop chars if buffer is full

    ; Store char
    mov [r12 + r13], al
    inc r13
    jmp read_loop

store_newline_and_end:
    mov [r12 + r13], al         ; Store the newline
    inc r13

end_getline:
    mov byte [r12 + r13], 0     ; Null terminate
    mov rax, r13                ; Return number of chars read (including newline)

    ; Epilogue
    pop r13
    pop r12
    pop rbp
    ret
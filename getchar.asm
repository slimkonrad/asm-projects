; //****************************************************************************************************************************
; //Program name: "getchar". This program reads a single character from stdin (fd 0)
; //              using the sys_read Linux syscall.
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
; //  The purpose of this file is to provide a basic 'getchar' function for reading
; //  single bytes from standard input without C libraries.
; //
; //This file
; //   File name: getchar.asm
; //   Language: x86 (NASM syntax)
; //   Compile: nasm -f elf64 -o getchar.o -l getchar.lis getchar.asm
; //
; //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; //
; //
; //===== Begin code area ===========================================================================================================

global getchar

segment .bss
    char_buffer: resb 1

segment .text
getchar:
    ; Prologue
    push rbp
    mov rbp, rsp

    ; Syscall read
    mov rax, 0                  ; sys_read
    mov rdi, 0                  ; stdin
    mov rsi, char_buffer
    mov rdx, 1                  ; Read 1 byte
    syscall

    ; rax = bytes read
    ; If 0 or less (EOF/error), return 0
    cmp rax, 0
    jle return_eof

    ; Success, return the character
    movzx rax, byte [char_buffer]
    jmp getchar_end

return_eof:
    xor rax, rax                ; Return 0 for EOF

getchar_end:
    ; Epilogue
    pop rbp
    ret
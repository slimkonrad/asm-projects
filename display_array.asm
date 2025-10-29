; //****************************************************************************************************************************
; //Program name: "display_array". This program receives a pointer to an array of 64-bit floats
; //              and a count. It iterates through the array, converting each float to a string
; //              using 'ftoa' and printing it to stdout, followed by a newline.
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
; //  The purpose of this file is to print the contents of the float array to the console,
; //  with each number on a new line, for user verification.
; //
; //This file
; //   File name: display_array.asm
; //   Language: x86 (NASM syntax)
; //   Compile: nasm -f elf64 -o display_array.o -l display_array.lis display_array.asm
; //
; //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; //
; //
; //===== Begin code area ===========================================================================================================

global display_array

extern ftoa

segment .data
    newline: db 0x0A, 0

segment .bss
    ; float_buffer: resb 100   <--- REMOVED FROM BSS (THIS IS THE FIX)

segment .text
display_array:
    ; Prologue
    push rbp
    mov rbp, rsp
    sub rsp, 104                ; <<< ALLOCATE 104 bytes on stack for buffer
    push r12
    push r13
    push r14
    push rbx

    ; rdi = array pointer
    ; rsi = count
    mov r12, rdi                ; array
    mov r13, rsi                ; count
    mov r14, 0                  ; index (i)

display_loop:
    cmp r14, r13                ; i < count
    jge end_display_loop

    ; 1. Convert float to string
    movsd xmm0, [r12 + r14 * 8] ; Load float
    lea rdi, [rbp - 104]        ; <<< rdi = pointer to stack buffer
    call ftoa

    ; 2. Get length of string
    lea rdi, [rbp - 104]        ; <<< rdi = pointer to stack buffer
    call strlen_local
    mov rdx, rax                ; Length for sys_write

    ; 3. Print float string
    mov rax, 1
    mov rdi, 1
    lea rsi, [rbp - 104]        ; <<< rsi = pointer to stack buffer
    syscall

    ; 4. Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    inc r14
    jmp display_loop

end_display_loop:
    ; Epilogue
    pop rbx
    pop r14
    pop r13
    pop r12
    add rsp, 104                ; <<< DEALLOCATE stack buffer
    pop rbp
    ret

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
; //****************************************************************************************************************************
; //Program name: "ftoa". This program receives a 64-bit float in xmm0 and a pointer
; //              to a string buffer in rdi. It converts the float to a null-terminated
; //              ASCII string.
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
; //  The purpose of this file is to convert a 64-bit float into a displayable string.
; //  It handles the sign, integer part, and fractional part.
; //
; //This file
; //   File name: ftoa.asm
; //   Language: x86 (NASM syntax)
; //   Compile: nasm -f elf64 -o ftoa.o -l ftoa.lis ftoa.asm
; //
; //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; //
; //
; //===== Begin code area ===========================================================================================================

global ftoa

segment .data
    ; [BUG FIX]: Data for xmm operations MUST be 16-byte aligned
    align 16
    sign_mask: dq 0x8000000000000000
    ten_power: dq 10.0
    zero_float: dq 0.0

segment .text
ftoa:
    ; Prologue
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push r12
    push r13
    push r14

    ; rdi = buffer pointer
    ; xmm0 = float
    mov r12, rdi                ; Save buffer pointer
    mov r13, 0                  ; String index

    ; 1. Handle sign
    comisd xmm0, [zero_float]
    jnb not_negative            ; Jump if xmm0 >= 0.0

    ; It's negative
    mov byte [r12 + r13], '-'
    inc r13
    xorpd xmm0, [sign_mask]     ; Make xmm0 positive
    
not_negative:
    ; 2. Separate integer and fractional parts
    cvttsd2si rax, xmm0         ; rax = truncated integer part
    cvtsi2sd xmm1, rax          ; xmm1 = integer part as float
    subsd xmm0, xmm1            ; xmm0 = fractional part (e.g., 0.45)

    ; 3. Convert integer part (rax) to string (itoa)
    mov rbx, 10
    mov rcx, 0                  ; Digit counter
    cmp rax, 0
    jne itoa_loop               ; If rax is 0, just push '0'
    push '0'
    inc rcx
    jmp pop_digits_loop

itoa_loop:
    xor rdx, rdx
    div rbx                     ; rax = quotient, rdx = remainder
    add rdx, '0'                ; Convert digit to ASCII
    push rdx                    ; Push digit
    inc rcx
    cmp rax, 0
    jne itoa_loop

pop_digits_loop:
    cmp rcx, 0
    je done_itoa
    pop rax
    mov [r12 + r13], al
    inc r13
    dec rcx
    jmp pop_digits_loop
done_itoa:

    ; 4. Add decimal point
    mov byte [r12 + r13], '.'
    inc r13

    ; 5. Convert fractional part (xmm0)
    mov r14, 0                  ; Precision counter (up to 6 places)
fraction_loop:
    cmp r14, 6
    jge end_fraction

    mulsd xmm0, [ten_power]     ; e.g., 0.45 -> 4.5
    cvttsd2si rax, xmm0         ; rax = 4 (integer digit)
    
    push rax                    ; Save the integer digit (4)
    
    add rax, '0'                ; Convert to ASCII ('4')
    mov [r12 + r13], al         ; Store '4'
    inc r13

    pop rax                     ; Restore the integer digit (4)
    
    cvtsi2sd xmm1, rax          ; xmm1 = 4.0
    subsd xmm0, xmm1            ; xmm0 = 4.5 - 4.0 = 0.5
    
    inc r14
    jmp fraction_loop

end_fraction:
    ; 6. Null terminate
    mov byte [r12 + r13], 0

    ; Epilogue
    pop r14
    pop r13
    pop r12
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret
; //****************************************************************************************************************************
; //Program name: "get_numbers". This program loops, asking the user for float input.
; //              It uses getline, isfloat, and stringtof to read, validate, and convert
; //              the input, storing it in the provided array.
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
; //  The purpose of this file is to manage the user input loop for gathering float numbers.
; //  It validates input using 'isfloat' and converts valid strings to floats using 'stringtof'.
; //  It also contains a workaround for bugs in the provided 'atof.asm'.
; //
; //This file
; //   File name: get_numbers.asm
; //   Language: x86 (NASM syntax)
; //   Compile: nasm -f elf64 -o get_numbers.o -l get_numbers.lis get_numbers.asm
; //
; //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
; //
; //
; //===== Begin code area ===========================================================================================================

global get_numbers

extern getline
extern isfloat
extern stringtof

segment .data
    invalid_msg: db "Invalid float. Please try again.", 0x0A, 0
    invalid_len: equ $ - invalid_msg
    
    minus_char: db '-', 0

    ; [BUG FIX 1]: Data for xmm operations MUST be 16-byte aligned
    align 16
    sign_mask: dq 0x8000000000000000
    ten_float: dq 10.0
    zero_float: dq 0.0

segment .bss
    input_buffer: resb 100

segment .text
get_numbers:
    ; Prologue
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push r12
    push r13
    push r14
    push r15

    ; rdi = array pointer
    ; rsi = max numbers
    mov r12, rdi                ; array pointer
    mov r13, 0                  ; number count (index)
    mov r15, rsi                ; max numbers

get_loop:
    cmp r13, r15                ; count < max
    jge end_get_loop

    ; Get line
    mov rdi, input_buffer
    mov rsi, 100
    call getline
    mov r14, rax                ; Save length in r14

    ; Check for EOF (Ctrl+D) ONLY
    cmp r14, 0
    je end_get_loop
    
not_empty_line:
    ; Stomps the newline
    cmp byte [input_buffer + r14 - 1], 0x0A
    jne not_newline
    mov byte [input_buffer + r14 - 1], 0
    dec r14
    not_newline:

    ; Check for empty string *after stomping newline*
    ; If empty, it's invalid input, not time to end.
    cmp r14, 0
    je invalid_input

    ; Validate float
    mov rdi, input_buffer
    call isfloat
    cmp rax, 0                  ; Check if false
    je invalid_input

    ; --- [BUG FIX 2]: Rewritten parser logic ---
    mov r14, 0                  ; is_negative flag = false
    mov rbx, 0                  ; index
    mov rcx, 0                  ; integer_part
    mov rdx, 0                  ; decimal_places
    mov r9, 0                   ; hit_decimal_flag
    
    ; Check for sign
    cmp byte [input_buffer], '-'
    jne check_plus
    mov r14, 1                  ; is_negative = true
    inc rbx
    jmp parse_loop
check_plus:
    cmp byte [input_buffer], '+'
    jne parse_loop
    inc rbx                     ; Skip '+'
    
parse_loop:
    cmp byte [input_buffer + rbx], 0 ; End of string?
    je end_parse_loop
    
    cmp byte [input_buffer + rbx], '.'
    je hit_decimal
    
    ; It's a digit
    imul rcx, rcx, 10
    
    movzx rax, byte [input_buffer + rbx]
    sub rax, '0'
    add rcx, rax                ; rcx = (rcx * 10) + digit

    cmp r9, 1                   ; Have we hit decimal?
    jne skip_inc_rdx            ; If not, don't count
    inc rdx                     ; If yes, count this as a decimal place
skip_inc_rdx:
    inc rbx
    jmp parse_loop

hit_decimal:
    mov r9, 1                   ; Set hit_decimal_flag
    inc rbx                     ; Move past the '.'
    jmp parse_loop              ; Continue loop

end_parse_loop:
    ; Now, rcx = integer part (e.g., 123)
    ; rdx = decimal places (e.g., 1 for "12.3")
    ; r14 = is_negative (e.g., 0)
    
    cvtsi2sd xmm0, rcx          ; xmm0 = 123.0
    
    ; Divide by 10^rdx
    mov rcx, 0                  ; Use rcx as loop counter
divide_loop:
    cmp rcx, rdx
    jge end_divide_loop
    
    divsd xmm0, [ten_float]     ; xmm0 = xmm0 / 10.0
    inc rcx
    jmp divide_loop
end_divide_loop:

    ; Fix sign
    cmp r14, 1                  ; Was it negative?
    jne store_number
    xorpd xmm0, [sign_mask]     ; Flip sign bit

store_number:
    movsd [r12 + r13 * 8], xmm0 ; Store float in array
    inc r13
    jmp get_loop

invalid_input:
    ; Print "Invalid float"
    mov rax, 1
    mov rdi, 1
    mov rsi, invalid_msg
    mov rdx, invalid_len
    syscall
    jmp get_loop

end_get_loop:
    mov rax, r13                ; Return number of floats read

    ; Epilogue
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret
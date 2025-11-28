extern scanf, printf, isfloat, atof, getchar

global input_array

section .data
    scan_format     db "%s", 0
    error_msg       db 10, "The last input was invalid and not entered into the array.", 10, 0
    newline_char    equ 10
    eof             equ -1

section .bss
    input_buffer    resb 800    ; Use 800-byte buffer as specified

section .text
input_array:
    ; Prototype: long input_array(double* array, long max_size)
    ; rdi = array pointer, rsi = max_size
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32         ; Space for saving callee-saved registers
    mov     [rbp-8], r12
    mov     [rbp-16], r13
    mov     [rbp-24], r14

    mov     r12, rdi        ; Back up the array pointer
    mov     r13, rsi        ; Back up the maximum size
    xor     r14, r14        ; Create a loop counter, r14 = 0

begin_loop:
    ; Stop if we have reached the maximum size
    cmp     r14, r13
    jge     end_loop

try_again:
    ; Obtain a floating-point number (as a string) from the keyboard
    mov     rdi, scan_format
    mov     rsi, input_buffer
    xor     rax, rax
    call    scanf
    cmp     rax, 1          ; Check if user does Control + D
    jl      end_loop

    ; Check if what the user inputted is a float number
    mov     rdi, input_buffer
    call    isfloat
    cmp     rax, 0          ; isfloat returns false(0) or true(-1)
    je      invalid_input

    ; Convert the string of the float number to a float number
    mov     rdi, input_buffer
    call    atof
    ; Copy the newly input float number into the next open cell of the array
    movsd   [r12 + r14 * 8], xmm0
    inc     r14             ; Increment number of floats we have read
    jmp     begin_loop

invalid_input:
    ; Output an invalid data detected message
    mov     rdi, error_msg
    xor     rax, rax
    call    printf
    ; Clear the rest of the bad input line to prevent an infinite loop
clear_stdin_loop:
    call    getchar
    cmp     rax, eof
    je      end_loop
    cmp     rax, newline_char
    je      try_again
    jmp     clear_stdin_loop

end_loop:
    mov     rax, r14        ; Return the count of numbers successfully read

    mov     r12, [rbp-8]    ; Restore registers
    mov     r13, [rbp-16]
    mov     r14, [rbp-24]
    mov     rsp, rbp
    pop     rbp
    ret
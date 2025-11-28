extern printf, input_array, display_array, magnitude, append, mean, clearerr, stdin
global manager

section .data
    prompt_intro    db "This program will manage your arrays of 64-bit floats", 10, 0
    prompt_a        db "For array A enter a sequence of 64-bit floats separated by white space.", 10, "After the last input press enter followed by Control+D:", 10, 0
    msg_a_received  db "These number were received and placed into array A:", 10, 0
    msg_mag_a       db "The magnitude of array A is %f", 10, 10, 0
    prompt_b        db "For array B enter a sequence of 64-bit floats separated by white space.", 10, "After the last input press enter followed by Control+D:", 10, 0
    msg_b_received  db "These number were received and placed into array B:", 10, 0
    msg_mag_b       db "The magnitude of this array B is %f", 10, 10, 0
    msg_append      db "Arrays A and B have been appended and given the name A⊕B.", 10, "A⊕B contains", 10, 0
    msg_mag_append  db "The magnitude of A⊕B is %f", 10, 10, 0
    msg_mean_append db "The mean of A⊕B is %f", 10, 0
section .bss
    array_a         resq 100
    array_b         resq 100
    array_append    resq 200
section .text
manager:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 64
    mov     [rbp-8], rbx
    mov     [rbp-16], r12
    mov     [rbp-24], r13
    mov     [rbp-32], r14
    mov     rdi, prompt_intro
    xor     rax, rax
    call    printf
    mov     rdi, prompt_a
    xor     rax, rax
    call    printf
    mov     rdi, array_a
    mov     rsi, 100
    call    input_array
    mov     r12, rax

    push    r12                 ; Save the correct size of array A
    sub     rsp, 8              ; Re-align the stack for the printf call
    mov     rdi, msg_a_received
    xor     rax, rax
    call    printf
    add     rsp, 8              ; De-align the stack
    pop     r12                 ; Restore the correct size of array A

    mov     rdi, array_a
    mov     rsi, r12
    call    display_array
    mov     rdi, array_a
    mov     rsi, r12
    call    magnitude
    mov     rdi, msg_mag_a
    mov     rax, 1
    call    printf
    mov     rdi, [stdin]
    call    clearerr
    mov     rdi, prompt_b
    xor     rax, rax
    call    printf
    mov     rdi, array_b
    mov     rsi, 100
    call    input_array
    mov     r13, rax

    push    r13                 ; Save the correct size of array B
    sub     rsp, 8              ; Re-align the stack for the printf call
    mov     rdi, msg_b_received
    xor     rax, rax
    call    printf
    add     rsp, 8              ; De-align the stack
    pop     r13                 ; Restore the correct size of array B

    mov     rdi, array_b
    mov     rsi, r13
    call    display_array
    mov     rdi, array_b
    mov     rsi, r13
    call    magnitude
    mov     rdi, msg_mag_b
    mov     rax, 1
    call    printf
    mov     rdi, msg_append
    xor     rax, rax
    call    printf
    mov     rdi, array_append
    mov     rsi, array_a
    mov     rdx, r12
    mov     rcx, array_b
    mov     r8, r13
    call    append
    mov     r14, rax
    mov     rdi, array_append
    mov     rsi, r14
    call    display_array
    mov     rdi, array_append
    mov     rsi, r14
    call    magnitude
    movsd   xmm15, xmm0
    mov     rdi, msg_mag_append
    mov     rax, 1
    call    printf
    mov     rdi, array_append
    mov     rsi, r14
    call    mean
    mov     rdi, msg_mean_append
    mov     rax, 1
    call    printf
    movsd   xmm0, xmm15
    mov     rbx, [rbp-8]
    mov     r12, [rbp-16]
    mov     r13, [rbp-24]
    mov     r14, [rbp-32]
    mov     rsp, rbp
    pop     rbp
    ret
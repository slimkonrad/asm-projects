global append
section .text
append:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 40
    mov     [rbp-8], rdi
    mov     [rbp-16], rsi
    mov     [rbp-24], rdx
    mov     [rbp-32], rcx
    mov     [rbp-40], r8
    mov     rdi, [rbp-8]
    mov     rsi, [rbp-16]
    mov     rcx, [rbp-24]
    rep movsq
    mov     rsi, [rbp-32]
    mov     rcx, [rbp-40]
    rep movsq
    mov     rax, [rbp-24]
    add     rax, [rbp-40]
    mov     rsp, rbp
    pop     rbp
    ret
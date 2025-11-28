global magnitude
section .text
magnitude:
    push    rbp
    mov     rbp, rsp
    mov     r12, rdi
    mov     r13, rsi
    xorpd   xmm0, xmm0
    xor     rcx, rcx
magnitude_loop:
    cmp     rcx, r13
    jge     end_magnitude_loop
    movsd   xmm1, [r12 + rcx * 8]
    mulsd   xmm1, xmm1
    addsd   xmm0, xmm1
    inc     rcx
    jmp     magnitude_loop
end_magnitude_loop:
    sqrtsd  xmm0, xmm0
    mov     rsp, rbp
    pop     rbp
    ret
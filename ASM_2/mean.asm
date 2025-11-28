global mean
section .text
mean:
    push    rbp
    mov     rbp, rsp
    mov     r12, rdi
    mov     r13, rsi
    test    r13, r13
    jz      zero_size
    xorpd   xmm0, xmm0
    xor     rcx, rcx
mean_loop:
    cmp     rcx, r13
    jge     end_mean_loop
    addsd   xmm0, [r12 + rcx * 8]
    inc     rcx
    jmp     mean_loop
end_mean_loop:
    cvtsi2sd xmm1, r13
    divsd   xmm0, xmm1
    jmp     done_mean
zero_size:
    xorpd   xmm0, xmm0
done_mean:
    mov     rsp, rbp
    pop     rbp
    ret
global _start

section .bss

buffer: resb 32 ; buffer for the string

section .text

_start:

    mov rax,12345          ; number we want to print
    call print_int

    mov rax,60             ; exit syscall
    xor rdi,rdi
    syscall

print_int:

    mov rbx,10             ; divisor for decimal conversion
    lea rdi,[buffer + 31]  ; point to end of buffer

.convert:

    xor rdx,rdx            ; clear high part of dividend
                            ; div uses RDX:RAX as dividend

    div rbx                ; (RDX:RAX) / RBX
                            ; quotient  -> RAX
                            ; remainder -> RDX

    add dl,'0'             ; convert remainder to ASCII

    dec rdi                ; move one byte backwards
    mov [rdi],dl           ; store ASCII character in buffer

    test rax,rax           ; quotient == 0 ?
    jnz .convert           ; if not, continue converting

    mov rax,1              ; write syscall
    mov rsi,rdi            ; pointer to start of string

    mov rdx,buffer + 31    ; end position
    sub rdx,rdi            ; string length = end - start

    mov rdi,1              ; stdout
    syscall

    ret

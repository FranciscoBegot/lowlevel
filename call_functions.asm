global _start

section .data
newline: db 10                   ; '\n' in ASCII
codes:   db '0123456789ABCDEF'   ; hex digit lookup table

section .text

nline:
    mov rax, 1           ; syscall: write
    mov rdi, 1           ; file descriptor: stdout
    mov rsi, newline     ; address of '\n'
    mov rdx, 1           ; number of bytes to write
    syscall
    ret


print_hex:
    mov rax, rdi         ; copy input value to RAX
    mov rdi, 1           ; file descriptor: stdout
    mov rdx, 1           ; length per character
    mov rcx, 64          ; bit counter (start at 64 bits)

.loop:
    push rax             ; save RAX
    sub rcx, 4           ; move to next 4 bits
    sar rax, cl          ; shift right by CL bits
    and rax, 0xF         ; isolate lower 4 bits
    lea rsi, [codes + rax] ; point to corresponding hex digit

    mov rax, 1           ; syscall: write
    push rcx
    syscall
    pop rcx
    pop rax

    test rcx, rcx        ; check if finished
    jnz .loop            ; if not zero, continue
    ret


_start:
    mov rdi, 0x1122334455667788
    call print_hex
    call nline

    mov rax, 60          ; syscall: exit
    xor rdi, rdi         ; exit code 0
    syscall              ; exit program


global _start

section .data
newline: db 10                   ; '\n' in ASCII
codes:   db '0123456789ABCDEF'   ; hex digit lookup table
demo1:   dq 0x1122334455667788   ; dq = Define Quadword = 64 bits.
                                   ; The CPU/assembler will store this in little-endian (reverse) byte order: 0x88, 0x77, 0x66... 
demo2:   db 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88 ; db = Define Byte. You are telling the assembler to store these bytes in THIS specific order.
                                   ; In memory, this will look like: 0x11, 0x22, 0x33...



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
    mov rdi, [demo1]
    call print_hex
    call nline
                                ; This will print 112233... because the little-endian CPU "fixes"
                                ; the little-endian memory (88,77...) back into the correct register value.

    mov rdi, [demo2]
    call print_hex
    call nline
                                ; This will print 887766... because the CPU *assumes* the data
                                ; (11,22...) was stored in little-endian, so it "fixes" it,
                                ; effectively reversing it into 8877...

    mov rax, 60          ; syscall: exit
    xor rdi, rdi         ; exit code 0
    syscall              ; exit program

section .data
letrar: 
    db 'A'              ; Stores the character 'A' in memory (1 byte).

section .text
global _start
_start:

    mov rcx, 10          ; Initialize loop counter (we’ll print 'A' 10 times).

.loop:

    mov rax, 1           ; Argument #0: syscall number for write()
    mov rdi, 1           ; Argument #1: file descriptor (1 = STDOUT)
    mov rsi, letrar      ; Argument #2: address of the character 'A'
    mov rdx, 1           ; Argument #3: number of bytes to write (1 byte)

    push rcx             ; Save RCX (loop counter) before syscall (since syscall may modify registers)
    syscall              ; Execute system call -> prints 'A'
    pop rcx              ; Restore RCX after syscall

    dec rcx              ; Decrease loop counter by 1
    test rcx, rcx        ; Check if RCX == 0 (sets flags)
    jnz .loop            ; If not zero, repeat loop

.saida:

    mov rax, 60          ; syscall number for exit()
    xor rdi, rdi         ; exit code 0 (success)
    syscall              ; Exit the program





























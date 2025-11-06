global _start          ; Linker directive: defines _start as the program's entry point.

section .data           ; Section for static data (variables).

message: db 'hello, world!', 10     ; Define the string and a newline character (\n).
length:  equ $ - message             ; Constant: calculates the length of 'message' in bytes.

section .text           ; Section for executable code.

_start:                 ; Label where execution begins.


    mov rax, 1          ; Argument #0: syscall number for write()
    mov rdi, 1          ; Argument #1: file descriptor (1 = STDOUT)
    mov rsi, message     ; Argument #2: address of the buffer (message)
    mov rdx, length      ; Argument #3: number of bytes to write
    syscall              ; Execute the system call (prints the message)

.exit: ; label to exit in a safe way
    mov rax, 60         ; syscall number for exit()
    xor rdi, rdi        ; exit code 0 (success)
    syscall              ; Exit the program


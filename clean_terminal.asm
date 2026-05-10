section .data
    ;American National Standards Institute (ANSI
    ; ANSI Escape Sequences:
    ; 27 (0x1b) is the ESC character.
    ; [2J clears the entire screen buffer.
    ; [H moves the cursor to the "home" position (top-left corner, coordinates 0,0).
    clear_screen: db 27, '[2J', 27, '[H'
    
    ; Calculate the length of the sequence dynamically ($ is current address)
    clear_len:    equ $ - clear_screen

section .text
    global _start

_start:
    mov rax, 1          ; System call number for sys_write
    mov rdi, 1          ; File descriptor 1 (stdout)
    mov rsi, clear_screen ; Pointer to the buffer containing the escape sequence
    mov rdx, clear_len    ; Number of bytes to write
    syscall             ; hey kernel, clean the terminal

    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; Return code 0
    syscall             ; syscall

global _start

section .data
    lookup: db '0123456789ABCDEF'  ; A lookup table to convert a 4-bit number (0-15) to an ASCII hex char
    test:   dq -1                     ; Our 8-byte (64-bit) variable, initialized to -1 (0xFFFFFFFFFFFFFFFF)
    newl:   db 10                     ; The newline character '\n'

section .text

newline:
    mov rax, 1                  ; 1 = syscall number for 'write'
    mov rdi, 1                  ; 1 = file descriptor for 'stdout' (standard output)
    mov rsi, newl               ; address of the string to print
    mov rdx, 1                  ; number of bytes to print
    syscall                     ; Call the kernel
    ret                         ; Return from function

print_hex:
    ; --- Setup ---
    mov rax, rdi                ; Copy the number-to-print from RDI (the 1st argument)
                                ; into RAX (our work register)
    
    mov rdi, 1
    
    mov rdx, 1                  ; We will write 1 byte (one character) at a time
    mov rcx, 64                 ; Bit counter, start at 64 (for 64 bits)

.loop:
    push rax                    ; Save the current state of our number (RAX) on the stack
    sub rcx, 4                  ; Decrement bit counter by 4 (for the 4 bits we're about to print)
    sar rax, cl                 ; Shift the number right by CL bits (e.g., shift by 60, then 56...)
                                ; This moves the 4 bits we want to the very end of the register
    and rax, 0xf                ; Isolate *only* those 4 bits (e.g., 0b1101 which is 13)
    
    lea rsi, [lookup + rax]     ; Get the address of the char (e.g., 'lookup' + 13 = address of 'D')
    mov rax, 1                  ; Set syscall number to 'write' (RDI is already 1)
    
    push rcx                    ; Save RCX (the counter) because 'syscall' might change it
    syscall                     ; Print the character
    pop rcx                     ; Restore RCX
    
    pop rax                     ; Restore the original, un-shifted RAX for the next loop
    
    test rcx, rcx               ; Is the counter (RCX) 0?
    jnz .loop                   ; If not zero, loop again
    ret                         ; Done, return. (Remember: RDI is now 1!)

_start:
    ; 1. Print the initial value (-1)
    mov rdi, [test]             ; Load RDI with the 64-bit *value* at 'test' (0xFF...FF)
    call print_hex              ; Prints "FFFFFFFFFFFFFFFF"
    call newline

    ; 2. Modify 1 byte and print the result
    mov byte[test], 1           ; Memory at 'test' is modified (becomes 0xFFFFFFFFFFFF01)
    
    ; We MUST reload RDI from memory. If we don't, RDI still holds '1'
    ; (the value 'print_hex' left in it) and we would just print '1' again.
    mov rdi, [test]             ; Reload RDI with the *new* value from memory.
    
    call print_hex              ; Prints "FFFFFFFFFFFFFF01"
    call newline

    ; 3. Modify 2 bytes (word) and print
    mov word[test], 1           ; Memory at 'test' becomes 0xFFFFFFFFFF0001 (due to little-endian)
    mov rdi, [test]             ; <-- Reload RDI with the new value
    call print_hex              ; Prints "FFFFFFFFFFFF0001"
    call newline

    ; 4. Modify 4 bytes (dword) and print
    mov dword[test], 1          ; Memory at 'test' becomes 0xFFFFFFFF00000001
    mov rdi, [test]             ; <-- Reload RDI with the new value
    call print_hex              ; Prints "FFFFFFFF00000001"
    call newline

    ; 5. Modify 8 bytes (qword) and print
    mov qword[test], 1          ; Memory at 'test' becomes 0x0000000000000001
    mov rdi, [test]             ; <-- Reload RDI with the new value
    call print_hex              ; Prints "0000000000000001"
    call newline

.exit:
    mov rax, 60                 ; 60 = syscall number for 'exit'
    xor rdi, rdi                ; 0 = exit code (success)
    syscall

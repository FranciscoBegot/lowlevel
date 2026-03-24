   global _start               ; Export the entry point for the linker (ld)
   section .bss               ; Section for uninitialized data
   
   buffer resb 6              ; Reserve 6 bytes to fit "Hello\n"
   
   
   section .text              ; Section for the actual code
   _start:                    ; The starting point of the program
   
  
      mov byte[buffer], 'H'     ; Move ASCII 'H' into the 1st byte of buffer
      mov byte[buffer + 1], 'e' ; Move ASCII 'e' into the 2nd byte
      mov byte[buffer + 2], 'l' ; Move ASCII 'l' into the 3rd byte
      mov byte[buffer + 3], 'l' ; Move ASCII 'l' into the 4th byte
      mov byte[buffer + 4], 'o' ; Move ASCII 'o' into the 5th byte
      mov byte[buffer + 5], 10  ; Move newline character (\n) into the 6th byte
  
      mov rax, 1                ; System call number for sys_write
      mov rdi, 1                ; File descriptor 1 (stdout)
      mov rsi, buffer           ; Pointer to the string to print
      mov rdx, 6                ; Number of bytes to print
  
      syscall                   ; Invoke the kernel to execute the write
  
      mov rax, 60               ; System call number for sys_exit
      xor rdi, rdi              ; Set exit code to 0 (rdi = 0)
      syscall                   ; Invoke the kernel to exit the program

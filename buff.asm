global _start
section .bss ; Section when we only want to reserve some memory

buffer resq 1 ; Reserve qword(64 bits)

section .text

_start:

mov qword[buffer],42 ; We store 42 into buffer
mov rax,[buffer]

mov rdi,rax
mov rax,60 ; We can see the number 42 by doing echo $?
syscall

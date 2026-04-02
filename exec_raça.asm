global _start ; entry point

section .text

_start:

           ; exec must follow this pattern --> int execve(const char *filename, char *const argv[], char *const envp[]);

           ; we must follow the system v amd64 ABI (register order for arguments)

sub rsp,16 ; reserve 16 bytes on stack (alignment and space for the string)

mov rsi,rsp ; rsi will point to the beginning of our string in the stack

mov byte [rsi],     0x2f   ; '/'
mov byte [rsi+1],   0x62   ; 'b'
mov byte [rsi+2],   0x69   ; 'i'
mov byte [rsi+3],   0x6e   ; 'n'
mov byte [rsi+4],   0x2f   ; '/'
mov byte [rsi+5],   0x62   ; 'b'
mov byte [rsi+6],   0x61   ; 'a'
mov byte [rsi+7],   0x73   ; 's'
mov byte [rsi+8],   0x68   ; 'h'
mov byte [rsi+9],   0x00   ; null terminator for the string

mov rdi,rsi ; rdi = pointer to "/bin/bash" (first argument: filename)

xor rdx,rdx ; rdx = 0 (envp = NULL)

push rdx ; push NULL -> marks end of argv array
push rdi ; push pointer to "/bin/bash"

mov rsi,rsp ; rsi now points to argv array (["/bin/bash", NULL])


mov rax,59 ; syscall for execve
syscall ; invoke kernel -> replace current process with /bin/bash

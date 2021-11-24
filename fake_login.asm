# nasm fake_login.asm -f elf64 -o fake_login.o
# ld -m elf_x86_64 -o fake_login fake_login.o

; --------------------------------
        SYS_READ   equ     0          ; read text from stdin
    SYS_WRITE  equ     1          ; write text to stdout
    SYS_EXIT   equ     60         ; terminate the program
    STDIN      equ     0          ; standard input
    STDOUT     equ     1          ; standard output
; --------------------------------
section .bss
    username_len equ     24         ; 24 bytes for username
    username     resb    username_len ; buffer for username len
        password_len equ     24         ; 24 bytes for password
    password     resb    password_len ; buffer for password len
; --------------------------------
section .data
    username_prompt     db      "Username: "
    username_prompt_len equ     $ - username_prompt

        password_prompt     db      "Password: "
    password_prompt_len equ     $ - password_prompt

    success       db      10, "Welcome",10
    success_len   equ     $ - success

        fail       db      10, "Try again",10
    fail_len   equ     $ - fail

        real_password db      "1234",10
    real_password_len   equ     $ - real_password
; --------------------------------
section .text
    global _start

_start:
get_username:
    mov     rdx, username_prompt_len ; print username prompt
    mov     rsi, username_prompt
    mov     rdi, STDOUT
    mov     rax, SYS_WRITE
    syscall

    mov     rdx, username_len ; get username
    mov     rsi, username
    mov     rdi, STDIN
    mov     rax, SYS_READ
    syscall                      ; -> RAX

    mov     rdx, password_prompt_len    ; print password prompt
    mov     rsi, password_prompt
    mov     rdi, STDOUT
    mov     rax, SYS_WRITE
    syscall

        mov     rdx, password_len ; get password
    mov     rsi, password
    mov     rdi, STDIN
    mov     rax, SYS_READ
    syscall                      ; -> RAX

        mov rsi, password
        mov rdi, real_password

        mov rcx, real_password_len
        cld
        repe cmpsb
        jecxz Equal

NotEqual:
        mov     rdx, fail_len ; print fail
    mov     rsi, fail
    mov     rdi, STDOUT
    mov     rax, SYS_WRITE
    syscall
        jmp Exit

Equal:
        mov     rdx, success_len ; print success
    mov     rsi, success
    mov     rdi, STDOUT
    mov     rax, SYS_WRITE
    syscall

Exit:
    xor     edi, edi             ; successful exit
    mov     rax, SYS_EXIT
    syscall

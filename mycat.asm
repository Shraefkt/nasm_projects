; Program takes an argument and prints the file
;nasm mycat.asm -f elf64 -o mycat.o && ld -m elf_x86_64 -o mycat mycat.o
section .bss
; --------------------------------
section .data
    fd dq 0

        error_message     db      "File does not exist or no argument supplied" , 0xa
    error_message_len equ     $ - error_message

        newline         db                      0xa
        newline_len equ $ - newline
; --------------------------------
section .text
    global _start

_start:

;open file and get fd

        mov rbx, [rsp+0x10]
    mov     rsi, 0 ; flags Readonly
    mov     rdx, 0777 ; mode
    mov     rdi, rbx ; filename
    mov     rax, 2 ; syscall no
    syscall ; rax - fd

        cmp rax, 0xfffff
        jnc error
    mov [fd], rax

;read file onto stack
    mov rdi, [fd] ;file descriptor
        sub rsp, 256 ; move stack pointer down
        mov rsi, rsp ; location
        mov rdx, 256 ; length of read
        mov rax, 0x0 ; syscall no
        syscall

; write data
        mov rdi, 1 ; fd : stdout
        mov rsi, rsp ; write location
        mov rdx, 256
        mov rax, 1 ; syscall no
        syscall

; print a newline
        mov rsi, newline
        mov rdi, 1
        mov rdx, newline_len
        mov rax, 1
        syscall


; close file
        mov rdi, [fd]
        mov rax, 3
        syscall

        jmp exit

error:
; print error message
        mov rsi, error_message
        mov rdi, 1
        mov rdx, error_message_len
        mov rax, 1
        syscall

exit:
        mov rdi, 0
        mov rax, 60
        syscall

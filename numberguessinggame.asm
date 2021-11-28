;nasm numberguessinggame.asm -f elf64 -o numberguessinggame.o && ld -m elf_x86_64 -o numberguessinggame numberguessinggame.o
SYS_READ 	equ		0
SYS_WRITE 	equ 	1
SYS_EXIT 	equ 	60
SYS_TIME 	equ 	201
STDIN 		equ		0
STDOUT 		equ 	1

section .bss
	points resb 4
	guess_len equ 1
	guess resb guess_len
	
section .data 
	welcomeMsg 		db 'Welcome to my guessing game! Guess a number from 0 to 3!',0xa
	welcomeMsg_len 	equ $ 	-	welcomeMsg
	prompt			db 'Guess: '
	prompt_len		equ $	-	prompt
	wrongMsg 		db	'Game Over!',0xa,'Points:'
	wrongMsg_len	equ	$	-	wrongMsg
	newline			db 0xa

section .text 
	global _start:
	
_start:

welcome:
	mov rsi, welcomeMsg
	mov rdx, welcomeMsg_len
	call write
	
	mov byte[points], 0 
guessing_loop:
	mov rsi, prompt
	mov rdx, prompt_len
	call write
	
	mov rsi, guess
	mov rdx, guess_len
	call read
	
	mov rsi, rsp ; for enter 
	mov rdx, 1
	call read 
	
	call generate_random_num
	xor rax,rax
	mov al, [guess]
	sub al, 0x30
	cmp al, bl
	jne wrong
	inc byte[points]
	
	loop guessing_loop

wrong:
	
	mov rsi,wrongMsg
	mov rdx, wrongMsg_len
	call write
	
	add byte[points],0x30
	mov rsi, points
	mov rdx, 1
	call write
	
	mov rsi, newline
	mov rdx, 1
	call write
	
exit:
	mov rdi, 0
	mov rax, SYS_EXIT
	syscall
	
	
write:
	mov rdi, STDOUT
    mov   rax, SYS_WRITE
	syscall
	ret
	
read:
	mov rdi, STDIN
    mov   rax, SYS_READ
	syscall
	ret
	
generate_random_num:
	xor rsi,rsi
	mov rax, SYS_TIME
	syscall
	xor rbx,rbx
	mov bl, al
	and bl,3
	ret
	

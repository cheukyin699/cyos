[org 0x8000]

; Set Graphical mode
xor ah, ah
mov al, 13h
int 10h

mov bh, 0
mov bl, 0h
mov si, welcome_msg
call printf

; Prompts for username
mov bl, 10h
mov si, login_prmt
call printf

; Gets the username
mov si, login_buf
call os_getline
mov si, login_buf
call printf

; Prompts for password
mov si, pass_prmt
call printf

; Gets the password

jmp $

printf:
	lodsb
	or al, al
	jz .done
	mov ah, 0Eh
	int 10h
	inc bl
	jmp printf
	.done:
	ret

welcome_msg db 'Welcome to CYOS! Please login', 13, 10, 0
login_prmt db 'LOGIN: ', 0
pass_prmt db 'PASSWORD: ', 0
login_buf times 50 db 0
pass_buf times 50 db 0

; +---------------------------------+
; |Features to pull into the kernel |
; +---------------------------------+

	%INCLUDE 'src/include/keyboard.asm'

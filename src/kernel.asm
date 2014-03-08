[org 0x8000]

; Set Cursor shape
mov ah, 1
mov cx, 60h
int 10h

; Set Graphical mode
xor ah, ah
mov al, 13h
int 10h

mov bl, 4
mov si, welcome_msg
call os_printf

; Prompts for username
mov bl, 20
mov si, login_prmt
call os_printf

; Gets the username
mov si, login_buf
call os_getline

; Prompts for password
mov si, pass_prmt
call os_printf

; Gets the password
stc							; Set carry to stop user from seeing password
mov si, pass_buf
call os_getline

; Writes a pixel graphics
mov ah, 0Ch
mov al, 0Fh					; The color
mov cx, 50					; The x
mov dx, 40					; The y
mov si, 10					; The width
mov di, 100					; The height
call os_box

; Tells you what your username and password is
mov si, login_buf
call os_printf
mov al, ':'
mov ah, 0Eh
int 10h
mov si, pass_buf
call os_printf

jmp $

welcome_msg db 'Welcome to CYOS! Please login', 13, 10, 0
login_prmt db 'LOGIN: ', 0
pass_prmt db 13, 10, 'PASSWORD: ', 0
login_buf times 50 db 0
pass_buf times 50 db 0

; +---------------------------------+
; |Features to pull into the kernel |
; +---------------------------------+

	%INCLUDE 'src/include/keyboard.asm'
	%INCLUDE 'src/include/system.asm'

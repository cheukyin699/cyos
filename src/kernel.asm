[org 0x8000]

; Set Graphical mode
xor ah, ah
mov al, 13h
int 10h

mov bl, 4
mov si, welcome_msg
call os_printf

login_strt:
mov si, os_nl
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

; Clears screen
xor bh, bh
call os_cls

; Writes a pixel graphics
mov ah, 0Ch
mov al, 0Fh					; The color
mov cx, 50					; The x
mov dx, 40					; The y
mov si, 10					; The width
mov di, 100					; The height
call os_box

; Tells you what your username and password is
; but hashed
mov si, login_buf
mov byte[di], 0x18
call os_safehash
mov si, pass_buf
mov byte[di], 0x18
call os_safehash
mov si, login_buf
mov di, valid_login
call os_strcmp
jnc login_strt
mov si, pass_buf
mov di, valid_pass
call os_strcmp
jnc login_strt

mov si, valid
call os_printf

jmp $

welcome_msg db 'Welcome to CYOS! Please login', 13, 10, 0
login_prmt db 'LOGIN: ', 0
pass_prmt db 13, 10, 'PASSWORD: ', 0
valid db 'Username and password is correct', 13, 10, 0
login_buf times 50 db 0
pass_buf times 50 db 0
valid_login db 'jwwl', 0
valid_pass db 'lwwj', 0

; +---------------------------------+
; |Features to pull into the kernel |
; +---------------------------------+
	
	%INCLUDE 'src/include/algorithms.asm'
	%INCLUDE 'src/include/keyboard.asm'
	%INCLUDE 'src/include/string.asm'
	%INCLUDE 'src/include/system.asm'

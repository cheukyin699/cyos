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

getline:
	call os_wait_for_key
	cmp al, 0Dh				; If enter key is pressed
	jz .stopline
	cmp al, 8				; If backspace key is pressed
	jz .backspce
	;cmp al, 0				; If nothing is pressed
	;jz getline

	; If it isn't enter or backspace, print the char out
	mov ah, 0Eh
	int 10h
	xor di, di
	add di, si
	xor ch, ch
	add di, cx
	mov [di], al			; Puts the value of al into the variable
	inc cl					; Increase the counter
	jmp getline

	.stopline:
	; Must go to new line
	mov al, 0Dh
	mov ah, 0Eh
	int 10h
	mov al, 0Ah
	int 10h

	; Then return
	ret

	.backspce:
	cmp cl, 0				; If the counter is at 0 then doen't go back
	jz getline
	dec cl					; Otherwise decrease the counter
	xor di, di
	add di, si
	xor ch, ch
	add di, cx
	mov word [di], 0				; Replace the value with 0
	; Get cursor pos
	mov ah, 3
	int 10h

	; dh is the row it is on
	; dl is the column it is on
	dec dl					; Decrease column by 1
	mov ah, 2
	int 10h

	; Overwrites any character on the spot as space
	mov ah, 0Ah
	mov al, 20h				; The spacebar ascii symbol
	push cx					; Preserve counter value
	xor cx, cx				; Should only appear once
	int 10h
	pop cx					; Restore counter value
	jmp getline

welcome_msg db 'Welcome to CYOS! Please login', 13, 10, 0
login_prmt db 'LOGIN: ', 0
pass_prmt db 'PASSWORD: ', 0
login_buff times 50 db 0
pass_buff times 50 db 0

; +---------------------------------+
; |Features to pull into the kernel |
; +---------------------------------+

	%INCLUDE 'src/include/keyboard.asm'

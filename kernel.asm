[org 8000h]

; Prints welcome message
mov si, msg
call printf

; Waits for keystroke until halting
call os_wait_for_key
mov ah, 0Eh					; Prints out keypressed
int 10h						; yay!

jmp $

printf:
	lodsb
	or al, al
	jz .done
	mov ah, 0Eh
	int 10h
	jmp printf
	.done:
	ret

msg db 'Welcome to CYOS!', 13, 10, 0

; +---------------------------------+
; |Features to pull into the kernel |
; +---------------------------------+

	%INCLUDE 'include/keyboard.asm'

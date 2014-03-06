; ===============================
; CYOS - include/keyboard.asm
; 
; Description: For handling and 
; providing keyboard functions.
; 
; Author: Ng Cheuk Yin
; ===============================

; Functions:
;	os_wait_for_key		- Waits for keypress and returns key
;	os_getkey			- Scans keyboard for input. Doesn't wait.

; os_wait_for_key:
;	Requires: NONE
;	Returns: AX=keypressed
os_wait_for_key:
	pusha				; Preserves everything

	xor ax, ax
	mov ah, 10h
	int 16h

	mov [.temp_buf], ax	; Move to temperary buffer
	
	popa
	mov ax, [.temp_buf]
	ret

; os_getkey
;	Requires: NONE
;	Returns: AX=0 if no keys pressed, otherwise scan code
os_getkey:
	pusha				; Preserves everything

	xor ax, ax
	mov ah, 1
	int 16h
	jz .nokeystrk

	xor ax, ax
	int 16h

	mov [.temp_buf], ax	; Moves to temperary buffer

	popa
	mov ax, [.temp_buf]
	ret
	
	.nokeystrk:
	popa
	mov ax, 0
	ret

; Temperaray variable(s)
.temp_buf dw 0

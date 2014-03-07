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
;	os_getline			- Gets a line. Returns on carriage ret

; os_getline
;	Requires: si=buffer
;	Returns: si=buffer
os_getline:
	pusha
	mov ax, 0
	push ax
	.o_gt_lp:
		call os_wait_for_key
		cmp al, 0		; Repeats if nothing was pressed
		jz .o_gt_lp
		cmp al, 0Dh		; Terminates if ENTER was pressed
		jz .o_gt_ret
		mov ah, 0Eh		; Prints out the letter
		int 10h
		push ax
		jmp .o_gt_lp
	.o_gt_ret:
		pop ax
		cmp ax, 0		; See if end of input
		jz .o_gt_end
		; If not, record in SI
		mov [si], al
		inc si
		jmp .o_gt_ret
	.o_gt_end:
		; Gets position
		mov ah, 03h
		int 10h
		xor dl, dl		; Set column to 0
		inc dh
		; Sets cursor position
		mov ah, 02h
		int 10h
		; Return
		popa
		ret

; os_wait_for_key:
;	Requires: NONE
;	Returns: AX=keypressed
os_wait_for_key:
	pusha				; Preserves everything

	mov ax, 0
	mov ah, 10h
	int 16h

	mov [.temp_buf], ax	; Move to temperary buffer
	
	popa
	mov ax, [.temp_buf]
	ret
	.temp_buf dw 0

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

	.temp_buf dw 0

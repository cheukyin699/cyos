; ===============================
; CYOS - include/system.asm
; 
; Description: For handling and 
; providing misc functions.
; 
; Author: Ng Cheuk Yin
; ===============================

; Functions:
;	os_printf				- Printf operation
;	os_pixel				- Creates a pixel on screen of a color
;	os_box					- Creates a box of a color

; os_box
; Requires: AL=color, CX=startcol, DX=startrow, SI=width, DI=height
; Returns: Nothing
os_box:
	pusha
	mov [o_b_srtcol], cx
	mov [o_b_srtrow], dx
	mov [o_b_h], di
	mov [o_b_w], si
	.o_b_row:
		.o_b_col:
			mov cx, [o_b_srtcol]
			add cx, [o_b_ci]
			mov dx, [o_b_srtrow]
			add dx, [o_b_ri]
			call os_pixel
			inc word[o_b_ci]
			mov si, [o_b_w]
			cmp [o_b_ci], si
			jl .o_b_col
		mov word[o_b_ci], 0
		inc word[o_b_ri]
		mov di, [o_b_h]
		cmp [o_b_ri], di
		jl .o_b_row
	popa
	ret

	o_b_w dw 0
	o_b_h dw 0
	o_b_srtcol dw 0
	o_b_srtrow dw 0
	o_b_ci dw 0					; The column index i
	o_b_ri dw 0					; The row index i

; os_pixel
; Requires: AL=color, CX=column, DX=row
; Returns: Nothing
os_pixel:
	pusha
	mov ah, 0Ch
	int 10h
	popa
	ret

; os_printf
; Requires: Message address copied to SI. Note: Message must be 0 terminated.
; Returns: Nothing
os_printf:
	pusha
	.o_pf_lp:
	lodsb
	or al, al
	jz .o_pf_done
	mov ah, 0Eh
	int 10h
	jmp .o_pf_lp
	.o_pf_done:
		popa
		ret

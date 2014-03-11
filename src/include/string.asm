; ===============================
; CYOS - include/string.asm
; 
; Description: For handling and 
; providing string functions.
; 
; Author: Ng Cheuk Yin
; ===============================

; Constants:
;	os_nl					- The String newline

; Functions:
;	os_strcat				- Turns 2 strings into 1
;	os_strcmp				- Compares 2 strings

; os_nl
; - Basically, it is a newline variable
os_nl db 13, 10, 0

; os_strcmp
; Requires: SI=string1, DI=string2
; Returns: CF=1 if true, CF=0 if false
os_strcmp:
	pusha
	.o_scmp:
		lodsb
		push ax
		xor al, [di]
		cmp al, 0
		jne .o_scmp_n
		pop ax
		inc di
		cmp al, 0
		je .o_scmp_done
		jmp .o_scmp
	.o_scmp_n:
		clc
		jmp .o_scmp_r
	.o_scmp_done:
		stc
	.o_scmp_r:
	popa
	ret

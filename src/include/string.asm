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
		cmp [si], [di]
		inc si
		inc di
		jz .o_scmp
		; pass
	popa
	ret

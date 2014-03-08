; ===============================
; CYOS - include/system.asm
; 
; Description: For handling and 
; providing algorithmic functions.
; 
; Author: Ng Cheuk Yin
; ===============================

; Functions:
;	os_safehash						- An XOR hash function

; os_safehash
; Requires: SI=string_to_hash, DI=salt
; Returns: SI=hashed_string
os_safehash:
	pusha
	.o_sh_lp:
		mov al, [si]
		or al, al
		jz .o_sh_done
		
		xor al, [di]
		mov [si], al
		inc si
		jmp .o_sh_lp
	.o_sh_done:
	popa
	ret

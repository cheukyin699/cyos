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

; os_nl
; - Basically, it is a newline variable
os_nl db 13, 10, 0

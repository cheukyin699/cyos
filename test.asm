; boot.asm
; Boots up the kernel
[bits 16]
[org 0x7c00]
start:
	mov si, load_msg
	call printf

load:
	mov ax, 1000h			; set segment to 1000
	mov es, ax
	mov bx, 0				; offset 0
	mov dl, 0
	mov dh, 0				; set head
	mov cl, 2				; set sector
	mov ch, 0				; set track

	mov ah, 2				; BIOS int 13h ah=2: READ SECTORS
	mov al, 17				; Reads 1 sector

	int 13h
	jnc noerror

	mov si, no_load
	call printf
	jmp load

noerror:
	mov si, loaded
	call printf

	; Jump to loaded area
	mov sp, 0				; Restore stack ptr

	mov ax, 1000h
	mov es, ax
	mov ds, ax
	push word 1000h
	push word 0
	retf

printf:
	lodsb
	or al, al
	jz .done
	mov ax, 0Eh
	int 10h
	jmp printf

	.done:
	ret

no_load db 'Error: Cannot load secondary file, will try again.', 13, 10, 0
loaded db 'Successfully loaded secondary file.', 13, 10, 0
load_msg db 'Bootloader - OK',13,10,0
times 510-($-$$) db 0
dw 0xAA55 

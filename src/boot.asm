[bits 16]
[org 0x7c00]

cls:
	mov ax, 3
	int 10h

ReadDisk:
	mov ax, 0
	mov bx, 0x8000		; The segment
	mov es, ax

	mov ah, 02h			; Read function
	mov al, 17			; Reads next 17 sectors
	mov ch, 0			; Cylinder #
	mov cl, 2			; Sector #
	mov dh, 0			; Head #
	mov dl, 0			; Drive #
	int 13h
	jnc Successful
	
	mov si, error
	call printf
	jmp ReadDisk

Successful:
	cli
	xor ax, ax
	mov ss, ax
	mov esp, 8000h

	jmp 8000h

printf:
	lodsb
	or al, al
	jz .done
	mov ah, 0Eh
	int 10h
	jmp printf
	.done:
		ret
suc db 'Kernel loaded successfully', 13, 10, 0
error db 'Error: Cannot read drive', 13, 10, 0
times 510-($-$$) db 0
dw 0xAA55

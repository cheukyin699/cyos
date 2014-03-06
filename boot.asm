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

PM:
	cli					; Clear/disable interupts
	mov eax, cr0
	or al, 1			; set PE (Protection Enabled)bit in CR0 (Control Register 0)
	mov cr0, eax

	jmp ReadDisk

Successful:
	mov si, s_str
	call printf

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
gdtr:
	dw 0			; For limit storage
	dd 0			; For base storage
s_str db 'Successfully loaded Kernel to memory', 13, 10, 0
error db 'Error: Cannot read drive - Trying again', 13, 10, 0
times 510-($-$$) db 0
dw 0xAA55

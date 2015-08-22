; helloNoNull.asm 
; Author: citu_adrian@yahoo.com
; Description: Dummy shellcode with no null bytes

global _start
section .text
_start:
	; print hello world on the screen
	xor eax, eax
	mov al, 0x4
	
	xor ebx, ebx
	mov bl, 0x1
	
	mov ecx, message
	
	xor edx, edx
	mov dl, 0xD
	int 0x80


	; exit the program gracefully
	xor eax, eax
	mov al, 0x1
	
	xor ebx, ebx
	mov bl, 0x5
	int 0x80

section .data
	message: db "Hello World!", 0xA

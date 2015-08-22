; helloCallJmp.asm 
; Author: citu_adrian@yahoo.com
; Description: Dummy shellcode using the jmp call pop technique to 
; compare the memoty location of datas


global _start

section .text
		
_start:
	jmp short data
	
	shellcode:

		xor eax, eax
		mov al, 0x4
		
		xor ebx, ebx
		mov bl, 0x1
		
		pop ecx
		
		xor edx, edx
		mov dl, 0xD
		int 0x80

		xor eax, eax
		mov al, 0x1
		
		xor ebx, ebx
		mov bl, 0x5
		int 0x80
			
	data:
		call shellcode
		message: db "Hello World!", 0xA

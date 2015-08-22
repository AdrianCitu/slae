; helloStack.asm 
; Author: citu_adrian@yahoo.com
; Description: Dummy shellcode using the stack to 
; compare the memory location of datas


global _start

section .text

_start:

	xor eax, eax
	mov al, 0x4
	
	xor ebx, ebx
	mov bl, 0x1
	
	;"0x0"
	xor ecx, ecx
	push ecx
	
	;"\n"
	push 0x0A
	
	;"!dlr"
    push 0x21646C72
    
    ;"oW o"
    push 0x6F57086F
    
    ;"lleH"	
	push 0x6C6C6548
	
	mov ecx, esp
	
	xor edx, edx
	mov dl, 0xD
	int 0x80

	xor eax, eax
	mov al, 0x1
	
	xor ebx, ebx
	mov bl, 0x5
	int 0x80


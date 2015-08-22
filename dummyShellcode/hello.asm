; hello.asm 
; Author: citu_adrian@yahoo.com
; Description: Dummy shellcode

global _start

section .text

_start:
    
    ;execute write(int fd, const void *buf, size_t count); 
	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, message
	mov edx, 0xD
	int 0x80


	;execute _exit(0);
	mov eax, 0x1
	mov ebx, 0x5
	int 0x80

section .data
	message: db "Hello World!", 0xA




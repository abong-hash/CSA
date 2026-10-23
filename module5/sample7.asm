; swap two numbers using push and pop
 
 
section .data   
    digit db '0', 10
 
section .text 
    global _start
 
_start:
 
    ;original value 
    mov eax, 3
    mov ebx, 8
 
    push eax        ;push 3
    push ebx        ;push 8
 
    mov esi, eax    ; ESI = 8
    mov edi, ebx    ; EDI = 3
 
    ;first swapped
    mov eax, esi 
    add al, '0'
    mov [digit], al
 
    mov eax,4
    mov ebx,1
    mov ecx,digit
    mov edx,2
    int 0x80
 
    ;first swapped
    mov eax, edi 
    add al, '0'
    mov [digit], al
 
    mov eax,4
    mov ebx,1
    mov ecx,digit
    mov edx,2
    int 0x80
 
    mov eax,1
    xor ebx, ebx
    int 0x80
;Push and pop
;8
;3
section .data 
    digit db '0', 10
 
section .text 
    global _start
 
_start:
 
    push dword 3
    push dword 8
 
    pop eax
    pop ebx
 
    mov esi, eax        ;esi 9
    mov edi, ebx        ;edi 2
 
    mov eax, esi
    add al, '0'
    mov [digit], al
    mov eax,4
    mov ebx,1
    mov ecx,digit
    mov edx,2
    int 0x80
 
    mov eax, edi
    add al, '0'
    mov [digit], al
 
    mov eax,4
    mov ebx,1
    mov ecx,digit
    mov edx,2
    int 0x80
 
    mov eax,1
    xor ebx,ebx
    int 0x80
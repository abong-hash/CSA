;Push and pop with procedure
 
section .data 
    digit db '0', 10
 
section .text 
    global _start
 
_start:
 
    call push_pop
 
    mov eax, esi          ;pop value 9
    call display_digit
 
    mov eax, edi
 
    call display_digit
 
    mov eax,1
    xor ebx,ebx
    int 0x80
 
push_pop:
 
    push dword 2        
    push dword 9
 
    pop eax             ;eax = 9
    pop ebx             ;ebx = 2
 
    mov esi, eax        ;esi 9
    mov edi, ebx        ;edi 2
 
    ret
 
display_digit:
    add al, '0'
    mov [digit], al
    mov eax,4
    mov ebx,1
    mov ecx,digit
    mov edx,2
    int 0x80
 
    ret
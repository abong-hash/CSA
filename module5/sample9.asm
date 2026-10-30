;recursion 
;3 2 1
 
section .data
    digit db '0', 10
 
section .text
    global _start
 
_start:
 
    mov eax, 3
    call recur
    mov eax, 1
    xor ebx, ebx
    int 0x80
 
recur:
    cmp eax, 0
    je .done
    push eax
    call print_digit
    pop eax
    dec eax
    call recur
.done:
    ret
print_digit:
 
    push eax
    push ebx
    push ecx
    push edx
    add al, '0'
    mov [digit], al
    mov eax, 4
    mov ebx, 1
    mov ecx, digit
    mov edx, 2
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
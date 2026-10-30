;3! = 3 x 2 x 1
;24 + 48 = 72
 
section .data
    digit db '0', 10
    ;star db '*'
section .text
    global _start
_start:
    mov eax, 4
    call recur
    call print_digit
    mov eax, 1
    xor ebx, ebx
    int 0x80
recur:
    cmp eax, 1          ;base case 
    jbe .done
    push eax
    dec eax
    call recur
    pop ebx
    imul eax, ebx       ;imul multiplies the current result ; product will accumulate 
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
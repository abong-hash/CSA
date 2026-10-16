;compute for the sum of 2 and 3
;registers eax, ebx where store 2 to eax, and 3 to ebx

section .data
    digit db '0', 10

section .text
    global _start

_start:
    mov eax, 2
    mov ebx, 3
    call calculate
    add al, '0'
    mov [digit], al

    mov eax, 4
    mov ebx, 1
    mov ecx, digit
    mov edx, 22
    int 0x80


calculate:
    add eax, ebx
    ret
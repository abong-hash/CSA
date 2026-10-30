section .data
    filename db 'hello.txt', 0
    msg db 'Hi!', 10
    len equ $-msg
section .text
    global _start
_start:
    mov eax, 8
    mov ebx, filename
    mov ecx, 0644o
    int 0x80
    test eax, eax
    js error
    mov esi, eax
    mov eax, 4
    mov ebx, esi
    mov ecx, msg
    mov edx, len
    int 0x80
    mov edi, eax
    mov eax, 6
    mov ebx, esi
    int 0x80
    cmp edi, len
    jne error
    xor ebx, ebx
    jmp exit
error:
    mov ebx, 1
exit:
    mov eax, 1
    int 0x80
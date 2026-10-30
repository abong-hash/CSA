section .data
    filename db 'hello.txt', 0
section .bss
    buffer resb 32
section .text
    global _start
_start:
    mov eax, 5
    mov ebx, filename
    xor ecx, ecx
    xor edx, edx
    int 0x80
    test eax, eax
    js error
    mov esi, eax
    mov eax, 3
    mov ebx, esi
    mov ecx, buffer
    mov edx, 32
    int 0x80
    mov edi, eax
    mov eax, 6
    mov ebx, esi
    int 0x80
    test edi, edi
    js error
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, edi
    int 0x80
    xor ebx, ebx
    jmp exit
error:
    mov ebx, 1
exit:
    mov eax, 1
    int 0x80
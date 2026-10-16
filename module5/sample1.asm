section .data
    msg db "Hello from a procedure!", 10
    len equ $-msg

section .text
    global _start

_start:
    call show
    mov eax, 1
    xor ebx, ebx
    int 0x80

show:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80
    ret
    
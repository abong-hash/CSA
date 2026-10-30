%macro print_text 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro
 
section .data
    msg db "Hello!", 10
    len equ $-msg
 
section .text
    global _start
 
_start:
    print_text msg, len
    print_text msg, len
    print_text msg, len
 
 
    mov eax, 1
    xor ebx, ebx
    int 0x80
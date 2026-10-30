section .data
    filename db 'beginner.txt', 0
section .text
    global _start
_start:
    mov eax, 8       ; sys_creat
    mov ebx, filename
    mov ecx, 0644o   ; file permissions
    int 0x80
    test eax, eax
    js error
    mov ebx, eax
    mov eax, 6       ; sys_close
    int 0x80
    xor ebx, ebx
    jmp exit
error:
    mov ebx, 1
exit:
    mov eax, 1
    int 0x80
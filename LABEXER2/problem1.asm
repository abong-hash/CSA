section .data
    input_string db "COMPUTER", 0
    newline db 10, 0

section .text
    global _start

_start:
    mov esi, input_string
    xor ecx, ecx

.push_loop:
    movzx eax, byte [esi]

    test eax, eax
    jz .prepare_pop

    push eax
    inc esi
    inc ecx
    jmp .push_loop

.prepare_pop:
    mov edi, input_string

.pop_loop:
    test ecx, ecx
    jz .display

    ; LIFO returns the characters in reverse order.
    pop eax
    mov [edi], al
    inc edi
    dec ecx
    jmp .pop_loop

.display:
    ; Preserve null termination after reversing.
    mov byte [edi], 0

    mov ecx, input_string
    call print_string

    mov ecx, newline
    call print_string

    ; Exit successfully.
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_string:
    pushad
    xor edx, edx

.length:
    cmp byte [ecx + edx], 0
    je .write

    inc edx
    jmp .length

.write:
    mov eax, 4                  
    mov ebx, 1                  
    int 0x80

    popad
    ret
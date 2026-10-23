section .data
    source dd 0, 10, 20, 30, 40  ; Change these for each test case

    reversed_msg db "Reversed array: "
    reversed_len equ $ - reversed_msg

    sum_msg db "Sum: "
    sum_len equ $ - sum_msg

    space db " "
    newline db 10

section .bss
    destination resd 5
    total resd 1
    number_buffer resb 12

section .text
    global _start

_start:
    mov esi, source
    mov ecx, 5

push_loop:
    push dword [esi]         
    add esi, 4
    loop push_loop

    mov edi, destination
    mov ecx, 5
    xor eax, eax             

pop_loop:
    pop edx
    mov [edi], edx           
    add eax, edx             
    add edi, 4
    loop pop_loop

    mov [total], eax         

    ; Display the array label
    mov ecx, reversed_msg
    mov edx, reversed_len
    call print_text

    mov esi, destination
    mov edi, 5

display_loop:
    mov eax, [esi]
    call print_integer

    add esi, 4
    dec edi
    jz array_finished

    mov ecx, space
    mov edx, 1
    call print_text
    jmp display_loop

array_finished:
    mov ecx, newline
    mov edx, 1
    call print_text

    ; Display the sum label
    mov ecx, sum_msg
    mov edx, sum_len
    call print_text

    mov eax, [total]
    call print_integer

    mov ecx, newline
    mov edx, 1
    call print_text

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80


print_text:
    pushad

    mov eax, 4
    mov ebx, 1
    int 0x80

    popad
    ret


print_integer:
    pushad

    mov edi, number_buffer + 12
    mov ebx, 10
    xor esi, esi             

    test eax, eax
    jns convert_digits

    mov esi, 1
    neg eax

convert_digits:
    xor edx, edx
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl

    test eax, eax
    jnz convert_digits

    test esi, esi
    jz write_integer

    dec edi
    mov byte [edi], '-'

write_integer:
    mov ecx, edi
    mov edx, number_buffer + 12
    sub edx, edi

    mov eax, 4
    mov ebx, 1
    int 0x80

    popad
    ret
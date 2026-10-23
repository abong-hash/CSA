section .data
    number dw 42             ; Change this for each test case

section .bss
    binary resb 17          

section .text
    global _start

_start:
    movzx eax, word [number]
    mov ebx, 2
    xor ecx, ecx            

    ; Handle zero separately
    test eax, eax
    jnz divide_loop

    push dword 0
    inc ecx
    jmp prepare_output

divide_loop:
    xor edx, edx            
    div ebx                 

    push edx                
    inc ecx

    test eax, eax
    jnz divide_loop

prepare_output:
    mov edi, binary
    mov esi, ecx            

pop_loop:
    pop edx                 
    add dl, '0'             
    mov [edi], dl
    inc edi
    loop pop_loop

    mov byte [edi], 10       

    ; Display the binary string
    mov eax, 4
    mov ebx, 1
    mov ecx, binary
    mov edx, esi
    inc edx                 
    int 0x80

    
    mov eax, 1
    xor ebx, ebx
    int 0x80
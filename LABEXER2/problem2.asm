section .data
    expression db "A + (B * (C - D)", 0

    balanced_message db "Result (EAX): 1 (Balanced)",10,0

    extra_opening_message db "Result (EAX): 0 (Unbalanced - Extra opening)",10,0

    unexpected_closing_message db "Result (EAX): 0 (Unbalanced - Unexpected closing)",10,0

    wrong_order_message db "Result (EAX): 0 (Unbalanced - Wrong order)",10,0

    unclosed_message db "Result (EAX): 0 (Unbalanced - Unclosed)",10,0

section .bss
    balance_result resd 1

    ; 0 = no error
    ; 1 = extra opening
    ; 2 = unexpected closing
    ; 3 = wrong order
    ; 4 = unclosed
    error_type resd 1

section .text
    global _start

_start:
    mov esi, expression
    call validate_brackets

    mov [balance_result], eax

    cmp eax, 1
    je .balanced

    cmp dword [error_type], 1
    je .extra_opening

    cmp dword [error_type], 2
    je .unexpected_closing

    cmp dword [error_type], 3
    je .wrong_order

    mov ecx, unclosed_message
    jmp .display

.balanced:
    mov ecx, balanced_message
    jmp .display

.extra_opening:
    mov ecx, extra_opening_message
    jmp .display

.unexpected_closing:
    mov ecx, unexpected_closing_message
    jmp .display

.wrong_order:
    mov ecx, wrong_order_message

.display:
    call print_string

    mov eax, 1
    xor ebx, ebx
    int 0x80

; Input:
;   ESI points to a null-terminated expression.

; Output:
;   EAX = 1 if balanced, otherwise 0.
;   error_type identifies the displayed explanation.

validate_brackets:
    push ebp
    mov ebp, esp

    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov dword [error_type], 0
    xor ecx, ecx               

.skip_spaces:
    movzx edx, byte [esi]

    cmp dl, ' '
    je .skip_character

    cmp dl, 9                  
    je .skip_character

    mov edi, edx
    jmp .scan

.skip_character:
    inc esi
    jmp .skip_spaces

.scan:
    movzx edx, byte [esi]

    test edx, edx
    jz .end_expression

    cmp dl, '('
    je .opening

    cmp dl, ')'
    je .closing

.next:
    inc esi
    jmp .scan

.opening:
    push dword 40              
    inc ecx
    jmp .next

.closing:
    test ecx, ecx
    jz .closing_error

    pop ebx
    dec ecx
    jmp .next

.closing_error:
    cmp edi, ')'
    je .wrong_order

    mov dword [error_type], 2
    xor eax, eax
    jmp .restore

.wrong_order:
    mov dword [error_type], 3
    xor eax, eax
    jmp .restore

.end_expression:
    test ecx, ecx
    jnz .opening_error

    mov eax, 1
    jmp .restore

.opening_error:
    cmp edi, '('
    je .extra_opening

    mov dword [error_type], 4
    xor eax, eax
    jmp .restore

.extra_opening:
    mov dword [error_type], 1
    xor eax, eax

.restore:
    lea esp, [ebp - 20]

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx

    pop ebp
    ret

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
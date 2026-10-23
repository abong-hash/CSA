section .data
    initial_values dd 0, 15, 15, 0
    operation dd 1

    success_message db "Registers preserved.", 10
                    db "ESP offset: 0 bytes (Balanced)", 10, 0

    failure_message db "ERROR: Registers or ESP were not preserved.", 10, 0
    operation_message db "ERROR: Invalid operation or zero divisor.", 10, 0

section .bss
    saved_esp resd 1

    calculated_value resd 1
    division_quotient resd 1
    division_remainder resd 1
    arithmetic_error resd 1

section .text
    global _start

_start:
    ; Initialize the four registers.
    mov eax, [initial_values]
    mov ebx, [initial_values + 4]
    mov ecx, [initial_values + 8]
    mov edx, [initial_values + 12]

    ; Record ESP before CALL.
    mov [saved_esp], esp

    call calculate_foo

    ; Verify zero net ESP offset after the subroutine returns.
    cmp esp, [saved_esp]
    jne .failed

    ; Verify that all original register values were restored.
    cmp eax, [initial_values]
    jne .failed

    cmp ebx, [initial_values + 4]
    jne .failed

    cmp ecx, [initial_values + 8]
    jne .failed

    cmp edx, [initial_values + 12]
    jne .failed

    cmp dword [arithmetic_error], 0
    jne .operation_error

    mov ecx, success_message
    call print_string

    mov eax, 1
    xor ebx, ebx
    int 0x80

.failed:
    mov ecx, failure_message
    jmp .error_exit

.operation_error:
    mov ecx, operation_message

.error_exit:
    call print_string

    mov eax, 1
    mov ebx, 1
    int 0x80

calculate_foo:
    push eax
    push ebx
    push ecx
    push edx

    cmp dword [operation], 1
    je .multiply_add

    cmp dword [operation], 2
    je .division_accumulation

    cmp dword [operation], 3
    je .subtraction_scaling

    cmp dword [operation], 4
    je .bitwise

    cmp dword [operation], 5
    je .modulo_division

    cmp dword [operation], 6
    je .zero_arithmetic

    jmp .bad_operation

.multiply_add:
    ; Result = (EAX * EBX) + ECX + EDX
    imul eax, ebx
    add eax, ecx
    add eax, edx
    jmp .save_result

.division_accumulation:
    ; Result = (EAX / EBX) + original ECX + original EDX
    test ebx, ebx
    jz .bad_operation

    add ecx, edx
    xor edx, edx
    div ebx
    add eax, ecx
    jmp .save_result

.subtraction_scaling:
    ; Result = ((EAX - EBX) * ECX) - EDX
    sub eax, ebx
    imul eax, ecx
    sub eax, edx
    jmp .save_result

.bitwise:
    ; Result = (EAX AND EBX) OR ECX OR EDX
    and eax, ebx
    or eax, ecx
    or eax, edx
    jmp .save_result

.modulo_division:
    ; DIV produces the quotient in EAX and remainder in EDX.
    test ebx, ebx
    jz .bad_operation

    xor edx, edx
    div ebx

    mov [division_quotient], eax
    mov [division_remainder], edx
    jmp .save_result

.zero_arithmetic:
    ; Result = EAX + EBX - ECX + EDX
    add eax, ebx
    sub eax, ecx
    add eax, edx
    jmp .save_result

.bad_operation:
    mov dword [arithmetic_error], 1
    xor eax, eax

.save_result:
    mov [calculated_value], eax

    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

    ; Restore in reverse order.
    pop edx
    pop ecx
    pop ebx
    pop eax
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
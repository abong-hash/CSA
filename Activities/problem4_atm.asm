section .data
    name_prompt db "Enter account name: ", 0
    pin_prompt db "Enter PIN: ", 0
    amount_prompt db "Enter withdrawal amount: ", 0

    correct_pin db "1234", 0

    granted db "ACCESS GRANTED", 10, 0
    denied db "ACCESS DENIED", 10, 0

    balance_label db "Current Balance: PHP ", 0
    withdrawn_label db "Amount Withdrawn: PHP ", 0
    remaining_label db "Remaining Balance: PHP ", 0

    invalid_amount db "INVALID AMOUNT", 10, 0
    insufficient db "INSUFFICIENT FUNDS", 10, 0
    not_multiple db "AMOUNT MUST BE A MULTIPLE OF 100", 10, 0
    success db "WITHDRAWAL SUCCESSFUL", 10, 0

    balance dd 10000

    newline db 10, 0
    bad_text db "Enter 1 to 127 characters.", 10, 0

section .bss
    account_name resb 128
    pin_buffer resb 128
    amount_buffer resb 128

    amount resd 1

    input_char resb 1
    number_text resb 11

section .text
    global _start

_start:
    mov ecx, name_prompt
    mov edi, account_name
    call read_text

    mov ecx, pin_prompt
    call print_string

    mov edi, pin_buffer
    call read_line
    jc deny_access

    call verify_pin
    jc deny_access

    mov ecx, granted
    call print_string

    mov ecx, balance_label
    call print_string

    mov eax, [balance]
    call print_uint

    mov ecx, newline
    call print_string

    mov ecx, amount_prompt
    call print_string

    mov edi, amount_buffer
    call read_line
    jc bad_amount

    ; First check: positive integer.
    mov esi, amount_buffer
    call parse_uint
    jc bad_amount

    test eax, eax
    jz bad_amount

    mov [amount], eax

    call withdraw
    jmp exit_program

deny_access:
    mov ecx, denied
    call print_string
    jmp exit_program

bad_amount:
    mov ecx, invalid_amount
    call print_string
    jmp exit_program

verify_pin:
    mov esi, pin_buffer
    mov edi, correct_pin

.next:
    mov al, [esi]
    cmp al, [edi]
    jne .wrong

    test al, al
    jz .correct

    inc esi
    inc edi
    jmp .next

.wrong:
    stc
    ret

.correct:
    clc
    ret

withdraw:
    ; Second check: amount must not exceed balance.
    mov eax, [amount]
    cmp eax, [balance]
    ja .insufficient

    ; Third check: amount must be divisible by 100.
    xor edx, edx
    mov ebx, 100
    div ebx

    test edx, edx
    jnz .not_multiple

    ; All checks passed.
    mov eax, [amount]
    sub [balance], eax

    mov ecx, success
    call print_string

    mov ecx, withdrawn_label
    call print_string

    mov eax, [amount]
    call print_uint

    mov ecx, newline
    call print_string

    mov ecx, remaining_label
    call print_string

    mov eax, [balance]
    call print_uint

    mov ecx, newline
    call print_string
    ret

.insufficient:
    mov ecx, insufficient
    call print_string
    ret

.not_multiple:
    mov ecx, not_multiple
    call print_string
    ret

print_string:
    pushad
    mov edx, ecx

.count:
    cmp byte [edx], 0
    je .write
    inc edx
    jmp .count

.write:
    sub edx, ecx

    mov eax, 4
    mov ebx, 1
    int 0x80

    popad
    ret

read_line:
    pushad
    xor esi, esi
    xor ebp, ebp

.next:
    mov eax, 3
    xor ebx, ebx
    mov ecx, input_char
    mov edx, 1
    int 0x80

    test eax, eax
    js exit_program
    jz .eof

    mov al, [input_char]

    cmp al, 10
    je .done

    cmp al, 13
    je .next

    test al, al
    jz .overflow

    cmp esi, 127
    jae .overflow

    mov [edi + esi], al
    inc esi
    jmp .next

.overflow:
    mov ebp, 1
    jmp .next

.eof:
    test esi, esi
    jz exit_program

.done:
    mov byte [edi + esi], 0

    test ebp, ebp
    jnz .invalid

    popad
    clc
    ret

.invalid:
    popad
    stc
    ret

read_text:
    call print_string
    call read_line
    jc .invalid

    cmp byte [edi], 0
    je .invalid
    ret

.invalid:
    push ecx
    mov ecx, bad_text
    call print_string
    pop ecx
    jmp read_text

parse_uint:
    xor eax, eax

    cmp byte [esi], 0
    je .invalid

.next:
    movzx ebx, byte [esi]

    test ebx, ebx
    jz .valid

    cmp ebx, '0'
    jb .invalid

    cmp ebx, '9'
    ja .invalid

    sub ebx, '0'

    mov edx, 10
    mul edx

    test edx, edx
    jnz .invalid

    add eax, ebx
    jc .invalid

    inc esi
    jmp .next

.valid:
    clc
    ret

.invalid:
    stc
    ret

print_uint:
    pushad

    mov edi, number_text + 10
    mov byte [edi], 0
    mov ebx, 10

.next:
    xor edx, edx
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl

    test eax, eax
    jnz .next

    mov ecx, edi
    call print_string

    popad
    ret

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
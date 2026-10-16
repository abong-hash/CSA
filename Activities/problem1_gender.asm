section .data
    name_prompt db "What is your name? ", 0
    age_prompt db "How old are you? ", 0
    gender_prompt db "What is your gender? ", 0

    hello_text db "Hello ", 0
    age_text db "You are ", 0
    years_text db " years old", 10, 0

    male_text db "Hello", 10, 0
    female_text db "World", 10, 0
    invalid_text db "INVALID", 10, 0

    newline db 10, 0
    bad_text db "Enter 1 to 127 characters.", 10, 0
    bad_number db "INVALID AGE. Enter a nonnegative integer.", 10, 0

section .bss
    full_name resb 128
    age_buffer resb 128
    gender_buffer resb 128

    age resd 1
    gender_valid resb 1

    input_char resb 1
    number_text resb 11

section .text
    global _start

_start:
    mov ecx, name_prompt
    mov edi, full_name
    call read_text

    call read_age

    mov ecx, gender_prompt
    call print_string

    mov edi, gender_buffer
    call read_line
    setnc byte [gender_valid]

    call show_person
    call show_gender

    jmp exit_program

show_gender:
    cmp byte [gender_valid], 1
    jne .invalid

    cmp byte [gender_buffer + 1], 0
    jne .invalid

    mov al, [gender_buffer]

    cmp al, 'M'
    je .male

    cmp al, 'm'
    je .male

    cmp al, 'F'
    je .female

    cmp al, 'f'
    je .female

.invalid:
    mov ecx, invalid_text
    jmp .display

.male:
    mov ecx, male_text
    jmp .display

.female:
    mov ecx, female_text

.display:
    call print_string
    ret

read_age:
    mov ecx, age_prompt
    call print_string

    mov edi, age_buffer
    call read_line
    jc .invalid

    mov esi, age_buffer
    call parse_uint
    jc .invalid

    mov [age], eax
    ret

.invalid:
    mov ecx, bad_number
    call print_string
    jmp read_age

show_person:
    mov ecx, hello_text
    call print_string

    mov ecx, full_name
    call print_string

    mov ecx, newline
    call print_string

    mov ecx, age_text
    call print_string

    mov eax, [age]
    call print_uint

    mov ecx, years_text
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

; ECX = prompt, EDI = destination buffer.
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

; Convert digits at ESI into EAX.
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

; Print the integer in EAX.
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
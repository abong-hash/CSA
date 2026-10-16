section .data
    name_prompt db "Enter student name: ", 0
    id_prompt db "Enter student ID: ", 0
    grade_prompt db "Enter grade: ", 0

    name_label db "Student Name: ", 0
    id_label db "Student ID: ", 0
    grade_label db "Grade: ", 0
    class_label db "Classification: ", 0

    excellent db "Excellent", 10, 0
    very_good db "Very Good", 10, 0
    good db "Good", 10, 0
    passed db "Passed", 10, 0
    failed db "Failed", 10, 0
    invalid_text db "INVALID GRADE", 10, 0

    long_input db "[input exceeds 127 characters]", 0
    newline db 10, 0
    bad_text db "Enter 1 to 127 characters.", 10, 0

section .bss
    full_name resb 128
    student_id resb 128
    grade_buffer resb 128

    grade resd 1
    grade_valid resb 1
    grade_too_long resb 1

    input_char resb 1

section .text
    global _start

_start:
    mov ecx, name_prompt
    mov edi, full_name
    call read_text

    mov ecx, id_prompt
    mov edi, student_id
    call read_text

    mov ecx, grade_prompt
    call print_string

    mov edi, grade_buffer
    call read_line
    jc overlong_grade

    mov esi, grade_buffer
    call parse_uint
    jc show_details

    cmp eax, 100
    ja show_details

    mov [grade], eax
    mov byte [grade_valid], 1
    jmp show_details

overlong_grade:
    mov byte [grade_too_long], 1

show_details:
    mov ecx, name_label
    call print_string

    mov ecx, full_name
    call print_string

    mov ecx, newline
    call print_string

    mov ecx, id_label
    call print_string

    mov ecx, student_id
    call print_string

    mov ecx, newline
    call print_string

    mov ecx, grade_label
    call print_string

    mov ecx, grade_buffer

    cmp byte [grade_too_long], 1
    jne print_grade

    mov ecx, long_input

print_grade:
    call print_string

    mov ecx, newline
    call print_string

    mov ecx, class_label
    call print_string

    call classify_grade
    jmp exit_program

classify_grade:
    cmp byte [grade_valid], 1
    jne .invalid

    mov eax, [grade]

    cmp eax, 90
    jae .excellent

    cmp eax, 85
    jae .very_good

    cmp eax, 80
    jae .good

    cmp eax, 75
    jae .passed

    mov ecx, failed
    jmp .display

.excellent:
    mov ecx, excellent
    jmp .display

.very_good:
    mov ecx, very_good
    jmp .display

.good:
    mov ecx, good
    jmp .display

.passed:
    mov ecx, passed
    jmp .display

.invalid:
    mov ecx, invalid_text

.display:
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

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
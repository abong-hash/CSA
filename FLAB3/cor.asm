; COR PROGRAM
; Implements MACROS and PROCEDURES

%macro print_text 2
    mov ecx, %1
    mov edx, %2
    call print_proc
%endmacro

%macro input_detail 3
    print_text %1, %2
    mov ecx, %3
    call read_line
%endmacro

%macro show_detail 3
    print_text %1, %2
    mov ecx, %3
    call print_string
    print_text newline, 1
%endmacro

section .data
    UNIT_PRICE equ 1000
    LAB_PRICE equ 800

    header db "========================================", 10
           db "       CERTIFICATE OF REGISTRATION", 10
           db "========================================", 10
    header_len equ $ - header

    student_label db "Student#: "
    student_len equ $ - student_label

    name_label db "Name (Full Name): "
    name_len equ $ - name_label

    phone_label db "Phone: "
    phone_len equ $ - phone_label

    college_label db "College: "
    college_len equ $ - college_label

    program_label db "Program: "
    program_len equ $ - program_label

    year_label db "Year Level: "
    year_len equ $ - year_label

    address_label db "Address: "
    address_len equ $ - address_label

    details_title db 10, "---------- STUDENT DETAILS ----------", 10
    details_title_len equ $ - details_title

    units_prompt db 10, "Enter total number of units: "
    units_prompt_len equ $ - units_prompt

    labs_prompt db "Enter number of laboratory subjects: "
    labs_prompt_len equ $ - labs_prompt

    subjects_list db 10
        db "===================== SUBJECT LIST =====================", 10
        db "Course Code  Subject Title", 10
        db "--------------------------------------------------------", 10
        db "CCS0021      INFORMATION MANAGEMENT (LEC)", 10
        db "CCS0021L     INFORMATION MANAGEMENT (LAB)", 10
        db "CS0001       DISCRETE STRUCTURES 1", 10
        db "CS0003       COMPUTER SYSTEMS & ARCHITECTURE", 10
        db "CS0003L      COMPUTER SYSTEMS & ARCHITECTURE (LAB)", 10
        db "CS0070       OBJECT ORIENTED PROGRAMMING", 10
        db "CS0070L      OBJECT ORIENTED PROGRAMMING-LAB", 10
        db "GED0021      SPECIALIZED ENGLISH PROGRAM 2", 10
        db "GED0076      LINEAR ALGEBRA", 10
        db "GED0081      COLLEGE PHYSICS 1 LECTURE", 10
        db "GED0081L     COLLEGE PHYSICS 1 LABORATORY", 10
        db "========================================================", 10
    subjects_list_len equ $ - subjects_list

    summary db 10, "----------- FEE SUMMARY -----------", 10
            db "Price per unit: PHP 1000.00", 10
            db "Fee per laboratory subject: PHP 800.00", 10
    summary_len equ $ - summary

    units_label db "Total Units: "
    units_label_len equ $ - units_label

    labs_label db "Laboratory Subjects: "
    labs_label_len equ $ - labs_label

    tuition_label db "Tuition Fee: PHP "
    tuition_label_len equ $ - tuition_label

    lab_fee_label db "Laboratory Fee: PHP "
    lab_fee_label_len equ $ - lab_fee_label

    total_label db "TOTAL AMOUNT PAYABLE: PHP "
    total_label_len equ $ - total_label

    money_end db ".00", 10
    money_end_len equ $ - money_end

    invalid_msg db "Invalid input. Enter a nonnegative whole number: "
    invalid_len equ $ - invalid_msg

    overflow_msg db 10, "The entered amount is too large.", 10
    overflow_len equ $ - overflow_msg

    newline db 10

section .bss
    student_no resb 128
    full_name resb 128
    phone resb 128
    college resb 128
    program resb 128
    year_level resb 128
    address resb 128

    number_input resb 128
    input_char resb 1
    number_output resb 12

    total_units resd 1
    lab_subjects resd 1
    tuition_fee resd 1
    laboratory_fee resd 1
    total_fee resd 1

section .text
    global _start

_start:
    print_text header, header_len

    ; STEP 1: Enter personal details.
    input_detail student_label, student_len, student_no
    input_detail name_label, name_len, full_name
    input_detail phone_label, phone_len, phone
    input_detail college_label, college_len, college
    input_detail program_label, program_len, program
    input_detail year_label, year_len, year_level
    input_detail address_label, address_len, address

    ; STEP 2: Display personal details.
    print_text details_title, details_title_len

    show_detail student_label, student_len, student_no
    show_detail name_label, name_len, full_name
    show_detail phone_label, phone_len, phone
    show_detail college_label, college_len, college
    show_detail program_label, program_len, program
    show_detail year_label, year_len, year_level
    show_detail address_label, address_len, address

    ; Display the subjects after the student details.
    print_text subjects_list, subjects_list_len

    ; STEP 3: Enter total units.
    print_text units_prompt, units_prompt_len
    call read_integer
    mov [total_units], eax

    ; STEP 4: Enter laboratory subject count.
    print_text labs_prompt, labs_prompt_len
    call read_integer
    mov [lab_subjects], eax

    ; STEP 5: Compute fees.
    call compute_fees

    ; STEP 6: Display the fee summary.
    print_text summary, summary_len

    print_text units_label, units_label_len
    mov eax, [total_units]
    call print_number
    print_text newline, 1

    print_text labs_label, labs_label_len
    mov eax, [lab_subjects]
    call print_number
    print_text newline, 1

    print_text tuition_label, tuition_label_len
    mov eax, [tuition_fee]
    call print_number
    print_text money_end, money_end_len

    print_text lab_fee_label, lab_fee_label_len
    mov eax, [laboratory_fee]
    call print_number
    print_text money_end, money_end_len

    print_text total_label, total_label_len
    mov eax, [total_fee]
    call print_number
    print_text money_end, money_end_len

    ; Terminate the program.
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_proc:
    push eax
    push ebx

    mov eax, 4
    mov ebx, 1
    int 0x80

    pop ebx
    pop eax
    ret

read_line:
    pushad
    mov edi, ecx
    xor esi, esi

.read:
    mov eax, 3
    xor ebx, ebx
    mov ecx, input_char
    mov edx, 1
    int 0x80

    cmp eax, 0
    jle .done

    mov al, [input_char]

    cmp al, 10
    je .done

    cmp al, 13
    je .read

    ; Consume any extra characters if full.
    cmp esi, 127
    jae .read

    mov [edi + esi], al
    inc esi
    jmp .read

.done:
    mov byte [edi + esi], 0
    popad
    ret

print_string:
    xor edx, edx

.count:
    cmp byte [ecx + edx], 0
    je .display

    inc edx
    jmp .count

.display:
    call print_proc
    ret

read_integer:
.retry:
    mov ecx, number_input
    call read_line

    xor eax, eax
    mov esi, number_input

    cmp byte [esi], 0
    je .invalid

.convert:
    movzx edx, byte [esi]

    test edx, edx
    jz .done

    cmp edx, '0'
    jb .invalid
    cmp edx, '9'
    ja .invalid

    sub edx, '0'

    imul eax, eax, 10
    jo .invalid

    add eax, edx
    jo .invalid

    inc esi
    jmp .convert

.invalid:
    print_text invalid_msg, invalid_len
    jmp .retry

.done:
    ret

compute_fees:
    mov eax, [total_units]
    imul eax, eax, UNIT_PRICE
    jo amount_error
    mov [tuition_fee], eax

    mov eax, [lab_subjects]
    imul eax, eax, LAB_PRICE
    jo amount_error
    mov [laboratory_fee], eax

    add eax, [tuition_fee]
    jo amount_error
    mov [total_fee], eax
    ret

print_number:
    pushad

    mov edi, number_output + 12
    mov ebx, 10
    xor ecx, ecx

.convert:
    xor edx, edx
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl
    inc ecx

    test eax, eax
    jnz .convert

    mov edx, ecx
    mov ecx, edi
    call print_proc

    popad
    ret

amount_error:
    print_text overflow_msg, overflow_len

    mov eax, 1
    mov ebx, 1
    int 0x80
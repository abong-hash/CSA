; Simple calculator - NASM 32-bit Linux
; Enter numbers from 0 to 99. Press Enter after every answer.
; Only enter 'A', 'S', 'M', or 'D' as your choice

section .data
    clear db 27, '[2J', 27, '[H', 0
    menu db '----------------------------------', 10
         db 'MENU', 10
         db '[A]dd', 10, '[S]ubtract', 10
         db '[M]ultiply', 10, '[D]ivide', 10
         db '----------------------------------', 10
         db 'Enter your choice: ', 0
    
    prompt1 db 'Enter first number: ', 0
    prompt2 db 'Enter second number: ', 0
    
    sum db 'The sum is ', 0
    difference db 'The difference is ', 0
    product db 'The product is ', 0
    quotient db 'The quotient is ', 0
    
    again db 10, 'Do you want to try again (Y/N): ', 0
    error db 'Cannot divide by zero.', 10, 0
    invalid db 'Invalid choice, it must be A, S, M, or D', 10, 0
    minus db '-', 0
    newline db 10, 0

section .bss
    input resb 4
    choice resb 1
    num1 resd 1
    num2 resd 1
    output resb 6

section .text
    global _start

_start:

menu_loop:
    mov ecx, clear
    call print_string
    mov ecx, menu
    call print_string
    call read_input
    mov al, [input]
    mov [choice], al

    mov ecx, prompt1
    call print_string
    call read_number
    mov [num1], eax

    mov ecx, prompt2
    call print_string
    call read_number
    mov [num2], eax

    cmp byte [choice], 'A'
    je addition
    cmp byte [choice], 'S'
    je subtraction
    cmp byte [choice], 'M'
    je multiplication
    cmp byte [choice], 'D'
    je division
    mov ecx, invalid
    call print_string
    jmp try_again

addition:
    call add_numbers
    jmp show_answer

subtraction:
    call subtract_numbers
    jmp show_answer

multiplication:
    call multiply_numbers
    jmp show_answer

division:
    cmp dword [num2], 0
    je divide_error
    call divide_numbers

show_answer:
    call print_string           
    call print_number           
    mov ecx, newline
    call print_string
    jmp try_again

divide_error:
    mov ecx, error
    call print_string

try_again:
    mov ecx, again
    call print_string
    call read_input
    cmp byte [input], 'Y'
    je menu_loop
    cmp byte [input], 'y'
    je menu_loop

exit_program:
    mov eax, 1                  
    mov ebx, 0
    int 80h

; Arithmetic procedures return the answer in EAX.
add_numbers:
    mov eax, [num1]
    add eax, [num2]
    mov ecx, sum
    ret

subtract_numbers:
    mov eax, [num1]
    sub eax, [num2]
    mov ecx, difference
    ret

multiply_numbers:
    mov eax, [num1]
    imul eax, [num2]
    mov ecx, product
    ret

divide_numbers:
    mov eax, [num1]
    mov edx, 0
    div dword [num2]            
    mov ecx, quotient
    ret

; Read a response from the keyboard in an interactive terminal.
read_input:
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 4
    int 80h
    cmp eax, 0
    jle exit_program
    ret

; Convert one or two typed digits into a number.
; This simple version assumes valid input from 0 to 99.
read_number:
    call read_input
    movzx eax, byte [input]
    sub eax, '0'
    cmp byte [input + 1], 10    
    je number_ready
    cmp byte [input + 1], 13    
    je number_ready
    imul eax, eax, 10           
    movzx ebx, byte [input + 1]
    sub ebx, '0'
    add eax, ebx                

number_ready:
    ret

; Print the zero-terminated message at ECX.
print_string:
    pushad                     
    mov edx, 0

count_letters:
    cmp byte [ecx + edx], 0
    je write_string
    inc edx
    jmp count_letters

write_string:
    mov eax, 4
    mov ebx, 1
    int 80h
    popad                      
    ret

; Convert the answer into characters so it can be displayed.
print_number:
    cmp eax, 0
    jge convert_number
    mov ecx, minus
    call print_string
    neg eax

convert_number:
    mov edi, output + 5
    mov byte [edi], 0
    mov ebx, 10

next_digit:
    mov edx, 0
    div ebx                    
    add dl, '0'
    dec edi
    mov [edi], dl
    cmp eax, 0
    jne next_digit
    mov ecx, edi
    call print_string
    ret
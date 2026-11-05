%macro print 2
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    call write_all
%endmacro

section .data
    menu db 10, '========== GEORGETTE EATERY ==========', 10
         db 'A. Rice: Plain Rice        Php 5.00', 10
         db 'B. Rice: Java Rice         Php 10.00', 10
         db 'C. Ulam 1: Fish            Php 35.00', 10
         db 'D. Ulam 2: Pork            Php 50.00', 10
         db 'E. Ulam 3: Vegetables      Php 20.00', 10
         db 'F. Dessert: Saging con yelo Php 60.00', 10
         db 'Enter your choice [A-F]: '
    menu_len equ $ - menu

    ordered db 'You ordered: '
    ordered_len equ $ - ordered
    again db 'Do you want to order again? [Y/N]: '
    again_len equ $ - again
    bad_item db 'Invalid choice. Enter one letter from A to F.', 10
    bad_item_len equ $ - bad_item
    bad_again db 'Invalid answer. Enter Y or N.', 10
    bad_again_len equ $ - bad_again
    thanks db 10, 'Thank you! Please come again!', 10
    thanks_len equ $ - thanks
    heading db 10, 'Contents of receipt.txt:', 10
    heading_len equ $ - heading
    header db '========== GEORGETTE EATERY RECEIPT ==========', 10
           db 'Item                       Price', 10
           db '--------------------------------------------', 10
    header_len equ $ - header
    error_msg db 'Error: unable to read input or read/write a file/output.', 10
    error_len equ $ - error_msg
    filename db 'receipt.txt', 0

    rice db 'Plain Rice                 Php 5.00', 10
    rice_len equ $ - rice
    java db 'Java Rice                  Php 10.00', 10
    java_len equ $ - java
    fish db 'Fish                       Php 35.00', 10
    fish_len equ $ - fish
    pork db 'Pork                       Php 50.00', 10
    pork_len equ $ - pork
    vegetables db 'Vegetables                 Php 20.00', 10
    vegetables_len equ $ - vegetables
    dessert db 'Saging con yelo            Php 60.00', 10
    dessert_len equ $ - dessert

    items dd rice, java, fish, pork, vegetables, dessert
    lengths dd rice_len, java_len, fish_len, pork_len
            dd vegetables_len, dessert_len

section .bss
    receipt_fd resd 1
    input_char resb 1
    buffer resb 256

section .text
    global _start

_start:
    ; Create receipt.txt
    mov eax, 5                      
    mov ebx, filename
    mov ecx, 577                    
    mov edx, 420                    
    int 0x80
    test eax, eax
    js io_error
    mov [receipt_fd], eax

    mov ebx, eax
    mov ecx, header
    mov edx, header_len
    call write_all

show_menu:
    print menu, menu_len
    call read_choice
    test eax, eax                   
    jz finish
    cmp al, 'A'
    jb invalid_item
    cmp al, 'F'
    ja invalid_item

    sub eax, 'A'                    
    mov esi, [items + eax * 4]
    mov edi, [lengths + eax * 4]
    print ordered, ordered_len
    print esi, edi

    ; Record this selection, including repeated orders
    mov ebx, [receipt_fd]
    mov ecx, esi
    mov edx, edi
    call write_all

ask_again:
    print again, again_len
    call read_choice
    test eax, eax
    jz finish
    cmp al, 'Y'
    je show_menu
    cmp al, 'N'
    je finish
    print bad_again, bad_again_len
    jmp ask_again

invalid_item:
    print bad_item, bad_item_len
    jmp show_menu

finish:
    print thanks, thanks_len
    mov eax, 6                      
    mov ebx, [receipt_fd]
    int 0x80
    test eax, eax
    js io_error

    ; Reopen the saved file and display its actual contents.
    mov eax, 5
    mov ebx, filename
    xor ecx, ecx                    
    int 0x80
    test eax, eax
    js io_error
    mov [receipt_fd], eax
    print heading, heading_len

display_receipt:
    mov eax, 3                      
    mov ebx, [receipt_fd]
    mov ecx, buffer
    mov edx, 256
    int 0x80
    test eax, eax
    js io_error
    jz close_receipt
    mov edx, eax                    
    mov ebx, 1
    mov ecx, buffer
    call write_all
    jmp display_receipt

close_receipt:
    mov eax, 6
    mov ebx, [receipt_fd]
    int 0x80
    test eax, eax
    js io_error
    mov eax, 1                      
    xor ebx, ebx
    int 0x80

read_choice:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    xor esi, esi                    
    xor edi, edi                    
.read:
    mov eax, 3
    xor ebx, ebx                    
    mov ecx, input_char
    mov edx, 1
    int 0x80
    test eax, eax
    js io_error
    jz .end_line
    mov al, [input_char]
    cmp al, 10
    je .check
    cmp al, 13
    je .read
    test esi, esi
    jnz .extra
    movzx edi, al
.extra:
    cmp esi, 2
    jae .read
    inc esi
    jmp .read
.check:
    cmp esi, 1
    jne .invalid
    mov eax, edi
    cmp al, 'a'
    jb .done
    cmp al, 'z'
    ja .done
    sub eax, 32                     
    jmp .done
.end_line:
    test esi, esi
    jnz .check
    xor eax, eax
    jmp .done
.invalid:
    mov eax, 1
.done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

write_all:
    pushad
.write:
    test edx, edx
    jz .done
    mov eax, 4                      
    int 0x80
    test eax, eax
    jle io_error
    add ecx, eax
    sub edx, eax
    jmp .write
.done:
    popad
    ret

io_error:
    mov eax, 4
    mov ebx, 2                      
    mov ecx, error_msg
    mov edx, error_len
    int 0x80
    mov eax, 1
    mov ebx, 1                      
    int 0x80
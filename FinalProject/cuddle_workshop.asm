; The Cuddle Workshop: Build Your Own Bear - NASM 32-bit Linux

%macro PRINT 1
    mov esi, %1
    call emit_z
%endmacro

%macro EXIT 1
    mov eax, 1
    mov ebx, %1
    int 0x80
%endmacro

section .data
banner: db 10, "==========================================", 10, " THE CUDDLE WORKSHOP - BUILD YOUR OWN BEAR", 10, "==========================================", 10, 0
main_menu: db 10, "1. Create a new bear", 10, "2. View current bear and bill", 10, "3. Edit current bear", 10, "4. Checkout and save receipt", 10, "5. Read last saved receipt", 10, "6. Exit", 10, "Choice: ", 0
ask_customer: db "Customer name (1-30 ASCII characters): ", 0
ask_bear: db "Bear name (1-30 ASCII characters): ", 0
invalid: db "Invalid input. Please try again.", 10, 0
no_order: db "Create a bear first using option 1.", 10, 0
locked: db "This bear is already paid. Create a new bear to order again.", 10, 0
new_warning: db "A new bear replaces the current design. Continue? 1 Yes / 2 No: ", 0
edit_menu: db 10, "EDIT BEAR", 10, "1. Style", 10, "2. Expression", 10, "3. Outfit", 10, "4. Accessory", 10, "5. Return to main menu", 10, "Choice: ", 0
choose: db "Choose 1-3: ", 0
preview: db 10, "CURRENT BEAR PREVIEW", 10, 0
bill_header: db 10, "---------- CUSTOM BEAR ORDER ----------", 10, 0
customer_label: db "Customer: ", 0
bear_label: db "Bear name: ", 0
style_label: db "Style: ", 0
face_label: db "Expression: ", 0
outfit_label: db "Outfit: ", 0
acc_label: db "Accessory: ", 0
price_sep: db " - Php ", 0
total_label: db "TOTAL: Php ", 0
payment_label: db "PAYMENT: Php ", 0
change_label: db "CHANGE: Php ", 0
paid_label: db "STATUS: PAID", 10, 0
unpaid_label: db "STATUS: UNPAID", 10, 0
confirm: db "Confirm checkout? 1 Yes / 2 Cancel: ", 0
pay_prompt: db "Cash payment in whole pesos (0-999999): ", 0
short_cash: db "Insufficient payment. Enter the full cash amount again.", 10, 0
saved: db "Payment accepted. Receipt saved to bear_receipt.txt.", 10, 0
file_error: db "File operation failed. Payment is not finalized; you may retry.", 10, 0
read_error: db "Cannot read the receipt. Complete and save an order first, or check file permissions.", 10, 0
receipt_header: db 10, "========== SAVED BEAR RECEIPT ==========", 10, 0
goodbye: db 10, "Thank you for visiting The Cuddle Workshop!", 10, 0
footer: db "--------------------------------------", 10, " Thank you! Please hug your new friend.", 10, "--------------------------------------", 10, 0
nl: db 10, 0
style_menu: db 10, "CHOOSE BEAR STYLE", 10, "1. Classic - Php 200", 10, "        ()___()", 10, "        (     )", 10, 10, "2. Tiny Ears - Php 220", 10, "        o_____o", 10, "        (     )", 10, 10, "3. Fluffy - Php 250", 10, "        ()~~~()", 10, "        {     }", 10, 0
face_menu: db 10, "CHOOSE EXPRESSION", 10, "1. Happy - Included", 10, "        ( o o )", 10, "        (  v  )", 10, 10, "2. Sleepy - Php 10", 10, "        ( - - )", 10, "        (  v  )", 10, 10, "3. Winking - Php 15", 10, "        ( o - )", 10, "        (  v  )", 10, 0
outfit_menu: db 10, "CHOOSE OUTFIT", 10, "1. Plain Shirt - Php 40", 10, "       /|-----|\", 10, "      / |     | \", 10, "        |_____|", 10, 10, "2. Overalls - Php 70", 10, "       /|H   H|\", 10, "      / |H___H| \", 10, "        |__O__|", 10, 10, "3. Bow Tie - Php 30", 10, "       /| ><  |\", 10, "      / |     | \", 10, "        |_____|", 10, 0
acc_menu: db 10, "CHOOSE ACCESSORY", 10, "1. None - Included", 10, "        ()___()", 10, 10, "2. Party Hat - Php 25", 10, "          /\", 10, "         /..\", 10, "        ()___()", 10, 10, "3. Crown - Php 50", 10, "        \|^|^|/", 10, "        ()___()", 10, 0
feet: db "        /     \", 10, "       (___|___)", 10, 0
style_name0: db "Classic", 0
style_name1: db "Tiny Ears", 0
style_name2: db "Fluffy", 0
face_name0: db "Happy", 0
face_name1: db "Sleepy", 0
face_name2: db "Winking", 0
outfit_name0: db "Plain Shirt", 0
outfit_name1: db "Overalls", 0
outfit_name2: db "Bow Tie", 0
acc_name0: db "None", 0
acc_name1: db "Party Hat", 0
acc_name2: db "Crown", 0
head0: db "        ()___()", 10, 0
head1: db "        o_____o", 10, 0
head2: db "        ()~~~()", 10, 0
face_art0: db "        ( o o )", 10, "        (  v  )", 10, 0
face_art1: db "        ( - - )", 10, "        (  v  )", 10, 0
face_art2: db "        ( o - )", 10, "        (  v  )", 10, 0
fluffy_face0: db "        { o o }", 10, "        {  v  }", 10, 0
fluffy_face1: db "        { - - }", 10, "        {  v  }", 10, 0
fluffy_face2: db "        { o - }", 10, "        {  v  }", 10, 0
outfit_art0: db "       /|-----|\", 10, "      / |     | \", 10, "        |_____|", 10, 0
outfit_art1: db "       /|H   H|\", 10, "      / |H___H| \", 10, "        |__O__|", 10, 0
outfit_art2: db "       /| ><  |\", 10, "      / |     | \", 10, "        |_____|", 10, 0
acc_art0: db 0
acc_art1: db "          /\", 10, "         /..\", 10, 0
acc_art2: db "        \|^|^|/", 10, 0
filename: db "bear_receipt.txt",0
style_names: dd style_name0,style_name1,style_name2
face_names: dd face_name0,face_name1,face_name2
outfit_names: dd outfit_name0,outfit_name1,outfit_name2
acc_names: dd acc_name0,acc_name1,acc_name2
heads: dd head0,head1,head2
faces: dd face_art0,face_art1,face_art2
fluffy_faces: dd fluffy_face0,fluffy_face1,fluffy_face2
outfit_arts: dd outfit_art0,outfit_art1,outfit_art2
acc_arts: dd acc_art0,acc_art1,acc_art2
style_prices: dd 200,220,250
face_prices: dd 0,10,15
outfit_prices: dd 40,70,30
acc_prices: dd 0,25,50

section .bss
line: resb 128
one_byte: resb 1
customer: resb 31
bear: resb 31
number_buffer: resb 12
read_buffer: resb 1024
receipt: resb 4096
receipt_len: resd 1
capture: resd 1
io_error: resd 1
active: resd 1
paid: resd 1
style: resd 1
face: resd 1
outfit: resd 1
acc: resd 1
total: resd 1
payment: resd 1
change: resd 1
file_fd: resd 1

section .text
    global _start

_start:
    cld
    PRINT banner
.main:
    PRINT main_menu
    mov ebx, 1
    mov edx, 6
    call get_range
    cmp eax, 1
    je .new
    cmp eax, 2
    je .view
    cmp eax, 3
    je .edit
    cmp eax, 4
    je .checkout
    cmp eax, 5
    je .read
    PRINT goodbye
    EXIT 0
.new:
    cmp dword [active], 0
    je .create
    PRINT new_warning
    mov ebx, 1
    mov edx, 2
    call get_range
    cmp eax, 2
    je .main
.create:
    call create_bear
    jmp .main
.view:
    call require_order
    jc .main
    call show_order
    jmp .main
.edit:
    call require_editable
    jc .main
    call edit_bear
    jmp .main
.checkout:
    call require_editable
    jc .main
    call checkout
    jmp .main
.read:
    call read_receipt
    jmp .main

require_order:
    cmp dword [active], 0
    jne .ok
    PRINT no_order
    stc
    ret
.ok:
    clc
    ret
require_editable:
    call require_order
    jc .done
    cmp dword [paid], 0
    je .ok
    PRINT locked
    stc
    ret
.ok:
    clc
.done:
    ret

create_bear:
    PRINT ask_customer
    mov edi, customer
    call get_name
    PRINT ask_bear
    mov edi, bear
    call get_name
    mov dword [active], 1
    mov dword [paid], 0
    mov dword [style], 0
    mov dword [face], 0
    mov dword [outfit], 0
    mov dword [acc], 0
    call choose_style
    call choose_face
    call choose_outfit
    call choose_acc
    call show_order
    ret

choose_style:
    PRINT style_menu
    PRINT choose
    mov ebx, 1
    mov edx, 3
    call get_range
    dec eax
    mov [style], eax
    call preview_bear
    ret
choose_face:
    PRINT face_menu
    PRINT choose
    mov ebx, 1
    mov edx, 3
    call get_range
    dec eax
    mov [face], eax
    call preview_bear
    ret
choose_outfit:
    PRINT outfit_menu
    PRINT choose
    mov ebx, 1
    mov edx, 3
    call get_range
    dec eax
    mov [outfit], eax
    call preview_bear
    ret
choose_acc:
    PRINT acc_menu
    PRINT choose
    mov ebx, 1
    mov edx, 3
    call get_range
    dec eax
    mov [acc], eax
    call preview_bear
    ret

edit_bear:
.again:
    PRINT edit_menu
    mov ebx, 1
    mov edx, 5
    call get_range
    cmp eax, 5
    je .done
    cmp eax, 1
    je .style
    cmp eax, 2
    je .face
    cmp eax, 3
    je .outfit
    call choose_acc
    jmp .bill
.style:
    call choose_style
    jmp .bill
.face:
    call choose_face
    jmp .bill
.outfit:
    call choose_outfit
.bill:
    call show_order
    jmp .again
.done:
    ret

preview_bear:
    PRINT preview
    call render_bear
    ret
render_bear:
    mov eax, [acc]
    mov esi, [acc_arts+eax*4]
    call emit_z
    mov eax, [style]
    mov esi, [heads+eax*4]
    call emit_z
    mov eax, [face]
    mov esi, [faces+eax*4]
    cmp dword [style], 2
    jne .normal
    mov esi, [fluffy_faces+eax*4]
.normal:
    call emit_z
    mov eax, [outfit]
    mov esi, [outfit_arts+eax*4]
    call emit_z
    PRINT feet
    ret

calculate_total:
    mov eax, [style]
    mov eax, [style_prices+eax*4]
    mov ebx, [face]
    add eax, [face_prices+ebx*4]
    mov ebx, [outfit]
    add eax, [outfit_prices+ebx*4]
    mov ebx, [acc]
    add eax, [acc_prices+ebx*4]
    mov [total], eax
    ret

show_order:
    call calculate_total
    PRINT bill_header
    PRINT customer_label
    PRINT customer
    PRINT nl
    PRINT bear_label
    PRINT bear
    PRINT nl
    call render_bear
    PRINT style_label
    mov eax, [style]
    mov esi, [style_names+eax*4]
    call emit_z
    mov eax, [style]
    mov eax, [style_prices+eax*4]
    call show_price
    PRINT face_label
    mov eax, [face]
    mov esi, [face_names+eax*4]
    call emit_z
    mov eax, [face]
    mov eax, [face_prices+eax*4]
    call show_price
    PRINT outfit_label
    mov eax, [outfit]
    mov esi, [outfit_names+eax*4]
    call emit_z
    mov eax, [outfit]
    mov eax, [outfit_prices+eax*4]
    call show_price
    PRINT acc_label
    mov eax, [acc]
    mov esi, [acc_names+eax*4]
    call emit_z
    mov eax, [acc]
    mov eax, [acc_prices+eax*4]
    call show_price
    PRINT total_label
    mov eax, [total]
    call emit_uint
    PRINT nl
    cmp dword [paid], 0
    je .unpaid
    PRINT payment_label
    mov eax, [payment]
    call emit_uint
    PRINT nl
    PRINT change_label
    mov eax, [change]
    call emit_uint
    PRINT nl
    PRINT paid_label
    ret
.unpaid:
    PRINT unpaid_label
    ret
show_price:
    PRINT price_sep
    call emit_uint
    PRINT nl
    ret

checkout:
    call show_order
    PRINT confirm
    mov ebx, 1
    mov edx, 2
    call get_range
    cmp eax, 2
    je .done
.cash:
    PRINT pay_prompt
    mov ebx, 0
    mov edx, 999999
    call get_range
    cmp eax, [total]
    jb .short
    mov [payment], eax
    sub eax, [total]
    mov [change], eax

    mov dword [paid], 1
    mov dword [capture], 1
    mov dword [receipt_len], 0
    mov dword [io_error], 0
    call show_order
    PRINT footer
    mov dword [capture], 0
    cmp dword [io_error], 0
    jne .failed
    call save_receipt
    jc .failed
    PRINT saved
    call show_order
.done:
    ret
.short:
    PRINT short_cash
    jmp .cash
.failed:
    mov dword [paid], 0
    PRINT file_error
    ret

save_receipt:
    mov eax, 5
    mov ebx, filename
    mov ecx, 577
    mov edx, 384
    int 0x80
    test eax, eax
    js .fail
    mov [file_fd], eax
    mov ebx, eax
    mov ecx, receipt
    mov edx, [receipt_len]
    call write_all
    pushfd
    mov eax, 6
    mov ebx, [file_fd]
    int 0x80
    pop edx
    test edx, 1
    jnz .fail
    test eax, eax
    js .fail
    clc
    ret
.fail:
    stc
    ret

read_receipt:
    mov eax, 5
    mov ebx, filename
    xor ecx, ecx
    xor edx, edx
    int 0x80
    test eax, eax
    js .fail
    mov [file_fd], eax
    PRINT receipt_header
.next:
    mov eax, 3
    mov ebx, [file_fd]
    mov ecx, read_buffer
    mov edx, 1024
    int 0x80
    cmp eax, -4
    je .next
    test eax, eax
    js .close_fail
    jz .close
    mov edx, eax
    mov ebx, 1
    mov ecx, read_buffer
    call write_all
    jc .close_fail
    jmp .next
.close:
    mov eax, 6
    mov ebx, [file_fd]
    int 0x80
    test eax, eax
    js .fail
    ret
.close_fail:
    mov eax, 6
    mov ebx, [file_fd]
    int 0x80
.fail:
    PRINT read_error
    ret

read_line:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    xor edi, edi
    xor esi, esi
.next:
    mov eax, 3
    xor ebx, ebx
    mov ecx, one_byte
    mov edx, 1
    int 0x80
    cmp eax, -4
    je .next
    test eax, eax
    js .fatal
    jz .eof
    mov al, [one_byte]
    cmp al, 10
    je .finish
    cmp al, 13
    je .next
    test al, al
    jz .overflow
    cmp edi, 127
    jae .overflow
    mov [line+edi], al
    inc edi
    jmp .next
.overflow:
    mov esi, 1
    jmp .next
.eof:
    test edi, edi
    jnz .finish
    EXIT 0
.finish:
    mov byte [line+edi], 0
    mov eax, edi
    test esi, esi
    jnz .bad
    clc
    jmp .return
.bad:
    stc
.return:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
.fatal:
    EXIT 1

get_range:
    push esi
    push edi
.retry:
    call read_line
    jc .invalid
    test eax, eax
    jz .invalid
    cmp eax, 6
    ja .invalid
    mov ecx, eax
    mov esi, line
    xor eax, eax
.parse:
    movzx edi, byte [esi]
    sub edi, '0'
    cmp edi, 9
    ja .invalid
    imul eax, eax, 10
    add eax, edi
    inc esi
    loop .parse
    cmp eax, ebx
    jb .invalid
    cmp eax, edx
    ja .invalid
    pop edi
    pop esi
    ret
.invalid:
    PRINT invalid
    jmp .retry

get_name:
.retry:
    call read_line
    jc .invalid
    test eax, eax
    jz .invalid
    cmp eax, 30
    ja .invalid
    mov ecx, eax
    xor edx, edx
    mov esi, line
.check:
    mov al, [esi]
    cmp al, 32
    jb .invalid
    cmp al, 126
    ja .invalid
    cmp al, 32
    je .space
    mov edx, 1
.space:
    inc esi
    loop .check
    test edx, edx
    jz .invalid
    push edi
    mov esi, line
.copy:
    lodsb
    stosb
    test al, al
    jnz .copy
    pop edi
    ret
.invalid:
    PRINT invalid
    jmp .retry

emit_z:
    pushad
    mov ecx, esi
    xor edx, edx
.length:
    cmp byte [ecx+edx], 0
    je .ready
    inc edx
    jmp .length
.ready:
    cmp dword [capture], 0
    jne .capture
    mov ebx, 1
    call write_all
    jmp .done
.capture:
    mov eax, [receipt_len]
    mov ebx, eax
    add ebx, edx
    cmp ebx, 4096
    ja .full
    mov edi, receipt
    add edi, eax
    mov ecx, edx
    rep movsb
    mov [receipt_len], ebx
    jmp .done
.full:
    mov dword [io_error], 1
.done:
    popad
    ret

emit_uint:
    pushad
    mov edi, number_buffer+11
    mov byte [edi], 0
    mov ebx, 10
.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz .convert
    mov esi, edi
    call emit_z
    popad
    ret

write_all:
    pushad
.next:
    test edx, edx
    jz .ok
    mov eax, 4
    int 0x80
    cmp eax, -4
    je .next
    test eax, eax
    jle .bad
    add ecx, eax
    sub edx, eax
    jmp .next
.ok:
    popad
    clc
    ret
.bad:
    popad
    stc
    ret
; Expand a Linux write system call wherever this macro is used.
%macro print_text 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    number dd 5
    heading db 'Factorial of '
    heading_len equ $ - heading
    equals db ' = '
    equals_len equ $ - equals
    newline db 10
    allocated_msg db 'Memory allocated: 4096 bytes.', 10
    allocated_len equ $ - allocated_msg
    file_msg db 'File created and written: result.txt', 10
    file_msg_len equ $ - file_msg
    freed_msg db 'Memory deallocated successfully.', 10
    freed_len equ $ - freed_msg
    error_msg db 'Error: an operation failed.', 10
    error_len equ $ - error_msg
    filename db 'result.txt', 0
    file_text db 'This file demonstrates file handling in Assembly.', 10
    file_text_len equ $ - file_text
    file_descriptor dd -1
    memory_address dd 0

section .bss
    answer resd 1
    digits resb 10

section .text
    global _start

_start:
    ; Unsigned 32-bit factorial is supported for 0 through 12.
    cmp dword [number], 12
    ja error
    mov eax, [number]
    call factorial
    mov [answer], eax

    ; Print the original number and its factorial in decimal.
    print_text heading, heading_len
    mov eax, [number]
    call print_number
    print_text equals, equals_len
    mov eax, [answer]
    call print_number
    print_text newline, 1

    ; mmap2: reserve a readable/writable private anonymous page.
    mov eax, 192
    xor ebx, ebx                 ; Let Linux choose the address.
    mov ecx, 4096               ; Allocation size in bytes.
    mov edx, 3                  ; PROT_READ | PROT_WRITE.
    mov esi, 34                 ; MAP_PRIVATE | MAP_ANONYMOUS.
    mov edi, -1                 ; No backing file.
    xor ebp, ebp                ; Page offset is zero.
    int 0x80
    cmp eax, -4095              ; Linux syscall error range.
    jae error
    mov [memory_address], eax
    print_text allocated_msg, allocated_len

    ; Use the allocated page as the buffer for the file contents.
    cld
    mov esi, file_text
    mov edi, [memory_address]
    mov ecx, file_text_len
    rep movsb

    ; open: create result.txt or truncate its existing contents.
    mov eax, 5
    mov ebx, filename
    mov ecx, 577                ; O_WRONLY | O_CREAT | O_TRUNC.
    mov edx, 0o644              ; Permissions, subject to umask.
    int 0x80
    test eax, eax
    js error
    mov [file_descriptor], eax

    ; write: advance through the buffer if a short write occurs.
    mov ecx, [memory_address]
    mov edx, file_text_len
.write_loop:
    mov eax, 4
    mov ebx, [file_descriptor]
    int 0x80
    test eax, eax
    jle error
    add ecx, eax
    sub edx, eax
    jnz .write_loop

    ; close: release the file descriptor.
    mov eax, 6
    mov ebx, [file_descriptor]
    int 0x80
    mov dword [file_descriptor], -1
    test eax, eax
    js error
    print_text file_msg, file_msg_len

    ; munmap: return the allocated page to the operating system.
    mov eax, 91
    mov ebx, [memory_address]
    mov ecx, 4096
    int 0x80
    test eax, eax
    js error
    mov dword [memory_address], 0
    print_text freed_msg, freed_len

    mov eax, 1                  ; Exit successfully.
    xor ebx, ebx
    int 0x80

; Input: EAX = n. Output: EAX = n!.
factorial:
    cmp eax, 1
    jbe .base_case
    push eax                    ; Preserve n on the stack.
    dec eax
    call factorial              ; Compute (n - 1)! recursively.
    pop ebx                     ; Recover this call's original n.
    mul ebx                     ; EDX:EAX = (n - 1)! * n.
    ret
.base_case:
    mov eax, 1                  ; Both 0! and 1! equal 1.
    ret

; Convert unsigned EAX to decimal and print it, including zero.
print_number:
    mov edi, digits + 10
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
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

error:
    ; Release any resources acquired before the error.
    cmp dword [file_descriptor], -1
    je .check_memory
    mov eax, 6
    mov ebx, [file_descriptor]
    int 0x80
.check_memory:
    cmp dword [memory_address], 0
    je .report
    mov eax, 91
    mov ebx, [memory_address]
    mov ecx, 4096
    int 0x80
.report:
    print_text error_msg, error_len
    mov eax, 1
    mov ebx, 1                  ; Nonzero exit status means failure.
    int 0x80
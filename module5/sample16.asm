section .data
    prompt db "Enter text to save: "
    prompt_len equ $-prompt
    filename db "user_output.txt", 0
 
section .bss
    input_buffer resb 256       ; Reserve 256 bytes in memory for user input
 
section .text
    global _start
 
_start:
    ; 1. Print the prompt to the screen
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80
 
    ; 2. Read user input from keyboard (sys_read)
    mov eax, 3                  ; sys_read
    mov ebx, 0                  ; stdin (file descriptor 0)
    mov ecx, input_buffer       ; Buffer to store typed characters
    mov edx, 256                ; Maximum bytes to read
    int 0x80
    test eax, eax
    js error                    ; Jump if read failed (negative return value)
    mov esi, eax                ; Save the actual number of bytes read into 'esi'
 
    ; 3. Display the user input back to the console (sys_write)
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, input_buffer       ; Pointer to our input buffer
    mov edx, esi                ; Number of bytes read
    int 0x80
 
    ; 4. Create the file (sys_creat)
    mov eax, 8                  ; sys_creat
    mov ebx, filename           ; Pointer to "user_output.txt"
    mov ecx, 0644o              ; File permissions (rw-r--r--)
    int 0x80
 
    test eax, eax
    js error
    mov edi, eax                ; Save file descriptor into 'edi'
 
    ; 5. Write the user input buffer into the file (sys_write)
    mov eax, 4                  ; sys_write
    mov ebx, edi                ; File descriptor from sys_creat
    mov ecx, input_buffer       ; Pointer to input buffer
    mov edx, esi                ; Number of bytes read
    int 0x80
 
    ; 6. Close the file (sys_close)
    mov eax, 6                  ; sys_close
    mov ebx, edi                ; File descriptor
    int 0x80
 
    ; 7. Exit successfully
    xor ebx, ebx
    jmp exit
 
error:
    mov ebx, 1                  ; Error exit code
 
exit:
    mov eax, 1                  ; sys_exit
    int 0x80
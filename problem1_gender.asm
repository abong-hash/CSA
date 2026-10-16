section .data
    askName db "What is your name? ", 0
    askNameLen equ $-askName

    askAge db "How old are you? ", 0
    askAgeLen equ $-askAge

    askGender db "What is your gender? ", 0
    askGenderLen equ $-askGender

    hello db "Hello ", 0
    helloLen equ $-hello

    ageMsg db "You are ", 0
    ageMsgLen equ $-ageMsg

    yearsOld db " years old", 10
    yearsOldLen equ $-yearsOld

    msgM db "Hello", 10
    msgMLen equ $-msgM

    msgF db "World", 10
    msgFLen equ $-msgF

    invalid db "INVALID", 10
    invalidLen equ $-invalid

section .bss
    name resb 100
    age resb 20
    gender resb 2
    nameLen resd 1
    ageLen resd 1

section .text
    global _start

_start:

    ;name
    mov eax, 4
    mov ebx, 1
    mov ecx, askName
    mov edx, askNameLen
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 100
    int 80h
    dec eax
    mov [nameLen], eax

    ;age
    mov eax, 4
    mov ebx, 1
    mov ecx, askAge
    mov edx, askAgeLen
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, age
    mov edx, 20
    int 80h
    dec eax
    mov [ageLen], eax

    ;gender
    mov eax, 4
    mov ebx, 1
    mov ecx, askGender
    mov edx, askGenderLen
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, gender
    mov edx, 2
    int 80h

    ;Hello name
    mov eax, 4
    mov ebx, 1
    mov ecx, hello
    mov edx, 6
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, [nameLen]
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, yearsOld
    mov edx, 1
    int 80h

    ;age line
    mov eax, 4
    mov ebx, 1
    mov ecx, ageMsg
    mov edx, 8
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, age
    mov edx, [ageLen]
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, yearsOld
    mov edx, [yearsOldLen]
    int 80h

    mov al,[gender]

    cmp al, 'M'
    je male
    cmp al, 'm'
    je male
    cmp al, 'F'
    je female

    jmp invalidGender

male:
    mov eax, 4
    mov ebx, 1
    mov ecx, msgM
    mov edx, msgMLen
    int 80h
    jmp done

female:
    mov eax, 4
    mov ebx, 1
    mov ecx, msgF
    mov edx, msgFLen
    int 80h
    jmp done

invalidGender:
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid
    mov edx, invalidLen
    int 80h

done:
    mov eax, 1
    xor ebx, ebx
    int 80h

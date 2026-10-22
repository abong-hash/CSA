%macro say 1
    mov ecx, %1
    call print_string
%endmacro

section .data

welcome db 10, "=======================================", 10
        db "       THE MYSTIC ZODIAC ORACLE", 10
        db "=======================================", 10
        db "             *       *", 10
        db "          *     /\      *", 10
        db "               /  \", 10
        db "         *    /____\    *", 10
        db "               |  |", 10
        db "           *   |__|   *", 10
        db "       DISCOVER YOUR DESTINY!", 10
        db "=======================================", 10
        db "Fictional predictions for entertainment only.", 10, 0

name_prompt db "Enter your name (1-63 characters): ", 0
month_prompt db "Enter birth month (1-12): ", 0
day_prompt db "Enter birth day (1-31): ", 0

bad_name db "Invalid name: enter 1-63 characters.", 10, 0
bad_month db "Invalid month. Enter a whole number from 1 to 12.", 10, 0
bad_day db "Invalid date. Use a real day for that month (February: 1-28).", 10, 0

hello db 10, "Welcome, ", 0
hello_end db "!", 10, 0

menu db 10, "----------- HOROSCOPE MENU -----------", 10
     db "[1] Love and Relationships", 10
     db "[2] Career and Studies", 10
     db "[3] Health and Wellness", 10
     db "[4] Lucky Number and Color", 10
     db "[5] View Zodiac Information", 10
     db "[6] Exit", 10
     db "Enter your choice: ", 0

bad_choice db "Invalid selection. Choose 1-6.", 10, 0
return_prompt db 10, "Return to menu? (Y/N): ", 0
bad_return db "Invalid response. Enter only Y or N.", 10, 0
goodbye db "Thank you for visiting the Oracle. Goodbye!", 10, 0

info_heading db 10, "========== YOUR ZODIAC SIGN ==========", 10, 0
love_heading db 10, "LOVE AND RELATIONSHIPS HOROSCOPE", 10, 0
career_heading db 10, "CAREER AND STUDIES HOROSCOPE", 10, 0
health_heading db 10, "HEALTH AND WELLNESS HOROSCOPE", 10, 0
lucky_heading db 10, "LUCKY NUMBER AND COLOR", 10, 0

love_text db ", listening with kindness may strengthen a friendship today.", 10
          db "Make time for an honest conversation.", 10, 0

career_text db ", your creativity may help solve a difficult problem today.", 10
            db "Stay focused, ask questions, and trust your preparation!", 10, 0

health_text db ", a calm break may brighten your day.", 10
            db "Enjoy a restful moment and balance study time with relaxation.", 10
            db "This fictional horoscope is not medical advice.", 10, 0

newline db 10, 0

; Actual month lengths, with February limited to 28 days.
month_lengths dd 31,28,31,30,31,30,31,31,30,31,30,31

; First day of the next zodiac sign in each month.
cutoff_days dd 20,19,21,20,21,21,23,23,23,23,22,22

; Zodiac names, starting with Capricorn at index 0.
cap_name db "Capricorn", 0
aqu_name db "Aquarius", 0
pis_name db "Pisces", 0
ari_name db "Aries", 0
tau_name db "Taurus", 0
gem_name db "Gemini", 0
can_name db "Cancer", 0
leo_name db "Leo", 0
vir_name db "Virgo", 0
lib_name db "Libra", 0
sco_name db "Scorpio", 0
sag_name db "Sagittarius", 0

sign_names dd cap_name,aqu_name,pis_name,ari_name,tau_name,gem_name
           dd can_name,leo_name,vir_name,lib_name,sco_name,sag_name

; ascii art
cap_info db "     /\  /\",10
         db "    ( oo )",10
         db "     /__\  ~",10
         db "Zodiac Sign: CAPRICORN",10
         db "Dates: Dec 22-Jan 19",10
         db "Element: Earth",10
         db "Symbol: Sea-Goat",10
         db "Personality: Disciplined, patient, responsible.",10,0

aqu_info db "    ~~~  ~~~",10
         db "     ~~~  ~~~",10
         db "    WATER BEARER",10
         db "Zodiac Sign: AQUARIUS",10
         db "Dates: Jan 20-Feb 18",10
         db "Element: Air",10
         db "Symbol: Water Bearer",10
         db "Personality: Independent, inventive, friendly.",10,0

pis_info db "    ><(((>  <)))><",10
         db "        ~~~~~",10
         db "Zodiac Sign: PISCES",10
         db "Dates: Feb 19-Mar 20",10
         db "Element: Water",10
         db "Symbol: Fish",10
         db "Personality: Imaginative, gentle, compassionate.",10,0

ari_info db "     __     __",10
         db "    /  \___/  \",10
         db "     ( o o )",10
         db "      \___/",10
         db "Zodiac Sign: ARIES",10
         db "Dates: Mar 21-Apr 19",10
         db "Element: Fire",10
         db "Symbol: Ram",10
         db "Personality: Bold, energetic, adventurous.",10,0

tau_info db "    \       /",10
         db "     \_____/",10
         db "     ( o o )",10
         db "      \___/",10
         db "Zodiac Sign: TAURUS",10
         db "Dates: Apr 20-May 20",10
         db "Element: Earth",10
         db "Symbol: Bull",10
         db "Personality: Reliable, patient, determined.",10,0

gem_info db "      O   O",10
         db "     /|\ /|\",10
         db "     / \ / \",10
         db "Zodiac Sign: GEMINI",10
         db "Dates: May 21-Jun 20",10
         db "Element: Air",10
         db "Symbol: Twins",10
         db "Personality: Curious, adaptable, expressive.",10,0

can_info db "     \ /   \ /",10
         db "      (o___o)",10
         db "     /|_____|\ ",10
         db "Zodiac Sign: CANCER",10
         db "Dates: Jun 21-Jul 22",10
         db "Element: Water",10
         db "Symbol: Crab",10
         db "Personality: Caring, loyal, protective.",10,0

leo_info db "       /\_/\",10
         db "      ( o.o )",10
         db "       > ^ <",10
         db "Zodiac Sign: LEO",10
         db "Dates: Jul 23-Aug 22",10
         db "Element: Fire",10
         db "Symbol: Lion",10
         db "Personality: Confident, creative, courageous.",10,0

vir_info db "        O",10
         db "       /|\  *",10
         db "       / \",10
         db "Zodiac Sign: VIRGO",10
         db "Dates: Aug 23-Sep 22",10
         db "Element: Earth",10
         db "Symbol: Maiden",10
         db "Personality: Practical, careful, analytical.",10,0

lib_info db "        |",10
         db "     ___|___",10
         db "    /   |   \",10
         db "   (_)  |  (_)",10
         db "Zodiac Sign: LIBRA",10
         db "Dates: Sep 23-Oct 22",10
         db "Element: Air",10
         db "Symbol: Scales",10
         db "Personality: Fair, diplomatic, cooperative.",10,0

sco_info db "     _     _",10
         db "    ( \___/ )",10
         db "     /o___o\___",10
         db "              \_>",10
         db "Zodiac Sign: SCORPIO",10
         db "Dates: Oct 23-Nov 21",10
         db "Element: Water",10
         db "Symbol: Scorpion",10
         db "Personality: Passionate, brave, resourceful.",10,0

sag_info db "          /|",10
         db "      ---/->",10
         db "         \|",10
         db "Zodiac Sign: SAGITTARIUS",10
         db "Dates: Nov 22-Dec 21",10
         db "Element: Fire",10
         db "Symbol: Archer",10
         db "Personality: Optimistic, honest, adventurous.",10,0

zodiac_details dd cap_info,aqu_info,pis_info,ari_info,tau_info,gem_info
               dd can_info,leo_info,vir_info,lib_info,sco_info,sag_info

; Fictional lucky values for each sign.
cap_lucky db "Lucky Number: 8",10,"Lucky Color: Brown",10,0
aqu_lucky db "Lucky Number: 4",10,"Lucky Color: Turquoise",10,0
pis_lucky db "Lucky Number: 7",10,"Lucky Color: Sea Green",10,0
ari_lucky db "Lucky Number: 9",10,"Lucky Color: Red",10,0
tau_lucky db "Lucky Number: 6",10,"Lucky Color: Green",10,0
gem_lucky db "Lucky Number: 5",10,"Lucky Color: Yellow",10,0
can_lucky db "Lucky Number: 2",10,"Lucky Color: Silver",10,0
leo_lucky db "Lucky Number: 1",10,"Lucky Color: Gold",10,0
vir_lucky db "Lucky Number: 5",10,"Lucky Color: Navy Blue",10,0
lib_lucky db "Lucky Number: 6",10,"Lucky Color: Pink",10,0
sco_lucky db "Lucky Number: 9",10,"Lucky Color: Maroon",10,0
sag_lucky db "Lucky Number: 3",10,"Lucky Color: Purple",10,0

lucky_texts dd cap_lucky,aqu_lucky,pis_lucky,ari_lucky,tau_lucky,gem_lucky
            dd can_lucky,leo_lucky,vir_lucky,lib_lucky,sco_lucky,sag_lucky

section .bss

user_name resb 64
birth_month resd 1
birth_day resd 1
sign_index resd 1

input_buffer resb 128
input_byte resb 1
number_buffer resb 12

section .text
    global _start

_start:
    call display_welcome
    call get_user_info
    call determine_zodiac
    call display_zodiac_art

.menu_loop:
    call display_menu
    call read_number
    jc .invalid

    cmp eax, 6
    je .quit

    cmp eax, 1
    jl .invalid

    cmp eax, 5
    jg .invalid

    call show_horoscope
    call ask_return
    jmp .menu_loop

.invalid:
    say bad_choice
    jmp .menu_loop

.quit:
    say goodbye
    call exit_program

; Show the welcome screen.
display_welcome:
    say welcome
    ret

; Collect the user's name and valid birth date.
get_user_info:
.name:
    say name_prompt
    mov ecx, user_name
    mov edx, 64
    call read_line
    jc .name_error

    cmp eax, 0
    je .name_error
    jmp .month

.name_error:
    say bad_name
    jmp .name

.month:
    say month_prompt
    call read_number
    jc .month_error

    cmp eax, 1
    jl .month_error

    cmp eax, 12
    jg .month_error

    mov [birth_month], eax

.day:
    say day_prompt
    call read_number
    jc .day_error

    mov [birth_day], eax
    call validate_birthdate

    cmp eax, 1
    jne .day_error

    say hello
    say user_name
    say hello_end
    ret

.month_error:
    say bad_month
    jmp .month

.day_error:
    say bad_day
    jmp .day

; February 29 is rejected because no birth year is collected.
validate_birthdate:
    push ebx

    mov eax, [birth_month]
    cmp eax, 1
    jl .invalid

    cmp eax, 12
    jg .invalid

    dec eax
    mov ebx, [birth_day]

    cmp ebx, 0
    jle .invalid

    cmp ebx, [month_lengths + eax*4]
    jg .invalid

    mov eax, 1
    pop ebx
    ret

.invalid:
    xor eax, eax
    pop ebx
    ret

; Capricorn = 0, Aquarius = 1, ..., Sagittarius = 11.
determine_zodiac:
    pushad

    mov ebx, [birth_month]
    dec ebx
    mov eax, [birth_day]

    cmp eax, [cutoff_days + ebx*4]
    jl .store
    jge .next_sign

.next_sign:
    inc ebx

    cmp ebx, 12
    jne .store

    xor ebx, ebx

.store:
    mov [sign_index], ebx
    popad
    ret

; Display the selected sign's art and information.
display_zodiac_art:
    pushad

    say info_heading
    mov ebx, [sign_index]
    mov ecx, [zodiac_details + ebx*4]
    call print_string

    popad
    ret

display_menu:
    say menu
    ret

; validated menu choice from 1 to 5.
show_horoscope:
    pushad

    cmp eax, 1
    je .love

    cmp eax, 2
    je .career

    cmp eax, 3
    je .health

    cmp eax, 4
    je .lucky

    cmp eax, 5
    je .info

    jmp .done

.love:
    say love_heading
    call display_sign_name
    say love_text
    jmp .done

.career:
    say career_heading
    call display_sign_name
    say career_text
    jmp .done

.health:
    say health_heading
    call display_sign_name
    say health_text
    jmp .done

.lucky:
    say lucky_heading
    mov ebx, [sign_index]
    mov ecx, [lucky_texts + ebx*4]
    call print_string
    jmp .done

.info:
    call display_zodiac_art

.done:
    popad
    ret

display_sign_name:
    pushad

    mov ebx, [sign_index]
    mov ecx, [sign_names + ebx*4]
    call print_string

    popad
    ret

; Accept only a single Y/y or N/n.
ask_return:
.again:
    say return_prompt
    mov ecx, input_buffer
    mov edx, 128
    call read_line
    jc .invalid

    cmp eax, 1
    jne .invalid

    mov al, [input_buffer]

    cmp al, 'Y'
    je .yes

    cmp al, 'y'
    je .yes

    cmp al, 'N'
    je .no

    cmp al, 'n'
    je .no

.invalid:
    say bad_return
    jmp .again

.yes:
    ret

.no:
    say goodbye
    call exit_program

; Print a zero-terminated string addressed by ECX.
; All general registers are preserved.
print_string:
    pushad
    xor edx, edx

.length:
    cmp byte [ecx + edx], 0
    je .write

    inc edx
    jmp .length

.write:
    test edx, edx
    jz .done

    mov eax, 4
    mov ebx, 1
    int 0x80

    cmp eax, 0
    jle .done

    add ecx, eax
    sub edx, eax
    jmp .write

.done:
    popad
    ret

read_line:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    mov esi, ecx
    mov ebp, edx
    dec ebp

    xor ebx, ebx
    xor edi, edi

.next:
    push ebx

    mov eax, 3
    xor ebx, ebx
    mov ecx, input_byte
    mov edx, 1
    int 0x80

    pop ebx

    cmp eax, 0
    jle exit_program

    mov al, [input_byte]

    cmp al, 10
    je .finish

    cmp al, 13
    je .next

    cmp ebx, ebp
    jae .overflow

    mov [esi + ebx], al
    inc ebx
    jmp .next

.overflow:
    mov edi, 1
    jmp .next

.finish:
    mov byte [esi + ebx], 0
    mov eax, ebx

    test edi, edi
    jnz .bad

    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    clc
    ret

.bad:
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    stc
    ret

; Read decimal digits from 0 to 9999.
read_number:
    push ebx
    push ecx
    push edx
    push esi

    mov ecx, input_buffer
    mov edx, 128
    call read_line
    jc .invalid

    test eax, eax
    jz .invalid

    mov esi, input_buffer
    xor eax, eax

.convert:
    movzx ebx, byte [esi]

    test ebx, ebx
    jz .valid

    cmp ebx, '0'
    jb .invalid

    cmp ebx, '9'
    ja .invalid

    imul eax, eax, 10
    sub ebx, '0'
    add eax, ebx

    cmp eax, 9999
    ja .invalid

    inc esi
    jmp .convert

.valid:
    pop esi
    pop edx
    pop ecx
    pop ebx
    clc
    ret

.invalid:
    pop esi
    pop edx
    pop ecx
    pop ebx
    stc
    ret

; General numeric output helper
print_uint:
    pushad

    mov edi, number_buffer + 11
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

    mov ecx, edi
    call print_string

    popad
    ret

; Terminate the process successfully
exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
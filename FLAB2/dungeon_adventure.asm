section .data

welcome db 10, '======================================', 10
        db ' DUNGEON ADVENTURE AND SURVIVAL GAME', 10
        db '======================================', 10
        db '              |>>>>', 10
        db '              |', 10
        db '          _  _|_  _', 10
        db '         |;|_|;|_|;|', 10
        db '         \.    .  /', 10
        db '          \:  .  /', 10
        db '           ||:   |', 10
        db '           ||:.  |', 10
        db '           ||:  .|', 10
        db '       ENTER IF YOU DARE!', 10
        db '======================================', 10, 0

name_prompt db 'Enter your hero name: ', 0

class_prompt db 10, 'Choose your character:', 10
             db '[1] Warrior', 10
             db '[2] Mage', 10
             db '[3] Archer', 10
             db 'Enter choice: ', 0

invalid_class db 'Invalid class. Choose 1, 2, or 3.', 10, 0

welcome_hero db 10, 'Welcome, ', 0
warrior db 'Warrior ', 0
mage db 'Mage ', 0
archer db 'Archer ', 0

main_menu db 10, '[1] Explore Dungeon', 10
          db '[2] View Character Status', 10
          db '[3] Use Health Potion', 10
          db '[4] View Inventory', 10
          db '[5] Exit Game', 10
          db 'Enter choice: ', 0

invalid_menu db 'Invalid menu option.', 10, 0

status_title db 10, '--- CHARACTER STATUS ---', 10, 'Name: ', 0
class_label db 10, 'Class: ', 0
health_label db 10, 'Health: ', 0
attack_label db 10, 'Attack: ', 0
potions_label db 10, 'Potions: ', 0
room_label db 10, 'Current room: ', 0

inventory_title db 10, '--- INVENTORY ---', 10, 'Gold: ', 0
potion_word db 'Potions: ', 0

room1 db 10, '--- ROOM 1: GOBLIN CHAMBER ---', 10
      db '     ,      ,', 10
      db '    /(.-""-.)\', 10
      db ' |\  \/      \/  /|', 10
      db ' | \ / =.  .= \ / |', 10
      db '  \  \   ^    /  /', 10
      db "   \  '-----'  /", 10
      db 'A GOBLIN APPEARS!', 10, 0

room2 db 10, '--- ROOM 2: TREASURE CHAMBER ---', 10
      db ' __________', 10
      db '/_________/|', 10
      db '|  _____  | |', 10
      db '| |  ?  | | |', 10
      db '| |_____| | /', 10
      db '|_________|/', 10
      db '[1] Open Chest  [2] Leave Chest', 10
      db 'Enter choice: ', 0

room3 db 10, "--- ROOM 3: DRAGON'S LAIR ---", 10
      db ' / \  //\', 10
      db ' |\___/|      \', 10
      db ' /0  0  \      |', 10
      db '/   ^    \    /', 10
      db '/  \___/   \  /', 10
      db '\___________\/', 10
      db 'THE DRAGON AWAKENS!', 10, 0

combat_menu db 10, '[1] Attack  [2] Defend', 10
            db '[3] Use Potion  [4] Run', 10
            db 'Enter choice: ', 0

enemy_health_label db 'Enemy health: ', 0
defeated db 'Enemy defeated!', 10, 0
ran_away db 'You escaped the encounter.', 10, 0

chest_open db 'You opened the chest and gained 50 gold.', 10, 0
chest_left db 'You left the chest untouched.', 10, 0
bad_chest db 'Invalid choice. Select 1 or 2.', 10, 0

defend_msg db 'You defend. The next attack is reduced by 5.', 10, 0
attack_msg db 'You attack!', 10, 0
enemy_attack_msg db 'The enemy attacks for ', 0
damage_end db ' damage.', 10, 0

potion_ok db 'You used a potion and restored up to 20 health.', 10, 0
potion_full db 'Your health is already full. One potion was consumed.', 10, 0
no_potions db 'You have no potions left.', 10, 0

game_over db 10, 'GAME OVER', 10
          db 'Your hero has fallen.', 10
          db 'The dungeon remains undefeated.', 10
          db 'BETTER LUCK NEXT TIME!', 10, 0

victory db 10, 'VICTORY!', 10
        db 'CONGRATULATIONS, ', 0

victory2 db '!', 10
         db 'You defeated the dragon and escaped!', 10
         db 'Final Gold: ', 0

remaining db 'Remaining Health: ', 0
hero_msg db 'YOU ARE A HERO!', 10, 0
newline db 10, 0

section .bss

name_buf resb 64
input_buf resb 64
num_buf resb 16
class_name resb 16

class_choice resd 1
health resd 1
max_health resd 1
attack resd 1
potions resd 1
gold resd 1
room resd 1
enemy_health resd 1
enemy_damage resd 1
defend_flag resd 1

section .text
    global _start
    
_start:
    call display_welcome
    call get_player_info
    call initialize_character
    call display_hero_welcome

main_loop:
    cmp dword [health], 0
    jle game_lost

    call display_main_menu
    call read_number

    cmp eax, 1
    je do_explore
    cmp eax, 2
    je do_status
    cmp eax, 3
    je do_potion
    cmp eax, 4
    je do_inventory
    cmp eax, 5
    je exit_program

    mov esi, invalid_menu
    call print_cstr
    jmp main_loop

do_explore:
    call explore_dungeon
    cmp eax, 2
    je game_won
    jmp main_loop

do_status:
    call display_status
    jmp main_loop

do_potion:
    call use_potion
    jmp main_loop

do_inventory:
    call display_inventory
    jmp main_loop


display_welcome:
    mov esi, welcome
    jmp print_cstr


get_player_info:
    mov esi, name_prompt
    call print_cstr

    mov edi, name_buf
    call read_line

get_class:
    mov esi, class_prompt
    call print_cstr
    call read_number

    cmp eax, 1
    jb bad_class

    cmp eax, 3
    ja bad_class

    mov [class_choice], eax
    ret

bad_class:
    mov esi, invalid_class
    call print_cstr
    jmp get_class


initialize_character:
    cmp dword [class_choice], 1
    je init_warrior

    cmp dword [class_choice], 2
    je init_mage

    mov dword [max_health], 85
    mov dword [health], 85
    mov dword [attack], 25
    mov dword [potions], 2
    mov esi, archer
    jmp init_common

init_warrior:
    mov dword [max_health], 100
    mov dword [health], 100
    mov dword [attack], 20
    mov dword [potions], 2
    mov esi, warrior
    jmp init_common

init_mage:
    mov dword [max_health], 70
    mov dword [health], 70
    mov dword [attack], 30
    mov dword [potions], 3
    mov esi, mage

init_common:
    mov edi, class_name

copy_class:
    lodsb
    stosb

    cmp al, 0
    jne copy_class

    mov dword [gold], 0
    mov dword [room], 1
    ret


display_hero_welcome:
    mov esi, welcome_hero
    call print_cstr

    mov esi, class_name
    call print_cstr

    mov esi, name_buf
    call print_cstr

    mov esi, newline
    jmp print_cstr


display_main_menu:
    mov esi, main_menu
    jmp print_cstr


explore_dungeon:
    cmp dword [room], 1
    je enter_goblin

    cmp dword [room], 2
    je enter_treasure

    jmp enter_dragon


enter_goblin:
    mov esi, room1
    call print_cstr

    mov dword [enemy_health], 30
    mov dword [enemy_damage], 10

    call battle_enemy

    cmp eax, 1
    jne explore_done

    mov dword [room], 2

    mov esi, room2
    call print_cstr

treasure_loop:
    call read_number

    cmp eax, 1
    je open_treasure

    cmp eax, 2
    je leave_treasure

    mov esi, bad_chest
    call print_cstr

    mov esi, room2
    call print_cstr
    jmp treasure_loop


open_treasure:
    add dword [gold], 50

    mov esi, chest_open
    call print_cstr

    mov dword [room], 3
    mov eax, 1
    ret


leave_treasure:
    mov esi, chest_left
    call print_cstr

    mov dword [room], 3
    mov eax, 1
    ret


enter_treasure:
    mov esi, room2
    call print_cstr
    jmp treasure_loop


enter_dragon:
    mov esi, room3
    call print_cstr

    mov dword [enemy_health], 60
    mov dword [enemy_damage], 15

    call battle_enemy

    cmp eax, 1
    jne explore_done

    mov eax, 2
    ret


explore_done:
    xor eax, eax
    ret


battle_enemy:
combat_loop:
    cmp dword [health], 0
    jle battle_dead

    mov esi, enemy_health_label
    call print_cstr

    mov eax, [enemy_health]
    call print_num

    mov esi, combat_menu
    call print_cstr

    call read_number

    cmp eax, 1
    je combat_attack

    cmp eax, 2
    je combat_defend

    cmp eax, 3
    je combat_potion

    cmp eax, 4
    je combat_run

    mov esi, invalid_menu
    call print_cstr
    jmp combat_loop


combat_attack:
    mov esi, attack_msg
    call print_cstr

    mov eax, [enemy_health]
    sub eax, [attack]
    mov [enemy_health], eax

    cmp eax, 0
    jle enemy_dead

    call enemy_retaliate
    jmp combat_loop


combat_defend:
    mov dword [defend_flag], 1

    mov esi, defend_msg
    call print_cstr

    call enemy_retaliate
    jmp combat_loop


combat_potion:
    call use_potion
    jmp combat_loop


combat_run:
    mov esi, ran_away
    call print_cstr

    xor eax, eax
    ret


enemy_dead:
    mov esi, defeated
    call print_cstr

    mov eax, 1
    ret


battle_dead:
    xor eax, eax
    ret


enemy_retaliate:
    mov eax, [enemy_damage]

    cmp dword [defend_flag], 1
    jne apply_damage

    sub eax, 5

    cmp eax, 0
    jge apply_damage

    xor eax, eax

apply_damage:
    mov dword [defend_flag], 0

    push eax

    mov esi, enemy_attack_msg
    call print_cstr

    pop eax
    call print_num

    push eax

    mov esi, damage_end
    call print_cstr

    pop eax
    sub [health], eax

    cmp dword [health], 0
    jg .done

    mov dword [health], 0

.done:
    ret


use_potion:
    cmp dword [potions], 0
    jle .none

    cmp dword [health], 0
    jle .none

    mov eax, [health]

    cmp eax, [max_health]
    jge .full

    add eax, 20

    cmp eax, [max_health]
    jle .store

    mov eax, [max_health]

.store:
    mov [health], eax
    dec dword [potions]

    mov esi, potion_ok
    jmp print_cstr

.full:
    dec dword [potions]

    mov esi, potion_full
    jmp print_cstr

.none:
    mov esi, no_potions
    jmp print_cstr


display_status:
    mov esi, status_title
    call print_cstr

    mov esi, name_buf
    call print_cstr

    mov esi, class_label
    call print_cstr

    mov esi, class_name
    call print_cstr

    mov esi, health_label
    call print_cstr

    mov eax, [health]
    call print_num

    mov esi, attack_label
    call print_cstr

    mov eax, [attack]
    call print_num

    mov esi, potions_label
    call print_cstr

    mov eax, [potions]
    call print_num

    mov esi, room_label
    call print_cstr

    mov eax, [room]
    jmp print_num


display_inventory:
    mov esi, inventory_title
    call print_cstr

    mov eax, [gold]
    call print_num

    mov esi, potion_word
    call print_cstr

    mov eax, [potions]
    jmp print_num


read_line:
    mov eax, 3
    mov ebx, 0
    mov ecx, edi
    mov edx, 63
    int 0x80

    cmp eax, 0
    jle .empty

    mov edx, eax
    dec edx

    cmp byte [edi + edx], 10
    jne .terminate

    mov byte [edi + edx], 0
    ret

.terminate:
    mov byte [edi + eax], 0
    ret

.empty:
    mov byte [edi], 0
    ret


read_number:
    mov edi, input_buf
    call read_line

    mov esi, input_buf
    xor eax, eax
    xor ebx, ebx

.digits:
    mov bl, [esi]

    cmp bl, '0'
    jb .done

    cmp bl, '9'
    ja .done

    imul eax, 10
    sub bl, '0'
    add eax, ebx

    inc esi
    jmp .digits

.done:
    ret


print_cstr:
    push esi
    xor edx, edx

.len:
    cmp byte [esi + edx], 0
    je .write

    inc edx
    jmp .len

.write:
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 0x80

    pop esi
    ret


print_num:
    push eax

    mov edi, num_buf
    add edi, 15
    mov byte [edi], 0

    mov ebx, 10

    cmp eax, 0
    jne .convert

    dec edi
    mov byte [edi], '0'
    jmp .output

.convert:
    xor edx, edx
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl

    cmp eax, 0
    jne .convert

.output:
    mov esi, edi
    call print_cstr

    mov esi, newline
    call print_cstr

    pop eax
    ret


game_lost:
    mov esi, game_over
    call print_cstr
    jmp exit_program


game_won:
    mov esi, victory
    call print_cstr

    mov esi, name_buf
    call print_cstr

    mov esi, victory2
    call print_cstr

    mov eax, [gold]
    call print_num

    mov esi, remaining
    call print_cstr

    mov eax, [health]
    call print_num

    mov esi, hero_msg
    call print_cstr


exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
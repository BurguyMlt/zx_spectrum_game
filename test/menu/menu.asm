    ; 2 // (c) Морозов Алексей
    ; 3 // Главное меню.
    ; 5 const int KEY_UP = 1;
    ; 6 const int KEY_DOWN = 2;
    ; 7 const int KEY_LEFT = 4;
    ; 8 const int KEY_RIGHT = 8;
    ; 9 const int KEY_FIRE = 16;
    ; 11 const int menuLogoX      = 1;
    ; 12 const int menuLogoY      = 1;
    ; 13 const int menuItemH      = 10;
    ; 14 const int menuItemsY     = 100;
    ; 15 const int menuItemsX     = 80;
    ; 16 const int menuItemsSX    = 72;
    ; 17 const int menuItemsCount = 3;
    ; 18 const int menuItemsM     = menuItemsCount * menuItemH;
    ; 20 uint8_t menuX = 0;
menuX db 0
    ; 21 uint8_t menuX1 = 0;
menuX1 db 0
    ; 23 uint16_t test;
test dw 0
    ; 25 void menuDrawCursor()
menuDrawCursor:
    ; 26 {
    ; 27 drawTextEx(h = ((a = menuX1) += menuItemsY), l = menuItemsSX, de = "@");
    ld   a, (menuX1)
    add  100
    ld   h, a
    ld   l, 72
    ld   de, s0
    call drawTextEx
    ; 28 return;
    ret
    ; 29 }
    ret
    ; 31 void wait()
wait:
    ; 32 {
    ; 33 hl = &frame;
    ld   hl, frame
    ; 34 a ^= a;
    xor  a
    ; 35 do { a |= *hl; } while(flag_z);
l0:
    or   (hl)
    jp   z, l0
    ; 36 *hl = 0;
    ld   (hl), 0
    ; 37 }
    ret
    ; 39 void main()
main:
    ; 40 {
    ; 41 clearScreen(a = 0x45);
    ld   a, 69
    call clearScreen
    ; 42 drawImage(de = [0x5800 + menuLogoX + (menuLogoY << 5)], hl = &image_logo);
    ld   de, 22561
    ld   hl, image_logo
    call drawImage
    ; 43 drawTextEx(hl = [(menuItemsY + menuItemH * 0) * 256 + menuItemsX], de = "Начать новую игру");
    ld   hl, 25680
    ld   de, s1
    call drawTextEx
    ; 44 drawTextEx(hl = [(menuItemsY + menuItemH * 1) * 256 + menuItemsX], de = "Настроить управление");
    ld   hl, 28240
    ld   de, s2
    call drawTextEx
    ; 45 drawTextEx(hl = [(menuItemsY + menuItemH * 2) * 256 + menuItemsX], de = "Ввести пароль");
    ld   hl, 30800
    ld   de, s3
    call drawTextEx
    ; 47 drawTextCenter(h = [192 - 8 - menuItemH * 2], de = "Игра | 2019 Алексей {Alemorf} Морозов");
    ld   h, 164
    ld   de, s4
    call drawTextCenter
    ; 48 drawTextCenter(h = [192 - 8 - menuItemH * 1], de = "Мюзикл | 1998 Антон {Саруман} Круглов,");
    ld   h, 174
    ld   de, s5
    call drawTextCenter
    ; 49 drawTextCenter(h = [192 - 8 - menuItemH * 0], de = "Елена {Мириам} Ханпира");
    ld   h, 184
    ld   de, s6
    call drawTextCenter
    ; 51 menuX = a ^= a;
    xor  a
    ld   (menuX), a
    ; 52 menuX1 = (++a);
    inc  a
    ld   (menuX1), a
    ; 54 menuDrawCursor();
    call menuDrawCursor
    ; 56 while()
l1:
    ; 57 {
    ; 58 wait();
    call wait
    ; 59 menuTick();
    call menuTick
    ; 60 }
    jp   l1
    ; 61 return;
    ret
    ; 62 }
    ret
    ; 64 void menuTick()
menuTick:
    ; 65 {
    ; 66 // Получить нажатую клавишу
    ; 67 hl = &keyTrigger;
    ld   hl, keyTrigger
    ; 68 b = *hl;
    ld   b, (hl)
    ; 69 *hl = 0;
    ld   (hl), 0
    ; 71 // Нажат выстрел
    ; 72 a = menuX;
    ld   a, (menuX)
    ; 73 if (b & KEY_FIRE)
    bit  4, b
    ; 74 {
    jp   z, l3
    ; 75 if (a == [0 * menuItemH]) return exec(hl = "city");
    cp   0
    ld   hl, s7
    jp   z, exec
    ; 76 if (a == [1 * menuItemH]) return intro();
    cp   10
    jp   z, intro
    ; 77 //if (a == [2 * menuItemH]) return loadGame();
    ; 78 //return saveGame();
    ; 79 return;
    ret
    ; 80 }
    ; 82 // Перемещение курсора
    ; 83 if (b & KEY_UP)
l3:
    bit  0, b
    ; 84 {
    jp   z, l4
    ; 85 a -= menuItemH;
    sub  10
    ; 86 if (flag_c) return;
    ret  c
    ; 87 }
    ; 88 else if (b & KEY_DOWN)
    jp   l5
l4:
    bit  1, b
    ; 89 {
    jp   z, l6
    ; 90 a += menuItemH;
    add  10
    ; 91 if (a >= menuItemsM) return;
    cp   30
    ret  nc
    ; 92 }
    ; 93 menuX = a;
l6:
l5:
    ld   (menuX), a
    ; 95 // Плавное перемещение курсора
    ; 96 hl = &menuX1;
    ld   hl, menuX1
    ; 97 b = *hl;
    ld   b, (hl)
    ; 98 if (a == b) return; // Оставит флаг CF при выполнении menuX1 - menuX
    cp   b
    ret  z
    ; 99 b++; // Не изменяет CF
    inc  b
    ; 100 if (flag_c) ----b;
    jp   nc, l7
    dec  b
    dec  b
    ; 102 push(bc);
l7:
    push bc
    ; 103 menuDrawCursor();
    call menuDrawCursor
    ; 104 pop(bc);
    pop  bc
    ; 106 *(hl = &menuX1) = b;
    ld   hl, menuX1
    ld   (hl), b
    ; 108 menuDrawCursor();
    call menuDrawCursor
    ; 110 return;
    ret
    ; 111 }
    ret
    ; strings
s0 db  "@", 0
s7 db  "city", 0
s3 db  "Ввести пароль", 0
s6 db  "Елена {Мириам} Ханпира", 0
s4 db  "Игра | 2019 Алексей {Alemorf} Морозов", 0
s5 db  "Мюзикл | 1998 Антон {Саруман} Круглов,", 0
s2 db  "Настроить управление", 0
s1 db  "Начать новую игру", 0

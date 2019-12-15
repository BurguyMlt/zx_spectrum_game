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
    ; 27 gDrawTextEx(h = ((a = menuX1) += menuItemsY), l = menuItemsSX, de = "@", a = 0x44);
    ld   a, (menuX1)
    add  100
    ld   h, a
    ld   l, 72
    ld   de, s0
    ld   a, 68
    call gDrawTextEx
    ; 28 }
    ret
    ; 30 void wait()
wait:
    ; 31 {
    ; 32 hl = &gFrame;
    ld   hl, gFrame
    ; 33 a ^= a;
    xor  a
    ; 34 do { a |= *hl; } while(flag_z);
l0:
    or   (hl)
    jp   z, l0
l1:
    ; 35 *hl = 0;
    ld   (hl), 0
    ; 36 }
    ret
    ; 38 void main()
main:
    ; 39 {
    ; 40 gClearScreen(a = 0x45);
    ld   a, 69
    call gClearScreen
    ; 41 gDrawImage(de = [0x5800 + menuLogoX + (menuLogoY << 5)], hl = &image_logo);
    ld   de, 22561
    ld   hl, image_logo
    call gDrawImage
    ; 42 gDrawTextEx(a = 0x45, hl = [(menuItemsY + menuItemH * 0) * 256 + menuItemsX], de = "Начать новую игру");
    ld   a, 69
    ld   hl, 25680
    ld   de, s1
    call gDrawTextEx
    ; 43 gDrawTextEx(a = 0x45, hl = [(menuItemsY + menuItemH * 1) * 256 + menuItemsX], de = "Настроить управление");
    ld   a, 69
    ld   hl, 28240
    ld   de, s2
    call gDrawTextEx
    ; 44 gDrawTextEx(a = 0x45, hl = [(menuItemsY + menuItemH * 2) * 256 + menuItemsX], de = "Ввести пароль");
    ld   a, 69
    ld   hl, 30800
    ld   de, s3
    call gDrawTextEx
    ; 46 gDrawTextCenter(a = 0x43, h = [192 - 8 - menuItemH * 2], de = "Игра | 2019 Алексей {Alemorf} Морозов");
    ld   a, 67
    ld   h, 164
    ld   de, s4
    call gDrawTextCenter
    ; 47 gDrawTextCenter(a = 0x43, h = [192 - 8 - menuItemH * 1], de = "Мюзикл | 1998 Антон {Саруман} Круглов,");
    ld   a, 67
    ld   h, 174
    ld   de, s5
    call gDrawTextCenter
    ; 48 gDrawTextCenter(a = 0x43, h = [192 - 8 - menuItemH * 0], de = "Елена {Мириам} Ханпира");
    ld   a, 67
    ld   h, 184
    ld   de, s6
    call gDrawTextCenter
    ; 50 menuX = a ^= a;
    xor  a
    ld   (menuX), a
    ; 51 menuX1 = (++a);
    inc  a
    ld   (menuX1), a
    ; 53 menuDrawCursor();
    call menuDrawCursor
    ; 55 while()
l2:
    ; 56 {
    ; 57 wait();
    call wait
    ; 58 menuTick();
    call menuTick
    ; 59 }
    jp   l2
l3:
    ; 60 return;
    ret
    ; 61 }
    ret
    ; 63 void menuTick()
menuTick:
    ; 64 {
    ; 65 // Получить нажатую клавишу
    ; 66 hl = &gKeyTrigger;
    ld   hl, gKeyTrigger
    ; 67 b = *hl;
    ld   b, (hl)
    ; 68 *hl = 0;
    ld   (hl), 0
    ; 70 // Нажат выстрел
    ; 71 a = menuX;
    ld   a, (menuX)
    ; 72 if (b & KEY_FIRE)
    bit  4, b
    ; 73 {
    jp   z, l4
    ; 74 if (a == [0 * menuItemH]) return gExec(hl = "city");
    or   a
    ld   hl, s7
    jp   z, gExec
    ; 75 if (a == [1 * menuItemH]) return intro();
    cp   10
    jp   z, intro
    ; 76 //if (a == [2 * menuItemH]) return loadGame();
    ; 77 //return saveGame();
    ; 78 return;
    ret
    ; 79 }
    ; 81 // Перемещение курсора
    ; 82 if (b & KEY_UP)
l4:
    bit  0, b
    ; 83 {
    jp   z, l5
    ; 84 a -= menuItemH;
    sub  10
    ; 85 if (flag_c) return;
    ret  c
    ; 86 }
    ; 87 else if (b & KEY_DOWN)
    jp   l6
l5:
    bit  1, b
    ; 88 {
    jp   z, l7
    ; 89 a += menuItemH;
    add  10
    ; 90 if (a >= menuItemsM) return;
    cp   30
    ret  nc
    ; 91 }
    ; 92 menuX = a;
l7:
l6:
    ld   (menuX), a
    ; 94 // Плавное перемещение курсора
    ; 95 hl = &menuX1;
    ld   hl, menuX1
    ; 96 b = *hl;
    ld   b, (hl)
    ; 97 if (a == b) return; // Оставит флаг CF при выполнении menuX1 - menuX
    cp   b
    ret  z
    ; 98 b++; // Не изменяет CF
    inc  b
    ; 99 if (flag_c) ----b;
    jp   nc, l8
    dec  b
    dec  b
    ; 101 push(bc);
l8:
    push bc
    ; 102 menuDrawCursor();
    call menuDrawCursor
    ; 103 pop(bc);
    pop  bc
    ; 105 *(hl = &menuX1) = b;
    ld   hl, menuX1
    ld   (hl), b
    ; 107 menuDrawCursor();
    call menuDrawCursor
    ; 109 return;
    ret
    ; 110 }
    ret
    ; strings
s0 db "@",0
s7 db "city",0
s3 db "Ввести пароль",0
s6 db "Елена {Мириам} Ханпира",0
s4 db "Игра | 2019 Алексей {Alemorf} Морозов",0
s5 db "Мюзикл | 1998 Антон {Саруман} Круглов,",0
s2 db "Настроить управление",0
s1 db "Начать новую игру",0

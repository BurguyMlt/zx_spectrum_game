    ; menu/menu2.c:2 // (c) Морозов Алексей
    ; menu/menu2.c:3 // Главное меню.
    ; menu/menu2.c:4 
    ; menu/menu2.c:5 #include "common.h"
    ; menu/menu2.c:6 
    ; common.h:2 const int itemsCount = 8;
    ; common.h:3 
    ; common.h:4 // Размер глобального строкового буфера
    ; common.h:5 const int gStringBufferSize = 32;
    ; common.h:6 
    ; common.h:7 // Флаги для переменных gPanelChangedA, gPanelChangedB
    ; common.h:8 const int gPanelChangedMoney = 0x01;
    ; common.h:9 const int gPanelChangedPlace = 0x02;
    ; common.h:10 //const int gPanelChangedImages = 0x04;
    ; common.h:11 const int gPanelChanedSecondWeaponCount = 0x08;
    ; common.h:12 const int gPanelChanedArmorCount = 0x10;
    ; common.h:13 
    ; common.h:14 // Максимальное кол-во символов (не учитывая терминатор строки), которое возращает функция numberToString16
    ; common.h:15 const int numberToString16max = 5;
    ; common.h:16 
    ; common.h:17 // Максимальное кол-во предметов у игрока
    ; common.h:18 const int playerItemsMax = 5;
    ; common.h:19 
    ; common.h:20 // Максимальное кол-во типов лута у игрока (кол-во отображаемых строк в инвентаре)
    ; common.h:21 const int playerLutMax = 12;
    ; common.h:22 
    ; common.h:23 // Максимальное кол-во лута у игрока (сумма)
    ; common.h:24 const int playerLutMaxCountInLine = 99;
    ; common.h:25 
    ; common.h:26 const int secondWeaponMax = 9;
    ; common.h:27 
    ; common.h:28 // Флаги клавиш для переменные gKeyPressed, gKeyTrigger
    ; common.h:29 const int KEY_UP = 1;
    ; common.h:30 const int KEY_DOWN = 2;
    ; common.h:31 const int KEY_LEFT = 4;
    ; common.h:32 const int KEY_RIGHT = 8;
    ; common.h:33 const int KEY_FIRE = 16;
    ; common.h:34 const int KEY_MENU = 32;
    ; common.h:35 
    ; common.h:36 // Стандартные адреса ZX Spectrum
    ; common.h:37 const int screenBw0 = 0x4000;
    ; common.h:38 const int screenAttr0 = 0x5800;
    ; common.h:39 
    ; common.h:40 // Размеры экрана
    ; common.h:41 const int screenWidthTails = 32;
    ; common.h:42 const int panelHeightTails = 4;
    ; common.h:43 const int tailHeight = 8;
    ; common.h:44 const int tailWidth = 8;
    ; common.h:45 const int playfieldHeightTails = 20;
    ; common.h:46 
    ; common.h:47 // Используется при упаковке координат X, Y в регистровую пару
    ; common.h:48 const int bpl = 256;
    ; common.h:49 
    ; common.h:50 // Точки входа
    ; common.h:51 const int gPanelRedrawImagesPage = 6;
    ; common.h:52 const int gPanelRedrawImages = 0xC006;
    ; common.h:53 const int gInventPage = 6;
    ; common.h:54 const int gInvent = 0xC000;
    ; common.h:55 
    ; common.h:56 // Параметр для drawText
    ; common.h:57 const int smallFontFlag = 0x80;
    ; common.h:58 
    ; menu/menu2.c:7 const int menuLogoX      = 1;
    ; menu/menu2.c:8 const int menuLogoY      = 1;
    ; menu/menu2.c:9 const int menuItemH      = 10;
    ; menu/menu2.c:10 const int menuItemsY     = 100;
    ; menu/menu2.c:11 const int menuItemsX     = 80;
    ; menu/menu2.c:12 const int menuItemsSX    = 72;
    ; menu/menu2.c:13 const int menuItemsCount = 3;
    ; menu/menu2.c:14 const int menuItemsM     = menuItemsCount * menuItemH;
    ; menu/menu2.c:15 
    ; menu/menu2.c:16 uint8_t menuX = 0;
menuX db 0
    ; menu/menu2.c:17 uint8_t menuX1 = 0;
menuX1 db 0
    ; menu/menu2.c:18 
    ; menu/menu2.c:19 uint16_t test;
test dw 0
    ; menu/menu2.c:20 
    ; menu/menu2.c:21 void menuDrawCursor()
menuDrawCursor:
    ; menu/menu2.c:22 {
    ; menu/menu2.c:23 gDrawTextEx(h = ((a = menuX1) += menuItemsY), l = menuItemsSX, de = "@", a = 0x44);
    ld   a, (menuX1)
    add  100
    ld   h, a
    ld   l, 72
    ld   de, s0
    ld   a, 68
    call gDrawTextEx
    ; menu/menu2.c:24 }
    ret
    ; menu/menu2.c:25 
    ; menu/menu2.c:26 void wait()
wait:
    ; menu/menu2.c:27 {
    ; menu/menu2.c:28 hl = &gFrame;
    ld   hl, gFrame
    ; menu/menu2.c:29 a ^= a;
    xor  a
    ; menu/menu2.c:30 do { a |= *hl; } while(flag_z);
l0:
    or   (hl)
    jp   z, l0
l1:
    ; menu/menu2.c:31 *hl = 0;
    ld   (hl), 0
    ; menu/menu2.c:32 }
    ret
    ; menu/menu2.c:33 
    ; menu/menu2.c:34 void main()
main:
    ; menu/menu2.c:35 {
    ; menu/menu2.c:36 gClearScreen(a = 0x45);
    ld   a, 69
    call gClearScreen
    ; menu/menu2.c:37 gDrawImage(de = [0x5800 + menuLogoX + (menuLogoY << 5)], hl = &image_logo);
    ld   de, 22561
    ld   hl, image_logo
    call gDrawImage
    ; menu/menu2.c:38 gDrawTextEx(a = 0x45, hl = [(menuItemsY + menuItemH * 0) * 256 + menuItemsX], de = "Начать новую игру");
    ld   a, 69
    ld   hl, 25680
    ld   de, s1
    call gDrawTextEx
    ; menu/menu2.c:39 gDrawTextEx(a = 0x45, hl = [(menuItemsY + menuItemH * 1) * 256 + menuItemsX], de = "Настроить управление");
    ld   a, 69
    ld   hl, 28240
    ld   de, s2
    call gDrawTextEx
    ; menu/menu2.c:40 gDrawTextEx(a = 0x45, hl = [(menuItemsY + menuItemH * 2) * 256 + menuItemsX], de = "Ввести пароль");
    ld   a, 69
    ld   hl, 30800
    ld   de, s3
    call gDrawTextEx
    ; menu/menu2.c:41 
    ; menu/menu2.c:42 gDrawTextCenter(a = 0x43, h = [192 - 8 - menuItemH * 2], de = "Игра | 2019 Алексей {Alemorf} Морозов");
    ld   a, 67
    ld   h, 164
    ld   de, s4
    call gDrawTextCenter
    ; menu/menu2.c:43 gDrawTextCenter(a = 0x43, h = [192 - 8 - menuItemH * 1], de = "Мюзикл | 1998 Антон {Саруман} Круглов,");
    ld   a, 67
    ld   h, 174
    ld   de, s5
    call gDrawTextCenter
    ; menu/menu2.c:44 gDrawTextCenter(a = 0x43, h = [192 - 8 - menuItemH * 0], de = "Елена {Мириам} Ханпира");
    ld   a, 67
    ld   h, 184
    ld   de, s6
    call gDrawTextCenter
    ; menu/menu2.c:45 
    ; menu/menu2.c:46 menuX = a ^= a;
    xor  a
    ld   (menuX), a
    ; menu/menu2.c:47 menuX1 = (++a);
    inc  a
    ld   (menuX1), a
    ; menu/menu2.c:48 
    ; menu/menu2.c:49 menuDrawCursor();
    call menuDrawCursor
    ; menu/menu2.c:50 
    ; menu/menu2.c:51 while()
l2:
    ; menu/menu2.c:52 {
    ; menu/menu2.c:53 wait();
    call wait
    ; menu/menu2.c:54 menuTick();
    call menuTick
    ; menu/menu2.c:55 }
    jp   l2
l3:
    ; menu/menu2.c:56 return;
    ret
    ; menu/menu2.c:57 }
    ret
    ; menu/menu2.c:58 
    ; menu/menu2.c:59 void menuTick()
menuTick:
    ; menu/menu2.c:60 {
    ; menu/menu2.c:61 // Получить нажатую клавишу
    ; menu/menu2.c:62 hl = &gKeyTrigger;
    ld   hl, gKeyTrigger
    ; menu/menu2.c:63 b = *hl;
    ld   b, (hl)
    ; menu/menu2.c:64 *hl = 0;
    ld   (hl), 0
    ; menu/menu2.c:65 
    ; menu/menu2.c:66 // Нажат выстрел
    ; menu/menu2.c:67 a = menuX;
    ld   a, (menuX)
    ; menu/menu2.c:68 if (b & KEY_FIRE)
    bit  4, b
    ; menu/menu2.c:69 {
    jp   z, l4
    ; menu/menu2.c:70 if (a == [0 * menuItemH]) return gExec(hl = "city");
    or   a
    ld   hl, s7
    jp   z, gExec
    ; menu/menu2.c:71 if (a == [1 * menuItemH]) return intro();
    cp   10
    jp   z, intro
    ; menu/menu2.c:72 //if (a == [2 * menuItemH]) return loadGame();
    ; menu/menu2.c:73 //return saveGame();
    ; menu/menu2.c:74 return;
    ret
    ; menu/menu2.c:75 }
    ; menu/menu2.c:76 
    ; menu/menu2.c:77 // Перемещение курсора
    ; menu/menu2.c:78 if (b & KEY_UP)
l4:
    bit  0, b
    ; menu/menu2.c:79 {
    jp   z, l5
    ; menu/menu2.c:80 a -= menuItemH;
    sub  10
    ; menu/menu2.c:81 if (flag_c) return;
    ret  c
    ; menu/menu2.c:82 }
    ; menu/menu2.c:83 else if (b & KEY_DOWN)
    jp   l6
l5:
    bit  1, b
    ; menu/menu2.c:84 {
    jp   z, l7
    ; menu/menu2.c:85 a += menuItemH;
    add  10
    ; menu/menu2.c:86 if (a >= menuItemsM) return;
    cp   30
    ret  nc
    ; menu/menu2.c:87 }
    ; menu/menu2.c:88 menuX = a;
l7:
l6:
    ld   (menuX), a
    ; menu/menu2.c:89 
    ; menu/menu2.c:90 // Плавное перемещение курсора
    ; menu/menu2.c:91 hl = &menuX1;
    ld   hl, menuX1
    ; menu/menu2.c:92 b = *hl;
    ld   b, (hl)
    ; menu/menu2.c:93 if (a == b) return; // Оставит флаг CF при выполнении menuX1 - menuX
    cp   b
    ret  z
    ; menu/menu2.c:94 b++; // Не изменяет CF
    inc  b
    ; menu/menu2.c:95 if (flag_c) ----b;
    jp   nc, l8
    dec  b
    dec  b
    ; menu/menu2.c:96 
    ; menu/menu2.c:97 push(bc);
l8:
    push bc
    ; menu/menu2.c:98 menuDrawCursor();
    call menuDrawCursor
    ; menu/menu2.c:99 pop(bc);
    pop  bc
    ; menu/menu2.c:100 
    ; menu/menu2.c:101 *(hl = &menuX1) = b;
    ld   hl, menuX1
    ld   (hl), b
    ; menu/menu2.c:102 
    ; menu/menu2.c:103 menuDrawCursor();
    call menuDrawCursor
    ; menu/menu2.c:104 
    ; menu/menu2.c:105 return;
    ret
    ; menu/menu2.c:106 }
    ret
    ; menu/menu2.c:107 
    ; strings
s0 db "@",0
s7 db "city",0
s3 db "������ ������",0
s6 db "����� {������} �������",0
s4 db "���� | 2019 ������� {Alemorf} �������",0
s5 db "������ | 1998 ����� {�������} �������,",0
s2 db "��������� ����������",0
s1 db "������ ����� ����",0

    ; base/keyboard.c:2 
    ; base/keyboard.c:3 #include "common.h"
    ; base/keyboard.c:4 
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
    ; base/keyboard.c:5 // Использует A, BC, HL
    ; base/keyboard.c:6 void readKey()
readKey:
    ; base/keyboard.c:7 {
    ; base/keyboard.c:8 c = in(bc = 0xEFFE);
    ld   bc, 61438
    in   c, (c)
    ; base/keyboard.c:9 a ^= a;
    xor  a
    ; base/keyboard.c:10 if (c & 0x04) a |= KEY_RIGHT;
    bit  2, c
    jp   z, l1000
    or   8
    ; base/keyboard.c:11 if (c & 0x08) a |= KEY_UP;
l1000:
    bit  3, c
    jp   z, l1001
    or   1
    ; base/keyboard.c:12 if (c & 0x10) a |= KEY_DOWN;
l1001:
    bit  4, c
    jp   z, l1002
    or   2
    ; base/keyboard.c:13 c = in(bc = 0xF7FE);
l1002:
    ld   bc, 63486
    in   c, (c)
    ; base/keyboard.c:14 if (c & 0x10) a |= KEY_LEFT;
    bit  4, c
    jp   z, l1003
    or   4
    ; base/keyboard.c:15 c = in(bc = 0x7FFE);
l1003:
    ld   bc, 32766
    in   c, (c)
    ; base/keyboard.c:16 if (c & 0x01) a |= KEY_FIRE;
    bit  0, c
    jp   z, l1004
    or   16
    ; base/keyboard.c:17 c = in(bc = 0xBFFE);
l1004:
    ld   bc, 49150
    in   c, (c)
    ; base/keyboard.c:18 if (c & 0x01) a |= KEY_MENU;
    bit  0, c
    jp   z, l1005
    or   32
    ; base/keyboard.c:19 a ^= 0xFF;
l1005:
    xor  255
    ; base/keyboard.c:20 
    ; base/keyboard.c:21 // Чтение прошлого значения и сохранение нового
    ; base/keyboard.c:22 b = a;
    ld   b, a
    ; base/keyboard.c:23 hl = &gKeyPressed;
    ld   hl, gKeyPressed
    ; base/keyboard.c:24 a = *hl;
    ld   a, (hl)
    ; base/keyboard.c:25 *hl = b;
    ld   (hl), b
    ; base/keyboard.c:26 
    ; base/keyboard.c:27 // Выделение события нажатия
    ; base/keyboard.c:28 a ^= 0xFF;
    xor  255
    ; base/keyboard.c:29 a &= b;
    and  b
    ; base/keyboard.c:30 hl = &gKeyTrigger;
    ld   hl, gKeyTrigger
    ; base/keyboard.c:31 a |= *hl;
    or   (hl)
    ; base/keyboard.c:32 *hl = a;
    ld   (hl), a
    ; base/keyboard.c:33 
    ; base/keyboard.c:34 return;
    ret
    ; base/keyboard.c:35 }
    ret
    ; base/keyboard.c:36 

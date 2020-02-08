    ; base/panel.c:2 
    ; base/panel.c:3 #include "common.h"
    ; base/panel.c:4 
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
    ; base/panel.c:5 const int panelAddrBwA        = 0x5080;
    ; base/panel.c:6 const int panelAddrBwB        = panelAddrBwA | 0x8000;
    ; base/panel.c:7 const int panelAddrClA        = 0x5A80;
    ; base/panel.c:8 const int panelAddrClB        = panelAddrClA | 0x8000;
    ; base/panel.c:9 
    ; base/panel.c:10 const int panelPlaceColor     = 0x4E;
    ; base/panel.c:11 const int panelNumberColor    = 0x4F;
    ; base/panel.c:12 const int panelMoneyColor     = 0xCE;
    ; base/panel.c:13 
    ; base/panel.c:14 const int panelMoneyAddr      = 0x52C4;
    ; base/panel.c:15 const int panelMoneyWidth16   = 7;
    ; base/panel.c:16 const int panelArmorCount     = 0x52FC;
    ; base/panel.c:17 const int panelSuperCountAddr = 0x52F8;
    ; base/panel.c:18 const int panelPlaceAddr      = 0x5284;
    ; base/panel.c:19 const int panelPlaceWidth16   = 7;
    ; base/panel.c:20 
    ; base/panel.c:21 void panelRedraw()
panelRedraw:
    ; base/panel.c:22 {
    ; base/panel.c:23 // Нужно ли перерисовать?
    ; base/panel.c:24 hl = &gPanelChangedA;
    ld   hl, gPanelChangedA
    ; base/panel.c:25 if ((a = gVideoPage) & 0x80) hl++;
    ld   a, (gVideoPage)
    bit  7, a
    jp   z, l6000
    inc  hl
    ; base/panel.c:26 a = *hl;
l6000:
    ld   a, (hl)
    ; base/panel.c:27 if (a == 0) return;
    or   a
    ret  z
    ; base/panel.c:28 *hl = 0;
    ld   (hl), 0
    ; base/panel.c:29 
    ; base/panel.c:30 // Рисование денег
    ; base/panel.c:31 if (a & gPanelChangedMoney)
    bit  0, a
    ; base/panel.c:32 {
    jp   z, l6001
    ; base/panel.c:33 push(a)
    ; base/panel.c:34 {
    push af
    ; base/panel.c:35 numberToString16(hl = &gStringBuffer, de = gPlayerMoney);
    ld   hl, gStringBuffer
    ld   de, (gPlayerMoney)
    call numberToString16
    ; base/panel.c:36 
    ; base/panel.c:37 // Очистка фона под надписью
    ; base/panel.c:38 clearSmall99(b = panelMoneyWidth16, hl = panelMoneyAddr);
    ld   b, 7
    ld   hl, 21188
    call clearSmall99
    ; base/panel.c:39 
    ; base/panel.c:40 // Рисование надписи
    ; base/panel.c:41 gDrawText(hl, de = &gStringBuffer, a = [panelPlaceColor | smallFontFlag]);
    ld   de, gStringBuffer
    ld   a, 206
    call gDrawText
    ; base/panel.c:42 }
    pop  af
    ; base/panel.c:43 }
    ; base/panel.c:44 
    ; base/panel.c:45 // Рисование названия города
    ; base/panel.c:46 if (a & gPanelChangedPlace)
l6001:
    bit  1, a
    ; base/panel.c:47 {
    jp   z, l6002
    ; base/panel.c:48 push(a)
    ; base/panel.c:49 {
    push af
    ; base/panel.c:50 // Очистка фона под надписью
    ; base/panel.c:51 clearSmall99(b = panelPlaceWidth16, hl = panelPlaceAddr);
    ld   b, 7
    ld   hl, 21124
    call clearSmall99
    ; base/panel.c:52 // Рисование надписи
    ; base/panel.c:53 gDrawText(hl, de = "УТЕХА", a = [panelPlaceColor | smallFontFlag]); //! В глобальные переменные
    ld   de, s6000
    ld   a, 206
    call gDrawText
    ; base/panel.c:54 }
    pop  af
    ; base/panel.c:55 }
    ; base/panel.c:56 
    ; base/panel.c:57 // Рисование кол-ва второго оружия
    ; base/panel.c:58 if (a & gPanelChanedSecondWeaponCount)
l6002:
    bit  3, a
    ; base/panel.c:59 {
    jp   z, l6003
    ; base/panel.c:60 push(a)
    ; base/panel.c:61 {
    push af
    ; base/panel.c:62 // Кол-во супероружия хранится в массиве
    ; base/panel.c:63 a = gPlayerSecondWeaponSel;
    ld   a, (gPlayerSecondWeaponSel)
    ; base/panel.c:64 getItemOfArray8(hl = &gPlayerSecondWeaponCounters, a);
    ld   hl, gPlayerSecondWeaponCounters
    call getItemOfArray8
    ; base/panel.c:65 // Рисование
    ; base/panel.c:66 drawNubmer999(hl = panelSuperCountAddr, d = 0, e = a);
    ld   hl, 21240
    ld   d, 0
    ld   e, a
    call drawNubmer999
    ; base/panel.c:67 }
    pop  af
    ; base/panel.c:68 }
    ; base/panel.c:69 
    ; base/panel.c:70 // Рисование числа амулета
    ; base/panel.c:71 if (a & gPanelChanedArmorCount)
l6003:
    bit  4, a
    ; base/panel.c:72 {
    jp   z, l6004
    ; base/panel.c:73 push(a)
    ; base/panel.c:74 {
    push af
    ; base/panel.c:75 drawNubmer999(hl = panelArmorCount, de = 999);
    ld   hl, 21244
    ld   de, 999
    call drawNubmer999
    ; base/panel.c:76 }
    pop  af
    ; base/panel.c:77 }
    ; base/panel.c:78 }
l6004:
    ret
    ; base/panel.c:79 
    ; base/panel.c:80 // Рисование числа маленьким шрифтом с центрированием.
    ; base/panel.c:81 
    ; base/panel.c:82 void drawNubmer999(hl, de)
drawNubmer999:
    ; base/panel.c:83 {
    ; base/panel.c:84 // Преобразование числа в строку
    ; base/panel.c:85 push(hl)
    ; base/panel.c:86 {
    push hl
    ; base/panel.c:87 numberToString16(hl = &gStringBuffer); //! Заменить на numberToString8
    ld   hl, gStringBuffer
    call numberToString16
    ; base/panel.c:88 }
    pop  hl
    ; base/panel.c:89 
    ; base/panel.c:90 // Очистка фона под цифрой
    ; base/panel.c:91 clearSmall99(b = 1, hl);
    ld   b, 1
    call clearSmall99
    ; base/panel.c:92 
    ; base/panel.c:93 // Центрирование числа
    ; base/panel.c:94 c = [(16 - (5 + 5 + 4)) / 2]; // Смещение для 3-х цифр
    ld   c, 1
    ; base/panel.c:95 if ((a = *[&gStringBuffer + 2]) == 0) c = [(16 - (5 + 4)) / 2]; // Смещение для 2-х цифр
    ld   a, ((gStringBuffer) + (2))
    or   a
    jp   nz, l6005
    ld   c, 3
    ; base/panel.c:96 if ((a = *[&gStringBuffer + 1]) == 0) c = [(16 - 4) / 2]; // Смещение для одной цифры
l6005:
    ld   a, ((gStringBuffer) + (1))
    or   a
    jp   nz, l6006
    ld   c, 6
    ; base/panel.c:97 
    ; base/panel.c:98 // Рисование текста
    ; base/panel.c:99 drawTextSub(c, hl, de = &gStringBuffer, a = [panelNumberColor | smallFontFlag]);
l6006:
    ld   de, gStringBuffer
    ld   a, 207
    call drawTextSub
    ; base/panel.c:100 }
    ret
    ; base/panel.c:101 
    ; base/panel.c:102 // Очистить прямоугольник ширинй b * 16 и высотой 5 пикселей.
    ; base/panel.c:103 // Пересение знакоместа (координатой Y) не допускается.
    ; base/panel.c:104 // Вход:
    ; base/panel.c:105 //     b - ширина / 16 в пикселях
    ; base/panel.c:106 //     hl - адрес верхнего левого угла прямоугольника в чб видеопамяти.
    ; base/panel.c:107 
    ; base/panel.c:108 void clearSmall99(b, hl)
clearSmall99:
    ; base/panel.c:109 {
    ; base/panel.c:110 // Адрес активной видеостраницы
    ; base/panel.c:111 h = (((a = gVideoPage) &= 0x80) |= h);    
    ld   a, (gVideoPage)
    and  128
    or   h
    ld   h, a
    ; base/panel.c:112 push(hl)
    ; base/panel.c:113 {
    push hl
    ; base/panel.c:114 a ^= a;
    xor  a
    ; base/panel.c:115 do
l6007:
    ; base/panel.c:116 {
    ; base/panel.c:117 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; base/panel.c:118 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; base/panel.c:119 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; base/panel.c:120 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; base/panel.c:121 *hl = a; l++;
    ld   (hl), a
    inc  l
    ; base/panel.c:122 *hl = a; h--;
    ld   (hl), a
    dec  h
    ; base/panel.c:123 *hl = a; h--;
    ld   (hl), a
    dec  h
    ; base/panel.c:124 *hl = a; h--;
    ld   (hl), a
    dec  h
    ; base/panel.c:125 *hl = a; h--;
    ld   (hl), a
    dec  h
    ; base/panel.c:126 *hl = a; l++;
    ld   (hl), a
    inc  l
    ; base/panel.c:127 } while(--b);
    djnz l6007
l6008:
    ; base/panel.c:128 }
    pop  hl
    ; base/panel.c:129 }
    ret
    ; base/panel.c:130 
    ; base/panel.c:131 // Скопировать панель с видеостраницы A на видеостраницу B.
    ; base/panel.c:132 // Используется при обновлении панели из модуля расположенного в расширенной памяти.
    ; base/panel.c:133 // Такой модуль не имеет возможности изменять видеостраницу B.
    ; base/panel.c:134 
    ; base/panel.c:135 // Ограничение: панель не должна быть расположена на пересечении третей экрана.
    ; base/panel.c:136 // Ограничение: панель должна быть шириной во весь экран
    ; base/panel.c:137 
    ; base/panel.c:138 void copyPanel()
copyPanel:
    ; base/panel.c:139 {
    ; base/panel.c:140 h = [panelAddrBwA >> 8]; // Старшая часть адреса видеостраницы A
    ld   h, 80
    ; base/panel.c:141 d = [panelAddrBwB >> 8]; // Старшая часть адреса видеостраницы B
    ld   d, 208
    ; base/panel.c:142 a = tailHeight;
    ld   a, 8
    ; base/panel.c:143 do
l6009:
    ; base/panel.c:144 {
    ; base/panel.c:145 push(de, hl)
    ; base/panel.c:146 {
    push de
    push hl
    ; base/panel.c:147 l = e = panelAddrBwA; // Младная часть адреса обоих видеостраниц. Должна совпадать.
    ld   e, 20608
    ld   l, e
    ; base/panel.c:148 ldir(hl, de, bc = [screenWidthTails * panelHeightTails]);
    ld   bc, 128
    ldir
    ; base/panel.c:149 }
    pop  hl
    pop  de
    ; base/panel.c:150 d++; h++;
    inc  d
    inc  h
    ; base/panel.c:151 } while(flag_nz --a);
    dec  a
    jp   nz, l6009
l6010:
    ; base/panel.c:152 
    ; base/panel.c:153 // Копируем цветную видеопамять
    ; base/panel.c:154 ldir(hl = panelAddrClA, de = panelAddrClB, bc = [screenWidthTails * panelHeightTails]);
    ld   hl, 23168
    ld   de, 55936
    ld   bc, 128
    ldir
    ; base/panel.c:155 }
    ret
    ; base/panel.c:156 
    ; strings
s6000 db "�����",0

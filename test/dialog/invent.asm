    ; dialog/invent.c:2 // (c) Алексей Морозов aka alemorf
    ; dialog/invent.c:3 // Инвентарь
    ; dialog/invent.c:4 
    ; dialog/invent.c:5 #counter 16000
    ; dialog/invent.c:6 
    ; dialog/invent.c:7 #include "common.h"
    ; dialog/invent.c:8 
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
    ; dialog/invent.c:9 const int borderColor                   = 0x44;
    ; dialog/invent.c:10 
    ; dialog/invent.c:11 const int secondWeaponBwAddrForPict     = 0x4042;
    ; dialog/invent.c:12 const int secondWeaponClAddrForPict     = 0x5842;
    ; dialog/invent.c:13 const int secondWeaponTextPos           = 35 * 256 + 19;
    ; dialog/invent.c:14 const int secondWeaponTextInactiveColor = 0x41;
    ; dialog/invent.c:15 const int secondWeaponTextActiveColor   = 0x47;
    ; dialog/invent.c:16 const int secondWeaponStepTails         = 3;
    ; dialog/invent.c:17 
    ; dialog/invent.c:18 const int itemsPos                      = 7 * 8 * 256 + 16;
    ; dialog/invent.c:19 const int itemsCursorPos                = 7 * 8 * 256 + 9;
    ; dialog/invent.c:20 const int itemsCursorColor              = 0x43;
    ; dialog/invent.c:21 const int itemColor                     = 0x45;
    ; dialog/invent.c:22 const int itemHeight                    = 10;
    ; dialog/invent.c:23 
    ; dialog/invent.c:24 const int lutPos                        = 7 * 8 * 256 + 144;
    ; dialog/invent.c:25 const int lutCountX                     = 240;
    ; dialog/invent.c:26 const int lutColor                      = 0x47;
    ; dialog/invent.c:27 const int lutItemHeight                 = 10;
    ; dialog/invent.c:28 
    ; dialog/invent.c:29 uint8_t selectedItem = 0;
selectedItem db 0
    ; dialog/invent.c:30 uint8_t selectedItem1 = 0;
selectedItem1 db 0
    ; dialog/invent.c:31 
    ; dialog/invent.c:32 const int inventgraphMapSpecialCodes = 0x80;
    ; dialog/invent.c:33 
    ; dialog/invent.c:34 void invent()
invent:
    ; dialog/invent.c:35 {
    ; dialog/invent.c:36 // Перемещаем курсор в начало
    ; dialog/invent.c:37 selectedItem = a = 0;
    ld   a, 0
    ld   (selectedItem), a
    ; dialog/invent.c:38 selectedItem1 = a;
    ld   (selectedItem1), a
    ; dialog/invent.c:39 
    ; dialog/invent.c:40 // Начало рисования
    ; dialog/invent.c:41 gBeginDraw();
    call gBeginDraw
    ; dialog/invent.c:42 
    ; dialog/invent.c:43 // Очищаем экран, но не трогаем панель.
    ; dialog/invent.c:44 hl = screenBw0;
    ld   hl, 16384
    ; dialog/invent.c:45 *hl = 0; // Без пикселей
    ld   (hl), 0
    ; dialog/invent.c:46 ldir(hl, de = [screenBw0 + 1], bc = [screenWidthTails * 128 + screenWidthTails * panelHeightTails - 1]);
    ld   de, 16385
    ld   bc, 4223
    ldir
    ; dialog/invent.c:47 a = [tailHeight - 1]; // Один проход уже сделали
    ld   a, 7
    ; dialog/invent.c:48 do
l16000:
    ; dialog/invent.c:49 {
    ; dialog/invent.c:50 (hl = [screenWidthTails * panelHeightTails]) += de;
    ld   hl, 128
    add  hl, de
    ; dialog/invent.c:51 ex(hl, de);
    ex de, hl
    ; dialog/invent.c:52 ldir(hl = screenBw0, de, bc = [screenWidthTails * panelHeightTails]);
    ld   hl, 16384
    ld   bc, 128
    ldir
    ; dialog/invent.c:53 } while(flag_nz --a);
    dec  a
    jp   nz, l16000
l16001:
    ; dialog/invent.c:54 
    ; dialog/invent.c:55 // Заливаем весь экран цветом рамки
    ; dialog/invent.c:56 hl = screenAttr0;
    ld   hl, 22528
    ; dialog/invent.c:57 *hl = borderColor;
    ld   (hl), 68
    ; dialog/invent.c:58 ldir(hl, de = [screenAttr0 + 1], bc = [screenWidthTails * playfieldHeightTails - 1]);
    ld   de, 22529
    ld   bc, 639
    ldir
    ; dialog/invent.c:59 
    ; dialog/invent.c:60 // Рисуем рамку
    ; dialog/invent.c:61 bc = screenBw0;
    ld   bc, 16384
    ; dialog/invent.c:62 de = &inventgraphMap;
    ld   de, inventgraphMap
    ; dialog/invent.c:63 while()
l16002:
    ; dialog/invent.c:64 {
    ; dialog/invent.c:65 // Читаем код
    ; dialog/invent.c:66 a = *de; de++;
    ld   a, (de)
    inc  de
    ; dialog/invent.c:67 
    ; dialog/invent.c:68 // Это специальный код
    ; dialog/invent.c:69 if (a >= inventgraphMapSpecialCodes)
    cp   128
    ; dialog/invent.c:70 {
    jp   c, l16004
    ; dialog/invent.c:71 // Конец рисования
    ; dialog/invent.c:72 if (flag_z) break;
    jp   z, l16003
    ; dialog/invent.c:73 
    ; dialog/invent.c:74 // Пропуск
    ; dialog/invent.c:75 a -= inventgraphMapSpecialCodes;
    sub  128
    ; dialog/invent.c:76 c = (a += c);
    add  c
    ld   c, a
    ; dialog/invent.c:77 if (flag_c) b = ((a = b) += 8);
    jp   nc, l16005
    ld   a, b
    add  8
    ld   b, a
    ; dialog/invent.c:78 continue;
l16005:
    jp l16002
    ; dialog/invent.c:79 }
    ; dialog/invent.c:80 
    ; dialog/invent.c:81 // Вычисление адреса. Тут арифметка написана так, что номер тейла не может быть больше 127
    ; dialog/invent.c:82 a += a;
l16004:
    add  a
    ; dialog/invent.c:83 l = (a += [&inventgraphTails >> 2]);
    add  (inventgraphTails) >> (2)
    ld   l, a
    ; dialog/invent.c:84 h = ((a +@= [&inventgraphTails >> 10]) -= l);
    adc  (inventgraphTails) >> (10)
    sub  l
    ld   h, a
    ; dialog/invent.c:85 hl += hl += hl;
    add  hl, hl
    add  hl, hl
    ; dialog/invent.c:86 
    ; dialog/invent.c:87 // Копируем тейл в видеопамять. Тайлы не пересекают 256-байтную страницу.
    ; dialog/invent.c:88 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; dialog/invent.c:89 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; dialog/invent.c:90 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; dialog/invent.c:91 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; dialog/invent.c:92 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; dialog/invent.c:93 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; dialog/invent.c:94 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; dialog/invent.c:95 *bc = a = *hl;
    ld   a, (hl)
    ld   (bc), a
    ; dialog/invent.c:96 
    ; dialog/invent.c:97 // Следующий адрес
    ; dialog/invent.c:98 b = ((a = b) -= 7);
    ld   a, b
    sub  7
    ld   b, a
    ; dialog/invent.c:99 c++;
    inc  c
    ; dialog/invent.c:100 if (flag_z) b = ((a = b) += 8);
    jp   nz, l16006
    ld   a, b
    add  8
    ld   b, a
    ; dialog/invent.c:101 }
l16006:
    jp   l16002
l16003:
    ; dialog/invent.c:102 
    ; dialog/invent.c:103 // Скрываем надпись "Заклинания", если на неё заезжает курсор
    ; dialog/invent.c:104 if ((a = gPlayerSecondWeaponCount) >= 8)
    ld   a, (gPlayerSecondWeaponCount)
    cp   8
    ; dialog/invent.c:105 {
    jp   c, l16007
    ; dialog/invent.c:106 d = h = 0x40;
    ld   h, 64
    ld   d, h
    ; dialog/invent.c:107 do
l16008:
    ; dialog/invent.c:108 {
    ; dialog/invent.c:109 l = 0x37;
    ld   l, 55
    ; dialog/invent.c:110 e = 0x38;
    ld   e, 56
    ; dialog/invent.c:111 ldir(hl, de, bc = 7);
    ld   bc, 7
    ldir
    ; dialog/invent.c:112 d++;
    inc  d
    ; dialog/invent.c:113 } while(flag_z d & 0x8);
    bit  3, d
    jp   z, l16008
l16009:
    ; dialog/invent.c:114 }
    ; dialog/invent.c:115 
    ; dialog/invent.c:116 // Рисуем пиктограммы второго оружия
    ; dialog/invent.c:117 bc = secondWeaponBwAddrForPict;
l16007:
    ld   bc, 16450
    ; dialog/invent.c:118 hl = secondWeaponClAddrForPict;
    ld   hl, 22594
    ; dialog/invent.c:119 d = 0; //! Заменить на B
    ld   d, 0
    ; dialog/invent.c:120 do
l16010:
    ; dialog/invent.c:121 {
    ; dialog/invent.c:122 push(bc, de)
    ; dialog/invent.c:123 {
    push bc
    push de
    ; dialog/invent.c:124 push(hl)
    ; dialog/invent.c:125 {
    push hl
    ; dialog/invent.c:126 h = 0; l = d;
    ld   h, 0
    ld   l, d
    ; dialog/invent.c:127 hl += hl += hl; de = hl; (hl += hl += hl += hl) += de; hl += (de = &magic_0); ex(hl, de); // *36
    add  hl, hl
    add  hl, hl
    ld   d, h
    ld   e, l
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, de
    ld   de, magic_0
    add  hl, de
    ex de, hl
    ; dialog/invent.c:128 }
    pop  hl
    ; dialog/invent.c:129 push(hl)
    ; dialog/invent.c:130 {
    push hl
    ; dialog/invent.c:131 drawSprite4(bc, hl, de);
    call drawSprite4
    ; dialog/invent.c:132 }
    pop  hl
    ; dialog/invent.c:133 }
    pop  de
    pop  bc
    ; dialog/invent.c:134 l = ((a = l) += secondWeaponStepTails); c = l;
    ld   a, l
    add  3
    ld   l, a
    ld   c, l
    ; dialog/invent.c:135 d++;
    inc  d
    ; dialog/invent.c:136 } while((a = gPlayerSecondWeaponCount) != d);
    ld   a, (gPlayerSecondWeaponCount)
    cp   d
    jp   nz, l16010
l16011:
    ; dialog/invent.c:137 
    ; dialog/invent.c:138 // Рисуем кол-во второго оружия
    ; dialog/invent.c:139 b = 0;
    ld   b, 0
    ; dialog/invent.c:140 hl = secondWeaponTextPos;
    ld   hl, 8979
    ; dialog/invent.c:141 do
l16012:
    ; dialog/invent.c:142 {
    ; dialog/invent.c:143 push(bc)
    ; dialog/invent.c:144 {
    push bc
    ; dialog/invent.c:145 push (hl)
    ; dialog/invent.c:146 {
    push hl
    ; dialog/invent.c:147 ex(hl, de);
    ex de, hl
    ; dialog/invent.c:148 getItemOfArray8(hl = &gPlayerSecondWeaponCounters, a = b);
    ld   hl, gPlayerSecondWeaponCounters
    ld   a, b
    call getItemOfArray8
    ; dialog/invent.c:149 ex(hl, de);
    ex de, hl
    ; dialog/invent.c:150 numberToString16(d = 0, e = a, hl = &gStringBuffer);                
    ld   d, 0
    ld   e, a
    ld   hl, gStringBuffer
    call numberToString16
    ; dialog/invent.c:151 }
    pop  hl
    ; dialog/invent.c:152 push (hl)
    ; dialog/invent.c:153 {
    push hl
    ; dialog/invent.c:154 a = *[&gStringBuffer + 1];
    ld   a, ((gStringBuffer) + (1))
    ; dialog/invent.c:155 if (a < 3) ++++l; // Выравнивание по ширине
    cp   3
    jp   nc, l16014
    inc  l
    inc  l
    ; dialog/invent.c:156 gDrawTextEx(hl, de = &gStringBuffer, a = [secondWeaponTextInactiveColor | 0x80]);
l16014:
    ld   de, gStringBuffer
    ld   a, 193
    call gDrawTextEx
    ; dialog/invent.c:157 }
    pop  hl
    ; dialog/invent.c:158 }
    pop  bc
    ; dialog/invent.c:159 l = ((a = l) += [secondWeaponStepTails * tailWidth]);
    ld   a, l
    add  24
    ld   l, a
    ; dialog/invent.c:160 b++;
    inc  b
    ; dialog/invent.c:161 } while((a = gPlayerSecondWeaponCount) != b);
    ld   a, (gPlayerSecondWeaponCount)
    cp   b
    jp   nz, l16012
l16013:
    ; dialog/invent.c:162 
    ; dialog/invent.c:163 // Рисуем наименования предметов
    ; dialog/invent.c:164 b = a = gPlayerItemsCount;
    ld   a, (gPlayerItemsCount)
    ld   b, a
    ; dialog/invent.c:165 hl = itemsPos;
    ld   hl, 14352
    ; dialog/invent.c:166 de = &gPlayerItems;
    ld   de, gPlayerItems
    ; dialog/invent.c:167 do
l16015:
    ; dialog/invent.c:168 {
    ; dialog/invent.c:169 push(bc, de, hl)
    ; dialog/invent.c:170 {
    push bc
    push de
    push hl
    ; dialog/invent.c:171 ex(hl, de);
    ex de, hl
    ; dialog/invent.c:172 getItemOfArray16(a = *hl, hl = &itemNames);
    ld   a, (hl)
    ld   hl, itemNames
    call getItemOfArray16
    ; dialog/invent.c:173 ex(hl, de);
    ex de, hl
    ; dialog/invent.c:174 gDrawTextEx(hl, de, a = itemColor);
    ld   a, 69
    call gDrawTextEx
    ; dialog/invent.c:175 }
    pop  hl
    pop  de
    pop  bc
    ; dialog/invent.c:176 de++;
    inc  de
    ; dialog/invent.c:177 h = ((a = h) += itemHeight);
    ld   a, h
    add  10
    ld   h, a
    ; dialog/invent.c:178 } while(--b);
    djnz l16015
l16016:
    ; dialog/invent.c:179 
    ; dialog/invent.c:180 // Рисуем наименование лута
    ; dialog/invent.c:181 b = a = gPlayerLutCount;
    ld   a, (gPlayerLutCount)
    ld   b, a
    ; dialog/invent.c:182 hl = lutPos;
    ld   hl, 14480
    ; dialog/invent.c:183 de = &gPlayerLut;
    ld   de, gPlayerLut
    ; dialog/invent.c:184 do
l16017:
    ; dialog/invent.c:185 {
    ; dialog/invent.c:186 push(bc)
    ; dialog/invent.c:187 {
    push bc
    ; dialog/invent.c:188 // Преобразуем кол-во в строку (gStringBuffer)
    ; dialog/invent.c:189 push(hl, de)
    ; dialog/invent.c:190 {
    push hl
    push de
    ; dialog/invent.c:191 (hl = playerLutMax) += de;
    ld   hl, 12
    add  hl, de
    ; dialog/invent.c:192 numberToString16(d = 0, e = *hl, hl = &gStringBuffer);
    ld   d, 0
    ld   e, (hl)
    ld   hl, gStringBuffer
    call numberToString16
    ; dialog/invent.c:193 }
    pop  de
    pop  hl
    ; dialog/invent.c:194 
    ; dialog/invent.c:195 push(de)
    ; dialog/invent.c:196 {
    push de
    ; dialog/invent.c:197 // Тип лута
    ; dialog/invent.c:198 a = *de;
    ld   a, (de)
    ; dialog/invent.c:199 
    ; dialog/invent.c:200 // Тип лута в строку (de)
    ; dialog/invent.c:201 ex(hl, de);
    ex de, hl
    ; dialog/invent.c:202 getItemOfArray16(hl = &lutNames, a);
    ld   hl, lutNames
    call getItemOfArray16
    ; dialog/invent.c:203 ex(hl, de);
    ex de, hl
    ; dialog/invent.c:204 
    ; dialog/invent.c:205 // Выводим наименование
    ; dialog/invent.c:206 push(hl)
    ; dialog/invent.c:207 {
    push hl
    ; dialog/invent.c:208 gDrawTextEx(hl, de, a = lutColor);
    ld   a, 71
    call gDrawTextEx
    ; dialog/invent.c:209 }
    pop  hl
    ; dialog/invent.c:210 
    ; dialog/invent.c:211 // Выводим кол-во по правому краю
    ; dialog/invent.c:212 push(hl)
    ; dialog/invent.c:213 {
    push hl
    ; dialog/invent.c:214 l = lutCountX;
    ld   l, 240
    ; dialog/invent.c:215 drawTextRight(hl, de = &gStringBuffer, a = lutColor);
    ld   de, gStringBuffer
    ld   a, 71
    call drawTextRight
    ; dialog/invent.c:216 }
    pop  hl
    ; dialog/invent.c:217 }
    pop  de
    ; dialog/invent.c:218 }
    pop  bc
    ; dialog/invent.c:219 
    ; dialog/invent.c:220 h = ((a = h) += lutItemHeight); // Следующий текст пишем ниже
    ld   a, h
    add  10
    ld   h, a
    ; dialog/invent.c:221 de++; // Следующий ЛУТ
    inc  de
    ; dialog/invent.c:222 } while(--b);
    djnz l16017
l16018:
    ; dialog/invent.c:223 
    ; dialog/invent.c:224 // Рисуем основное оружие
    ; dialog/invent.c:225 drawSprite4(hl = 0x59E1, bc = 0x48E1, de = [&magic_0 + 36]);
    ld   hl, 23009
    ld   bc, 18657
    ld   de, (magic_0) + (36)
    call drawSprite4
    ; dialog/invent.c:226 gDrawTextEx(hl = [15 * 8 * 256 + 28], de = "Обычное оружие", a = 0x47);
    ld   hl, 30748
    ld   de, s16000
    ld   a, 71
    call gDrawTextEx
    ; dialog/invent.c:227 gDrawTextEx(hl = [(15 * 8 + 9) * 256 + 28], de = "\x16\x17\x18\x15\x19\x1A\x1B\x02", a = 0x46);
    ld   hl, 33052
    ld   de, s16001
    ld   a, 70
    call gDrawTextEx
    ; dialog/invent.c:228 
    ; dialog/invent.c:229 // Рисуем защиту
    ; dialog/invent.c:230 drawSprite4(hl = 0x5A21, bc = 0x5021, de = [&magic_0 + 36 * 3]);
    ld   hl, 23073
    ld   bc, 20513
    ld   de, (magic_0) + (108)
    call drawSprite4
    ; dialog/invent.c:231 gDrawTextEx(hl = [17 * 8 * 256 + 28], de = "Обычная защита", a = 0x47);
    ld   hl, 34844
    ld   de, s16002
    ld   a, 71
    call gDrawTextEx
    ; dialog/invent.c:232 gDrawTextEx(hl = [(17 * 8 + 9) * 256 + 28], de = "\x1A\x1B\x1C\x15\x1D\x1E\x1F\x02", a = 0x46);
    ld   hl, 37148
    ld   de, s16003
    ld   a, 70
    call gDrawTextEx
    ; dialog/invent.c:233 
    ; dialog/invent.c:234 // Рисуем ключи
    ; dialog/invent.c:235 drawSprite4(hl = 0x5A2E, bc = 0x502E, de = [&magic_0 + 36 * 9]);
    ld   hl, 23086
    ld   bc, 20526
    ld   de, (magic_0) + (324)
    call drawSprite4
    ; dialog/invent.c:236 
    ; dialog/invent.c:237 // Рисуем курсоры
    ; dialog/invent.c:238 drawSecondWeaponCursor(ixh = secondWeaponTextActiveColor);
    ld   ixh, 71
    call drawSecondWeaponCursor
    ; dialog/invent.c:239 drawItemCursor();
    call drawItemCursor
    ; dialog/invent.c:240 
    ; dialog/invent.c:241 gEndDraw();
    call gEndDraw
    ; dialog/invent.c:242 
    ; dialog/invent.c:243 // ** Меню ***
    ; dialog/invent.c:244 
    ; dialog/invent.c:245 while()
l16019:
    ; dialog/invent.c:246 {
    ; dialog/invent.c:247 // Ждем, если прошло меньше 1/50 сек с прошлого цикла.
    ; dialog/invent.c:248 while ((a = gVideoPage) & 1);
l16021:
    ld   a, (gVideoPage)
    bit  0, a
    jp   z, l16022
    jp   l16021
l16022:
    ; dialog/invent.c:249 gVideoPage = (a |= 1);
    or   1
    ld   (gVideoPage), a
    ; dialog/invent.c:250 
    ; dialog/invent.c:251 // Клавиша
    ; dialog/invent.c:252 hl = &gKeyTrigger;
    ld   hl, gKeyTrigger
    ; dialog/invent.c:253 a = *hl;
    ld   a, (hl)
    ; dialog/invent.c:254 *hl = 0;
    ld   (hl), 0
    ; dialog/invent.c:255 if (a & KEY_LEFT)
    bit  2, a
    ; dialog/invent.c:256 {
    jp   z, l16023
    ; dialog/invent.c:257 a = gPlayerSecondWeaponSel;
    ld   a, (gPlayerSecondWeaponSel)
    ; dialog/invent.c:258 a-=1;
    sub  1
    ; dialog/invent.c:259 if (flag_c) continue;
    jp   c, l16019
    ; dialog/invent.c:260 setSecondWeapon(a);
    call setSecondWeapon
    ; dialog/invent.c:261 }
    ; dialog/invent.c:262 else if (a & KEY_RIGHT)
    jp   l16024
l16023:
    bit  3, a
    ; dialog/invent.c:263 {
    jp   z, l16025
    ; dialog/invent.c:264 a = gPlayerSecondWeaponSel;
    ld   a, (gPlayerSecondWeaponSel)
    ; dialog/invent.c:265 a++;
    inc  a
    ; dialog/invent.c:266 if (a >= *(hl = &gPlayerSecondWeaponCount)) continue;
    ld   hl, gPlayerSecondWeaponCount
    cp   (hl)
    jp   nc, l16019
    ; dialog/invent.c:267 setSecondWeapon(a);
    call setSecondWeapon
    ; dialog/invent.c:268 }
    ; dialog/invent.c:269 else if (a & KEY_UP)
    jp   l16026
l16025:
    bit  0, a
    ; dialog/invent.c:270 {
    jp   z, l16027
    ; dialog/invent.c:271 a = selectedItem;
    ld   a, (selectedItem)
    ; dialog/invent.c:272 a-=1;
    sub  1
    ; dialog/invent.c:273 if (flag_c) continue;
    jp   c, l16019
    ; dialog/invent.c:274 selectedItem = a;
    ld   (selectedItem), a
    ; dialog/invent.c:275 }
    ; dialog/invent.c:276 else if (a & KEY_DOWN)
    jp   l16028
l16027:
    bit  1, a
    ; dialog/invent.c:277 {
    jp   z, l16029
    ; dialog/invent.c:278 a = selectedItem;
    ld   a, (selectedItem)
    ; dialog/invent.c:279 a++;
    inc  a
    ; dialog/invent.c:280 if (a >= *(hl = &gPlayerItemsCount)) continue; //*(hl = &gPlayerItemsCount)) continue;
    ld   hl, gPlayerItemsCount
    cp   (hl)
    jp   nc, l16019
    ; dialog/invent.c:281 selectedItem = a;
    ld   (selectedItem), a
    ; dialog/invent.c:282 }
    ; dialog/invent.c:283 else if (a & KEY_MENU)
    jp   l16030
l16029:
    bit  5, a
    ; dialog/invent.c:284 {
    jp   z, l16031
    ; dialog/invent.c:285 gBeginDraw();
    call gBeginDraw
    ; dialog/invent.c:286 gEndDraw();
    call gEndDraw
    ; dialog/invent.c:287 return;
    ret
    ; dialog/invent.c:288 }
    ; dialog/invent.c:289 
    ; dialog/invent.c:290 // Умножение на 10
    ; dialog/invent.c:291 a = selectedItem;
l16031:
l16030:
l16028:
l16026:
l16024:
    ld   a, (selectedItem)
    ; dialog/invent.c:292 c = (a += a);
    add  a
    ld   c, a
    ; dialog/invent.c:293 ((a += a) += a) += c;
    add  a
    add  a
    add  c
    ; dialog/invent.c:294 
    ; dialog/invent.c:295 // Плавное перемещение курсора
    ; dialog/invent.c:296 hl = &selectedItem1;
    ld   hl, selectedItem1
    ; dialog/invent.c:297 b = *hl;
    ld   b, (hl)
    ; dialog/invent.c:298 if (a == b) continue; // Оставит флаг CF при выполнении dialogX1 - menuX
    cp   b
    jp   z, l16019
    ; dialog/invent.c:299 b++; // Не изменяет CF
    inc  b
    ; dialog/invent.c:300 if (flag_c) ----b;
    jp   nc, l16032
    dec  b
    dec  b
    ; dialog/invent.c:301 
    ; dialog/invent.c:302 // Стираем прошлый курсор
    ; dialog/invent.c:303 push(bc);
l16032:
    push bc
    ; dialog/invent.c:304 drawItemCursor();
    call drawItemCursor
    ; dialog/invent.c:305 pop(bc);
    pop  bc
    ; dialog/invent.c:306 
    ; dialog/invent.c:307 // Сохраняем новые координаты курсора
    ; dialog/invent.c:308 *(hl = &selectedItem1) = b;
    ld   hl, selectedItem1
    ld   (hl), b
    ; dialog/invent.c:309 
    ; dialog/invent.c:310 // Рисуем курсор
    ; dialog/invent.c:311 drawItemCursor();
    call drawItemCursor
    ; dialog/invent.c:312 }
    jp   l16019
l16020:
    ; dialog/invent.c:313 }
    ret
    ; dialog/invent.c:314 
    ; dialog/invent.c:315 void drawItemCursor()
drawItemCursor:
    ; dialog/invent.c:316 {
    ; dialog/invent.c:317 l = itemsCursorPos;
    ld   l, 14345
    ; dialog/invent.c:318 h = ((a = selectedItem1) += [itemsCursorPos >> 8]);
    ld   a, (selectedItem1)
    add  56
    ld   h, a
    ; dialog/invent.c:319 gDrawTextEx(hl, de = "@", a = itemsCursorColor);
    ld   de, s16004
    ld   a, 67
    call gDrawTextEx
    ; dialog/invent.c:320 }
    ret
    ; dialog/invent.c:321 
    ; dialog/invent.c:322 void setSecondWeapon(a)
setSecondWeapon:
    ; dialog/invent.c:323 {
    ; dialog/invent.c:324 push(a)
    ; dialog/invent.c:325 {
    push af
    ; dialog/invent.c:326 drawSecondWeaponCursor(ixh = secondWeaponTextInactiveColor);
    ld   ixh, 65
    call drawSecondWeaponCursor
    ; dialog/invent.c:327 }
    pop  af
    ; dialog/invent.c:328 gPlayerSecondWeaponSel = a;
    ld   (gPlayerSecondWeaponSel), a
    ; dialog/invent.c:329 drawSecondWeaponCursor(ixh = secondWeaponTextActiveColor);
    ld   ixh, 71
    call drawSecondWeaponCursor
    ; dialog/invent.c:330 gPanelChangedA = a = 0xFF;
    ld   a, 255
    ld   (gPanelChangedA), a
    ; dialog/invent.c:331 gPanelChangedB = a;
    ld   (gPanelChangedB), a
    ; dialog/invent.c:332 gPanelRedraw();
    call gPanelRedraw
    ; dialog/invent.c:333 return panelDrawSecondWeapon();
    jp   panelDrawSecondWeapon
    ; dialog/invent.c:334 }
    ret
    ; dialog/invent.c:335 
    ; dialog/invent.c:336 void drawSecondWeaponCursor(ixh)
drawSecondWeaponCursor:
    ; dialog/invent.c:337 {
    ; dialog/invent.c:338 a = gPlayerSecondWeaponSel;
    ld   a, (gPlayerSecondWeaponSel)
    ; dialog/invent.c:339 b = a; (a += a) += b;
    ld   b, a
    add  a
    add  b
    ; dialog/invent.c:340 hl = [secondWeaponBwAddrForPict - 0x21]; l = (a += l);
    ld   hl, 16417
    add  l
    ld   l, a
    ; dialog/invent.c:341 b = [(secondWeaponClAddrForPict - 0x21) >> 8]; c = l;
    ld   b, 88
    ld   c, l
    ; dialog/invent.c:342 de = &magic_10;    
    ld   de, magic_10
    ; dialog/invent.c:343 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; dialog/invent.c:344 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; dialog/invent.c:345 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; dialog/invent.c:346 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; dialog/invent.c:347 ixl = 2;
    ld   ixl, 2
    ; dialog/invent.c:348 do
l16033:
    ; dialog/invent.c:349 {
    ; dialog/invent.c:350 l = ((a = l) += [0x20 - 4]); c = l;
    ld   a, l
    add  28
    ld   l, a
    ld   c, l
    ; dialog/invent.c:351 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; dialog/invent.c:352 l++; l++; c = l;
    inc  l
    inc  l
    ld   c, l
    ; dialog/invent.c:353 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; dialog/invent.c:354 } while (flag_nz --ixl);
    dec  ixl
    jp   nz, l16033
l16034:
    ; dialog/invent.c:355 l = ((a = l) += [0x20 - 4]); c = l;
    ld   a, l
    add  28
    ld   l, a
    ld   c, l
    ; dialog/invent.c:356 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; dialog/invent.c:357 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; dialog/invent.c:358 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; dialog/invent.c:359 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; dialog/invent.c:360 }
    ret
    ; dialog/invent.c:361 
    ; strings
s16001 db 22,23,24,21,25,26,27,2,0
s16003 db 26,27,28,21,29,30,31,2,0
s16004 db "@",0
s16002 db "������� ������",0
s16000 db "������� ������",0

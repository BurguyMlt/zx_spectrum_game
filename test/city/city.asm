    ; 3 const KEY_UP = 1;
    ; 4 const KEY_DOWN = 2;
    ; 5 const KEY_LEFT = 4;
    ; 6 const KEY_RIGHT = 8;
    ; 7 const KEY_FIRE = 16;
    ; 9 const PORT_7FFD_SECOND_VIDEO_PAGE = 8;
    ; 11 const screenAddr1 = 0x4000;
    ; 12 const screenAddr2 = 0xC000;
    ; 13 const screenWidth = 256;
    ; 14 const screenHeight = 192;
    ; 15 const screenBwSize = screenWidth / 8 * screenHeight;
    ; 16 const screenAttrSize = screenWidth / 8 * screenHeight / 8;
    ; 17 const screenAttrAddr1 = screenAddr1 + screenBwSize;
    ; 18 const screenAttrAddr2 = screenAddr2 + screenBwSize;
    ; 19 const screenEndAddr1 = screenAttrAddr1 + screenAttrSize;
    ; 20 const screenEndAddr2 = screenAttrAddr2 + screenAttrSize;
    ; 21 const cacheAddr1 = screenEndAddr1;
    ; 22 const cacheAddr2 = screenEndAddr2;
    ; 23 const unusedTailCode = 0xFF;
    ; 24 const viewWidth = 32;
    ; 25 const viewHeight = 20;
    ; 27 uint8_t cityPlayerX = 0;
cityPlayerX db 0
    ; 29 void cityInvalidate(hl)
cityInvalidate:
    ; 30 {
    ; 31 d = h; e = l; de++;
    ld   d, h
    ld   e, l
    inc  de
    ; 32 *hl = unusedTailCode;
    ld   (hl), 255
    ; 33 bc = [viewWidth * viewHeight - 1];
    ld   bc, 639
    ; 34 ldir();
    ldir
    ; 35 }
    ret
    ; 37 void city()
city:
    ; 38 {
    ; 39 cityPlayerX = a = 0;
    ld   a, 0
    ld   (cityPlayerX), a
    ; 41 // Очистка экрана
    ; 42 showVisibleVideoPage();
    call showVisibleVideoPage
    ; 43 clearScreenEx(hl = screenEndAddr2, d = 0x47);
    ld   hl, 56064
    ld   d, 71
    call clearScreenEx
    ; 44 clearScreen(d = 0x47);
    ld   d, 71
    call clearScreen
    ; 46 // Инициализация кеша
    ; 47 cityInvalidate(hl = cacheAddr1);
    ld   hl, 23296
    call cityInvalidate
    ; 48 cityInvalidate(hl = cacheAddr2);
    ld   hl, 56064
    call cityInvalidate
    ; 50 // Перерисовать
    ; 51 cityRedraw();
    call cityRedraw
    ; 53 while()
l2000:
    ; 54 {
    ; 55 readKey();
    call readKey
    ; 57 // Чтение клавиши
    ; 58 //hl = &keyTrigger;
    ; 59 hl = &keyPressed;
    ld   hl, keyPressed
    ; 60 b = *hl;
    ld   b, (hl)
    ; 61 //*hl = 0;
    ; 63 //
    ; 64 a = cityPlayerX;
    ld   a, (cityPlayerX)
    ; 65 if (b & KEY_LEFT)
    bit  2, b
    ; 66 {
    jp   z, l2002
    ; 67 cityPlayerX = --a;
    dec  a
    ld   (cityPlayerX), a
    ; 68 cityRedraw();
    call cityRedraw
    ; 69 }
    ; 70 else if (b & KEY_RIGHT)
    jp   l2003
l2002:
    bit  3, b
    ; 71 {
    jp   z, l2004
    ; 72 cityPlayerX = ++a;
    inc  a
    ld   (cityPlayerX), a
    ; 73 cityRedraw();
    call cityRedraw
    ; 74 }
    ; 75 }
l2004:
l2003:
    jp   l2000
    ; 76 }
    ret
    ; 78 uint8_t startFrame;
startFrame db 0
    ; 80 void cityRedraw()
cityRedraw:
    ; 81 {
    ; 82 // Оценка времени
    ; 83 startFrame = a = frame;
    ld   a, (frame)
    ld   (startFrame), a
    ; 85 // Адрес карты / источник
    ; 86 de` = &levelMap; // Можно оптимизировать d` = [&levelMap >> 8], но не поддержвиает компилятор пока
    ld   de, levelMap
    ; 87 e` = a = cityPlayerX;
    ld   a, (cityPlayerX)
    ld   e, a
    ; 88 b` = e`;
    ld   b, e
    ; 90 // Адрес видеостраницы / назначение
    ; 91 hl` = &visibleVideoPage;
    ld   hl, visibleVideoPage
    ; 92 if (*hl` & PORT_7FFD_SECOND_VIDEO_PAGE)
    bit  3, (hl)
    ; 93 {
    jp   z, l2005
    ; 94 *hl = 0;
    ld   (hl), 0
    ; 95 hl` = [cacheAddr1 - 1];
    ld   hl, 23295
    ; 96 ex(bc, de, hl);
    exx
    ; 97 hl = screenAddr1;
    ld   hl, 16384
    ; 98 bc = screenAttrAddr1;
    ld   bc, 22528
    ; 99 }
    ; 100 else
    jp   l2006
l2005:
    ; 101 {
    ; 102 *hl` = PORT_7FFD_SECOND_VIDEO_PAGE;
    ld   (hl), 8
    ; 103 hl` = [cacheAddr2 - 1];
    ld   hl, 56063
    ; 104 ex(bc, de, hl);
    exx
    ; 105 hl = screenAddr2;
    ld   hl, 49152
    ; 106 bc = screenAttrAddr2;
    ld   bc, 55296
    ; 107 }
l2006:
    ; 109 // Цикл строк
    ; 110 ixh = viewHeight;
    ld   ixh, 20
    ; 111 do
l2007:
    ; 112 {
    ; 113 push(hl);
    push hl
    ; 115 // Цикл стобцов
    ; 116 ixl = viewWidth;
    ld   ixl, 32
    ; 117 do
l2008:
    ; 118 {
    ; 119 push(hl);
    push hl
    ; 121 // Чтение номера тейла из карты уровня
    ; 122 ex(bc, de, hl);
    exx
    ; 123 hl`++;
    inc  hl
    ; 124 a = *de`;
    ld   a, (de)
    ; 125 e`++;
    inc  e
    ; 126 if (a == *hl`) // Можно потом оптимизировать на один переход
    cp   (hl)
    ; 127 {
    jp   nz, l2009
    ; 128 ex(bc, de, hl);
    exx
    ; 129 bc++;
    inc  bc
    ; 130 }
    ; 131 else
    jp   l2010
l2009:
    ; 132 {
    ; 133 *hl` = a;
    ld   (hl), a
    ; 134 ex(bc, de, hl);
    exx
    ; 136 // Вычисление адреса тейла
    ; 137 de = &levelTails; // Можно оптимизировать d = [&levelTails >> 8], но не поддержвиает компилятор пока
    ld   de, levelTails
    ; 138 e = a;
    ld   e, a
    ; 140 // Вывод на экран
    ; 141 a = *de; d++; *hl = a; h++;
    ld   a, (de)
    inc  d
    ld   (hl), a
    inc  h
    ; 142 a = *de; d++; *hl = a; h++;
    ld   a, (de)
    inc  d
    ld   (hl), a
    inc  h
    ; 143 a = *de; d++; *hl = a; h++;
    ld   a, (de)
    inc  d
    ld   (hl), a
    inc  h
    ; 144 a = *de; d++; *hl = a; h++;
    ld   a, (de)
    inc  d
    ld   (hl), a
    inc  h
    ; 145 a = *de; d++; *hl = a; h++;
    ld   a, (de)
    inc  d
    ld   (hl), a
    inc  h
    ; 146 a = *de; d++; *hl = a; h++;
    ld   a, (de)
    inc  d
    ld   (hl), a
    inc  h
    ; 147 a = *de; d++; *hl = a; h++;
    ld   a, (de)
    inc  d
    ld   (hl), a
    inc  h
    ; 148 a = *de; d++; *hl = a;
    ld   a, (de)
    inc  d
    ld   (hl), a
    ; 149 a = *de;      *bc = a; bc++;
    ld   a, (de)
    ld   (bc), a
    inc  bc
    ; 150 }
l2010:
    ; 152 pop(hl); // h был увеличен на 8
    pop  hl
    ; 153 l++;
    inc  l
    ; 154 ixl--;
    dec  ixl
    ; 155 } while(flag_nz);
    jp   nz, l2008
    ; 157 pop(hl);
    pop  hl
    ; 159 // Следующая строка карты
    ; 160 ex(bc, de, hl);
    exx
    ; 161 e` = b`;
    ld   e, b
    ; 162 d`++;
    inc  d
    ; 163 ex(bc, de, hl);
    exx
    ; 165 // Адрес следующей чб строки на экране
    ; 166 hl += (de = 0x20);
    ld   de, 32
    add  hl, de
    ; 167 if (h & 1) hl += (de = [0x800 - 0x100]);
    bit  0, h
    jp   z, l2011
    ld   de, 1792
    add  hl, de
    ; 169 ixh--;
l2011:
    dec  ixh
    ; 170 } while(flag_nz);
    jp   nz, l2007
    ; 172 halt();
    halt
    ; 173 showVisibleVideoPage();
    call showVisibleVideoPage
    ; 175 (a = frame) -= *(hl = &startFrame);
    ld   a, (frame)
    ld   hl, startFrame
    sub  (hl)
    ; 176 printDelay(a);
    call printDelay
    ; 177 }
    ret
    ; 179 uint8_t visibleVideoPage = 0;
visibleVideoPage db 0
    ; 181 void showVisibleVideoPage()
showVisibleVideoPage:
    ; 182 {
    ; 183 a = visibleVideoPage;
    ld   a, (visibleVideoPage)
    ; 184 a |= 0x7;
    or   7
    ; 185 p7FFD = a;
    ld   (p7FFD), a
    ; 186 out(bc = 0x7FFD, a);
    ld   bc, 32765
    out  (c), a
    ; 187 }
    ret
    ; 189 void printDelay(a)
printDelay:
    ; 190 {
    ; 191 push(a)
    ; 192 {
    push af
    ; 193 a = visibleVideoPage;
    ld   a, (visibleVideoPage)
    ; 194 hl = [screenAddr1 + 0x10E0];
    ld   hl, 20704
    ; 195 if (a & PORT_7FFD_SECOND_VIDEO_PAGE)
    bit  3, a
    ; 196 hl = [screenAddr2 + 0x10E0];
    jp   z, l2012
    ld   hl, 53472
    ; 198 push (hl)
l2012:
    ; 199 {
    push hl
    ; 200 fillRect(hl, bc = 0x0101);
    ld   bc, 257
    call fillRect
    ; 201 }
    pop  hl
    ; 202 }
    pop  af
    ; 203 a += 48;
    add  48
    ; 204 drawCharSub(hl, a);
    call drawCharSub
    ; 205 }
    ret

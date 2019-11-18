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
    ; 42 out(bc = 0x7FFD, a = 7);
    ld   bc, 32765
    ld   a, 7
    out  (c), a
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
    ; 79 uint8_t visibleVideoPageX;
visibleVideoPageX db 0
    ; 81 void cityRedraw()
cityRedraw:
    ; 82 {
    ; 83 // Адрес карты / источник
    ; 84 de` = &levelMap; // Можно оптимизировать d` = [&levelMap >> 8], но не поддержвиает компилятор пока
    ld   de, levelMap
    ; 85 e` = a = cityPlayerX;
    ld   a, (cityPlayerX)
    ld   e, a
    ; 86 b` = e`;
    ld   b, e
    ; 88 // Ждем, если активная страница еще не стала видимой
    ; 89 while ((a = visibleVideoPage) & 1);
l2005:
    ld   a, (visibleVideoPage)
    bit  0, a
    jp   z, l2006
    jp   l2005
l2006:
    ; 91 // Адрес видеостраницы / назначение
    ; 92 if (a & 8)
    bit  3, a
    ; 93 {
    jp   z, l2008
    ; 94 hl` = [cacheAddr1 - 1];
    ld   hl, 23295
    ; 95 ex(bc, de, hl);
    exx
    ; 96 de = screenAddr1;
    ld   de, 16384
    ; 97 bc = screenAttrAddr1;
    ld   bc, 22528
    ; 98 }
    ; 99 else
    jp   l2009
l2008:
    ; 100 {
    ; 101 hl` = [cacheAddr2 - 1];
    ld   hl, 56063
    ; 102 ex(bc, de, hl);
    exx
    ; 103 de = screenAddr2;
    ld   de, 49152
    ; 104 bc = screenAttrAddr2;
    ld   bc, 55296
    ; 105 }
l2009:
    ; 107 // Оценка времени
    ; 108 startFrame = a = frame;
    ld   a, (frame)
    ld   (startFrame), a
    ; 110 // Цикл строк
    ; 111 ixh = viewHeight;
    ld   ixh, 20
    ; 112 do
l2010:
    ; 113 {
    ; 114 // Сохранение адреса вывода
    ; 115 iyl = e;
    ld   iyl, e
    ; 116 iyh = d;
    ld   iyh, d
    ; 118 // Цикл стобцов
    ; 119 ixl = viewWidth;
    ld   ixl, 32
    ; 120 do
l2011:
    ; 121 {
    ; 122 optimize0:  // Чтение номера тейла из карты уровня
optimize0:
    ; 123 ex(bc, de, hl);
    exx
    ; 124 hl`++;
    inc  hl
    ; 125 a = *de`;
    ld   a, (de)
    ; 126 e`++;
    inc  e
    ; 127 if (a == *hl`) goto optimize1;
    cp   (hl)
    jp   z, optimize1
    ; 128 *hl` = a;
    ld   (hl), a
    ; 129 ex(bc, de, hl);
    exx
    ; 131 // Вычисление адреса тейла
    ; 132 h = &levelTailsHigh;
    ld   h, levelTailsHigh
    ; 133 l = a;
    ld   l, a
    ; 135 // Вывод на экран
    ; 136 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 137 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 138 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 139 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 140 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 141 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 142 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 143 a = *hl; h++; *de = a;
    ld   a, (hl)
    inc  h
    ld   (de), a
    ; 144 a = *hl;      *bc = a; bc++;
    ld   a, (hl)
    ld   (bc), a
    inc  bc
    ; 146 d = iyh;
    ld   d, iyh
    ; 147 e++;
    inc  e
    ; 148 ixl--;
    dec  ixl
    ; 149 } while(flag_nz);
    jp   nz, l2011
    ; 150 optimize2:
optimize2:
    ; 152 // Следующая строка карты
    ; 153 ex(bc, de, hl);
    exx
    ; 154 e` = b`;
    ld   e, b
    ; 155 d`++;
    inc  d
    ; 156 ex(bc, de, hl);
    exx
    ; 158 // Адрес следующей чб строки на экране
    ; 159 e = ((a = iyl) += 0x20);
    ld   a, iyl
    add  32
    ld   e, a
    ; 160 if (flag_c) d = ((a = d) += 0x08);
    jp   nc, l2012
    ld   a, d
    add  8
    ld   d, a
    ; 162 ixh--;
l2012:
    dec  ixh
    ; 163 } while(flag_nz);
    jp   nz, l2010
    ; 165 // Переключить видеостраницы во время следующего прерывания
    ; 166 visibleVideoPage = ((a = visibleVideoPage) ^= 8 |= 1);
    ld   a, (visibleVideoPage)
    xor  8
    or   1
    ld   (visibleVideoPage), a
    ; 168 // Оценка времени
    ; 169 printDelay((a = frame) -= *(hl = &startFrame));
    ld   a, (frame)
    ld   hl, startFrame
    sub  (hl)
    call printDelay
    ; 171 return;
    ret
    ; 172 optimize1:
optimize1:
    ; 173 ex(bc, de, hl);
    exx
    ; 174 bc++;
    inc  bc
    ; 175 e++;
    inc  e
    ; 176 ixl--;
    dec  ixl
    ; 177 if(flag_nz) goto optimize0;
    jp   nz, optimize0
    ; 178 goto optimize2;
    jp   optimize2
    ; 179 }
    ret
    ; 181 uint8_t visibleVideoPage = 0;
visibleVideoPage db 0
    ; 183 void printDelay(a)
printDelay:
    ; 184 {
    ; 185 push(a)
    ; 186 {
    push af
    ; 187 // Активная видеостраница
    ; 188 a = visibleVideoPage;
    ld   a, (visibleVideoPage)
    ; 189 hl = [screenAddr1 + 0x10E0];
    ld   hl, 20704
    ; 190 if (a & PORT_7FFD_SECOND_VIDEO_PAGE)
    bit  3, a
    ; 191 hl = [screenAddr2 + 0x10E0];
    jp   z, l2013
    ld   hl, 53472
    ; 193 // Очиска
    ; 194 push (hl)
l2013:
    ; 195 {
    push hl
    ; 196 fillRect(hl, bc = 0x0101);
    ld   bc, 257
    call fillRect
    ; 197 }
    pop  hl
    ; 198 }
    pop  af
    ; 199 a += '0';
    add  48
    ; 200 drawCharSub(hl, a);
    call drawCharSub
    ; 201 }
    ret

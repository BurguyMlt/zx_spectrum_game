    ; 2 const int KEY_DOWN = 2;
    ; 3 const int KEY_LEFT = 4;
    ; 4 const int KEY_RIGHT = 8;
    ; 5 const int KEY_FIRE = 16;
    ; 7 // 3 - фиолетовый
    ; 9 const int colorCursor = 0x43;
    ; 10 const int colorText   = 0x47;
    ; 11 const int colorItem   = 0x45;
    ; 12 const int colorPrice  = 0x44;
    ; 14 uint16_t shopText;
shopText dw 0
    ; 15 uint16_t shopGetLine;
shopGetLine dw 0
    ; 16 uint8_t shopX;
shopX db 0
    ; 17 uint8_t shopY;
shopY db 0
    ; 18 uint8_t shopW;
shopW db 0
    ; 19 uint8_t shopH;
shopH db 0
    ; 20 const int shopLineHeight = 10;
    ; 21 uint16_t dialogCursor;
dialogCursor dw 0
    ; 22 uint8_t dialogX;
dialogX db 0
    ; 23 uint8_t dialogX1;
dialogX1 db 0
    ; 25 //---------------------------------------------------------------------------------------------------------------------
    ; 26 // Вход: ix - функция динамического текста, iyh - режим, de - указатель на текст
    ; 27 // Вход: de - указатель на следующий текст, iyh - новый режим
    ; 28 // Сохраняет: hl, ix, iyl
    ; 30 void shopNextLine()
shopNextLine:
    ; 31 {
    ; 32 // Вывод статического текста
    ; 33 if (flag_z (a = iyh) & 0x80)
    ld   a, iyh
    bit  7, a
    ; 34 {
    jp   nz, l0
    ; 35 do { a = *de; de++; } while(a >= 32);
l1:
    ld   a, (de)
    inc  de
    cp   32
    jp   nc, l1
l2:
    ; 36 if (flag_nz a |= a) return; // nz
    or   a
    ret  nz
    ; 37 // Переход к динамическому тексту
    ; 38 iyh = 0x80;
    ld   iyh, 128
    ; 39 }
    ; 40 // Вывод динамического текста
    ; 41 if (flag_z a |= ixl) return; // z
l0:
    or   ixl
    ret  z
    ; 42 (a = iyh) &= 0x7F; iyh++;
    ld   a, iyh
    and  127
    inc  iyh
    ; 43 push(hl)
    ; 44 {
    push hl
    ; 45 callIx(); // Вход: a - номер. Выход: hl - текст. Портит: a, bc, de
    call callIx
    ; 46 ex(hl, de);
    ex de, hl
    ; 47 }
    pop  hl
    ; 48 (a = d) |= e; // return z/nz
    ld   a, d
    or   e
    ; 49 }
    ret
    ; 51 //---------------------------------------------------------------------------------------------------------------------
    ; 52 // Алгоритм диалога
    ; 54 const int tailSize = 8;
    ; 55 const int shopTopPadding = 4;
    ; 56 const int shopAnswerSeparatorHeight = 4;
    ; 58 void shopStart(de, ix)
shopStart:
    ; 59 {
    ; 60 shopText = de;
    ld   (shopText), de
    ; 61 shopGetLine = ix;
    ld   (shopGetLine), ix
    ; 63 // ВЫЧИСЛЕНИЕ РАЗМЕРА
    ; 65 ex(bc, de, hl);
    exx
    ; 66 hl` = 0; // h` - ширина цен, l` - ширина товаров
    ld   hl, 0
    ; 67 ex(bc, de, hl);
    exx
    ; 68 hl = shopTopPadding; // h - ширина назчаний, l - высота всех элементов
    ld   hl, 4
    ; 69 iy = 0; // iyl - режим ответов, iyh - режим динамического текста
    ld   iy, 0
    ; 70 // de - указатель на текст
    ; 71 do
l3:
    ; 72 {
    ; 73 push(de)
    ; 74 {
    push de
    ; 75 push(hl)
    ; 76 {
    push hl
    ; 77 gMeasureText(); // Вход: de - текст. Выход: de - текст, a - терминатор, c - ширина в пикселях. Портит: b, hl.
    call gMeasureText
    ; 78 }
    pop  hl
    ; 80 ex(a); // Сохраняем термиатор
    ex   af, af
    ; 81 a = c;
    ld   a, c
    ; 82 if (a != 0)
    or   a
    ; 83 {
    jp   z, l5
    ; 84 a += iyl; // Добавляем отступ ответов
    add  iyl
    ; 85 ex(a);
    ex   af, af
    ; 86 if (a == 9) // Если есть цена
    cp   9
    ; 87 {
    jp   nz, l6
    ; 88 ex(bc, de, hl);
    exx
    ; 89 ex(a);
    ex   af, af
    ; 90 if (a >= l`) l` = a;  // Вычисляем максимальную ширину
    cp   l
    jp   c, l7
    ld   l, a
    ; 91 ex(bc, de, hl);
l7:
    exx
    ; 93 push(hl)
    ; 94 {
    push hl
    ; 95 gMeasureText();
    call gMeasureText
    ; 96 }
    pop  hl
    ; 97 // Учет ширины и высоты
    ; 99 ex(a); // Сохраняем термиатор
    ex   af, af
    ; 100 a = c;
    ld   a, c
    ; 101 ex(bc, de, hl);
    exx
    ; 102 if (a >= h`) h` = a;  // Вычисляем максимальную ширину
    cp   h
    jp   c, l8
    ld   h, a
    ; 103 ex(bc, de, hl);
l8:
    exx
    ; 104 }
    ; 105 else
    jp   l9
l6:
    ; 106 {
    ; 107 ex(a);
    ex   af, af
    ; 108 if (a >= h) h = a; // Вычисляем максимальную ширину
    cp   h
    jp   c, l10
    ld   h, a
    ; 109 }
l10:
l9:
    ; 110 l = ((a = l) += shopLineHeight); // Вычисляем высоту
    ld   a, l
    add  10
    ld   l, a
    ; 111 }
    ; 112 ex(a);
l5:
    ex   af, af
    ; 114 // Если строка оканчивается кодом 13, то далее идут ответы
    ; 115 if (a == 13)
    cp   13
    ; 116 {
    jp   nz, l11
    ; 117 iyl = tailSize; // Отступ для ответов
    ld   iyl, 8
    ; 118 l = ((a = l) += [shopAnswerSeparatorHeight]); // Отступ ответов. Это примерно половина высота строки. Это гарантирует отсутсвтие клешинга.
    ld   a, l
    add  4
    ld   l, a
    ; 119 }
    ; 120 }
l11:
    pop  de
    ; 122 // Следующая строка
    ; 123 shopNextLine();
    call shopNextLine
    ; 124 } while(flag_nz);
    jp   nz, l3
l4:
    ; 126 // Преобразование пикселей в знакоместа
    ; 127 ex(bc, de, hl);
    exx
    ; 128 a = h`;
    ld   a, h
    ; 129 if (flag_nz a |= a) a += tailSize; // Если есть цена, то добавляем разделитель в одно знакоместо между наименованием и ценой.
    or   a
    jp   z, l12
    add  8
    ; 130 a += l`; // Суммируем ширину наименований и цен
l12:
    add  l
    ; 131 ex(bc, de, hl);
    exx
    ; 132 if (a < h) a = h;
    cp   h
    jp   nc, l13
    ld   a, h
    ; 134 h = ((a += 7) >>= 3); shopW = a; // Преобразуем в знакоместа
l13:
    add  7
    srl  a
    srl  a
    srl  a
    ld   h, a
    ld   (shopW), a
    ; 135 l = (((a = l) += 7) >>= 3); shopH = a; // Преобразуем в знакоместа
    ld   a, l
    add  7
    srl  a
    srl  a
    srl  a
    ld   l, a
    ld   (shopH), a
    ; 136 shopX = (((a = [32 - 2]) -= h) >>= 1); // Вычисляем положение диалога
    ld   a, 30
    sub  h
    srl  a
    ld   (shopX), a
    ; 137 shopY = (((a = [20 - 3]) -= l) >>= 1);
    ld   a, 17
    sub  l
    srl  a
    ld   (shopY), a
    ; 139 // РИСОВАНИЕ
    ; 141 // Выбираем 0-ую страницу для рисования
    ; 142 gBeginDraw();
    call gBeginDraw
    ; 143 gFarCall(iyl = 7, ix = &gPanelRedraw);
    ld   iyl, 7
    ld   ix, gPanelRedraw
    call gFarCall
    ; 145 // Рисуем рамку
    ; 146 hl = shopX; // И за одно shopY
    ld   hl, (shopX)
    ; 147 calcAddr(); // bc - чб, hl = цвет
    call calcAddr
    ; 148 iy = shopW; // И за одно shopH
    ld   iy, (shopW)
    ; 149 drawDialog2(de = &dialogrect_0, bc, hl, iyl);
    ld   de, dialogrect_0
    call drawDialog2
    ; 150 do
l14:
    ; 151 {
    ; 152 drawDialog2(de = &dialogrect_3, bc, hl, iyl);
    ld   de, dialogrect_3
    call drawDialog2
    ; 153 } while(flag_nz --iyh);
    dec  iyh
    jp   nz, l14
l15:
    ; 154 drawDialog2(de = &dialogrect_6, bc, hl, iyl);
    ld   de, dialogrect_6
    call drawDialog2
    ; 155 drawSprite2(bc, de, hl);
    call drawSprite2
    ; 157 *[&shopStartColor + 1] = a = colorText;
    ld   a, 71
    ld   ((shopStartColor) + (1)), a
    ; 158 // Рисуем текст
    ; 159 ix = shopGetLine;  // ix - функция динамического текста
    ld   ix, (shopGetLine)
    ; 160 de = shopText;     // de - статический текст
    ld   de, (shopText)
    ; 161 hl = shopX;        // hl - Координаты для вывода текста в знакоместах
    ld   hl, (shopX)
    ; 162 (((hl += hl) += hl) += hl) += (bc = [(tailSize + shopTopPadding) * 256 + tailSize]); // Вычисляем координаты в внутри рамки в пикселях
    add  hl, hl
    add  hl, hl
    add  hl, hl
    ld   bc, 3080
    add  hl, bc
    ; 163 dialogCursor = hl; // hl - координаты первого ответа (что бы не было глюка, если программист забудет в диалоге описать варианты ответов)
    ld   (dialogCursor), hl
    ; 164 iy = 0;            // iyl - кол-во ответов, iyh - режим динамического текста
    ld   iy, 0
    ; 165 do
l16:
    ; 166 {
    ; 167 a = *de;
    ld   a, (de)
    ; 168 if (a >= ' ')
    cp   32
    ; 169 {
    jp   c, l18
    ; 170 push(de)
    ; 171 {
    push de
    ; 172 push(hl)
    ; 173 {
    push hl
    ; 174 shopStartColor: a = colorText;
shopStartColor:
    ld   a, 71
    ; 175 gDrawTextEx(hl, de, a); // Выводим наименование
    call gDrawTextEx
    ; 176 }
    pop  hl
    ; 177 if (a == 9)
    cp   9
    ; 178 {
    jp   nz, l19
    ; 179 push(hl)
    ; 180 {
    push hl
    ; 181 push(de, hl)
    ; 182 {
    push de
    push hl
    ; 183 gMeasureText(); // Вычисляем ширину цены, что бы прижать её к правому краю
    call gMeasureText
    ; 184 }
    pop  hl
    pop  de
    ; 185 l = a = shopW;
    ld   a, (shopW)
    ld   l, a
    ; 186 (a = shopX) += l;
    ld   a, (shopX)
    add  l
    ; 187 a++;
    inc  a
    ; 188 a <<= 3;
    sla  a
    sla  a
    sla  a
    ; 189 l = (a -= c);
    sub  c
    ld   l, a
    ; 190 gDrawTextEx(hl, de, a = colorPrice); // Выводим цену
    ld   a, 68
    call gDrawTextEx
    ; 191 }
    pop  hl
    ; 192 }
    ; 193 }
l19:
    pop  de
    ; 194 hl += (bc = [shopLineHeight * 256]);
    ld   bc, 2560
    add  hl, bc
    ; 195 }
    ; 196 if (a == 13)
l18:
    cp   13
    ; 197 {
    jp   nz, l20
    ; 198 h = ((a = h) += shopAnswerSeparatorHeight); // Если есть цена, то добавляем разделитель в одно знакоместо между наименованием и ценой.
    ld   a, h
    add  4
    ld   h, a
    ; 199 dialogCursor = hl; // Координаты первого ответа
    ld   (dialogCursor), hl
    ; 200 l = ((a = l) += tailSize); // Отступ для ответов
    ld   a, l
    add  8
    ld   l, a
    ; 201 iyl = -1; // Сброс счетчика кол-ва ответов
    ld   iyl, -1
    ; 202 *[&shopStartColor + 1] = a = colorItem;
    ld   a, 69
    ld   ((shopStartColor) + (1)), a
    ; 203 }
    ; 204 iyl++; // Счетчик кол-ва ответов
l20:
    inc  iyl
    ; 205 shopNextLine();
    call shopNextLine
    ; 206 } while(flag_nz);
    jp   nz, l16
l17:
    ; 208 // Начальное положение курсора
    ; 209 dialogX = (a ^= a);
    xor  a
    ld   (dialogX), a
    ; 210 dialogX1 = a;
    ld   (dialogX1), a
    ; 212 // Рисуем курсор
    ; 213 dialogDrawCursor();
    call dialogDrawCursor
    ; 215 // Выводим на экран
    ; 216 gEndDraw();
    call gEndDraw
    ; 218 // Клавиатура
    ; 219 while()
l21:
    ; 220 {
    ; 221 // Ждем, если прошло меньше 1/50 сек с прошлого цикла.
    ; 222 while ((a = gVideoPage) & 1);
l23:
    ld   a, (gVideoPage)
    bit  0, a
    jp   z, l24
    jp   l23
l24:
    ; 223 gVideoPage = (a |= 1);
    or   1
    ld   (gVideoPage), a
    ; 225 // Получить нажатую клавишу
    ; 226 hl = &gKeyTrigger;
    ld   hl, gKeyTrigger
    ; 227 b = *hl;
    ld   b, (hl)
    ; 228 *hl = 0;
    ld   (hl), 0
    ; 230 // Нажат выстрел
    ; 231 if (b & KEY_FIRE)
    bit  4, b
    ; 232 {
    jp   z, l25
    ; 233 // Отмечаем, что весь экран нужно перерисовать и выходим
    ; 234 gFarCall(iyl = 7, ix = &gCopyVideoPage);
    ld   iyl, 7
    ld   ix, gCopyVideoPage
    call gFarCall
    ; 235 a = dialogX;
    ld   a, (dialogX)
    ; 236 return;
    ret
    ; 237 }
    ; 239 // Перемещение курсора
    ; 240 a = dialogX;
l25:
    ld   a, (dialogX)
    ; 241 if (b & KEY_UP)
    bit  0, b
    ; 242 {
    jp   z, l26
    ; 243 a -= 1;
    sub  1
    ; 244 if (flag_c) continue;
    jp   c, l21
    ; 245 }
    ; 246 else if (b & KEY_DOWN)
    jp   l27
l26:
    bit  1, b
    ; 247 {
    jp   z, l28
    ; 248 a++;
    inc  a
    ; 249 if (a >= iyl) continue;
    cp   iyl
    jp   nc, l21
    ; 250 }
    ; 251 dialogX = a;
l28:
l27:
    ld   (dialogX), a
    ; 253 // Умножение на 10
    ; 254 c = (a += a);
    add  a
    ld   c, a
    ; 255 ((a += a) += a) += c;
    add  a
    add  a
    add  c
    ; 257 // Плавное перемещение курсора
    ; 258 hl = &dialogX1;
    ld   hl, dialogX1
    ; 259 b = *hl;
    ld   b, (hl)
    ; 260 if (a == b) continue; // Оставит флаг CF при выполнении dialogX1 - menuX
    cp   b
    jp   z, l21
    ; 261 b++; // Не изменяет CF
    inc  b
    ; 262 if (flag_c) ----b;
    jp   nc, l29
    dec  b
    dec  b
    ; 264 // Стираем прошлый курсор
    ; 265 push(bc);
l29:
    push bc
    ; 266 dialogDrawCursor();
    call dialogDrawCursor
    ; 267 pop(bc);
    pop  bc
    ; 269 // Сохраняем новые координаты курсора
    ; 270 *(hl = &dialogX1) = b;
    ld   hl, dialogX1
    ld   (hl), b
    ; 272 // Рисуем курсор
    ; 273 dialogDrawCursor();
    call dialogDrawCursor
    ; 274 }
    jp   l21
l22:
    ; 275 }
    ret
    ; 277 void dialogDrawCursor()
dialogDrawCursor:
    ; 278 {
    ; 279 hl = dialogCursor;
    ld   hl, (dialogCursor)
    ; 280 h = ((a = dialogX1) += h);
    ld   a, (dialogX1)
    add  h
    ld   h, a
    ; 281 gDrawTextEx(hl, de = "@", a = colorCursor);
    ld   de, s0
    ld   a, 67
    call gDrawTextEx
    ; 282 }
    ret
    ; 284 void drawDialog2()
drawDialog2:
    ; 285 {
    ; 286 push(bc, hl)
    ; 287 {
    push bc
    push hl
    ; 288 drawSprite2();
    call drawSprite2
    ; 289 a = iyl;
    ld   a, iyl
    ; 290 ix = de;
    ld   ixh, d
    ld   ixl, e
    ; 291 do
l30:
    ; 292 {
    ; 293 ex(a);
    ex   af, af
    ; 294 d = ixh; e = ixl;
    ld   d, ixh
    ld   e, ixl
    ; 295 drawSprite2();
    call drawSprite2
    ; 296 ex(a);
    ex   af, af
    ; 297 } while(flag_nz --a);
    dec  a
    jp   nz, l30
l31:
    ; 298 drawSprite2();
    call drawSprite2
    ; 299 }
    pop  hl
    pop  bc
    ; 300 // Следующая строка
    ; 301 l = ((a = l) += 32); h = ((a +@= h) -= l);
    ld   a, l
    add  32
    ld   l, a
    adc  h
    sub  l
    ld   h, a
    ; 302 c = ((a = c) += 32); if (flag_c) b = ((a = b) += 8);
    ld   a, c
    add  32
    ld   c, a
    jp   nc, l32
    ld   a, b
    add  8
    ld   b, a
    ; 303 }
l32:
    ret
    ; 305 // Вход:
    ; 306 //   l - x
    ; 307 //   h - y
    ; 308 //   hl - цветной адрес
    ; 309 //   bc - чб адрес
    ; 311 void calcAddr()
calcAddr:
    ; 312 {
    ; 313 //        43210     43210
    ; 314 // bc  .1.43...  210.....
    ; 315 // hl  .1.11.43  210.....
    ; 316 b = (((a = h) &= 0x18) |= 0x40);
    ld   a, h
    and  24
    or   64
    ld   b, a
    ; 317 h = ((a = h) >>r= 3);
    ld   a, h
    rrca
    rrca
    rrca
    ld   h, a
    ; 318 c = l = ((a &= 0xE0) |= l);
    and  224
    or   l
    ld   l, a
    ld   c, l
    ; 319 h = (((a = h) &= 0x03) |= 0x58);
    ld   a, h
    and  3
    or   88
    ld   h, a
    ; 321 if (flag_z (a = gVideoPage) & 0x80) return;
    ld   a, (gVideoPage)
    bit  7, a
    ret  z
    ; 322 h |= 0x80;
    set  7, h
    ; 323 b |= 0x80;
    set  7, b
    ; 324 }
    ret
    ; strings
s0 db "@",0

    ; dialog/alg.c:2 
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
    ; dialog/alg.c:3 const int colorCursor = 0x43;
    ; dialog/alg.c:4 const int colorText   = 0x47;
    ; dialog/alg.c:5 const int colorItem   = 0x45;
    ; dialog/alg.c:6 const int colorPrice  = 0x44;
    ; dialog/alg.c:7 
    ; dialog/alg.c:8 uint16_t shopText;
shopText dw 0
    ; dialog/alg.c:9 uint16_t shopGetLine;
shopGetLine dw 0
    ; dialog/alg.c:10 uint8_t shopX;
shopX db 0
    ; dialog/alg.c:11 uint8_t shopY;
shopY db 0
    ; dialog/alg.c:12 uint8_t shopW;
shopW db 0
    ; dialog/alg.c:13 uint8_t shopH;
shopH db 0
    ; dialog/alg.c:14 const int shopLineHeight = 10;
    ; dialog/alg.c:15 uint16_t dialogCursor;
dialogCursor dw 0
    ; dialog/alg.c:16 uint8_t dialogX;
dialogX db 0
    ; dialog/alg.c:17 uint8_t dialogX1;
dialogX1 db 0
    ; dialog/alg.c:18 
    ; dialog/alg.c:19 //---------------------------------------------------------------------------------------------------------------------
    ; dialog/alg.c:20 // Вход: ix - функция динамического текста, iyh - режим, de - указатель на текст
    ; dialog/alg.c:21 // Вход: de - указатель на следующий текст, iyh - новый режим
    ; dialog/alg.c:22 // Сохраняет: hl, ix, iyl
    ; dialog/alg.c:23 
    ; dialog/alg.c:24 void shopNextLine()
shopNextLine:
    ; dialog/alg.c:25 {
    ; dialog/alg.c:26 // Вывод статического текста
    ; dialog/alg.c:27 if (flag_z (a = iyh) & 0x80)
    ld   a, iyh
    bit  7, a
    ; dialog/alg.c:28 {
    jp   nz, l0
    ; dialog/alg.c:29 do { a = *de; de++; } while(a >= 32);
l1:
    ld   a, (de)
    inc  de
    cp   32
    jp   nc, l1
l2:
    ; dialog/alg.c:30 if (flag_nz a |= a) return; // nz
    or   a
    ret  nz
    ; dialog/alg.c:31 // Переход к динамическому тексту
    ; dialog/alg.c:32 iyh = 0x80;
    ld   iyh, 128
    ; dialog/alg.c:33 }
    ; dialog/alg.c:34 // Вывод динамического текста
    ; dialog/alg.c:35 if (flag_z a |= ixl) return; // z
l0:
    or   ixl
    ret  z
    ; dialog/alg.c:36 (a = iyh) &= 0x7F; iyh++;
    ld   a, iyh
    and  127
    inc  iyh
    ; dialog/alg.c:37 push(hl)
    ; dialog/alg.c:38 {
    push hl
    ; dialog/alg.c:39 callIx(); // Вход: a - номер. Выход: hl - текст. Портит: a, bc, de
    call callIx
    ; dialog/alg.c:40 ex(hl, de);
    ex de, hl
    ; dialog/alg.c:41 }
    pop  hl
    ; dialog/alg.c:42 (a = d) |= e; // return z/nz
    ld   a, d
    or   e
    ; dialog/alg.c:43 }
    ret
    ; dialog/alg.c:44 
    ; dialog/alg.c:45 //---------------------------------------------------------------------------------------------------------------------
    ; dialog/alg.c:46 // Алгоритм диалога
    ; dialog/alg.c:47 
    ; dialog/alg.c:48 const int tailSize = 8;
    ; dialog/alg.c:49 const int shopTopPadding = 4;
    ; dialog/alg.c:50 const int shopAnswerSeparatorHeight = 4;
    ; dialog/alg.c:51 
    ; dialog/alg.c:52 void shopStart(de, ix)
shopStart:
    ; dialog/alg.c:53 {
    ; dialog/alg.c:54 shopText = de;
    ld   (shopText), de
    ; dialog/alg.c:55 shopGetLine = ix;
    ld   (shopGetLine), ix
    ; dialog/alg.c:56 
    ; dialog/alg.c:57 // ВЫЧИСЛЕНИЕ РАЗМЕРА
    ; dialog/alg.c:58 
    ; dialog/alg.c:59 ex(bc, de, hl);
    exx
    ; dialog/alg.c:60 hl` = 0; // h` - ширина цен, l` - ширина товаров
    ld   hl, 0
    ; dialog/alg.c:61 ex(bc, de, hl);
    exx
    ; dialog/alg.c:62 hl = shopTopPadding; // h - ширина назчаний, l - высота всех элементов
    ld   hl, 4
    ; dialog/alg.c:63 iy = 0; // iyl - режим ответов, iyh - режим динамического текста
    ld   iy, 0
    ; dialog/alg.c:64 // de - указатель на текст
    ; dialog/alg.c:65 do
l3:
    ; dialog/alg.c:66 {
    ; dialog/alg.c:67 push(de)
    ; dialog/alg.c:68 {
    push de
    ; dialog/alg.c:69 push(hl)
    ; dialog/alg.c:70 {
    push hl
    ; dialog/alg.c:71 gMeasureText(); // Вход: de - текст. Выход: de - текст, a - терминатор, c - ширина в пикселях. Портит: b, hl.
    call gMeasureText
    ; dialog/alg.c:72 }
    pop  hl
    ; dialog/alg.c:73 
    ; dialog/alg.c:74 ex(a); // Сохраняем термиатор
    ex   af, af
    ; dialog/alg.c:75 a = c;
    ld   a, c
    ; dialog/alg.c:76 if (a != 0)
    or   a
    ; dialog/alg.c:77 {
    jp   z, l5
    ; dialog/alg.c:78 a += iyl; // Добавляем отступ ответов
    add  iyl
    ; dialog/alg.c:79 ex(a);
    ex   af, af
    ; dialog/alg.c:80 if (a == 9) // Если есть цена
    cp   9
    ; dialog/alg.c:81 {
    jp   nz, l6
    ; dialog/alg.c:82 ex(bc, de, hl);
    exx
    ; dialog/alg.c:83 ex(a);
    ex   af, af
    ; dialog/alg.c:84 if (a >= l`) l` = a;  // Вычисляем максимальную ширину
    cp   l
    jp   c, l7
    ld   l, a
    ; dialog/alg.c:85 ex(bc, de, hl);
l7:
    exx
    ; dialog/alg.c:86 
    ; dialog/alg.c:87 push(hl)
    ; dialog/alg.c:88 {
    push hl
    ; dialog/alg.c:89 gMeasureText();
    call gMeasureText
    ; dialog/alg.c:90 }
    pop  hl
    ; dialog/alg.c:91 // Учет ширины и высоты
    ; dialog/alg.c:92 
    ; dialog/alg.c:93 ex(a); // Сохраняем термиатор
    ex   af, af
    ; dialog/alg.c:94 a = c;
    ld   a, c
    ; dialog/alg.c:95 ex(bc, de, hl);
    exx
    ; dialog/alg.c:96 if (a >= h`) h` = a;  // Вычисляем максимальную ширину
    cp   h
    jp   c, l8
    ld   h, a
    ; dialog/alg.c:97 ex(bc, de, hl);
l8:
    exx
    ; dialog/alg.c:98 }
    ; dialog/alg.c:99 else
    jp   l9
l6:
    ; dialog/alg.c:100 {
    ; dialog/alg.c:101 ex(a);
    ex   af, af
    ; dialog/alg.c:102 if (a >= h) h = a; // Вычисляем максимальную ширину
    cp   h
    jp   c, l10
    ld   h, a
    ; dialog/alg.c:103 }
l10:
l9:
    ; dialog/alg.c:104 l = ((a = l) += shopLineHeight); // Вычисляем высоту
    ld   a, l
    add  10
    ld   l, a
    ; dialog/alg.c:105 }
    ; dialog/alg.c:106 ex(a);
l5:
    ex   af, af
    ; dialog/alg.c:107 
    ; dialog/alg.c:108 // Если строка оканчивается кодом 13, то далее идут ответы
    ; dialog/alg.c:109 if (a == 13)
    cp   13
    ; dialog/alg.c:110 {
    jp   nz, l11
    ; dialog/alg.c:111 iyl = tailSize; // Отступ для ответов
    ld   iyl, 8
    ; dialog/alg.c:112 l = ((a = l) += [shopAnswerSeparatorHeight]); // Отступ ответов. Это примерно половина высота строки. Это гарантирует отсутсвтие клешинга.
    ld   a, l
    add  4
    ld   l, a
    ; dialog/alg.c:113 }
    ; dialog/alg.c:114 }
l11:
    pop  de
    ; dialog/alg.c:115 
    ; dialog/alg.c:116 // Следующая строка
    ; dialog/alg.c:117 shopNextLine();
    call shopNextLine
    ; dialog/alg.c:118 } while(flag_nz);
    jp   nz, l3
l4:
    ; dialog/alg.c:119 
    ; dialog/alg.c:120 // Преобразование пикселей в знакоместа
    ; dialog/alg.c:121 ex(bc, de, hl);
    exx
    ; dialog/alg.c:122 a = h`;
    ld   a, h
    ; dialog/alg.c:123 if (flag_nz a |= a) a += tailSize; // Если есть цена, то добавляем разделитель в одно знакоместо между наименованием и ценой.
    or   a
    jp   z, l12
    add  8
    ; dialog/alg.c:124 a += l`; // Суммируем ширину наименований и цен
l12:
    add  l
    ; dialog/alg.c:125 ex(bc, de, hl);
    exx
    ; dialog/alg.c:126 if (a < h) a = h;
    cp   h
    jp   nc, l13
    ld   a, h
    ; dialog/alg.c:127 
    ; dialog/alg.c:128 h = ((a += 7) >>= 3); shopW = a; // Преобразуем в знакоместа
l13:
    add  7
    srl  a
    srl  a
    srl  a
    ld   h, a
    ld   (shopW), a
    ; dialog/alg.c:129 l = (((a = l) += 7) >>= 3); shopH = a; // Преобразуем в знакоместа
    ld   a, l
    add  7
    srl  a
    srl  a
    srl  a
    ld   l, a
    ld   (shopH), a
    ; dialog/alg.c:130 shopX = (((a = [32 - 2]) -= h) >>= 1); // Вычисляем положение диалога
    ld   a, 30
    sub  h
    srl  a
    ld   (shopX), a
    ; dialog/alg.c:131 shopY = (((a = [20 - 3]) -= l) >>= 1);
    ld   a, 17
    sub  l
    srl  a
    ld   (shopY), a
    ; dialog/alg.c:132 
    ; dialog/alg.c:133 // РИСОВАНИЕ
    ; dialog/alg.c:134 
    ; dialog/alg.c:135 // Выбираем 0-ую страницу для рисования
    ; dialog/alg.c:136 gBeginDraw();
    call gBeginDraw
    ; dialog/alg.c:137 gFarCall(iyl = 7, ix = &gPanelRedraw);
    ld   iyl, 7
    ld   ix, gPanelRedraw
    call gFarCall
    ; dialog/alg.c:138 
    ; dialog/alg.c:139 // Рисуем рамку
    ; dialog/alg.c:140 hl = shopX; // И за одно shopY
    ld   hl, (shopX)
    ; dialog/alg.c:141 calcAddr(); // bc - чб, hl = цвет
    call calcAddr
    ; dialog/alg.c:142 iy = shopW; // И за одно shopH
    ld   iy, (shopW)
    ; dialog/alg.c:143 drawDialog2(de = &dialogrect_0, bc, hl, iyl);
    ld   de, dialogrect_0
    call drawDialog2
    ; dialog/alg.c:144 do
l14:
    ; dialog/alg.c:145 {
    ; dialog/alg.c:146 drawDialog2(de = &dialogrect_3, bc, hl, iyl);
    ld   de, dialogrect_3
    call drawDialog2
    ; dialog/alg.c:147 } while(flag_nz --iyh);
    dec  iyh
    jp   nz, l14
l15:
    ; dialog/alg.c:148 drawDialog2(de = &dialogrect_6, bc, hl, iyl);
    ld   de, dialogrect_6
    call drawDialog2
    ; dialog/alg.c:149 drawSprite2(bc, de, hl);
    call drawSprite2
    ; dialog/alg.c:150 
    ; dialog/alg.c:151 *[&shopStartColor + 1] = a = colorText;
    ld   a, 71
    ld   ((shopStartColor) + (1)), a
    ; dialog/alg.c:152 // Рисуем текст
    ; dialog/alg.c:153 ix = shopGetLine;  // ix - функция динамического текста
    ld   ix, (shopGetLine)
    ; dialog/alg.c:154 de = shopText;     // de - статический текст
    ld   de, (shopText)
    ; dialog/alg.c:155 hl = shopX;        // hl - Координаты для вывода текста в знакоместах
    ld   hl, (shopX)
    ; dialog/alg.c:156 (((hl += hl) += hl) += hl) += (bc = [(tailSize + shopTopPadding) * 256 + tailSize]); // Вычисляем координаты в внутри рамки в пикселях
    add  hl, hl
    add  hl, hl
    add  hl, hl
    ld   bc, 3080
    add  hl, bc
    ; dialog/alg.c:157 dialogCursor = hl; // hl - координаты первого ответа (что бы не было глюка, если программист забудет в диалоге описать варианты ответов)
    ld   (dialogCursor), hl
    ; dialog/alg.c:158 iy = 0;            // iyl - кол-во ответов, iyh - режим динамического текста
    ld   iy, 0
    ; dialog/alg.c:159 do
l16:
    ; dialog/alg.c:160 {
    ; dialog/alg.c:161 a = *de;
    ld   a, (de)
    ; dialog/alg.c:162 if (a >= ' ')
    cp   32
    ; dialog/alg.c:163 {
    jp   c, l18
    ; dialog/alg.c:164 push(de)
    ; dialog/alg.c:165 {
    push de
    ; dialog/alg.c:166 push(hl)
    ; dialog/alg.c:167 {
    push hl
    ; dialog/alg.c:168 shopStartColor: a = colorText;
shopStartColor:
    ld   a, 71
    ; dialog/alg.c:169 gDrawTextEx(hl, de, a); // Выводим наименование
    call gDrawTextEx
    ; dialog/alg.c:170 }
    pop  hl
    ; dialog/alg.c:171 if (a == 9)
    cp   9
    ; dialog/alg.c:172 {
    jp   nz, l19
    ; dialog/alg.c:173 push(hl)
    ; dialog/alg.c:174 {
    push hl
    ; dialog/alg.c:175 push(de, hl)
    ; dialog/alg.c:176 {
    push de
    push hl
    ; dialog/alg.c:177 gMeasureText(); // Вычисляем ширину цены, что бы прижать её к правому краю
    call gMeasureText
    ; dialog/alg.c:178 }
    pop  hl
    pop  de
    ; dialog/alg.c:179 l = a = shopW;
    ld   a, (shopW)
    ld   l, a
    ; dialog/alg.c:180 (a = shopX) += l;
    ld   a, (shopX)
    add  l
    ; dialog/alg.c:181 a++;
    inc  a
    ; dialog/alg.c:182 a <<= 3;
    sla  a
    sla  a
    sla  a
    ; dialog/alg.c:183 l = (a -= c);
    sub  c
    ld   l, a
    ; dialog/alg.c:184 gDrawTextEx(hl, de, a = colorPrice); // Выводим цену
    ld   a, 68
    call gDrawTextEx
    ; dialog/alg.c:185 }
    pop  hl
    ; dialog/alg.c:186 }
    ; dialog/alg.c:187 }
l19:
    pop  de
    ; dialog/alg.c:188 hl += (bc = [shopLineHeight * 256]);
    ld   bc, 2560
    add  hl, bc
    ; dialog/alg.c:189 }
    ; dialog/alg.c:190 if (a == 13)
l18:
    cp   13
    ; dialog/alg.c:191 {
    jp   nz, l20
    ; dialog/alg.c:192 h = ((a = h) += shopAnswerSeparatorHeight); // Если есть цена, то добавляем разделитель в одно знакоместо между наименованием и ценой.
    ld   a, h
    add  4
    ld   h, a
    ; dialog/alg.c:193 dialogCursor = hl; // Координаты первого ответа
    ld   (dialogCursor), hl
    ; dialog/alg.c:194 l = ((a = l) += tailSize); // Отступ для ответов
    ld   a, l
    add  8
    ld   l, a
    ; dialog/alg.c:195 iyl = -1; // Сброс счетчика кол-ва ответов
    ld   iyl, -1
    ; dialog/alg.c:196 *[&shopStartColor + 1] = a = colorItem;
    ld   a, 69
    ld   ((shopStartColor) + (1)), a
    ; dialog/alg.c:197 }
    ; dialog/alg.c:198 iyl++; // Счетчик кол-ва ответов
l20:
    inc  iyl
    ; dialog/alg.c:199 shopNextLine();
    call shopNextLine
    ; dialog/alg.c:200 } while(flag_nz);
    jp   nz, l16
l17:
    ; dialog/alg.c:201 
    ; dialog/alg.c:202 // Начальное положение курсора
    ; dialog/alg.c:203 dialogX = (a ^= a);
    xor  a
    ld   (dialogX), a
    ; dialog/alg.c:204 dialogX1 = a;
    ld   (dialogX1), a
    ; dialog/alg.c:205 
    ; dialog/alg.c:206 // Рисуем курсор
    ; dialog/alg.c:207 dialogDrawCursor();
    call dialogDrawCursor
    ; dialog/alg.c:208 
    ; dialog/alg.c:209 // Выводим на экран
    ; dialog/alg.c:210 gEndDraw();
    call gEndDraw
    ; dialog/alg.c:211 
    ; dialog/alg.c:212 // Клавиатура
    ; dialog/alg.c:213 while()
l21:
    ; dialog/alg.c:214 {
    ; dialog/alg.c:215 // Ждем, если прошло меньше 1/50 сек с прошлого цикла.
    ; dialog/alg.c:216 while ((a = gVideoPage) & 1);
l23:
    ld   a, (gVideoPage)
    bit  0, a
    jp   z, l24
    jp   l23
l24:
    ; dialog/alg.c:217 gVideoPage = (a |= 1);
    or   1
    ld   (gVideoPage), a
    ; dialog/alg.c:218 
    ; dialog/alg.c:219 // Получить нажатую клавишу
    ; dialog/alg.c:220 hl = &gKeyTrigger;
    ld   hl, gKeyTrigger
    ; dialog/alg.c:221 b = *hl;
    ld   b, (hl)
    ; dialog/alg.c:222 *hl = 0;
    ld   (hl), 0
    ; dialog/alg.c:223 
    ; dialog/alg.c:224 // Нажат выстрел
    ; dialog/alg.c:225 if (b & KEY_FIRE)
    bit  4, b
    ; dialog/alg.c:226 {
    jp   z, l25
    ; dialog/alg.c:227 // Отмечаем, что весь экран нужно перерисовать и выходим
    ; dialog/alg.c:228 gFarCall(iyl = 7, ix = &gCopyVideoPage);
    ld   iyl, 7
    ld   ix, gCopyVideoPage
    call gFarCall
    ; dialog/alg.c:229 a = dialogX;
    ld   a, (dialogX)
    ; dialog/alg.c:230 return;
    ret
    ; dialog/alg.c:231 }
    ; dialog/alg.c:232 
    ; dialog/alg.c:233 // Перемещение курсора
    ; dialog/alg.c:234 a = dialogX;
l25:
    ld   a, (dialogX)
    ; dialog/alg.c:235 if (b & KEY_UP)
    bit  0, b
    ; dialog/alg.c:236 {
    jp   z, l26
    ; dialog/alg.c:237 a -= 1;
    sub  1
    ; dialog/alg.c:238 if (flag_c) continue;
    jp   c, l21
    ; dialog/alg.c:239 }
    ; dialog/alg.c:240 else if (b & KEY_DOWN)
    jp   l27
l26:
    bit  1, b
    ; dialog/alg.c:241 {
    jp   z, l28
    ; dialog/alg.c:242 a++;
    inc  a
    ; dialog/alg.c:243 if (a >= iyl) continue;
    cp   iyl
    jp   nc, l21
    ; dialog/alg.c:244 }
    ; dialog/alg.c:245 dialogX = a;
l28:
l27:
    ld   (dialogX), a
    ; dialog/alg.c:246 
    ; dialog/alg.c:247 // Умножение на 10
    ; dialog/alg.c:248 c = (a += a);
    add  a
    ld   c, a
    ; dialog/alg.c:249 ((a += a) += a) += c;
    add  a
    add  a
    add  c
    ; dialog/alg.c:250 
    ; dialog/alg.c:251 // Плавное перемещение курсора
    ; dialog/alg.c:252 hl = &dialogX1;
    ld   hl, dialogX1
    ; dialog/alg.c:253 b = *hl;
    ld   b, (hl)
    ; dialog/alg.c:254 if (a == b) continue; // Оставит флаг CF при выполнении dialogX1 - menuX
    cp   b
    jp   z, l21
    ; dialog/alg.c:255 b++; // Не изменяет CF
    inc  b
    ; dialog/alg.c:256 if (flag_c) ----b;
    jp   nc, l29
    dec  b
    dec  b
    ; dialog/alg.c:257 
    ; dialog/alg.c:258 // Стираем прошлый курсор
    ; dialog/alg.c:259 push(bc);
l29:
    push bc
    ; dialog/alg.c:260 dialogDrawCursor();
    call dialogDrawCursor
    ; dialog/alg.c:261 pop(bc);
    pop  bc
    ; dialog/alg.c:262 
    ; dialog/alg.c:263 // Сохраняем новые координаты курсора
    ; dialog/alg.c:264 *(hl = &dialogX1) = b;
    ld   hl, dialogX1
    ld   (hl), b
    ; dialog/alg.c:265 
    ; dialog/alg.c:266 // Рисуем курсор
    ; dialog/alg.c:267 dialogDrawCursor();
    call dialogDrawCursor
    ; dialog/alg.c:268 }
    jp   l21
l22:
    ; dialog/alg.c:269 }
    ret
    ; dialog/alg.c:270 
    ; dialog/alg.c:271 void dialogDrawCursor()
dialogDrawCursor:
    ; dialog/alg.c:272 {
    ; dialog/alg.c:273 hl = dialogCursor;
    ld   hl, (dialogCursor)
    ; dialog/alg.c:274 h = ((a = dialogX1) += h);
    ld   a, (dialogX1)
    add  h
    ld   h, a
    ; dialog/alg.c:275 gDrawTextEx(hl, de = "@", a = colorCursor);
    ld   de, s0
    ld   a, 67
    call gDrawTextEx
    ; dialog/alg.c:276 }
    ret
    ; dialog/alg.c:277 
    ; dialog/alg.c:278 void drawDialog2()
drawDialog2:
    ; dialog/alg.c:279 {
    ; dialog/alg.c:280 push(bc, hl)
    ; dialog/alg.c:281 {
    push bc
    push hl
    ; dialog/alg.c:282 drawSprite2();
    call drawSprite2
    ; dialog/alg.c:283 a = iyl;
    ld   a, iyl
    ; dialog/alg.c:284 ix = de;
    ld   ixh, d
    ld   ixl, e
    ; dialog/alg.c:285 do
l30:
    ; dialog/alg.c:286 {
    ; dialog/alg.c:287 ex(a);
    ex   af, af
    ; dialog/alg.c:288 d = ixh; e = ixl;
    ld   d, ixh
    ld   e, ixl
    ; dialog/alg.c:289 drawSprite2();
    call drawSprite2
    ; dialog/alg.c:290 ex(a);
    ex   af, af
    ; dialog/alg.c:291 } while(flag_nz --a);
    dec  a
    jp   nz, l30
l31:
    ; dialog/alg.c:292 drawSprite2();
    call drawSprite2
    ; dialog/alg.c:293 }
    pop  hl
    pop  bc
    ; dialog/alg.c:294 // Следующая строка
    ; dialog/alg.c:295 l = ((a = l) += 32); h = ((a +@= h) -= l);
    ld   a, l
    add  32
    ld   l, a
    adc  h
    sub  l
    ld   h, a
    ; dialog/alg.c:296 c = ((a = c) += 32); if (flag_c) b = ((a = b) += 8);
    ld   a, c
    add  32
    ld   c, a
    jp   nc, l32
    ld   a, b
    add  8
    ld   b, a
    ; dialog/alg.c:297 }
l32:
    ret
    ; dialog/alg.c:298 
    ; dialog/alg.c:299 // Вход:
    ; dialog/alg.c:300 //   l - x
    ; dialog/alg.c:301 //   h - y
    ; dialog/alg.c:302 //   hl - цветной адрес
    ; dialog/alg.c:303 //   bc - чб адрес
    ; dialog/alg.c:304 
    ; dialog/alg.c:305 void calcAddr()
calcAddr:
    ; dialog/alg.c:306 {
    ; dialog/alg.c:307 //        43210     43210
    ; dialog/alg.c:308 // bc  .1.43...  210.....
    ; dialog/alg.c:309 // hl  .1.11.43  210.....
    ; dialog/alg.c:310 b = (((a = h) &= 0x18) |= 0x40);
    ld   a, h
    and  24
    or   64
    ld   b, a
    ; dialog/alg.c:311 h = ((a = h) >>r= 3);
    ld   a, h
    rrca
    rrca
    rrca
    ld   h, a
    ; dialog/alg.c:312 c = l = ((a &= 0xE0) |= l);
    and  224
    or   l
    ld   l, a
    ld   c, l
    ; dialog/alg.c:313 h = (((a = h) &= 0x03) |= 0x58);
    ld   a, h
    and  3
    or   88
    ld   h, a
    ; dialog/alg.c:314 
    ; dialog/alg.c:315 if (flag_z (a = gVideoPage) & 0x80) return;
    ld   a, (gVideoPage)
    bit  7, a
    ret  z
    ; dialog/alg.c:316 h |= 0x80;
    set  7, h
    ; dialog/alg.c:317 b |= 0x80;
    set  7, b
    ; dialog/alg.c:318 }
    ret
    ; dialog/alg.c:319 
    ; strings
s0 db "@",0

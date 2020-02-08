    ; base/drawtext2.c:2 
    ; base/drawtext2.c:3 // Вычисление ширины текста в пикселях
    ; base/drawtext2.c:4 // Вход: DE - текст
    ; base/drawtext2.c:5 // Выход: С - результат, A - последний символ, DE - адрес символа за последним символом
    ; base/drawtext2.c:6 // Портит: HL
    ; base/drawtext2.c:7 
    ; base/drawtext2.c:8 const int firstChar = ' ';
    ; base/drawtext2.c:9 
    ; base/drawtext2.c:10 void measureText()
measureText:
    ; base/drawtext2.c:11 {
    ; base/drawtext2.c:12 c = 0;
    ld   c, 0
    ; base/drawtext2.c:13 while()
l10000:
    ; base/drawtext2.c:14 {
    ; base/drawtext2.c:15 a = *de; de++;
    ld   a, (de)
    inc  de
    ; base/drawtext2.c:16 if (a < firstChar) return;
    cp   32
    ret  c
    ; base/drawtext2.c:17 
    ; base/drawtext2.c:18 // Вычисление адреса символа (de = image_font + a * 9)
    ; base/drawtext2.c:19 push(de)
    ; base/drawtext2.c:20 {
    push de
    ; base/drawtext2.c:21 calcCharAddr(); //  HL - адрес символа в знакогенераторе, DE - мусор
    call calcCharAddr
    ; base/drawtext2.c:22 hl += (de = 8);
    ld   de, 8
    add  hl, de
    ; base/drawtext2.c:23 a = *hl;
    ld   a, (hl)
    ; base/drawtext2.c:24 c = (a += c);
    add  c
    ld   c, a
    ; base/drawtext2.c:25 }
    pop  de
    ; base/drawtext2.c:26 }
    jp   l10000
l10001:
    ; base/drawtext2.c:27 }
    ret
    ; base/drawtext2.c:28 
    ; base/drawtext2.c:29 // Вычисление адреса символа
    ; base/drawtext2.c:30 // Вход: A - символ
    ; base/drawtext2.c:31 // Выход: HL - адрес символа в знакогенераторе
    ; base/drawtext2.c:32 // Портит: DE
    ; base/drawtext2.c:33 
    ; base/drawtext2.c:34 void calcCharAddr()
calcCharAddr:
    ; base/drawtext2.c:35 {    
    ; base/drawtext2.c:36 calcCharAddrPoly:
calcCharAddrPoly:
    ; base/drawtext2.c:37 goto calcCharAddrBig;
    jp   calcCharAddrBig
    ; base/drawtext2.c:38 
    ; base/drawtext2.c:39 calcCharAddrSmall: // 32, 48-57, 192-223
calcCharAddrSmall:
    ; base/drawtext2.c:40 a -= [192 - 12];
    sub  180
    ; base/drawtext2.c:41 if (flag_c)
    ; base/drawtext2.c:42 {
    jp   nc, l10002
    ; base/drawtext2.c:43 a += [(192 - 12) - 46];
    add  134
    ; base/drawtext2.c:44 if (a >= 12) a ^= a;
    cp   12
    jp   c, l10003
    xor  a
    ; base/drawtext2.c:45 }
l10003:
    ; base/drawtext2.c:46 h = 0; l = a;
l10002:
    ld   h, 0
    ld   l, a
    ; base/drawtext2.c:47 hl += hl;
    add  hl, hl
    ; base/drawtext2.c:48 d = h; e = l;
    ld   d, h
    ld   e, l
    ; base/drawtext2.c:49 (hl += hl) += de;
    add  hl, hl
    add  hl, de
    ; base/drawtext2.c:50 hl += (de = &image_smallfont);
    ld   de, image_smallfont
    add  hl, de
    ; base/drawtext2.c:51 return;
    ret
    ; base/drawtext2.c:52 
    ; base/drawtext2.c:53 calcCharAddrBig: // 32-96, 192-255
calcCharAddrBig:
    ; base/drawtext2.c:54 a -= 32;
    sub  32
    ; base/drawtext2.c:55 if (a >= 96) a -= 64;
    cp   96
    jp   c, l10004
    sub  64
    ; base/drawtext2.c:56 h = 0; l = a;
l10004:
    ld   h, 0
    ld   l, a
    ; base/drawtext2.c:57 d = h; e = l;
    ld   d, h
    ld   e, l
    ; base/drawtext2.c:58 (((hl += hl) += hl) += hl) += de;
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, de
    ; base/drawtext2.c:59 hl += (de = &image_font);
    ld   de, image_font
    add  hl, de
    ; base/drawtext2.c:60 }
    ret
    ; base/drawtext2.c:61 
    ; base/drawtext2.c:62 // Вывод текста по центру экрана
    ; base/drawtext2.c:63 // Вход: DE - текст, H - строка
    ; base/drawtext2.c:64 
    ; base/drawtext2.c:65 void drawTextCenter()
drawTextCenter:
    ; base/drawtext2.c:66 {
    ; base/drawtext2.c:67 ex(a, a);
    ex   af, af
    ; base/drawtext2.c:68 push(hl, de)
    ; base/drawtext2.c:69 {
    push hl
    push de
    ; base/drawtext2.c:70 measureText();
    call measureText
    ; base/drawtext2.c:71 a = (((a = 256) -= c) >>= 1);
    ld   a, 256
    sub  c
    srl  a
    ld   a, a
    ; base/drawtext2.c:72 }
    pop  de
    pop  hl
    ; base/drawtext2.c:73 l = a;
    ld   l, a
    ; base/drawtext2.c:74 ex(a, a);
    ex   af, af
    ; base/drawtext2.c:75 drawTextEx();
    call drawTextEx
    ; base/drawtext2.c:76 }
    ret
    ; base/drawtext2.c:77 
    ; base/drawtext2.c:78 // Вычисление адреса в видеопамяти и смещения в битах.
    ; base/drawtext2.c:79 // Вход: H - коодината y, L - коодината x
    ; base/drawtext2.c:80 // Выход: HL - адрес, C - смещение в битах
    ; base/drawtext2.c:81 // Портит: A, B
    ; base/drawtext2.c:82 
    ; base/drawtext2.c:83 void calcCoords()
calcCoords:
    ; base/drawtext2.c:84 {
    ; base/drawtext2.c:85 // Необходимо разместить Y в регистре HL следующим образом
    ; base/drawtext2.c:86 // ...76210 543.....
    ; base/drawtext2.c:87 
    ; base/drawtext2.c:88 c = ((a = l) &= 7); // Из координаты X получаем смещение в битах
    ld   a, l
    and  7
    ld   c, a
    ; base/drawtext2.c:89 l >>= 3; //  Из координаты X смещение в байтах
    srl  l
    srl  l
    srl  l
    ; base/drawtext2.c:90 l = ((((a = h) <<= 2) &= 0xE0) |= l);
    ld   a, h
    sla  a
    sla  a
    and  224
    or   l
    ld   l, a
    ; base/drawtext2.c:91 b = (((a = h) >>= 3) &= 0x18);
    ld   a, h
    srl  a
    srl  a
    srl  a
    and  24
    ld   b, a
    ; base/drawtext2.c:92 h = ((((a = h) &= 7) |= 0x40) |= b);
    ld   a, h
    and  7
    or   64
    or   b
    ld   h, a
    ; base/drawtext2.c:93 h = (((a = gVideoPage) &= 0x80) |= h);
    ld   a, (gVideoPage)
    and  128
    or   h
    ld   h, a
    ; base/drawtext2.c:94 }
    ret
    ; base/drawtext2.c:95 
    ; base/drawtext2.c:96 void drawTextEx()
drawTextEx:
    ; base/drawtext2.c:97 {
    ; base/drawtext2.c:98 ex(a, a);
    ex   af, af
    ; base/drawtext2.c:99 calcCoords();
    call calcCoords
    ; base/drawtext2.c:100 ex(a, a);
    ex   af, af
    ; base/drawtext2.c:101 return drawTextSub();
    jp   drawTextSub
    ; base/drawtext2.c:102 }
    ret
    ; base/drawtext2.c:103 
    ; base/drawtext2.c:104 void drawText()
drawText:
    ; base/drawtext2.c:105 {
    ; base/drawtext2.c:106 c = 0;
    ld   c, 0
    ; base/drawtext2.c:107 drawTextSub:
drawTextSub:
    ; base/drawtext2.c:108 
    ; base/drawtext2.c:109 // Выбор шрифта
    ; base/drawtext2.c:110 push(hl)
    ; base/drawtext2.c:111 {
    push hl
    ; base/drawtext2.c:112 a <<r= 1;
    rlca
    ; base/drawtext2.c:113 if (flag_c)
    ; base/drawtext2.c:114 {
    jp   nc, l10005
    ; base/drawtext2.c:115 a >>= 1;
    srl  a
    ; base/drawtext2.c:116 *(hl = [&drawTextPolyHeight + 1]) = 5;
    ld   hl, (drawTextPolyHeight) + (1)
    ld   (hl), 5
    ; base/drawtext2.c:117 *[&calcCharAddrPoly + 1] = hl = &calcCharAddrSmall;
    ld   hl, calcCharAddrSmall
    ld   ((calcCharAddrPoly) + (1)), hl
    ; base/drawtext2.c:118 }
    ; base/drawtext2.c:119 else
    jp   l10006
l10005:
    ; base/drawtext2.c:120 {
    ; base/drawtext2.c:121 a >>= 1;
    srl  a
    ; base/drawtext2.c:122 *(hl = [&drawTextPolyHeight + 1]) = 8;
    ld   hl, (drawTextPolyHeight) + (1)
    ld   (hl), 8
    ; base/drawtext2.c:123 *[&calcCharAddrPoly + 1] = hl = &calcCharAddrBig;
    ld   hl, calcCharAddrBig
    ld   ((calcCharAddrPoly) + (1)), hl
    ; base/drawtext2.c:124 }
l10006:
    ; base/drawtext2.c:125 }
    pop  hl
    ; base/drawtext2.c:126 
    ; base/drawtext2.c:127 //
    ; base/drawtext2.c:128 ex(a, a);
    ex   af, af
    ; base/drawtext2.c:129 h = (((a = gVideoPage) &= 0x80) |= h);
    ld   a, (gVideoPage)
    and  128
    or   h
    ld   h, a
    ; base/drawtext2.c:130 *[&drawTextS + 1] = hl;
    ld   ((drawTextS) + (1)), hl
    ; base/drawtext2.c:131 while ()
l10007:
    ; base/drawtext2.c:132 {
    ; base/drawtext2.c:133 a = *de; de++;
    ld   a, (de)
    inc  de
    ; base/drawtext2.c:134 if (a < firstChar) break;
    cp   32
    jp   c, l10008
    ; base/drawtext2.c:135 drawCharSub();
    call drawCharSub
    ; base/drawtext2.c:136 }
    jp   l10007
l10008:
    ; base/drawtext2.c:137 
    ; base/drawtext2.c:138 // Раскраска
    ; base/drawtext2.c:139 push(a, bc, de, hl)
    ; base/drawtext2.c:140 {
    push af
    push bc
    push de
    push hl
    ; base/drawtext2.c:141 ex(hl, de);
    ex de, hl
    ; base/drawtext2.c:142 drawTextS:
drawTextS:
    ; base/drawtext2.c:143 hl = 0;
    ld   hl, 0
    ; base/drawtext2.c:144 
    ; base/drawtext2.c:145 // Если символ пересекает границу в 8 пикселей, то раскрашиываем две строки.
    ; base/drawtext2.c:146 b = ((a = h) &= 7);
    ld   a, h
    and  7
    ld   b, a
    ; base/drawtext2.c:147 a = *[&drawTextPolyHeight + 1];
    ld   a, ((drawTextPolyHeight) + (1))
    ; base/drawtext2.c:148 a--;
    dec  a
    ; base/drawtext2.c:149 b = (a += b);
    add  b
    ld   b, a
    ; base/drawtext2.c:150 
    ; base/drawtext2.c:151 // Преобразование адреса из чб в цвет
    ; base/drawtext2.c:152 d = (((a = h) >>= 3) &= 3);
    ld   a, h
    srl  a
    srl  a
    srl  a
    and  3
    ld   d, a
    ; base/drawtext2.c:153 h = ((((a = h) &= 0xC0) |= 0x18) |= d);
    ld   a, h
    and  192
    or   24
    or   d
    ld   h, a
    ; base/drawtext2.c:154 
    ; base/drawtext2.c:155 // Ширина
    ; base/drawtext2.c:156 (((a = e) -= l) &= 31);
    ld   a, e
    sub  l
    and  31
    ; base/drawtext2.c:157 c++; if (flag_nz c--) a++;
    inc  c
    dec  c
    jp   z, l10009
    inc  a
    ; base/drawtext2.c:158 if (flag_nz a |= a)
l10009:
    or   a
    ; base/drawtext2.c:159 {
    jp   z, l10010
    ; base/drawtext2.c:160 c = a;
    ld   c, a
    ; base/drawtext2.c:161 
    ; base/drawtext2.c:162 // Цвет
    ; base/drawtext2.c:163 ex(a, a);
    ex   af, af
    ; base/drawtext2.c:164 
    ; base/drawtext2.c:165 // Первая строка
    ; base/drawtext2.c:166 push (bc, hl)
    ; base/drawtext2.c:167 {
    push bc
    push hl
    ; base/drawtext2.c:168 do
l10011:
    ; base/drawtext2.c:169 {
    ; base/drawtext2.c:170 *hl = a;
    ld   (hl), a
    ; base/drawtext2.c:171 hl++;
    inc  hl
    ; base/drawtext2.c:172 } while(flag_nz --c);
    dec  c
    jp   nz, l10011
l10012:
    ; base/drawtext2.c:173 }
    pop  hl
    pop  bc
    ; base/drawtext2.c:174 
    ; base/drawtext2.c:175 // Вторая строка
    ; base/drawtext2.c:176 if (flag_nz b & 8)
    bit  3, b
    ; base/drawtext2.c:177 {
    jp   z, l10013
    ; base/drawtext2.c:178 hl += (de = 32);
    ld   de, 32
    add  hl, de
    ; base/drawtext2.c:179 do
l10014:
    ; base/drawtext2.c:180 {
    ; base/drawtext2.c:181 *hl = a;
    ld   (hl), a
    ; base/drawtext2.c:182 hl++;
    inc  hl
    ; base/drawtext2.c:183 } while(flag_nz --c);
    dec  c
    jp   nz, l10014
l10015:
    ; base/drawtext2.c:184 }
    ; base/drawtext2.c:185 }
l10013:
    ; base/drawtext2.c:186 }
l10010:
    pop  hl
    pop  de
    pop  bc
    pop  af
    ; base/drawtext2.c:187 }
    ret
    ; base/drawtext2.c:188 
    ; base/drawtext2.c:189 uint16_t drawTextTbl[] =
    ; base/drawtext2.c:190 {
    ; base/drawtext2.c:191 0x0000, 0x0000, 0xE64F, 0x00FF,
    ; base/drawtext2.c:192 0x0F00, 0x0000, 0xE64F, 0x807F,
    ; base/drawtext2.c:193 0x0F0F, 0x0000, 0xE64F, 0xC03F,
    ; base/drawtext2.c:194 0x0F0F, 0x000F, 0xE64F, 0xE01F,
    ; base/drawtext2.c:195 0x0F0F, 0x0F0F, 0xE64F, 0xF00F,
    ; base/drawtext2.c:196 0x0707, 0x0700, 0xE64F, 0xF807,
    ; base/drawtext2.c:197 0x0707, 0x0000, 0xE64F, 0xFC03,
    ; base/drawtext2.c:198 0x0700, 0x0000, 0xE64F, 0xFE07
    ; base/drawtext2.c:199 };
drawTextTbl:
    dw 0
    dw 0
    dw 58959
    dw 255
    dw 3840
    dw 0
    dw 58959
    dw 32895
    dw 3855
    dw 0
    dw 58959
    dw 49215
    dw 3855
    dw 15
    dw 58959
    dw 57375
    dw 3855
    dw 3855
    dw 58959
    dw 61455
    dw 1799
    dw 1792
    dw 58959
    dw 63495
    dw 1799
    dw 0
    dw 58959
    dw 64515
    dw 1792
    dw 0
    dw 58959
    dw 65031
    ; base/drawtext2.c:200 
    ; base/drawtext2.c:201 void drawCharSub()
drawCharSub:
    ; base/drawtext2.c:202 {
    ; base/drawtext2.c:203 // Функция сохраняет DE
    ; base/drawtext2.c:204 push(de);
    push de
    ; base/drawtext2.c:205 
    ; base/drawtext2.c:206 // Вычисление адреса символа
    ; base/drawtext2.c:207 push(hl)
    ; base/drawtext2.c:208 {
    push hl
    ; base/drawtext2.c:209 calcCharAddr(); // Вход A, выход HL, портит DE
    call calcCharAddr
    ; base/drawtext2.c:210 ex(hl, de);
    ex de, hl
    ; base/drawtext2.c:211 }
    pop  hl
    ; base/drawtext2.c:212 
    ; base/drawtext2.c:213 push(hl, bc)
    ; base/drawtext2.c:214 {
    push hl
    push bc
    ; base/drawtext2.c:215 // Выбор одной из 8 подпрограмм рисования символа
    ; base/drawtext2.c:216 a = c;
    ld   a, c
    ; base/drawtext2.c:217 ex(bc, de, hl);
    exx
    ; base/drawtext2.c:218 l = ((((a += a) += a) += a) += &drawTextTbl);
    add  a
    add  a
    add  a
    add  drawTextTbl
    ld   l, a
    ; base/drawtext2.c:219 h = ((a +@= [&drawTextTbl >> 8]) -= l);
    adc  (drawTextTbl) >> (8)
    sub  l
    ld   h, a
    ; base/drawtext2.c:220 de = &C1;
    ld   de, C1
    ; base/drawtext2.c:221 bc = 7;
    ld   bc, 7
    ; base/drawtext2.c:222 ldir();
    ldir
    ; base/drawtext2.c:223 de++; de++; de++;
    inc  de
    inc  de
    inc  de
    ; base/drawtext2.c:224 ldi();
    ldi
    ; base/drawtext2.c:225 ex(bc, de, hl);
    exx
    ; base/drawtext2.c:226 
    ; base/drawtext2.c:227 drawTextPolyHeight:
drawTextPolyHeight:
    ; base/drawtext2.c:228 b = 8;
    ld   b, 8
    ; base/drawtext2.c:229 do
l10016:
    ; base/drawtext2.c:230 {
    ; base/drawtext2.c:231 a = *de; // Половинка
    ld   a, (de)
    ; base/drawtext2.c:232 C1:         nop(); nop(); nop(); nop();
C1:
    nop
    nop
    nop
    nop
    ; base/drawtext2.c:233 c = a;
    ld   c, a
    ; base/drawtext2.c:234 a &= 0;
    and  0
    ; base/drawtext2.c:235 *hl = (a ^= *hl);
    xor  (hl)
    ld   (hl), a
    ; base/drawtext2.c:236 a = 0; // Половинка
    ld   a, 0
    ; base/drawtext2.c:237 a &= c;
    and  c
    ; base/drawtext2.c:238 l++; // влево
    inc  l
    ; base/drawtext2.c:239 *hl = (a ^= *hl);
    xor  (hl)
    ld   (hl), a
    ; base/drawtext2.c:240 l--; // вправо
    dec  l
    ; base/drawtext2.c:241 h++; // Цикл
    inc  h
    ; base/drawtext2.c:242 (a = h) &= 7;
    ld   a, h
    and  7
    ; base/drawtext2.c:243 if (flag_z) drawCharNextLine();
    call z, drawCharNextLine
    ; base/drawtext2.c:244 de++;
    inc  de
    ; base/drawtext2.c:245 } while(--b);
    djnz l10016
l10017:
    ; base/drawtext2.c:246 }
    pop  bc
    pop  hl
    ; base/drawtext2.c:247 
    ; base/drawtext2.c:248 // Адрес вывода следующего символа на экране
    ; base/drawtext2.c:249 a = *de; // Ширина символа
    ld   a, (de)
    ; base/drawtext2.c:250 a += c; // Смещение в пикселях
    add  c
    ; base/drawtext2.c:251 if (a >= 8) { a &= 7; l++; }
    cp   8
    jp   c, l10018
    and  7
    inc  l
    ; base/drawtext2.c:252 c = a;
l10018:
    ld   c, a
    ; base/drawtext2.c:253 
    ; base/drawtext2.c:254 // Функция сохраняет DE
    ; base/drawtext2.c:255 pop(de);
    pop  de
    ; base/drawtext2.c:256 }
    ret
    ; base/drawtext2.c:257 
    ; base/drawtext2.c:258 void drawCharNextLine()
drawCharNextLine:
    ; base/drawtext2.c:259 {
    ; base/drawtext2.c:260 push(de)
    ; base/drawtext2.c:261 {
    push de
    ; base/drawtext2.c:262 hl += (de = [0x20 - 0x800]);
    ld   de, -2016
    add  hl, de
    ; base/drawtext2.c:263 }
    pop  de
    ; base/drawtext2.c:264 (a = h) &= 7;
    ld   a, h
    and  7
    ; base/drawtext2.c:265 if (flag_z) return;
    ret  z
    ; base/drawtext2.c:266 push(de)
    ; base/drawtext2.c:267 {
    push de
    ; base/drawtext2.c:268 hl += (de = [0x800 - 0x100]);
    ld   de, 1792
    add  hl, de
    ; base/drawtext2.c:269 }
    pop  de
    ; base/drawtext2.c:270 }
    ret
    ; base/drawtext2.c:271 

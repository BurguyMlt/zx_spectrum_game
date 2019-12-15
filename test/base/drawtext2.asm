    ; 3 // Вычисление ширины текста в пикселях
    ; 4 // Вход: DE - текст
    ; 5 // Выход: С - результат, A - последний символ, DE - адрес символа за последним символом
    ; 6 // Портит: HL
    ; 8 const int firstChar = [' ' - 11];
    ; 10 void measureText()
measureText:
    ; 11 {
    ; 12 c = 0;
    ld   c, 0
    ; 13 while()
l10000:
    ; 14 {
    ; 15 a = *de; de++;
    ld   a, (de)
    inc  de
    ; 16 if (a < firstChar) return;
    cp   21
    ret  c
    ; 18 // Вычисление адреса символа (de = image_font + a * 9)
    ; 19 push(de)
    ; 20 {
    push de
    ; 21 calcCharAddr(); //  HL - адрес символа в знакогенераторе, DE - мусор
    call calcCharAddr
    ; 22 hl += (de = 8);
    ld   de, 8
    add  hl, de
    ; 23 a = *hl;
    ld   a, (hl)
    ; 24 c = (a += c);
    add  c
    ld   c, a
    ; 25 }
    pop  de
    ; 26 }
    jp   l10000
l10001:
    ; 27 }
    ret
    ; 29 // Вычисление адреса символа
    ; 30 // Вход: A - символ
    ; 31 // Выход: HL - адрес символа в знакогенераторе
    ; 32 // Портит: DE
    ; 34 void calcCharAddr()
calcCharAddr:
    ; 35 {
    ; 36 a -= firstChar;
    sub  21
    ; 37 if (a >= 96) a -= 64;
    cp   96
    jp   c, l10002
    sub  64
    ; 38 h = 0; l = a;
l10002:
    ld   h, 0
    ld   l, a
    ; 39 d = h; e = l;
    ld   d, h
    ld   e, l
    ; 40 (((hl += hl) += hl) += hl) += de;
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, de
    ; 41 hl += (de = &image_font);
    ld   de, image_font
    add  hl, de
    ; 42 }
    ret
    ; 44 // Вывод текста по центру экрана
    ; 45 // Вход: DE - текст, H - строка
    ; 47 void drawTextCenter()
drawTextCenter:
    ; 48 {
    ; 49 ex(a, a);
    ex   af, af
    ; 50 push(hl, de)
    ; 51 {
    push hl
    push de
    ; 52 measureText();
    call measureText
    ; 53 a = (((a = 256) -= c) >>= 1);
    ld   a, 256
    sub  c
    srl  a
    ld   a, a
    ; 54 }
    pop  de
    pop  hl
    ; 55 l = a;
    ld   l, a
    ; 56 ex(a, a);
    ex   af, af
    ; 57 drawTextEx();
    call drawTextEx
    ; 58 }
    ret
    ; 60 // Вычисление адреса в видеопамяти и смещения в битах.
    ; 61 // Вход: H - коодината y, L - коодината x
    ; 62 // Выход: HL - адрес, C - смещение в битах
    ; 63 // Портит: A, B
    ; 65 void calcCoords()
calcCoords:
    ; 66 {
    ; 67 // Необходимо разместить Y в регистре HL следующим образом
    ; 68 // ...76210 543.....
    ; 70 c = ((a = l) &= 7); // Из координаты X получаем смещение в битах
    ld   a, l
    and  7
    ld   c, a
    ; 71 l >>= 3; //  Из координаты X смещение в байтах
    srl  l
    srl  l
    srl  l
    ; 72 l = ((((a = h) <<= 2) &= 0xE0) |= l);
    ld   a, h
    sla  a
    sla  a
    and  224
    or   l
    ld   l, a
    ; 73 b = (((a = h) >>= 3) &= 0x18);
    ld   a, h
    srl  a
    srl  a
    srl  a
    and  24
    ld   b, a
    ; 74 h = ((((a = h) &= 7) |= 0x40) |= b);
    ld   a, h
    and  7
    or   64
    or   b
    ld   h, a
    ; 75 h = (((a = gVideoPage) &= 0x80) |= h);
    ld   a, (gVideoPage)
    and  128
    or   h
    ld   h, a
    ; 76 }
    ret
    ; 78 void drawTextEx()
drawTextEx:
    ; 79 {
    ; 80 ex(a, a);
    ex   af, af
    ; 81 calcCoords();
    call calcCoords
    ; 82 ex(a, a);
    ex   af, af
    ; 83 return drawTextSub();
    jp   drawTextSub
    ; 84 }
    ret
    ; 86 void drawText()
drawText:
    ; 87 {
    ; 88 c = 0;
    ld   c, 0
    ; 89 drawTextSub:
drawTextSub:
    ; 90 ex(a, a);
    ex   af, af
    ; 91 *[&drawTextS + 1] = hl;
    ld   ((drawTextS) + (1)), hl
    ; 92 while ()
l10003:
    ; 93 {
    ; 94 a = *de; de++;
    ld   a, (de)
    inc  de
    ; 95 if (a < firstChar) break;
    cp   21
    jp   c, l10004
    ; 96 drawCharSub();
    call drawCharSub
    ; 97 }
    jp   l10003
l10004:
    ; 98 push(a, bc, de, hl)
    ; 99 {
    push af
    push bc
    push de
    push hl
    ; 100 ex(hl, de);
    ex de, hl
    ; 101 drawTextS:
drawTextS:
    ; 102 hl = 0;
    ld   hl, 0
    ; 104 // Две строки?
    ; 105 if (a != 2)
    cp   2
    ; 106 if (flag_nz (a = h) &= 7) a = 1;
    jp   z, l10005
    ld   a, h
    and  7
    jp   z, l10006
    ld   a, 1
    ; 107 b = a;
l10006:
l10005:
    ld   b, a
    ; 109 // Преобразование адреса из чб в цвет
    ; 110 d = (((a = h) >>= 3) &= 3);
    ld   a, h
    srl  a
    srl  a
    srl  a
    and  3
    ld   d, a
    ; 111 h = ((((a = h) &= 0xC0) |= 0x18) |= d);
    ld   a, h
    and  192
    or   24
    or   d
    ld   h, a
    ; 113 // Ширина
    ; 114 (((a = e) -= l) &= 31);
    ld   a, e
    sub  l
    and  31
    ; 115 c++; if (flag_nz c--) a++;
    inc  c
    dec  c
    jp   z, l10007
    inc  a
    ; 116 if (flag_nz a |= a)
l10007:
    or   a
    ; 117 {
    jp   z, l10008
    ; 118 c = a;
    ld   c, a
    ; 120 // Цвет
    ; 121 ex(a, a);
    ex   af, af
    ; 123 // Первая строка
    ; 124 push (bc, hl)
    ; 125 {
    push bc
    push hl
    ; 126 do
l10009:
    ; 127 {
    ; 128 *hl = a;
    ld   (hl), a
    ; 129 hl++;
    inc  hl
    ; 130 } while(flag_nz --c);
    dec  c
    jp   nz, l10009
l10010:
    ; 131 }
    pop  hl
    pop  bc
    ; 133 // Вторая строка
    ; 134 if (flag_nz b & 1)
    bit  0, b
    ; 135 {
    jp   z, l10011
    ; 136 hl += (de = 32);
    ld   de, 32
    add  hl, de
    ; 137 do
l10012:
    ; 138 {
    ; 139 *hl = a;
    ld   (hl), a
    ; 140 hl++;
    inc  hl
    ; 141 } while(flag_nz --c);
    dec  c
    jp   nz, l10012
l10013:
    ; 142 }
    ; 143 }
l10011:
    ; 144 }
l10008:
    pop  hl
    pop  de
    pop  bc
    pop  af
    ; 145 }
    ret
    ; 147 uint16_t drawTextTbl[] =
    ; 148 {
    ; 149 0x0000, 0x0000, 0xE64F, 0x00FF,
    ; 150 0x0F00, 0x0000, 0xE64F, 0x807F,
    ; 151 0x0F0F, 0x0000, 0xE64F, 0xC03F,
    ; 152 0x0F0F, 0x000F, 0xE64F, 0xE01F,
    ; 153 0x0F0F, 0x0F0F, 0xE64F, 0xF00F,
    ; 154 0x0707, 0x0700, 0xE64F, 0xF807,
    ; 155 0x0707, 0x0000, 0xE64F, 0xFC03,
    ; 156 0x0700, 0x0000, 0xE64F, 0xFE07
    ; 157 };
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
    ; 159 void drawCharSub()
drawCharSub:
    ; 160 {
    ; 161 // Функция сохраняет DE
    ; 162 push(de);
    push de
    ; 164 // Вычисление адреса символа
    ; 165 push(hl)
    ; 166 {
    push hl
    ; 167 calcCharAddr(); // Вход A, выход HL, портит DE
    call calcCharAddr
    ; 168 ex(hl, de);
    ex de, hl
    ; 169 }
    pop  hl
    ; 171 push(hl, bc)
    ; 172 {
    push hl
    push bc
    ; 173 // Выбор одной из 8 подпрограмм рисования символа
    ; 174 a = c;
    ld   a, c
    ; 175 ex(bc, de, hl);
    exx
    ; 176 l = ((((a += a) += a) += a) += &drawTextTbl);
    add  a
    add  a
    add  a
    add  drawTextTbl
    ld   l, a
    ; 177 h = ((a +@= [&drawTextTbl >> 8]) -= l);
    adc  (drawTextTbl) >> (8)
    sub  l
    ld   h, a
    ; 178 de = &C1;
    ld   de, C1
    ; 179 bc = 7;
    ld   bc, 7
    ; 180 ldir();
    ldir
    ; 181 de++; de++; de++;
    inc  de
    inc  de
    inc  de
    ; 182 ldi();
    ldi
    ; 183 ex(bc, de, hl);
    exx
    ; 185 b = 8;
    ld   b, 8
    ; 186 do
l10014:
    ; 187 {
    ; 188 a = *de; // Половинка
    ld   a, (de)
    ; 189 C1:         nop(); nop(); nop(); nop();
C1:
    nop
    nop
    nop
    nop
    ; 190 c = a;
    ld   c, a
    ; 191 a &= 0;
    and  0
    ; 192 *hl = (a ^= *hl);
    xor  (hl)
    ld   (hl), a
    ; 193 a = 0; // Половинка
    ld   a, 0
    ; 194 a &= c;
    and  c
    ; 195 l++; // влево
    inc  l
    ; 196 *hl = (a ^= *hl);
    xor  (hl)
    ld   (hl), a
    ; 197 l--; // вправо
    dec  l
    ; 198 h++; // Цикл
    inc  h
    ; 199 (a = h) &= 7;
    ld   a, h
    and  7
    ; 200 if (flag_z) drawCharNextLine();
    call z, drawCharNextLine
    ; 201 de++;
    inc  de
    ; 202 } while(--b);
    djnz l10014
l10015:
    ; 203 }
    pop  bc
    pop  hl
    ; 205 // Адрес вывода следующего символа на экране
    ; 206 a = *de; // Ширина символа
    ld   a, (de)
    ; 207 a += c; // Смещение в пикселях
    add  c
    ; 208 if (a >= 8) { a &= 7; l++; }
    cp   8
    jp   c, l10016
    and  7
    inc  l
    ; 209 c = a;
l10016:
    ld   c, a
    ; 211 // Функция сохраняет DE
    ; 212 pop(de);
    pop  de
    ; 213 }
    ret
    ; 215 void drawCharNextLine()
drawCharNextLine:
    ; 216 {
    ; 217 push(de)
    ; 218 {
    push de
    ; 219 hl += (de = [0x20 - 0x800]);
    ld   de, -2016
    add  hl, de
    ; 220 }
    pop  de
    ; 221 (a = h) &= 7;
    ld   a, h
    and  7
    ; 222 if (flag_z) return;
    ret  z
    ; 223 push(de)
    ; 224 {
    push de
    ; 225 hl += (de = [0x800 - 0x100]);
    ld   de, 1792
    add  hl, de
    ; 226 }
    pop  de
    ; 227 }
    ret

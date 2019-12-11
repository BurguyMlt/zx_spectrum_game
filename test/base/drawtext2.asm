    ; 2 // Вход: DE - текст
    ; 3 // Выход: С - результат, A - последний символ, DE - адрес символа за последним символом
    ; 4 // Портит: HL
    ; 6 void measureText()
measureText:
    ; 7 {
    ; 8 c = 0;
    ld   c, 0
    ; 9 while()
l0:
    ; 10 {
    ; 11 a = *de; de++;
    ld   a, (de)
    inc  de
    ; 12 if (a < ' ') return;
    cp   32
    ret  c
    ; 14 // Вычисление адреса символа (de = image_font + a * 9)
    ; 15 push(de)
    ; 16 {
    push de
    ; 17 calcCharAddr(); //  HL - адрес символа в знакогенераторе, DE - мусор
    call calcCharAddr
    ; 18 hl += (de = 8);
    ld   de, 8
    add  hl, de
    ; 19 a = *hl;
    ld   a, (hl)
    ; 20 c = (a += c);
    add  c
    ld   c, a
    ; 21 }
    pop  de
    ; 22 }
    jp   l0
    ; 23 }
    ret
    ; 25 // Вычисление адреса символа
    ; 26 // Вход: A - символ
    ; 27 // Выход: HL - адрес символа в знакогенераторе
    ; 28 // Портит: DE
    ; 30 void calcCharAddr()
calcCharAddr:
    ; 31 {
    ; 32 a -= ' ';
    sub  32
    ; 33 if (a >= 96) a -= 64;
    cp   96
    jp   c, l2
    sub  64
    ; 34 h = 0; l = a;
l2:
    ld   h, 0
    ld   l, a
    ; 35 d = h; e = l;
    ld   d, h
    ld   e, l
    ; 36 (((hl += hl) += hl) += hl) += de;
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, de
    ; 37 hl += (de = &image_font);
    ld   de, image_font
    add  hl, de
    ; 38 }
    ret
    ; 40 // Вывод текста по центру экрана
    ; 41 // Вход: DE - текст, H - строка
    ; 43 void drawTextCenter()
drawTextCenter:
    ; 44 {
    ; 45 ex(a, a);
    ex   af, af
    ; 46 push(hl, de)
    ; 47 {
    push hl
    push de
    ; 48 measureText();
    call measureText
    ; 49 a = (((a = 256) -= c) >>= 1);
    ld   a, 256
    sub  c
    srl  a
    ld   a, a
    ; 50 }
    pop  de
    pop  hl
    ; 51 l = a;
    ld   l, a
    ; 52 ex(a, a);
    ex   af, af
    ; 53 drawTextEx();
    call drawTextEx
    ; 54 }
    ret
    ; 56 // Вычисление адреса в видеопамяти и смещения в битах.
    ; 57 // Вход: H - коодината y, L - коодината x
    ; 58 // Выход: HL - адрес, C - смещение в битах
    ; 59 // Портит: A, B
    ; 61 void calcCoords()
calcCoords:
    ; 62 {
    ; 63 // Необходимо разместить Y в регистре HL следующим образом
    ; 64 // ...76210 543.....
    ; 66 c = ((a = l) &= 7); // Из координаты X получаем смещение в битах
    ld   a, l
    and  7
    ld   c, a
    ; 67 l >>= 3; //  Из координаты X смещение в байтах
    srl  l
    srl  l
    srl  l
    ; 68 l = ((((a = h) <<= 2) &= 0xE0) |= l);
    ld   a, h
    sla  a
    sla  a
    and  224
    or   l
    ld   l, a
    ; 69 b = (((a = h) >>= 3) &= 0x18);
    ld   a, h
    srl  a
    srl  a
    srl  a
    and  24
    ld   b, a
    ; 70 h = ((((a = h) &= 7) |= 0x40) |= b);
    ld   a, h
    and  7
    or   64
    or   b
    ld   h, a
    ; 71 h = (((a = gVideoPage) &= 0x80) |= h);
    ld   a, (gVideoPage)
    and  128
    or   h
    ld   h, a
    ; 72 }
    ret
    ; 74 void drawTextEx()
drawTextEx:
    ; 75 {
    ; 76 ex(a, a);
    ex   af, af
    ; 77 calcCoords();
    call calcCoords
    ; 78 ex(a, a);
    ex   af, af
    ; 79 return drawTextSub();
    jp   drawTextSub
    ; 80 }
    ret
    ; 82 void drawText()
drawText:
    ; 83 {
    ; 84 c = 0;
    ld   c, 0
    ; 85 drawTextSub:
drawTextSub:
    ; 86 ex(a, a);
    ex   af, af
    ; 87 *[&drawTextS + 1] = hl;
    ld   ((drawTextS) + (1)), hl
    ; 88 while ()
l3:
    ; 89 {
    ; 90 a = *de; de++;
    ld   a, (de)
    inc  de
    ; 91 if (a < ' ') goto drawTextN;
    cp   32
    jp   c, drawTextN
    ; 92 drawCharSub();
    call drawCharSub
    ; 93 }
    jp   l3
    ; 94 drawTextN:
drawTextN:
    ; 95 push(a, bc, de, hl)
    ; 96 {
    push af
    push bc
    push de
    push hl
    ; 97 ex(hl, de);
    ex de, hl
    ; 98 drawTextS:
drawTextS:
    ; 99 hl = 0;
    ld   hl, 0
    ; 101 // Две строки?
    ; 102 if (flag_nz (a = h) &= 7) a = 1;
    ld   a, h
    and  7
    jp   z, l5
    ld   a, 1
    ; 103 b = a;
l5:
    ld   b, a
    ; 105 // Преобразование адреса из чб в цвет
    ; 106 d = (((a = h) >>= 3) &= 3);
    ld   a, h
    srl  a
    srl  a
    srl  a
    and  3
    ld   d, a
    ; 107 h = ((((a = h) &= 0xC0) |= 0x18) |= d);
    ld   a, h
    and  192
    or   24
    or   d
    ld   h, a
    ; 109 // Ширина
    ; 110 (((a = e) -= l) &= 31);
    ld   a, e
    sub  l
    and  31
    ; 111 c++; if (flag_nz c--) a++;
    inc  c
    dec  c
    jp   z, l6
    inc  a
    ; 112 if (flag_nz a |= a)
l6:
    or   a
    ; 113 {
    jp   z, l7
    ; 114 c = a;
    ld   c, a
    ; 116 // Цвет
    ; 117 ex(a, a);
    ex   af, af
    ; 119 // Первая строка
    ; 120 push (bc, hl)
    ; 121 {
    push bc
    push hl
    ; 122 do
l8:
    ; 123 {
    ; 124 *hl = a;
    ld   (hl), a
    ; 125 hl++;
    inc  hl
    ; 126 } while(flag_nz --c);
    dec  c
    jp   nz, l8
    ; 127 }
    pop  hl
    pop  bc
    ; 129 // Вторая строка
    ; 130 if (flag_nz b & 1)
    bit  0, b
    ; 131 {
    jp   z, l9
    ; 132 hl += (de = 32);
    ld   de, 32
    add  hl, de
    ; 133 do
l10:
    ; 134 {
    ; 135 *hl = a;
    ld   (hl), a
    ; 136 hl++;
    inc  hl
    ; 137 } while(flag_nz --c);
    dec  c
    jp   nz, l10
    ; 138 }
    ; 139 }
l9:
    ; 140 }
l7:
    pop  hl
    pop  de
    pop  bc
    pop  af
    ; 141 }
    ret
    ; 143 uint16_t drawTextTbl[] =
    ; 144 {
    ; 145 0x0000, 0x0000, 0xE64F, 0x00FF,
    ; 146 0x0F00, 0x0000, 0xE64F, 0x807F,
    ; 147 0x0F0F, 0x0000, 0xE64F, 0xC03F,
    ; 148 0x0F0F, 0x000F, 0xE64F, 0xE01F,
    ; 149 0x0F0F, 0x0F0F, 0xE64F, 0xF00F,
    ; 150 0x0707, 0x0700, 0xE64F, 0xF807,
    ; 151 0x0707, 0x0000, 0xE64F, 0xFC03,
    ; 152 0x0700, 0x0000, 0xE64F, 0xFE07
    ; 153 };
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
    ; 155 void drawCharSub()
drawCharSub:
    ; 156 {
    ; 157 // Функция сохраняет DE
    ; 158 push(de);
    push de
    ; 160 // Вычисление адреса символа
    ; 161 push(hl)
    ; 162 {
    push hl
    ; 163 calcCharAddr(); // Вход A, выход HL, портит DE
    call calcCharAddr
    ; 164 ex(hl, de);
    ex de, hl
    ; 165 }
    pop  hl
    ; 167 push(hl, bc)
    ; 168 {
    push hl
    push bc
    ; 169 // Выбор одной из 8 подпрограмм рисования символа
    ; 170 a = c;
    ld   a, c
    ; 171 ex(bc, de, hl);
    exx
    ; 172 l = ((((a += a) += a) += a) += &drawTextTbl);
    add  a
    add  a
    add  a
    add  drawTextTbl
    ld   l, a
    ; 173 h = ((a +@= [&drawTextTbl >> 8]) -= l);
    adc  (drawTextTbl) >> (8)
    sub  l
    ld   h, a
    ; 174 de = &C1;
    ld   de, C1
    ; 175 bc = 7;
    ld   bc, 7
    ; 176 ldir();
    ldir
    ; 177 de++; de++; de++;
    inc  de
    inc  de
    inc  de
    ; 178 ldi();
    ldi
    ; 179 ex(bc, de, hl);
    exx
    ; 181 b = 8;
    ld   b, 8
    ; 182 do
l11:
    ; 183 {
    ; 184 a = *de; // Половинка
    ld   a, (de)
    ; 185 C1:         nop(); nop(); nop(); nop();
C1:
    nop
    nop
    nop
    nop
    ; 186 c = a;
    ld   c, a
    ; 187 a &= 0;
    and  0
    ; 188 *hl = (a ^= *hl);
    xor  (hl)
    ld   (hl), a
    ; 189 a = 0; // Половинка
    ld   a, 0
    ; 190 a &= c;
    and  c
    ; 191 l++; // влево
    inc  l
    ; 192 *hl = (a ^= *hl);
    xor  (hl)
    ld   (hl), a
    ; 193 l--; // вправо
    dec  l
    ; 194 h++; // Цикл
    inc  h
    ; 195 (a = h) &= 7;
    ld   a, h
    and  7
    ; 196 if (flag_z) drawCharNextLine();
    call z, drawCharNextLine
    ; 197 de++;
    inc  de
    ; 198 } while(--b);
    djnz l11
    ; 199 }
    pop  bc
    pop  hl
    ; 201 // Адрес вывода следующего символа на экране
    ; 202 a = *de; // Ширина символа
    ld   a, (de)
    ; 203 a += c; // Смещение в пикселях
    add  c
    ; 204 if (a >= 8) { a &= 7; l++; }
    cp   8
    jp   c, l12
    and  7
    inc  l
    ; 205 c = a;
l12:
    ld   c, a
    ; 207 // Функция сохраняет DE
    ; 208 pop(de);
    pop  de
    ; 209 }
    ret
    ; 211 void drawCharNextLine()
drawCharNextLine:
    ; 212 {
    ; 213 push(de)
    ; 214 {
    push de
    ; 215 hl += (de = [0x20 - 0x800]);
    ld   de, -2016
    add  hl, de
    ; 216 }
    pop  de
    ; 217 (a = h) &= 7;
    ld   a, h
    and  7
    ; 218 if (flag_z) return;
    ret  z
    ; 219 push(de)
    ; 220 {
    push de
    ; 221 hl += (de = [0x800 - 0x100]);
    ld   de, 1792
    add  hl, de
    ; 222 }
    pop  de
    ; 223 }
    ret

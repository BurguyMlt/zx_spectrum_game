    ; 3 void getItemOfArray8()
getItemOfArray8:
    ; 4 {
    ; 5 l = (a += l);
    add  l
    ld   l, a
    ; 6 h = ((a +@= h) -= l);
    adc  h
    sub  l
    ld   h, a
    ; 7 a = *hl;
    ld   a, (hl)
    ; 8 }
    ret
    ; 10 void getItemOfArray16()
getItemOfArray16:
    ; 11 {
    ; 12 push(a)
    ; 13 {
    push af
    ; 14 l = ((a += a) += l);
    add  a
    add  l
    ld   l, a
    ; 15 h = ((a +@= h) -= l);
    adc  h
    sub  l
    ld   h, a
    ; 16 a = *hl; hl++; h = *hl; l = a;
    ld   a, (hl)
    inc  hl
    ld   h, (hl)
    ld   l, a
    ; 17 }
    pop  af
    ; 18 }
    ret
    ; 20 // b - указывает на максимальное кол-во копируемых символов, размер буфера должен быть на 1 байт больше.
    ; 22 void strcpyn(hl, de, b)
strcpyn:
    ; 23 {
    ; 24 do
l7000:
    ; 25 {
    ; 26 a = *de; de++;
    ld   a, (de)
    inc  de
    ; 27 if (flag_z a |= a) break;
    or   a
    jp   z, l7001
    ; 28 *hl = a; hl++;
    ld   (hl), a
    inc  hl
    ; 29 } while(--b);
    djnz l7000
l7001:
    ; 30 *hl = 0;
    ld   (hl), 0
    ; 31 }
    ret
    ; 33 void numberToString16(hl, de)
numberToString16:
    ; 34 {
    ; 35 *[&uint16_to_str_addr + 1] = hl;
    ld   ((uint16_to_str_addr) + (1)), hl
    ; 37 // Терминатор
    ; 38 a ^= a;
    xor  a
    ; 39 push(a);
    push af
    ; 41 // Разделение числа на цифры
    ; 42 ex(hl, de);
    ex de, hl
    ; 43 do
l7002:
    ; 44 {
    ; 45 div16(hl, de = 10);
    ld   de, 10
    call div16
    ; 46 (a = e) += '0';
    ld   a, e
    add  48
    ; 47 push(a);
    push af
    ; 48 } while (flag_nz (a = h) |= l);
    ld   a, h
    or   l
    jp   nz, l7002
l7003:
    ; 50 // Вывод в строку
    ; 51 uint16_to_str_addr:
uint16_to_str_addr:
    ; 52 de = 0;
    ld   de, 0
    ; 53 do
l7004:
    ; 54 {
    ; 55 pop(a);
    pop  af
    ; 56 *de = a; de++;
    ld   (de), a
    inc  de
    ; 57 } while(flag_nz a |= a);
    or   a
    jp   nz, l7004
l7005:
    ; 58 de--;
    dec  de
    ; 59 hl = de;
    ld   h, d
    ld   l, e
    ; 60 }
    ret
    ; 62 // Умножение HL на DE, результат в HL. BC портить нельзя
    ; 64 void mul16()
mul16:
    ; 65 {
    ; 66 bc = hl;
    ld   b, h
    ld   c, l
    ; 67 hl = 0;
    ld   hl, 0
    ; 68 a = 17;
    ld   a, 17
    ; 69 while()
l7006:
    ; 70 {
    ; 71 a--;
    dec  a
    ; 72 if (flag_z) return;
    ret  z
    ; 73 hl += hl;
    add  hl, hl
    ; 74 ex(hl, de);
    ex de, hl
    ; 75 if (flag_c)
    ; 76 {
    jp   nc, l7008
    ; 77 hl += hl;
    add  hl, hl
    ; 78 hl++;
    inc  hl
    ; 79 }
    ; 80 else
    jp   l7009
l7008:
    ; 81 {
    ; 82 hl += hl;
    add  hl, hl
    ; 83 }
l7009:
    ; 84 ex(hl, de);
    ex de, hl
    ; 85 if (flag_nc) continue;
    jp   nc, l7006
    ; 86 hl += bc;
    add  hl, bc
    ; 87 if (flag_nc) continue;
    jp   nc, l7006
    ; 88 de++;
    inc  de
    ; 89 }
    jp   l7006
l7007:
    ; 90 }
    ret
    ; 92 // Добавить элемент в конец массива uint8_t[]
    ; 93 //
    ; 94 // Вход:
    ; 95 //   de - адрес начала массива
    ; 96 //   hl - адрес, где хранится длинна массива
    ; 97 //   c  - максимальное кол-во элементов в массиве
    ; 98 // Выход:
    ; 99 //   z  - В массиве нет места
    ; 101 void addElement(de, hl, c, a)
addElement:
    ; 102 {
    ; 103 b = a;
    ld   b, a
    ; 104 a = *hl;
    ld   a, (hl)
    ; 105 if (a == c) return; // z
    cp   c
    ret  z
    ; 106 (*hl)++;
    inc  (hl)
    ; 107 l = (a += e); h = ((a +@= d) -= l);
    add  e
    ld   l, a
    adc  d
    sub  l
    ld   h, a
    ; 108 *hl = b;
    ld   (hl), b
    ; 109 ++(a ^= a); // return nz
    xor  a
    inc  a
    ; 110 }
    ret
    ; 112 // Удалить элемент из массива
    ; 113 //
    ; 114 // Вход:
    ; 115 //   de - адрес начала массива
    ; 116 //   hl - адрес, где хранится длинна массива
    ; 117 //   c  - максимальное кол-во элементов в массиве
    ; 118 // Выход:
    ; 119 //   z  - В массиве нет места
    ; 121 void removeElement(de, hl, a)
removeElement:
    ; 122 {
    ; 123 (*hl)--;
    dec  (hl)
    ; 124 removeElement2:
removeElement2:
    ; 125 b = a;
    ld   b, a
    ; 126 e = (a += e); d = ((a +@= d) -= e); // de += a
    add  e
    ld   e, a
    adc  d
    sub  e
    ld   d, a
    ; 127 (a = *hl) -= b;
    ld   a, (hl)
    sub  b
    ; 128 if (flag_z) return;
    ret  z
    ; 129 b = 0; c = a;
    ld   b, 0
    ld   c, a
    ; 130 hl = de;
    ld   h, d
    ld   l, e
    ; 131 hl++;
    inc  hl
    ; 132 ldir();
    ldir
    ; 133 }
    ret
    ; 135 void drawSprite2(de, bc, hl)
drawSprite2:
    ; 136 {
    ; 137 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; 138 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; 139 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; 140 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; 141 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; 142 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; 143 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; 144 *bc = a = *de; de++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    ; 145 *hl = a = *de; de++;
    ld   a, (de)
    ld   (hl), a
    inc  de
    ; 146 b = ((a = b) -= 7);
    ld   a, b
    sub  7
    ld   b, a
    ; 147 l++;
    inc  l
    ; 148 c++;
    inc  c
    ; 149 }
    ret
    ; 151 void drawSprite4(bc, hl, de)
drawSprite4:
    ; 152 {
    ; 153 drawSprite2(bc, hl, de);
    call drawSprite2
    ; 154 drawSprite2(bc, hl, de);
    call drawSprite2
    ; 155 l = ((a = l) += [0x20 - 2]); c = l;
    ld   a, l
    add  30
    ld   l, a
    ld   c, l
    ; 156 if (flag_c) { b = ((a = b) += 8); h++; }
    jp   nc, l7010
    ld   a, b
    add  8
    ld   b, a
    inc  h
    ; 157 drawSprite2(bc, hl, de);
l7010:
    call drawSprite2
    ; 158 drawSprite2(bc, hl, de);
    call drawSprite2
    ; 159 }
    ret
    ; 161 void drawSpriteXor(de, bc, hl, ixh)
drawSpriteXor:
    ; 162 {
    ; 163 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; 164 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; 165 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; 166 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; 167 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; 168 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; 169 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; 170 a = *de; de++; *hl = (a ^= *hl);
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    ; 171 h = ((a = h) -= 7);
    ld   a, h
    sub  7
    ld   h, a
    ; 172 l++;
    inc  l
    ; 173 *bc = a = ixh; de++;
    ld   a, ixh
    ld   (bc), a
    inc  de
    ; 174 bc++;
    inc  bc
    ; 175 }
    ret

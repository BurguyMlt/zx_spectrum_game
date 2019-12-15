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
    ; 135 // HL делится на DE, результат в HL, остаток в DE
    ; 137 void div16()
div16:
    ; 138 {
    ; 139 ex(hl, de);
    ex de, hl
    ; 140 if (flag_z (a = h) |= l) return; // Деление на ноль
    ld   a, h
    or   l
    ret  z
    ; 141 bc = 0;
    ld   bc, 0
    ; 142 push(bc);
    push bc
    ; 143 do
l7010:
    ; 144 {
    ; 145 (a = e) -= l;
    ld   a, e
    sub  l
    ; 146 (a = d) -@= h;
    ld   a, d
    sbc  h
    ; 147 if (flag_c) break;
    jp   c, l7011
    ; 148 push(hl);
    push hl
    ; 149 hl += hl;
    add  hl, hl
    ; 150 } while(flag_nc);
    jp   nc, l7010
l7011:
    ; 151 hl = 0;
    ld   hl, 0
    ; 152 while()
l7012:
    ; 153 {
    ; 154 pop(bc);
    pop  bc
    ; 155 (a = b) |= c;
    ld   a, b
    or   c
    ; 156 if (flag_z) return;
    ret  z
    ; 157 hl += hl;
    add  hl, hl
    ; 158 push(de);
    push de
    ; 159 e = ((a = e) -= c);
    ld   a, e
    sub  c
    ld   e, a
    ; 160 d = ((a = d) -@= b);
    ld   a, d
    sbc  b
    ld   d, a
    ; 161 if (flag_c)
    ; 162 {
    jp   nc, l7014
    ; 163 pop(de);
    pop  de
    ; 164 continue;
    jp l7012
    ; 165 }
    ; 166 hl++;
l7014:
    inc  hl
    ; 167 pop(bc);
    pop  bc
    ; 168 }
    jp   l7012
l7013:
    ; 169 }
    ret

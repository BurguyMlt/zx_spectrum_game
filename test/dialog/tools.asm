    ; dialog/tools.c:2 
    ; dialog/tools.c:3 void getItemOfArray8()
getItemOfArray8:
    ; dialog/tools.c:4 {
    ; dialog/tools.c:5 l = (a += l);
    add  l
    ld   l, a
    ; dialog/tools.c:6 h = ((a +@= h) -= l);
    adc  h
    sub  l
    ld   h, a
    ; dialog/tools.c:7 a = *hl;
    ld   a, (hl)
    ; dialog/tools.c:8 }
    ret
    ; dialog/tools.c:9 
    ; dialog/tools.c:10 void getItemOfArray16()
getItemOfArray16:
    ; dialog/tools.c:11 {
    ; dialog/tools.c:12 push(a)
    ; dialog/tools.c:13 {
    push af
    ; dialog/tools.c:14 l = ((a += a) += l);
    add  a
    add  l
    ld   l, a
    ; dialog/tools.c:15 h = ((a +@= h) -= l);
    adc  h
    sub  l
    ld   h, a
    ; dialog/tools.c:16 a = *hl; hl++; h = *hl; l = a;
    ld   a, (hl)
    inc  hl
    ld   h, (hl)
    ld   l, a
    ; dialog/tools.c:17 }
    pop  af
    ; dialog/tools.c:18 }
    ret
    ; dialog/tools.c:19 
    ; dialog/tools.c:20 // b - указывает на максимальное кол-во копируемых символов, размер буфера должен быть на 1 байт больше.
    ; dialog/tools.c:21 
    ; dialog/tools.c:22 void strcpyn(hl, de, b)
strcpyn:
    ; dialog/tools.c:23 {
    ; dialog/tools.c:24 do
l7000:
    ; dialog/tools.c:25 {
    ; dialog/tools.c:26 a = *de; de++;
    ld   a, (de)
    inc  de
    ; dialog/tools.c:27 if (a == 0) break;
    or   a
    jp   z, l7001
    ; dialog/tools.c:28 *hl = a; hl++;
    ld   (hl), a
    inc  hl
    ; dialog/tools.c:29 } while(--b);
    djnz l7000
l7001:
    ; dialog/tools.c:30 *hl = 0;
    ld   (hl), 0
    ; dialog/tools.c:31 }
    ret
    ; dialog/tools.c:32 
    ; dialog/tools.c:33 void numberToString16(hl, de)
numberToString16:
    ; dialog/tools.c:34 {
    ; dialog/tools.c:35 *[&uint16_to_str_addr + 1] = hl;
    ld   ((uint16_to_str_addr) + (1)), hl
    ; dialog/tools.c:36 
    ; dialog/tools.c:37 // Терминатор
    ; dialog/tools.c:38 a ^= a;
    xor  a
    ; dialog/tools.c:39 push(a);
    push af
    ; dialog/tools.c:40 
    ; dialog/tools.c:41 // Разделение числа на цифры
    ; dialog/tools.c:42 ex(hl, de);
    ex de, hl
    ; dialog/tools.c:43 do
l7002:
    ; dialog/tools.c:44 {
    ; dialog/tools.c:45 div16(hl, de = 10);
    ld   de, 10
    call div16
    ; dialog/tools.c:46 (a = e) += '0';
    ld   a, e
    add  48
    ; dialog/tools.c:47 push(a);
    push af
    ; dialog/tools.c:48 } while (flag_nz (a = h) |= l);
    ld   a, h
    or   l
    jp   nz, l7002
l7003:
    ; dialog/tools.c:49 
    ; dialog/tools.c:50 // Вывод в строку
    ; dialog/tools.c:51 uint16_to_str_addr:
uint16_to_str_addr:
    ; dialog/tools.c:52 de = 0;
    ld   de, 0
    ; dialog/tools.c:53 do
l7004:
    ; dialog/tools.c:54 {
    ; dialog/tools.c:55 pop(a);
    pop  af
    ; dialog/tools.c:56 *de = a; de++;
    ld   (de), a
    inc  de
    ; dialog/tools.c:57 } while(flag_nz a |= a);
    or   a
    jp   nz, l7004
l7005:
    ; dialog/tools.c:58 de--;
    dec  de
    ; dialog/tools.c:59 hl = de;
    ld   h, d
    ld   l, e
    ; dialog/tools.c:60 }
    ret
    ; dialog/tools.c:61 
    ; dialog/tools.c:62 // Умножение HL на DE, результат в HL. BC портить нельзя
    ; dialog/tools.c:63 
    ; dialog/tools.c:64 void mul16()
mul16:
    ; dialog/tools.c:65 {
    ; dialog/tools.c:66 bc = hl;
    ld   b, h
    ld   c, l
    ; dialog/tools.c:67 hl = 0;
    ld   hl, 0
    ; dialog/tools.c:68 a = 17;
    ld   a, 17
    ; dialog/tools.c:69 while()
l7006:
    ; dialog/tools.c:70 {
    ; dialog/tools.c:71 a--;
    dec  a
    ; dialog/tools.c:72 if (flag_z) return;
    ret  z
    ; dialog/tools.c:73 hl += hl;
    add  hl, hl
    ; dialog/tools.c:74 ex(hl, de);
    ex de, hl
    ; dialog/tools.c:75 if (flag_c)
    ; dialog/tools.c:76 {
    jp   nc, l7008
    ; dialog/tools.c:77 hl += hl;
    add  hl, hl
    ; dialog/tools.c:78 hl++;
    inc  hl
    ; dialog/tools.c:79 }
    ; dialog/tools.c:80 else
    jp   l7009
l7008:
    ; dialog/tools.c:81 {
    ; dialog/tools.c:82 hl += hl;
    add  hl, hl
    ; dialog/tools.c:83 }
l7009:
    ; dialog/tools.c:84 ex(hl, de);
    ex de, hl
    ; dialog/tools.c:85 if (flag_nc) continue;
    jp   nc, l7006
    ; dialog/tools.c:86 hl += bc;
    add  hl, bc
    ; dialog/tools.c:87 if (flag_nc) continue;
    jp   nc, l7006
    ; dialog/tools.c:88 de++;
    inc  de
    ; dialog/tools.c:89 }
    jp   l7006
l7007:
    ; dialog/tools.c:90 }
    ret
    ; dialog/tools.c:91 
    ; dialog/tools.c:92 // Добавить элемент в конец массива uint8_t[]
    ; dialog/tools.c:93 //
    ; dialog/tools.c:94 // Вход:
    ; dialog/tools.c:95 //   de - адрес начала массива
    ; dialog/tools.c:96 //   hl - адрес, где хранится длинна массива
    ; dialog/tools.c:97 //   c  - максимальное кол-во элементов в массиве
    ; dialog/tools.c:98 // Выход:
    ; dialog/tools.c:99 //   z  - В массиве нет места
    ; dialog/tools.c:100 
    ; dialog/tools.c:101 void addElement(de, hl, c, a)
addElement:
    ; dialog/tools.c:102 {
    ; dialog/tools.c:103 b = a;
    ld   b, a
    ; dialog/tools.c:104 a = *hl;
    ld   a, (hl)
    ; dialog/tools.c:105 if (a == c) return; // z
    cp   c
    ret  z
    ; dialog/tools.c:106 (*hl)++;
    inc  (hl)
    ; dialog/tools.c:107 l = (a += e); h = ((a +@= d) -= l);
    add  e
    ld   l, a
    adc  d
    sub  l
    ld   h, a
    ; dialog/tools.c:108 *hl = b;
    ld   (hl), b
    ; dialog/tools.c:109 ++(a ^= a); // return nz
    xor  a
    inc  a
    ; dialog/tools.c:110 }
    ret
    ; dialog/tools.c:111 
    ; dialog/tools.c:112 // Удалить элемент из массива
    ; dialog/tools.c:113 //
    ; dialog/tools.c:114 // Вход:
    ; dialog/tools.c:115 //   de - адрес начала массива
    ; dialog/tools.c:116 //   hl - адрес, где хранится длинна массива
    ; dialog/tools.c:117 //   c  - максимальное кол-во элементов в массиве
    ; dialog/tools.c:118 // Выход:
    ; dialog/tools.c:119 //   z  - В массиве нет места
    ; dialog/tools.c:120 
    ; dialog/tools.c:121 void removeElement(de, hl, a)
removeElement:
    ; dialog/tools.c:122 {
    ; dialog/tools.c:123 (*hl)--;
    dec  (hl)
    ; dialog/tools.c:124 removeElement2:
removeElement2:
    ; dialog/tools.c:125 b = a;
    ld   b, a
    ; dialog/tools.c:126 e = (a += e); d = ((a +@= d) -= e); // de += a
    add  e
    ld   e, a
    adc  d
    sub  e
    ld   d, a
    ; dialog/tools.c:127 (a = *hl) -= b;
    ld   a, (hl)
    sub  b
    ; dialog/tools.c:128 if (flag_z) return;
    ret  z
    ; dialog/tools.c:129 b = 0; c = a;
    ld   b, 0
    ld   c, a
    ; dialog/tools.c:130 hl = de;
    ld   h, d
    ld   l, e
    ; dialog/tools.c:131 hl++;
    inc  hl
    ; dialog/tools.c:132 ldir();
    ldir
    ; dialog/tools.c:133 }
    ret
    ; dialog/tools.c:134 
    ; dialog/tools.c:135 void drawSprite2(de, bc, hl)
drawSprite2:
    ; dialog/tools.c:136 {
    ; dialog/tools.c:137 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; dialog/tools.c:138 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; dialog/tools.c:139 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; dialog/tools.c:140 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; dialog/tools.c:141 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; dialog/tools.c:142 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; dialog/tools.c:143 *bc = a = *de; de++; b++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    inc  b
    ; dialog/tools.c:144 *bc = a = *de; de++;
    ld   a, (de)
    ld   (bc), a
    inc  de
    ; dialog/tools.c:145 *hl = a = *de; de++;
    ld   a, (de)
    ld   (hl), a
    inc  de
    ; dialog/tools.c:146 b = ((a = b) -= 7);
    ld   a, b
    sub  7
    ld   b, a
    ; dialog/tools.c:147 l++;
    inc  l
    ; dialog/tools.c:148 c++;
    inc  c
    ; dialog/tools.c:149 }
    ret
    ; dialog/tools.c:150 
    ; dialog/tools.c:151 void drawSprite4(bc, hl, de)
drawSprite4:
    ; dialog/tools.c:152 {
    ; dialog/tools.c:153 drawSprite2(bc, hl, de);
    call drawSprite2
    ; dialog/tools.c:154 drawSprite2(bc, hl, de);
    call drawSprite2
    ; dialog/tools.c:155 l = ((a = l) += [0x20 - 2]); c = l;
    ld   a, l
    add  30
    ld   l, a
    ld   c, l
    ; dialog/tools.c:156 if (flag_c) { b = ((a = b) += 8); h++; }
    jp   nc, l7010
    ld   a, b
    add  8
    ld   b, a
    inc  h
    ; dialog/tools.c:157 drawSprite2(bc, hl, de);
l7010:
    call drawSprite2
    ; dialog/tools.c:158 drawSprite2(bc, hl, de);
    call drawSprite2
    ; dialog/tools.c:159 }
    ret
    ; dialog/tools.c:160 
    ; dialog/tools.c:161 void drawSpriteXor(de, bc, hl, ixh)
drawSpriteXor:
    ; dialog/tools.c:162 {
    ; dialog/tools.c:163 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; dialog/tools.c:164 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; dialog/tools.c:165 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; dialog/tools.c:166 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; dialog/tools.c:167 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; dialog/tools.c:168 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; dialog/tools.c:169 a = *de; de++; *hl = (a ^= *hl); h++;
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    inc  h
    ; dialog/tools.c:170 a = *de; de++; *hl = (a ^= *hl);
    ld   a, (de)
    inc  de
    xor  (hl)
    ld   (hl), a
    ; dialog/tools.c:171 h = ((a = h) -= 7);
    ld   a, h
    sub  7
    ld   h, a
    ; dialog/tools.c:172 l++;
    inc  l
    ; dialog/tools.c:173 *bc = a = ixh; de++;
    ld   a, ixh
    ld   (bc), a
    inc  de
    ; dialog/tools.c:174 bc++;
    inc  bc
    ; dialog/tools.c:175 }
    ret
    ; dialog/tools.c:176 
    ; dialog/tools.c:177 void drawTextRight(hl, de, a)
drawTextRight:
    ; dialog/tools.c:178 {
    ; dialog/tools.c:179 push(a)
    ; dialog/tools.c:180 {
    push af
    ; dialog/tools.c:181 push(hl, de)
    ; dialog/tools.c:182 {
    push hl
    push de
    ; dialog/tools.c:183 gMeasureText(de); // Вход: de - текст. Выход: de - текст, a - терминатор, c - ширина в пикселях. Портит: b, hl.
    call gMeasureText
    ; dialog/tools.c:184 }
    pop  de
    pop  hl
    ; dialog/tools.c:185 l = ((a = l) -= c);
    ld   a, l
    sub  c
    ld   l, a
    ; dialog/tools.c:186 }
    pop  af
    ; dialog/tools.c:187 gDrawTextEx(hl, de, a);
    call gDrawTextEx
    ; dialog/tools.c:188 }
    ret
    ; dialog/tools.c:189 

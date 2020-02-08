    ; city/tools.c:2 
    ; city/tools.c:3 void getItemOfArray8()
getItemOfArray8:
    ; city/tools.c:4 {
    ; city/tools.c:5 l = (a += l);
    add  l
    ld   l, a
    ; city/tools.c:6 h = ((a +@= h) -= l);
    adc  h
    sub  l
    ld   h, a
    ; city/tools.c:7 a = *hl;
    ld   a, (hl)
    ; city/tools.c:8 }
    ret
    ; city/tools.c:9 
    ; city/tools.c:10 void getItemOfArray16()
getItemOfArray16:
    ; city/tools.c:11 {
    ; city/tools.c:12 push(a)
    ; city/tools.c:13 {
    push af
    ; city/tools.c:14 l = ((a += a) += l);
    add  a
    add  l
    ld   l, a
    ; city/tools.c:15 h = ((a +@= h) -= l);
    adc  h
    sub  l
    ld   h, a
    ; city/tools.c:16 a = *hl; hl++; h = *hl; l = a;
    ld   a, (hl)
    inc  hl
    ld   h, (hl)
    ld   l, a
    ; city/tools.c:17 }
    pop  af
    ; city/tools.c:18 }
    ret
    ; city/tools.c:19 
    ; city/tools.c:20 // b - указывает на максимальное кол-во копируемых символов, размер буфера должен быть на 1 байт больше.
    ; city/tools.c:21 
    ; city/tools.c:22 void strcpyn(hl, de, b)
strcpyn:
    ; city/tools.c:23 {
    ; city/tools.c:24 do
l7000:
    ; city/tools.c:25 {
    ; city/tools.c:26 a = *de; de++;
    ld   a, (de)
    inc  de
    ; city/tools.c:27 if (flag_z a |= a) break;
    or   a
    jp   z, l7001
    ; city/tools.c:28 *hl = a; hl++;
    ld   (hl), a
    inc  hl
    ; city/tools.c:29 } while(--b);
    djnz l7000
l7001:
    ; city/tools.c:30 *hl = 0;
    ld   (hl), 0
    ; city/tools.c:31 }
    ret
    ; city/tools.c:32 
    ; city/tools.c:33 void numberToString16(hl, de)
numberToString16:
    ; city/tools.c:34 {
    ; city/tools.c:35 *[&uint16_to_str_addr + 1] = hl;
    ld   ((uint16_to_str_addr) + (1)), hl
    ; city/tools.c:36 
    ; city/tools.c:37 // Терминатор
    ; city/tools.c:38 a ^= a;
    xor  a
    ; city/tools.c:39 push(a);
    push af
    ; city/tools.c:40 
    ; city/tools.c:41 // Разделение числа на цифры
    ; city/tools.c:42 ex(hl, de);
    ex de, hl
    ; city/tools.c:43 do
l7002:
    ; city/tools.c:44 {
    ; city/tools.c:45 div16(hl, de = 10);
    ld   de, 10
    call div16
    ; city/tools.c:46 (a = e) += '0';
    ld   a, e
    add  48
    ; city/tools.c:47 push(a);
    push af
    ; city/tools.c:48 } while (flag_nz (a = h) |= l);
    ld   a, h
    or   l
    jp   nz, l7002
l7003:
    ; city/tools.c:49 
    ; city/tools.c:50 // Вывод в строку
    ; city/tools.c:51 uint16_to_str_addr:
uint16_to_str_addr:
    ; city/tools.c:52 de = 0;
    ld   de, 0
    ; city/tools.c:53 do
l7004:
    ; city/tools.c:54 {
    ; city/tools.c:55 pop(a);
    pop  af
    ; city/tools.c:56 *de = a; de++;
    ld   (de), a
    inc  de
    ; city/tools.c:57 } while(flag_nz a |= a);
    or   a
    jp   nz, l7004
l7005:
    ; city/tools.c:58 de--;
    dec  de
    ; city/tools.c:59 hl = de;
    ld   h, d
    ld   l, e
    ; city/tools.c:60 }
    ret
    ; city/tools.c:61 
    ; city/tools.c:62 // Умножение HL на DE, результат в HL. BC портить нельзя
    ; city/tools.c:63 
    ; city/tools.c:64 void mul16()
mul16:
    ; city/tools.c:65 {
    ; city/tools.c:66 bc = hl;
    ld   b, h
    ld   c, l
    ; city/tools.c:67 hl = 0;
    ld   hl, 0
    ; city/tools.c:68 a = 17;
    ld   a, 17
    ; city/tools.c:69 while()
l7006:
    ; city/tools.c:70 {
    ; city/tools.c:71 a--;
    dec  a
    ; city/tools.c:72 if (flag_z) return;
    ret  z
    ; city/tools.c:73 hl += hl;
    add  hl, hl
    ; city/tools.c:74 ex(hl, de);
    ex de, hl
    ; city/tools.c:75 if (flag_c)
    ; city/tools.c:76 {
    jp   nc, l7008
    ; city/tools.c:77 hl += hl;
    add  hl, hl
    ; city/tools.c:78 hl++;
    inc  hl
    ; city/tools.c:79 }
    ; city/tools.c:80 else
    jp   l7009
l7008:
    ; city/tools.c:81 {
    ; city/tools.c:82 hl += hl;
    add  hl, hl
    ; city/tools.c:83 }
l7009:
    ; city/tools.c:84 ex(hl, de);
    ex de, hl
    ; city/tools.c:85 if (flag_nc) continue;
    jp   nc, l7006
    ; city/tools.c:86 hl += bc;
    add  hl, bc
    ; city/tools.c:87 if (flag_nc) continue;
    jp   nc, l7006
    ; city/tools.c:88 de++;
    inc  de
    ; city/tools.c:89 }
    jp   l7006
l7007:
    ; city/tools.c:90 }
    ret
    ; city/tools.c:91 
    ; city/tools.c:92 // Добавить элемент в конец массива uint8_t[]
    ; city/tools.c:93 //
    ; city/tools.c:94 // Вход:
    ; city/tools.c:95 //   de - адрес начала массива
    ; city/tools.c:96 //   hl - адрес, где хранится длинна массива
    ; city/tools.c:97 //   c  - максимальное кол-во элементов в массиве
    ; city/tools.c:98 // Выход:
    ; city/tools.c:99 //   z  - В массиве нет места
    ; city/tools.c:100 
    ; city/tools.c:101 void addElement(de, hl, c, a)
addElement:
    ; city/tools.c:102 {
    ; city/tools.c:103 b = a;
    ld   b, a
    ; city/tools.c:104 a = *hl;
    ld   a, (hl)
    ; city/tools.c:105 if (a == c) return; // z
    cp   c
    ret  z
    ; city/tools.c:106 (*hl)++;
    inc  (hl)
    ; city/tools.c:107 l = (a += e); h = ((a +@= d) -= l);
    add  e
    ld   l, a
    adc  d
    sub  l
    ld   h, a
    ; city/tools.c:108 *hl = b;
    ld   (hl), b
    ; city/tools.c:109 ++(a ^= a); // return nz
    xor  a
    inc  a
    ; city/tools.c:110 }
    ret
    ; city/tools.c:111 
    ; city/tools.c:112 // Удалить элемент из массива
    ; city/tools.c:113 //
    ; city/tools.c:114 // Вход:
    ; city/tools.c:115 //   de - адрес начала массива
    ; city/tools.c:116 //   hl - адрес, где хранится длинна массива
    ; city/tools.c:117 //   c  - максимальное кол-во элементов в массиве
    ; city/tools.c:118 // Выход:
    ; city/tools.c:119 //   z  - В массиве нет места
    ; city/tools.c:120 
    ; city/tools.c:121 void removeElement(de, hl, a)
removeElement:
    ; city/tools.c:122 {
    ; city/tools.c:123 (*hl)--;
    dec  (hl)
    ; city/tools.c:124 removeElement2:
removeElement2:
    ; city/tools.c:125 b = a;
    ld   b, a
    ; city/tools.c:126 e = (a += e); d = ((a +@= d) -= e); // de += a
    add  e
    ld   e, a
    adc  d
    sub  e
    ld   d, a
    ; city/tools.c:127 (a = *hl) -= b;
    ld   a, (hl)
    sub  b
    ; city/tools.c:128 if (flag_z) return;
    ret  z
    ; city/tools.c:129 b = 0; c = a;
    ld   b, 0
    ld   c, a
    ; city/tools.c:130 hl = de;
    ld   h, d
    ld   l, e
    ; city/tools.c:131 hl++;
    inc  hl
    ; city/tools.c:132 ldir();
    ldir
    ; city/tools.c:133 }
    ret
    ; city/tools.c:134 
    ; city/tools.c:135 // HL делится на DE, результат в HL, остаток в DE
    ; city/tools.c:136 
    ; city/tools.c:137 void div16()
div16:
    ; city/tools.c:138 {
    ; city/tools.c:139 ex(hl, de);
    ex de, hl
    ; city/tools.c:140 if (flag_z (a = h) |= l) return; // Деление на ноль
    ld   a, h
    or   l
    ret  z
    ; city/tools.c:141 bc = 0;
    ld   bc, 0
    ; city/tools.c:142 push(bc);
    push bc
    ; city/tools.c:143 do
l7010:
    ; city/tools.c:144 {
    ; city/tools.c:145 (a = e) -= l;
    ld   a, e
    sub  l
    ; city/tools.c:146 (a = d) -@= h;
    ld   a, d
    sbc  h
    ; city/tools.c:147 if (flag_c) break;
    jp   c, l7011
    ; city/tools.c:148 push(hl);
    push hl
    ; city/tools.c:149 hl += hl;
    add  hl, hl
    ; city/tools.c:150 } while(flag_nc);
    jp   nc, l7010
l7011:
    ; city/tools.c:151 hl = 0;
    ld   hl, 0
    ; city/tools.c:152 while()
l7012:
    ; city/tools.c:153 {
    ; city/tools.c:154 pop(bc);
    pop  bc
    ; city/tools.c:155 (a = b) |= c;
    ld   a, b
    or   c
    ; city/tools.c:156 if (flag_z) return;
    ret  z
    ; city/tools.c:157 hl += hl;
    add  hl, hl
    ; city/tools.c:158 push(de);
    push de
    ; city/tools.c:159 e = ((a = e) -= c);
    ld   a, e
    sub  c
    ld   e, a
    ; city/tools.c:160 d = ((a = d) -@= b);
    ld   a, d
    sbc  b
    ld   d, a
    ; city/tools.c:161 if (flag_c)
    ; city/tools.c:162 {
    jp   nc, l7014
    ; city/tools.c:163 pop(de);
    pop  de
    ; city/tools.c:164 continue;
    jp l7012
    ; city/tools.c:165 }
    ; city/tools.c:166 hl++;
l7014:
    inc  hl
    ; city/tools.c:167 pop(bc);
    pop  bc
    ; city/tools.c:168 }
    jp   l7012
l7013:
    ; city/tools.c:169 }
    ret
    ; city/tools.c:170 

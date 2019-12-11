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
    ; 27 if (flag_z a |= a) goto strncpyBreak;
    or   a
    jp   z, strncpyBreak
    ; 28 *hl = a; hl++;
    ld   (hl), a
    inc  hl
    ; 29 } while(--b);
    djnz l7000
    ; 30 strncpyBreak:
strncpyBreak:
    ; 31 *hl = 0;
    ld   (hl), 0
    ; 32 }
    ret
    ; 34 void numberToString16(hl, de)
numberToString16:
    ; 35 {
    ; 36 *[&uint16_to_str_addr + 1] = hl;
    ld   ((uint16_to_str_addr) + (1)), hl
    ; 38 // Терминатор
    ; 39 a ^= a;
    xor  a
    ; 40 push(a);
    push af
    ; 42 // Разделение числа на цифры
    ; 43 ex(hl, de);
    ex de, hl
    ; 44 do
l7001:
    ; 45 {
    ; 46 div16(hl, de = 10);
    ld   de, 10
    call div16
    ; 47 (a = e) += '0';
    ld   a, e
    add  48
    ; 48 push(a);
    push af
    ; 49 } while (flag_nz (a = h) |= l);
    ld   a, h
    or   l
    jp   nz, l7001
    ; 51 // Вывод в строку
    ; 52 uint16_to_str_addr:
uint16_to_str_addr:
    ; 53 de = 0;
    ld   de, 0
    ; 54 do
l7002:
    ; 55 {
    ; 56 pop(a);
    pop  af
    ; 57 *de = a; de++;
    ld   (de), a
    inc  de
    ; 58 } while(flag_nz a |= a);
    or   a
    jp   nz, l7002
    ; 59 de--;
    dec  de
    ; 60 }
    ret

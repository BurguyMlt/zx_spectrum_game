    ; 3 void numberToString16(hl, de)
numberToString16:
    ; 4 {
    ; 5 *[&uint16_to_str_addr + 1] = hl;
    ld   ((uint16_to_str_addr) + (1)), hl
    ; 7 // Терминатор
    ; 8 a ^= a;
    xor  a
    ; 9 push(a);
    push af
    ; 11 // Разделение числа на цифры
    ; 12 ex(hl, de);
    ex de, hl
    ; 13 do
l7000:
    ; 14 {
    ; 15 div16(hl, de = 10);
    ld   de, 10
    call div16
    ; 16 (a = e) += '0';
    ld   a, e
    add  48
    ; 17 push(a);
    push af
    ; 18 } while (flag_nz (a = h) |= l);
    ld   a, h
    or   l
    jp   nz, l7000
l7001:
    ; 20 // Вывод в строку
    ; 21 uint16_to_str_addr:
uint16_to_str_addr:
    ; 22 de = 0;
    ld   de, 0
    ; 23 do
l7002:
    ; 24 {
    ; 25 pop(a);
    pop  af
    ; 26 *de = a; de++;
    ld   (de), a
    inc  de
    ; 27 } while(flag_nz a |= a);
    or   a
    jp   nz, l7002
l7003:
    ; 28 de--;
    dec  de
    ; 29 hl = de;
    ld   h, d
    ld   l, e
    ; 30 }
    ret
    ; 32 void div16()
div16:
    ; 33 {
    ; 34 ex(hl, de);
    ex de, hl
    ; 35 if (flag_z (a = h) |= l) return; // Деление на ноль
    ld   a, h
    or   l
    ret  z
    ; 36 bc = 0;
    ld   bc, 0
    ; 37 push(bc);
    push bc
    ; 38 do
l7004:
    ; 39 {
    ; 40 (a = e) -= l;
    ld   a, e
    sub  l
    ; 41 (a = d) -@= h;
    ld   a, d
    sbc  h
    ; 42 if (flag_c) break;
    jp   c, l7005
    ; 43 push(hl);
    push hl
    ; 44 hl += hl;
    add  hl, hl
    ; 45 } while(flag_nc);
    jp   nc, l7004
l7005:
    ; 46 hl = 0;
    ld   hl, 0
    ; 47 while()
l7006:
    ; 48 {
    ; 49 pop(bc);
    pop  bc
    ; 50 (a = b) |= c;
    ld   a, b
    or   c
    ; 51 if (flag_z) return;
    ret  z
    ; 52 hl += hl;
    add  hl, hl
    ; 53 push(de);
    push de
    ; 54 e = ((a = e) -= c);
    ld   a, e
    sub  c
    ld   e, a
    ; 55 d = ((a = d) -@= b);
    ld   a, d
    sbc  b
    ld   d, a
    ; 56 if (flag_c)
    ; 57 {
    jp   nc, l7008
    ; 58 pop(de);
    pop  de
    ; 59 continue;
    jp l7006
    ; 60 }
    ; 61 hl++;
l7008:
    inc  hl
    ; 62 pop(bc);
    pop  bc
    ; 63 }
    jp   l7006
l7007:
    ; 64 }
    ret

    ; base/tools.c:2 
    ; base/tools.c:3 void numberToString16(hl, de)
numberToString16:
    ; base/tools.c:4 {
    ; base/tools.c:5 *[&uint16_to_str_addr + 1] = hl;
    ld   ((uint16_to_str_addr) + (1)), hl
    ; base/tools.c:6 
    ; base/tools.c:7 // Терминатор
    ; base/tools.c:8 a ^= a;
    xor  a
    ; base/tools.c:9 push(a);
    push af
    ; base/tools.c:10 
    ; base/tools.c:11 // Разделение числа на цифры
    ; base/tools.c:12 ex(hl, de);
    ex de, hl
    ; base/tools.c:13 do
l7000:
    ; base/tools.c:14 {
    ; base/tools.c:15 div16(hl, de = 10);
    ld   de, 10
    call div16
    ; base/tools.c:16 (a = e) += '0';
    ld   a, e
    add  48
    ; base/tools.c:17 push(a);
    push af
    ; base/tools.c:18 } while (flag_nz (a = h) |= l);
    ld   a, h
    or   l
    jp   nz, l7000
l7001:
    ; base/tools.c:19 
    ; base/tools.c:20 // Вывод в строку
    ; base/tools.c:21 uint16_to_str_addr:
uint16_to_str_addr:
    ; base/tools.c:22 de = 0;
    ld   de, 0
    ; base/tools.c:23 do
l7002:
    ; base/tools.c:24 {
    ; base/tools.c:25 pop(a);
    pop  af
    ; base/tools.c:26 *de = a; de++;
    ld   (de), a
    inc  de
    ; base/tools.c:27 } while(flag_nz a |= a);
    or   a
    jp   nz, l7002
l7003:
    ; base/tools.c:28 de--;
    dec  de
    ; base/tools.c:29 hl = de;
    ld   h, d
    ld   l, e
    ; base/tools.c:30 }
    ret
    ; base/tools.c:31 
    ; base/tools.c:32 void div16()
div16:
    ; base/tools.c:33 {
    ; base/tools.c:34 ex(hl, de);
    ex de, hl
    ; base/tools.c:35 if (flag_z (a = h) |= l) return; // Деление на ноль
    ld   a, h
    or   l
    ret  z
    ; base/tools.c:36 bc = 0;
    ld   bc, 0
    ; base/tools.c:37 push(bc);
    push bc
    ; base/tools.c:38 do
l7004:
    ; base/tools.c:39 {
    ; base/tools.c:40 (a = e) -= l;
    ld   a, e
    sub  l
    ; base/tools.c:41 (a = d) -@= h;
    ld   a, d
    sbc  h
    ; base/tools.c:42 if (flag_c) break;
    jp   c, l7005
    ; base/tools.c:43 push(hl);
    push hl
    ; base/tools.c:44 hl += hl;
    add  hl, hl
    ; base/tools.c:45 } while(flag_nc);
    jp   nc, l7004
l7005:
    ; base/tools.c:46 hl = 0;
    ld   hl, 0
    ; base/tools.c:47 while()
l7006:
    ; base/tools.c:48 {
    ; base/tools.c:49 pop(bc);
    pop  bc
    ; base/tools.c:50 (a = b) |= c;
    ld   a, b
    or   c
    ; base/tools.c:51 if (flag_z) return;
    ret  z
    ; base/tools.c:52 hl += hl;
    add  hl, hl
    ; base/tools.c:53 push(de);
    push de
    ; base/tools.c:54 e = ((a = e) -= c);
    ld   a, e
    sub  c
    ld   e, a
    ; base/tools.c:55 d = ((a = d) -@= b);
    ld   a, d
    sbc  b
    ld   d, a
    ; base/tools.c:56 if (flag_c)
    ; base/tools.c:57 {
    jp   nc, l7008
    ; base/tools.c:58 pop(de);
    pop  de
    ; base/tools.c:59 continue;
    jp l7006
    ; base/tools.c:60 }
    ; base/tools.c:61 hl++;
l7008:
    inc  hl
    ; base/tools.c:62 pop(bc);
    pop  bc
    ; base/tools.c:63 }
    jp   l7006
l7007:
    ; base/tools.c:64 }
    ret
    ; base/tools.c:65 
    ; base/tools.c:66 void getItemOfArray8()
getItemOfArray8:
    ; base/tools.c:67 {
    ; base/tools.c:68 l = (a += l);
    add  l
    ld   l, a
    ; base/tools.c:69 h = ((a +@= h) -= l);
    adc  h
    sub  l
    ld   h, a
    ; base/tools.c:70 a = *hl;
    ld   a, (hl)
    ; base/tools.c:71 }
    ret
    ; base/tools.c:72 

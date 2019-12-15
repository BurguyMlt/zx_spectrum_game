    ; 3 void fillRect(hl, bc)
fillRect:
    ; 4 {
    ; 5 ixl = b;
    ld   ixl, b
    ; 6 do
l3000:
    ; 7 {
    ; 8 a ^= a;
    xor  a
    ; 9 d = h; e = l;
    ld   d, h
    ld   e, l
    ; 10 b = c;
    ld   b, c
    ; 11 do
l3002:
    ; 12 {
    ; 13 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; 14 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; 15 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; 16 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; 17 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; 18 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; 19 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; 20 *hl = a; h = d;
    ld   (hl), a
    ld   h, d
    ; 21 l++;
    inc  l
    ; 22 } while(--b);
    djnz l3002
l3003:
    ; 24 // Адрес следующей строки
    ; 25 l = ((a = e) += 32);
    ld   a, e
    add  32
    ld   l, a
    ; 26 if (flag_c) h = ((a = h) += 8);
    jp   nc, l3004
    ld   a, h
    add  8
    ld   h, a
    ; 27 } while(flag_nz --ixl);
l3004:
    dec  ixl
    jp   nz, l3000
l3001:
    ; 28 }
    ret

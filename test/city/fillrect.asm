    ; 3 void fillRect(hl, bc)
fillRect:
    ; 4 {
    ; 5 do
l3000:
    ; 6 {
    ; 7 push(bc)
    ; 8 {
    push bc
    ; 9 a ^= a;
    xor  a
    ; 10 d = 8;
    ld   d, 8
    ; 11 e = l;
    ld   e, l
    ; 12 do
l3001:
    ; 13 {
    ; 14 b = c;
    ld   b, c
    ; 15 do
l3002:
    ; 16 {
    ; 17 *hl = a; l++;
    ld   (hl), a
    inc  l
    ; 18 } while(--b);
    djnz l3002
    ; 19 l = e;
    ld   l, e
    ; 20 h++;
    inc  h
    ; 21 d--;
    dec  d
    ; 22 } while(flag_nz);
    jp   nz, l3001
    ; 24 // Адрес следующей строки
    ; 25 hl += (de = [0x20 - 0x800]);
    ld   de, -2016
    add  hl, de
    ; 26 a = h;
    ld   a, h
    ; 27 a &= 7;
    and  7
    ; 28 if (flag_nz) fillRectAddLine();
    call nz, fillRectAddLine
    ; 29 }
    pop  bc
    ; 30 } while(--b);
    djnz l3000
    ; 31 }
    ret

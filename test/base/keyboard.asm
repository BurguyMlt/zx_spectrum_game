    ; 3 const int KEY_UP = 1;
    ; 4 const int KEY_DOWN = 2;
    ; 5 const int KEY_LEFT = 4;
    ; 6 const int KEY_RIGHT = 8;
    ; 7 const int KEY_FIRE = 16;
    ; 9 // Использует A, BC, HL
    ; 10 void readKey()
readKey:
    ; 11 {
    ; 12 c = in(bc = 0xEFFE);
    ld   bc, 61438
    in   c, (c)
    ; 13 a ^= a;
    xor  a
    ; 14 if (c & 0x04) a |= KEY_RIGHT;
    bit  2, c
    jp   z, l1000
    or   8
    ; 15 if (c & 0x08) a |= KEY_UP;
l1000:
    bit  3, c
    jp   z, l1001
    or   1
    ; 16 if (c & 0x10) a |= KEY_DOWN;
l1001:
    bit  4, c
    jp   z, l1002
    or   2
    ; 17 c = in(bc = 0xF7FE);
l1002:
    ld   bc, 63486
    in   c, (c)
    ; 18 if (c & 0x10) a |= KEY_LEFT;
    bit  4, c
    jp   z, l1003
    or   4
    ; 19 c = in(bc = 0x7FFE);
l1003:
    ld   bc, 32766
    in   c, (c)
    ; 20 if (c & 0x01) a |= KEY_FIRE;
    bit  0, c
    jp   z, l1004
    or   16
    ; 21 a ^= 0xFF;
l1004:
    xor  255
    ; 23 // Чтение прошлого значения и сохранение нового
    ; 24 b = a;
    ld   b, a
    ; 25 hl = &gKeyPressed;
    ld   hl, gKeyPressed
    ; 26 a = *hl;
    ld   a, (hl)
    ; 27 *hl = b;
    ld   (hl), b
    ; 29 // Выделение события нажатия
    ; 30 a ^= 0xFF;
    xor  255
    ; 31 a &= b;
    and  b
    ; 32 hl = &gKeyTrigger;
    ld   hl, gKeyTrigger
    ; 33 a |= *hl;
    or   (hl)
    ; 34 *hl = a;
    ld   (hl), a
    ; 36 return;
    ret
    ; 37 }
    ret

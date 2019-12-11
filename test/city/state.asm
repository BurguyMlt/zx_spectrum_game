    ; 3 const int playerItemsMax = 5;
    ; 4 uint8_t playerItems[playerItemsMax] = { 0, 1, 2, -1, -1 };
playerItems:
    db 0
    db 1
    db 2
    db -1
    db -1
    ; 6 void playerAddItem(a)
playerAddItem:
    ; 7 {
    ; 8 c = a;
    ld   c, a
    ; 9 hl = &playerItems;
    ld   hl, playerItems
    ; 10 a = 0xFF;
    ld   a, 255
    ; 11 b = playerItemsMax;
    ld   b, 5
    ; 12 do {
l5000:
    ; 13 if (a == *hl)
    cp   (hl)
    ; 14 {
    jp   nz, l5001
    ; 15 *hl = c;
    ld   (hl), c
    ; 16 return; // z
    ret
    ; 17 }
    ; 18 hl++;
l5001:
    inc  hl
    ; 19 } while(--b);
    djnz l5000
    ; 20 b--; // return nz
    dec  b
    ; 21 }
    ret
    ; 23 void playerRemoveItem(a)
playerRemoveItem:
    ; 24 {
    ; 25 c = a;
    ld   c, a
    ; 26 // Адрес удаляемого элемента de = &playerItems + a
    ; 27 e = (a += &playerItems); d = ((a +@= [&playerItems >> 8]) -= e);
    add  playerItems
    ld   e, a
    adc  (playerItems) >> (8)
    sub  e
    ld   d, a
    ; 28 // Адрес следующего за удаляемым элемента
    ; 29 l = e; h = d; hl++;
    ld   l, e
    ld   h, d
    inc  hl
    ; 30 // Сдвигаем элементы, если есть что сдвигать
    ; 31 (a = [playerItemsMax - 1]) -= c;
    ld   a, 4
    sub  c
    ; 32 if (flag_nz)
    ; 33 {
    jp   z, l5002
    ; 34 b = 0; c = a;
    ld   b, 0
    ld   c, a
    ; 35 ldir();
    ldir
    ; 36 }
    ; 37 // Очищаем крайний элемент
    ; 38 *de = a = 0xFF;
l5002:
    ld   a, 255
    ld   (de), a
    ; 39 }
    ret

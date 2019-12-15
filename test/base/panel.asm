    ; 3 const int gPanelChangedMoney = 0x01;
    ; 4 const int gPanelChangedPlace = 0x02;
    ; 6 const int panelMoneyX = 4;
    ; 7 const int panelMoneyY = 22;
    ; 8 const int panelMoneyW = 3;
    ; 9 const int panelMoneyH = 1;
    ; 10 const int panelMoneyColor = 0x4E;
    ; 12 const int panelPlaceX = 4;
    ; 13 const int panelPlaceY = 20;
    ; 14 const int panelPlaceW = 3;
    ; 15 const int panelPlaceH = 1;
    ; 16 const int panelPlaceColor = 0x4E;
    ; 18 void panelRedraw()
panelRedraw:
    ; 19 {
    ; 20 // Нужно ли перерисовать?
    ; 21 hl = &gPanelChangedA;
    ld   hl, gPanelChangedA
    ; 22 if ((a = gVideoPage) & 0x80) hl++;
    ld   a, (gVideoPage)
    bit  7, a
    jp   z, l6000
    inc  hl
    ; 23 a = *hl;
l6000:
    ld   a, (hl)
    ; 24 if (flag_z a |= a) return;
    or   a
    ret  z
    ; 25 *hl = 0;
    ld   (hl), 0
    ; 27 // Надо перерисовать деньги
    ; 28 if (a & gPanelChangedMoney)
    bit  0, a
    ; 29 {
    jp   z, l6001
    ; 30 push(a)
    ; 31 {
    push af
    ; 32 numberToString16(hl = &gStringBuffer, de = gPlayerMoney);
    ld   hl, gStringBuffer
    ld   de, (gPlayerMoney)
    call numberToString16
    ; 34 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; 35 while()
l6002:
    ; 36 {
    ; 37 (a = *hl) -= [48 - 22];
    ld   a, (hl)
    sub  26
    ; 38 if (flag_c) break;
    jp   c, l6003
    ; 39 *hl = a; hl++;
    ld   (hl), a
    inc  hl
    ; 40 }
    jp   l6002
l6003:
    ; 41 hl++; *hl = 2;
    inc  hl
    ld   (hl), 2
    ; 43 gCalcCoords(hl = [panelMoneyY * 8 * 256 + panelMoneyX * 8]);
    ld   hl, 45088
    call gCalcCoords
    ; 44 fillRect(hl, bc = [panelMoneyH * 256 + panelMoneyW]);
    ld   bc, 259
    call fillRect
    ; 46 gCalcCoords(hl = [(panelMoneyY * 8 + 2) * 256 + panelMoneyX * 8]);
    ld   hl, 45600
    call gCalcCoords
    ; 47 gDrawText(hl, c = 0, de = &gStringBuffer, a = panelMoneyColor);
    ld   c, 0
    ld   de, gStringBuffer
    ld   a, 78
    call gDrawText
    ; 48 }
    pop  af
    ; 49 }
    ; 50 /*
    ; 64 }
l6001:
    ret

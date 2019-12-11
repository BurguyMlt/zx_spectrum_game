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
    ; 18 void setPlayerMoney(hl)
setPlayerMoney:
    ; 19 {
    ; 20 gPlayerMoney = hl;
    ld   (gPlayerMoney), hl
    ; 21 hl = &gPanelChanged1;
    ld   hl, gPanelChanged1
    ; 22 *hl |= gPanelChangedMoney;
    set  0, (hl)
    ; 23 hl = &gPanelChanged2;
    ld   hl, gPanelChanged2
    ; 24 *hl |= gPanelChangedMoney;
    set  0, (hl)
    ; 25 }
    ret
    ; 27 void playerMoneyRedraw()
playerMoneyRedraw:
    ; 28 {
    ; 29 // Нужно ли перерисовать?
    ; 30 hl = &gPanelChanged1;
    ld   hl, gPanelChanged1
    ; 31 h = (((a = gVideoPage) &= 0x80) |= h);
    ld   a, (gVideoPage)
    and  128
    or   h
    ld   h, a
    ; 32 a = *hl;
    ld   a, (hl)
    ; 33 if (flag_z a |= a) return;
    or   a
    ret  z
    ; 34 *hl = 0;
    ld   (hl), 0
    ; 36 // Надо перерисовать деньги
    ; 37 if (a & gPanelChangedMoney)
    bit  0, a
    ; 38 {
    jp   z, l6000
    ; 39 push(a)
    ; 40 {
    push af
    ; 41 numberToString16(hl = &tmpString, de = gPlayerMoney);
    ld   hl, tmpString
    ld   de, (gPlayerMoney)
    call numberToString16
    ; 42 gCalcCoords(hl = [panelMoneyY * 8 * 256 + panelMoneyX * 8]);
    ld   hl, 45088
    call gCalcCoords
    ; 43 push(hl);
    push hl
    ; 44 fillRect(hl, bc = [panelMoneyH * 256 + panelMoneyW]);
    ld   bc, 259
    call fillRect
    ; 45 pop(hl);
    pop  hl
    ; 46 gDrawText(hl, c = 0, de = &tmpString, a = panelMoneyColor);
    ld   c, 0
    ld   de, tmpString
    ld   a, 78
    call gDrawText
    ; 47 }
    pop  af
    ; 48 }
    ; 50 if (a & gPanelChangedPlace)
l6000:
    bit  1, a
    ; 51 {
    jp   z, l6001
    ; 52 push(a)
    ; 53 {
    push af
    ; 54 gCalcCoords(hl = [panelPlaceY * 8 * 256 + panelPlaceX * 8]);
    ld   hl, 40992
    call gCalcCoords
    ; 55 push(hl);
    push hl
    ; 56 fillRect(hl, bc = [panelPlaceH * 256 + panelPlaceW]);
    ld   bc, 259
    call fillRect
    ; 57 pop(hl);
    pop  hl
    ; 58 gDrawText(hl, c = 0, de = "Утеха", a = panelPlaceColor);
    ld   c, 0
    ld   de, s6000
    ld   a, 78
    call gDrawText
    ; 59 }
    pop  af
    ; 60 }
    ; 61 }
l6001:
    ret
    ; strings
s6000 db "Утеха",0

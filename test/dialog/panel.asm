    ; 3 const int gPanelX = 0;
    ; 4 const int gPanelY = 20;
    ; 6 void panelFullRedraw()
panelFullRedraw:
    ; 7 {
    ; 8 gDrawImage(de = [0x5800 + gPanelX + (gPanelY << 5)], hl = &image_panelgraph);
    ld   de, 23168
    ld   hl, image_panelgraph
    call gDrawImage
    ; 9 panelDrawSecondWeapon();
    call panelDrawSecondWeapon
    ; 10 }
    ret
    ; 12 void deMulA36(a) // a должно быть меньше 16
deMulA36:
    ; 13 {
    ; 14 a += a += a;
    add  a
    add  a
    ; 15 c = a;
    ld   c, a
    ; 16 a += a += a;
    add  a
    add  a
    ; 17 l = a; h = 0; b = h;
    ld   l, a
    ld   h, 0
    ld   b, h
    ; 18 hl += hl += bc += de;
    add  hl, hl
    add  hl, bc
    add  hl, de
    ; 19 ex(hl, de);
    ex de, hl
    ; 20 }
    ret
    ; 22 void panelDrawSecondWeapon()
panelDrawSecondWeapon:
    ; 23 {
    ; 24 deMulA36(a = secondWeapon, de = &magic_0);
    ld   a, (secondWeapon)
    ld   de, magic_0
    call deMulA36
    ; 25 drawSprite4(hl = 0x5AB8, bc = 0x50B8, de);
    ld   hl, 23224
    ld   bc, 20664
    call drawSprite4
    ; 26 return panelDrawSecondWeaponCount();
    jp   panelDrawSecondWeaponCount
    ; 27 }
    ret
    ; 29 void panelDrawSecondWeaponCount()
panelDrawSecondWeaponCount:
    ; 30 {
    ; 31 gDrawTextEx(hl = [24 * 8 + 3 + 186 * 256], de = "\x1F\x1F\x02", a = [0x40 + 1 * 8 + 7]);
    ld   hl, 47811
    ld   de, s21000
    ld   a, 79
    call gDrawTextEx
    ; 32 }
    ret
    ; strings
s21000 db 31,31,2,0

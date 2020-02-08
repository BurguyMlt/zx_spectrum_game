    ; dialog/panel.c:2 
    ; dialog/panel.c:3 const int gPanelX = 0;
    ; dialog/panel.c:4 const int gPanelY = 20;
    ; dialog/panel.c:5 
    ; dialog/panel.c:6 void panelFullRedraw()
panelFullRedraw:
    ; dialog/panel.c:7 {
    ; dialog/panel.c:8 gDrawImage(de = [0x5800 + gPanelX + (gPanelY << 5)], hl = &image_panelgraph);
    ld   de, 23168
    ld   hl, image_panelgraph
    call gDrawImage
    ; dialog/panel.c:9 return panelRedrawImages();
    jp   panelRedrawImages
    ; dialog/panel.c:10 }
    ret
    ; dialog/panel.c:11 
    ; dialog/panel.c:12 void panelRedrawImages()
panelRedrawImages:
    ; dialog/panel.c:13 {
    ; dialog/panel.c:14 panelDrawSecondWeapon();
    call panelDrawSecondWeapon
    ; dialog/panel.c:15 }
    ret
    ; dialog/panel.c:16 
    ; dialog/panel.c:17 void deMulA36(a) // a должно быть меньше 16
deMulA36:
    ; dialog/panel.c:18 {
    ; dialog/panel.c:19 a += a += a;
    add  a
    add  a
    ; dialog/panel.c:20 c = a;
    ld   c, a
    ; dialog/panel.c:21 a += a += a;
    add  a
    add  a
    ; dialog/panel.c:22 l = a; h = 0; b = h;
    ld   l, a
    ld   h, 0
    ld   b, h
    ; dialog/panel.c:23 hl += hl += bc += de;
    add  hl, hl
    add  hl, bc
    add  hl, de
    ; dialog/panel.c:24 ex(hl, de);
    ex de, hl
    ; dialog/panel.c:25 }
    ret
    ; dialog/panel.c:26 
    ; dialog/panel.c:27 void panelDrawSecondWeapon()
panelDrawSecondWeapon:
    ; dialog/panel.c:28 {
    ; dialog/panel.c:29 deMulA36(a = gPlayerSecondWeaponSel, de = &magic_0);
    ld   a, (gPlayerSecondWeaponSel)
    ld   de, magic_0
    call deMulA36
    ; dialog/panel.c:30 return drawSprite4(hl = 0x5AB8, bc = 0x50B8, de);
    ld   hl, 23224
    ld   bc, 20664
    jp   drawSprite4
    ; dialog/panel.c:31 }
    ret
    ; dialog/panel.c:32 

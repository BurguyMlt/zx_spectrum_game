#counter 21000

const int gPanelX = 0;
const int gPanelY = 20;

void panelFullRedraw()
{
    gDrawImage(de = [0x5800 + gPanelX + (gPanelY << 5)], hl = &image_panelgraph);
    panelDrawSecondWeapon();
}

void deMulA36(a) // a должно быть меньше 16
{
    a += a += a;
    c = a;
    a += a += a;
    l = a; h = 0; b = h;
    hl += hl += bc += de;
    ex(hl, de);
}

void panelDrawSecondWeapon()
{
    deMulA36(a = secondWeapon, de = &magic_0);
    drawSprite4(hl = 0x5AB8, bc = 0x50B8, de);
    return panelDrawSecondWeaponCount();
}

void panelDrawSecondWeaponCount()
{
    gDrawTextEx(hl = [24 * 8 + 3 + 186 * 256], de = "\x1F\x1F\x02", a = [0x40 + 1 * 8 + 7]);
}

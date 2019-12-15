#counter 16000

const int KEY_UP = 1;
const int KEY_DOWN = 2;
const int KEY_LEFT = 4;
const int KEY_RIGHT = 8;
const int KEY_FIRE = 16;

const int secondWeaponBwAddrForPict = 0x4042;
const int secondWeaponClAddrForPict = 0x5842;
const int secondWeaponCount = 9;
const int secondWeaponTextPos = 35 * 256 + 19;
const int secondWeaponTextInactiveColor = 0x41;
const int secondWeaponTextActiveColor = 0x47;
const int itemsPos = 7 * 8 * 256 + 16;
const int itemsCursorPos = 7 * 8 * 256 + 9;
const int itemsCursorColor = 0x43;
const int lutPos = 7 * 8 * 256 + 144;

uint8_t secondWeapon = 4;
uint8_t selectedItem = 0;

void invent()
{
    gBeginDraw();

    // Очистка экрана
    hl = 0x4000;
    *hl = l;
    ldir(hl, de = 0x4001, bc = [32 * 64 * 2 + 32 * 4 - 1]);
    a = 7;
    do
    {
        (hl = [32 * 4]) += de;
        ex(hl, de);
        ldir(hl = 0x4000, de, bc = [32 * 4]);
    } while(flag_nz --a);

    // Заливаем одним цветом
    hl = 0x5800;
    *hl = 0x44;
    ldir(hl, de = 0x5801, bc = [32 * 20 - 1]);

    // Рисуем
    bc = 0x4000;
    de = &inventgraphMap;
    while()
    {
inventBlank2:
        a = *de; de++;
        if (a >= 128)
        {
            if (flag_z) break;
            a -= 128;
            c = (a += c);
            if (flag_c) b = ((a = b) += 8);
            continue;
        }
        // Вычисление адреса
        a += a += a;
        l = (a += [&inventgraphTails >> 1]);
        h = ((a +@= [&inventgraphTails >> 9]) -= l);
        hl += hl;
        // Запись
        *bc = a = *hl; l++; b++; // Тайлы не пересекают 256-байтную страницу
        *bc = a = *hl; l++; b++;
        *bc = a = *hl; l++; b++;
        *bc = a = *hl; l++; b++;
        *bc = a = *hl; l++; b++;
        *bc = a = *hl; l++; b++;
        *bc = a = *hl; l++; b++;
        *bc = a = *hl;
        // Следующий адрес
        b = ((a = b) -= 7);
        c++;
        if (flag_z) b = ((a = b) += 8);
    }

    // Пиктограммы второго оружия
    bc = secondWeaponBwAddrForPict; //0x4042;
    hl = secondWeaponClAddrForPict; //0x5842;
    d = 0;
    do
    {
        push(bc, de)
        {
            push(hl)
            {
                h = 0; l = d;
                hl += hl += hl; de = hl; (hl += hl += hl += hl) += de; hl += (de = &magic_0); ex(hl, de); // *36
            }
            push(hl)
            {
                drawSprite4(bc, hl, de);
            }
        }
        l = ((a = l) += 3); c = l;
        d++;
    } while((a = d) < secondWeaponCount);

    // Кол-во второго оружия
    b = secondWeaponCount;
    hl = secondWeaponTextPos;
    do
    {
        push(bc, hl)
        {
            gDrawTextEx(hl, de = "\x1F\x1F\x02", a = secondWeaponTextInactiveColor);
        }
        l = ((a = l) += 24);
    } while(--b);

    // Предметы
    b = 5;
    hl = itemsPos;
    do
    {
        ex(hl, de);
        getItemOfArray16(hl = &itemNames, --(a = b));
        ex(hl, de);
        push(bc, hl)
        {
            gDrawTextEx(hl, de, a = secondWeaponTextActiveColor);
        }
        h = ((a = h) += 10);
    } while(--b);

    // ЛУТ
    b = 9;
    hl = lutPos;
    do
    {
        ex(hl, de);
        getItemOfArray16(hl = &lutNames, --(a = b));
        ex(hl, de);
        push(bc, hl)
        {
            gDrawTextEx(hl, de, a = 0x47);
        }
        push(bc, hl)
        {
            push(hl)
            {
                gMeasureText(de = "99"); // Вход: de - текст. Выход: de - текст, a - терминатор, c - ширина в пикселях. Портит: b, hl.
            }
            l = ((a = 248) -= c);
            gDrawTextEx(hl, de = "99", a = 0x47);
        }
        h = ((a = h) += 10);
    } while(--b);

    // Основное оружие
    drawSprite4(hl = 0x59E1, bc = 0x48E1, de = [&magic_0 + 36]);
    gDrawTextEx(hl = [15 * 8 * 256 + 28], de = "Обычное оружие", a = 0x47);
    gDrawTextEx(hl = [(15 * 8 + 9) * 256 + 28], de = "\x16\x17\x18\x15\x19\x1A\x1B\x02", a = 0x46);

    // Защита
    drawSprite4(hl = 0x5A21, bc = 0x5021, de = [&magic_0 + 36 * 3]);
    gDrawTextEx(hl = [17 * 8 * 256 + 28], de = "Обычная защита", a = 0x47);
    gDrawTextEx(hl = [(17 * 8 + 9) * 256 + 28], de = "\x1A\x1B\x1C\x15\x1D\x1E\x1F\x02", a = 0x46);

    // Ключ
    drawSprite4(hl = 0x5A2E, bc = 0x502E, de = [&magic_0 + 36 * 9]);

    drawSecondWeaponCursor(ixh = 0x47);

    drawItemCursor();

    gEndDraw();

    while()
    {
        hl = &gKeyTrigger;
        a = *hl;
        *hl = 0;
        if (a & KEY_LEFT)
        {
            a = secondWeapon;
            a-=1;
            if (flag_c) continue;
            setSecondWeapon(a);
        }
        else if (a & KEY_RIGHT)
        {
            a = secondWeapon;
            a++;
            if (a >= secondWeaponCount) continue;
            setSecondWeapon(a);
        }
        else if (a & KEY_UP)
        {
            a = selectedItem;
            a-=1;
            if (flag_c) continue;
            selectItem(a);
        }
        else if (a & KEY_DOWN)
        {
            a = selectedItem;
            a++;
            if (a >= 5) continue; //*(hl = &gPlayerItemsCount)) continue;
            selectItem(a);
        }
    }
}

void drawItemCursor(de)
{
    a = selectedItem;
    a += a; b = a; (a += a += a) += b; // *10
    hl = itemsCursorPos; h = (a += h);
    gDrawTextEx(hl, de = "@", a = itemsCursorColor);
}

void selectItem()
{
    push(a)
    {
        drawItemCursor();
    }
    selectedItem = a;
    drawItemCursor();
}

void setSecondWeapon(a)
{
    push(a)
    {
        drawSecondWeaponCursor(ixh = secondWeaponTextInactiveColor);
    }
    secondWeapon = a;
    drawSecondWeaponCursor(ixh = secondWeaponTextActiveColor);

    return panelDrawSecondWeapon();
}

void drawSecondWeaponCursor(ixh)
{
    // Курсор
    a = secondWeapon;
    b = a; (a += a) += b;
    hl = [secondWeaponBwAddrForPict - 0x21]; l = (a += l);
    b = [(secondWeaponClAddrForPict - 0x21) >> 8]; c = l;
    de = &magic_10;
    drawSpriteXor(bc, hl, de);
    drawSpriteXor(bc, hl, de);
    drawSpriteXor(bc, hl, de);
    drawSpriteXor(bc, hl, de);
    ixl = 2;
    do
    {
        l = ((a = l) += [0x20 - 4]); c = l;
        drawSpriteXor(bc, hl, de);
        l++; l++; c = l;
        drawSpriteXor(bc, hl, de);
    } while (flag_nz --ixl);
    l = ((a = l) += [0x20 - 4]); c = l;
    drawSpriteXor(bc, hl, de);
    drawSpriteXor(bc, hl, de);
    drawSpriteXor(bc, hl, de);
    drawSpriteXor(bc, hl, de);
}

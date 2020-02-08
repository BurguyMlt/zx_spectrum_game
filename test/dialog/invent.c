// Последнее Испытание 8 бит
// (c) Алексей Морозов aka alemorf
// Инвентарь

#counter 16000

#include "common.h"

const int borderColor                   = 0x44;

const int secondWeaponBwAddrForPict     = 0x4042;
const int secondWeaponClAddrForPict     = 0x5842;
const int secondWeaponTextPos           = 35 * 256 + 19;
const int secondWeaponTextInactiveColor = 0x41;
const int secondWeaponTextActiveColor   = 0x47;
const int secondWeaponStepTails         = 3;

const int itemsPos                      = 7 * 8 * 256 + 16;
const int itemsCursorPos                = 7 * 8 * 256 + 9;
const int itemsCursorColor              = 0x43;
const int itemColor                     = 0x45;
const int itemHeight                    = 10;

const int lutPos                        = 7 * 8 * 256 + 144;
const int lutCountX                     = 240;
const int lutColor                      = 0x47;
const int lutItemHeight                 = 10;

uint8_t selectedItem = 0;
uint8_t selectedItem1 = 0;

const int inventgraphMapSpecialCodes = 0x80;

void invent()
{
    // Перемещаем курсор в начало
    selectedItem = a = 0;
    selectedItem1 = a;

    // Начало рисования
    gBeginDraw();

    // Очищаем экран, но не трогаем панель.
    hl = screenBw0;
    *hl = 0; // Без пикселей
    ldir(hl, de = [screenBw0 + 1], bc = [screenWidthTails * 128 + screenWidthTails * panelHeightTails - 1]);
    a = [tailHeight - 1]; // Один проход уже сделали
    do
    {
        (hl = [screenWidthTails * panelHeightTails]) += de;
        ex(hl, de);
        ldir(hl = screenBw0, de, bc = [screenWidthTails * panelHeightTails]);
    } while(flag_nz --a);

    // Заливаем весь экран цветом рамки
    hl = screenAttr0;
    *hl = borderColor;
    ldir(hl, de = [screenAttr0 + 1], bc = [screenWidthTails * playfieldHeightTails - 1]);

    // Рисуем рамку
    bc = screenBw0;
    de = &inventgraphMap;
    while()
    {
        // Читаем код
        a = *de; de++;

        // Это специальный код
        if (a >= inventgraphMapSpecialCodes)
        {
            // Конец рисования
            if (flag_z) break;

            // Пропуск
            a -= inventgraphMapSpecialCodes;
            c = (a += c);
            if (flag_c) b = ((a = b) += 8);
            continue;
        }

        // Вычисление адреса. Тут арифметка написана так, что номер тейла не может быть больше 127
        a += a;
        l = (a += [&inventgraphTails >> 2]);
        h = ((a +@= [&inventgraphTails >> 10]) -= l);
        hl += hl += hl;

        // Копируем тейл в видеопамять. Тайлы не пересекают 256-байтную страницу.
        *bc = a = *hl; l++; b++;
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

    // Скрываем надпись "Заклинания", если на неё заезжает курсор
    if ((a = gPlayerSecondWeaponCount) >= 8)
    {
        d = h = 0x40;
        do
        {
            l = 0x37;
            e = 0x38;
            ldir(hl, de, bc = 7);
            d++;
        } while(flag_z d & 0x8);
    }

    // Рисуем пиктограммы второго оружия
    bc = secondWeaponBwAddrForPict;
    hl = secondWeaponClAddrForPict;
    d = 0; //! Заменить на B
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
        l = ((a = l) += secondWeaponStepTails); c = l;
        d++;
    } while((a = gPlayerSecondWeaponCount) != d);

    // Рисуем кол-во второго оружия
    b = 0;
    hl = secondWeaponTextPos;
    do
    {
        push(bc)
        {
            push (hl)
            {
                ex(hl, de);
                getItemOfArray8(hl = &gPlayerSecondWeaponCounters, a = b);
                ex(hl, de);
                numberToString16(d = 0, e = a, hl = &gStringBuffer);                
            }
            push (hl)
            {
                a = *[&gStringBuffer + 1];
                if (a < 3) ++++l; // Выравнивание по ширине
                gDrawTextEx(hl, de = &gStringBuffer, a = [secondWeaponTextInactiveColor | 0x80]);
            }
        }
        l = ((a = l) += [secondWeaponStepTails * tailWidth]);
        b++;
    } while((a = gPlayerSecondWeaponCount) != b);

    // Рисуем наименования предметов
    b = a = gPlayerItemsCount;
    hl = itemsPos;
    de = &gPlayerItems;
    do
    {
        push(bc, de, hl)
        {
            ex(hl, de);
            getItemOfArray16(a = *hl, hl = &itemNames);
            ex(hl, de);
            gDrawTextEx(hl, de, a = itemColor);
        }
        de++;
        h = ((a = h) += itemHeight);
    } while(--b);

    // Рисуем наименование лута
    b = a = gPlayerLutCount;
    hl = lutPos;
    de = &gPlayerLut;
    do
    {
        push(bc)
        {
            // Преобразуем кол-во в строку (gStringBuffer)
            push(hl, de)
            {
                (hl = playerLutMax) += de;
                numberToString16(d = 0, e = *hl, hl = &gStringBuffer);
            }

            push(de)
            {
                // Тип лута
                a = *de;

                // Тип лута в строку (de)
                ex(hl, de);
                getItemOfArray16(hl = &lutNames, a);
                ex(hl, de);

                // Выводим наименование
                push(hl)
                {
                    gDrawTextEx(hl, de, a = lutColor);
                }

                // Выводим кол-во по правому краю
                push(hl)
                {
                    l = lutCountX;
                    drawTextRight(hl, de = &gStringBuffer, a = lutColor);
                }
            }
        }

        h = ((a = h) += lutItemHeight); // Следующий текст пишем ниже
        de++; // Следующий ЛУТ
    } while(--b);

    // Рисуем основное оружие
    drawSprite4(hl = 0x59E1, bc = 0x48E1, de = [&magic_0 + 36]);
    gDrawTextEx(hl = [15 * 8 * 256 + 28], de = "Обычное оружие", a = 0x47);
    gDrawTextEx(hl = [(15 * 8 + 9) * 256 + 28], de = "\x16\x17\x18\x15\x19\x1A\x1B\x02", a = 0x46);

    // Рисуем защиту
    drawSprite4(hl = 0x5A21, bc = 0x5021, de = [&magic_0 + 36 * 3]);
    gDrawTextEx(hl = [17 * 8 * 256 + 28], de = "Обычная защита", a = 0x47);
    gDrawTextEx(hl = [(17 * 8 + 9) * 256 + 28], de = "\x1A\x1B\x1C\x15\x1D\x1E\x1F\x02", a = 0x46);

    // Рисуем ключи
    drawSprite4(hl = 0x5A2E, bc = 0x502E, de = [&magic_0 + 36 * 9]);

    // Рисуем курсоры
    drawSecondWeaponCursor(ixh = secondWeaponTextActiveColor);
    drawItemCursor();

    gEndDraw();

    // ** Меню ***

    while()
    {
        // Ждем, если прошло меньше 1/50 сек с прошлого цикла.
        while ((a = gVideoPage) & 1);
        gVideoPage = (a |= 1);

        // Клавиша
        hl = &gKeyTrigger;
        a = *hl;
        *hl = 0;
        if (a & KEY_LEFT)
        {
            a = gPlayerSecondWeaponSel;
            a-=1;
            if (flag_c) continue;
            setSecondWeapon(a);
        }
        else if (a & KEY_RIGHT)
        {
            a = gPlayerSecondWeaponSel;
            a++;
            if (a >= *(hl = &gPlayerSecondWeaponCount)) continue;
            setSecondWeapon(a);
        }
        else if (a & KEY_UP)
        {
            a = selectedItem;
            a-=1;
            if (flag_c) continue;
            selectedItem = a;
        }
        else if (a & KEY_DOWN)
        {
            a = selectedItem;
            a++;
            if (a >= *(hl = &gPlayerItemsCount)) continue; //*(hl = &gPlayerItemsCount)) continue;
            selectedItem = a;
        }
        else if (a & KEY_MENU)
        {
            gBeginDraw();
            gEndDraw();
            return;
        }

        // Умножение на 10
        a = selectedItem;
        c = (a += a);
        ((a += a) += a) += c;

        // Плавное перемещение курсора
        hl = &selectedItem1;
        b = *hl;
        if (a == b) continue; // Оставит флаг CF при выполнении dialogX1 - menuX
        b++; // Не изменяет CF
        if (flag_c) ----b;

        // Стираем прошлый курсор
        push(bc);
        drawItemCursor();
        pop(bc);

        // Сохраняем новые координаты курсора
        *(hl = &selectedItem1) = b;

        // Рисуем курсор
        drawItemCursor();
    }
}

void drawItemCursor()
{
    l = itemsCursorPos;
    h = ((a = selectedItem1) += [itemsCursorPos >> 8]);
    gDrawTextEx(hl, de = "@", a = itemsCursorColor);
}

void setSecondWeapon(a)
{
    push(a)
    {
        drawSecondWeaponCursor(ixh = secondWeaponTextInactiveColor);
    }
    gPlayerSecondWeaponSel = a;
    drawSecondWeaponCursor(ixh = secondWeaponTextActiveColor);
    gPanelChangedA = a = 0xFF;
    gPanelChangedB = a;
    gPanelRedraw();
    return panelDrawSecondWeapon();
}

void drawSecondWeaponCursor(ixh)
{
    a = gPlayerSecondWeaponSel;
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

#counter 6000

#include "common.h"

const int panelAddrBwA        = 0x5080;
const int panelAddrBwB        = panelAddrBwA | 0x8000;
const int panelAddrClA        = 0x5A80;
const int panelAddrClB        = panelAddrClA | 0x8000;

const int panelPlaceColor     = 0x4E;
const int panelNumberColor    = 0x4F;
const int panelMoneyColor     = 0xCE;

const int panelMoneyAddr      = 0x52C4;
const int panelMoneyWidth16   = 7;
const int panelArmorCount     = 0x52FC;
const int panelSuperCountAddr = 0x52F8;
const int panelPlaceAddr      = 0x5284;
const int panelPlaceWidth16   = 7;

void panelRedraw()
{
    // Нужно ли перерисовать?
    hl = &gPanelChangedA;
    if ((a = gVideoPage) & 0x80) hl++;
    a = *hl;
    if (a == 0) return;
    *hl = 0;

    // Рисование денег
    if (a & gPanelChangedMoney)
    {
        push(a)
        {
            numberToString16(hl = &gStringBuffer, de = gPlayerMoney);

            // Очистка фона под надписью
            clearSmall99(b = panelMoneyWidth16, hl = panelMoneyAddr);

            // Рисование надписи
            gDrawText(hl, de = &gStringBuffer, a = [panelPlaceColor | smallFontFlag]);
        }
    }

    // Рисование названия города
    if (a & gPanelChangedPlace)
    {
        push(a)
        {
            // Очистка фона под надписью
            clearSmall99(b = panelPlaceWidth16, hl = panelPlaceAddr);
            // Рисование надписи
            gDrawText(hl, de = "УТЕХА", a = [panelPlaceColor | smallFontFlag]); //! В глобальные переменные
        }
    }

    // Рисование кол-ва второго оружия
    if (a & gPanelChanedSecondWeaponCount)
    {
        push(a)
        {
            // Кол-во супероружия хранится в массиве
            a = gPlayerSecondWeaponSel;
            getItemOfArray8(hl = &gPlayerSecondWeaponCounters, a);
            // Рисование
            drawNubmer999(hl = panelSuperCountAddr, d = 0, e = a);
        }
    }

    // Рисование числа амулета
    if (a & gPanelChanedArmorCount)
    {
        push(a)
        {
            drawNubmer999(hl = panelArmorCount, de = 999);
        }
    }
}

// Рисование числа маленьким шрифтом с центрированием.

void drawNubmer999(hl, de)
{
    // Преобразование числа в строку
    push(hl)
    {
        numberToString16(hl = &gStringBuffer); //! Заменить на numberToString8
    }

    // Очистка фона под цифрой
    clearSmall99(b = 1, hl);

    // Центрирование числа
    c = [(16 - (5 + 5 + 4)) / 2]; // Смещение для 3-х цифр
    if ((a = *[&gStringBuffer + 2]) == 0) c = [(16 - (5 + 4)) / 2]; // Смещение для 2-х цифр
    if ((a = *[&gStringBuffer + 1]) == 0) c = [(16 - 4) / 2]; // Смещение для одной цифры

    // Рисование текста
    drawTextSub(c, hl, de = &gStringBuffer, a = [panelNumberColor | smallFontFlag]);
}

// Очистить прямоугольник ширинй b * 16 и высотой 5 пикселей.
// Пересение знакоместа (координатой Y) не допускается.
// Вход:
//     b - ширина / 16 в пикселях
//     hl - адрес верхнего левого угла прямоугольника в чб видеопамяти.

void clearSmall99(b, hl)
{
    // Адрес активной видеостраницы
    h = (((a = gVideoPage) &= 0x80) |= h);    
    push(hl)
    {
        a ^= a;
        do
        {
            *hl = a; h++;
            *hl = a; h++;
            *hl = a; h++;
            *hl = a; h++;
            *hl = a; l++;
            *hl = a; h--;
            *hl = a; h--;
            *hl = a; h--;
            *hl = a; h--;
            *hl = a; l++;
        } while(--b);
    }
}

// Скопировать панель с видеостраницы A на видеостраницу B.
// Используется при обновлении панели из модуля расположенного в расширенной памяти.
// Такой модуль не имеет возможности изменять видеостраницу B.

// Ограничение: панель не должна быть расположена на пересечении третей экрана.
// Ограничение: панель должна быть шириной во весь экран

void copyPanel()
{
    h = [panelAddrBwA >> 8]; // Старшая часть адреса видеостраницы A
    d = [panelAddrBwB >> 8]; // Старшая часть адреса видеостраницы B
    a = tailHeight;
    do
    {
        push(de, hl)
        {
            l = e = panelAddrBwA; // Младная часть адреса обоих видеостраниц. Должна совпадать.
            ldir(hl, de, bc = [screenWidthTails * panelHeightTails]);
        }
        d++; h++;
    } while(flag_nz --a);

    // Копируем цветную видеопамять
    ldir(hl = panelAddrClA, de = panelAddrClB, bc = [screenWidthTails * panelHeightTails]);
}

// ZX Spectrum test (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

// Очистить оба экрана
// Вход: A - атрбут
// Сохраняет: A', BC', DE', HL', IY, IX

void clearScreen(a)
{
    push(a)
    {
        // В прерывании не выбирать видеостраницу
        gVideoPage = a = 0;

        // Выбрать вторую видеостраницу для записи
        a = gSystemPage;
        a |= 7;
        gSystemPage = a;
        out(bc = 0x7FFD, a);
    }

    clearScreen1(hl = [0x5B00 - 1], a);
    clearScreen1(hl = [0xDB00 - 1], a);

    // Выбрать первую видеостраницу для отображения
    a = gSystemPage;
    a &= [~8];
    gSystemPage = a;
    out(bc = 0x7FFD, a);
}

void clearScreen1(hl, a)
{
    d = h;
    e = l;
    de--;
    push(de, hl)
    {
        *hl = 0;
        lddr(bc = [0x1B00 - 1]);
    }
    *hl = a;
    lddr(bc = [0x300 - 1]);
}

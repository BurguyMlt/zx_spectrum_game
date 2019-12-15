// ZX Spectrum test (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

// Очистить оба экрана
// Вход: A - атрбут
// Сохраняет: A', BC', DE', HL', IY, IX

void clearScreen()
{
    // В прерывании не выбирать видеостраницу
    gVideoPage = a = 0;

    // Выбрать вторую видеостраницу для записи
    a = gSystemPage;
    a |= 7;
    gSystemPage = a;
    out(bc = 0x7FFD, a);

    clearScreen1(hl = [0x5B00 - 1]);
    clearScreen1(hl = [0xDB00 - 1]);

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
    a ^= a;
    *hl = 0;
    lddr(bc = [0x1B00 - 1]);
}

void beginDraw()
{
    hl = &gVideoPage;
    while ((a = *hl) & 1);
    a &= 0x7F;
    if (flag_z a & 8) a |= 0x80;
    *hl = a;
}

void endDraw()
{    
    gVideoPage = ((a = gVideoPage) ^= 8 |= 1);
}

void copyVideoPage()
{
    // Переключаемся на 2-ую страницу и обновляем там панель
    beginDraw();
    panelRedraw();
    endDraw();

    // Ждем завершения переключения
    hl = &gVideoPage;
    do {} while (flag_nz *hl & 1);

    // Копируем 2-ую страницу на первую
    ldir(hl = 0xC000, de = 0x4000, bc = 0x1B00);
}

void drawPanel()
{
    // Рисуем панель на нулевой видеостранице
    farCall(iyl = &gPanelgraphPage, ix = &gPanelgraph);
    // Копируем её на первую видеостраницу. Для ускорения копируем только нижнюю треть ч/б.
    ldir(hl = 0x5000, de = 0xD000, bc = 0xB00);
}

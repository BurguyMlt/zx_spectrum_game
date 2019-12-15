    ; 3 // Очистить оба экрана
    ; 4 // Вход: A - атрбут
    ; 5 // Сохраняет: A', BC', DE', HL', IY, IX
    ; 7 void clearScreen()
clearScreen:
    ; 8 {
    ; 9 // В прерывании не выбирать видеостраницу
    ; 10 gVideoPage = a = 0;
    ld   a, 0
    ld   (gVideoPage), a
    ; 12 // Выбрать вторую видеостраницу для записи
    ; 13 a = gSystemPage;
    ld   a, (gSystemPage)
    ; 14 a |= 7;
    or   7
    ; 15 gSystemPage = a;
    ld   (gSystemPage), a
    ; 16 out(bc = 0x7FFD, a);
    ld   bc, 32765
    out  (c), a
    ; 18 clearScreen1(hl = [0x5B00 - 1]);
    ld   hl, 23295
    call clearScreen1
    ; 19 clearScreen1(hl = [0xDB00 - 1]);
    ld   hl, 56063
    call clearScreen1
    ; 21 // Выбрать первую видеостраницу для отображения
    ; 22 a = gSystemPage;
    ld   a, (gSystemPage)
    ; 23 a &= [~8];
    and  ~(8)
    ; 24 gSystemPage = a;
    ld   (gSystemPage), a
    ; 25 out(bc = 0x7FFD, a);
    ld   bc, 32765
    out  (c), a
    ; 26 }
    ret
    ; 28 void clearScreen1(hl, a)
clearScreen1:
    ; 29 {
    ; 30 d = h;
    ld   d, h
    ; 31 e = l;
    ld   e, l
    ; 32 de--;
    dec  de
    ; 33 a ^= a;
    xor  a
    ; 34 *hl = 0;
    ld   (hl), 0
    ; 35 lddr(bc = [0x1B00 - 1]);
    ld   bc, 6911
    lddr
    ; 36 }
    ret
    ; 38 void beginDraw()
beginDraw:
    ; 39 {
    ; 40 hl = &gVideoPage;
    ld   hl, gVideoPage
    ; 41 while ((a = *hl) & 1);
l0:
    ld   a, (hl)
    bit  0, a
    jp   z, l1
    jp   l0
l1:
    ; 42 a &= 0x7F;
    and  127
    ; 43 if (flag_z a & 8) a |= 0x80;
    bit  3, a
    jp   nz, l2
    or   128
    ; 44 *hl = a;
l2:
    ld   (hl), a
    ; 45 }
    ret
    ; 47 void endDraw()
endDraw:
    ; 48 {    
    ; 49 gVideoPage = ((a = gVideoPage) ^= 8 |= 1);
    ld   a, (gVideoPage)
    xor  8
    or   1
    ld   (gVideoPage), a
    ; 50 }
    ret
    ; 52 void copyVideoPage()
copyVideoPage:
    ; 53 {
    ; 54 // Переключаемся на 2-ую страницу и обновляем там панель
    ; 55 beginDraw();
    call beginDraw
    ; 56 panelRedraw();
    call panelRedraw
    ; 57 endDraw();
    call endDraw
    ; 59 // Ждем завершения переключения
    ; 60 hl = &gVideoPage;
    ld   hl, gVideoPage
    ; 61 do {} while (flag_nz *hl & 1);
l3:
    bit  0, (hl)
    jp   nz, l3
l4:
    ; 63 // Копируем 2-ую страницу на первую
    ; 64 ldir(hl = 0xC000, de = 0x4000, bc = 0x1B00);
    ld   hl, 49152
    ld   de, 16384
    ld   bc, 6912
    ldir
    ; 65 }
    ret
    ; 67 void drawPanel()
drawPanel:
    ; 68 {
    ; 69 // Рисуем панель на нулевой видеостранице
    ; 70 farCall(iyl = &gPanelgraphPage, ix = &gPanelgraph);
    ld   iyl, gPanelgraphPage
    ld   ix, gPanelgraph
    call farCall
    ; 71 // Копируем её на первую видеостраницу. Для ускорения копируем только нижнюю треть ч/б.
    ; 72 ldir(hl = 0x5000, de = 0xD000, bc = 0xB00);
    ld   hl, 20480
    ld   de, 53248
    ld   bc, 2816
    ldir
    ; 73 }
    ret

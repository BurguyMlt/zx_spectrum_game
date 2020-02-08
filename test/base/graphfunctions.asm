    ; base/graphfunctions.c:2 
    ; base/graphfunctions.c:3 // Очистить оба экрана
    ; base/graphfunctions.c:4 // Вход: A - атрбут
    ; base/graphfunctions.c:5 // Сохраняет: A', BC', DE', HL', IY, IX
    ; base/graphfunctions.c:6 
    ; base/graphfunctions.c:7 void clearScreen()
clearScreen:
    ; base/graphfunctions.c:8 {
    ; base/graphfunctions.c:9 // В прерывании не выбирать видеостраницу
    ; base/graphfunctions.c:10 gVideoPage = a = 0;
    ld   a, 0
    ld   (gVideoPage), a
    ; base/graphfunctions.c:11 
    ; base/graphfunctions.c:12 // Выбрать вторую видеостраницу для записи
    ; base/graphfunctions.c:13 a = gSystemPage;
    ld   a, (gSystemPage)
    ; base/graphfunctions.c:14 a |= 7;
    or   7
    ; base/graphfunctions.c:15 gSystemPage = a;
    ld   (gSystemPage), a
    ; base/graphfunctions.c:16 out(bc = 0x7FFD, a);
    ld   bc, 32765
    out  (c), a
    ; base/graphfunctions.c:17 
    ; base/graphfunctions.c:18 clearScreen1(hl = [0x5B00 - 1]);
    ld   hl, 23295
    call clearScreen1
    ; base/graphfunctions.c:19 clearScreen1(hl = [0xDB00 - 1]);
    ld   hl, 56063
    call clearScreen1
    ; base/graphfunctions.c:20 
    ; base/graphfunctions.c:21 // Выбрать первую видеостраницу для отображения
    ; base/graphfunctions.c:22 a = gSystemPage;
    ld   a, (gSystemPage)
    ; base/graphfunctions.c:23 a &= [~8];
    and  ~(8)
    ; base/graphfunctions.c:24 gSystemPage = a;
    ld   (gSystemPage), a
    ; base/graphfunctions.c:25 out(bc = 0x7FFD, a);
    ld   bc, 32765
    out  (c), a
    ; base/graphfunctions.c:26 }
    ret
    ; base/graphfunctions.c:27 
    ; base/graphfunctions.c:28 void clearScreen1(hl, a)
clearScreen1:
    ; base/graphfunctions.c:29 {
    ; base/graphfunctions.c:30 d = h;
    ld   d, h
    ; base/graphfunctions.c:31 e = l;
    ld   e, l
    ; base/graphfunctions.c:32 de--;
    dec  de
    ; base/graphfunctions.c:33 a ^= a;
    xor  a
    ; base/graphfunctions.c:34 *hl = 0;
    ld   (hl), 0
    ; base/graphfunctions.c:35 lddr(bc = [0x1B00 - 1]);
    ld   bc, 6911
    lddr
    ; base/graphfunctions.c:36 }
    ret
    ; base/graphfunctions.c:37 
    ; base/graphfunctions.c:38 void beginDraw()
beginDraw:
    ; base/graphfunctions.c:39 {
    ; base/graphfunctions.c:40 hl = &gVideoPage;
    ld   hl, gVideoPage
    ; base/graphfunctions.c:41 while ((a = *hl) & 1);
l0:
    ld   a, (hl)
    bit  0, a
    jp   z, l1
    jp   l0
l1:
    ; base/graphfunctions.c:42 a &= 0x7F;
    and  127
    ; base/graphfunctions.c:43 if (flag_z a & 8) a |= 0x80;
    bit  3, a
    jp   nz, l2
    or   128
    ; base/graphfunctions.c:44 *hl = a;
l2:
    ld   (hl), a
    ; base/graphfunctions.c:45 }
    ret
    ; base/graphfunctions.c:46 
    ; base/graphfunctions.c:47 void endDraw()
endDraw:
    ; base/graphfunctions.c:48 {    
    ; base/graphfunctions.c:49 gVideoPage = ((a = gVideoPage) ^= 8 |= 1);
    ld   a, (gVideoPage)
    xor  8
    or   1
    ld   (gVideoPage), a
    ; base/graphfunctions.c:50 }
    ret
    ; base/graphfunctions.c:51 
    ; base/graphfunctions.c:52 void copyVideoPage()
copyVideoPage:
    ; base/graphfunctions.c:53 {
    ; base/graphfunctions.c:54 // Переключаемся на 2-ую страницу и обновляем там панель
    ; base/graphfunctions.c:55 beginDraw();
    call beginDraw
    ; base/graphfunctions.c:56 panelRedraw();
    call panelRedraw
    ; base/graphfunctions.c:57 endDraw();
    call endDraw
    ; base/graphfunctions.c:58 
    ; base/graphfunctions.c:59 // Ждем завершения переключения
    ; base/graphfunctions.c:60 hl = &gVideoPage;
    ld   hl, gVideoPage
    ; base/graphfunctions.c:61 do {} while (flag_nz *hl & 1);
l3:
    bit  0, (hl)
    jp   nz, l3
l4:
    ; base/graphfunctions.c:62 
    ; base/graphfunctions.c:63 // Копируем 2-ую страницу на первую
    ; base/graphfunctions.c:64 ldir(hl = 0xC000, de = 0x4000, bc = 0x1B00);
    ld   hl, 49152
    ld   de, 16384
    ld   bc, 6912
    ldir
    ; base/graphfunctions.c:65 }
    ret
    ; base/graphfunctions.c:66 
    ; base/graphfunctions.c:67 void drawPanel()
drawPanel:
    ; base/graphfunctions.c:68 {
    ; base/graphfunctions.c:69 // Рисуем панель на нулевой видеостранице
    ; base/graphfunctions.c:70 farCall(iyl = &gPanelgraphPage, ix = &gPanelgraph);
    ld   iyl, gPanelgraphPage
    ld   ix, gPanelgraph
    call farCall
    ; base/graphfunctions.c:71 // Копируем её на первую видеостраницу. Для ускорения копируем только нижнюю треть ч/б.
    ; base/graphfunctions.c:72 ldir(hl = 0x5000, de = 0xD000, bc = 0xB00);
    ld   hl, 20480
    ld   de, 53248
    ld   bc, 2816
    ldir
    ; base/graphfunctions.c:73 }
    ret
    ; base/graphfunctions.c:74 

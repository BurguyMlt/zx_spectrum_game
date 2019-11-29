    ; 3 // Очистить оба экрана
    ; 4 // Вход: A - атрбут
    ; 5 // Сохраняет: A', BC', DE', HL', IY, IX
    ; 7 void clearScreen(a)
clearScreen:
    ; 8 {
    ; 9 push(a)
    ; 10 {
    push af
    ; 11 // В прерывании не выбирать видеостраницу
    ; 12 videoPage = a = 0;
    ld   a, 0
    ld   (videoPage), a
    ; 14 // Выбрать вторую видеостраницу для записи
    ; 15 a = systemPage;
    ld   a, (systemPage)
    ; 16 a |= 7;
    or   7
    ; 17 systemPage = a;
    ld   (systemPage), a
    ; 18 out(bc = 0x7FFD, a);
    ld   bc, 32765
    out  (c), a
    ; 19 }
    pop  af
    ; 21 clearScreen1(hl = [0x5B00 - 1], a);
    ld   hl, 23295
    call clearScreen1
    ; 22 clearScreen1(hl = [0xDB00 - 1], a);
    ld   hl, 56063
    call clearScreen1
    ; 24 // Выбрать первую видеостраницу для отображения
    ; 25 a = systemPage;
    ld   a, (systemPage)
    ; 26 a &= [~8];
    and  ~(8)
    ; 27 systemPage = a;
    ld   (systemPage), a
    ; 28 out(bc = 0x7FFD, a);
    ld   bc, 32765
    out  (c), a
    ; 29 }
    ret
    ; 31 void clearScreen1(hl, a)
clearScreen1:
    ; 32 {
    ; 33 d = h;
    ld   d, h
    ; 34 e = l;
    ld   e, l
    ; 35 de--;
    dec  de
    ; 36 push(de, hl)
    ; 37 {
    push de
    push hl
    ; 38 *hl = 0;
    ld   (hl), 0
    ; 39 lddr(bc = [0x1B00 - 1]);
    ld   bc, 6911
    lddr
    ; 40 }
    pop  hl
    pop  de
    ; 41 *hl = a;
    ld   (hl), a
    ; 42 lddr(bc = [0x300 - 1]);
    ld   bc, 767
    lddr
    ; 43 }
    ret

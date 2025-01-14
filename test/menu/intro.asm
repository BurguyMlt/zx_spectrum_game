; ZX Spectrum test (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

intro:
        LD     DE, introText0  ; Текст
        LD     HL, 1           ; Координаты текста (H=y,L=x)
        EXX
        LD     DE, 0x5800      ; Координаты Рейстлина (адрес в памяти атрубутов)
        LD     HL, image_rast  ; Рейстлин
        CALL   introUniversal

        LD     DE, introText1  ; Текст
        LD     HL, 0           ; Координаты текста (H=y,L=x)
        EXX
        LD     DE, 0x5810      ; Координаты Такхизис (адрес в памяти атрубутов)
        LD     HL, image_takh  ; Рейстлин
        CALL   introUniversal

        JP     main

;-------------------------------------------------------------------------------

introUniversal:
        ; Сохраняем параметры изображения
        PUSH   HL
        PUSH   DE

        ; Очистка экранов
        LD     A, 45h
        CALL   gClearScreen

        ; Рисуем изображение
        POP    DE
        POP    HL
        CALL   gDrawImage

        ; Инициализация эффектов
        CALL   sparkReset ; Сохраняет EXX, IX, IY

        ; Цикл строк. Далее DE - текст, HL - координаты
        EXX
intro_1:
        PUSH   HL

        ; Нужно ли прижать к правому краю?
        LD     A, L
        OR     A
        JP     Z, intro_2

        ; Вычисление ширины строки
        PUSH   DE
        CALL   gMeasureText
        POP    DE
        POP    HL
        PUSH   HL

        ; Вычисление координаты X первого символа
        XOR    A
        SUB    C
        LD     L, A
intro_2:

        ; Рисование строки
        CALL   introDrawText

        ; Следующая строка
        POP    HL
        LD     A, H
        ADD    10
        LD     H, A

        ; Если это не последняя строка, то продолжим
        LD     A, (DE)
        OR     A
        JP     NZ, intro_1

        ; Новые искры не создавать
        XOR    A
        LD     (SPARK_INIT_X), A

intro_4:
        ; Дожигаем существующие искры
        CALL   sparkDo

        ; Если не нажата ни одна клавиша, то продолжаем.
        LD     BC, 000FEh
        IN     A, (C)
        CPL
        AND    1Fh
        JP     Z, intro_4

        RET

;-------------------------------------------------------------------------------
; Вывод строки текста

introDrawText:
        LD     A, L
        LD     (SPARK_INIT_X), A
        LD     A, H
        LD     (SPARK_INIT_Y), A
        CALL   gCalcCoords
introDrawText_1:
        LD     A, (DE)
        INC    DE
        OR     A
        RET    Z

        ; Анимация
        CALL   intro_3

        CALL   gDrawCharSub

        ; Перемещаем и искру
        LD     A, (SPARK_INIT_X)
        ADD    B
        LD     (SPARK_INIT_X), A

        JP     introDrawText_1

;-------------------------------------------------------------------------------

intro_3:
        ; Анимация
        PUSH   AF
        PUSH   BC
        PUSH   DE
        PUSH   HL
        CALL   sparkDo
        CALL   sparkDo
        POP    HL
        POP    DE
        POP    BC
        POP    AF
        RET

;-------------------------------------------------------------------------------

introText0:
        db "Величайший маг Рейстлин Маджере", 0
        db "- перед этим именем трепетали", 0
        db "самые искушенные чародеи.", 0
        db "Никто из живущих не знал", 0
        db "пределов его могущества!", 0
        db " ", 0
        db "Однажды из Бездны вырвалась", 0
        db "злая богиня Такхизис. Самые", 0
        db "жуткие кошмары людей стали", 0
        db "явью. Армии мертвецов сжигали", 0
        db "города дотла не оставляя живых.", 0
        db " ", 0
        db "Рейстлин присягнул на верность", 0
        db "Такхизис и возглавил ее армию.", 0
        db "Каждый белый маг поклялся", 0
        db "убить его за это.", 0
        db " ", 0
        db "(Нажмите любую клавишу)", 0
        db 0

;-------------------------------------------------------------------------------

introText1:
        db "Никто не знал истинных мотивов", 0
        db "Рейстлина. Доказав Такхизис свою", 0
        db "преданность и дождавшись момента,", 0
        db "Рейстлин нанес удар ей в спину.", 0
        db "Он изгнал ее в Бездну и", 0
        db "навсегда закрыл Врата.", 0
        db " ", 0
        db "И теперь каждый черный маг", 0
        db "поклялся убить его. Белые", 0
        db "же маги его не простили.", 0
        db " ", 0
        db "За магические знания позволившие", 0
        db "спасти мир Рейстлин заплатил своим", 0
        db "здоровьем. Он был болен и", 0
        db "чувствовал, что его время уходит.", 0
        db "Но он знал как все исправить.", 0
        db "Если он спустится в Бездну", 0
        db "и убьет Такхизис, то он сам", 0
        db "станет богом.", 0
        db 0

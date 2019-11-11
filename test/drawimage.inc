; ZX Spectrum test (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

;-------------------------------------------------------------------------------
; Вывести изображение
; HL - адрес изображения
; DE - адрес в видеопамяти (5800 - 5CFFh)

drawImage:
        ; Преобразование адреса в DE из формата X + Y * 32 в формат YY000 YYYXXXXX
        PUSH   DE
        LD     A, D
        ADD    A
        ADD    A
        ADD    A
        ADD    40h - 0C0h
        LD     D, A

        ; Чтение высоты и ширины. Сохранение  её в стеке
        LD     C, (HL)
        INC    HL
        LD     B, (HL)
        INC    HL
        PUSH   BC

        ; Вывод чернобелой графики
drawImage_1:
        PUSH   BC

        ; Копирование строки
        LD     A, 8
drawImage_3:
        PUSH   BC
        PUSH   DE
        LD     B, 0
        LDIR
        POP    DE
        POP    BC
        INC    D
        DEC    A
        JP     NZ, drawImage_3

        ; Адрес следующей строки
        LD     BC, 0x20 - 0x800
        EX     DE, HL
        ADD    HL, BC
        EX     DE, HL
        LD     A, D
        AND    7
        CALL   NZ, drawImage_4

        ; Следующая строка
        POP    BC
        DJNZ   drawImage_1

        ; Восстановление координат вывода и размера
        POP    BC
        POP    DE

        ; Цикл для каждой строки
drawImage_2:
        PUSH   BC

        ; Копирование строки
        PUSH   DE
        LD     B, 0
        LDIR
        POP    DE

        ; Адрес следующей строки
        EX     DE, HL
        LD     BC, 32
        ADD    HL, BC
        EX     DE, HL

        ; Следующая строка
        POP    BC
        DJNZ   drawImage_2

        RET

;-------------------------------------------------------------------------------

drawImage_4:
        LD     BC, 0x800 - 0x100
        EX     DE, HL
        ADD    HL, BC
        EX     DE, HL
        RET

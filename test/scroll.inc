scroll:
        ; Заливка черным цветом экрана
        LD     D, 0
        CALL   clearScreen

        ; Перерисовать всё
        LD     HL, 05B00h
        LD     DE, 05B01h
        LD     BC, 32 * 20 - 1
        LD     (HL), 0FFh
        LDIR

Loop:
        ;JP     Intro

        LD     A, (mainMenuX)
        INC    A
        LD     (mainMenuX), A

        LD     DE, levelMap
        LD     E, A
        LD     HL, 5800h - 1 + 300h
        EXX
        LD     HL, 4000h

        ; Цикл строк
        LD     B, 20
Begin_2:
        PUSH   HL
        PUSH   BC

        ; Цикл стобцов
        LD     B, 32
Begin_1:
        PUSH   HL

        ; Чтение номера тейла из карты уровня
        EXX
        LD     A, (DE)
        INC    E
        EXX

        ; Вычисление адреса тейла
        LD     E, A
        LD     D, levelTails >> 8

        ; Вывод на экран
        LD     A, (DE)
        INC    D
        LD     (HL), A
        INC    H
        LD     A, (DE)
        INC    D
        LD     (HL), A
        INC    H
        LD     A, (DE)
        INC    D
        LD     (HL), A
        INC    H
        LD     A, (DE)
        INC    D
        LD     (HL), A
        INC    H
        LD     A, (DE)
        INC    D
        LD     (HL), A
        INC    H
        LD     A, (DE)
        INC    D
        LD     (HL), A
        INC    H
        LD     A, (DE)
        INC    D
        LD     (HL), A
        INC    H
        LD     A, (DE)
        INC    D
        LD     (HL), A
        INC    H
        LD     A, (DE)
        EXX
        DEC    H
        DEC    H
        DEC    H
        LD     (HL), A
        INC    H
        INC    H
        INC    H
        EXX

        ; Конец цикла столбцов
        POP    HL
        INC    L ; Вправо
        DJNZ   Begin_1
DontDraw_2:
        ; Следующая строка карты
        EXX
        LD     A, E
        ADD    256 - 32
        LD     E, A
        INC    D
        EXX

        ; Конец цикла строк
        POP    BC
        POP    HL
        LD     DE, 20h
        ADD    HL, DE
        LD     A, H
        AND    7
        JP     Z, Begin_5
        LD     DE, 800h-100h
        ADD    HL, DE
Begin_5:
        DJNZ   Begin_2

        JP     Loop

;-------------------------------------------------------------------------------

DontDraw:
        EXX
        ; Конец цикла столбцов
        POP    HL
        INC    L ; Вправо
        DJNZ   Begin_1
        JP     DontDraw_2

;-------------------------------------------------------------------------------

        include "build/city1graph.inc"

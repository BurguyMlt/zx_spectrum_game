; ZX Spectrum test (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

scroll:
        ; Заливка черным цветом экрана
        LD     D, 047h
        CALL   clearScreen

        ; Перерисовать всё
        LD     HL, 01B00h + 04000h
        LD     DE, 01B01h + 04000h
        LD     BC, 32 * 20 - 1
        LD     (HL), 0FFh
        LDIR

        ; Перерисовать всё
        LD     HL, 01B00h + 0C000h
        LD     DE, 01B01h + 0C000h
        LD     BC, 32 * 20 - 1
        LD     (HL), 0FFh
        LDIR

Loop:
        call   readKey

        ld     hl, keyTrigger
        ;ld     hl, keyPressed
        LD     A, (mainMenuX)
        ld     b, (hl)
        ld     (hl), 0
        bit    2, b
        jp     z, Loop_0
        dec    A
        jp     Loop_red
Loop_0:
        bit    3, b
        jp     z, Loop
        inc    A

Loop_red:
        LD     (mainMenuX), A

        LD     DE, levelMap
        LD     A, (mainMenuX)
        LD     E, A

        LD     HL, currentPage
        LD     A, (HL)
        OR     A
        JP     NZ, Begin_6
        LD     (HL), 8
        LD     HL, 0C000h + 1800h - 1 + 300h
        EXX
        LD     HL, 0C000h
        JP     Begin_7
Begin_6:
        LD     (HL), 0
        LD     HL, 04000h + 1800h - 1 + 300h
        EXX
        LD     HL, 04000h
Begin_7:

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
        INC    HL
        LD     A, (DE)
        INC    E
        CP     (HL)
        JP     Z, DontDraw
        LD     (HL), A
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

        call   wait ; учет
        CALL   showVideoPage

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

currentPage db 0

showVideoPage:
        LD   A, (currentPage)
        OR   07h
        LD   (p7FFD), A
        LD   BC, #7FFD
        OUT  (C), A
        RET

;-------------------------------------------------------------------------------

        include "build/city1graph.inc"

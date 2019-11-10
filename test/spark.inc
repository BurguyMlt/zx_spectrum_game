; Структура описывающая искру

SPARK_TBL_X     = 0
SPARK_TBL_Y     = 2
SPARK_TBL_DX    = 4
SPARK_TBL_DY    = 6
SPARK_TBL_L     = 8
SPARK_TBL_ADDR  = 9
SPARK_TBL_MASK  = 11
SPARK_TBL_SIZE  = 12 ; Размер одного элемента
SPARK_TBL_COUNT = 128 ; Кол-во элментов
SPARK_TBL       = 0FF00h - SPARK_TBL_SIZE * SPARK_TBL_COUNT
SPARK_INIT_X  = SPARK_TBL - 1
SPARK_INIT_Y  = SPARK_TBL - 2

;-------------------------------------------------------------------------------
; Рассчитать псевдослучайное число

rand:   LD    A, R
rand_1: ADD   0
        LD    E, A
        ADD   A
        ADD   A
        ADD   E
        INC   A
        LD    (rand_1 + 1), A
        RET

;-------------------------------------------------------------------------------
; Выключить все искры. Необходимо вызхвать после очистки экрана.
; Сохраняет: BC', DE', HL', IX, IY

sparkReset:
        LD    HL, SPARK_TBL + SPARK_TBL_L
        LD    DE, SPARK_TBL_SIZE
        LD    B,  SPARK_TBL_COUNT
        XOR   A
sparkInit_1:
        LD    (HL), A
        ADD   HL, DE
        DJNZ  sparkInit_1
        RET

;-------------------------------------------------------------------------------
; Обработать все искры
; Не сохраняет регистры

sparkDo:
        LD    B,  SPARK_TBL_COUNT
        LD    IX, SPARK_TBL
sparkDo_1:
        PUSH  BC
        CALL  sparkOne
        LD    BC, SPARK_TBL_SIZE
        ADD   IX, BC
        POP   BC
        DJNZ  sparkDo_1
        RET

;-------------------------------------------------------------------------------
; Обработать одну искру
; Вход/выход: IX - адрес объекта искры

sparkOne:
        ; Если искра не создана, то создаём
        LD    A, (IX + SPARK_TBL_L)
        OR    A
        JP    Z, sparkCreate

        ; Стираем искру с экрана
        LD    HL, (IX + SPARK_TBL_ADDR)
        LD    A, (IX + SPARK_TBL_MASK)
        XOR   (HL)
        LD    (HL), A

        ; Закончилось время слуществования искры
        DEC   (IX + SPARK_TBL_L)
        JP    Z, sparkCreate

        ; Ускорение по Y
        LD    BC, 20
        LD    HL, (IX + SPARK_TBL_DY)
        ADD   HL, BC ; dy
        EX    HL, DE

        ; Перемещение по Y
        LD    HL, (IX + SPARK_TBL_Y)
        ADD   HL, DE ; y

        ; За пределами экрана по Y
        LD    A, H
        CP    192
        JP    NC, sparkDisable

        ; Перемещение по X
        EXX
        LD    HL, (IX + SPARK_TBL_X)
        LD    DE, (IX + SPARK_TBL_DX)
        ADD   HL, DE ; x
        EXX

        ; За пределами экрана по X
        JP    C, sparkDisable

sparkCreated:
        ; Сохранение координат
        LD    (IX + SPARK_TBL_Y), HL
        LD    (IX + SPARK_TBL_DY), DE
        EXX
        LD    (IX + SPARK_TBL_X), HL
        LD    (IX + SPARK_TBL_DX), DE
        EXX

        ; Вычисление экранных координат
        EXX
        LD    A, H ; X
        EXX
        LD    L, A
        CALL  calcCoords

        ; Вычисление маски (a = 80h >> c)
        LD    IYH, pixelMaskTbl >> 8
        LD    IYL, C
        LD    A, (IY + (pixelMaskTbl & 0FFh))

        ; Сохряняем вычисленные значения для стирания искры
        LD    (IX + SPARK_TBL_ADDR), HL
        LD    (IX + SPARK_TBL_MASK), A

        ; Рисование искры
        XOR   (HL)
        LD    (HL), A
        RET

;-------------------------------------------------------------------------------
; Создать новую искру

sparkCreate:
        ; dy
        CALL  rand
        LD    E, A
        LD    D, 0

        ; y
        LD    A, (SPARK_INIT_Y)
        LD    H, A
        LD    L, 0

        ; dx
        EXX
        CALL  rand
        LD    E, A
        LD    D, 2

        ; x
        LD    A, (SPARK_INIT_X)
        OR    A
        RET   Z
        LD    H, A
        LD    L, 0
        EXX

        ; l
        CALL  rand
        AND   31
        INC   A
        LD    (IX + SPARK_TBL_L), A

        JP    sparkCreated

pixelMaskTbl db 80h, 40h, 20h, 10h, 8, 4, 2, 1

;-------------------------------------------------------------------------------

sparkDisable:
        LD    (IX + SPARK_TBL_L), 0
        RET

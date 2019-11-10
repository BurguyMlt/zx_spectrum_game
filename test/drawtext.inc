;-------------------------------------------------------------------------------

;drawText_A dw 0
;drawText_AC db 0
;
;drawText_NL:
;        LD     HL, (drawText_A)
;        PUSH   BC
;        LD     B, 10
;drawText_NL2:
;        INC    H ; Цикл
;        LD     A, H
;        AND    7
;        CALL   Z, drawText_L
;        DJNZ   drawText_NL2
;        POP    BC
;        LD     (drawText_A), HL
;        LD     A, (drawText_AC)
;        LD     C, A
;        JP     drawTextSub

;-------------------------------------------------------------------------------

calcCoords:
        ; ...76210 543XXXXX

        ; C = L & 7; L >>= 3;
        LD     A, L
        AND    7
        LD     C, A
        SRL    L
        SRL    L
        SRL    L

        ; L |= ((H << 2) & 0xE0)
        LD     A, H
        ADD    A
        ADD    A
        AND    0E0h
        OR     L
        LD     L, A

        ; B = (H >> 3) & 0x18
        LD     A, H
        RRCA
        RRCA
        RRCA
        AND    018h
        LD     B, A

        ; H = 0x40 | (H & 7) | B
        LD     A, H
        AND    007h
        OR     040h
        OR     A, B
        LD     H, A
        RET

;-------------------------------------------------------------------------------

drawText:
        LD     C, 0
drawTextSub:
        LD     A, (DE)
        INC    DE
        OR     A
        RET    Z
        CALL   drawCharSub
        JP     drawTextSub

;-------------------------------------------------------------------------------

drawTextEx:
        CALL   calcCoords
        JP     drawTextSub

;-------------------------------------------------------------------------------

drawCharSub:
        ; Чтение символа (a = *de++)
        PUSH   DE

        ; Вычисление адреса символа (de = image_font + a * 9)
        PUSH   HL
        CALL   calcCharAddr
        EX     HL, DE
        POP    HL
        PUSH   HL
        PUSH   BC

        ; Выбор одной из 8 подпрограмм рисования символа
        LD     B, 8
        LD     A, C
        EXX
        CP     4
        JP     NC, drawText_S4567
        CP     2
        JP     NC, drawText_S23
        CP     1
        JP     NC, drawText_S1
drawText_S0:
        ; Сдвиг на 0
        LD     HL, 00000h ; NOP, NOP
        LD     DE, 00000h ; NOP, NOP
        LD     BC, 0FF00h ;
        JP     drawText_CC
        ; Сдвиг на 1
drawText_S1:
        LD     HL, 00F00h ; RRCA, NOP
        LD     DE, 00000h ; NOP, NOP
        LD     BC, 07F80h ;
        JP     drawText_CC
drawText_S23:
        CP     3
        JP     NC, drawText_S3
        ; Сдвиг на 2
drawText_S2:
        LD     HL, 00F0Fh ; RRCA, RRCA
        LD     DE, 00000h ; NOP, NOP
        LD     BC, 03FC0h ;
        JP     drawText_CC
        ; Сдвиг на 3
drawText_S3:
        LD     HL, 00F0Fh ; RRCA, RRCA
        LD     DE, 0000Fh ; RRCA, NOP
        LD     BC, 01FE0h ;
        JP     drawText_CC
drawText_S4567:
        CP     6
        JP     NC, drawText_S67
        CP     5
        JP     NC, drawText_S5
drawText_S4:
        ; Сдвиг на 4
        LD     HL, 00F0Fh ; RRCA, RRCA
        LD     DE, 00F0Fh ; RRCA, RRCA
        LD     BC, 00FF0h
        JP     drawText_CC
        ; Сдвиг на 5
drawText_S5:
        LD     HL, 00707h ; RLCA, RLCA
        LD     DE, 00700h ; RLCA, NOP
        LD     BC, 007F8h
        JP     drawText_CC
drawText_S67:
        CP     7
        JP     NC, drawText_S7
        ; Сдвиг на 6
drawText_S6:
        LD     HL, 00707h ; RLCA, RLCA
        LD     DE, 00000h ; NOP, NOP
        LD     BC, 003FCh
        JP     drawText_CC
        ; Сдвиг на 7
drawText_S7:
        LD     HL, 00700h ; RLCA, NOP
        LD     DE, 00000h ; NOP, NOP
        LD     BC, 007FEh
        ; Вывод символа
drawText_CC:
        LD     (drawText_C1), HL
        LD     (drawText_C1 + 2), DE
        LD     A, B
        LD     (drawText_C2 + 1), A
        LD     A, C
        LD     (drawText_C3 + 1), A
        EXX
drawText_C:
        LD     A, (DE) ; Половинка
drawText_C1:
        NOP
        NOP
        NOP
        NOP
        LD     C, A
drawText_C2:
        AND    0
        XOR    (HL)
        LD     (HL), A
        LD     A, C ; Половинка
drawText_C3:
        AND    0
        INC    L ; влево
        XOR    (HL)
        LD     (HL), A
        DEC    L ; вправо
        INC    H ; Цикл
        LD     A, H
        AND    7
        CALL   Z, drawText_L
        INC    DE
        DEC    B
        JP     NZ, drawText_C
        ; Конец
drawText_1:
        POP    BC
        POP    HL
        LD     A, (DE)
        LD     B, A
        ADD    C
        CP     8
        JP     C, drawText_2
        AND    7
        INC    L ; Вправо
drawText_2:
        LD     C, A

        POP    DE
        RET

;-------------------------------------------------------------------------------

drawText_L:
        PUSH   DE
        LD     DE, 20h-800h
        ADD    HL, DE
        POP    DE
        LD     A, H
        AND    7
        RET    Z
        PUSH   DE
        LD     DE, 800h-100h
        ADD    HL, DE
        POP    DE
        RET

;-------------------------------------------------------------------------------

calcCharAddr:
        ; Вычисление адреса символа (de = image_font + a * 9)
        SUB    ' '
        CP     96
        JP     C, drawTextRus
        SUB    64
drawTextRus:
        LD     H, 0
        LD     L, A
        LD     D, H
        LD     E, L
        ADD    HL, HL
        ADD    HL, HL
        ADD    HL, HL
        ADD    HL, DE
        LD     DE, image_font
        ADD    HL, DE
        RET

;-------------------------------------------------------------------------------
; DE - текст / С - результат

measureText:
        LD     C, 0
measureText_1:
        ; Чтение символа (a = *de++)
        LD     A, (DE)
        INC    DE
        OR     A
        RET    Z

        ; Вычисление адреса символа (de = image_font + a * 9)
        PUSH   DE
        CALL   calcCharAddr
        LD     DE, 8
        ADD    HL, DE
        LD     A, (HL)
        ADD    C
        LD     C, A
        POP    DE
        JP     measureText_1

;-------------------------------------------------------------------------------

drawTextCenter:
        PUSH   DE
        PUSH   HL
        CALL   measureText
        LD     A, C
        SRL    A
        LD     C, A
        LD     A, 128
        SUB    C
        LD     C, A
        SRL    A
        SRL    A
        SRL    A
        POP    HL
        POP    DE
        ADD    L
        LD     L, A
        LD     A, C
        AND    7
        LD     C, A
        CALL   drawTextSub


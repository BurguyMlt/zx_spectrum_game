;-------------------------------------------------------------------------------
; Очистить экран
; Вход: D - атрбут
; Сохраняет: A, A', BC', DE', HL', IX, IY

clearScreen:
        LD     HL, 0
        ADD    HL, SP
        LD     (clearScreen_2 + 1), HL
        LD     SP, 5B00h
        LD     B, 300h / 32 ; Поместится в 8 бит
        LD     E, D
clearScreen_0:
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        DJNZ   clearScreen_0
        LD     B, 1800h / 32 ; Поместится в 8 бит
        LD     DE, 0
clearScreen_1:
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        PUSH   DE
        DJNZ   clearScreen_1
clearScreen_2:
        LD     SP, 0
        RET

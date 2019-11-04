;-------------------------------------------------------------------------------
; Очистить экран

clearScreen:
        LD     HL, 0
        ADD    HL, SP
        LD     (clearScreen_2 + 1), HL
        LD     SP, 5B00h
        LD     HL, 0
        LD     B, 1800h / 32 ; Поместится в 8 бит
clearScreen_1:
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        DJNZ   clearScreen_1
clearScreen_2:
        LD     SP, 0
        RET

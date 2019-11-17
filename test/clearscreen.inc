; ZX Spectrum test (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

;-------------------------------------------------------------------------------
; Очистить экран
; Вход: D - атрбут
; Сохраняет: A, A', BC', DE', HL', IY

clearScreen:
        LD     HL, 5B00h
clearScreenEx:
        LD     IX, 0
        ADD    IX, SP
        DI
        LD     SP, HL
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
        LD     SP, IX
        EI
        RET

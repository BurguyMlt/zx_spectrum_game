; ZX Spectrum test (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

        DEVICE ZXSPECTRUM128

        ORG 5D3Bh ; Адрес загрузки программы на бейсике

PayloadDestAddress = #5F00  ; Куда копировать полезную нагрузку

;-------------------------------------------------------------------------------

Basic:  db 0, 0 ; Номер первой строки бейсика
        dw End - BasicLine ; Размер строки бейсика
BasicLine:
        db 0F9h        ; RANDOMIZE
        db 0C0h        ; USR
        db 030h        ; 0
        db 00Eh        ; Признак закодированного числа, дале 5 байт числа.
        db 000h        ; Должно быть 0
        db 000h        ; Должно быть 0
        db Code & 0FFh ; Младшая часть адреса программы в маш. кодах
        db Code >> 8   ; Старшая часть адреса программы в маш. кодах
        db 000h        ; Должно быть 0
        db 03Ah        ; :
        db 0EAh        ; REM

;-------------------------------------------------------------------------------

PayloadLength=(End - Payload)

Code:   ; Блокируем прерывания
        DI

        ; Копирование полезной нагрузки
        LD   BC, Payload + PayloadLength - 1
        LD   DE, PayloadDestAddress + PayloadLength - 1
Code_1:
        LD   A, (BC)
        DEC  BC
        LD   (DE), A
        DEC  DE
        LD   HL, 10000h - (Payload - 1)
        ADD  HL, BC
        JP   C, Code_1

        ; Запуск
        JP   PayloadDestAddress

;-------------------------------------------------------------------------------

        ; Полезная нагрузка
Payload:
        INCBIN "build/boot.bin"

;-------------------------------------------------------------------------------

End:
        SAVEBIN "build/boot.B", Basic, End - Basic

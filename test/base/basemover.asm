    DEVICE ZXSPECTRUM128

    include "../module.inc"

    org moverAddr

begin:
    ; Выключение прерываний
    DI

    ; Перенос модуля
    LD HL, baseCode
    LD DE, baseAddr
    LD BC, baseCodeEnd - baseCode
    LDIR

    ; Инициализация стека
    LD    SP, stackEndAddr

    ; Выбор второй видеостраницы
    XOR   A
    LD    (gVideoPage), A
    LD    A, 17h
    LD    (gSystemPage), A
    LD    BC, 7FFDh
    OUT   (C), A

    ; Установка обработчика прерываний
    LD    HL, irqTableAddr
    LD    DE, irqTableAddr + 1
    LD    BC, 100h
    LD    (HL), irqAddr
    LD    A, H
    LDIR
    LD    I, A
    LD    A, 195 ; Код команды JP
    LD    (irqAddr), A
    LD    HL, gIrqHandler
    LD    (irqAddr + 1), HL
    IM    2
    EI

    ; Загрузка файла DIALOG
    LD    A, 6 | 0x10
    LD    BC, 7FFDh
    LD    (gSystemPage), A
    OUT   (C), A
    LD    HL, aDialog
    LD    DE, 0C000h
    CALL  gLoadFile

    ; Загрузка файла
    LD    HL, aStart
    JP    gExec

aStart db "city", 0
;aStart db "menu", 0
aDialog db "dialog", 0

baseCode:
    incbin "base.bin"
baseCodeEnd:

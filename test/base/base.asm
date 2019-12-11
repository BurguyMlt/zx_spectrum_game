; ZX Spectrum test (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

    DEVICE ZXSPECTRUM128

    include "../module.inc"

;-------------------------------------------------------------------------------
; Точки входа

    org baseAddr

begin:
iDrawText:       jp drawText
iDrawTextCenter: jp drawTextCenter
iDrawTextEx:     jp drawTextEx
iClearScreen:    jp clearScreen
iDrawImage:      jp drawImage
iMeasureText:    jp measureText
iCalcCoords:     jp calcCoords
iDrawCharSub:    jp drawCharSub
iExec:           jp exec
iIrqHandler:     jp irqHandler
iDrawPanel:      jp drawPanel

;-------------------------------------------------------------------------------

    org gEnd

irqHandler:
    PUSH  AF
    PUSH  BC
    PUSH  HL

    ; Переключение видеостраницы
    LD    A, (gVideoPage)
    BIT   0, A
    JP    Z, irqHandler_1
    AND   ~1
    LD    (gVideoPage), A
    LD    B, A
    LD    A, (gSystemPage)
    AND   ~8
    OR    B
    LD    (gSystemPage), A
    LD    BC, 7FFDh
    OUT   (C), A
irqHandler_1:

    LD    A, (gFrame)
    INC   A
    LD    (gFrame), A

    call  readKey

    POP   HL
    POP   BC
    POP   AF
    EI
    RETI

;-------------------------------------------------------------------------------

exec:
    LD    SP, stackEndAddr

    PUSH  HL
    ; Установка черной рамки
    LD    A, 0
    OUT   (-2), A
    ; Очистка всех экранов
    LD    A, 42h
    CALL  clearScreen
    POP   HL

    LD    DE, moduleLoadAddr
    CALL  loadFile
    JP    moduleLoadAddr

;-------------------------------------------------------------------------------

fileNotFound:
    ld   hl, 0
    ld   de, aFileNotFound
    call drawTextEx
    ld   hl, 10 << 8
    pop  de
    call drawTextEx

    jp $

;-------------------------------------------------------------------------------

aFileNotFound db "Не найден файл ", 0
aSpace = $ - 2
aExt db "C",0

;-------------------------------------------------------------------------------

loadFile:
    ; Сохраняем адрес загрузки
    push de

    ; Преобразование имени файла
    ld   bc, 808h
loadFile_0:
    ld   a, (hl)
    or   a
    jp   nz, loadFile_1
    ld   hl, aSpace
loadFile_1:
    ldi
    djnz loadFile_0
    ld   hl, aExt
    ldi
    ldi
    pop  hl

    ; Установка прерываний по умолчанию
    di
    ld   a, i
    push af
    im   1

    ; Передача имени файла
    push hl
    ld   c, 13h
    call 3D13h

    ; Поиск файла
    ld   c, 0Ah
    call 3D13h
    ld   a, c
    cp   0FFh
    jp   z, fileNotFound ; Файл не найден

    ; Загрузка заголовка
    ld   c, 8
    call 3D13h

    ; Надо перенести имя

    ; Загрузка файла
    ld   de, (5CEBh)
    ld   a, (5CEAh)
    ld   b, a
    pop  hl
    ld   c, 5
    call 3D13h

    ; Восстановление страницы
    LD    A, (gSystemPage)
    LD    BC, 7FFDh
    OUT   (C), A

    ; Восстановление прерываний
    pop  af
    LD   i, a
    im   2
    ei

    ret

;-------------------------------------------------------------------------------

panelX = 0
panelY = 20

drawPanel:
    ld   hl, image_panel
    ld   de, 5800h + panelX + (panelY << 5)
    call drawImage
    ld   hl, image_panel
    ld   de, 8000h + 5800h + panelX + (panelY << 5)
    jp   drawImage

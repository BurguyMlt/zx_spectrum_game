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
iLoadFile:       jp loadFile
iFarCall         jp farCall
iIrqHandler:     jp irqHandler
iDrawPanel:      jp drawPanel
iBeginDraw:      jp beginDraw
iEndDraw:        jp endDraw
iCopyVideoPage:  jp copyVideoPage
iPanelRedraw:    jp panelRedraw
iCopyPanel:      jp copyPanel
iStringBuffer:   ds gStringBufferSize

iFrame:            db 0
iVideoPage:        db 0
iSystemPage:       db 0
iKeyTrigger:       db 0
iKeyPressed:       db 0
iPlayerMoney:      db 0
iPlayerLut:        ds playerLutMax * 2
iPlayerLutCount:   db 0
iPlayerItems:      ds playerItemsMax
iPlayerItemsCount: db 0

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

    ; На всякий случай
    LD   A, (gSystemPage)
    LD   (23388),A

    ; Загрузка файла
    xor  a
    ld   (5CF9h), a
    ld   de, (5CEBh)
    ld   a, (5CEAh)
    ld   b, a
    pop  hl
    ld   a, 0FFh
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

; IYL - Страница, IX - Функция, A` - Портит, BC` - Портит.

farCall:
    ; Выбор страницы с сохранением выбранной видеостраницы
    EXX
    EX AF, AF
    DI
    LD    A, (gSystemPage)
    PUSH  AF
    AND   ~7
    OR    IYL
    LD    (gSystemPage), A
    LD    BC, 7FFDh
    OUT   (C), A
    EI
    EX AF, AF
    EXX

    ; Вызов
    CALL  farJump2

    ; Восстановление  с сохранением выбранной видеостраницы
    EXX
    EX AF, AF
    POP   AF
    AND   7
    LD    B, A
    DI
    LD    A, (gSystemPage)
    AND   ~7
    OR    B
    LD    (gSystemPage), A
    LD    BC, 7FFDh
    OUT   (C), A
    EI
    EX AF, AF
    EXX
    RET

farJump2:
    JP    IX

;-------------------------------------------------------------------------------

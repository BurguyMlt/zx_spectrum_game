; ZX Spectrum test (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

; 4000 - screen
; 5B00 - cache
; 5E00 - free

        DEVICE ZXSPECTRUM128

moduleLoadAddr = 7000h
stackAddr = 0C000h

;-------------------------------------------------------------------------------
; Точки входа

    org 626Fh

p_init: JP   init
frame db 0
videoPage db 0
systemPage db 0
keyTrigger db 0
keyPressed db 0
p_drawText: jp drawText
p_drawTextCenter: jp drawTextCenter
p_drawTextEx: jp drawTextEx
p_clearScreen: jp clearScreen
p_drawImage: jp drawImage
p_measureText: jp measureText
p_calcCoords: jp calcCoords
p_drawCharSub: jp drawCharSub
p_exec: jp exec

;-------------------------------------------------------------------------------

init:
        ; Инициализация стека
        LD    SP, stackAddr

        ; Выбор второй видеостраницы
        XOR   A
        LD    (videoPage), A
        LD    A, 17h
        LD    (systemPage), A
        LD    BC, 7FFDh
        OUT   (C), A

        ; Установка обработчика прерываний (FE00-FFFFh)
        LD    A, 24       ;код команды JR
        LD    (65535), A
        LD    A, 195      ;код команды JP
        LD    (65524), A
        LD    HL, IrqHandler
        LD    (65525), HL ;в HL - адрес обработчика прерываний
        LD    HL, #FE00   ;построение таблицы для векторов прерываний
        LD    DE, #FE01
        LD    BC, 256     ;размер таблицы минус 1
        LD    (HL), #FF   ;адрес перехода #FFFF (65535)
        LD    A,H         ;запоминаем старший байт адреса таблицы
        LDIR              ;заполняем таблицу
        LD    I,A         ;задаем в регистре I старший байт адреса
                          ; таблицы для векторов прерываний
        IM    2           ;назначаем второй режим прерываний
        EI                ;разрешаем прерывания

        ; Загрузка файла
        LD    HL, aStart

;-------------------------------------------------------------------------------

exec:
        LD    SP, stackAddr

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

aStart db "menu", 0
;aStart db "city", 0
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
        LD    A, (systemPage)
        LD    BC, 7FFDh
        OUT   (C), A

        ; Восстановление прерываний
        pop  af
        LD   i, a
        im   2
        ei

        ret

;-------------------------------------------------------------------------------

IrqHandler:
        PUSH  AF
        PUSH  BC
        PUSH  HL

        ; Переключение видеостраницы
        LD    A, (videoPage)
        BIT   0, A
        JP    Z, irqHandler_1
        AND   8
        LD    (videoPage), A
        LD    B, A
        LD    A, (systemPage)
        AND   ~8
        OR    B
        LD    (systemPage), A
        LD    BC, 7FFDh
        OUT   (C), A
irqHandler_1:

        LD    A, (frame)
        INC   A
        LD    (frame), A

        call  readKey

        POP   HL
        POP   BC
        POP   AF
        EI
        RETI

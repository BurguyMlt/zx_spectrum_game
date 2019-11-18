; ZX Spectrum test (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

        DEVICE ZXSPECTRUM128

        ORG #5F00

MAIN_MENU_LOGO_X = 1
MAIN_MENU_LOGO_Y = 1
MAIN_MENU_ITEMS_COUNT = 3
MAIN_MENU_ITEM_HEIGHT = 10
MAIN_MENU_ITEMS_X = 12
MAIN_MENU_ITEMS_Y0 = 95
MAIN_MENU_ITEMS_Y1 = 105
MAIN_MENU_ITEMS_Y2 = 115
MAIN_MENU_ITEMS_Y3 = 125
MAIN_MENU_ITEMS_B0X = 5
MAIN_MENU_ITEMS_B0Y = 192 - 8 - (10 * 2)
MAIN_MENU_ITEMS_B1X = 4
MAIN_MENU_ITEMS_B1Y = 192 - 8 - (10 * 1)
MAIN_MENU_ITEMS_B2X = 9
MAIN_MENU_ITEMS_B2Y = 192 - 8 - (10 * 0)

Begin:
        LD    HL, Begin
        LD    SP, HL

        CALL   showVideoPage

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
        DI                ;запрещаем прерывания на время
                          ; установки второго режима
        LD    I,A         ;задаем в регистре I старший байт адреса
                          ; таблицы для векторов прерываний
        IM    2           ;назначаем второй режим прерываний
        EI                ;разрешаем прерывания

        ; Установка черной рамки
        LD     A, 0
        OUT    (-2), A

        ; Сразу переходим на Интро
        JP     city

        CALL   menuLoad

        ; Очистка экрана.
        LD     D, 47h
        CALL   clearScreen ; Сохраняет EXX, IX, IY

        ; Вывод изображения
        LD     DE, 0x5800 + MAIN_MENU_LOGO_X + (MAIN_MENU_LOGO_Y << 5)
        LD     HL, image_logo
        CALL   drawImage

        ; Строка 1
        LD     HL, 04000h + (MAIN_MENU_ITEMS_X) + (((MAIN_MENU_ITEMS_Y0) & 7) << 8) + ((((MAIN_MENU_ITEMS_Y0) >> 3) & 7) << 5) + ((((MAIN_MENU_ITEMS_Y0) >> 6) & 3) << 11) ; Адрес вывода
        LD     DE, mainMenuItemText0 ; Строка текста
        CALL   drawText

        ; Строка 2
        LD     HL, 04000h + (MAIN_MENU_ITEMS_X) + (((MAIN_MENU_ITEMS_Y1) & 7) << 8) + ((((MAIN_MENU_ITEMS_Y1) >> 3) & 7) << 5) + ((((MAIN_MENU_ITEMS_Y1) >> 6) & 3) << 11) ; Адрес вывода
        LD     DE, mainMenuItemText1 ; Строка текста
        CALL   drawText

        ; Строка 3
        LD     HL, 04000h + (MAIN_MENU_ITEMS_X) + (((MAIN_MENU_ITEMS_Y2) & 7) << 8) + ((((MAIN_MENU_ITEMS_Y2) >> 3) & 7) << 5) + ((((MAIN_MENU_ITEMS_Y2) >> 6) & 3) << 11) ; Адрес вывода
        LD     DE, mainMenuItemText2 ; Строка текста
        CALL   drawText

        ; Строка 4
        LD     HL, 04000h + (MAIN_MENU_ITEMS_X) + (((MAIN_MENU_ITEMS_Y3) & 7) << 8) + ((((MAIN_MENU_ITEMS_Y3) >> 3) & 7) << 5) + ((((MAIN_MENU_ITEMS_Y3) >> 6) & 3) << 11) ; Адрес вывода
        LD     DE, mainMenuItemText3 ; Строка текста
        CALL   drawText

        ; Цвет букв копирайта
        LD     HL, 05800h + (((MAIN_MENU_ITEMS_B0Y) >> 3) << 5)
        LD     DE, 05801h + (((MAIN_MENU_ITEMS_B0Y) >> 3) << 5)
        LD     BC, 32 * ((((MAIN_MENU_ITEMS_B2Y) + 7 + 7) >> 3) - ((MAIN_MENU_ITEMS_B0Y) >> 3)) - 1
        LD     (HL), 45h
        LDIR

        ; Строка копирайтов 1
        LD     HL, 04000h + (((MAIN_MENU_ITEMS_B0Y) & 7) << 8) + ((((MAIN_MENU_ITEMS_B0Y) >> 3) & 7) << 5) + ((((MAIN_MENU_ITEMS_B0Y) >> 6) & 3) << 11) ; Адрес вывода
        LD     DE, mainMenuBottomText0 ; Строка текста
        CALL   drawTextCenter

        ; Строка копирайтов 2
        LD     HL, 04000h + (((MAIN_MENU_ITEMS_B1Y) & 7) << 8) + ((((MAIN_MENU_ITEMS_B1Y) >> 3) & 7) << 5) + ((((MAIN_MENU_ITEMS_B1Y) >> 6) & 3) << 11) ; Адрес вывода
        LD     DE, mainMenuBottomText1 ; Строка текста
        CALL   drawTextCenter

        ; Строка копирайтов 3
        LD     DE, mainMenuBottomText2 ; Строка текста
        LD     HL, 04000h + (((MAIN_MENU_ITEMS_B2Y) & 7) << 8) + ((((MAIN_MENU_ITEMS_B2Y) >> 3) & 7) << 5) + ((((MAIN_MENU_ITEMS_B2Y) >> 6) & 3) << 11) ; Адрес вывода
        call   drawTextCenter

        ; Цвет курсора
        LD     HL, 05800h + (MAIN_MENU_ITEMS_X - 1) + (((MAIN_MENU_ITEMS_Y0) >> 3) << 5)
        LD     DE, 20h
        LD     BC, 00644h
boot_1:
        LD     (HL), C
        ADD    HL, DE
        DJNZ   boot_1

kk:
        ; Курсор
        LD     HL, (MAIN_MENU_ITEMS_Y0 << 8) | (MAIN_MENU_ITEMS_X * 8 - 8)
        LD     A, (mainMenuX)
        ADD    H
        LD     H, A
        LD     DE, mainMenuItemCursor ; Строка текста
        CALL   drawTextEx

ee:
        LD     hl, frame
        ld     a, (hl)
        or     a
        JP     z, ee
        DEC    (hl)

        LD     A, (key)
        AND    KEY_UP
        JP     Z, k1
        LD     a, (mainMenuX)
        inc    a
        ld     (mainMenuX), a
k1:

        LD     A, (key)
        AND    KEY_DOWN
        JP     Z, k2
        LD     a, (mainMenuX)
        dec    a
        LD     (mainMenuX), a
k2:
        JP     kk
//        JP     intro

;-------------------------------------------------------------------------------

IrqHandler:
        PUSH  AF
        PUSH  BC

        LD    A, (visibleVideoPage)
        AND   8
        OR    7
        LD    BC, 7FFDh
        OUT   (C), A
        LD    A, (visibleVideoPage)
        AND   ~1
        LD    (visibleVideoPage), A


        LD    A, (frame)
        INC   A
        LD    (frame), A

        POP   BC
        POP   AF
        EI
        RETI

frame db 0
mainMenuX db 0
mainMenuX1 db 0

;-------------------------------------------------------------------------------
; Ожидание нажатия клавиши

KEY_UP = 1
KEY_DOWN = 2
KEY_LEFT = 4
KEY_RIGHT = 8

key db 0


        ; right - 10 - 4
        ; down - 10 - 10
        ; up - 10 - 08
        ; left - 08 - 10

;-------------------------------------------------------------------------------

tickHandler dw 0
redrawHandler dw 0
p7FFD db 0

;-------------------------------------------------------------------------------

mainMenuItemText0:   db "Новая игра", 0
mainMenuItemText1:   db "Настройка управления", 0
mainMenuItemText2:   db "Загрузить игру", 0
mainMenuItemText3:   db "Сохранить игру", 0
mainMenuItemCursor:  db "@",0

mainMenuBottomText0: db "Игра | 2019 Алексей {Alemorf} Морозов", 0
mainMenuBottomText1: db "Мюзикл | 1998 Антон {Саруман} Круглов,", 0
mainMenuBottomText2: db "Елена {Мириам} Ханпира", 0

        include "clearscreen.inc"
        include "drawimage.inc"
        include "drawtext.inc"
        include "build/logo.inc"
        include "build/font.inc"
        include "build/menu.asm"
        include "build/keyboard.asm"
        include "intro.inc"
        include "city/city.asm"
        include "scroll.inc"

        SAVEBIN "build/boot.bin", Begin, $ - Begin

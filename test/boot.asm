        DEVICE ZXSPECTRUM128

        ORG #8000

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
        ; Установка черной рамки
        LD     A, 0
        OUT    (-2), A

        ; Сразу переходим на Интро
        ;JP     intro

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

        ; Курсор
        LD     HL, 04000h + (MAIN_MENU_ITEMS_X - 1) + (((MAIN_MENU_ITEMS_Y0) & 7) << 8) + ((((MAIN_MENU_ITEMS_Y0) >> 3) & 7) << 5) + ((((MAIN_MENU_ITEMS_Y0) >> 6) & 3) << 11) ; Адрес вывода
        LD     DE, mainMenuItemCursor ; Строка текста
        CALL   drawText

        CALL   waitKey
        JP     intro

mainMenuX db 0
mainMenuX1 db 0

;-------------------------------------------------------------------------------
; Ожидание нажатия клавиши

waitKey:
        ; Если не нажата ни одна клавиша, то продолжаем.
        LD     BC, 000FEh
        IN     A, (C)
        CPL
        AND    1Fh
        JP     Z, waitKey
        RET

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
        include "intro.inc"
        include "scroll.inc"

        SAVEBIN "build/boot.bin", Begin, $ - Begin

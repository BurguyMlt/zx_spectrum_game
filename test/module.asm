    DEVICE ZXSPECTRUM128
    org 7000h

boot = 626Fh + 3

frame            = boot + 0 ; db
videoPage        = boot + 1 ; db
systemPage       = boot + 2 ; db
keyTrigger       = boot + 3 ; db
keyPressed       = boot + 4 ; db
drawText         = boot + 5 + 3 * 0
drawTextCenter   = boot + 5 + 3 * 1
drawTextEx       = boot + 5 + 3 * 2
clearScreen      = boot + 5 + 3 * 3
drawImage        = boot + 5 + 3 * 4
measureText      = boot + 5 + 3 * 5
calcCoords       = boot + 5 + 3 * 6
drawCharSub      = boot + 5 + 3 * 7
exec             = boot + 5 + 3 * 8

    jp main

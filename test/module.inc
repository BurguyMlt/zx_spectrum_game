;romAddr        = 0
;screenAddr     = 4000h
;cacheAddr      = 5B00h

gPanelChanged1  = 0x5D80
gPanelChanged2  = 0x5D80 | 0x8000

irqTableAddr      = 5F00h
irqAddr           = 6060h
stackBeginAddr    = 6001h
stackEndAddr      = 605Fh
baseAddr          = 6063h
moduleLoadAddr    = 7000h
moverAddr         = 8000h

gEnd = baseAddr

; Функции
gDrawText         = gEnd
gEnd = gEnd + 3
gDrawTextCenter   = gEnd
gEnd = gEnd + 3
gDrawTextEx       = gEnd
gEnd = gEnd + 3
gClearScreen      = gEnd
gEnd = gEnd + 3
gDrawImage        = gEnd
gEnd = gEnd + 3
gMeasureText      = gEnd
gEnd = gEnd + 3
gCalcCoords       = gEnd
gEnd = gEnd + 3
gDrawCharSub      = gEnd
gEnd = gEnd + 3
gExec             = gEnd
gEnd = gEnd + 3
gIrqHandler       = gEnd
gEnd = gEnd + 3
gDrawPanel        = gEnd
gEnd = gEnd + 3

; Переменные
gFrame            = gEnd
gEnd = gEnd + 1
gVideoPage        = gEnd
gEnd = gEnd + 1
gSystemPage       = gEnd
gEnd = gEnd + 1
gKeyTrigger       = gEnd
gEnd = gEnd + 1
gKeyPressed       = gEnd
gEnd = gEnd + 1
gPlayerMoney      = gEnd
gEnd = gEnd + 2

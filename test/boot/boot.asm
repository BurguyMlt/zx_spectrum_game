        DEVICE ZXSPECTRUM128

DOS=15619
BASE=25199

NUMBER=0Eh
CLEAR=0FDh
RANDOMIZE=0F9h
USR=0C0h
REM=0EAh
LOAD=0EFh
CODE=0AFh
EOL=0Dh

Basic:  db 0, 10
        db Line1e - Line1, 0
Line1:
        db CLEAR, '0', NUMBER, 0, 0, BASE & 0FFh, BASE >> 8, 0 
        db ':', RANDOMIZE, USR, '0', 0Eh, 0, 0, DOS & 0FFh, DOS >> 8, 0
        db ':', REM
        db ':', LOAD, '"', 'b', 'a', 's', 'e', '"', CODE, '0' + (BASE / 10000) % 10
        db '0' + (BASE / 1000) % 10, '0'+ (BASE / 100) % 10, '0' + (BASE / 10) % 10, '0' + BASE % 10
        db EOL
Line1e:
        db 0, 20
        db Line2e - Line2, 0
Line2:  db RANDOMIZE, USR, '0', NUMBER, 0, 0, BASE & 0FFh, BASE >> 8, 0
        db EOL
Line2e:

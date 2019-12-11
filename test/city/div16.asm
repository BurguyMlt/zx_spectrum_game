; HL делится на DE, результат в HL, остаток в DE

div16:  EX HL, DE
_DIV:	LD A,H
        OR L
        RET Z
        LD BC,0000
        PUSH BC
_DIV1:	LD A,E
	SUB L
        LD A,D
        SBC H
        JP C, _DIV2
        PUSH HL
        ADD HL, HL
        JP NC, _DIV1
_DIV2:	LD HL,0000
_DIV3:	POP BC
        LD A,B
        OR C
        RET Z
        ADD HL, HL
        PUSH DE
        LD A,E
	SUB C
        LD E,A
        LD A,D
        SBC B
        LD D,A
        JP C, _DIV4
        INC HL
        POP BC
        JP _DIV3
_DIV4:	POP DE
        JP _DIV3

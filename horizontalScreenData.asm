ROOM_RULES_DATA 	equ		$FA00

; datablock screenrules
org ROOM_RULES_DATA
db $6E, $74, $1F, $40
db $A1, $3B, $F0, $30
db $B9, $7F, $B7, $60
db $AB, $7F, $D6, $20
db $2F, $FF, $DE, $20
db $AB, $7B, $F4, $30
db $01, $02, $00, $00
db $FF, $FF, $FF, $70
db $0F, $1E, $16, $00
db $3F, $FF, $FF, $60
db $B9, $7F, $B7, $30
db $A9, $7B, $F5, $40
db $BF, $FF, $D6, $20
db $B9, $7B, $F2, $10
db $B9, $7F, $B7, $30
db $60, $57, $96, $00
db $7F, $FF, $FF, $60
db $33, $FF, $F6, $20
db $11, $02, $32, $00
db $2E, $74, $1F, $40
db $2A, $75, $9F, $20
db $B9, $76, $3F, $40
db $2F, $DF, $D6, $20
db $00, $00, $21, $10
db $00, $00, $20, $00
db $FF, $FF, $FF, $70
db $23, $9F, $D7, $40
db $7F, $7F, $7F, $70
db $BD, $BB, $E3, $00
db $27, $DF, $DE, $20
db $2F, $5F, $56, $00
db $0E, $1C, $16, $60
db $63, $7E, $5E, $20

; datablock for world 3 screenrules
db $E1, $80, $00, $00
db $C9, $C0, $00, $00
db $E1, $80, $00, $00
db $CB, $F0, $00, $00
db $EF, $E0, $00, $00
db $CB, $E0, $00, $00
db $ED, $E0, $00, $00
db $E7, $E0, $00, $00
db $EF, $E0, $00, $00
db $E9, $A0, $00, $00
db $80, $B0, $00, $00
db $EB, $E0, $00, $00
db $A1, $C0, $00, $00
db $84, $A0, $00, $00
db $EF, $F0, $00, $00
db $EF, $F0, $00, $00

; addresses for 1 - 38
db $00, $00
db $0B, $71
db $3E, $71
db $80, $71
db $A4, $71
db $EC, $71
db $3A, $72
db $73, $72
db $A3, $72
db $D3, $72
db $4B, $73
db $81, $73
db $A5, $73
db $CF, $73
db $F9, $73
db $23, $74
db $56, $74
db $7D, $74
db $F8, $74
db $76, $75
db $97, $75
db $C4, $75
db $0C, $76
db $39, $76
db $B1, $76
db $17, $77
db $4D, $77
db $8C, $77
db $DB, $76
db $A4, $74
db $C5, $74
db $E0, $74
db $81, $76

;lvl 1 start room, index 0x21
db $2E, $75

; world 3 - we'll call it rooms 33 -> 50 (0x22 - 0x31, convienently 16 rooms)
db $F3, $70
db $0E, $71
db $4D, $71
db $86, $71
db $AD, $71
db $16, $72
db $46, $72
db $AF, $72
db $06, $73
db $3F, $73
db $B7, $70
; best start screen for lvl 3, index 0x2D
db $79, $72
db $2F, $71
db $DA, $71
db $F8, $71
db $DC, $72

; door placement data room index 0x00 - 0x21 (World 1)
db $AE
db $74
db $4B
db $93
db $73
db $AB
db $75
db $55
db $A9
db $71
db $74
db $2E
db $99
db $64
db $B1
db $A7
db $4C
db $2C
db $8E
db $51
db $43
db $55
db $00
db $9E
db $00
db $46
db $41
db $92
db $00
db $00
db $00
db $00
db $9D

; door placement room index 0x22 - 0x32 (World 3)
db $64
db $00
db $AB
db $16
db $7C
db $88
db $88
db $9C
db $78
db $5E
db $BE
db $5F
db $00
db $00
db $00
db $00

; item placement
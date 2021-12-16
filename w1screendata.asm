ROOM_RULES_DATA 	equ		$FA10

org ROOM_RULES_DATA
; Rooms are represented by 8 bytes of data
; The first 5 bytes are binary data that tell us if they connect to the room in that index 1 - 40
; The 6th byte represents the door location to use if a door is in that room
; the 7th and 8th bytes are the memory address of the room's data


; The next two bytes are the address of the room data
db $6E, $74, $1F, $40, $01, $ae, $0b, $71
db $A1, $3B, $F0, $20, $02, $74, $3e, $71
db $B9, $7F, $B7, $60, $01, $4b, $80, $71
db $AB, $7F, $D6, $20, $00, $93, $a4, $71
db $2F, $FF, $DE, $20, $00, $73, $ec, $71
db $AB, $7B, $F4, $20, $02, $ab, $3a, $72
db $01, $02, $00, $00, $00, $75, $73, $72
db $FF, $FF, $FF, $60, $02, $55, $a3, $72
db $0F, $1E, $16, $00, $04, $a9, $d3, $72
db $3F, $FF, $FF, $60, $02, $71, $4b, $73
db $B9, $7F, $B7, $20, $02, $74, $81, $73
db $A9, $7B, $F5, $40, $01, $2e, $a5, $73
db $BF, $FF, $D6, $20, $06, $99, $cf, $73
db $B9, $7B, $F2, $00, $02, $64, $f9, $73
db $B9, $7F, $B7, $20, $02, $b1, $23, $74
db $60, $57, $96, $00, $00, $a7, $56, $74
db $7F, $FF, $FF, $60, $00, $4c, $7d, $74
db $33, $FF, $F6, $20, $02, $2c, $f8, $74
db $11, $02, $32, $00, $02, $8e, $76, $75
db $2E, $74, $1F, $40, $00, $51, $97, $75
db $2A, $75, $9F, $20, $00, $43, $c4, $75
db $B9, $76, $3F, $40, $03, $55, $0c, $76
db $2F, $DF, $D6, $20, $00, $00, $39, $76
db $00, $00, $21, $00, $00, $9e, $b1, $76
db $00, $00, $20, $00, $00, $00, $17, $77 ;needs platforms, never used
db $FF, $FF, $FF, $60, $02, $46, $4d, $77
db $23, $9F, $D7, $40, $01, $41, $8c, $77
db $7F, $7F, $7F, $60, $00, $92, $db, $76 ;needs platforms, never used
db $BD, $BB, $E3, $00, $06, $00, $a4, $74 ;needs platforms, never used
db $27, $DF, $DE, $20, $00, $00, $c5, $74 ;needs platforms, never used
db $2F, $5F, $56, $00, $00, $00, $e0, $74 ;needs platforms, never used
db $0E, $1C, $16, $60, $00, $00, $81, $76 ;needs platforms, never used
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $70 ; end room 1
db $00, $00, $00, $00, $00, $00, $39, $70 ; end room 2
db $00, $00, $00, $00, $00, $00, $78, $70 ; end room 3
db $B3, $7F, $F6, $62, $00, $00, $bd, $70 ; start rooms
db $2F, $5F, $D6, $62, $00, $00, $09, $73 ; start rooms
db $63, $7E, $5E, $62, $00, $00, $2e, $75 ; start rooms
db $00, $00, $00, $00, $00, $00, $FF, $FF ; fake "end of level" room

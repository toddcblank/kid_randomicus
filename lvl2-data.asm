RULES_DATA			equ		$F900

org RULES_DATA
db $FF, $FF, $FB, $FF
db $FF, $FF, $FF, $FF
db $FF, $F3, $7F, $FF
db $FF, $FF, $FF, $FF
db $FF, $FF, $7B, $FF
db $FF, $FE, $7B, $FF
db $FF, $FF, $7B, $FF
db $FF, $FE, $FF, $FF
db $FF, $FF, $FF, $FF
db $FF, $FF, $FB, $E7
db $FF, $FF, $FF, $FF
db $FF, $FF, $FB, $FF
db $FD, $FF, $FB, $DF
db $FF, $FF, $FB, $FF
db $FF, $F7, $FF, $F8
db $FF, $F3, $FF, $FF
db $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF
db $FB, $F3, $FF, $FF
db $FF, $FF, $FF, $FF
db $FF, $93, $7F, $FE
db $FF, $FF, $FB, $FF
db $FF, $FF, $FB, $FF
db $FF, $FE, $FF, $FF
db $FD, $FF, $FF, $BF
db $FF, $FF, $FB, $FF
db $FF, $F3, $7F, $FE
db $FD, $FF, $FF, $D7
db $FF, $F3, $FF, $FF
db $FF, $E1, $7F, $FD
db $FF, $FF, $FB, $FF
db $FF, $FF, $FB, $FF
db $FF, $FF, $FB, $FF

; addresses
db $1B, $B1
db $3F, $B1
db $63, $B1
db $8D, $B1
db $BD, $B1
db $D5, $B1
db $08, $B2
db $3E, $B2
db $65, $B2
db $89, $B2
db $B3, $B2
db $0A, $B3
db $28, $B3
db $52, $B3
db $7C, $B3
db $AC, $B3
db $D0, $B3
db $EE, $B3
db $1E, $B4
db $45, $B4
db $78, $B4
db $B7, $B4
db $DB, $B4
db $3E, $B5
db $62, $B5
db $B0, $B5
db $0A, $B6
db $43, $B6
db $9D, $B6
db $CD, $B6
db $00, $B7
db $27, $B7
db $E5, $B0
db $D4, $B2
db $05, $B5
db $3A, $B0
db $70, $B0
db $AC, $B0
db $FF, $FF	;end of level data
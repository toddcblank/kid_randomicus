RULES_DATA			equ		$F880

org RULES_DATA
; Rooms are represented by 8 bytes of data
; The first 5 bytes are binary data that tell us if they connect to the room in that index 1 - 40
; The 6th byte represents the door location to use if a door is in that room
; the 7th and 8th bytes are the memory address of the room's data

; The next two bytes are the address of the room data
; 1-5
db $FF, $FF, $FB, $FF, $07, $A3, $1B, $B1	
db $FF, $FF, $FF, $FF, $07, $AA, $3F, $B1
db $FF, $F3, $7F, $FF, $07, $AB, $63, $B1
db $FF, $FF, $FF, $FF, $07, $A4, $8D, $B1
db $FF, $FF, $7B, $FF, $07, $A9, $BD, $B1
db $FF, $FE, $7B, $FF, $07, $76, $D5, $B1
db $FF, $FF, $7B, $FF, $07, $AD, $08, $B2
db $FF, $FE, $FF, $FF, $07, $A8, $3E, $B2
db $FF, $FF, $FF, $FF, $07, $A5, $65, $B2
db $FF, $FF, $FB, $E7, $07, $1E, $89, $B2
db $FF, $FF, $FF, $FF, $07, $AE, $B3, $B2
db $FF, $FF, $FB, $FF, $07, $AA, $0A, $B3
db $FD, $FF, $FB, $DF, $07, $6A, $28, $B3
db $FF, $FF, $FB, $FF, $07, $AA, $52, $B3
db $FF, $F7, $FF, $F8, $07, $89, $7C, $B3
db $FF, $F3, $FF, $FF, $07, $68, $AC, $B3
db $FF, $FF, $FF, $FF, $07, $8A, $D0, $B3
db $FF, $FF, $FF, $FF, $07, $87, $EE, $B3
db $FF, $FF, $FF, $FF, $07, $7C, $1E, $B4
db $FF, $FF, $FF, $FF, $07, $9A, $45, $B4
db $FB, $F3, $FF, $FF, $07, $5A, $78, $B4
db $FF, $FF, $FF, $FF, $07, $9C, $B7, $B4
db $FF, $93, $7F, $FE, $07, $96, $DB, $B4
db $FF, $FF, $FB, $FF, $07, $AA, $3E, $B5
db $FF, $FF, $FB, $FF, $07, $A8, $62, $B5
db $FF, $FE, $FF, $FF, $07, $2B, $B0, $B5
db $FD, $FF, $FF, $BF, $07, $00, $0A, $B6
db $FF, $FF, $FB, $FF, $07, $9E, $43, $B6
db $FF, $F3, $7F, $FE, $07, $A6, $9D, $B6
db $FD, $FF, $FF, $D7, $07, $4B, $CD, $B6
db $FF, $F3, $FF, $FF, $07, $A5, $00, $B7
db $FF, $E1, $7F, $FD, $07, $9A, $27, $B7
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
db $00, $00, $00, $00, $00, $00, $3A, $B0	; ending room 1
db $00, $00, $00, $00, $00, $00, $70, $B0	; ending room 2
db $00, $00, $00, $00, $00, $00, $AC, $B0	; ending room 3
db $FF, $FF, $FB, $FF, $00, $00, $E5, $B0	; starting room 1
db $FF, $FF, $FB, $FF, $00, $00, $D4, $B2	; starting room 2
db $FF, $FF, $FB, $FF, $00, $00, $05, $B5	; starting room 3
db $00, $00, $00, $00, $00, $00, $FF, $FF	; fake "end of level" room
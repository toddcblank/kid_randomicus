RULES_DATA			equ		$F880

org RULES_DATA
; Rooms are represented by 8 bytes of data
; The first 5 bytes are binary data that tell us if they connect to the room in that index 1 - 40
; The 6th byte represents the door location to use if a door is in that room
; the 7th and 8th bytes are the memory address of the room's data

; The next two bytes are the address of the room data
; 1-5
db $FF, $FF, $FB, $FF, $00, $A3, $1B, $B1	
db $FF, $FF, $FF, $FF, $00, $AA, $3F, $B1
db $FF, $F3, $7F, $FF, $00, $AB, $63, $B1
db $FF, $FF, $FF, $FF, $00, $A4, $8D, $B1
db $FF, $FF, $7B, $FF, $00, $A9, $BD, $B1
; 6-10								
db $FF, $FE, $7B, $FF, $00, $76, $D5, $B1
db $FF, $FF, $7B, $FF, $00, $AD, $08, $B2
db $FF, $FE, $FF, $FF, $00, $A8, $3E, $B2
db $FF, $FF, $FF, $FF, $00, $A5, $65, $B2
db $FF, $FF, $FB, $E7, $00, $1E, $89, $B2
; 11 - 15
db $FF, $FF, $FF, $FF, $00, $AE, $B3, $B2
db $FF, $FF, $FB, $FF, $00, $AA, $0A, $B3
db $FD, $FF, $FB, $DF, $00, $6A, $28, $B3
db $FF, $FF, $FB, $FF, $00, $AA, $52, $B3
db $FF, $F7, $FF, $F8, $00, $89, $7C, $B3
; 16 - 20
db $FF, $F3, $FF, $FF, $00, $68, $AC, $B3
db $FF, $FF, $FF, $FF, $00, $8A, $D0, $B3
db $FF, $FF, $FF, $FF, $00, $87, $EE, $B3
db $FF, $FF, $FF, $FF, $00, $7C, $1E, $B4
db $FF, $FF, $FF, $FF, $00, $9A, $45, $B4
; 21 - 25
db $FB, $F3, $FF, $FF, $00, $5A, $78, $B4
db $FF, $FF, $FF, $FF, $00, $9C, $B7, $B4
db $FF, $93, $7F, $FE, $00, $96, $DB, $B4
db $FF, $FF, $FB, $FF, $00, $AA, $3E, $B5
db $FF, $FF, $FB, $FF, $00, $A8, $62, $B5
; 26 - 30                    
db $FF, $FE, $FF, $FF, $00, $2B, $B0, $B5
db $FD, $FF, $FF, $BF, $00, $00, $0A, $B6
db $FF, $FF, $FB, $FF, $00, $9E, $43, $B6
db $FF, $F3, $7F, $FE, $00, $A6, $9D, $B6
db $FD, $FF, $FF, $D7, $00, $4B, $CD, $B6
; 31-35
db $FF, $F3, $FF, $FF, $00, $A5, $00, $B7
db $FF, $E1, $7F, $FD, $00, $9A, $27, $B7
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
; 36 - 40
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far
db $00, $00, $00, $00, $00, $00, $00, $00	; non-existant so far

; 41 - 46, starting and ending room 
db $FF, $FF, $FB, $FF, $00, $00, $E5, $B0	; starting room 1
db $FF, $FF, $FB, $FF, $00, $00, $D4, $B2	; starting room 2
db $FF, $FF, $FB, $FF, $00, $00, $05, $B5	; starting room 3, never picked as a destination

db $00, $00, $00, $00, $00, $00, $3A, $B0	; ending room 1
db $00, $00, $00, $00, $00, $00, $70, $B0	; ending room 2
db $00, $00, $00, $00, $00, $00, $AC, $B0	; ending room 3

db $00, $00, $00, $00, $00, $00, $FF, $FF	; fake "end of level" room
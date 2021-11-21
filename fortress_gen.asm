; Rooms in Kid Icarus can be represented by two bytes
; 4 bits for each direction that you can come from
; 4 bits for each direction you can go to
; so a room is encoded as:
; (where U = UP, R = RIGHT, D = DOWN, L = LEFT)
;FROM U     R     D     L
;TO   URDL  URDL  URDL  URDL
;
; So a room encoded as:
; 0111 0110 0010 0011
;
; Would be a room where
; ;rom the top you can only go R, D, or L
; from R can only go R or D
; from D can only go D
; from L can go D or L
;
; and this room's potential exits would be listed as:
; 76 23
; 
; a fully open room, which all 4 directions are accessible from every other direction would be
; FF FF
; 
; we'll also encode the available exits for a room, we could
; probably deduce this but it's easier to just encode it
;
; we also save some room by encoding the room id and allowing us to skip encoding unused rooms
;
; rooms!
;FORTRESS_ROOMS_CONNECTIONS	equ	$BCF0
FORTRESS_ROOMS_CONNECTIONS	equ	$F2F0
START_ROOM					equ	#$33
DUNGEON_START				equ	$70AF
ENEMY_START					equ $712F
FORTRESS_SIZE				equ	#$20

; for music
FORT1_BOSS_IDX				equ	$CB90
FORT2_BOSS_IDX				equ	$CB91
FORT3_BOSS_IDX				equ	$CB92

; varibale holders
ROOM_COUNT					equ	$0070
NEED_EXIT_NEXT				equ $0071	; which direction we came from, this tells us
										; which set of bits to check for possible exits
ROOM_OFFSET					equ $0072	; which room we're working with 0 - 63
NEED_EXIT					equ $0073	; which exit will need to be available in a room
NEXT_ROOM_OFFSET			equ $0074	; the next room we're going to
INITIAL_SEED_LB				equ	$00EF
INITIAL_SEED_RB				equ	$00F0
;INITIAL_SEED_LB				equ	$0080
;INITIAL_SEED_RB				equ	$0081
RNG_SEED 					equ	$0197
RNG_SEED_RB 				equ	$0198
PATH_COMPARISON				equ	$0075
ROOM_ID						equ	$0076
EXIT_PATH_BYTE				equ $0077	; viable exits for the room we're in
NEXT_EXIT_PATH_BYTE			equ $0078
DEADEND_DETECTOR			equ $0079
PATH_START					equ $6100
PATH_IDX					equ $007A
VALID_EXITS					equ $007B
ENEMY_TEMP_STORAGE			equ $007C
ENEMY_PLACEMENT_IDX			equ $007D
ROOM_PATH_START				equ $6200
ROOM_PATH_IDX				equ $007E
EXISTING_EXITS				equ $007F

DUNGEON_SEED_LB				equ $00B0
DUNGEON_SEED_RB				equ $00B1

org FORTRESS_ROOMS_CONNECTIONS
db $00, $00, $00, $00; room 00 - not a real room
db $77, $77, $07, $01; room 01 - 1111 1111 1111 1111
db $EE, $EE, $0F, $02; room 02 - 1110 1110 1110 1110
db $FF, $FF, $0F, $03; room 03 - 1111 1111 1111 1111

db $FF, $FF, $0F, $04; room 04 - 1111 1111 1111 1111
db $00, $00, $00, $05; room 05 - this is replaced, need to find the original
db $00, $00, $00, $06; room 06 - this is replaced, need to find the original
db $0E, $EE, $0E, $07; room 07 - 0000 1110 1110 1110

db $E6, $6E, $0F, $08; room 08 - 1110 0110 0110 1110
db $00, $00, $00, $09; room 09 - this is replaced, need to find the original
db $F2, $6F, $0F, $0A; room 0A - 1011 0010 0110 1011
db $80, $08, $09, $0B; room 0B - 1000 0000 0000 1100 (2-4 boss room)

db $FF, $FF, $0F, $0C; room 0C - 1111 1111 1111 1111
db $00, $00, $00, $0D; room 0D - this is replaced, need to find the original
db $33, $BB, $0F, $0E; room 0E - 0011 0011 1100 1100 (or 1111 1111 1100 1100 with wall clips)
db $FF, $FF, $0F, $0F; room 0F - 0111 0111 0111 0000

db $00, $00, $00, $10; room 10 - non-existant
db $00, $00, $00, $11; room 11 - this is replaced, need to find the original
db $AA, $0A, $0B, $12; room 12 - 1010 1010 0000 1010
db $EE, $EE, $0F, $13; room 13 - 1110 1110 1110 1110

db $BB, $0B, $0B, $14; room 14 - 1011 1011 0000 1011
db $EE, $EE, $0F, $15; room 15 - 1110 1110 1110 1110 (medic room)
db $EE, $EE, $0F, $16; room 16 - 1110 1110 1110 1110 (shop)
db $EE, $EE, $0F, $17; room 17 - 1110 1110 1110 1110 

db $EE, $EE, $0F, $18; room 18 - 1110 1110 1110 1110 
db $FF, $FF, $0F, $19; room 19 - 1111 1111 1111 1111
db $FF, $FF, $0F, $1A; room 1A - 1111 1111 1111 1111 (same as 19)
db $86, $48, $0F, $1B; room 1B - 1000 0110 0100 1000

db $50, $50, $05, $1C; room 1C - 0101 0000 0101 0000
db $50, $50, $05, $1D; room 1D - 0101 0000 0101 0000 (same as 1C)
db $FF, $F8, $0F, $1E; room 1E - 1111 1111 1111 1000
db $FF, $F8, $0F, $1F; room 1F - 1111 1111 1111 1000

db $FF, $FF, $0F, $20; room 20 - 1111 1111 1111 1111
db $77, $78, $0F, $21; room 21 - 0111 0111 0111 1000 (21 - 25 are all the same)
db $00, $00, $00, $22; room 22 - 0111 0111 0111 1000 (21 - 25 are all the same, I don't want to use this one)
db $00, $00, $00, $23; room 23 - 0111 0111 0111 1000 (21 - 25 are all the same, I don't want to use this one)

db $00, $00, $00, $24; room 24 - 0111 0111 0111 1000 (21 - 25 are all the same, I don't want to use this one)
db $00, $00, $00, $25; room 25 - 0111 0111 0111 1000 (21 - 25 are all the same, I don't want to use this one)
db $F6, $6F, $0F, $26; room 26 - 1111 0110 0110 1111
db $F6, $6F, $0F, $27; room 27 - 1111 0110 0110 1111 (same as 26)

db $AA, $0A, $0B, $28; room 28 - 1010 1010 0000 1010 (hot springs)
db $FF, $FF, $0F, $29; room 29 - 1111 1111 1111 1111 (1-4 and 3-4 boss room)


originaldungeon:
; original code that we swiped
  LDA #$00                 
  STA $02                  
  LDA #$70                 
  STA $03                  
  LDX #$0F                 
  LDY #$00      
loop:  
  LDA ($00),Y              
  STA ($02),Y              
  INY                      
  BNE loop                
  INC $01                  
  INC $03                  
  DEX                      
  BNE loop                

; zero out the dungeon we copied
zerodungeon:
  LDA #$00
  LDY #$CF
cleardungeon:
  STA DUNGEON_START, Y
  DEY
  BNE cleardungeon
LDA #$00
STA PATH_IDX
STA ROOM_PATH_IDX
LDA #$FF
STA DEADEND_DETECTOR

LDA DUNGEON_SEED_LB
BEQ newseed
STA RNG_SEED
LDA DUNGEON_SEED_RB
BEQ newseed
STA RNG_SEED_RB
CLC
BCC newdungeon

newseed:
	; seed our rng
	LDA INITIAL_SEED_LB
	STA RNG_SEED
	STA DUNGEON_SEED_LB
	LDA INITIAL_SEED_RB
	STA RNG_SEED_RB
	STA DUNGEON_SEED_RB

newdungeon:
LDA FORTRESS_SIZE
STA ROOM_COUNT

; start room is 28th room, which is the 54th byte (0x36)
LDY #$36
STY ROOM_OFFSET

; room #01 is first room
LDA #$01
STA ROOM_ID

LDA #$07
STA EXIT_PATH_BYTE

storeroom:
LDY ROOM_OFFSET
LDA DUNGEON_START, Y	;if we already had a room then we skip counting it and just pick a new exit
BNE room_exists

LDA ROOM_ID
STA DUNGEON_START, Y
LDY ROOM_PATH_IDX
STA ROOM_PATH_START, Y
INC ROOM_PATH_IDX
DEC ROOM_COUNT
BNE newroom:
JMP placeboss			;if we've placed the right number of moves, we jump to placing the boss

room_exists:
; get the existing exits.  if we have other valid, non used exits we want to pick one of those
STA ROOM_ID
INY
LDA DUNGEON_START, Y
STA EXISTING_EXITS
JMP deadend_detect

newroom:
; main meet of the algorithm
; we've got the room for this offset stored in ROOM_ID
; and Y contains the memory offset (0-127, only the even numbers) to
; store the room at
LDA #$FF
STA DEADEND_DETECTOR

deadend_detect:
LDA DEADEND_DETECTOR
BNE populatevalidpaths	;if DEADEND_DETECTOR gets to 0 give up and start over
JMP placeboss	;for now just exit, i think we should retry if it's working


populatevalidpaths:
; After storing the room, we pick a direction to go
jsr getpathnibble
STA VALID_EXITS
; subtract the existing exits
LDA EXISTING_EXITS
AND VALID_EXITS
STA EXISTING_EXITS
LDA VALID_EXITS
SEC
SBC EXISTING_EXITS

pickexit:
; pick an exit
; this will set:
; NEED_EXIT_NEXT to the door that needs to be open in the next room
; NEXT_ROOM_OFFSET with the memory offset of the next room
; NEED_EXIT with the exit that the current room needs to support
DEC DEADEND_DETECTOR
BNE rngdir	;if DEADEND_DETECTOR gets to 0 give up and start over
JMP placeboss	;for now just exit, i think we should retry if it's working
rngdir:
jsr prng
CLC
AND #$03 				; trim to 0-3

up:
CMP #$00				; go up
BNE right
LDA #$04
STA NEED_EXIT_NEXT
LDX #$01
LDA ROOM_OFFSET
SEC
SBC #$10
BMI pickexit			; OOB
STA NEXT_ROOM_OFFSET
JMP checkroom

right:
CMP #$01				; go right
BNE down
LDA #$08
STA NEED_EXIT_NEXT
LDX #$02
LDA ROOM_OFFSET			; check if we're all the way to the right, which would be 0x_E
AND #$0E
CMP #$0E
BEQ pickexit			; TOO FAR! pick a new exit
LDA ROOM_OFFSET
CLC
ADC #$02
STA NEXT_ROOM_OFFSET
JMP checkroom

down:
CMP #$02				; go down
BNE left
LDA #$01
STA NEED_EXIT_NEXT
LDX #$04
LDA ROOM_OFFSET
CLC
ADC #$10
CMP #$80
BPL pickexit			;OOB
STA NEXT_ROOM_OFFSET
JMP checkroom

left:
LDA #$02
STA NEED_EXIT_NEXT
LDX #$08
LDA ROOM_OFFSET		; check if we're on the left
AND #$0F
BNE notoob_left		; zero flag will be set if the accumulator got set to 0, which means we're at the left wall
JMP pickexit
notoob_left:
LDA ROOM_OFFSET		; reload room offset to move left
SEC
SBC #$02
STA NEXT_ROOM_OFFSET

checkroom:
; check if we have open exits, and if we picked one
STX NEED_EXIT
LDY ROOM_OFFSET
INY
LDA DUNGEON_START, Y
AND VALID_EXITS

LDA VALID_EXITS
AND NEED_EXIT
BNE check_next_room
JMP pickexit	; no good pick a new one
; check if there's a room that way already
check_next_room:
LDY NEXT_ROOM_OFFSET
LDA DUNGEON_START, Y
BEQ storeexit			; no room skip this step

; if there is a room, check that it can have an exit that direction
; luckily the value of the room id is also the index, so we can 
; multiply it by 4, and add 2 to see if the exit is valid
ASL A
ASL A
CLC
ADC #$02
TAY
LDA FORTRESS_ROOMS_CONNECTIONS, Y
AND NEED_EXIT_NEXT
BNE storeexit
JMP pickexit	;no good, pick a new exit.  there should _always_ be at least 1 we can do

; place the exit and move there 
storeexit:
LDY ROOM_OFFSET		; prng clobbers y, we need to reset it
INY					; dungeon memory is byte pairs of rooms then exits
LDA NEED_EXIT
ORA DUNGEON_START, Y; combine exits
STA DUNGEON_START, Y; store exits
LDY NEXT_ROOM_OFFSET
INY
LDA NEED_EXIT_NEXT
ORA DUNGEON_START, Y
STA DUNGEON_START, Y

; set up for the next iteration
LDY PATH_IDX
LDA NEED_EXIT
STA PATH_START, Y
INC PATH_IDX
LDA NEXT_ROOM_OFFSET
STA ROOM_OFFSET
LDA NEXT_EXIT_PATH_BYTE
STA EXIT_PATH_BYTE

pickroom:
LDY NEXT_ROOM_OFFSET
LDA DUNGEON_START, Y
BNE got_a_room
jsr prng
AND #$3F
CMP #$29	; we have 29 possible rooms 0-29, but 29 is the boss room
BPL pickroom
STA ROOM_ID

; multiply by 4 since we have 4 bytes per room
ASL A
ASL A
; 2 more byte to get exits
CLC
ADC #$02
TAY
LDA FORTRESS_ROOMS_CONNECTIONS, Y
AND NEED_EXIT_NEXT
BEQ pickroom	; this room can't go that way, find a new one
got_a_room:
JMP storeroom

placeboss:
; find room with a single entrance, preferably on the left side (0x08)
; 64 rooms
LDA ROOM_OFFSET
TAY
LDA #$29
STA DUNGEON_START, Y
INY
LDA #$00
STA DUNGEON_START, Y

; fix boss music, this breaks stuff somehow?!?
DEY
TYA
LSR A
;STA FORT1_BOSS_IDX

jsr populateenemies
RTS

populateenemies:
	LDA #$40	;64 rooms
	STA ENEMY_PLACEMENT_IDX
	
	iterate_rooms:
	LDA ENEMY_PLACEMENT_IDX
	ASL A
	TAX
	LDA DUNGEON_START, X
	BEQ nextroom
	CMP #$01
	BEQ nextroom
	CMP #$15
	BEQ nextroom
	CMP #$16
	BEQ nextroom
	CMP #$28
	BEQ nextroom
	CMP #$07				; Spike room 07
	BNE spike09
	LDA #$51
	JMP storeenemy
	spike09:
	CMP #$09				; Spike room 09
	BNE spike13
	LDA #$52
	JMP storeenemy
	spike13:
	CMP #$13				; Spike room 13
	BNE spike1c
	LDA #$50
	JMP storeenemy
	spike1c:
	CMP #$1C				; Spike room 1C
	BNE spike20:
	LDA #$53
	JMP storeenemy
	spike20:
	CMP #$20				; Spike room 20
	BNE boosroom
	LDA #$52
	JMP storeenemy
	boosroom:
	CMP #$29				; Boss Room
	BNE pickenemy
	LDA #$F0
	JMP storeenemy
	
	; need to pick a random enemy	TODO: eggplant wizards
	pickenemy:
	JSR prng
	AND #$03				; random enemies are 0x1_, 0x2_, 0x3_, and 0x4_
	CLC
	ADC #$01
	ASL A
	ASL A
	ASL A
	ASL A
	; should now have 1-4 in the top nibble
	STA ENEMY_TEMP_STORAGE
	JSR prng
	AND #$07
	ORA ENEMY_TEMP_STORAGE
	INC ENEMY_TEMP_STORAGE
	
	storeenemy:
	LDY ENEMY_PLACEMENT_IDX
	STA ENEMY_START, Y
	
	nextroom:
	DEC ENEMY_PLACEMENT_IDX
	BNE iterate_rooms
	RTS
	

; getpathnibble
; returns the nibble for relevante path for room in ROOM_ID
; assuming you are coming from NEED_EXIT_NEXT
getpathnibble:
	LDA ROOM_ID
	ASL A
	ASL A
	TAY
	LDA NEED_EXIT_NEXT
	
	from_up:
	CMP #$01
	BNE from_right
	LDA FORTRESS_ROOMS_CONNECTIONS, Y
	AND #$F0
	LSR A
	LSR A
	LSR A
	LSR A
	rts
	
	from_right:
	CMP #$02
	BNE from_down
	LDA FORTRESS_ROOMS_CONNECTIONS, Y
	AND #$0F
	rts
		
	from_down:	
	INY
	CMP #$04
	BNE from_left:
	LDA FORTRESS_ROOMS_CONNECTIONS, Y
	AND #$F0
	LSR A
	LSR A
	LSR A
	LSR A
	rts
	
	from_left:
	LDA FORTRESS_ROOMS_CONNECTIONS, Y
	AND #$0F
	rts

; prng
;
; Returns a random 8-bit number in A (0-255), clobbers Y (0).
;
; Requires a 2-byte value on the zero page called "seed".
; Initialize seed to any value except 0 before the first call to prng.
; (A seed value of 0 will cause prng to always return 0.)
;
; This is a 16-bit Galois linear feedback shift register with polynomial $0039.
; The sequence of numbers it generates will repeat after 65535 calls.
;
; Execution time is an average of 125 cycles (excluding jsr and rts)	
; Returns a random 8-bit number in A (0-255), clobbers Y (unknown).
prng:
	lda RNG_SEED+1
	tay ; store copy of high byte
	; compute seed+1 ($39>>1 = %11100)
	lsr ; shift to consume zeroes on left...
	lsr
	lsr
	sta RNG_SEED+1 ; now recreate the remaining bits in reverse order... %111
	lsr
	eor RNG_SEED+1
	lsr
	eor RNG_SEED+1
	eor RNG_SEED+0 ; recombine with original low byte
	sta RNG_SEED+1
	; compute seed+0 ($39 = %111001)
	tya ; original high byte
	sta RNG_SEED+0
	asl
	eor RNG_SEED+0
	asl
	eor RNG_SEED+0
	asl
	asl
	asl
	eor RNG_SEED+0
	sta RNG_SEED+0
	rts
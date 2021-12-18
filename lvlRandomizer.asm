; different per world
PARAM_RULES_FP_LB			EQU $80
PARAM_RULES_FP_HB			EQU $81
PARAM_ITEM_LOCS_LB			EQU $82
PARAM_ITEM_LOCS_HB			EQU $83
PARAM_ENEMY_TABLE1_LB		EQU $84
PARAM_ENEMY_TABLE1_HB		EQU $85

;temp the same, not sure if I have room to do these different per world
ENEMY_TABLE_HB				equ #$FD

ROUTINE						equ	$F660

; these variables don't change per level
CURRENT_SCREEN		equ		$04D1
CURRENT_LEVEL		equ		$0130
CURRENT_WORLD		equ		$00A0
LVL_ITEM_DATA		equ		$FE00
LVL_START			equ		$6200
LVL_DOORS			equ		$6100
LVL_ITEM_COUNT		equ		$6140
LVL_ITEMS			equ		$6141
LVL_ENEMIES_T1		equ		$6180
LVL_ENEMIES_T2		equ		$61A0
LVL_MAX_ITEMS		equ		#$05
FIRST_ROOM			equ		#$29
FIRST_EXIT_OPTION	equ		#$26

DOOR_DISTRIBUTION equ   $FDD0

LVL_2_1_SIZE		equ		#$36
LVL_2_2_SIZE		equ		#$3C
LVL_2_3_SIZE		equ		#$3C

LVL_3_1_SIZE		equ		#$16
LVL_3_2_SIZE		equ		#$1C
LVL_3_3_SIZE		equ		#$20

; variables that are set per level
LVL_GEN_PARAM_SIZE	equ	$00C0 ; size of the level.  how many rooms to build

; variables that are used while we generate the level
POTENTIAL				equ		$00D0	; index of the next room we might use
CURRENT_SCREEN_ID		equ		$00D1	; the index of the last screen we wrote
SCREEN_RULES_LOCATION	equ		$00D2	; offset of the room connection rule byte we care about
SRL_WORK				equ		$00D3	; temporary variable used to shift to get the right bit
ROOM_BIT				equ		$00D4	; index of the bit we care about
SCREEN_RULE				equ		$00D5
SCREEN_ADDR				equ		$00D6
PREVIOUS_ROOM_IDX		equ		$00D7
TEMP_JUNK				equ		$00D8	; used withing some subroutines
DOOR_COUNT				equ		$00D9	; how many doors we've placed
ROOM_RULES_ADDRESS_PTR	equ		$00DA	; 2 bytes, word address of the rules we care about
										; needed because rooms take up more than 256 bytes
ROOM_LOCATION			equ		$00DC	; location in a room that we're placing something (door or item)
DOOR_CHOSEN				equ		$00DD	; which door (or item) we've chosen
DATA_OFFSET_CALC		equ		$00DE	; used when calculating the data offset for a room index

; RNG variables
INITIAL_SEED_LB		equ		$00EF
INITIAL_SEED_RB		equ		$00F0
RNG_SEED 			equ 	$0197
RNG_SEED_RB 		equ		$0198
Y_STORAGE 			equ		$0199	; used because prng clobbers Y, let's us store and load it if needed
STORE_SEED_LB		equ		$00B0
STORE_SEED_RB		equ		$00B1


org ROUTINE
	LDA CURRENT_SCREEN
	CMP #$00
	BNE loadNextScreen		;if we're not on the 0th screen, we've already generated it.
	JSR seedRNG
	JSR generateLevel
	JSR generateEnemies
	loadNextScreen:
	JSR writeRoomToLoadAddr	;writes the next room to the place that the game loads it
RTS

writeRoomToLoadAddr:
	LDA CURRENT_SCREEN
	STA POTENTIAL
	ASL POTENTIAL
	LDY POTENTIAL
	LDA LVL_START, Y
	STA $49
	INY
	LDA LVL_START, Y
	STA $4A
	RTS					; we only re-generate on the first screen
	
seedRNG:
	LDA INITIAL_SEED_LB
	BNE storerng_lb
	LDA #$BE
	storerng_lb:
	STA STORE_SEED_LB
	STA RNG_SEED
	
	LDA INITIAL_SEED_RB
	BNE storerng_rb
	LDA #$EF
	storerng_rb
	STA RNG_SEED_RB
	STA STORE_SEED_RB
	
	RTS

generateLevel:
	LDX #$00
	STX DOOR_COUNT
	STX LVL_ITEM_COUNT
	
	; write the first room
	LDA FIRST_ROOM
	CLC
	ADC CURRENT_LEVEL
	STA POTENTIAL
	STA PREVIOUS_ROOM_IDX
	JSR storeRoom

	; add rooms until we've hit the size
	moreRooms:
		JSR pickNextRoom
		JSR checkRoom
	BEQ moreRooms			;try again, didn't work
	JSR storeRoom
	JSR placeDoor
	JSR addItem
	CPX LVL_GEN_PARAM_SIZE
	BNE moreRooms
	JSR writeExit
	BEQ generateLevel	;try again
	JSR writeDoorClosure
	RTS

; generateEnemies is done after the level is generated
; and generates the 4 enemy tables (2 of enemies, 2 of positions)
; it distributes the enemies against the values in the ENEMY_TABLE1 and ENEMY_TABLE2
; blocks, which are 16 bytes each creating a distribution of those enemy values
generateEnemies:
	LDA ENEMY_TABLE_HB
	STA PARAM_ENEMY_TABLE1_HB

	LDA LVL_GEN_PARAM_SIZE
	LSR A
	TAX
	genEnemyLoop:
	; select T1 Enemy
	JSR prng
	AND #$0F
	TAY
	LDA (PARAM_ENEMY_TABLE1_LB), Y
	STA LVL_ENEMIES_T1, X
	
	; select T2 Enemy, it's always 0x10 more than table 1
	JSR prng
	AND #$0F
	CLC
	ADC #$10
	TAY
	LDA (PARAM_ENEMY_TABLE1_LB), Y
	STA LVL_ENEMIES_T2, X
	
	DEX
	BPL genEnemyLoop
	RTS

; Pre-reqs:
;
;		POTENTIAL contains the index of the room to place a door
;		Y contains the memory offset (2 bytes per room)
;		LVL_START contains the starting address of the level data
;		Updates Y to point to the next place to write
placeDoor:
	
	; prevent doors on screen 2 for various reasons
	; it results in the level being regenerated when you exit the room
	CPX #$04
	BNE maybeDoor
	RTS
	
	maybeDoor:
	JSR prng
	AND #$03
	CMP #$01
	BEQ checkNumDoors
	RTS
	
	checkNumDoors:
	LDA DOOR_COUNT
	CMP #$06
	BMI pickDoorToPlace
	RTS
	
	pickDoorToPlace:
	JSR pickADoor
	STA DOOR_CHOSEN
	
	LDA POTENTIAL
	STA DATA_OFFSET_CALC
	JSR convertDataOffsetCalcToDataOffset
	ADC #$05
	TAY
	LDA (ROOM_RULES_ADDRESS_PTR), Y	
	BNE putADoorHere
	RTS
	
	putADoorHere:
	STA ROOM_LOCATION
	;door data is 4 bytes each, stage, screen, coords, room type
	LDA DOOR_COUNT
	ASL A
	ASL A
	TAY
	
	LDA CURRENT_LEVEL
	STA LVL_DOORS, Y
	
	TXA
	ROR A
	SEC
	SBC #$01
	STA LVL_DOORS+1, Y
	
	LDA ROOM_LOCATION
	STA LVL_DOORS+2, Y
	
	LDA DOOR_CHOSEN
	STA LVL_DOORS+3, Y
	
	INC DOOR_COUNT
	
	RTS
	
; todo: this needs different logic per world
pickADoor:
	JSR prng
	AND #$0F

	LDY CURRENT_WORLD
	CPY #$02	
	BEQ loadDoorFromDistribution
	
	CLC
	ADC #$10
	CPY #$04	
	BEQ loadDoorFromDistribution
	
	CLC
	ADC #$10

	loadDoorFromDistribution:
	TAY
	LDA DOOR_DISTRIBUTION, Y
	
	RTS

addItem:

	LDA LVL_ITEM_COUNT
	CMP LVL_MAX_ITEMS
	BCC notatmaxitems
	RTS
	
	notatmaxitems:
	JSR prng
	AND #$07
	CMP #$01
	BEQ pickItem
	RTS
	
	pickItem:
	JSR prng
	AND #$01
	STA DOOR_CHOSEN	;yeah this is for doors, but we'll use it here
	
	LDA POTENTIAL
	SEC
	SBC #$01
	TAY
	LDA (PARAM_ITEM_LOCS_LB), Y
	STA ROOM_LOCATION
	
	LDA LVL_ITEM_COUNT
	ASL A
	ASL A
	TAY
	
	LDA CURRENT_LEVEL
	STA LVL_ITEMS, Y
	
	TXA
	ROR A
	SEC
	SBC #$01
	STA LVL_ITEMS+1, Y
	
	LDA ROOM_LOCATION
	STA LVL_ITEMS+2, Y
	
	LDA DOOR_CHOSEN
	STA LVL_ITEMS+3, Y
	
	INC LVL_ITEM_COUNT
	RTS

writeDoorClosure:
	LDA DOOR_COUNT
	ASL A
	ASL A
	TAY
	LDA #$FF
	STA LVL_DOORS, Y
	STA LVL_DOORS + 1, Y
	STA LVL_DOORS + 2, Y
	STA LVL_DOORS + 3, Y
	RTS

convertDataOffsetCalcToDataOffset:
	LDA PARAM_RULES_FP_LB
	STA ROOM_RULES_ADDRESS_PTR
	LDA PARAM_RULES_FP_HB
	STA ROOM_RULES_ADDRESS_PTR + 1
	LDA DATA_OFFSET_CALC
	SEC
	SBC #$01
	ASL A
	ASL A
	ASL A
	
	BCC exitConvert
	INC ROOM_RULES_ADDRESS_PTR + 1
	CLC
	
	exitConvert:
	; SRL_WORK now contains the index of the first byte of rules for our current room
	RTS

pickNextRoom:
	; pick a random new screen
	JSR prng
	AND #$1F
	STA POTENTIAL
	INC POTENTIAL
	RTS

; checkRoom - compares rules of PREVIOUS_ROOM_IDX with POTENTIAL.  A > 0 means it works
checkRoom:
	LDA PREVIOUS_ROOM_IDX
	STA DATA_OFFSET_CALC
	JSR convertDataOffsetCalcToDataOffset
	
	; SRL_WORK now contains the index of the first byte of rules for our current room
	STA SRL_WORK
	
	; figure out which byte and bit of rules we want
	LDA POTENTIAL
	getroomrulebitindex:
		CMP #$08
		BPL moveToNextRuleBit
		JMP setindex
		moveToNextRuleBit:
		INC SRL_WORK
		SEC
		SBC #$08
		JMP getroomrulebitindex

	setindex:
		; now that we have the offset stored in SRL_WORK
		; get the right rule byte and store it
		STA ROOM_BIT 
		LDY SRL_WORK
		LDA (ROOM_RULES_ADDRESS_PTR), Y
		STA SCREEN_RULE

		LDA #$80
		
	bitcheck_loop:
		DEC ROOM_BIT
		BEQ compareroom 
		ROR A				; shift accumulator bit over
		BNE bitcheck_loop

	compareroom:

		AND SCREEN_RULE

	RTS

; writeExit - writes our exit room for the level
;	returns a 0 accumulator if the exit was bad and we need to restart
; 
writeExit:
	LDA FIRST_EXIT_OPTION
	STA POTENTIAL
	JSR checkRoom
	BNE goodExit
	
	INC POTENTIAL
	JSR checkRoom
	BNE goodExit
	
	INC POTENTIAL
	JSR checkRoom
	BNE goodExit
	
	; last chance so if this isn't good remake the whole level
	RTS
	
	goodExit:
	JSR storeRoom
	; store FF FF in the last spot (fake room 0x26)
	LDA #$2C
	STA POTENTIAL
	JSR storeRoom
	RTS


; Pre-reqs:
;
;		POTENTIAL contains the index of the room to store (0 - 31)
;		Y contains the memory offset (2 bytes per room)
;		LVL_START contains the starting address of the level data
;		Updates Y to point to the next place to write
storeRoom:
	LDA POTENTIAL
	STA DATA_OFFSET_CALC
	STA PREVIOUS_ROOM_IDX
	JSR convertDataOffsetCalcToDataOffset
	getFirstRoomAddressByte:
	ADC #$06
	TAY
	LDA (ROOM_RULES_ADDRESS_PTR), Y
	STA LVL_START, X
	INX
	INY
	LDA (ROOM_RULES_ADDRESS_PTR), Y
	STA LVL_START, X
	INX
	
	RTS

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
RULES_DATA			equ		$F900
ROUTINE				equ		$F700
CURRENT_SCREEN		equ		$04D1
CURRENT_LEVEL		equ		$0130
SCREEN_ADDR_DB		equ		RULES_DATA + 35 + 35 + 35 + 35
STAGE_LENGTH		equ		#$1B

; generation variables
LVL_GEN_PARAM_SIZE			equ	$00C0 ; size of the level.  how many rooms to build


; our variables
POTENTIAL				equ		$00D0
CURRENT_SCREEN_ID		equ		$00D1
SCREEN_RULES_LOCATION	equ		$00D2
SRL_WORK				equ		$00D3
ROOM_BIT				equ		$00D4
SCREEN_RULE				equ		$00D5
SCREEN_ADDR				equ		$00D6
PREVIOUS_ROOM_IDX		equ		$00D7
TEMP_JUNK				equ		$00D8

INITIAL_SEED_LB		equ		$00EF
INITIAL_SEED_RB		equ		$00F0
RNG_SEED 			equ 	$0197
RNG_SEED_RB 		equ		$0198
Y_STORAGE 			equ		$0199
STORE_SEED_LB		equ		$00B0
STORE_SEED_RB		equ		$00B1

LVL_START		equ		$7100
LVL_ENEMIES_T1	equ		$7180
LVL_ENEMIES_T2	equ		$71A0

ENEMY_TABLE1	equ		$FD00
ENEMY_TABLE2	equ		$FD10


LVL_2_1_SIZE		equ		#$36 ; 0x1B * 2 bytes
LVL_2_2_SIZE		equ		#$3C ; 0x1B * 2 bytes
LVL_2_3_SIZE		equ		#$3C ; 0x1B * 2 bytes

org ROUTINE
LDA CURRENT_SCREEN
CMP #$00
BNE loadNextScreen
JSR seedRNG
JSR generateLevel2
JSR generateEnemies
loadNextScreen:
JSR writeRoomToLoadAddr
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
	INY
	RTS					; we only re-generate on the first screen
	
seedRNG:
; seed our rng on the first screen of the first level
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

generateLevel2:
	LDA LVL_2_1_SIZE
	STA LVL_GEN_PARAM_SIZE
	LDY #$00
	LDX CURRENT_LEVEL
	BEQ writeFirstRoom
	; assume 2-2
	LDA LVL_2_2_SIZE
	STA LVL_GEN_PARAM_SIZE
	DEX
	BEQ writeFirstRoom
	;2-3
	LDA LVL_2_3_SIZE
	STA LVL_GEN_PARAM_SIZE

	writeFirstRoom:
	; write the first room
	LDA #$20
	CLC
	ADC CURRENT_LEVEL ; 20 for 2-1, 21 for 2-2, 22 for 2-3
	STA POTENTIAL
	STA PREVIOUS_ROOM_IDX
	JSR storeRoom

	moreRooms:
		JSR pickNextRoom
		JSR checkRoom
	BEQ moreRooms			;try again, didn't work
	JSR storeRoom
	JSR placeDoor
	CPY LVL_GEN_PARAM_SIZE
	BNE moreRooms
	JSR writeExit
	RTS

generateEnemies:
	LDA LVL_GEN_PARAM_SIZE
	LSR A
	TAX
	genEnemyLoop:
	; select T1 Enemy
	JSR prng
	AND #$0F
	TAY
	LDA ENEMY_TABLE1, Y
	STA LVL_ENEMIES_T1, X
	
	; select T2 Enemy
	JSR prng
	AND #$0F
	TAY
	LDA ENEMY_TABLE2, Y
	STA LVL_ENEMIES_T2, X
	
	; decrement twice because Size is 2 times number of screens
	DEX
	BPL genEnemyLoop
	RTS

placeDoor:
	;NYI
	RTS

pickNextRoom:
	; pick a random new screen
	STY Y_STORAGE
	JSR prng
	LDY Y_STORAGE
	AND #$1F
	STA POTENTIAL
	INC POTENTIAL

; checkRoom - compares rules of PREVIOUS_ROOM_IDX with POTENTIAL.  A > 0 means it works
checkRoom:
	LDA PREVIOUS_ROOM_IDX
	STA SRL_WORK
	DEC SRL_WORK
	ASL SRL_WORK
	ASL SRL_WORK
	; SRL_WORK now contains the index of the first byte of rules for our current room
	STA SRL_WORK
	
	; figure out which byte and bit of rules we want
	LDA POTENTIAL
	getroomrulebitindex:
		CMP #$08
		BMI setindex
		INC SRL_WORK
		SBC #$08
		JMP getroomrulebitindex

	setindex:
		; now that we have the offset stored in SRL_WORK
		; get the right rule byte and store it
		STA ROOM_BIT 
		LDX SRL_WORK
		LDA RULES_DATA,X
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

; writeExit - writes our exit room for the level 0x24, 0x25, and 0x26 for 2-1, 2-2, and 2-3
writeExit:
	LDA #$23
	CLC
	ADC CURRENT_LEVEL
	STA POTENTIAL
	JSR storeRoom
	; store FF FF in the last spot (fake room 0x26
	LDA #$26
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
	STA PREVIOUS_ROOM_IDX
	ASL A
	TAX
	LDA SCREEN_ADDR_DB, X
	STA LVL_START, Y
	INX
	INY
	LDA SCREEN_ADDR_DB, X
	STA LVL_START, Y
	INY
	
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
;; these variables don't change per level
CURRENT_SCREEN		equ		$04D1
POTENTIAL			equ		$00D0	; index of the next room we will use

LVL_START			equ		$6200
LVL_ENEMIES_T1		equ		$6180
LVL_ENEMIES_T2		equ		$61A0
FIRST_ROOM			equ		#$00
LVL_SIZE            equ     #$1C

W4_SCREENS          equ     $FE80
W4_ENEMIES          equ     $FE94
ROUTINE             equ     $FEA0

; enemies
ENEMY_TOTEM     equ     #$04
ENEMY_MOILA     equ     #$06
ENEMY_SYREN     equ     #$08
ENEMY_DAPHNE    equ    #$0A
ENEMY_ZUREE     equ     #$07
ENEMY_ERINUS    equ    #$09

; RNG variables
INITIAL_SEED_LB		equ		$00EF
INITIAL_SEED_RB		equ		$00F0
RNG_SEED 			equ 	$0197
RNG_SEED_RB 		equ		$0198
Y_STORAGE 			equ		$0199	; used because prng clobbers Y, let's us store and load it if needed
STORE_SEED_LB		equ		$00B0
STORE_SEED_RB		equ		$00B1


org W4_SCREENS
db $ee, $ba
db $1e, $bb
db $51, $bb
db $51, $bb
db $78, $bb
db $78, $bb
db $ab, $bb
db $7c, $ba
db $af, $ba
db $ff, $ff ; End of Level room

; W4_ENEMIES
db ENEMY_TOTEM, ENEMY_TOTEM, ENEMY_TOTEM, ENEMY_TOTEM
db ENEMY_MOILA, ENEMY_MOILA, ENEMY_MOILA, ENEMY_MOILA 
db ENEMY_SYREN, ENEMY_SYREN, ENEMY_SYREN, ENEMY_SYREN  
db ENEMY_DAPHNE, ENEMY_DAPHNE
db ENEMY_ZUREE, ENEMY_ZUREE

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
	RTS					; we only re-generate on the first screen
	
seedRNG:
	LDA STORE_SEED_LB
	BNE storerng_lb
	LDA #$BE
	storerng_lb:
	STA STORE_SEED_LB
	STA RNG_SEED
	
	LDA STORE_SEED_RB
	BNE storerng_rb
	LDA #$EF
	storerng_rb
	STA RNG_SEED + 1
	STA STORE_SEED_RB
	
	RTS

generateLevel:
	LDX #$00
	; write the first room
	LDA FIRST_ROOM
	STA POTENTIAL
	JSR storeRoom

	; add rooms until we've hit the size
	moreRooms:
		JSR pickNextRoom
	    JSR storeRoom
	CPX LVL_SIZE
	BNE moreRooms
	JSR writeExit
	RTS

; generateEnemies is done after the level is generated
; and generates the 4 enemy tables (2 of enemies, 2 of positions)
; it distributes the enemies against the values in the ENEMY_TABLE1 and ENEMY_TABLE2
; blocks, which are 16 bytes each creating a distribution of those enemy values
generateEnemies:
	
	genEnemyLoop:
	; select T1 Enemy
	JSR prng
	AND #$0F
	TAY
	LDA W4_ENEMIES, Y
	STA LVL_ENEMIES_T1, X
	
	; select T2 Enemy, it's always Erinus.  we'll have one 50% of the time
	JSR prng
    AND #$01
    CMP #$00
    BEQ storeErinus
    LDA ENEMY_ERINUS

    storeErinus:
	STA LVL_ENEMIES_T2, X
	
	DEX
	BPL genEnemyLoop
	RTS

pickNextRoom:
	; pick a random new screen
	JSR prng
	AND #$07
	STA POTENTIAL
	RTS

; writeExit - writes our exit room for the level
;	returns a 0 accumulator if the exit was bad and we need to restart
; 
writeExit:
	; store FF FF in the last spot (fake room index 8)
	LDA #$08
	STA POTENTIAL
	JSR storeRoom

    LDA #$09
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
	ASL A	
	TAY
	LDA (W4_SCREENS), Y
	STA LVL_START, X
    INX
	LDA (W4_SCREENS + 1), Y
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


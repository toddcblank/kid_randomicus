; these are memory address we need to use
; Kid Icarus locations that we don't want to change
LVL_1_1_START		equ		$7C1A

LVL_1_1_START_HB 	equ 	#$7C ; memory address where lvl 1-1 data is written
LVL_1_1_START_LB 	equ 	#$1A ; memory address where lvl 1-1 data is written
LVL_1_2_START_HB	equ		#$7C ; memory address where lvl 1-2 data is written
LVL_1_2_START_LB	equ		#$34 ; memory address where lvl 1-2 data is written
LVL_1_3_START_HB	equ		#$7C ; memory address where lvl 1-3 data is written
LVL_1_3_START_LB	equ		#$52 ; memory address where lvl 1-3 data is written

LVL_3_1_START_HB	equ		#$77
LVL_3_1_START_LB	equ		#$55
LVL_3_2_START_HB	equ		#$77
LVL_3_2_START_LB	equ		#$6D
LVL_3_3_START_HB	equ		#$77
LVL_3_3_START_LB	equ		#$8B

DOOR_PATCH_LOC		equ		#$6100; we actually move the data there, hope it works!

; zero page variables that we use
CUR_ROOM  			equ		$0191
POTENTIAL 			equ		$0192
ROOM_INDEX 			equ		$0193 ; not used LUL
ROOM_RULE 			equ   	$0194
ROOM_RULES_OFFSET 	equ 	$0195
ROOM_BIT 			equ		$0196 ; this is the value 0-7 for which bit we care about in the rule
RNG_SEED 			equ 	$0197
RNG_SEED_RB 		equ		$0198
Y_STORAGE 			equ		$0199
RRO_WORK			equ		$019A ; holds the original room rules offset, which we need to save
STORE_SEED_LB		equ		$00B0
STORE_SEED_RB		equ		$00B1
LEVEL_INDEX			equ		$00A0

; Level Gen SubRoutine Params
LVL_GEN_PARAM_SIZE			equ	$00C0 ; size of the level.  how many rooms to build
LVL_GEN_END_ROOM_ADDR_PARAM	equ	$00C2 ; the address of the end room for the level.  we hardcode it for highest likelyhood
LVL_GEN_START_ADDR_PARAM	equ	$00C4 ; where we should start writing the data for the level
LVL_START_ROOM_IDX_PARAM	equ	$00C6
IDX_OFFSET_PARAM			equ	$00C8
IDX_OFFSET_MAX_PARAM		equ	$00CA
DOOR_COUNT					equ	$00CC
CURR_LEVEL					equ	$00CE

ENEMY_VALUES				equ	$0090


; ROOM_RULES_DATA is the start of our .bin, everything else that we
; reference should be offset from it based on the size of the data
CODE_START_LOC		equ		$B9F0
ROOM_RULES_DATA 	equ		$FA00
ROOM_ADDRESSES 		equ		ROOM_RULES_DATA + 196; $BE84 ; this is the first byte of the address.  add 2 per room to get the room
DOOR_DATA			equ		ROOM_ADDRESSES + 98
LVL_1_1_SIZE 		equ		#$15
LVL_1_2_SIZE		equ		#$19
LVL_1_3_SIZE		equ		#$25

LVL_3_1_SIZE 		equ		#$14
LVL_3_2_SIZE		equ		#$18
LVL_3_3_SIZE		equ		#$1E

FRAME_COUNT 			equ		$0014
INITIAL_SEED_LB			equ		$00EF
INITIAL_SEED_RB			equ		$00F0
END_ROOM_LVL_1			equ		#$39 ; Room 32, it has the highest likelyhood of allowing access
END_ROOM_LVL_1HB		equ		#$70 ; high order byte of Room 32
END_ROOM_LVL_3			equ		#$2D ; Room 14, it has the highest likelyhood of allowing access
END_ROOM_LVL_3HB		equ		#$70 ; high order byte of Room 14 in world 3
END_ROOM_BACKUP_LVL_3	equ		#$00 ; Room 13, it works for the 1 room that doesn't work for 14
END_ROOM_BACKUP_LVL_3HB	equ		#$70 ; high order byte of Room 15 in world 3
LVL_1_START_ROOM		equ		#$21
LVL_3_START_ROOM		equ		#$2D

ENEMY_TABLE1_W1			equ		$7CD6
ENEMY_TABLE2_W1			equ		$7D0B
ENEMY_TABLE3_W1			equ		$7D40
ENEMY_TABLE4_W1			equ		$7D75

ENEMY_TABLE1_W3			equ		$77E7
ENEMY_TABLE2_W3			equ		$7821
ENEMY_TABLE3_W3			equ		$785B
ENEMY_TABLE4_W3			equ		$7895

ENEMY_NONE          equ #$00      ;empty

ENEMY_SHEMUN        equ #$02      ;snakes
ENEMY_MCGOO         equ #$03      ;slime
ENEMY_NETTLER       equ #$05      ;frogs
ENEMY_MONOEYE       equ #$08      ;medium flying enemy
ENEMY_COMMYLOOSE    equ #$0A      ;octopus
ENEMY_REAPER        equ #$0D      ;reaper

ENEMY_HOLER			equ #$03;     ;Slime
ENEMY_KOMAYTO		equ #$08;     ;Metroid <3
ENEMY_PLUTONFLY		equ #$07;     ;Pluton Fly (thief)
ENEMY_OCTOS			equ #$0A;     ;Octopus
ENEMY_COLLIN		equ #$0B;     ;Patra
ENEMY_KEEPAH		equ #$0C;     ;Ridley (this messes up some stuff, and shouldn't be used =/)

org CODE_START_LOC
original:
  LDA $9907,X              
  STA $00                  
  LDA $9908,X              
  STA $01                  
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

	; seed our rng
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
	
generateRandomVerticalWorld:
LDA #$00
STA CURR_LEVEL
STA DOOR_COUNT
LDA LEVEL_INDEX
CMP #$06
BEQ genLevelThree
; world 1 start
LDA LVL_1_START_ROOM
STA LVL_START_ROOM_IDX_PARAM
LDA #$01
STA IDX_OFFSET_PARAM
LDA #$1F
STA IDX_OFFSET_MAX_PARAM
LDA END_ROOM_LVL_1
STA LVL_GEN_END_ROOM_ADDR_PARAM
LDA END_ROOM_LVL_1HB
STA LVL_GEN_END_ROOM_ADDR_PARAM+1

; load lvl 1-1 vars
LDA LVL_1_1_SIZE
STA LVL_GEN_PARAM_SIZE
LDA LVL_1_1_START_LB
STA LVL_GEN_START_ADDR_PARAM
LDA LVL_1_1_START_HB
STA LVL_GEN_START_ADDR_PARAM+1
JSR generateRandomVerticalLevel
INC CURR_LEVEL

; load lvl 1-2 vars
LDA LVL_1_2_SIZE
STA LVL_GEN_PARAM_SIZE
LDA LVL_1_2_START_LB
STA LVL_GEN_START_ADDR_PARAM
LDA LVL_1_2_START_HB
STA LVL_GEN_START_ADDR_PARAM+1
JSR generateRandomVerticalLevel
INC CURR_LEVEL

; load lvl 1-3 vars
LDA LVL_1_3_SIZE
STA LVL_GEN_PARAM_SIZE
LDA LVL_1_3_START_LB
STA LVL_GEN_START_ADDR_PARAM
LDA LVL_1_3_START_HB
STA LVL_GEN_START_ADDR_PARAM+1
JSR generateRandomVerticalLevel
RTS

genLevelThree:
LDA #$22
STA IDX_OFFSET_PARAM
LDA #$0F
STA IDX_OFFSET_MAX_PARAM
LDA END_ROOM_LVL_3
STA LVL_GEN_END_ROOM_ADDR_PARAM
LDA END_ROOM_LVL_3HB
STA LVL_GEN_END_ROOM_ADDR_PARAM+1
LDA LVL_3_START_ROOM
STA LVL_START_ROOM_IDX_PARAM

;load lvl 3-1 vars
LDA LVL_3_1_SIZE
STA LVL_GEN_PARAM_SIZE
LDA LVL_3_1_START_LB
STA LVL_GEN_START_ADDR_PARAM
LDA LVL_3_1_START_HB
STA LVL_GEN_START_ADDR_PARAM+1
JSR generateRandomVerticalLevel
INC CURR_LEVEL

LDA LVL_3_2_SIZE
STA LVL_GEN_PARAM_SIZE
LDA LVL_3_2_START_LB
STA LVL_GEN_START_ADDR_PARAM
LDA LVL_3_2_START_HB
STA LVL_GEN_START_ADDR_PARAM+1
JSR generateRandomVerticalLevel
INC CURR_LEVEL

LDA LVL_3_3_SIZE
STA LVL_GEN_PARAM_SIZE
LDA LVL_3_3_START_LB
STA LVL_GEN_START_ADDR_PARAM
LDA LVL_3_3_START_HB
STA LVL_GEN_START_ADDR_PARAM+1
JSR generateRandomVerticalLevel
RTS

generateRandomVerticalLevel:
	; Y will be the room index
	LDY #$00

	; always start in room 33
	LDA LVL_START_ROOM_IDX_PARAM
	STA POTENTIAL
	
buildlevel:
	;store the successful potential room in the start + room index	
	LDA POTENTIAL
	
	STA ROOM_RULES_OFFSET
	DEC ROOM_RULES_OFFSET
	ASL ROOM_RULES_OFFSET
	ASL ROOM_RULES_OFFSET
	
	; shift to the left to multiply by 2 for room address index
	ASL A
	TAX
	LDA ROOM_ADDRESSES, X 
	STA (LVL_GEN_START_ADDR_PARAM),Y
	INX
	INY
	LDA ROOM_ADDRESSES, X 
	STA (LVL_GEN_START_ADDR_PARAM), Y
	INY	
	CPY LVL_GEN_PARAM_SIZE	; if > SIZE we're done
	BCC placedoor:
	JMP writeexit
	
placedoor:
	; let's see if we should put a door here
	STY Y_STORAGE
	JSR prng
	AND #$03
	CMP #$03
	BNE chooseroom ; no door move on

	; door data is stage [0,1,2] screen [0-stage length], coords [0x00 - 0xFF], room [0x20-27]
	LDA DOOR_COUNT
	CMP #$08
	BPL chooseroom ; we already have the doors

	; x4 to get address offset
	ASL A
	ASL A
	TAX
;	
	LDA CURR_LEVEL
	STA DOOR_PATCH_LOC, X
;	
	INX
	LDA Y_STORAGE
	STA DOOR_PATCH_LOC, X
	LSR DOOR_PATCH_LOC, X	;divide by 2 since Y assumes 2 bytes and we want pure index
	DEC DOOR_PATCH_LOC, X	; subtract 1, since we're 1 too high after writing the room we're working with
;	
	INX
	LDA POTENTIAL
	TAY
	INY
	LDA DOOR_DATA, Y
	BEQ chooseroom			;skip writing the rest if this room can't have a door
	STA DOOR_PATCH_LOC, X
;	
	INX
	pickadoor:
	JSR prng	
	AND #$07
	CLC
	ADC #$20
	LDY LEVEL_INDEX
	
	CMP #$20
	BNE handleDoor21
	; for 20 we're ok in w1 but not w3
	CPY #$02
	BNE pickadoor
	JMP storedoorvalue
	
	handleDoor21:
	CMP #$21
	BNE handleDoor27
	CLC
	ADC #$03
	JMP storedoorvalue
	
	handleDoor27:
	CMP #$27
	; for 27 we're ok in w3, but not w1
	BNE storedoorvalue
	CPY #$06
	BNE pickadoor
	
	storedoorvalue:
	STA DOOR_PATCH_LOC, X
	INC DOOR_COUNT
	
chooseroom:
	LDA ROOM_RULES_OFFSET
	STA RRO_WORK
	JSR prng
	AND IDX_OFFSET_MAX_PARAM ; trim to 0-31 or 0-15
	CLC
	STA ROOM_BIT
	ADC IDX_OFFSET_PARAM ; add 1 or 33 so it's 1 - 32 or 33 - 49
	CLC
	LDY Y_STORAGE
	
	STA POTENTIAL

	; room rules are sets of 8 bits, so we need to find
	; the right 8 bits by subtracting 8 until we're under 8
	; and shifting right in our room rules
	INC ROOM_BIT
	LDA ROOM_BIT
getroomrule:
	CMP #$08	
	BMI setindex
	INC RRO_WORK
	SBC #$08
	JMP getroomrule
	
setindex:
	; now that we have the offset stored in RRO_WORK
	; get the right rule byte and store it
	STA ROOM_BIT 
	LDX RRO_WORK
	LDA ROOM_RULES_DATA,X
	STA ROOM_RULE

	LDA #$80
bitcheck_loop:
	DEC ROOM_BIT
	BEQ compareroom 
	ROR A				; shift accumulator bit over
	BNE bitcheck_loop

	; Accumulator now houses the value to AND in the compare room

compareroom:
	AND ROOM_RULE
	BEQ chooseroom  ; no match, pick a new room
	JMP buildlevel	; match was good, build the level
	
writeexit:
	; ensure that if we're at the end, that this room connects to the end
	; for now we're always exiting from room 30.  30's available come-from 
	; rooms are 
	; bytes for rooms that work are:
	; 65 6E 64 48
	;	0110 0101 ; 1 - 8
	;	0110 1110 ; 9 - 16
	;	0110 0100 ; 17 - 24
	;	0100 1000 ; 25 - 27, 34 - 38
	LDA LEVEL_INDEX
	CMP #$06
	BNE lvl1exit
	LDA POTENTIAL
	CMP #$2C
	BEQ backupLvl3Room
	LDA END_ROOM_LVL_3
	STA LVL_GEN_END_ROOM_ADDR_PARAM
	LDA END_ROOM_LVL_3HB
	STA LVL_GEN_END_ROOM_ADDR_PARAM + 1
	JMP writeexitaddress
	
	backupLvl3Room:
	LDA END_ROOM_BACKUP_LVL_3
	STA LVL_GEN_END_ROOM_ADDR_PARAM
	LDA END_ROOM_BACKUP_LVL_3HB
	STA LVL_GEN_END_ROOM_ADDR_PARAM + 1
	JMP writeexitaddress
	
	lvl1exit:
	LDA POTENTIAL
	LDX #$65
	
getexitrule:

	; if this is world 3 then every room except 0x0b works.
	
	CMP #$08
	BMI bitcheck_exit
	
	LDX #$6E
	SBC #$08
	CMP #$08
	BMI bitcheck_exit
	
	LDX #$64
	SBC #$08
	CMP #$08
	BMI bitcheck_exit
	
	; this is the last option no need to compare
	LDX #$48	
	SBC #$08
	
bitcheck_exit:
	STX ROOM_RULE
	STA ROOM_BIT
	LDA #$80 
	CLC

bitcheck_loop_exit:
	DEC ROOM_BIT
	BEQ compareexit
	ROR A				; shift accumulator bit over
	BNE bitcheck_loop_exit
	
compareexit:
	; if ROOMRULE & the Accumulator are 0 then this exit doesn't work with this room
	; and we need to start all over
	AND ROOM_RULE
	BNE writeexitaddress
	LDA #$00
	STA DOOR_COUNT
	JMP generateRandomVerticalLevel
	
writeexitaddress:
	; write the exit room
	LDA LVL_GEN_END_ROOM_ADDR_PARAM
	STA (LVL_GEN_START_ADDR_PARAM), Y
	LDA LVL_GEN_END_ROOM_ADDR_PARAM+1
	INY
	STA (LVL_GEN_START_ADDR_PARAM), Y
	
	; need to close off the exits too
 	; x4 to get address offset
	LDA CURR_LEVEL
	CMP #$02
	BNE exiting
	LDA DOOR_COUNT
	ASL A
	ASL A
	TAX
	LDA #$FF
	STA DOOR_PATCH_LOC, X
	INX
	STA DOOR_PATCH_LOC, X
	INX
	STA DOOR_PATCH_LOC, X
	INX
	STA DOOR_PATCH_LOC, X
	exiting:
	LDA LEVEL_INDEX
	
	;enemies, I could probably do this more effeciently but for now should be fine
	CMP #$06
	BNE w1enemies
	
	w3enemies:	
	JSR randomizeEnemiesW3
	RTS
	
	w1enemies:
	JSR randomizeEnemiesW1
	RTS 			; we're done here

randomizeEnemiesW1:

	table1_w1:
	LDX #$2E
	LDY #$00
	; set up possible enemies for first table, we use 16 bytes for possible enemies to control RNG
	LDA ENEMY_NETTLER
	STA ENEMY_VALUES
	STA ENEMY_VALUES + 1
	
	LDA ENEMY_MONOEYE
	STA ENEMY_VALUES + 2
	STA ENEMY_VALUES + 3
	STA ENEMY_VALUES + 4
	STA ENEMY_VALUES + 5
	
	LDA ENEMY_COMMYLOOSE
	STA ENEMY_VALUES + 6
	STA ENEMY_VALUES + 7
	STA ENEMY_VALUES + 8
	STA ENEMY_VALUES + 9
	STA ENEMY_VALUES + 10
	STA ENEMY_VALUES + 11
	
	LDA ENEMY_NONE
	STA ENEMY_VALUES + 12
	STA ENEMY_VALUES + 13
	
	LDA ENEMY_REAPER
	STA ENEMY_VALUES + 14
	STA ENEMY_VALUES + 15

	fillEnemies:
	JSR pickEnemyRoutine
	STA ENEMY_TABLE1_W1, X
	CMP ENEMY_REAPER
	BEQ reaperCoords
	LDA #$00
	STA ENEMY_TABLE2_W1, X
	BEQ nextloop
	
	reaperCoords:
	JSR prng
	AND #$07
	ADC #$40
	CLC
	STA ENEMY_TABLE2_W1, X
	
	nextloop:
	DEX
	BNE fillEnemies
	
	; 2nd table
	LDX #$2E
	LDY #$00
	; set up possible enemies for second table, we use 16 bytes for possible enemies to control RNG
	LDA ENEMY_MCGOO
	STA ENEMY_VALUES
	STA ENEMY_VALUES + 1
	STA ENEMY_VALUES + 2
	STA ENEMY_VALUES + 3
	STA ENEMY_VALUES + 4
	
	LDA ENEMY_SHEMUN
	STA ENEMY_VALUES + 5
	STA ENEMY_VALUES + 6
	STA ENEMY_VALUES + 7
	STA ENEMY_VALUES + 8
	STA ENEMY_VALUES + 9
	STA ENEMY_VALUES + 10
	
	LDA ENEMY_NONE
	STA ENEMY_VALUES + 11
	STA ENEMY_VALUES + 12
	STA ENEMY_VALUES + 13
	
	LDA ENEMY_REAPER
	STA ENEMY_VALUES + 14
	STA	ENEMY_VALUES + 15
	
	pickEnemy2:
	; set up possible enemies for second table, we use 16 bytes for possible enemies to control RNG
	JSR pickEnemyRoutine
	STA ENEMY_TABLE3_W1, X
	CMP ENEMY_REAPER
	BEQ reaperCoords2
	LDA #$00
	STA ENEMY_TABLE4_W1, X
	BEQ nextScreen
	
	reaperCoords2:
	JSR prng
	AND #$07
	ADC #$C0
	CLC
	STA ENEMY_TABLE4_W1, X
	
	nextScreen:
	DEX
	BNE pickEnemy2
	RTS
	
randomizeEnemiesW3:
	LDX #$33
	
	LDA ENEMY_PLUTONFLY
	STA ENEMY_VALUES
	STA ENEMY_VALUES + 1
	
	LDA ENEMY_OCTOS
	STA ENEMY_VALUES + 2
	STA ENEMY_VALUES + 3
	STA ENEMY_VALUES + 4
	STA ENEMY_VALUES + 5

	LDA ENEMY_KOMAYTO
	STA ENEMY_VALUES + 6
	STA ENEMY_VALUES + 7
	STA ENEMY_VALUES + 8
	
	LDA ENEMY_COLLIN
	STA ENEMY_VALUES + 9
	STA ENEMY_VALUES + 10
	STA ENEMY_VALUES + 11
	
	LDA ENEMY_NONE
	STA ENEMY_VALUES + 12
	STA ENEMY_VALUES + 13
	
	LDA ENEMY_REAPER
	STA ENEMY_VALUES + 14
	STA ENEMY_VALUES + 15
	
	fillEnemies_W3:
	JSR pickEnemyRoutine
	STA ENEMY_TABLE1_W3, X
	CMP ENEMY_REAPER
	BEQ reaperCoords_w3
	LDA #$00
	BEQ nextloop_w3
	
	reaperCoords_w3:
	JSR prng
	AND #$07
	ADC #$40
	CLC
	
	nextloop_w3:
	STA ENEMY_TABLE2_W3, X
	DEX
	BNE fillEnemies_W3
	
	
	LDX #$33
	
	; set up possible enemies for second table, we use 16 bytes for possible enemies to control RNG
	LDA ENEMY_MCGOO
	STA ENEMY_VALUES
	STA ENEMY_VALUES + 1
	STA ENEMY_VALUES + 2
	STA ENEMY_VALUES + 3
	STA ENEMY_VALUES + 4
	
	LDA ENEMY_SHEMUN
	STA ENEMY_VALUES + 5
	STA ENEMY_VALUES + 6
	STA ENEMY_VALUES + 7
	STA ENEMY_VALUES + 8
	STA ENEMY_VALUES + 9
	STA ENEMY_VALUES + 10
	
	LDA ENEMY_NONE
	STA ENEMY_VALUES + 11
	STA ENEMY_VALUES + 12
	STA ENEMY_VALUES + 13
	
	LDA ENEMY_REAPER
	STA ENEMY_VALUES + 14
	STA ENEMY_VALUES + 15
	
	pickEnemy2_W3:
	JSR pickEnemyRoutine
	STA ENEMY_TABLE3_W3, X
	CMP ENEMY_REAPER
	BEQ reaperCoords2_w3
	LDA #$00
	STA ENEMY_TABLE4_W3, X
	BEQ nextScreen_w3
	
	reaperCoords2_w3:
	JSR prng
	AND #$07
	ADC #$C0
	CLC
	STA ENEMY_TABLE4_W3, X
	
	nextScreen_w3:
	DEX
	BNE pickEnemy2_W3
	RTS
	
pickEnemyRoutine:
	JSR prng
	AND #$0F
	TAY
	LDA ENEMY_VALUES, Y
	RTS

pickEnemyW3:
	JSR prng
	
	; Valid Enemies
	; ENEMY_NONE          	equ #$00   empty
	; ENEMY_HOLER			equ #$03   Slime
	; ENEMY_PLUTONFLY		equ #$07   Pluton Fly (thief)
	; ENEMY_KOMAYTO			equ #$08   Metroid <3
	; ENEMY_OCTOS			equ #$0A   Octopus
	; ENEMY_COLLIN			equ #$0B   Collin
	; ENEMY_KEEPAH			equ #$0C   Ridley (this messes up some stuff, and shouldn't be used =/)
	; ENEMY_REAPER			equ #$0D   reaper
	; 7 options since we don't use Keepah
	
	AND #$07
	BEQ exitEnemyPick_w3	; 0 == 0, we can exit
	; 3 and 7 are valid, we'll just leave
	CMP #$03
	BEQ exitEnemyPick_w3
	
	CMP #$07
	BEQ exitEnemyPick_w3
	
	metroid:
	CMP #$01
	BNE octos
	LDA ENEMY_KOMAYTO
	RTS

	octos:
	CMP #$02
	BNE patra
	LDA ENEMY_OCTOS
	RTS
	
	patra:
	CMP #$04
	BNE reaper_w3
	LDA ENEMY_COLLIN
	RTS
	
	reaper_w3:
	CMP #$05
	BNE noenemyw3
	LDA ENEMY_REAPER
	RTS
	
	noenemyw3:
	LDA ENEMY_NONE
	
	exitEnemyPick_w3:
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
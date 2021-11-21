; these are memory address we need to use
; Kid Icarus locations that we don't want to change
LVL_1_1_START		equ		$7C1A
LVL_1_1_START_HB 	equ 	#$7C ; memory address where lvl 1-1 data is written
LVL_1_1_START_LB 	equ 	#$1A ; memory address where lvl 1-1 data is written
LVL_1_2_START_HB	equ		#$7C ; memory address where lvl 1-2 data is written
LVL_1_2_START_LB	equ		#$34 ; memory address where lvl 1-2 data is written
LVL_1_3_START_HB	equ		#$7C ; memory address where lvl 1-3 data is written
LVL_1_3_START_LB	equ		#$52 ; memory address where lvl 1-3 data is written


; zero page variables that we use
CUR_ROOM  			equ		$0191
POTENTIAL 			equ		$0192
ROOM_INDEX 			equ		$0193
ROOM_RULE 			equ   	$0194
ROOM_RULES_OFFSET 	equ 	$0195
ROOM_BIT 			equ		$0196 ; this is the value 0-7 for which bit we care about in the rule
RNG_SEED 			equ 	$0197
RNG_SEED_RB 		equ		$0198
Y_STORAGE 			equ		$0199
RRO_WORK			equ		$019A ; holds the original room rules offset, which we need to save
STORE_SEED_LB		equ		$00B0
STORE_SEED_RB		equ		$00B1

; Level Gen SubRoutine Params
LVL_GEN_PARAM_SIZE			equ	$00C0 ; size of the level.  how many rooms to build
LVL_GEN_END_ROOM_ADDR_PARAM	equ	$00C2 ; the address of the end room for the level.  we hardcode it for highest likelyhood
LVL_GEN_START_ADDR_PARAM	equ	$00C4 ; where we should start writing the data for the level

; ROOM_RULES_DATA is the start of our .bin, everything else that we
; reference should be offset from it based on the size of the data
ROOM_RULES_DATA 	equ		$B9F0
ROOM_ADDRESSES 		equ		ROOM_RULES_DATA + 132; $BE84 ; this is the first byte of the address.  add 2 per room to get the room
ROUTINE_START 		equ		ROOM_ADDRESSES + 004E ; $BECC - we don't actually use this here
LVL_1_1_SIZE 		equ		#$15
LVL_1_2_SIZE		equ		#$19
LVL_1_3_SIZE		equ		#$25
FRAME_COUNT 		equ		$0014
INITIAL_SEED_LB		equ		$00EF
INITIAL_SEED_RB		equ		$00F0
END_ROOM_LVL_1		equ		#$39 ; Room 32, it has the highest likelyhood of allowing access
END_ROOM_LVL_1HB	equ		#$70 ; high order byte of Room 32

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

db $2E, $75
db $BD, $70
db $09, $73

db $00, $70
db $39, $70
db $78, $70

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
	STA STORE_SEED_LB
	STA RNG_SEED
	
	LDA INITIAL_SEED_RB
	STA RNG_SEED_RB
	STA STORE_SEED_RB

; load lvl 1-1 vars
LDA LVL_1_1_SIZE
STA LVL_GEN_PARAM_SIZE
LDA LVL_1_1_START_LB
STA LVL_GEN_START_ADDR_PARAM
LDA LVL_1_1_START_HB
STA LVL_GEN_START_ADDR_PARAM+1
LDA END_ROOM_LVL_1
STA LVL_GEN_END_ROOM_ADDR_PARAM
LDA END_ROOM_LVL_1HB
STA LVL_GEN_END_ROOM_ADDR_PARAM+1
JSR generateRandomVerticalLevel

; load lvl 1-2 vars
LDA LVL_1_2_SIZE
STA LVL_GEN_PARAM_SIZE
LDA LVL_1_2_START_LB
STA LVL_GEN_START_ADDR_PARAM
LDA LVL_1_2_START_HB
STA LVL_GEN_START_ADDR_PARAM+1
LDA END_ROOM_LVL_1
STA LVL_GEN_END_ROOM_ADDR_PARAM
LDA END_ROOM_LVL_1HB
STA LVL_GEN_END_ROOM_ADDR_PARAM+1
JSR generateRandomVerticalLevel

; load lvl 1-3 vars
LDA LVL_1_3_SIZE
STA LVL_GEN_PARAM_SIZE
LDA LVL_1_3_START_LB
STA LVL_GEN_START_ADDR_PARAM
LDA LVL_1_3_START_HB
STA LVL_GEN_START_ADDR_PARAM+1
LDA END_ROOM_LVL_1
STA LVL_GEN_END_ROOM_ADDR_PARAM
LDA END_ROOM_LVL_1HB
STA LVL_GEN_END_ROOM_ADDR_PARAM+1
JSR generateRandomVerticalLevel
RTS

generateRandomVerticalLevel:
	; Y will be the room index
	LDY #$00

	; start room rule at the first address for room 30's rule
	; the start rooms are after the middle rooms
	; room 30's rules are 32 * 4 = 128 bytes later (0x80)

	;LDA #$80
	;STA ROOM_RULES_OFFSET

	; always start in room 33
	LDA #$21
	STA POTENTIAL
	
buildlevel:
	;store the successful potential room in the start + room index	
	LDA POTENTIAL
	
	STA ROOM_RULES_OFFSET
	DEC ROOM_RULES_OFFSET
	ASL ROOM_RULES_OFFSET
	ASL ROOM_RULES_OFFSET
	
	; shift to the left to multiply by 2
	ASL A
	TAX
		
	LDA ROOM_ADDRESSES, X 
	STA (LVL_GEN_START_ADDR_PARAM),Y
	INX
	INY
	LDA ROOM_ADDRESSES, X 
	STA (LVL_GEN_START_ADDR_PARAM), Y
	INY				; y++
	CPY LVL_GEN_PARAM_SIZE	; if > SIZE we're done
	BCS writeexit
	
chooseroom:
	STY Y_STORAGE
	LDA ROOM_RULES_OFFSET
	STA RRO_WORK
	JSR prng
	AND #$1F ; trim to 0-31
	CLC
	ADC #$01 ; add 1 so it's 1 - 32
	CLC
	LDY Y_STORAGE
	
	STA POTENTIAL 	

	; room rules are sets of 8 bits, so we need to find
	; the right 8 bits by subtrating 8 until we're under 8
	; and shifting right in our room rules
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
	BNE buildlevel	; match was good, build the level
	
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
	LDA POTENTIAL
	LDX #$65
	
getexitrule:
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
	JMP generateRandomVerticalLevel
	
writeexitaddress:
	; write the exit room
	LDA LVL_GEN_END_ROOM_ADDR_PARAM
	STA (LVL_GEN_START_ADDR_PARAM), Y
	LDA LVL_GEN_END_ROOM_ADDR_PARAM+1
	INY
	STA (LVL_GEN_START_ADDR_PARAM), Y
	
	RTS 			; we're done here


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
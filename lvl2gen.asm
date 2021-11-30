RULES_DATA			equ		$F900
ROUTINE				equ		$F700
CURRENT_SCREEN		equ		$04D1
CURRENT_LEVEL		equ		$0130
SCREEN_ADDR_DB		equ		RULES_DATA + 35 + 35 + 35 + 35
STAGE_LENGTH		equ		#$1B

; our variables
POTENTIAL				equ		$00D0
CURRENT_SCREEN_ID		equ		$00D1
SCREEN_RULES_LOCATION	equ		$00D2
SRL_WORK				equ		$00D3
ROOM_BIT				equ		$00D4
SCREEN_RULE				equ		$00D5
SCREEN_ADDR				equ		$00D6


INITIAL_SEED_LB		equ		$00EF
INITIAL_SEED_RB		equ		$00F0
RNG_SEED 			equ 	$0197
RNG_SEED_RB 		equ		$0198
STORE_SEED_LB		equ		$00B0
STORE_SEED_RB		equ		$00B1

org ROUTINE
LDA CURRENT_SCREEN
CMP STAGE_LENGTH
BEQ writeExit
CMP #$00
BEQ writeFirstRoom
BNE pickNextScreen

writeExit:
LDA #$24
CLC
ADC CURRENT_LEVEL
STA POTENTIAL
CLC
BCC storeroom

writeFirstRoom:
; for the first room in each world we're going to start in room 
LDA #$21
CLC
ADC CURRENT_LEVEL ; 21 for 2-1, 22 for 2-2, 23 for 2-3
STA POTENTIAL
LDA CURRENT_LEVEL
CMP #$00
BNE storeroom

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
CLC
BCC storeroom

pickNextScreen:
LDA CURRENT_SCREEN_ID
STA SCREEN_RULES_LOCATION
DEC SCREEN_RULES_LOCATION
ASL SCREEN_RULES_LOCATION
ASL SCREEN_RULES_LOCATION
; SCREEN_RULES_LOCATION now holds the address of the first rule for the current room

LDA SCREEN_RULES_LOCATION
STA SRL_WORK
; pick a random new screen
JSR prng
AND #$1F
STA POTENTIAL
INC POTENTIAL
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
	BEQ pickNextScreen  ; no match, pick a new room


; look up address for picked screen
storeroom:
LDA POTENTIAL
STA CURRENT_SCREEN_ID ; store this one in the current screen for use by the next load
STA SCREEN_ADDR
DEC SCREEN_ADDR
ASL SCREEN_ADDR
LDY SCREEN_ADDR

; store LB in $#49, HB in $#4A
LDA SCREEN_ADDR_DB, Y
STA $49
INY
LDA SCREEN_ADDR_DB, Y
STA $4A

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
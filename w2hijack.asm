; sizes are number of bytes of addresses, so #screens * 2
LVL_2_1_SIZE 				equ	#$36
LVL_2_2_SIZE				equ	#$3C
LVL_2_3_SIZE				equ	#$3C

RULES_DATA_FIRST_PAGE		equ	#$F8
RULES_DATA_FIRST_PAGE_LB	equ	#$80
ITEM_LOCS_LB			    EQU #$00
ITEM_LOCS_HB			    EQU #$FE
ENEMY_TABLE2_LB     		EQU $20

PARAM_RULES_FP_LB			EQU $80
PARAM_RULES_FP_HB			EQU $81
PARAM_ITEM_LOCS_LB			EQU $82
PARAM_ITEM_LOCS_HB			EQU $83
PARAM_ENEMY_TABLE_LB		EQU $84

LVL_GEN_PARAM_SIZE			equ	$00C0 ; size of the level.  how many rooms to build

ROUTINE						equ	$F660

LVL2_HIJACK					equ	$AE37
ORIGINAL_CONTINUE			equ	LVL1_HIJACK + 32

org LVL2_HIJACK
LDA RULES_DATA_FIRST_PAGE_LB
STA PARAM_RULES_FP_LB

LDA RULES_DATA_FIRST_PAGE
STA PARAM_RULES_FP_HB

LDA ITEM_LOCS_HB
STA PARAM_ITEM_LOCS_HB

LDA ITEM_LOCS_LB
STA PARAM_ITEM_LOCS_LB

LDA LVL_2_1_SIZE
STA LVL_GEN_PARAM_SIZE

LDA ENEMY_TABLE2_LB
STA PARAM_ENEMY_TABLE_LB

JSR ROUTINE

NOP
NOP
NOP
NOP
NOP
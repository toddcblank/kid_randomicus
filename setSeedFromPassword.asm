SEED_SET_ROUTINE equ $AF00
SEED_LB          equ $011E
FIRST_PASSWORD_CHAR equ $6031

K_CHAR  equ #$14
I_CHAR  equ #$12

org SEED_SET_ROUTINE


originalCode:
  LDX #$23                 
  LDA #$00     
  
  origABD4:            
  STA $600D,X              
  DEX                      
  BPL origABD4                
  LDX #$11                 
  LDA #$00 

  origABDE:           
  STA $6061,X              
  DEX                      
  BPL origABDE              

LDA FIRST_PASSWORD_CHAR
CMP K_CHAR
BNE bailToOriginal

LDA FIRST_PASSWORD_CHAR + 1
CMP I_CHAR
BNE bailToOriginal

; seed setting
LDA FIRST_PASSWORD_CHAR + 2
AND #$0F
ASL A
ASL A
ASL A
ASL A
STA SEED_LB

LDA FIRST_PASSWORD_CHAR + 3
AND #$0F
CLC
ADC SEED_LB
STA SEED_LB

LDA FIRST_PASSWORD_CHAR + 4
AND #$0F
ASL A
ASL A
ASL A
ASL A
STA SEED_LB + 1

LDA FIRST_PASSWORD_CHAR + 5
AND #$0F
CLC
ADC SEED_LB + 1
STA SEED_LB + 1

; clear the stack
PLA
PLA
PLA
PLA
PLA
PLA
LDA #$A1
PHA
LDA #$04
PHA
LDA #$EE
PHA
LDA #$2A
PHA
LDA #$02
STA $A0
STA $6028
LDA #$FF
STA SEED_LB - 1
LDA #$00
LDX #$00
bailToOriginal:
    RTS
; This patch replaces the current build level routine in order to give us more room for
; our awesome randomization
NEW_ROUTINE_ADDR equ $BED2

JSR NEW_ROUTINE_ADDR
RTS
LDA #$00                 
STA $02                  
LDA #$70                 
STA $03                  
LDX #$0F                 
LDY #$00                 
LDA ($00),Y              
STA ($02),Y              
INY                      
BNE $98F8                
INC $01                  
INC $03                  
DEX                      
BNE $98F8                
RTS                      

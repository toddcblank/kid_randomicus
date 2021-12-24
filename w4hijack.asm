LVL3_HIJACK					equ	$f86e
ROUTINE                     equ $FEA4

; original
; LDA $0130                
; ASL A                    
; TAY                      
; LDA $BE7C,Y              
; STA $00                  
; LDA $BE7D,Y              
; STA $01                  
; LDA CURRENT_SCREEN       
; ASL A                    
; TAY                      
; LDA ($00),Y              
; STA $49                  
; INY                      
; LDA ($00),Y              

org LVL3_HIJACK
JSR ROUTINE

; need 27 total bytes overwritten, JSR is 3 bytes
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP

NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP

NOP
NOP
NOP
NOP

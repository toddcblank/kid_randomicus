PASSWORD_HIJACK equ $ABD0
NEW_PASSWORD equ $AF00
START_LVL_1 equ $EE2B

org PASSWORD_HIJACK
JSR NEW_PASSWORD
; this 
;CMP #$FF
;BNE oldPassword
;LDA #$A1
;PHA
;LDA #$04
;PHA
;LDA #$00
;JMP START_LVL_1

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
; need to take up 20 total bytes
oldPassword:
NOP
NOP
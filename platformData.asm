PLATFORM_DATA equ $F9A0

org PLATFORM_DATA
db $02, $19, $07, $00, $00, $00, $00, $00  ; w1 - room 25
db $02, $1D, $c7, $97, $67, $37, $00, $00  ; w1 - room 29
db $02, $1E, $c7, $67, $00, $00, $00, $00  ; w1 - room 30
db $02, $1F, $c7, $37, $00, $00, $00, $00  ; w1 - room 31
db $02, $20, $c7, $97, $37, $00, $00, $00  ; w1 - room 32
db $04, $21, $26, $76, $b6, $00, $00, $00  ; w2 - room 33
db $04, $22, $B6, $00, $00, $00, $00, $00  ; w2 - room 34
db $04, $23, $46, $C6, $00, $00, $00, $00  ; w2 - room 35
db $06, $04, $e7, $00, $00, $00, $00, $00  ; w3 - room 04
db $06, $0B, $b7, $00, $00, $00, $00, $00  ; w3 - room 11
db $06, $0C, $d7, $77, $00, $00, $00, $00  ; w3 - room 12
db $06, $0D, $c7, $97, $37, $07, $00, $00  ; w3 - room 13
db $06, $0E, $07, $00, $00, $00, $00, $00  ; w3 - room 14
db $FF ; end of platform data
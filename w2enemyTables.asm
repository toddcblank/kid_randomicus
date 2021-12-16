ENEMY_TABLE	equ	$FA00

NONE	equ	$00;	empty
SHEMUN	equ	$02;	snakes
GIRIN	equ	$03;	Ground enemy
ROKMAN	equ	$04;	Rocks.  :eyeroll:
KERON	equ	$05;	Frogs
PLUTON	equ	$07;	Pluton (thief)
MICKS	equ	$08;	Flying mouths
SNOWMAN	equ	$09;	Snowman
MINOS	equ	$0A;	Rising faces


; 16 spots for table 1 can be NONE, ROKMAN, KERON, PLUTON, MICKS, or MINOS
db NONE, NONE
db ROKMAN, ROKMAN, ROKMAN, ROKMAN
db KERON, KERON
db PLUTON, PLUTON
db MICKS, MICKS, MICKS
db MINOS, MINOS, MINOS

; 16 spots for table 2, can be NONE, SHEMUN, GIRIN, or SNOWMAN
db NONE, NONE, NONE, NONE
db SHEMUN, SHEMUN, SHEMUN, SHEMUN
db GIRIN, GIRIN, GIRIN, GIRIN
db SNOWMAN, SNOWMAN, SNOWMAN, SNOWMAN
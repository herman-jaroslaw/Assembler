;
; 5.3_test.asm
;
; Created: 26.04.2021 18:58:31
; Author : Jaro
;

ldi r18, low(1234) ; r19:r18 is an unsigned two-byte integer	;DEC 1234 = BIN 0000 0100 1101 0010 -> LOW = BIN 1101 0010 = DEC 210 
ldi r19, high(1234)												;HIGH = BIN 0000 0100 = DEC 4
lsr r19 ; Divide r19:r18 by two
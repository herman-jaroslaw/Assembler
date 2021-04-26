;
; 5.3_test.asm
;
; Created: 26.04.2021 18:58:31
; Author : Jaro
;

ldi r16, low(15)	;M�ODSZE									
ldi r17, high(15)	;STARSZE	;high(15) bierze pierwsze 8 bit�w 16-bitowej liczby 15 (0b 0000 0000 0000 1111), czyli 0							
	
subi r16, low(38)	;M�ODSZE	
sbci r17, high(38)	;STARSZE	;low(38) bierze drugie 4 bity liczby 38 (0b00100110), czyli 6


ldi r18, low(1234) ; r19:r18 is an unsigned two-byte integer	;DEC 1234 = BIN 0000 0100 1101 0010 -> LOW = BIN 1101 0010 = DEC 210 
ldi r19, high(1234)												;HIGH = BIN 0000 0100 = DEC 4
lsr r19 ; Divide r19:r18 by two

ldi r16, 0			;M�ODSZE									
ldi r17, high(15)	;STARSZE	;high(15) bierze pierwsze 8 bit�w 16-bitowej liczby 15 (0b 0000 0000 0000 1111), czyli 0							
	
subi r16, 0			;M�ODSZE	
sbci r17, low(38)	;STARSZE	;low(38) bierze drugie 4 bity liczby 38 (0b00100110), czyli 6
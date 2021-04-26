;
; lab_5.3_v2.asm
;
; Created: 21.04.2021 21:20:59
; Author : Jaro
;


;
; lab5_zad53.asm
;
; Created: 2021-04-21 20:33:34
; Author : DELL
;


; Replace with your application code

.include "328PBdef.inc"

.org 0x00 											;dyrektywa org nie jest konieczna
			rjmp prog_start 						;skok do programu g³ównego
.org 0x32 											;adres pocz¹tku listy danych dyrektywy DB
prime: .DB 0x5f, 0x7f
		
.org 0x100 											;adres pocz¹tku programu

prog_start: 	

	ldi r16, high(ramend)	
    out sph, r16		
    ldi r16, low(ramend)
    out spl, r16	

start:
    ldi r16, $ff
	out ddrb, r16
	out ddrd, r16
	out ddre, r16

	;ldi R17, 184
	;ldi zl, low(2*prime)
	;ldi zh, high(2*prime)


		ldi r20, 0x02				;1. wybór
		com r20						;wyœwietl
		out porte, r20				;lacza
		
		;ldi r16, 0x00	// bity starsze ; 11111111
		ldi r17, 0x20	// mlodsze		; 01000100 ;0x64; 0x20

		subi r17, 0x64				;0x64 ;mlodsze ;wynik = 68
		;sbci r16, 0x00				;2. wybór ;starsze
		
		push r18
		ldi r18, 0x5f
		;com r16						;kolejnej wartoœci
		com r18
		out portd, r18				;z listy prime
		;out portd, r16
		pop r18

		ldi r20, 0x01				;1. wybór
		com r20						;wyœwietl
		out porte, r20				;lacza
		
		ldi r16, 0x00	// bity starsze ; 11111111
		;ldi r17, 0x20	// mlodsze		; 01000100 ;0x64; 0x20

		;subi r17, 0x64				;0x64 ;mlodsze ;wynik = 68
		sbci r16, 0x00				;2. wybór ;starsze
		
		push r19
		ldi r19, 0x7f
		;com r16						;kolejnej wartoœci
		com r19
		out portd, r19				;z listy prime
		pop r19
		;call wait 
		;cp R16,R17
		;brne start
		;rjmp prog_start

	brmi znak ;skacze, gdy minus
prz:
	brvs przepelnienie

znak:
	ldi r22, 0b0001
	out pinb, r22
	jmp prz

przepelnienie:
	ldi r23, 0b0010
	out pinb, r23
	
	rjmp start

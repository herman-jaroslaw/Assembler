;4.3_v4

.include "328PBdef.inc"

.org 0x00 											;dyrektywa org nie jest konieczna
			rjmp prog_start 						;skok do programu g³ównego
.org 0x32 											;adres pocz¹tku listy danych dyrektywy DB
prime: .DB 0x7E, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47
		
.org 0x100 											;adres pocz¹tku programu

prog_start: 	

	ldi r16, high(ramend)	
    out sph, r16		
    ldi r16, low(ramend)
    out spl, r16	

		ldi R16,$00
		ldi R17,$ff
		out ddre, R17
		out ddrd, R17
		ldi R17, 184

		ldi zl, low(2*prime)
		ldi zh, high(2*prime)
start:
		ldi r20, 0x01				;1. wybór
		com r20						;wyœwietl
		out porte, r20				;lacza
		lpm r16, z+					;2. wybór
		com r16						;kolejnej wartoœci
		out portd, r16				;z listy prime

		call wait 
		cp R16,R17
		brne start
		;rjmp prog_start


wait:
  push r16
  push r17
  push r18
  ldi r18, 255
    loop2: 
        ldi r17, 255
        loop3:
            ldi r16, 100
            loop4:
                dec r16
            brne loop4
        dec r17 
        brne loop3
    dec r18
    brne loop2
  pop r18
  pop r17
  pop r16
  ret
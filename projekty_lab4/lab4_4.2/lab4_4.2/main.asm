// 4.2

.include "328PBdef.inc"

.org 0x00 											;dyrektywa org nie jest konieczna
			rjmp prog_start 						;skok do programu g³ównego
.org 0x32 											;adres pocz¹tku listy danych dyrektywy DB
prime: .DB 2, 3, 5, 7, 11, 13, 17, 19, 23, 29		;stworzenie listy dziesiêciu liczb pierwszych
.org 0x100 											;adres pocz¹tku programu

prog_start:

	ldi r16, high(ramend)	
    out sph, r16		
    ldi r16, low(ramend)
    out spl, r16
	
	 	
		ldi R16,$00
		ldi R17,$ff
		out ddrb, R17
		ldi R17, 29
		ldi zl, low(2*prime)
		ldi zh, high(2*prime)
start:
		lpm r16, z+
		out portb, r16

		call wait
		cp R16,R17
		brne start
		rjmp prog_start


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


;wait_subroutine:
;		push r16
;		push r17
;		
;		ldi r17,255
;		wait1:
;			ldi r16,255
;			wait2:
;				dec R16
;				brne wait2
;			dec R17
;			brne wait1
;		pop r17
;		pop r16
;		ret 
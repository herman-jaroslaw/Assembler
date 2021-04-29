;4.4
;port b - LED
;port c - switch
;port d - 7hex display
;port e - 7hex control

.org 0x00 
rjmp setting
.org 0x32
prime: .DB 0x7E, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47

setting: 

	ldi r16, high(ramend)	;stack
    out sph, r16		
    ldi r16, low(ramend)
    out spl, r16	

	ldi r16, $ff			;port set
	out ddrd, r16
	out ddre, r16

reset:
	ldi r20, 0x00			; counter set
	ldi r21, 0x00

start:
		call display		; counter
		inc r20
		brne start
		inc r21
		brne start
		rjmp reset

delay:             ; delay =  1/20s
   push r16
        push r17
    ldi r16,246                 ;50*(1+1+2)*246+246*3=49938
    loop:
        ldi r17,50
        loop2:
            nop
            dec r17
            brne loop2
        dec r16
        brne loop
        pop r17
        pop r16
ret

display:			; wyswietlanie zawartoœci licznika w formie podprogramu (pkt 3)
	ldi r26, 3		;cztery okresy odswiezajace LED (f modyfikacji licznika = 1/5 s, bo 4*1/20=1/5)
	wait:				; czestotliwosc modyfikacji licznika
		
		call delay
		dec r26
		brne wait

	call seg1	
	call delay		
	call seg2
	call delay
	call seg3
	call delay
	call seg4
	call delay

	ret

seg1:							;najstarszy segment, using r20
	push r20
	push r21

	ldi zl, low(2*prime)
	ldi zh, high(2*prime)

	ldi r20, 0x01				;wybor najstarszego segmentu	
	com r20						;odwrocenie wartosci rejestru r20
	out porte, r20				;wysterowanie portu sterujacego zerami w celu uaktywnienia segmentu

	swap r21					;zamiana miejscami polowek bajtu 
	andi r21, 0x0f				;isolation of less significant byte half
	add zl, r21					;adding value stored in r21 to zl (r30) 
	lpm r20, z					;loading value from z register (r30 and r31) to r20 (starting from 1st value in prime list)
	com r20						;inverting values in r20
	out portd, r20				;

	pop r21
	pop r20
	ret
seg2:						;using r20
	push r20
	push r21

	ldi zl, low(2*prime)
	ldi zh, high(2*prime)

	ldi r20, 0x02
	com r20
	out porte, r20


	andi r21, 0x0f
	add zl, r21
	lpm r20, z
	com r20
	out portd, r20

	pop r21
	pop r20 
	ret
seg3:			;using r21
	push r20
	push r21

	ldi zl, low(2*prime)
	ldi zh, high(2*prime)

	ldi r21, 0x04
	com r21
	out porte, r21


	swap r20
	andi r20, 0x0f
	add zl, r20
	lpm r21, z
	com r21
	out portd, r21

	pop r21
	pop r20
	ret
seg4:				;using r21
	push r20
	push r21

	ldi zl, low(2*prime)
	ldi zh, high(2*prime)

	ldi r21, 0x08
	com r21
	out porte, r21


	andi r20, 0x0f
	add zl, r20
	lpm r21, z
	com r21
	out portd, r21

	pop r21
	pop r20
	ret

stop: rjmp stop
;4.4_v2

.org 0x00 
rjmp ustawianie
.org 0x32
prime: .DB 0x7E, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47

ustawianie: 

	ldi r16, high(ramend)	;stosik
    out sph, r16		
    ldi r16, low(ramend)
    out spl, r16	

	ldi r16, $ff			;ustawianie portów
	out ddrd, r16
	out ddre, r16

reset:
	ldi r20, 0x00			; ustawianie licznika
	ldi r21, 0x00

start:
		call display		; licznik
		inc r20
		brne start
		inc r21
		brne start
		rjmp reset

delay:
	push r16
	push r17
	push r18

	ldi r16, 150 ;198
	delay1:
		ldi r17, 150 ;150
		delay2:
			ldi r18, 8; 8 
				delay3:
					dec r18
					brne delay3
			dec r17
			brne delay2
	dec r16
	brne delay1

	pop r18
	pop r17
	pop r16
	ret

display:			; wyœwietlanie
	ldi r26, 16
	wait:				; czestotliwosc modyfikacji licznika
		
		call delay
		dec r26
		brne wait

	call seg1	
	call delay		; { [1] [2] [3] [4] }
	call seg2
	call delay
	call seg3
call delay
	call seg4
	call delay

	ret

seg1:							
	push r20
	push r21

	ldi zl, low(2*prime)
	ldi zh, high(2*prime)

	ldi r20, 0x01
	com r20
	out portc, r20

	ldi r20, 0
	swap r21
	andi r21, 0x0f
	add zl, r21
	adc zh, r20
	lpm r20, z
	com r20
	out portd, r20

	pop r21
	pop r20
	ret
seg2:
	push r20
	push r21

	ldi zl, low(2*prime)
	ldi zh, high(2*prime)

	ldi r20, 0x02
	com r20
	out portc, r20

	ldi r20, 0
	andi r21, 0x0f
	add zl, r21
	adc zh, r20
	lpm r20, z
	com r20
	out portd, r20

	pop r21
	pop r20 
	ret
seg3:
	push r20
	push r21

	ldi zl, low(2*prime)
	ldi zh, high(2*prime)

	ldi r21, 0x04
	com r21
	out portc, r21

	ldi r21, 0
	swap r20
	andi r20, 0x0f
	add zl, r20
	adc zh, r21
	lpm r21, z
	com r21
	out portd, r21

	pop r21
	pop r20
	ret
seg4:
	push r20
	push r21

	ldi zl, low(2*prime)
	ldi zh, high(2*prime)

	ldi r21, 0x08
	com r21
	out portc, r21

	ldi r21, 0
	andi r20, 0x0f
	add zl, r20
	adc zh, r21
	lpm r21, z
	com r21
	out portd, r21

	pop r21
	pop r20
	ret

stop: rjmp stop
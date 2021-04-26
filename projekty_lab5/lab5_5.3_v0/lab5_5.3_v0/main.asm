;
; lab5_zad53.asm
;
; Created: 2021-04-21 20:33:34
; Author : DELL
;


; Replace with your application code


;4.4_A


.org 0x00 
rjmp ustawianie
.org 0x32
prime: .DB 0x7E, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47

ustawianie: 

	ldi r16, high(ramend)	;stos
    out sph, r16		
    ldi r16, low(ramend)
    out spl, r16	

	ldi r16, $ff			;ustawianie portów
	out ddrd, r16
	out ddre, r16
	out ddrc, r16

subtraction:

	ldi r16, 0x00	// bity starsze
	ldi r17, 0x64	// mlodsze

	subi r17, 0x20
	sbci r16, 0x00

	call display
	inc r20																					; po co?
	brne subtraction
	inc r21																					; po co?
	;brne subtraction




	 ;wyœwietlenie wyniku odejmowania
;	brmi znak
;prz:
;	brvs przepelnienie

;znak:
;	ldi r22, 0b0011
;	out pinc, r22
;	jmp prz

;przepelnienie:
;	ldi r23, 0b1100
;	out pinc, r23
	
;	rjmp subtraction


;reset:
;	ldi r20, 0x00			; ustawianie licznika
;	ldi r21, 0x00

;start:
;		call display		; licznik
;		inc r20																					; po co?
;		brne start
;		inc r21																					; po co?
;		brne start
;		rjmp reset

delay:             ;petla opozniajaca, delay 1/20s
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

display:			; wyœwietlanie
	ldi r26, 3
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

seg1:							
	push r20
	push r21

	ldi zl, low(2*prime)
	ldi zh, high(2*prime)

	ldi r20, 0x01
	com r20
	out porte, r20

	swap r21
	andi r21, 0x0f
	add zl, r21
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
	out porte, r20


	andi r21, 0x0f
	add zl, r21
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
seg4:
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
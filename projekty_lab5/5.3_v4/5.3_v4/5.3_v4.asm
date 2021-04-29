;5.3
;port b - LED
;port c - switch
;port d - 7hex display
;port e - 7hex control

.CSEG 
.ORG 0 
	ldi R16, HIGH(RAMEND)    
	out SPH, R16    
	ldi R16, LOW(RAMEND)    ;stos
	out SPL, R16    

	rjmp prog_start     
    .org 0x32  
	prime: .DB 0x7E, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47
 .DSEG 
.ORG 0x100 
	var1: .BYTE 1  
	var2: .BYTE 1	;parameters
	var3: .BYTE 1 
	.CSEG 

prog_start: 
	ldi r16, $ff    
	out ddre, r16    
	out ddrd, r16
	out ddrb, r16

	
	ldi r16, low(15)	;mlodsze	= DEC 194 = BIN 1100 0010 = U2 0011 1110			;0xC2		; 0000 0000 0000								
	ldi r17, high(15)	;starsze = DEC 254 = BIN 1111 1110 = U2 0000 0010				;0xFE
	
	
	subi r16, low(20)				; = DEC 15 = BIN 0000 1111 = U2 1111 0001	; 194 - 15 = 179 = HEX B3			;0x0F
	sbci r17, high(20)				;		; = DEC 1 = BIN 0000 0001 = U2 1111 1111			;0x01
    brvs overflow					; 254 - 1 = 253 = HEX FD
	brmi znak						; WYŒWIETLANY WYNIK: D420 = DEC 54 304,				;0000 0010 0100 1101
	rjmp start

znak:
		ldi r31,0
		ldi r30,1
		com r16
		com r17
		add r16, r30
		adc r17, r31	
	brvs both
        ldi r22, 0b100000
        out portb, r22
		rjmp start
overflow:
	brmi both
        ldi r23, 0b000100
        out portb, r23
		rjmp start
both:
       ldi r23, 0b100100
        out portb, r23
	
start:
	call displaying 
	rjmp prog_start 

displaying: 
	ldi r18, 2 
	petla: 
		call wait_sec 
		dec r18 
	brne petla 
								 ;display1 
		ldi r19,0x08 
		ldi r20,1 
		sts var1, r19 
		sts var2, r20 
		sts var3, r16
		call seg1  
			call wait_sec 
								 ;display2
		ldi r19,0x04 
		ldi r20,0
		sts var1, r19 
		sts var2, r20 
		sts var3, r16
		call seg1 
			call wait_sec 
								;display3
		ldi r19,0x02 
		ldi r20,1
		sts var1, r19 
		sts var2, r20 
		sts var3, r17
		call seg1 
			call wait_sec 
								;display4
		ldi r19,0x01 
		ldi r20,0 
		sts var1, r19 
		sts var2, r20	
		sts var3, r17
		call seg1 
			call wait_sec 
	ret 

	;delay
wait_sec:   
	push r16   
	push r17   
	push r18   
	push r19   
	ldi r16,1  
		ldi r17,5
		opoznienie_1:   
		ldi r18, 25
			opoznienie_2:   
			ldi r19, 100
				opoznienie_3:   
				dec r19   
				brne opoznienie_3	   
			dec r18   
			brne opoznienie_2   
		dec r17  
		brne opoznienie_1   
	dec r16     
	brne wait_sec   
pop r19  
pop r18   
pop r17   
pop r16   

Ret  
		;displaying
seg1:							   
	push r16 
	push r17 
	push r18  

	ldi zl, low(2*prime) 
	ldi zh, high(2*prime)    

	lds r16, var1	;display
	com r16                     
	out porte, r16  

	ldi r16, 0	;hex
	lds r18, var2 
	cp r18, r16 
	lds r17, var3
	brne noswap 
	swap r17  
noswap: 
	andi r17, 0x0f  
	add zl, r17  
	adc zh, r16 
	lpm r16, z  
	com r16  
	out portd, r16 

	pop r18 
	pop r17  
	pop r16  

	ret  
stop: rjmp stop

;r16 fc
;r17 ff
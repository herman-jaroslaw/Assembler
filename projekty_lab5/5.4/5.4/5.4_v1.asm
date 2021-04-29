;5.4_v1 - latest version
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
	var2: .BYTE 1	;parametry do podprogramu
	var3: .BYTE 1 
	.CSEG 

prog_start: 
	ldi r16, $ff    
	out ddre, r16    
	out ddrd, r16
	out ddrb, r16

	
	ldi r16, low(-50)	;mlodsze	= DEC 194 = BIN 1100 0010 = U2 0011 1110			;0xC2	;9C = U2 1001 1100 = BIN 0110 0100							
	ldi r17, high(-50)	;starsze = DEC 254 = BIN 1111 1110 = U2 0000 0010				;0xFE
	
	
	subi r16,0x20	; = DEC 15 = BIN 0000 1111 = U2 1111 0001	; 194 - 15 = 179 = HEX B3			;0x0F
	sbci r17,0x00		;-318 - 271 = -589		; = DEC 1 = BIN 0000 0001 = U2 1111 1111			;0x01
    brvs przepelnienie	; 254 - 1 = 253 = HEX FD
	brmi znak			
	jmp dzielenie
znak:
		ldi r31,0
		ldi r30,1
		com r16
		com r17
		add r16, r30
		adc r17, r31	
	brvs obie
        ldi r22, 0b100000
        out portb, r22
		rjmp start
przepelnienie:
	brmi obie
        ldi r23, 0b000100
        out portb, r23
		rjmp start
obie:
       ldi r23, 0b100100
        out portb, r23
		
dzielenie:

		;(F-32) * (1/2 + 1/16)		;to nieco wiêcej ni¿ (F-32) * (5/9)
		;dzielenie przez 2
	asr r17			;arithmetic shift right/dividing U2 number by 2/LSB (bit 0) moved to C flag
	ror r16			;all bits moved one position to right -> flag C goes to bit 7 and bit 0 goes to flag C									
	mov r24, r17
	mov r25, r16
		;dzielenie przez 1/8 
	asr r17			; w poni¿szych komendach wykonujê tak¹ operacjê jeszcze 3 razy
	ror r16			
	asr r17
	ror r16
	asr r17
	ror r16
	add r16, r25	; dodajemy (1/2 + 1/16)
	adc r17, r24	

start:
	call wyswietlanie 
	rjmp prog_start 
wyswietlanie: 
	ldi r18, 2 ; r18 sluzy aby cyfry zmienialy sie co 1/5s 
	petla: 
		call wait_sec 
		dec r18 
	brne petla 
								 ;wysw1 
		ldi r19,0x08 
		ldi r20,1 
		sts var1, r19 
		sts var2, r20 
		sts var3, r16
		call seg1  
			call wait_sec 
								 ;wysw2
		ldi r19,0x04 
		ldi r20,0
		sts var1, r19 
		sts var2, r20 
		sts var3, r16
		call seg1 
			call wait_sec 
								;wysw3 
		ldi r19,0x02 
		ldi r20,1
		sts var1, r19 
		sts var2, r20 
		sts var3, r17
		call seg1 
			call wait_sec 
								;wysw4 
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
		;podprogram wyswietlacze
seg1:							   
	push r16 
	push r17 
	push r18  

	ldi zl, low(2*prime) ;mno¿enie przez dwa, celem uzyskania adresu w przestrzeni bajtowej 
	ldi zh, high(2*prime)    

	lds r16, var1	;wyswietlacz
	com r16                     
	out porte, r16  

	ldi r16, 0	;segment
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
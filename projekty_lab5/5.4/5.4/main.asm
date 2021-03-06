;5.4 - wersja AZ zmodyfikowana
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
	prime: .DB 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7F, 0x7B, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47 	   ;lista
 .DSEG 
.ORG 0x100 
	var1: .BYTE 1  
	var2: .BYTE 1  ;parametry do podprogramu
	var3: .BYTE 1 
	.CSEG 

prog_start: 
	ldi r16, $ff    
	out ddre, r16   ;b - control
	out ddrd, r16	;d - display
	out ddrb, r16	;c - diody

	ldi r16, high(-100)													; 1. high(-1200) //starsze
	ldi r17, low(-100)	//mlodsze									; 2. high(-100) -> wy?wietla 5700
	
	sbci r16, 0x00
	subi r17, 0x20
	
	brmi znak														; Ad 1 WY?WIETLA WARTO?? 5b20
diody:
    brvs przepelnienie
	jmp dzielenie
znak:
		ldi r31,0
		ldi r30,1
		com r16
		com r17
		add r17,r30
		adc r16,r31
				
        ldi r22, 0b100000  
        out pinc, r22
		jmp diody															
przepelnienie:
        ldi r23, 0b001000 
        out pinc, r23 
dzielenie:

		;(F-32) * (1/2 + 1/16)		;to nieco wi?cej ni? (F-32) * (5/9)
		;dzielenie przez 2
	asr r16			;arithmetic shift right/dividing U2 number by 2/LSB (bit 0) moved to C flag
	ror r17			;all bits moved one position to right -> flag C goes to bit 7 and bit 0 goes to flag C									
	mov r24, r16
	mov r25, r17
		;dzielenie przez 1/8 
	asr r16			; w poni?szych komendach wykonuj? tak? operacj? jeszcze 3 razy
	ror r17			
	asr r16
	ror r17
	asr r16
	ror r17
	add r17, r25	; dodajemy (1/2 + 1/16)
	adc r16, r24	

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
		ldi r19,0x01 
		ldi r20,1 
		sts var1, r19 
		sts var2, r20 
		sts var3, r17
		call seg1  
			call wait_sec 
									;wysw2
		ldi r19,0x02 
		ldi r20,0
		sts var1, r19 
		sts var2, r20 
		sts var3, r17
		call seg1 
			call wait_sec 
									;wysw3
		ldi r19,0x04 
		ldi r20,1
		sts var1, r19 
		sts var2, r20 
		sts var3, r16
		call seg1 
			call wait_sec 
									;wysw4 
		ldi r19,0x08 
		ldi r20,0 
		sts var1, r19 
		sts var2, r20	
		sts var3, r16
		call seg1 
			call wait_sec 
	ret 

	;delay
wait_sec:						;zmienilem rejestry
	push r18   
	push r19   
	push r20   
	push r21   
	ldi r18,1  
		ldi r19,5
		opoznienie_1:   
		ldi r20, 25
			opoznienie_2:   
			ldi r21, 100
				opoznienie_3:   
				dec r21   
				brne opoznienie_3	   
			dec r20   
			brne opoznienie_2   
		dec r19  
		brne opoznienie_1   
	dec r18     
	brne wait_sec   
pop r21  
pop r20   
pop r19   
pop r18   

Ret  
;podprogram wyswietlacze
seg1:							   
	push r16 
	push r17 
	push r18  

	ldi zl, low(2*prime) ;mno?enie przez dwa, celem uzyskania adresu w przestrzeni bajtowej 
	ldi zh, high(2*prime)    

	lds r16, var1 ;wyswietlacz
	com r16                     
	out porte, r16  

	ldi r16, 0 ;segment 
	lds r18, var2 
	cp r18, r16 
	lds r17, var3
	brne bezzamiany 
	swap r17  
bezzamiany: 
	andi r17, 0x0f  
	add zl, r16  
	adc zh, r17 
	lpm r16, z  
	com r16  
	out portd, r16 

	pop r18 
	pop r17  
	pop r16  

	ret  
stop: rjmp stop
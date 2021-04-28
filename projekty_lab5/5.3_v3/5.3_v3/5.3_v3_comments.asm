;5.3_A
.CSEG
.ORG 0 
	ldi R16, HIGH(RAMEND)    
	out SPH, R16    
	ldi R16, LOW(RAMEND)    
	out SPL, R16    
//////////////////////////////   
	rjmp prog_start     
    .org 0x32  
	prime: .DB 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7F, 0x7B, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47	   
 .DSEG 
.ORG 0x100 
	var1: .BYTE 1				; ???
	var2: .BYTE 1				; ???
	var3: .BYTE 1				; ???
	.CSEG 

prog_start: 
	ldi r16, $ff    
	out ddre, r16 ;sterowanie wyswietlaczem		;STEROWANIE - port E
	out ddrd, r16 ;wyswietlanie					;DISPLAY - port D	
	out ddrb, r16  ;diody						;DIODY - port B

	ldi r16, low(15)	;M£ODSZE									
	ldi r17, high(15)	;STARSZE
	
	subi r16, low(38)	;M£ODSZE	
	sbci r17, high(38)	;STARSZE
    brvs przepelnienie				;Branch if Overflow Set -> if V set, go to przepelnienie			
	brpl znak						;Branch if Plus -> if N not set, go to przepelnienie
znak:													;dioda znaku
	brvs obie											;jeœli oprócz
        ldi r22, 0b100000
        out portb, r22
		rjmp licznik
przepelnienie:											;dioda przepe³nienia
	brpl obie
        ldi r23, 0b000100
        out portb, r23
		rjmp licznik
obie:													; dioda przepe³nienia + znaku
       ldi r23, 0b100100
       out portb, r23
	
	//////////////////////////licznik 
licznik: 
	call wyswietlanie 
	rjmp prog_start 
wyswietlanie: 
	ldi r18, 4 ; 1/5s
	petla: 
		call wait_sec 
		dec r18 
	brne petla 
;seg1 
		ldi r19,0x01 
		ldi r20,1 
		sts var1, r19 ;odczyt danych z pamiêci, zapisanie w  rejestrze ogólnego przeznaczenia
		sts var2, r20 
		sts var3, r16
		call seg1  
			call wait_sec 
;seg2 
		ldi r19,0x02 
		ldi r20,0
		sts var1, r19 
		sts var2, r20 
		sts var3, r16
		call seg1 
			call wait_sec 
;seg3 
		ldi r19,0x04 
		ldi r20,1
		sts var1, r19 
		sts var2, r20 
		sts var3, r17
		call seg1 
			call wait_sec 
;seg4 
		ldi r19,0x08 
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
		loop1:   
		ldi r18, 25
			loop2:   
			ldi r19, 100
				loop3:   
				dec r19   
				brne loop3	   
			dec r18   
			brne loop2   
		dec r17  
		brne loop1   
	dec r16     
	brne wait_sec   
pop r19  
pop r18   
pop r17   
pop r16   

Ret  


   
seg1:							   
	push r16 
	push r17 
	push r18  

	ldi zl, low(2*prime) 
	ldi zh, high(2*prime)    

	lds r16, var1 ;select display
	com r16                     
	out porte, r16  

	ldi r16, 0 ;select hex
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
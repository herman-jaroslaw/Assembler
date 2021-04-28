;5.3_v5_PM
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

	///21370
	ldi r16, 0x00 //0xC2 //starsze
	ldi r17, 0x05//0xFE	//mlodsze
	
	///14959
	subi r16,0x00
	sbci r17,0x02
	brmi znak
prz:
    brvs przepelnienie
	jmp licznik
znak:
        ldi r22, 0b0011  // jak minus to œwiec¹ siê dwa pierwsze LED-y  >>>
        out pinb, r22
		jmp prz																//(jak oba na tak to œwiec¹ wszystkie 4 LED-y)
przepelnienie:
        ldi r23, 0b1100 // jak przepe³nienie to œwieci siê 3 i 4 LED    >>>
        out pinb, r23 

	//////////////////////////licznik 
licznik: 
	call wyswietlanie
	rjmp prog_start 
wyswietlanie: 
	ldi r18, 2 ; r18 sluzy aby cyfry zmienialy sie co 1/5s 

	petla: 
		call wait_sec 
		dec r18 
	brne petla 
	//////////////////////seg1 
		ldi r19,0x01 
		ldi r20,1 
		sts var1, r19 
		sts var2, r20 
		sts var3, r16
		call seg1  
			call wait_sec 
///////////////////////seg2 
		ldi r19,0x02 
		ldi r20,0
		sts var1, r19 
		sts var2, r20 
		sts var3, r16
		call seg1 
			call wait_sec 
		////////////////////////////seg3 
		ldi r19,0x04 
		ldi r20,1
		sts var1, r19 
		sts var2, r20 
		sts var3, r17
		call seg1 
			call wait_sec 
			////////////////////////seg4 
		ldi r19,0x08 
		ldi r20,0 
		sts var1, r19 
		sts var2, r20	
		sts var3, r17
		call seg1 
			call wait_sec 
	ret 

	///////////////////////////////////opóŸnienie 
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
/////////////////////////////////////////////////////////////////////////////////////   
seg1:							   
	push r16 
	push r17 
	push r18  

	ldi zl, low(2*prime) ;mno¿enie przez dwa, celem uzyskania adresu w przestrzeni bajtowej 
	ldi zh, high(2*prime)    

	lds r16, var1 //////wybieranie wyœwietlacza 
	com r16                     
	out porte, r16  

	ldi r16, 0 /////////////wybieramy segmenty  
	lds r18, var2 
	cp r18, r16 
	lds r17, var3
	brne bezzamiany 
	swap r17  
bezzamiany: 
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
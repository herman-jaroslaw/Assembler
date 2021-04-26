;4.4_p

.include"m328PBdef.inc"   
	.CSEG   
	.ORG 0   
//////////////////////////////stos  
	ldi R16, HIGH(RAMEND)   
	out SPH, R16   
	ldi R16, LOW(RAMEND)   
	out SPL, R16   
//////////////////////////////  
	rjmp prog_start   
    .DSEG  
    .org 0x100  
	prime: .DB 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7F, 0x7B, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47, 0x47 	  
	.CSEG   


prog_start: 	/////////////////ustawianie wyjœæ
	ldi r16, $ff   
	out ddre, r16   
	out ddrd, r16 
	////////////////////////zerowanie liczników
	ldi r16, 0x00
	ldi r17, 0x00

	//////////////////////////licznik
licznik:
 
	call wyswietlanie
	inc r16 ; pierwsze dwa wyswietlacze
	brne licznik
	inc r17 ; drugie dwa wyœwietlacze
	brne licznik

	rjmp prog_start

wyswietlanie:
	ldi r18, 4 ; r18 sluzy aby cyfry zmienialy sie co 1/5s
	petla:
		call wait_sec
		dec r18
	brne petla

		call seg1 
			call wait_sec
		call seg2
			call wait_sec
		call seg3
			call wait_sec
		call seg4
			call wait_sec

	ret

	///////////////////////////////////opóŸnienie

wait_sec:  
	push r16  
	push r17  
	push r18  
	push r19  
	lds r16,1 
		lds r17,250
		opoznienie_1:  
		lds r18, 250  
			opoznienie_2:  
			lds r19, 5
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

	ldi zl, low(2*prime) ;mno¿enie przez dwa, celem uzyskania adresu w przestrzeni bajtowej
	ldi zh, high(2*prime)   

	ldi r16, 0x01 //////wybieranie wyœwietlacza
	com r16                    
	out porte, r16 

	ldi r16, 0 /////////////wybieramy segmenty 
	swap r17 
	andi r17, 0x0f 
	add zl, r17 
	adc zh, r16
	lpm r16, z 
	com r16 
	out portd, r16

	pop r17 
	pop r16 

	ret 

seg2: 

	push r16 
	push r17

	ldi zl, low(2*prime) 
	ldi zh, high(2*prime) 

	ldi r16, 0x02 
	com r16 
	out porte, r16 

	ldi r16, 0 
	andi r17, 0x0f 
	add zl, r17 
	adc zh, r16 ; a to co to to adc?
	lpm r16, z 
	com r16 
	out portd, r16 
  
	pop r17 
	pop r16  

	ret 
 

 seg3: 

	push r16
	push r17
 
	ldi zl, low(2*prime) 
	ldi zh, high(2*prime)   

	ldi r17, 0x04 
	com r17 
	out porte, r21  

	ldi r17, 0 
	swap r16 ; np. 0000 0010 -> 0010 0000; dziêki temu dopiero przy odpowiednim takcie seg3 zacznie wyœwietlaæ
	andi r16, 0x0f ;ale po co w sumie ???
	add zl, r16		; a to czemu ?
	;adc zh, r17 
	lpm r17, z 
	com r17 
	out portd, r17 
 
	pop r17 
	pop r16 
	ret 

seg4: ;skrajny prawy

	push r16 
	push r17 

	ldi zl, low(2*prime) 
	ldi zh, high(2*prime) 

	ldi r17, 0x08 
	com r17 
	out porte, r17  

	;ldi r17, 0 ;skoro 0 to mo¿na usun¹æ
	andi r16, 0x0f ;00001111 wy³uskanie 4 najm³odszych bitów (iloczyn logiczny)
	add zl, r16 
	;adc zh, r17 
	lpm r17, z ;load program memory - ³aduje jeden bajt z pamiêci programu (tu: z listy) do rejestru r17
	com r17 
	out portd, r17 ;wyœwietlenie cyfry

	pop r17 
	pop r16 
	ret   

stop: rjmp stop
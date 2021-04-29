;5.4_v2 -> AZ
;port b - LED
;port c - switch
;port d - 7hex display
;port e - 7hex control

.CSEG 
.ORG 0 
	ldi R16, HIGH(RAMEND)    
	out SPH, R16    
	ldi R16, LOW(RAMEND)    ;stack
	out SPL, R16    
 
	rjmp prog_start     
    .org 0x32  
	prime: .DB 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7F, 0x7B, 0x77, 0x1f, 0x4e, 0x3d, 0x4f, 0x47 	   ;lista
 .DSEG 
.ORG 0x100 
	var1: .BYTE 1  
	var2: .BYTE 1  ;parameters
	var3: .BYTE 1 
	.CSEG 

prog_start: 
	ldi r16, $ff    
	out ddre, r16    
	out ddrd, r16
	out ddrb, r16 

	ldi r16, high(-100) ;MS bits
	ldi r17, low(-100)	;LS bits
	
	subi r17, 0x20
	sbci r16, 0x00
	brmi znak
diodes:
    brvs overflow
	jmp dzielenie
znak:
		ldi r31,0
		ldi r30,1
		com r16
		com r17
		add r17,r30
		adc r16,r31
				
        ldi r22, 0b100000  
        out pinb, r22
		jmp diodes															
overflow:
        ldi r23, 0b001000 
        out pinb, r23 
dzielenie:

		;(F-32) * (1/2 + 1/16)
		;dzielenie przez 1/2
	asr r16			;arithmetic shift right/dividing U2 number by 2/LSB (bit 0) moved to C flag
	ror r17			;all bits moved one position to right -> flag C goes to bit 7 and bit 0 goes to flag C												
	mov r24, r16
	mov r25, r17
		 
	asr r16			; repeating same operation 3 times
	ror r17			
	asr r16
	ror r17
	asr r16
	ror r17
	add r17, r25	;(1/2 + 1/16)
	adc r16, r24	

start: 
	call wyswietlanie
	rjmp prog_start 
wyswietlanie: 
	ldi r18, 2 ; r18 -> changing numbers every 1/5s

	petla: 
		call wait_sec 
		dec r18 
	brne petla 
									 ;display1 
		ldi r19,0x08 
		ldi r20,1 
		sts var1, r19 
		sts var2, r20 
		sts var3, r17
		call seg1  
			call wait_sec 
									;display2
		ldi r19,0x04 
		ldi r20,0
		sts var1, r19 
		sts var2, r20 
		sts var3, r17
		call seg1 
			call wait_sec 
									;display3
		ldi r19,0x02 
		ldi r20,1
		sts var1, r19 
		sts var2, r20 
		sts var3, r16
		call seg1 
			call wait_sec 
									;display4
		ldi r19,0x01 
		ldi r20,0 
		sts var1, r19 
		sts var2, r20	
		sts var3, r16
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
;displays
seg1:							   
	push r16 
	push r17 
	push r18  

	ldi zl, low(2*prime) 
	ldi zh, high(2*prime)    

	lds r16, var1 
	com r16                     
	out porte, r16  

	ldi r16, 0 
	lds r18, var2 
	cp r18, r16 
	lds r17, var3
	brne no_swap 
	swap r17  
no_swap: 
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
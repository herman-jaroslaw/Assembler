;7.3_v1_KB

.include"m328pbdef.inc"

.cseg
.org 0
		jmp start
.org INT1addr
		jmp keypad_ISR			; Keyboard External Interrupt Request 2
.def button_code=r20
 
 
; Main program start
start:

	; Set Stack Pointer to top of RAM
	ldi r16, high(ramend)		
	out sph, r16
	ldi r16, low(ramend)
	out spl, r16

	;Set up port B as output for LED controls
	ldi r16, 0xff
	out ddrb, r16

	; Clear intf2 flag
	ldi r16, (1<<intf2)
	out gifr, r16

	; Enable Int2
	ldi r16, 0x20 
	out gicr, r16
	
	; Set Int2 active on falling edge
	ldi r16, 0
	out mcucsr, r16

	;Set rows as inputs and columns as outputs
	ldi r16, 0x0f
	out ddrc, r16

	;Set rows to high (pull ups) and columns to low to activate JP13
	ldi r16,0xf0
	out portc, r16

	;Global Enable Interrupt
	sei
 
	; Set up infinite loop
loop:

	;read button code from r20 and send to port B
	out portb, r20
	rjmp loop
 
 
;Keypad Interrupt Service Routine
keypad_ISR:

	;Disable interrupts
	cli

	;Store registers that are to be used in ISR on stack
	push r16

	;Set rows as outputs and columns as inputs on Port C
	ldi r16, 0xf0
	out ddrc, r16

	;Set rows to low and columns to high (pull up) on Port C
	ldi r16, 0x0f
	out portc, r16

	;Read Port C. Column code in lower nibble
	nop ;!!!!
	nop
	in r20, pinc

	;Store column code to r20 on lower nibble
	andi r20,0x0f

	;Set rows as inputs and columns as outputs on Port C
	ldi r16, 0x0f
	out ddrc, r16

	;Set rows to high (pull up) and columns to low on Port C
	ldi r16, 0xf0
	out portc, r16

	;Read Port C. Row code in higher nibble
	nop ;!!!!!
	nop
	in r16, pinc

	;Store row code to r20 on higher nibble
	andi r16, 0xf0
	or r20, r16

	;Set rows as inputs and columns as outputs
	ldi r16,0x0f
	out ddrc, r16

	;Set rows to high and columns to low to activate JP13
	ldi r16, 0xf0
	out portc, r16

	;Clear intf2 flag
	ldi r16, (1<<intf2)
	out gifr, r16

	;Restore registers from stack (in opposite order)
	pop r16

	;Enable interrupts globally
	sei
	reti



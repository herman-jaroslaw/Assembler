;7.2_v0
;
; Created: 2021-04-26 19:47:08
; Author : DELL
;


#include "m328pbdef.inc"			

.org 0 
	jmp main ;skip vector table 
.org PCINT0addr						;pocz¹tek programu ISR (procedury obs³ugi przerwania) dla tego przerwania
	jmp int0_isr
;------- main ---------- 
main: 
	ldi r16, LOW(RAMEND) ;initialize stack for ISR 
	out spl, r16 
	ldi r16, HIGH(RAMEND) 
	out sph, r16 

	sbi ddrb, 5 ;portb.5 is output (led0) 
	sbi portb, 7 ;pull-up enable for portd.2 
	ldi r20, (1<<pcint7)							;MSB in register pcmsk0
	sts pcmsk0, r20 ;enable int0					
	ldi r20, (1<<pcie0)
	sts pcicr, r20									;if high, reaction to interrupt			;sts: store r20 in pcicr (Pin Change Interrput Control)
	sei ;enable interrupts						
stop: 
	jmp stop ;stay forever 
;------- int0 ISR ------- 
int0_isr: 
	in r21, pinb ;read portb
	ldi r22, 0x20 ; HEX 20 = DEC 32 = BIN 0010 0000
	eor r21, r22 ;toggle bit 5 
	out portb,r21 
	reti
// 4.3

.include "328PBdef.inc"

.org 0x00 				
rjmp prog_start 			
.org 0x32 				
prime: .DB ~0x7e, ~0x30, ~0x6d, ~0x79, ~0x33, ~0x5b, ~0x5f, ~0x70, ~0x7F, ~0x7B, ~0x77, ~0x1f, ~0x4e, ~0x3d, ~0x4f, ~0x47, ~0x47

.org 0x100 				

prog_start: 	
		ldi R16,$ff
		ldi ddrd,R16
		ldi zl, low(2*prime)
		ldi zh, high(2*prime)

start:
		lpm r16, z+
		call outputled	
		call wait_subroutine
		rjmp start
	
outputled:	
		com r16
		out portd, r16
ret


wait_subroutine:
		push r16
		ldi r17,255

		wait1:
			ldi r16,255
			wait2:
				dec R16
				brne wait2
			dec R17
			brne wait1
		pop r16
		ret 
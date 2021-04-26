// 4.3

.include "328PBdef.inc"

.org 0x00
rjmp prog_start
.org 0x32
prime: .DB 2, 3, 5, 7, 11, 13, 17, 19, 23, 29

.org 0x100

prog_start:
        ldi R16,$00
        ldi R17,$ff
        out ddrd, R17
        ldi zl, low(2*prime)
        ldi zh, high(2*prime)

start:
        lpm r16, z+
        call outputled
        call wait
        rjmp start

outputled:
        com r16
        out portd, r16
ret


wait:
  push r16
  push r17
  loop1: 
    inc r18
    ldi r19, 255
    loop2: 
        ldi r16, 255
        loop3:
            ldi r17, 100
            loop4:
                dec r17
            brne loop4
        dec r16 
        brne loop3
    dec r19
    brne loop2
    cp r17, r20
    brne loop1
  pop r17
  pop r16
  ret
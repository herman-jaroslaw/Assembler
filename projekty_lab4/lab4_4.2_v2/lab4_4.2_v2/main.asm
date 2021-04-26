// 4.2

.include "328PBdef.inc"

.org 0x00                 ;org is not necessary here 
rjmp test             ;pass code execution to the right point in memory
.org 0x32                 ;Reserve data space at 0x32 address (16-bit addressing)
prime: .DB 0x7E, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b;Create array of the first ten primes in code memory
.org 0x100                 ;executable code starts here

test:
        ldi r16,$00
        ldi r17,$ff
        out ddre, R17
        ldi zl, low(2*prime)
        ldi zh, high(2*prime)
start:
        lpm r16, z+
        out porte, r16

        call delay
        cp r16, r17
        brne start
        rjmp test

delay:
    push r16
    push r17
    push r18

    ldi r16, 5 ;198
    delay1:
        ldi r17, 15 ;150
        delay2:
            ldi r18, 200; 8 
                delay3:
                    dec r18
                    brne delay3
            dec r17
            brne delay2
    dec r16
    brne delay1

    pop r18
    pop r17
    pop r16
    ret
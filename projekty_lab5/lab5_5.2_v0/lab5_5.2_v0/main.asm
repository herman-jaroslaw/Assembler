;
; lab5_5.2_v0.asm
;
; Created: 20.04.2021 18:51:32
; Author : Jaro & Karol
;


ldi r20, 0x60 ;0110 0000 (+96)
ldi r21, 0x46 ;0100 0110 (+70)
add r20, r21 ;(+96) +(+70) = 1010 0110
;V,N, r20 = A6

ldi r22, 70 
ldi r23, 96
add r22, r23
; V,N, r22=A6
ldi r24, -70
ldi r25, -96 
add r24, r25
; S,(V),(N?),C, R24=5A
ldi r26, -126  
ldi r27, 30
add r26, r27
; H,S,N, R26=A0
ldi r28, 126 
ldi r29, -6
add r28, r29
; H,C, R28=78
ldi r30, -2 
ldi r31, -5
add r30, r31
; H,C, R30=FE


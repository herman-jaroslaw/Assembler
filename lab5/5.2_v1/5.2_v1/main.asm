;
; 5.2_v1.asm
;
; Created: 26.04.2021 11:51:07
; Author : Jaro
;


ldi r20, 0x60 ;0110 0000 (+96)
ldi r21, 0x46 ;0100 0110 (+70)
add r20, r21 ;(+96) +(+70) = 1010 0110
;(unsigned)(+96) + (unsigned)(+70) = (unsigned)(166) OK
;(signed)(+96) + (signed)(+70) = (signed)(-90) INVALID !!!

;
; 5.2_v1.asm
;
; Created: 26.04.2021 11:51:07
; Author : Jaro
;


ldi r20, 0x60 ;0110 0000 (+96)
ldi r21, 0x46 ;0100 0110 (+70)
add r20, r21 ;(+96) +(+70) = 1010 0110
; Ustawione flagi: V, N

;KOD Z PDF:
;(unsigned)(+96) + (unsigned)(+70) = (unsigned)(166) OK
;(signed)(+96) + (signed)(+70) = (signed)(-90) INVALID !!!

ldi r20, 70
ldi r21, 96
add r20, r21
; Ustawione flagi: brak

ldi r20, -70 ;binary: 0b 0100 0110 [a]; U2: 0b 1011 1010 [c]
ldi r21, -96 ;binary: 0b 0110 0000 [b]; U2: 0b 1010 0000 [d]
add r20, r21 ;binary: 0b 1010 0110; U2: 0b 0101 1010; wynik = 90
; Ustawione flagi: S, C
;unsigned: 166 (a+b); signed: 346 (c+d)

ldi r20, -126
ldi r21, 30
add r20, r21
; Ustawione flagi: H, N

ldi r20, 126
ldi r21, -6
add r20, r21
; Ustawione flagi: C

ldi r20, -2
ldi r21, -5
add r20, r21
; Ustawione flagi: S, N




.include"328PBdef.inc"
.org 0x00 ;dyrektywa org nie jest konieczna
rjmp prog_start ;skok do programu g³ównego
.org 0x32 ;adres pocz¹tku listy danych dyrektywy DB
prime: .DB 2, 3, 5, 7, 11, 13, 17, 19, 23 ;stworzenie listy dziewiêciu liczb pierwszych
;w przestrzeni pamiêci programu
.org 0x100 ;adres pocz¹tku programu
prog_start: ldi r30, low(2*prime) ;mno¿enie przez dwa, celem uzyskania adresu
ldi r31, high(2*prime) ;w przestrzeni bajtowej

; 0x200 = e4
; 0x201 = e6
; 0x202 = f0
; 0x203 = e0
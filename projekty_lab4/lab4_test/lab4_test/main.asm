ldi r16, 0xff
out ddrd, r16 ;Ustawienie Port A jako wyj�cie
out ddre, r16 ;Ustawienie Port B jako wyj�cie
ldi r16, 0x01 ;Wyb�r pierwszego wy�wietlacza
com r16 ;Negacja, celem uzyskania aktywnego zera steruj�cego
out porte, r16 ;Aktywacja wy�wietlacza poprzez port B
ldi r16, 0x33 ;Kod cyfry 5
com r16 ;Negacja, celem uzyskania aktywnego zera steruj�cego
out portd, r16 ;Za�wiecenie segment�w odpowiedzialnych za �widzialno�� cyfry 5
stop: rjmp stop

ldi r16, 0xff
out ddrd, r16 ;Ustawienie Port A jako wyjœcie
out ddre, r16 ;Ustawienie Port B jako wyjœcie
ldi r16, 0x01 ;Wybór pierwszego wyœwietlacza
com r16 ;Negacja, celem uzyskania aktywnego zera steruj¹cego
out porte, r16 ;Aktywacja wyœwietlacza poprzez port B
ldi r16, 0x33 ;Kod cyfry 5
com r16 ;Negacja, celem uzyskania aktywnego zera steruj¹cego
out portd, r16 ;Zaœwiecenie segmentów odpowiedzialnych za „widzialnoœæ” cyfry 5
stop: rjmp stop

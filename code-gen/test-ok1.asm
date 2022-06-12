
osoba1_tezina:
		WORD	1
osoba1_visina:
		WORD	1
osoba1_godine:
		WORD	1
osoba2_tezina:
		WORD	1
osoba2_visina:
		WORD	1
osoba2_godine:
		WORD	1
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@main_body:
		MOV 	$11,-4(%14)
		MOV 	$10,osoba1_visina
		MOV 	$8,osoba2_tezina
		ADDS	osoba1_visina,$11,%0
		MOV 	%0,-4(%14)
		MOV 	osoba2_tezina,-8(%14)
		ADDS	-4(%14),-8(%14),%0
		MOV 	%0,%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET

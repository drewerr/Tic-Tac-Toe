macro reset/2
	ldi $2, 0b10000000
	st $1, $2
	ldi $2, 0b10010000
	st $1, $2
	ldi $2, 0b10100000
	st $1, $2
	ldi $2, 0b10000100
	st $1, $2
	ldi $2, 0b10010100
	st $1, $2
	ldi $2, 0b10100100
	st $1, $2
	ldi $2, 0b10001000
	st $1, $2
	ldi $2, 0b10011000
	st $1, $2
	ldi $2, 0b10101000
	st $1, $2
mend
#######################################################
asect 0x00
ldi r0, 0xf3

reset r0, r1

ldi r3, 3
while 
	tst r3
	ld r0, r1
	
	ldi r2, 128
	sub r1, r2
	if 
		tst r2
	is pl
		shla r1
		shla r1
		
		ldi r2, 128
		add r2, r1
		
		ldi r2, 2
		add r2, r1
		
		st r0, r1
	else
	
	fi
wend






#ldi r1, 0b10100001
#st r0, r1

#ldi r1, 0b10100110
#st r0, r1

#ldi r1, 0b10011011
#st r0, r1





#jsr 5
#ldi r0, 0x00
#ldi r1, 0b10100110
#st r0, r1


halt
end
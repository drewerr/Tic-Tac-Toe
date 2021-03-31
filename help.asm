asect 0x10
ldi r0, row1
ldi r1, 123
st r0, r1
inc r0
ldi r1, 13
st r0, r1

ldi r0, row2
ldi r1, 35
st r0, r1


halt
asect 0x00 	
	row1: ds 3
	row2: ds 3
	row3: ds 3
	#array: dc row1, row2, row3
end
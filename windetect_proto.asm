asect 0x00
inputs>
field: dc 1,2,2,0
dc 1,2,2,0
dc 2,1,1,0
endinputs>
asect 0x0c
##### REFRESH DATA - PART 1 #####
# r0 - how many mems are already written / cyclic constant (r1+3)
# r1 - address for taking / cyclic constant (8)
# r2 - symbols / address to store sum
# r3 - sum to store

ldi r0, 0
ldi r1, 8
while
	cmp r0, r1
stays lt
	ldi r1, table
	add r0,r1
	add r0,r1
	add r0,r1 # r1 has address for the row to be summed
	push r0
	ldi r0,3
	add r1,r0 #r0 has 
	while
		cmp r0,r1
	stays gt
		ld r1,r2
		ld r2,r2 # r2 has i-th symbol of that row
		dec r2
		if 
			tst r2
		is ge # if we have nought or cross
			inc r3
			if 
				tst r2
			is gt # if we have cross
				inc r3
				inc r3
				inc r3
			else 
			fi
		else # if we have nothing
		fi
		inc r1
	wend
	pop r0 # r3 has value to store. r0 must remain
	ldi r2, mem
	add r0, r2 # r2 has address to store sum
	st r2, r3
	ldi r3, 0 # setting for next iteration
	inc r0
	ldi r1, 8
wend
##### CHECK RESULT - PART 2 #####
# here we have 8 values in mem waiting to be checked
# r0 - how many mems are already checked
# r1 - mem address
# r2 - cyclic const (8) / i-th mem value
# r3 - res (if needed) / comparing values

ldi r0, 0
ldi r2, 8
ldi r1, mem
while
	cmp r0,r2
stays lt # while not all mems checked
	ld r1,r2 # r2 has i-th mem's value
	ldi r3, 3
	if
		cmp r2,r3
	is eq # if i-th mem signalizes that 0 wins
		ldi r0, 0xf3
		ldi r3, 1
		br end
	else
		ldi r3, 12
		if 
			cmp r2,r3
		is eq # if i-th mem signalizes that X wins
			ldi r0, 0xf3
			ldi r3, 2
			br end
		else
		fi
	fi
	# if we are here - no one won due to i-th mem
	inc r0 # setting for next iteration
	inc r1
	ldi r2, 8
wend
ldi r3, 0 # if we are here - no one has won
ldi r0, 0xf3
end:

halt

### STORAGE SPACE
asect 0xd0
table: # each triplet below represents a line of three cells
dc 0,1,2 # horizontal lines
dc 4,5,6
dc 8,9,10
dc 0,4,8 # vertical lines
dc 1,5,9
dc 2,6,10
dc 0,5,10 # diagonal lines
dc 8,5,2
mem: ds 4
ds 4
end
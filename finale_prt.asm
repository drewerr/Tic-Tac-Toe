### PRE-EXECUTION SETTINGS   ###
### FOR GSDD NOT TO SHOW WIN ###
################################
	asect 0x00
	ldi r0, 0xf3
	ldi r1, 0b10000000
	st r0, r1
	br st


##########################
# 	PUT-IN SUBROUTINE    #
# input data:			 #
# r2 - address of a cell #
# r1 - symbol_id 	 	 #
##########################
subr:
	st r2,r1 # putting symbol in our table
	ldi r0, 2

	if # adding 1 to cnt if writing cross (tie-checking)
		cmp r1,r0
	is eq
		ldi r0, cnt
		ld r0,r0
		inc r0
		ldi r3, cnt
		st r3, r0
	fi

	shla r2 # moving address to its place in package
	shla r2
	
	push r2 # we will need all registers, saving r1 and r2
	push r1
	
	ldi r0, 0 # preparation
	ldi r1, 8
	ldi r3, 0
	while
		cmp r0, r1
	stays lt
		ldi r1, table
		add r0,r1
		add r0,r1
		add r0,r1 # r1 has address for the row to be summed
		push r0
		ldi r0,3
		add r1,r0 # r0 has cyclic constant
		while
			cmp r0,r1
		stays gt
			ldc r1,r2
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
			# else
			fi
			# else if we have nothing
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

	ldi r0, cnt
	ld r0,r0
	ldi r1, 5
	
	if # checking for tie
		cmp r0,r1
	is eq
		ldi r3, 192
		ldi r0, 0xf3
		br end
	fi
	
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
			ldi r3, 64
			br end
		else
			ldi r3, 12
			if
				cmp r2,r3
			is eq # if i-th mem signalizes that X wins
				ldi r0, 0xf3
				ldi r3, 0
				br end
			fi
		fi
			   # if we are here - no one won due to i-th mem
		inc r0 # setting for next iteration
		inc r1
		ldi r2, 8
	wend
	ldi r3, 128 # if we are here - no one has won
	ldi r0, 0xf3
end:
	pop r1 # taking symbol_id and moved address
	pop r2 # back into registers
	
	add r1, r2 # add symbol to address
	add r3, r2 # add res
	
	st r0, r2 # send it on tttc
	
	ldi r2, 128 # if game is over, go to halt
	if
		cmp r3, r2
	is ne
		br e
	fi
	
	dec r1 # determining where we need to return by symbol
	if
		tst r1
	is eq
		br t2
	else
		br t1
	fi


#################
### MAIN LOOP ###
#################

st:
	addsp 0x80 # moving sp from 0xf*
	
	ldi r0, 0x03 # adjusting memory for AI to work
	ldi r1, 1
	st r0, r1
	ldi r0, 0x07
	st r0,r1
	
	ldi r0, 0xf3 # IO address
	
	while # endless while
		tst r0
	stays lt
new:	ld r0, r1 # load new input value
		ldi r2, 128
		sub r1, r2
		
		if
			tst r2 # check ready flag
		is pl
		
			ld r2, r3 # if already occupied, do not write
			if
				tst r3
			is nz
				br new
			fi

			ldi r1,2
			br subr # put-in subroutine
			
t1:			ldi r2, 0x00 # AI section
			ld r2, r1 # determining next (by address) free cell
			while
				tst r1
			stays gt
				inc r2
				ld r2, r1
			wend
		
			ldi r1, 1 
			br subr # put-in subroutine
t2:		fi
	wend
e:
	halt
	
####################	
### DATA SECTION ###
####################

asect 0xca # stored in code memory, because we need constants
	# each triplet below represents a line of three cells
	table: dc 0,1,2 # horizontal lines
	dc 4,5,6
	dc 8,9,10
	dc 0,4,8 # vertical lines
	dc 1,5,9
	dc 2,6,10
	dc 0,5,10 # diagonal lines
	dc 8,5,2
	
asect 0x10 # stored in data memory: we need to store our data
cnt:
asect 0x11
mem:
end
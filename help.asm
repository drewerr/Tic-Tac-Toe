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

macro proverka/2

	ldi $2, 0x00 
	ldi $1, 0x01
	ld $1, $1
	sub $2, $1
	if 
		tst $1
	is eq
		ldi $1, 0x02
		ld $1, $1
		sub $2, $1
		if
			tst $1
		is eq
			ldi $1, 0xf5
			st $1, $2
		fi
	fi	
#------------------------	
	ldi $2, 0x04 
	ldi $1, 0x05
	ld $1, $1
	sub $2, $1
	if 
		tst $1
	is eq
		ldi $1, 0x06
		ld $1, $1
		sub $2, $1
		if
			tst $1
		is eq
			ldi $1, 0xf5
			st $1, $2
		fi
	fi

#------------------------
	ldi $2, 0x08 
	ldi $1, 0x09
	ld $1, $1
	sub $2, $1
	if 
		tst $1
	is eq
		ldi $1, 0x0A
		ld $1, $1
		sub $2, $1
		if
			tst $1
		is eq
			ldi $1, 0xf5
			st $1, $2
		fi
	fi

#------------------------
	ldi $2, 0x00 
	ldi $1, 0x04
	ld $1, $1
	sub $2, $1
	if 
		tst $1
	is eq
		ldi $1, 0x08
		ld $1, $1
		sub $2, $1
		if
			tst $1
		is eq
			ldi $1, 0xf5
			st $1, $2
		fi
	fi
#------------------------
	ldi $2, 0x01 
	ldi $1, 0x05
	ld $1, $1
	sub $2, $1
	if 
		tst $1
	is eq
		ldi $1, 0x09
		ld $1, $1
		sub $2, $1
		if
			tst $1
		is eq
			ldi $1, 0xf5
			st $1, $2
		fi
	fi
#------------------------
	ldi $2, 0x02 
	ldi $1, 0x06
	ld $1, $1
	sub $2, $1
	if 
		tst $1
	is eq
		ldi $1, 0x0A
		ld $1, $1
		sub $2, $1
		if
			tst $1
		is eq
			ldi $1, 0xf5
			st $1, $2
		fi
	fi
#------------------------
	ldi $2, 0x00 
	ldi $1, 0x05
	ld $1, $1
	sub $2, $1
	if 
		tst $1
	is eq
		ldi $1, 0x0A
		ld $1, $1
		sub $2, $1
		if
			tst $1
		is eq
			ldi $1, 0xf5
			st $1, $2
		fi
	fi
#------------------------
	ldi $2, 0x08 
	ldi $1, 0x05
	ld $1, $1
	sub $2, $1
	if 
		tst $1
	is eq
		ldi $1, 0x02
		ld $1, $1
		sub $2, $1
		if
			tst $1
		is eq
			ldi $1, 0xf5
			st $1, $2
		fi
	fi
#------------------------
	ldi $2, 0x00
	if 
		tst $2
	is ne
		ldi $2, 0x04
		if 
			tst $2
		is ne
			ldi $2, 0x08
			if 
				tst $2
			is ne
				ldi $2, 0x01
				if 
					tst $2
				is ne
					ldi $2, 0x05
					if 
						tst $2
					is ne
						ldi $2, 0x09
						if 
							tst $2
						is ne
							ldi $2, 0x02
							if 
								tst $2
							is ne
								ldi $2, 0x06
								if 
									tst $2
								is ne
									ldi $2, 0x06
									if 
										tst $2
									is ne
										ldi $1, 0xf5
										ldi $2, 0x03
										st $1, $2
									fi
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi
#------------------------

mend
#######################################################
asect 0x0b
ldi r0, 0xf3
#reset r0, r1

ldi r2, 1 # pushing 1-s to 0x03 and 0x07 for the AI loop to work
ldi r1, 3
st r1,r2
ldi r1, 7
st r1,r2

ldi r3, 3
while 
	tst r3
new:ld r0, r1
	
	ldi r2, 128
	sub r1, r2
	if 
		tst r2 #check ready flag
	is pl
		ldi r1, 2 # if ready we need to write this value in table (address like 0b0000xxxx) xxxx-cell address
		
		ld r2,r3  # if already occupied, do not write
		if
			tst r3
		is eq
			st r2, r1
			ldi r3, 3
		else 
			br new
		fi
		
		shla r2 #making value to send it on tttc
		shla r2
		
		### TODO CHECK: IF GAME NOT OVER AFTER HUMAN - SEND CROSS
		### AND MAKE COMPUTER MOVE
		ldi r1, 130 # making score AND making symbolid (cross)
		add r1, r2 
		
		st r0, r2  # sending it on tttc
		
		ldi r1, 0x00 # AI section
		ld r1,r2
		while 
			tst r2
		stays ne
			inc r1
			ld r1,r2
		wend # now in r1 we have address to put our nought to
		
		shla r1
		shla r1
		
			### TODO CHECK: IF GAME NOT OVER AFTER AI - SEND NOUGHT
			ldi r2,129 # making score AND making symbolid (nought)
			add r1,r2
			
			st r0,r2 # sending it on tttc
			### TODO CHECK: ELSE SEND NOUGHT AND RESULT
			
			
		### TODO CHECK:ELSE (IF GAME OVER AFTER HUMAN) - SEND CROSS
		### AND RESULT 

	else
	fi
wend
halt
end

#proverka r1, r2
#		ldi r2, 1
#		sub r1, r2
#		if
#			tst r2
#		is eq
#		else
#		
#		fi
#		
#		ldi r1, 0x05
#		ld r1, r1
#		ldi r2, 2
#		sub r1, r2
#		if
#			tst r2
#		is eq
#			ldi r1, 0x04
#			ld r1, r1
#			ldi r2, 1
#			sub r1, r2
#			if
#				tst r2
#			is eq
#			
#			else
#				ldi r1, 0b10100001
#				st r0, r1
#				ldi r1, 0x00
#				ldi r2, 1
#				st r1, r2
#			fi	
#		else		
#		fi
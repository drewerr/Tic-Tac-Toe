### PRE-EXECUTION SETTINGS FOR AI LOOP ###
asect 0x03
dc 1
asect 0x07
dc 1
asect 0xf3
dc 0b10000101
asect 0x0b
br st


##########################
# PUT-IN SUBROUTINE #
# r2 - address of a cell #
# r1 - symbol_id #
##########################
subr:
st r2,r1 # putting symbol in our table

shla r2
shla r2

push r2
push r1
ldi r0, 0
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
ldc r2,r2 # r2 has i-th symbol of that row
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

ldi r0, 0
ldi r2, 8
ldi r1, mem
while
cmp r0,r2
stays lt # while not all mems checked
ldc r1,r2 # r2 has i-th mem's value
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
#else
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
pop r1
pop r2

add r1, r2 # add address
add r3, r2 # add res

st r0, r2 # sending it on tttc

ldi r2, 64
if
cmp r3, r2
is eq
br e
fi
ldi r2, 0
if
cmp r3, r2
is eq
br e
fi

dec r1
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
ldi r0, 0xf3 # IO address

while
tst r0
stays lt
new:ldc r0, r1
ldi r2, 128
sub r1, r2
if
tst r2 # check ready flag
is pl
ldc r2, r3 # if already occupied, do not write
if
tst r3
is nz
br new
fi

ldi r1,2
br subr # res subroutine
t1:
ldi r2, 0x00 # AI section
ldc r2, r1
while
tst r1
stays ne
inc r2
ldc r2, r1
wend # now in r1 we have address to put our nought to

ldi r1, 1 # putting nought to our table
br subr # res subroutine
t2:


fi
wend
e:
halt
asect 0xd0
# each triplet below represents a line of three cells
table: dc 0,1,2 # horizontal lines
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
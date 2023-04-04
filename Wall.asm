#Name: Grace Wall
#NetID: glw210000

#project 2

#note to grader - I realized after the fact that I was not supposed to take input from console,
#however, I emailed YZ about this and he said that it I could keep it the way it is. thank you -  grace

#config
#made 3 arrays - 2 input and one for the merged list
#all values stored in ascending order
#took user input and filled the arrays, giving an error if the input wasn't in ascending order(and ending program)
#checked if the first value of one array was less than the first of the second, 
#added whichever value was lower to the merged list, and moved the index of whichever input list it came from,
#did above comparison until all integer values added to the merged list
#printed the merged list
#ended program

.data #data section of the program

arg0: #assume its 3 numbers - arg0 is array to store first ordered int list
	.space 12#allocating just the space since i took user input for int values		

arg1:	#assume its know to be 3 nums - arg1 is array to  store second ordered int list
	.space 12#allocating just the space since i took user input for int values
	
ordered: #where MERGED LIST is to be stored 

	.space 24#allocate space so all of the integers from both input lists would fit perfectly
	
seperation: #used to seperate values when printing ordered list in output
	.asciiz ", "

instructions1: #gives users instructions to enter values for first input array
	.asciiz "Please enter 3 integers in ascending order for the first list >>> \n"
	
instructions2: #gives users instructions to enter values for the second ordered list
	.asciiz "Please enter 3 integers in ascending order for the second list >>> \n"

errormessage:#message to be printed if values are not entered in ascending order.
	.asciiz "error: integers were not entered in ascending order. program terminating."
	
	.text
	.globl main
	


main:
	#print user instructions
	la $a0, instructions1
	li $v0, 4
	syscall
	
	#read int from console
	li $v0, 5 #code to read integer
	syscall  #reads integer from console
	
	#input first int of arg0
	la $t1, arg0	#loads the address of the first array for use putting the values in the array	
	sw $v0, 0($t1) #saves the integer just read to the array
	
	#read int from console
	li $v0, 5 
	syscall 
	
	#input 2nd int of arg0		
	sw $v0, 4($t1) #saves the integer just read by syscall into the second byte of the array (offset 4 to put in second byte)
	lw $t3, 0($t1) #gets the first value entered into the array to check if in ascending order below
	blt $v0, $t3, error #gives an error statement if the values aren't in ascending order	
	
	#read int from console
	li $v0, 5 
	syscall 
	
	#input 3rd int of arg0	
	sw $v0, 8($t1) 
	lw $t3, 4($t1)
	blt $v0, $t3, error #gives error message if values aren't in ascending order
	
	#print instructions so they know they are now entering values for the second list.
	la $a0, instructions2
	li $v0, 4 #print string call
	syscall #prints string (instructions 2)
	
	#read int from console
	li $v0, 5 #call to read int from console
	syscall #reads int 
	
	#input first int of arg1
	la $t1, arg1	#sets the address of the second input array to a variable to help set it's values	
	sw $v0, 0($t1) 	# saves value of the first int entered to the second array
	
	#read int from console
	li $v0, 5 
	syscall 
	
	#input 2nd int of arg1		
	sw $v0, 4($t1) 	
	lw $t3, 0($t1)
	blt $v0, $t3, error #gives error message if not in ascending order
	
	#read int from console
	li $v0, 5 
	syscall 
	
	#input 3rd int of arg1	
	sw $v0, 8($t1) 	
	lw $t3, 4($t1)
	blt $v0, $t3, error #gives error message if not in ascending order and terminates program
	
	
	# initialize indexes / offset value for each array as 0
	li $s0,  0 #index of arg0 = $s0
	li $s1, 0 #index of arg1 = $s1
	li $s2, 0 #saves index of returned array (index of ordered = $s2)
	
	addi $t4, $t4, 0 #sets a value to be used as index when outputting the values later in output:
	#note: initialized t4 here so that it wouldn't be carried out an unnecessary # of times as output: is branched to multiple times
	
while:
	lw $t2, arg0($s0)#creates temporary variable with the value at the working index of arg0
	lw $t3, arg1($s1)#creates temporary variable with the value at the working index of arg1
	
	beq $s0, 12, oneless #jumps to add final value of arg1 if arg0 has already had all its values added to merged list
	blt $t3, $t2, oneless #goes to add the current arg1 array value to merged list if the value is less
	
zeroless:
	sw $t2, ordered($s2) #saves arg0 value to merged list...
	add $s0, $s0, 4 #increments working index of arg0 array
	add $s2, $s2, 4 #increments offset index in merged list
	j conditional #jumps to the comparison that sees if the loop needs to be gone through again
	
oneless : 
	beq $s1, 12, zeroless #jumps to add final arg0 value if all arg1 values are already in merged list
	sw $t3, ordered($s2) #saves current arg1 value to the merged list
	add $s1, $s1, 4 #increments working index of arg1 array...
	add $s2, $s2, 4 # increments offset of merged list

conditional: #checks if either input list has not been fully added to merged list
	bne $s0, 12, while 
	bne $s1, 12, while
	
output:
	lw  $t5, ordered($t4) #load the integer to be printed 
	move $a0, $t5 #set integer to be printed as the value of the current index of the merged list
	li $v0, 1 #set to print an integer
	syscall # print the int.
	
	la $a0, seperation #adds the previously declared comma and space
	li $v0, 4 #string call code
	syscall #prints comma and space 
	
	add $t4,$t4,4 #increases index so that next value will be printed.
	bne $t4, 24, output #goes to print next index if haven't printed entire merged list
	j fin #skips error statement and ends program
	
error: #prints error message if values aren't entered in ascending order, before program is terminated 
	la $a0, errormessage
	li $v0, 4
	syscall
	
fin:
	li	$v0, 10		#returns value of 10 - so syscall will terminate program below
	syscall			#ends program... (terminate code 10 above)
	
	
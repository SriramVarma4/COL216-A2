 .data 
 
# 100 characters space for the input string
inputstr: 	.space 		100

# other important variables for checking for errors
x:		.word 		43
y:		.word 		45
z:		.word 		42
d:		.word 		10

# digits limits in ascii
diglow:		.word 		48
dighig:		.word 		57

# error messages to print
errormsgchar: 	.asciiz 	": Character not defined, exiting"
errormsgstak: 	.asciiz 	"Incorrect Postfix expression, exiting"

##Debug
#debug: .asciiz "debug|"

#newline character for cleanliness
newline: .asciiz "\n"

.text
.globl main
.ent main

main:
	# take user input a string which will be stored in inputstr var
    li $v0, 8
    la $a0, inputstr
    li $a1, 100
    syscall
  
    # to keep a check of number of elements in stack, we will use $s5
    li $s5, 0
    li $t0, 0
    
    # goto processloop    
    j processloop
    
processloop:

    # loop over each character in string
    la $t7, inputstr
    add $t7, $t7, $t0
    lb $t1, 0($t7)
    # current character's ascii value in $t1 & position of current char in $t0

    # check if current character is newline
    lbu $t4, d 
    beq $t1, $t4, endloop
    
    # check if character is an operator, then goto operatorloop
    
    # plus:43
    lw $t4, x
    beq $t1, $t4, plusloop
    
    # minus:45
    lw $t4, y
    beq $t1, $t4, minusloop
    
    # mult:42
    lw $t4, z
    beq $t1, $t4, multloop

    # else add word to stack
    
    # check if character is a digit
    
    # 9:57
    lw $t4, dighig
    bgt $t1, $t4, errorchar
    
    # 0:48
    lw $t4, diglow
    blt $t1, $t4, errorchar
    
    # get value of digit in $t1 by subtracting 48 from ascii value
	sub $t1,$t1,$t4
	
	# adding character to stack
    subu $sp, $sp, 4
    sw $t1, ($sp)
    
    # incrementing stack count by 1
    addi $s5, 1
	
	
	j processloopend
	
processloopend:

    # incrementing position of character in string
    addi $t0, $t0,1
    j processloop

plusloop:

    # check if stack has insufficient characters
    blt $s5, 2, stackerror
    
    # take $t2, $t3 as top two inputs
    
    lw $t2, ($sp)
    addu $sp, $sp, 4
	
    lw $t3, ($sp)
    addu $sp, $sp, 4
	
    # get output of add onto $t4
    add $t4, $t3, $t2
	
    # push t4 onto stack 
    subu $sp, $sp, 4
    sw $t4, ($sp)
    
    # removing 1 from stack count
    addi $s5, -1

    # goto processloopend 
    j processloopend
    
minusloop:

    # check if stack has insufficient characters
    blt $s5, 2, stackerror

    # take $t2, $t3 as top two inputs
    
    lw $t2, ($sp)
    addu $sp, $sp, 4
    
    lw $t3, ($sp)
    addu $sp, $sp, 4

    # get output of add onto $t4
    sub $t4, $t3, $t2

    # push t4 onto stack 
    subu $sp, $sp, 4
    sw $t4, ($sp)

	# removing 1 from stack count
    addi $s5, -1

    # goto processloopend 
    j processloopend
	
multloop:

    # check if stack has insufficient characters
    blt $s5, 2, stackerror

    # take $t2, $t3 as top two inputs
    
    lw $t2, ($sp)
    addu $sp, $sp, 4
    
    lw $t3, ($sp)
    addu $sp, $sp, 4

    # get output of add onto $t4
    mul $t4, $t3, $t2

    # push t4 onto stack 
    subu $sp, $sp, 4
    sw $t4, ($sp)

	# removing 1 from stack count
    addi $s5, -1

    # goto processloopend 
    j processloopend

errorchar:
	
	# printing error char
	li $v0, 11
	move $a0, $t1
	syscall
	
	# printing error message 
	li $v0, 4
	la $a0, errormsgchar
	syscall
	
	j endmain	

stackerror:
	
	# printing error message
	li $v0, 4
	la $a0, errormsgstak
	syscall
	
	j endmain
	
endloop:

	# check if stack only has one element
	bne $s5, 1, stackerror
	
    # print top element in stack
    
    # getting the top element in $t9
    lw $t9, ($sp)
    addu $sp, $sp, 4
    
    #printing $t9
    li $v0, 1
	move $a0, $t9
    syscall
    
    j endmain
    
endmain:

	# printing newline 
	li $v0, 4
	la $a0, newline
	syscall
	
    # end system
    li $v0, 10
    syscall


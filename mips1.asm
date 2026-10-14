.data
	BoardState: .word 268505088
	Pixels: .word 268500992
	ReadyBit: .word 4294901760
	ASCIIChar: .word 4294901764

#268500992 is where pixels begin
#268505088 is where game board begin


.text

main:




li $s1, 0
li $s2, 0


DeclareInitialBoardState:


li $a0, 69
move $a1, $s1
move $a2, $s2

jal UpdateBoardState

beq $s2, 2, IncreaseRow
addi $s2, $s2, 1
j EndIncreaseRow
IncreaseRow:
addi $s1, $s1, 1
li $s2, 0
EndIncreaseRow:

bne $s1, 3, DeclareInitialBoardState

li $s0, 0
li $s1, 0









jal PrintBoardStateToConsole












GameLoop:

jal ReadInput




move $a0, $v0
li $v0, 11
#syscall


jal MovePosition



li $a0, 150
syscall
syscall
syscall
syscall
syscall
syscall
syscall
li $a0, 10
syscall

jal PrintBoardStateToConsole









bne $a0, 114, GameLoop














j ProgramTerminate



#   Args: $a0 = char
#         $a1 = row
#         $a2 = col
UpdateBoardState:
mul $t0, $a1, 3
mul $t0, $t0, 4
mul $t1, $a2, 4
add $t1, $t1, $t0
lw $t2, BoardState
add $t3, $t2, $t1

sw $a0, 0($t3)

li $a0, 0
li $a1, 0
li $a2, 0
li $t0, 0
li $t1, 0
li $t2, 0

jr $ra



PrintBoardStateToConsole:


li $v0, 11
lw $t0, BoardState
li $t1, 0
addi $t2, $t0, 36
addi $t3, $t0, 36

PrintChars:

lw $a0, 0($t0)
syscall
li $a0, 32
syscall

addi $t0, $t0, 4
beq $t1, 2, PrintNewLine
addi $t1, $t1, 1
j EndPrintNewLine
PrintNewLine:
li $a0, 10
syscall
li $t1, 0
EndPrintNewLine:
bne $t0, $t3, PrintChars


jr $ra



ReadInput:


DetectReadyBit:
lw $t1, ReadyBit
lw $t2, 0($t1)
bne $t2, 1, DetectReadyBit

lw $t1, ASCIIChar
lw $v0, 0($t1)

jr $ra

#	ARGS	$a0 = input
#		$a1 = row
#		$a2 = col
MovePosition:

move $t0, $s0
move $t1, $s1

beq $a0, 119, WKey
beq $a0, 100, DKey
beq $a0, 115, SKey
beq $a0, 97, AKey
beq $a0, 32, SpaceKey



j EndMoveCall

WKey:
ble $s0, 0, EndMoveCall
addi $s0, $s0, -1
j EndMoveCall
DKey:
bge $s1, 2, EndMoveCall
addi $s1, $s1, 1
j EndMoveCall
SKey:
bge $s0, 2, EndMoveCall
addi $s0, $s0, 1
j EndMoveCall
AKey:
ble $s1, 0, EndMoveCall
addi $s1, $s1, -1
j EndMoveCall
SpaceKey:
move $t7, $ra
move $a1, $s0
move $a2, $s1








EndMoveCall:

move $t7, $ra

li $a0, 69
move $a1, $t0
move $a2, $t1
jal UpdateBoardState


li $a0, 101
move $a1, $s0
move $a2, $s1
jal UpdateBoardState

move $ra, $t7
jr $ra


GetChar:
mul $t0, $a1, 3
mul $t0, $t0, 4
mul $t1, $a2, 4
add $t1, $t1, $t0
lw $t2, BoardState
add $t3, $t2, $t1

lw $a0, 0($t3)

jr $ra




ProgramTerminate:

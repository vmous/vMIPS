ori $3 $0 3
sw $3 0($0)
ori $3 $0 4
sw $3 4($0)
ori $3 $0 2
sw $3 8($0)
ori $3 $0 1
sw $3 12($0)
ori $3 $0 7
sw $3 16($0)
#initialize
ori $9 $0 5
ori $14 $0 4
ori $2 $0 0
ori $3 $0 0
inloop:
mult $2, $14
mflo $15
lw $4 0($15) 
mult $3, $14
mflo $15
lw $5 0($15)
slt $6 $4 $5
beq $6 $0 skip
mult $3, $14
mflo $15
sw $4 0($15) 
mult $2, $14
mflo $15
sw $5 0($15)
skip:   
addi $2 $2 1
bne $2 $9 inloop
outloop:
addi $3 $3 1
ori $2 $3 0
bne $3 $9 inloop
#Just to see everything to pass through BusW
lw $7 0($0)
lw $7 4($0)
lw $7 8($0)
lw $7 12($0)
lw $7 16($0)

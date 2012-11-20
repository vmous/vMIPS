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

ori $9 $0 20
ori $2 $0 0
ori $3 $0 0
inloop:
lw $4 0($2) 
lw $5 4($2)
slt $6 $4 $5
bne $6 $0 skip
sw $4 4($2) 
sw $5 0($2)
skip:   
addi $2 $2 4
bne $2 $9 inloop
outloop:
addi $3 $3 4
ori $2 $0 0
bne $3 $9 inloop

lw $7 0($0)
lw $7 4($0)
lw $7 8($0)
lw $7 12($0)
lw $7 16($0)
lw $7 16($0)

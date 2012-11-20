init:
addi $1, $0, 1
addi $2, $1, 1
addi $3, $2, 1
ori $5, $0, 3
funct:
bgezal $5, loop1
jal loop2
J funct
loop1:
sub $5, $5, $1
jr $31
loop2:
jr $31

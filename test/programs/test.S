# Put DEADBEEF in x28
addi x28, x28, 0x777
addi x17, x0, 1
sll x28, x28, x17
add x28, x28, x17
lui x28, 0xDEADB

#AUIPC test
auipc x29, 0xA55A0

#Slt & Branch test
sltu x10, x28, x29
slt x1, x28, x29
bne x10, x10, yeet
beq x0, x1, yeet

yeet:srli x29, x29, 1
slli x29, x29, 1
sra x29, x29, 1
jal x2, procedure
sw x3, 8(x31) 
lw x9, 8(x31)

procedure: sub x31, x29, x28
xor x3, x29, x28
jalr x2


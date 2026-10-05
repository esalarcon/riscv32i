.section .text
.global _start

/*Pongo el Stack al fondo de la memoria y salto a main*/
_start:
	lui  sp, %hi(_stack_ptr)
	addi sp, sp, %lo(_stack_ptr)

/*Variables Inicializadas*/
	lui  x3, %hi(_rdata)
	addi x3, x3, %lo(_rdata)
	lui  x4, %hi(_sdata)
	addi x4, x4, %lo(_sdata)
	lui  x5, %hi(_edata)
	addi x5, x5, %lo(_edata)
InicLoop:
	beq  x4, x5, Inicbss
	lw   x6, 0(x3)
	sw   x6, 0(x4)
	addi x3, x3, 4
	addi x4, x4, 4
	jal  zero, InicLoop
Inicbss:
	lui  x3, %hi(_sbss)
	addi x3, x3, %lo(_sbss)
	lui  x4, %hi(_ebss)
	addi x4, x4, %lo(_ebss)
Loopbss:	
	beq  x3, x4, JumpMain
	sw   x0, 0(x3)
	addi x3, x3, 4
	jal  zero, Loopbss  
JumpMain:
	jal zero,main



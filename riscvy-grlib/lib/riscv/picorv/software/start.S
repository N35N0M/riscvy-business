/* This linker file is based on the original one(s) by Clifford Wolf, located in the official PicoRV repository. */
// Most of the comments here are just to keep track of what's going on for someone unfamiliar with RISC-V assembly.

#include "custom_ops.S"

.section .text
.global _ftext
.global _pvstart
.global reset_vec
.global stackPointerAddr
.global irq

reset_vec:
	// no more than 16 bytes here !
	// What do the following two lines do...?
	// picorv32_waitirq_insn(zero) 
	// picorv32_maskirq_insn(zero, zero)
	j _pvstart


/* Interrupt handler */

.balign 16
irq_vec:
	/* SAVE REGISTERS */
    // Q regs q2 and q3 (temporary storage) are loaded with general reg x1 (return address for jumps) and x2 (stack pointer)
	picorv32_setq_insn(q2, x1)
	picorv32_setq_insn(q3, x2)

	// irqregs is a memory region defined a tad down below.
    // lui = Load Upper Immediate, x1 is loaded with the higher order bits of the address to irq_regs
    // addi = "add immediate, add sign-extended 6-bit immediate to the value in register rd then writes the result to rd." (User ISA manual)
	//
	// TL;DR: Loads the value of irq_reqs to X1, the return address register. (q2 holds the original x1 now)
	lui x1, %hi(irq_regs)
	addi x1, x1, %lo(irq_regs)

	// Load the value of q0, the return address, to the general purpose x2 (Stack pointer)
	picorv32_getq_insn(x2, q0)

	// "C.SW stores a 32-bit value in register rs2 0 to memory. It computes an effective address by adding
	//	the zero-extended offset, scaled by 4, to the base address in register rs1 0 . It expands to sw rs2 0 ,
	//	offset[6:2](rs1 0 )." -- User ISA spec

	// Recall that x1 now points to the irq_regs memory region.
    // So here, the return address is being saved to this region.
	sw x2,   0*4(x1)
	
	// q2 holds the return address, gets saved to irq_regs region
	picorv32_getq_insn(x2, q2)
	sw x2,   1*4(x1)

	// q3 holds the original stack pointer, gets saved.
	picorv32_getq_insn(x2, q3)
	sw x2,   2*4(x1)

	// And aaaaaall the other original register states.
	sw x3,   3*4(x1)
	sw x4,   4*4(x1)
	sw x5,   5*4(x1)
	sw x6,   6*4(x1)
	sw x7,   7*4(x1)
	sw x8,   8*4(x1)
	sw x9,   9*4(x1)
	sw x10, 10*4(x1)
	sw x11, 11*4(x1)
	sw x12, 12*4(x1)
	sw x13, 13*4(x1)
	sw x14, 14*4(x1)
	sw x15, 15*4(x1)
	sw x16, 16*4(x1)
	sw x17, 17*4(x1)
	sw x18, 18*4(x1)
	sw x19, 19*4(x1)
	sw x20, 20*4(x1)
	sw x21, 21*4(x1)
	sw x22, 22*4(x1)
	sw x23, 23*4(x1)
	sw x24, 24*4(x1)
	sw x25, 25*4(x1)
	sw x26, 26*4(x1)
	sw x27, 27*4(x1)
	sw x28, 28*4(x1)
	sw x29, 29*4(x1)
	sw x30, 30*4(x1)
	sw x31, 31*4(x1)


	/* call interrupt handler C function */
	// The stack is changed to point to a special interrupt stack. 
	lui sp, %hi(irq_stack)
	addi sp, sp, %lo(irq_stack)

	// arg0 = address of regs
    // a0 is ABI for register x10, which holds return value or function argument 0.
	lui a0, %hi(irq_regs)
	addi a0, a0, %lo(irq_regs)

	// arg1 = interrupt type
    // And a1 is register x11, return value/function argument 1  
	picorv32_getq_insn(a1, q1)

	// call to C function
	// Jump and link... So we can successfully return at the end of routine.
	jal ra, irq
 
	/* restore registers */


	// new irq_regs address returned from C code in a0
	addi x1, a0, 0

	// lw = load word. Loads the value from memory, the base address given by x1.
	lw x2,   0*4(x1)
	picorv32_setq_insn(q0, x2)

	lw x2,   1*4(x1)
	picorv32_setq_insn(q1, x2)

	lw x2,   2*4(x1)
	picorv32_setq_insn(q2, x2)

	lw x3,   3*4(x1)
	lw x4,   4*4(x1)
	lw x5,   5*4(x1)
	lw x6,   6*4(x1)
	lw x7,   7*4(x1)
	lw x8,   8*4(x1)
	lw x9,   9*4(x1)
	lw x10, 10*4(x1)
	lw x11, 11*4(x1)
	lw x12, 12*4(x1)
	lw x13, 13*4(x1)
	lw x14, 14*4(x1)
	lw x15, 15*4(x1)
	lw x16, 16*4(x1)
	lw x17, 17*4(x1)
	lw x18, 18*4(x1)
	lw x19, 19*4(x1)
	lw x20, 20*4(x1)
	lw x21, 21*4(x1)
	lw x22, 22*4(x1)
	lw x23, 23*4(x1)
	lw x24, 24*4(x1)
	lw x25, 25*4(x1)
	lw x26, 26*4(x1)
	lw x27, 27*4(x1)
	lw x28, 28*4(x1)
	lw x29, 29*4(x1)
	lw x30, 30*4(x1)
	lw x31, 31*4(x1)

	picorv32_getq_insn(x1, q1)
	picorv32_getq_insn(x2, q2)

	// "Copies value from q0 to the PC and reenables interrupts" -- PicoRV Readme
	picorv32_retirq_insn()

irq_regs:
	// registers are saved to this memory region during interrupt handling
	// the program counter is saved as register 0
	.fill 32,4

// stack is from the top down, hence the label placement.
	.fill 128,4
irq_stack:


/* THE STARTUP ROUTINE. ZERO ALL REGS. SET SP. START PROGRAM. */
/* Remember, that with interrupts, we start higher up. */
 
_pvstart:
/* zero-initialize all registers */
addi x1, zero, 0
addi x2, zero, 0
addi x3, zero, 0
addi x4, zero, 0
addi x5, zero, 0
addi x6, zero, 0
addi x7, zero, 0
addi x8, zero, 0
addi x9, zero, 0
addi x10, zero, 0
addi x11, zero, 0
addi x12, zero, 0
addi x13, zero, 0
addi x14, zero, 0
addi x15, zero, 0
addi x16, zero, 0
addi x17, zero, 0
addi x18, zero, 0
addi x19, zero, 0
addi x20, zero, 0
addi x21, zero, 0
addi x22, zero, 0
addi x23, zero, 0
addi x24, zero, 0
addi x25, zero, 0
addi x26, zero, 0
addi x27, zero, 0
addi x28, zero, 0
addi x29, zero, 0
addi x30, zero, 0
addi x31, zero, 0

/* set stack pointer */
lui sp, %hi(stackPointerAddr)
addi sp, sp, %lo(stackPointerAddr)  

/* push zeros on the stack for argc and argv */
/* (stack is aligned to 16 bytes in riscv calling convention) */
addi sp,sp,-16
sw zero,0(sp)
sw zero,4(sp)
sw zero,8(sp)
sw zero,12(sp)

/* jump to libc init */
j _ftext

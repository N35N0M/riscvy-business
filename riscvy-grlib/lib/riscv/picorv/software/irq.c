// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
#include <stdio.h>


uint32_t *irq(uint32_t *regs, uint32_t irqs)
{
	printf("========== INTERRUPT HANDLER CALLED ==========!\n");
	// APBUART Receiver FIFO -- not implemented
	if ((irqs & (1<<5)) != 0) {
		printf("Pico: Hey, I got notified by APBUART!\n");
	}

	// GRGPIO IRQ (shared interrupt line. We only use one button.)
	if ((irqs & (1<<6)) != 0) {
		printf("Pico: Who told you that you could push my buttons?!\n");
	}

	// AHBSTATUS IRQ -- not implemented
	if ((irqs & (1<<7)) != 0) {
		printf("Pico: The AHBSTATUS register has something it wants to tell you.\n");
	}

	// GPTIMER IRQ (it ticks!) -- not implemented
	if ((irqs & (1<<8)) != 0) {
		printf("Pico: Can you hear the clocks oscillating? \nI can. Or at least they interrupt me.\n");
	}
	printf("========== EXITING INTERRUPT HANDLER ==========!\n");

	return regs;
}


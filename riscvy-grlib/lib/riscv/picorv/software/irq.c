// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
#include <stdio.h>


uint32_t *irq(uint32_t *regs, uint32_t irqs)
{
    // Use prints sparingly, as they make the handlers much slower.
    //printf("\n\n========== INTERRUPT HANDLER CALLED ==========\n");

    if ((irqs & (1<<5)) != 0) {
        printf("INTERRUPT HANDLER: Received data in APBUART! \n");
    }

    // GRGPIO IRQ (Xilinx ZC702, SW7 button)
    if ((irqs & (1<<6)) != 0) {
        printf("INTERRUPT HANDLER: Registered button press! \n");
    }

    // AHBSTATUS IRQ -- not implemented
    if ((irqs & (1<<7)) != 0) {
        printf("INTERRUPT HANDLER: The AHBSTATUS register has something \n
it wants to tell you.\n");

    }

    // GPTIMER IRQ (it ticks!)
    if ((irqs & (1<<8)) != 0) {
        //printf("Pico: Can you hear the clocks oscillating? \n
        //          I can. Or at least they interrupt me.\n");

    }
    //printf("========== EXITING INTERRUPT HANDLER ==========\n\n");

    return regs;
}


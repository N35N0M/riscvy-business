#include <stdio.h>
#include <iostream>
#include <vector>
#include <algorithm>

/*
 *  This is a modified version of firmware.cc,
 *  found in the original PicoRV repository:
 *  https://github.com/cliffordwolf/picorv32
 */

// Defined in start.S
extern "C" uint32_t WaitForInterrupt();

class ExampleBaseClass
{
public:
    ExampleBaseClass() {
        std::cout << "ExampleBaseClass()" << std::endl;
    }

    virtual ~ExampleBaseClass() {
        std::cout << "~ExampleBaseClass()" << std::endl;
    }

    virtual void print_something_virt() {
        std::cout << "ExampleBaseClass::print_something_virt()" << std::endl;
    }

    void print_something_novirt() {
        std::cout << "ExampleBaseClass::print_something_novirt()" << std::endl;
    }
};

class ExampleSubClass : public ExampleBaseClass
{
public:
    ExampleSubClass() {
        std::cout << "ExampleSubClass()" << std::endl;
    }

    virtual ~ExampleSubClass() {
        std::cout << "~ExampleSubClass()" << std::endl;
    }

    virtual void print_something_virt() {
        std::cout << "ExampleSubClass::print_something_virt()" << std::endl;
    }

    void print_something_novirt() {
        std::cout << "ExampleSubClass::print_something_novirt()" << std::endl;
    }
};

int main()
{
    /*
     * INITIALIZE SYSTEM UART FIRST (APBUART):
     *  - Enable FIFO Debug mode
     *  - Enable transfer and receiver FIFOs
     *  - Enable receiver interrupts
     *
     * Note that for APBUART and all other GRLIB peripherals, the target
     * registers are big-endian, while the Pico performs little-endian
     * writes. Therefore, the byte-order for data is reversed.
     *
     */
    volatile int set_uart_control_to_fifo_debug = 0x07080080;
    *(volatile int*)0x80000108 = set_uart_control_to_fifo_debug;

    // ASCII Art is courtesy of:
    // http://patorjk.com/software/taag/#p=testall&f=Blocks&t=PicoRV
    printf(" ________  ___  ________  ________  ________  ___      ___\n"); 
    printf("|\\   __  \\|\\  \\|\\   ____\\|\\   __  \\|\\   __  \\|\\  \\    /  /|\n");
    printf("\\ \\  \\|\\  \\ \\  \\ \\  \\___|\\ \\  \\|\\  \\ \\  \\|\\  \\ \\  \\  /  / /\n");
    printf(" \\ \\   ____\\ \\  \\ \\  \\    \\ \\  \\\\\\  \\ \\   _  _\\ \\  \\/  / / \n");
    printf("  \\ \\  \\___|\\ \\  \\ \\  \\____\\ \\  \\\\\\  \\ \\  \\\\  \\\\ \\    / /  \n");
    printf("   \\ \\__\\    \\ \\__\\ \\_______\\ \\_______\\ \\__\\\\ _\\\\ \\__/ /   \n");
    printf("    \\|__|     \\|__|\\|_______|\\|_______|\\|__|\\|__|\\|__|/            \n");


    printf("\nWelcome to PicoRV32[IC] on GRLIB, running on the Xilinx ZC702!\n\n");
    printf("Setting up GRLIB peripherals...\n");
    printf("-- UART is already enabled, in FIFO debug mode, \n");
    printf("   and with receiver interrupts enabled.\n");

    /*
     * INITIALIZE GRGPIO
     *
     * grgpio_ipol:  Specify that the SW7 button is active high.
     * grgpio_iedge: SW7 is to interrupt on the rising edge.
     * grgpio_imask: Allow SW7 to raise interrupts.
     *
     */
    volatile int grgpio_ipol  = 0x01000000; 
    volatile int grgpio_iedge = 0x01000000; 
    volatile int grgpio_imask = 0x01000000; 
    *(volatile int*)0x80000810 = grgpio_ipol;
    *(volatile int*)0x80000814 = grgpio_iedge;
    *(volatile int*)0x8000080C = grgpio_imask;

    printf("-- Enabled GRGPIO button interrupt!\n");

    /* SETUP, BUT DO NOT ENABLE, GPTIMER
     *
     * The prescaler is 8 bits, while timer1 is 32 bits.
     * We set the reload value of prescaler and timer1 so that timer1 will
     * underflow and cause an interrupt every second, based on a 83MHZ clock.
     */
    volatile int gptimer_scaler_reload_value = 0xFF000000;
    volatile int gptimer_timer1_reload_value = 0x7AF20400;

    *(volatile int*)0x80000304 = gptimer_scaler_reload_value;
    *(volatile int*)0x80000314 = gptimer_timer1_reload_value;
    printf("-- Set GPTIMER prescaler and timer1 so that timer1 can \n");
    printf("   interrupt every second when enabled.\n\n");

    printf("Testing the stack... \n\n");
    ExampleBaseClass *obj = new ExampleBaseClass;
    obj->print_something_virt();
    obj->print_something_novirt();
    delete obj;

    obj = new ExampleSubClass;
    obj->print_something_virt();
    obj->print_something_novirt();
    delete obj;

    std::vector<unsigned int> some_ints;
    some_ints.push_back(0x48c9b3e4);
    some_ints.push_back(0x79109b6a);
    some_ints.push_back(0x16155039);
    some_ints.push_back(0xa3635c9a);
    some_ints.push_back(0x8d2f4702);
    some_ints.push_back(0x38d232ae);
    some_ints.push_back(0x93924a17);
    some_ints.push_back(0x62b895cc);
    some_ints.push_back(0x6130d459);
    some_ints.push_back(0x837c8b44);
    some_ints.push_back(0x3d59b4fe);
    some_ints.push_back(0x444914d8);
    some_ints.push_back(0x3a3dc660);
    some_ints.push_back(0xe5a121ef);
    some_ints.push_back(0xff00866d);
    some_ints.push_back(0xb843b879);

    std::sort(some_ints.begin(), some_ints.end());

    for (auto n : some_ints)
        std::cout << std::hex << n << std::endl;

    std::cout << "Setup and quicktest done. Now we run the main application.\n\n" << std::endl;

    // Values for GPTIMER's TIMER1. Refer to GRLIB IP core manual for details.
    volatile int timer1_enable_with_interrupt = 0x0D000000;
    volatile int* gptimer_timer1_control = (volatile int*)0x80000318;

    // Value to store the character we receive.
    char response;

    // Main routine
    while (true){
        printf("========== MAIN APPLICATION ==========\n");
        printf("Press SW7 to continue.\n");
        WaitForInterrupt();
        printf("Button pressed\n");
        printf("Requesting input from user...\n");
        response = getchar();
        printf("We successfully received this character: %c \n", response);
        printf("Now, let's count from five!\n");

        for (volatile int i=5; i>0; i--){
            printf("%i...\n",i);
            *gptimer_timer1_control = timer1_enable_with_interrupt;
            WaitForInterrupt();
        }
        printf("THE END!\n\n");
    }

    return 0;
}


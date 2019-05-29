#include <stdio.h>
#include <iostream>
#include <vector>
#include <algorithm>

// This is a modified version of firmware.cc, found in the original PicoRV repository.

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
    // Put UART in FIFO debug mode, enable transfer and receive, enable receiver interrupts
	// Payload is reversed since the adapter swaps bytes, and pico feeds the adapter in little-endian order.
	// The GRLIB peripheral registers are big endian.
	volatile int set_uart_control_to_fifo_debug = 0x07080080;
    *(volatile int*)0x80000108 = set_uart_control_to_fifo_debug;

	printf("Welcome to PicoRV32[IC] on GRLIB, running on the Xilinx ZC702!\n\n");

    printf("Setting up GRLIB peripherals...\n");
	printf("UART is already enabled, in FIFO debug mode, and with receiver interrupts enabled.\n");
	// All GRLIB data is big-endian, so we provide the data in reverse order (as we store in little-endian)
    volatile int grgpio_ipol  = 0x01000000; // Specify that GPIO line 0, SW7 button, is active high
    volatile int grgpio_iedge = 0x01000000; // Trigger interrupt on (rising) edge, not level
	volatile int grgpio_imask = 0x01000000; // Enable interrupts from GPIO line 0
    *(volatile int*)0x80000810 = grgpio_ipol;
    *(volatile int*)0x80000814 = grgpio_iedge;
    *(volatile int*)0x8000080C = grgpio_imask;

	printf("Enabled GRGPIO button interrupt!\n");

    printf("Testing the stack. \n");
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

	std::cout << "\nAll done. Now we wait for interrupt(s)" << std::endl;
    
	// On purpose endless looping to test interrupt handling.
	//char enq = '\x05';
	char response;
    while (true){
		printf("I will now wait for a button interrupt.\n");
		WaitForInterrupt();
		printf("Finished waiting for button!\n");
        printf("Requesting input from user.\n");
		//std::cout << enq << std::endl; // ASCII code: ENQ - Enquiry
		printf("Got input from user! Now I just need to read it!\n");
		response = getchar();
		printf("We successfully received this character: %c", response);
	}

	return 0;
}


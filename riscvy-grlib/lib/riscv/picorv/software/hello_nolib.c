// SOURCE: https://balau82.wordpress.com/2010/02/28/hello-world-for-bare-metal-arm-using-qemu/

volatile unsigned int * const APBUART_ADDR = (unsigned int *)0x80000100;

void print_apbuart(const char *s) {
 while(*s != '\0') { /* Loop until end of string */
 *APBUART_ADDR = (unsigned int)(*s); /* Transmit char */
 s++; /* Next char */
 }
}

void c_entry() {
 print_uart0("Hello world!\n");
}

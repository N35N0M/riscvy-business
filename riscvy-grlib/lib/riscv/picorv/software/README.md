# DISCLAIMER

The following is extracted partially or fully from the PicoRV core source code,
originally by Clifford Wolf (https://github.com/cliffordwolf/picorv32):

* Makefile (slightly modified to mostly use this directory for code compilation for picoRV)
* start.S  (changed memory address of top of stack and stack pointer)
* syscalls.c (changes address for writing characters, to the GRLIB UART address)
* testbench.v (changes stdout/UART address so it matches mod, also increases simulated memory size)
* riscv.ld (changes memory pointers to match target.)
* firmware.cc (expanded upon to initialize system and run a test routine. The original ends with printing sorted numbers.)


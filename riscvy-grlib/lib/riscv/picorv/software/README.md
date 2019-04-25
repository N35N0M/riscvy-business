=== DISCLAIMER ===
The following is extracted partially or fully from the PicoRV core source code,
originally by Clifford Wolf (https://github.com/cliffordwolf/picorv32):

* Makefile (slightly modified to mostly use this directory for code compilation for picoRV)
* start.ld (changed memory addresses to match target GRLIB design on Xilinx ZC702)
* start.S  (changed memory address of top of stack and stack pointer)
* syscalls.c (changes address for writing characters, to the GRLIB UART address)
* testbench.v (changes stdout/UART address so it matches mod, also increases simulated memory size)
* riscv.ld (changes memory pointers to match target.)
* firmware.d (unchanged)

In other words, we are simply adapting the PicoRV to our SoC, and contributing very little back.
We collect these files in a single directory, in order to make it very clear what files are involved,
as these are in multiple locations in the original source.

In addition, we add a hello world that uses no standard libraries (only writes to UART), one which utilizes newlib to implement standard C system libraries, and the dhrystone benchmark also used in BCC (LEON3 SPARCV8 compiler).

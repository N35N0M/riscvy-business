RISCV_TOOLS_PREFIX = /opt/riscv32ic/bin/riscv32-unknown-elf-
CXX = $(RISCV_TOOLS_PREFIX)g++
CC = $(RISCV_TOOLS_PREFIX)gcc
AS = $(RISCV_TOOLS_PREFIX)gcc
CXXFLAGS = -MD  -Wall -std=c++11
CCFLAGS = -MD  -Wall -std=c++11
LDFLAGS = -Wl,--gc-sections
LDLIBS = -lstdc++

# Implementation version, see sim-folder for simulation version.
firmware.srec: firmware.elf
	$(RISCV_TOOLS_PREFIX)objcopy -O srec --pad-to=0x40100000 --gap-fill 0 firmware.elf firmware.srec

firmware.elf: firmware.o syscalls.o start.o irq.o
	$(CC) $(LDFLAGS) -o $@ $^ -T riscv.ld $(LDLIBS)

irq.o: irq.c
	$(CC) -nostdlib -o irq.o -c irq.c

start.o: start.S
	$(CC) -nostdlib -o start.o -c start.S


# HELPERS
clean:
	rm -f *.o *.d *.tmp start.elf
	rm -f *.srec *.bin *.hex
	rm -f firmware.elf firmware32.hex

-include *.d
.PHONY: test clean

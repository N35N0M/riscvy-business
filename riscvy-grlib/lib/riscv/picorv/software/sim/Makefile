RISCV_TOOLS_PREFIX = /opt/riscv32ic/bin/riscv32-unknown-elf-
CXX = $(RISCV_TOOLS_PREFIX)g++
CC = $(RISCV_TOOLS_PREFIX)gcc
AS = $(RISCV_TOOLS_PREFIX)gcc
CXXFLAGS = -MD  -Wall -std=c++11
CCFLAGS = -MD  -Wall -std=c++11
LDFLAGS = -Wl,--gc-sections
LDLIBS = -lstdc++

# Simulation version
ram.srec: firmware.elf                                                     
	$(RISCV_TOOLS_PREFIX)objcopy -O srec --pad-to=0x400F0000 --gap-fill 0 firmware.elf ram.srec

firmware32.hex: firmware.elf hex8tohex32.py
	$(RISCV_TOOLS_PREFIX)objcopy -O verilog firmware.elf firmware.hex
	python3 hex8tohex32.py firmware.hex > firmware32.hex

firmware.elf: firmware.o syscalls.o start.o
	$(CC) $(LDFLAGS) -o $@ $^ -T riscv_sim.ld $(LDLIBS)

start.o: start.S
	$(CC) -nostdlib -o start.o -c start.S

firmware.o: firmware.cc
	$(CC) -nostdlib -o firmware.o -c firmware.cc


# HELPERS
clean:
	rm -f *.o *.d *.tmp start.elf
	rm -f *.srec *.bin *.hex
	rm -f firmware.elf firmware32.hex

-include *.d
.PHONY: test clean

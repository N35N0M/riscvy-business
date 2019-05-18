RISCV_TOOLS_PREFIX = /opt/riscv32ic/bin/riscv32-unknown-elf-
CXX = $(RISCV_TOOLS_PREFIX)g++
CC = $(RISCV_TOOLS_PREFIX)gcc
AS = $(RISCV_TOOLS_PREFIX)gcc
CXXFLAGS = -MD  -Wall -std=c++11
CCFLAGS = -MD  -Wall -std=c++11
LDFLAGS = -Wl,--gc-sections
LDLIBS = -lstdc++

firmware32.hex: firmware.elf start.elf hex8tohex32.py
	$(RISCV_TOOLS_PREFIX)objcopy -O verilog start.elf start.tmp
	$(RISCV_TOOLS_PREFIX)objcopy -O verilog firmware.elf firmware.tmp
	cat start.tmp firmware.tmp > firmware.hex
	python3 hex8tohex32.py firmware.hex > firmware32.hex
	rm -f start.tmp firmware.tmp

ram.srec: firmware.elf start.elf
	$(RISCV_TOOLS_PREFIX)objcopy -O srec --pad-to=0x46000020 --gap-fill 0 firmware.elf firmware.srec
	$(RISCV_TOOLS_PREFIX)objcopy -O srec --pad-to=0x45001000 --gap-fill 0 start.elf start.srec
	cat start.srec firmware.srec > ram.srec

firmware.elf: firmware.o syscalls.o
	$(CC) $(LDFLAGS) -o $@ $^ -T riscv.ld $(LDLIBS)
	chmod -x firmware.elf

start.elf: start.S start.ld
	$(CC) -nostdlib -o start.elf start.S -T start.ld $(LDLIBS)
	chmod -x start.elf

clean:
	rm -f *.o *.d *.tmp start.elf
	rm -f *.srec *.bin
	rm -f firmware.elf firmware32.hex

-include *.d
.PHONY: test clean

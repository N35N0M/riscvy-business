RISCV_TOOLS_PREFIX = /opt/riscv32ic/bin/riscv32-unknown-elf-
CXX = $(RISCV_TOOLS_PREFIX)g++
CC = $(RISCV_TOOLS_PREFIX)gcc
AS = $(RISCV_TOOLS_PREFIX)gcc
CXXFLAGS = -MD  -Wall -std=c++11
CCFLAGS = -MD  -Wall -std=c++11
LDFLAGS = -Wl,--gc-sections
LDLIBS = -lstdc++

fulltest: firmware32.hex full_testbench.v
	iverilog -o full_testbench.vvp full_testbench.v ../core/picorv32.v ../picorv32_freeahb_adapter.v ../../shared/FreeAHB/ahb_master/sources/ahb_master.v
	chmod -x full_testbench.vvp
	vvp -v -N full_testbench.vvp

test: testbench.vvp firmware32.hex
	vvp -v -N testbench.vvp

testbench.vvp: testbench.v ../core/picorv32.v
	iverilog -o testbench.vvp testbench.v ../core/picorv32.v
	chmod -x testbench.vvp

firmware32.hex: firmware.elf start.elf hex8tohex32.py
	$(RISCV_TOOLS_PREFIX)objcopy -O verilog start.elf start.tmp
	$(RISCV_TOOLS_PREFIX)objcopy -O verilog firmware.elf firmware.tmp
	cat start.tmp firmware.tmp > firmware.hex
	python3 hex8tohex32.py firmware.hex > firmware32.hex
	rm -f start.tmp firmware.tmp

firmware.hex: firmware.elf start.elf hex8tohex32.py
	$(RISCV_TOOLS_PREFIX)objcopy -O verilog start.elf start.tmp
	$(RISCV_TOOLS_PREFIX)objcopy -O verilog firmware.elf firmware.tmp
	cat start.tmp firmware.tmp > firmware.hex

ram.srec: firmware.elf start.elf
	$(RISCV_TOOLS_PREFIX)objcopy -O srec --pad-to=0x46000020 --gap-fill 0 firmware.elf firmware.srec
	$(RISCV_TOOLS_PREFIX)objcopy -O srec --pad-to=0x45001000 --gap-fill 0 start.elf start.srec
	cat start.srec firmware.srec > ram.srec

binaries: firmware.elf start.elf
	$(RISCV_TOOLS_PREFIX)objcopy -O binary start.elf start.bin
	$(RISCV_TOOLS_PREFIX)objcopy -O binary firmware.elf firmware.bin

firmware.elf: firmware.o syscalls.o
	$(CC) $(LDFLAGS) -o $@ $^ -T riscv.ld $(LDLIBS)
	chmod -x firmware.elf

start.elf: start.S start.ld
	$(CC) -nostdlib -o start.elf start.S -T start.ld $(LDLIBS)
	chmod -x start.elf

clean:
	rm -f *.o *.d *.tmp start.elf
	rm -f *.srec *.bin
	rm -f firmware.elf firmware.hex firmware32.hex
	rm -f testbench.vvp testbench.vcd

-include *.d
.PHONY: test clean

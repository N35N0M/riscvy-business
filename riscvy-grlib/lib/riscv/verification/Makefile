# TESTBENCHES
freeahb_tb: ## Simple test of the FreeAHB Master, displays wavedump.
	iverilog -s ahb_master_test -g2012 -Wall -Winfloop -o freeahb_tb.vvp \
	-DSIM freeahb_tb.sv ${FREEAHB_MASTER_PATH};
	vvp -v -N freeahb_tb.vvp
	gtkwave freeahb_tb.vcd


adapter_tb: ## Simple test of the Pico-to-AHB adapter, displays wavedump.
	iverilog -s freeahb_adapter_test -g2012 -Wall -Winfloop -o adapter_tb.vvp \
	-DSIM adapter_tb.sv ${ADAPTER_PATH};
	vvp -v -N adapter_tb.vvp
	gtkwave adapter_tb.vcd


pico_tb: ## The original picoRV32 TB. Runs a sample bare-metal application.  
pico_tb: firmware32.hex 
	iverilog -o pico_tb.vvp pico_tb.v ${PICO_CORE}
	chmod -x pico_tb.vvp
	vvp -v -N pico_tb.vvp
	gtkwave pico_tb.vcd


adapter_and_freeahb_tb: ## Simple test with both the adapter and FreeAHB master.
	iverilog -g2012 -Wall -Winfloop -o adapter_and_freeahb_tb.vvp -DSIM \
	${ADAPTER_PATH} adapter_and_freeahb_tb.sv ${FREEAHB_MASTER_PATH};
	vvp -v -N adapter_and_freeahb_tb.vvp
	gtkwave adapter_and_freeahb.vcd

topdesign_tb: ## Modded pico_tb. Tests bare-metal software on Pico, getting its memory through the adapter and FreeAHB master.  
topdesign_tb: firmware32.hex 
	iverilog -o topdesign_tb.vvp topdesign_tb.v ${PICO_CORE} ${ADAPTER_PATH} ${FREEAHB_MASTER_PATH}
	chmod -x topdesign_tb.vvp
	vvp -N topdesign_tb.vvp
	gtkwave topdesign_tb.vcd



# SOFTWARE BUILDING FOR DEPENDENT TESTBENCHES
firmware32.hex:  ## Builds the hexfile needed by the bare-metal application TBs.
	cd ${PICO_SIM_SOFTWARE} && $(MAKE) firmware32.hex && cp firmware32.hex ${RISCV_LIB_VERIFICATION}/firmware32.hex


.PHONY: clean help

help: ## This help dialog. Source - gist.github.com/prwhite/8168133
	@echo 'usage: make [target] ...'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

clean: ## Clean files built with this Makefile.
	rm -f *.vvp *.vcd *.hex
	cd ${PICO_SIM_SOFTWARE} && $(MAKE) clean

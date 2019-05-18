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


pico_tb: firmware32.hex ## The original picoRV32 TB. Runs a sample bare-metal application.
	iverilog -o testbench.vvp testbench.v ${PICO_CORE}
	chmod -x testbench.vvp
	vvp -v -N testbench.vvp
	gtkwave


adapter_and_freeahb_tb: ## Simple test with both the adapter and FreeAHB master.
	iverilog -g2012 -Wall -Winfloop -o adapter_and_freeahb_tb.vvp -DSIM \
	${ADAPTER_PATH} adapter_and_freeahb_tb.sv ${FREEAHB_MASTER_PATH};
	vvp -v -N adapter_and_freeahb_tb.vvp
	gtkwave


riscv_toplevel_test: firmware32.hex full_testbench.v ## Modded pico_tb. Tests bare-metal software on Pico, getting its memory through the adapter and FreeAHB master.
	iverilog -o full_testbench.vvp full_testbench.v ../core/picorv32.v ../picorv32_freeahb_adapter.v ../../shared/FreeAHB/ahb_master/sources/ahb_master.v
	chmod -x full_testbench.vvp
	vvp -v -N full_testbench.vvp



# SOFTWARE BUILDING FOR DEPENDENT TESTBENCHES
firmware32.hex:  ## Builds the hexfile needed by the bare-metal application TBs.
	cd ${PICO_SOFTWARE}
	$(make) firmware32.hex
	cp firmware32.hex ${RISCV_LIB_VERIFICATION}/firmware32.hex


.PHONY: clean help

help: ## This help dialog. Source - gist.github.com/prwhite/8168133
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
	printf "%-30s %s\n" "target" "help" ; \
	printf "%-30s %s\n" "------" "----" ; \
	for help_line in $${help_lines[@]}; do \
		IFS=$$':' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf '\033[36m'; \
		printf "%-30s %s" $$help_command ; \
		printf '\033[0m'; \
		printf "%s\n" $$help_info; \
	done

clean: ## Clean files built with this Makefile.
	rm -f *.vvp *.vcd

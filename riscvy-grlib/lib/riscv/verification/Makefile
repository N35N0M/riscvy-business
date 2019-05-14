FREEAHB_MASTER=${FREEAHB_MASTER_PATH}

freeahb_tb:
	iverilog -s ahb_master -g2012 -Wall -Winfloop -o freeahb_tb.vvp -DSIM freeahb_tb.sv ${FREEAHB_MASTER_PATH}
	vvp -v -N freeahb_tb.vvp

.PHONY: clean

clean:
	rm -f *.vvp *.vcd

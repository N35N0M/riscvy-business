iverilog -g2012 -Wall -Winfloop -o adapter_and_freeahb_tb.out -DSIM picorv32_freeahb_adapter.v testbenches/adapter_and_freeahb_tb.sv ../shared/FreeAHB/ahb_master/sources/ahb_master.v
vvp adapter_and_freeahb_tb.out

iverilog -g2012 -Wall -Winfloop -o adapter_tb.out -DSIM picorv32_freeahb_adapter.v testbenches/adapter_tb.sv
vvp adapter_tb.out

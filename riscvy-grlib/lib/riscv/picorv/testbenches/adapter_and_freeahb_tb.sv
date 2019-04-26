// Inspired by the style of the FreeAHB TB.

// DUV is the FreeAHB Adapter.
// We will apply valid stimulus from the Pico IF and FreeAHB master manually.
module adapter_and_freeahb_test;
    // ADAPTER
    logic 			[31:0]		freeahb_wdata;
    logic 								freeahb_valid;
   	logic		    [31:0]		freeahb_addr;
    logic       [2:0]			freeahb_size;
 		logic                 freeahb_write;
    logic 								freeahb_read;
    logic 			[31:0]		freeahb_min_len;// Minimum "guaranteed size of burst"
    logic 								freeahb_cont;			// Continues prev transfer
    logic 			[3:0]			freeahb_prot;
    logic 								freeahb_lock;

    logic 			   				freeahb_next; // Asserted indicates transfer finished.
    logic 			  [31:0]	freeahb_rdata;
    logic         [31:0]  freeahb_result_addr; // Not used.
    logic 				  			freeahb_ready; 				// rdata contains valid data.

    // Native PicoRV32 memory interface

    logic 			[31:0] 		mem_rdata;
    logic         				mem_ready;
    bit   			[31:0] 		mem_addr;
    bit   			[31:0] 		mem_wdata;
    bit   			[3:0] 		mem_wstrb;
    bit            				mem_valid;
    bit            				mem_instr;

    // FREEAHB

    bit                  i_hgrant;
    bit [31:0]           i_hrdata;
    bit                  i_hready;
    bit[1:0]             i_hresp;

    logic [31:0]           o_haddr;
    logic [2:0]            o_hburst;
    logic [2:0]            o_hsize;
    logic [1:0]            o_htrans;
    logic[31:0]            o_hwdata;
    logic                  o_hwrite;
    logic                  o_hbusreq;

    logic [3:0]            o_hprot;
    logic                  o_hlock;


    bit clk;
    bit resetn;

ahb_master #(.DATA_WDT(32), .BEAT_WDT(32)) FREEAHB_MAST (.i_hclk(clk),
                                                         .i_hreset_n(resetn),
                                                         .i_data(freeahb_wdata),
                                                         .i_valid(freeahb_valid),
                                                         .i_addr(freeahb_addr),
                                                         .i_size(freeahb_size),
                                                         .i_write(freeahb_write),
                                                         .i_read(freeahb_read),
                                                         .i_min_len(freeahb_min_len),
                                                         .i_cont(freeahb_cont),
                                                         .i_prot(freeahb_prot),
                                                         .i_lock(freeahb_lock),
                                                         .o_next(freeahb_next),
                                                         .o_data(freeahb_rdata),
                                                         .o_addr(freeahb_result_addr),
                                                         .o_ready(freeahb_ready),
                                                         .*);

picorv32_freeahb_adapter FREEAHB_ADAPT    (.clk(clk), .resetn(resetn), .*);


always #10 clk++;


initial
begin
        $dumpfile("freeahb_and_adapter.vcd");
        $dumpvars;
        resetn <= 1;
        d(10);
        // Only case: WRITE
        // Initialize write session by acting as PicoRV memory IF
        mem_addr    <= 32'b10000000000000000000000000000000;
        mem_wdata   <= 32'hF0FF0FAA;
        mem_wstrb   <= 4'b1111;
        mem_valid   <= 1'b1;
        mem_instr   <= 1'b1;

        wait_for_hbusreq;

        // We grant it the bus and simulate zero wait state conditions.
        i_hgrant <= 1'b1;
        i_hready <= 1'b1;
        i_hresp  <= 2'b00; // Slave responds OKAY.

        // Let the write transfer finish.
        wait_for_if_ready;

        $finish;
end

task wait_for_hbusreq;
        d(1);
        while(o_hbusreq !== 1)
        begin
                d(1);
        end
endtask

task wait_for_freeahb_valid;
        d(1);
        while(freeahb_valid !== 1)
        begin
                d(1);
        end
endtask

task wait_for_if_ready;
        d(1);
        while(mem_ready !== 1)
        begin
                d(1);
        end
endtask

task wait_for_next;
        d(1);
        while(freeahb_next !== 1)
        begin
                d(1);
        end
endtask

task d(int x);
        repeat(x)
        @(posedge clk);
endtask

endmodule

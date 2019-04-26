// Inspired by the style of the FreeAHB TB.

// DUV is the FreeAHB Adapter.
// We will apply valid stimulus from the Pico IF and FreeAHB master manually.
module freeahb_adapter_test;
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

    bit 			   					freeahb_next; // Asserted indicates transfer finished.
    bit 			  [31:0]		freeahb_rdata;
    bit         [31:0]    freeahb_result_addr; // Not used.
    bit 				  				freeahb_ready; 				// rdata contains valid data.

    // Native PicoRV32 memory interface

    logic 			[31:0] 		mem_rdata;
    logic         				mem_ready;
    bit   			[31:0] 		mem_addr;
    bit   			[31:0] 		mem_wdata;
    bit   			[3:0] 		mem_wstrb;
    bit            				mem_valid;
    bit            				mem_instr;


    bit clk;
    bit resetn;


picorv32_freeahb_adapter FREEAHB_ADAPT    (.clk(clk),.resetn(resetn), .*);


always #10 clk++;


initial
begin
        $dumpfile("freeahb_adapter.vcd");
        $dumpvars;
        resetn <= 1;
        // FIRST CASE: TEST READ
        // Initial state
        freeahb_ready <= 0;
        mem_valid <= 0;
        d(10);

        // Simulate the PicoRV IF.
        mem_addr    <= 32'b10000000000000000000000000000000;
        mem_valid   <= 1'b1;
        mem_instr   <= 1'b0;

        // Wait for adapter to initialize FreeAHB
        wait_for_freeahb_valid;

        // Fake a ready response from FreeAHB with some random data.
        freeahb_ready <= 1'b1;
        freeahb_rdata <= 32'b10101010101010101111111111111111;

        wait_for_if_ready;

        mem_valid <= 0;
        d(10);

        // SECOND CASE: TEST WRITE
        // Initial state
        freeahb_ready <= 0;
        mem_valid <= 0;
        freeahb_next <= 1;
        d(10);


        // Initialize write session by acting as PicoRV memory IF
        mem_addr    <= 32'b10000000000000000000000000000000;
        mem_wdata   <= 32'b11110000111111110000111110101010;
        mem_wstrb   <= 4'b1100;
        mem_valid   <= 1'b1;
        mem_instr   <= 1'b1;

        wait_for_freeahb_valid;

        // We fake the FreeAHB by now constantly driving freeahb_ready.
        freeahb_ready <= 1;
        freeahb_next  <= 1;

        wait_for_if_ready;

        $finish;
end

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

// *****************************************************************************
// picorv32_to_freeahb_adapter
// *****************************************************************************

module picorv32_freeahb_adapter #(parameter BIG_ENDIAN_AHB = 1) (
    input                   clk,
    input                   resetn,

    // FreeAHB interface
    output reg    [31:0]    freeahb_wdata,
    output reg              freeahb_valid,
    output reg    [31:0]    freeahb_addr,
    output reg    [2:0]     freeahb_size,
    output reg              freeahb_write,
    output reg              freeahb_read,
    output reg    [31:0]    freeahb_min_len,     // Minimum "guaranteed size of burst"
    output reg              freeahb_cont,        // Continues prev transfer
    output reg    [3:0]     freeahb_prot,
    output reg              freeahb_lock,

    input                   freeahb_next,        // Asserted indicates transfer finished.
    input         [31:0]    freeahb_rdata,
    input         [31:0]    freeahb_result_addr, // Not used.
    input                   freeahb_ready,       // rdata contains valid data.



    // Native PicoRV32 memory interface
    input                   mem_valid,
    input                   mem_instr,
    output reg              mem_ready,
    input         [31:0]    mem_addr,
    input         [31:0]    mem_wdata,
    input         [3:0]     mem_wstrb,
    output        [31:0]    mem_rdata

);
    // Arguably, this complexity could/should lie in the AHB master.
    // But we'd rather write up a new AHB master at this point, so we
    // place the complexity here for the time being.
    //
    // Note that rdata from the bus is only valid when HREADY is raised with
    // HRESP OKAY.
    if (BIG_ENDIAN_AHB == 1) begin
        assign mem_rdata[31:24] = freeahb_rdata[7:0];   // Byte A+3
        assign mem_rdata[23:16] = freeahb_rdata[15:8];  // Byte A+2
        assign mem_rdata[15:8]  = freeahb_rdata[23:16]; // Byte A+1
        assign mem_rdata[7:0]   = freeahb_rdata[31:24]; // Byte A
	
    end
    else begin
        assign mem_rdata        = freeahb_rdata;

    end


    reg [3:0] write_ctr;     // Used when composing wstrb into individual writes.
    reg       pending_write;
    reg       pending_write_finish;
    reg       pending_read;

    always @(posedge clk or negedge resetn) begin
        // IDLE memory system conditions
        if (!resetn || !mem_valid || mem_ready) begin
            freeahb_valid     <= 1'b0;
            freeahb_write     <= 1'b0;
            freeahb_read      <= 1'b0;
            freeahb_cont      <= 1'b0;
            freeahb_lock      <= 1'b0;
	    freeahb_min_len   <= 0;
	    freeahb_size      <= 0;
	    freeahb_prot      <= 0;
            mem_ready         <= 1'b0;
            write_ctr         <= 0;
            pending_write     <= 1'b0;
            pending_write_finish <= 1'b0;
            pending_read      <= 1'b0;
        end
	

        // *************************************************************************
        // READS
        //**************************************************************************
        // READ transfer start
        else if (mem_valid && mem_wstrb == 4'b0000 && !pending_read) begin
            freeahb_addr       <= mem_addr;
            freeahb_size       <= 3'b010;
            freeahb_read       <= 1'b1;
            freeahb_min_len    <= 0;
            freeahb_prot       <= mem_instr ? 4'b0000 : 4'b0001;
            pending_read       <= 1'b1;
        end

        // READ transfer complete
        else if (mem_valid && mem_wstrb == 4'b0000 && pending_read && freeahb_ready) begin
	    $display("READ BASE ADDR %h, RDATA %h", mem_addr, mem_rdata);
            mem_ready     <= 1'b1;
            freeahb_valid <= 1'b0;
            freeahb_read  <= 1'b0;
            freeahb_write <= 1'b0;
            freeahb_cont  <= 1'b0;
            pending_read  <= 1'b0;
        end

        // *************************************************************************
        // WRITES
        // *************************************************************************

        // WRITE sequences
        // The mem IF outputs WSTRB (write strobes), but this is a AXI4 construct,
        // and does not suit AHB. We therefore have to translate the strobes to
        // individual AHB transfers.
        else if (mem_valid && mem_wstrb != 4'b0000 && write_ctr < 4 && !pending_write && !pending_write_finish) begin
            // If we are to do a write, and freeahb indicates it is ready.
            // ADDRESS PHASE
            if (mem_wstrb[write_ctr]) begin
                freeahb_valid      <= 1'b0;
                freeahb_addr       <= mem_addr + write_ctr;
                freeahb_size       <= 3'b000; // byte
                freeahb_write      <= 1'b1;
                freeahb_cont       <= 1'b0;    // Byte strobes are not necessarily
                                                                     // sequential. Start new transfer.
                freeahb_prot       <= mem_instr ? 4'b0000 : 4'b0001;
		        pending_write      <= 1'b1;
            end


            // If we do not write this round, we must make sure to make the FreeAHB idle.
            else if (!mem_wstrb[write_ctr]) begin
                freeahb_write      <= 1'b0;
                write_ctr          <= write_ctr + 1;
            end

        end

        // Write sequence finished
        else if (mem_valid && mem_wstrb != 4'b0000 && !pending_write && !pending_write_finish && write_ctr == 4) begin
            mem_ready     <= 1'b1;
            freeahb_write <= 1'b0;
            freeahb_valid <= 1'b0;
	    write_ctr     <= 0;
	    freeahb_wdata <= 0; // Not neccessary, but makes it easier to debug.
        end

        // For 32-bit reads, we simply clear the read bit on the UI.
        // For writes, we must now drive the data if we are in the address phase.
        else if (mem_valid && freeahb_next && (pending_read || pending_write || pending_write_finish) ) begin
            freeahb_read <= 1'b0;

	        if (pending_write) begin
                    case (write_ctr)
                        0: begin
                               if (BIG_ENDIAN_AHB == 1) freeahb_wdata[31:24] <= mem_wdata[7:0];
                               else                     freeahb_wdata[7:0]   <= mem_wdata[7:0];
                           end

                        1: begin
                               if (BIG_ENDIAN_AHB == 1) freeahb_wdata[31:24] <= mem_wdata[15:8];
                               else                     freeahb_wdata[7:0]   <= mem_wdata[15:8];
                           end

                        2: begin
                               if (BIG_ENDIAN_AHB == 1) freeahb_wdata[31:24] <= mem_wdata[23:16];
                               else                     freeahb_wdata[7:0]   <= mem_wdata [23:16];
                           end

                        3: begin
                               if (BIG_ENDIAN_AHB == 1) freeahb_wdata[31:24] <= mem_wdata[31:24];
                               else                     freeahb_wdata[7:0]   <= mem_wdata[31:24];
                           end
                    endcase
                    freeahb_valid <= 1'b1;
                    pending_write <= 1'b0;
                    pending_write_finish <= 1'b1;
                     
	        end
            else if (pending_write_finish) begin 
		$display("WRITE BASE ADDR %h, MEM WDATA %h", mem_addr, mem_wdata);
                pending_write_finish <= 1'b0;
                freeahb_write        <= 1'b0;
                freeahb_valid        <= 1'b0;
                write_ctr          <= write_ctr + 1;
            end
        end
    end
endmodule

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
    // 
    // Therefore we can assign our internal rdata_latch continuously to the
    // mem_rdata to the pico core, but we can only update this latched rdata
    // whenever HREADY is raised.
    if (BIG_ENDIAN_AHB == 1) begin
        assign mem_rdata[31:24] = latched_rdata[7:0];
        assign mem_rdata[23:16] = latched_rdata[15:8];
        assign mem_rdata[15:8]  = latched_rdata[23:16];
        assign mem_rdata[7:0]   = latched_rdata[31:24];
    end
    else begin
        assign mem_rdata         =     latched_rdata;
    end


    reg [3:0] write_ctr;     // Used to keep track of which bit in
    reg       transfer_done; // mem_valid will always be lowered after a cycle of mem_ready
                             // We need to ensure that we don't kick off a second round of the same transaction before the adapter sees the lowering of the signal.
    reg [31:0] latched_rdata;

    always @(posedge clk or negedge resetn) begin
        // IDLE memory system conditions
        if (!resetn || !mem_valid || mem_ready) begin
            freeahb_valid     <= 1'b0;
            freeahb_write     <= 1'b0;
            freeahb_read      <= 1'b0;
            mem_ready         <= 1'b0;
            write_ctr         <= 0;
            transfer_done     <= 1'b0;
        end

        // *************************************************************************
        // READS
        //**************************************************************************
        // READ transfer start
        else if (mem_wstrb == 4'b0000 && !freeahb_valid && !transfer_done) begin
            freeahb_wdata      <= 0;
            freeahb_valid      <= mem_valid;
            freeahb_addr       <= mem_addr;
            freeahb_size       <= 3'b010;
            freeahb_write      <= 1'b0;
            freeahb_read       <= 1'b1;
            freeahb_min_len    <= 0;
            freeahb_cont       <= 1'b0;
            freeahb_prot       <= mem_instr ? 4'b0000 : 4'b0001;
            freeahb_lock       <= 1'b0;
        end

        // READ transfer complete
        else if (mem_wstrb == 4'b0000 && freeahb_valid && freeahb_ready) begin
            mem_ready     <= 1'b1;
            freeahb_valid <= 1'b0;
            freeahb_read  <= 1'b0;
            transfer_done <= 1'b1;
            latched_rdata <= freeahb_rdata;
        end

        // *************************************************************************
        // WRITES
        // *************************************************************************

        // WRITE sequences
        // The mem IF outputs WSTRB (write strobes), but this is a AXI4 construct,
        // and does not suit AHB. We therefore have to translate the strobes to
        // individual AHB transfers.
        // There is room for improvement, such as combining sequential strobes
        // into one transfer, to reduce transfers from bestcase 4clk to bestcase
        // 1 clk (all bytes enabled
        else if (mem_wstrb != 4'b0000 && write_ctr < 4) begin
            // If we are to do a write, and freeahb indicates it is ready.
            if (mem_wstrb[3-write_ctr] == 1 && freeahb_next) begin
                case (3-write_ctr)
                    3: begin
                           // See the AMBA-spec for active byte lanes for the specific endianness.
                           // This is for a little-endian variant, but we should use a parameter to
                           // allow for a big-endian variant (or one which converts from little endian to big endian)
                           if (BIG_ENDIAN_AHB == 1) begin
                               freeahb_wdata[31:24] <= mem_wdata[31:24];
                           end
                           else begin
                               freeahb_wdata[7:0]   <= mem_wdata[31:24];
                           end

                           freeahb_addr             <= mem_addr + 3;
                       end

                    2: begin
                           if (BIG_ENDIAN_AHB == 1) begin
                               freeahb_wdata[31:24] <= mem_wdata[23:16];
                           end
                           else begin
                               freeahb_wdata[7:0]   <= mem_wdata[23:16];
                           end

                           freeahb_addr             <= mem_addr + 2;
                       end

                    1: begin
                           if (BIG_ENDIAN_AHB == 1) begin
                               freeahb_wdata[31:24] <= mem_wdata[15:8];
                           end
                           else begin
                               freeahb_wdata[7:0]   <= mem_wdata[15:8];
                           end

                            freeahb_addr            <= mem_addr + 1;
                       end

                    0: begin
                           if (BIG_ENDIAN_AHB == 1) begin
                               freeahb_wdata[31:24] <= mem_wdata[7:0];
                           end
                           else begin
                               freeahb_wdata[7:0]   <= mem_wdata[7:0];
                           end

                               freeahb_addr         <= mem_addr + 0;
                          end
                endcase

                freeahb_valid      <= 1'b1;
                freeahb_size       <= 3'b000; // byte
                freeahb_write      <= 1'b1;
                freeahb_read       <= 1'b0;
                freeahb_min_len    <= 8;
                freeahb_cont       <= 1'b0;    // Byte strobes are not necessarily
                                                                     // sequential. Start new transfer.
                freeahb_prot       <= mem_instr ? 4'b0000 : 4'b0001;
                freeahb_lock       <= 1'b0;  // Never lock, so we do not block the bus
                                      // indefinitely (remember we have absolutely
                                      // no cache, so instructions and data
                                      // will constantly be fetched...)
                write_ctr          <= write_ctr + 1;

            end

            // We are to write, but currently the FreeAHB isnt ready.
            // This can be due to it not being granted the bus, so we make sure to raise
            // freeahb_write.
            else if (mem_wstrb[3-write_ctr] == 1 && !freeahb_next) begin
                freeahb_write      <= 1'b1;
                freeahb_valid      <= 1'b0;
            end

            // If we do not write this round, we must make sure to make the FreeAHB idle.
            else if (mem_wstrb[3-write_ctr] == 0) begin
                freeahb_valid      <= 1'b0;
                freeahb_write      <= 1'b0;
                write_ctr          <= write_ctr + 1;
            end

        end

        // Write sequence finished
        else if (mem_wstrb != 4'b0000 && freeahb_next && write_ctr == 4) begin
            mem_ready     <= 1'b1;
            freeahb_write <= 1'b0;
            freeahb_valid <= 1'b0;
            transfer_done <= 1'b1;
        end
    end
endmodule

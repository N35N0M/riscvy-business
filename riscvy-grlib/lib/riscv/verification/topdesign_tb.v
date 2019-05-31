/*                                                                              
 * This testbench was originally located in the PicoRV repo:                    
 * https://github.com/cliffordwolf/picorv32 (scripts/cxxdemo)                   
 *                                                                              
 * It has been modified by placing the PicoRV-to-FreeAHB adapter and the FreeAHB
 * master between PicoRV and the system memory.
 */ 


`timescale 1 ns / 1 ps
`undef VERBOSE_MEM
`define WRITE_VCD
`undef MEM8BIT

module testbench;
    reg clk = 1;
    reg resetn = 0;
    wire trap;


    always #5 clk = ~clk;

    initial begin
        repeat (100) @(posedge clk);
        resetn <= 1;
    end

    // ADAPTER
    wire    [31:0]    freeahb_wdata;
    wire              freeahb_valid;
    wire    [31:0]    freeahb_addr;
    wire    [2:0]     freeahb_size;
    wire              freeahb_write;
    wire              freeahb_read;
    wire    [31:0]    freeahb_min_len;
    wire              freeahb_cont;
    wire    [3:0]     freeahb_prot;
    wire              freeahb_lock;
    wire              freeahb_next;

    wire    [31:0]    freeahb_rdata;
    wire    [31:0]    freeahb_result_addr;
    wire              freeahb_ready;

    // FREEAHB

    reg                i_hgrant = 1;
    reg      [31:0]    i_hrdata;
    reg                i_hready = 1;
    reg      [1:0]     i_hresp = 0;

    reg write_data_next = 0;
    reg [31:0] write_address = 0;

    wire    [31:0]    o_haddr;
    wire    [2:0]     o_hburst;
    wire    [2:0]     o_hsize;
    wire    [1:0]     o_htrans;
    wire     [31:0]    o_hwdata;
    wire              o_hwrite;
    wire              o_hbusreq;

    wire    [3:0]     o_hprot;
    wire              o_hlock;


    wire mem_valid;
    wire mem_instr;
    wire mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0] mem_wstrb;
    wire  [31:0] mem_rdata;

    picorv32 #(
        .COMPRESSED_ISA(1),
        .PROGADDR_RESET (32'h 4000_0000)
    ) uut (
        .clk                 (clk        ),
        .resetn              (resetn     ),
        .trap                (trap       ),
        .mem_valid           (mem_valid  ),
        .mem_instr           (mem_instr  ),
        .mem_ready           (mem_ready  ),
        .mem_addr            (mem_addr   ),
        .mem_wdata           (mem_wdata  ),
        .mem_wstrb           (mem_wstrb  ),
        .mem_rdata           (mem_rdata  )
    );

ahb_master #(.DATA_WDT(32), .BEAT_WDT(32)) FREEAHB_MAST (
    .i_hclk(clk),
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
    .*
);

picorv32_freeahb_adapter #(.BIG_ENDIAN_AHB(0)) FREEAHB_ADAPT    (
    .clk(clk),
    .resetn(resetn),
    .enable(1'b1),

    // FreeAHB UI
    .freeahb_wdata(freeahb_wdata),
    .freeahb_valid(freeahb_valid),
    .freeahb_addr(freeahb_addr),
    .freeahb_size(freeahb_size),
    .freeahb_write(freeahb_write),
    .freeahb_read(freeahb_read),
    .freeahb_min_len(freeahb_min_len),
    .freeahb_cont(freeahb_cont),
    .freeahb_prot(freeahb_prot),
    .freeahb_lock(freeahb_lock),

    .freeahb_next(freeahb_next),
    .freeahb_rdata(freeahb_rdata),
    .freeahb_result_addr(freeahb_result_addr),
    .freeahb_ready(freeahb_ready),

    // Pico interface
    .mem_valid(mem_valid),
    .mem_instr(mem_instr),
    .mem_ready(mem_ready),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_wstrb(mem_wstrb),
    .mem_rdata(mem_rdata)
);

    /* Larger memories (512MB, which we want for our-                           
     * 0x4000_0000-0x5000_0000 system) seem to crash VVP.                       
     *                                                                          
     * 8MB should do for most programs.                                         
     * Simulated memory becomes 0x0000_0000 to 0x0080_0000                      
     *                                                                          
     * The memory hex that is loaded in is modified to relocate the program        
     * from base 0x4000_0000 to 0x0000_0000, and then the memory requests made  
     * in the testbench is also modified so that the correct address offset is  
     * requested.                                                               
     */ 
    localparam MEM_SIZE = 1024*1024*256;

    localparam MEM_OFFSET = 32'h 4000_0000;

`ifdef MEM8BIT
    reg [7:0] memory [0:MEM_SIZE-1];
    initial $readmemh("firmware.hex", memory);
`else
    reg [31:0] memory [0:MEM_SIZE/4-1];
    initial $readmemh("firmware32.hex", memory);
`endif

    always @(posedge clk) begin
        if ((mem_valid && !mem_ready) || write_data_next) begin
            case (1)
            o_haddr == 32'h 8000_0103: begin
                       if (!write_data_next && o_htrans == 2'b10 && o_hwrite) begin
                            write_data_next <= 1;
                       end
                        else if (write_data_next) begin
                            write_data_next <= 0;
                $write("%c", o_hwdata[7:0]);
                        end
            end
                (mem_addr - MEM_OFFSET) < MEM_SIZE: begin
`ifdef MEM8BIT
                    if (|mem_wstrb) begin
                        if (mem_wstrb[0]) memory[mem_addr - MEM_OFFSET + 0] <= o_hwdata[ 7: 0];
                        if (mem_wstrb[1]) memory[mem_addr - MEM_OFFSET + 1] <= o_hwdata[7: 0];
                        if (mem_wstrb[2]) memory[mem_addr - MEM_OFFSET + 2] <= o_hwdata[7:0];
                        if (mem_wstrb[3]) memory[mem_addr - MEM_OFFSET + 3] <= o_hwdata[7:0];
                    end else begin
                        i_hrdata <= {   memory[mem_addr - MEM_OFFSET+3], 
                                        memory[mem_addr - MEM_OFFSET+2], 
                                        memory[mem_addr - MEM_OFFSET+1], 
                                        memory[mem_addr - MEM_OFFSET]
                        };
                    end
`else
                    if (|mem_wstrb || write_data_next) begin
                        if (!write_data_next && o_htrans == 2'b10 && o_hwrite) begin
                         write_data_next <= 1;
                         write_address <= o_haddr;
                        end
                        else if (write_data_next) begin
                            write_data_next <= 0;
                            if (write_address == mem_addr) memory[(mem_addr - MEM_OFFSET) >> 2][7:0] <= o_hwdata[7:0];
                            if (write_address == mem_addr+1) memory[(mem_addr - MEM_OFFSET) >> 2][15:8] <= o_hwdata[7:0];
                            if (write_address == mem_addr+2) memory[(mem_addr - MEM_OFFSET) >> 2][23:16] <= o_hwdata[7:0];
                            if (write_address == mem_addr+3)  memory[(mem_addr - MEM_OFFSET) >> 2][31:24] <= o_hwdata[7:0];
                        end
                    end else begin

                        i_hrdata <= memory[(mem_addr - MEM_OFFSET) >> 2];
                    end


`endif
                end


            endcase
        end
        if (mem_valid && mem_ready) begin
`ifdef VERBOSE_MEM
            if (|mem_wstrb)
                $display("WR: ADDR=%x DATA=%x MASK=%b", mem_addr - MEM_OFFSET, mem_wdata, mem_wstrb);
            else
                $display("RD: ADDR=%x DATA=%x%s", mem_addr - MEM_OFFSET, mem_rdata, mem_instr ? " INSN" : "");
`endif
            if (^mem_addr === 1'bx ||
                    (mem_wstrb[0] && ^mem_wdata[ 7: 0] == 1'bx) ||
                    (mem_wstrb[1] && ^mem_wdata[15: 8] == 1'bx) ||
                    (mem_wstrb[2] && ^mem_wdata[23:16] == 1'bx) ||
                    (mem_wstrb[3] && ^mem_wdata[31:24] == 1'bx)) begin
                $display("CRITICAL UNDEF MEM TRANSACTION");
                $finish;
            end
        end
    end

`ifdef WRITE_VCD
    initial begin
        $dumpfile("topdesign_tb.vcd");
        $dumpvars(0, testbench);
    end
`endif

    always @(posedge clk) begin
        if (resetn && trap) begin
            repeat (10) @(posedge clk);
            $display("TRAP");
            $finish;
        end
    end
endmodule

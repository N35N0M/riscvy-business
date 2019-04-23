`include "../shared/FreeAHB/ahb_master/sources/ahb_master.v"
`include "core/picorv32.v"

// This is what is seen by the GRLIB AMBA bus, so
module pico_ahb_master (
  input         HCLK,
  input         HRESETn,
  input         HGRANTx,
  input         HREADY,
  input [1:0]   HRESP,
  input [31:0]  HRDATA,

  output        BUSREQx,
  output        HLOCKx,
  output [1:0]  HTRANS,
  output [31:0] HADDR,
  output        HWRITE,
  output [2:0]  HSIZE,
  output [2:0]  HBURST,
  output [3:0]  HPROT,
  output [31:0] HWDATA
  );

  ahb_master  #(
    .DATA_WDT(32),
    .BEAT_WDT(32)
    ) freeahb_master
  (
    // Actual Full AHB Lines
    .i_hclk     (HCLK       ),
    .i_hreset_n (HRESETn    ),
    .i_hgrant   (HGRANTx    ),
    .i_hrdata   (HRDATA     ),
    .i_hready   (HREADY     ),
    .i_hresp    (HRESP      ),
    .o_haddr    (HADDR      ),
    .o_hburst   (HBURST     ),
    .o_hsize    (HSIZE      ),
    .o_htrans   (HTRANS     ),
    .o_hwdata   (HWDATA     ),
    .o_hwrite   (HWRITE     ),
    .o_hbusreq  (BUSREQx          ), //TODO: I suspect that currently we request and get granted the bus constantly for no reason.
    .o_hprot    (HPROT      ),
    .o_hlock    (HLOCKx     ),

    // Interfacing with the PicoRV adapter
    .o_next       (o_next     ), // Not used, we expect a single transfer.
    .i_data       (i_data     ),
    .i_valid      (i_valid    ),
    .i_addr       (i_addr     ),
    .i_size       (i_size     ),
    .i_write      (i_write    ),
    .i_read       (i_read     ),
    .i_min_len    (i_min_len  ),
    .i_cont       (i_cont     ), // Not used, we expect a single transfer.
    .o_data       (o_data     ),
    .o_addr       (o_addr     ), // Not used, we dont verify the read addr.
    .o_ready      (o_ready    ),
    .o_clk        (o_clk      ),
    .o_reset      (o_reset    ),
    .i_lock       (i_lock     ),
    .i_prot       (i_prot     )
  );

  wire o_next;
  wire [31:0] i_data;
  wire        i_valid;
  wire [31:0] i_addr;
  wire [2:0]  i_size;
  wire        i_write;
  wire        i_read;
  wire [31:0] i_min_len;
  wire        i_cont;
  wire [31:0] o_data;
  wire [31:0] o_addr;
  wire        o_ready;
  wire        o_clk;
  wire        o_reset;
  wire        i_lock;
  wire [3:0]  i_prot;

  picorv32_freeahb_adapter pico_ahb_adapter(
    // FreeAHB interface
    .freeahb_next(o_next), // Asserted indicates transfer finished.
    .freeahb_wdata(i_data),
    .freeahb_valid(i_valid),
    .freeahb_addr(i_addr),
    .freeahb_size(i_size),
    .freeahb_write(i_write),
    .freeahb_read(i_read),
    .freeahb_min_len(i_min_len),
    .freeahb_cont(i_cont),
    .freeahb_rdata(o_data),
    .freeahb_result_addr(o_addr), // Not used.
    .freeahb_ready(o_ready), 				// rdata contains valid data.
    .freeahb_clk(o_clk),
    .freeahb_resetn(o_reset),
    .freeahb_lock(i_lock),
    .freeahb_prot(i_prot),


    // Native PicoRV32 memory interface
    .mem_valid(mem_valid),
    .mem_instr(mem_instr),
    .mem_ready(mem_ready),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_wstrb(mem_wstrb),
    .mem_rdata(mem_rdata),

    // Clock and reset passed from the bus.
    .pico_clk(pico_clk),
    .pico_resetn(pico_resetn)
  );

  wire        mem_valid;
  wire        mem_instr;
  wire        mem_ready;
  wire [31:0] mem_addr;
  wire [31:0] mem_wdata;
  wire [3:0]  mem_wstrb;
  wire [31:0] mem_rdata;

  picorv32 #(
		.ENABLE_COUNTERS     (1                   ),
		.ENABLE_COUNTERS64   (1                   ),
		.ENABLE_REGS_16_31   (1                   ),
		.ENABLE_REGS_DUALPORT(1                   ),
    .LATCHED_MEM_RDATA   (1                   ), // Our implementation requires this, as adapter READY data can possibly only last one cycle.
		.TWO_STAGE_SHIFT     (1                   ),
		.BARREL_SHIFTER      (0                   ),
		.TWO_CYCLE_COMPARE   (0                   ),
		.TWO_CYCLE_ALU       (0                   ),
		.COMPRESSED_ISA      (0                   ),
		.CATCH_MISALIGN      (1                   ),
		.CATCH_ILLINSN       (1                   ),
		.ENABLE_PCPI         (0                   ),
		.ENABLE_MUL          (0                   ),
		.ENABLE_FAST_MUL     (0                   ),
		.ENABLE_DIV          (0                   ),
		.ENABLE_IRQ          (0                   ),
		.ENABLE_IRQ_QREGS    (1                   ),
		.ENABLE_IRQ_TIMER    (1                   ),
		.ENABLE_TRACE        (0                   ),
		.REGS_INIT_ZERO      (0                   ),
		.MASKED_IRQ          (32'h 0000_0000      ),
		.LATCHED_IRQ         (32'h ffff_ffff      ),
		.PROGADDR_RESET      (32'h 4000_0000      ), // Note that this prohibits that the LEON and the RISC run stuff at the same time.
		.PROGADDR_IRQ        (32'h 0000_0010      ),
		.STACKADDR           (32'h ffff_ffff      )
	) picorv32_core (
		.clk      (pico_clk),
		.resetn   (pico_resetn),
		.trap     (),

		.mem_valid(mem_valid),
		.mem_addr (mem_addr ),
		.mem_wdata(mem_wdata),
		.mem_wstrb(mem_wstrb),
		.mem_instr(mem_instr),
		.mem_ready(mem_ready),
		.mem_rdata(mem_rdata),

    .mem_la_read(),
    .mem_la_write(),
    .mem_la_addr(),
    .mem_la_wdata(),
    .mem_la_wstrb(),

		.pcpi_valid(),
		.pcpi_insn (),
		.pcpi_rs1  (),
		.pcpi_rs2  (),
		.pcpi_wr   (),
		.pcpi_rd   (),
		.pcpi_wait (),
		.pcpi_ready(),

		.irq(),
		.eoi(),

		.trace_valid(),
		.trace_data ()
	);
endmodule

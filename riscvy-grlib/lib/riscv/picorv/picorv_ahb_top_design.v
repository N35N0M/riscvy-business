`include "picorv_ahb_if.v"
`include "../shared/FreeAHB/ahb_master/sources/ahb_master.v"

// This is what is seen by the GRLIB AMBA bus, so
module riscv_ahb_master (
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

  picorv32_ahb_if #(
    // PicoRV parameters
    .ENABLE_COUNTERS     (1             ),
  	.ENABLE_COUNTERS64   (1             ),
  	.ENABLE_REGS_16_31   (1             ),
  	.ENABLE_REGS_DUALPORT(1             ),
  	.TWO_STAGE_SHIFT     (1             ),
  	.BARREL_SHIFTER      (0             ),
  	.TWO_CYCLE_COMPARE   (0             ),
  	.TWO_CYCLE_ALU       (0             ),
  	.COMPRESSED_ISA      (0             ),
  	.CATCH_MISALIGN      (1             ),
  	.CATCH_ILLINSN       (1             ),
  	.ENABLE_PCPI         (0             ),
  	.ENABLE_MUL          (0             ),
  	.ENABLE_FAST_MUL     (0             ),
  	.ENABLE_DIV          (0             ),
  	.ENABLE_IRQ          (0             ),
  	.ENABLE_IRQ_QREGS    (1             ),
  	.ENABLE_IRQ_TIMER    (1             ),
  	.ENABLE_TRACE        (0             ),
  	.REGS_INIT_ZERO      (0             ),
  	.MASKED_IRQ          (32'h 0000_0000),
  	.LATCHED_IRQ         (32'h ffff_ffff),
  	.PROGADDR_RESET      (32'h 0000_0000),
  	.PROGADDR_IRQ        (32'h 0000_0010),
  	.STACKADDR           (32'h ffff_ffff)
    ) pico_with_ahb_interface (
      .clk               (HCLK          ),
      .resetn            (RESETn        ),
      .trap              (              ),

      // Pico coprocessor interface. Unused.
      .pcpi_valid        (              ),
      .pcpi_insn         (              ),
      .pcpi_rs1          (              ),
      .pcpi_rs2          (              ),
      .pcpi_wr           (              ),
      .pcpi_rd           (              ),
      .pcpi_wait         (              ),
      .pcpi_ready        (              ),

      // Interrupt interface. Unused for now.
      .irq               (              ),
      .eoi               (              ),

      // Trace interface. Unused for now.
      .trace_valid       (              ),
      .trace_data        (              ),

      // PicoRV-AHB memory interface, wired to FreeAMBA master.
      .mem_ahb_valid     (i_valid       ),
      .mem_ahb_write     (i_write       ),
      .mem_ahb_read      (i_read        ),
      .mem_ahb_ready     (o_ready       ),
      .mem_ahb_wdata     (i_data        ),
      .mem_ahb_lock      (i_lock        ),
      .mem_ahb_prot      (i_prot        ),
      .mem_ahb_rdata     (o_data        ),
      .mem_ahb_addr      (i_addr        ),
      .mem_ahb_size      (i_size        )
    );

    wire        o_next; // Not currently used
    wire [31:0] i_data; // TODO: this really should be parameterized...
    wire        i_valid;
    wire [31:0] i_addr;
    wire [2:0]  i_size;
    wire        i_write;
    wire        i_read;
    wire [31:0] i_min_len;
    wire        i_cont; // Not used. We expect a single transfer only.
    wire [31:0] o_data;
    wire [31:0] o_addr;
    wire        o_ready;
    wire        i_prot;
    wire        i_lock;

    // FreeAHB AHB Master instance
    ahb_master  #(
      .DATA_WDT(32),
      .BEAT_WDT(32),
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
      .o_hbusreq  (HBUSREQx   ),
      .o_hprot    (HPROT      ),
      .o_hlock    (HLOCKx     ),

      // Interfacing with the PicoRV adapter
      .o_next       (           ), // Not used, we expect a single transfer.
      .i_data       (i_data     ),
      .i_valid      (i_valid    ),
      .i_addr       (i_addr     ),
      .i_size       (i_size     ),
      .i_write      (i_write    ),
      .i_read       (i_read     ),
      .i_min_len    (i_min_len  ),
      .i_cont       (           ), // Not used, we expect a single transfer.
      .o_data       (o_data     ),
      .o_addr       (           ), // Not used, we dont verify the read addr.
      .o_ready      (o_ready    ),
      .i_lock       (i_lock     ),
      .i_prot       (i_prot     )
    );


endmodule

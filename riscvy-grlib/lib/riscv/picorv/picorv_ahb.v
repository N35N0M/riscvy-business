// Beware: Includes are ignored by Vivado
`include "../shared/FreeAHB/ahb_master/sources/ahb_master.v"
`include "core/picorv32.v"

// This is what is seen by the GRLIB AMBA bus, so
module pico_ahb_master (
  input         HCLK,
  input         HRESETn,
  input [31:0]  HIRQ,
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
  output [31:0] HWDATA,

  input        ENABLE
  );


  // Wiring between PicoRV Memory IF to AHB adapter
  // and the FreeAHB master
  wire [31:0]     adapter_to_ahb_addr;
  wire            adapter_to_ahb_cont;
  wire [31:0]     adapter_to_ahb_data;
  wire            adapter_to_ahb_lock;
  wire [31:0]     adapter_to_ahb_min_len;
  wire [3:0]      adapter_to_ahb_prot;
  wire            adapter_to_ahb_read;
  wire [2:0]      adapter_to_ahb_size;
  wire            adapter_to_ahb_valid;
  wire            adapter_to_ahb_write;
  wire [31:0]     ahb_to_adapter_addr;
  wire [31:0]     ahb_to_adapter_data;
  wire            ahb_to_adapter_next;
  wire            ahb_to_adapter_ready;

  // Wiring between the PicoRV core and the PicoRV memory IF adapter.
  wire            pico_to_adapter_valid;
  wire            pico_to_adapter_instr;
  wire            adapter_to_pico_ready;
  wire [31:0]     pico_to_adapter_addr;
  wire [31:0]     pico_to_adapter_wdata;
  wire [3:0]      pico_to_adapter_wstrb;
  wire [31:0]     adapter_to_pico_rdata;
  
  ahb_master  #(
    .DATA_WDT(32),
    .BEAT_WDT(32)
    ) freeahb_master
  (
    // Actual Full AHB Lines
    .i_hclk       (HCLK       ),
    .i_hreset_n   (HRESETn    ),
    .i_hgrant     (HGRANTx    ),
    .i_hrdata     (HRDATA     ),
    .i_hready     (HREADY     ),
    .i_hresp      (HRESP      ),
    .o_haddr      (HADDR      ),
    .o_hburst     (HBURST     ),
    .o_hsize      (HSIZE      ),
    .o_htrans     (HTRANS     ),
    .o_hwdata     (HWDATA     ),
    .o_hwrite     (HWRITE     ),
    .o_hbusreq    (BUSREQx    ),
    .o_hprot      (HPROT      ),
    .o_hlock      (HLOCKx     ),

    // Interfacing with the PicoRV adapter
    .i_addr       (adapter_to_ahb_addr     ),
    .i_cont       (adapter_to_ahb_cont     ), // Not used, we expect a single transfer.
    .i_data       (adapter_to_ahb_data     ),
    .i_lock       (adapter_to_ahb_lock     ),
    .i_min_len    (adapter_to_ahb_min_len  ),
    .i_prot       (adapter_to_ahb_prot     ),
    .i_read       (adapter_to_ahb_read     ),
    .i_size       (adapter_to_ahb_size     ),
    .i_valid      (adapter_to_ahb_valid    ),
    .i_write      (adapter_to_ahb_write    ),
    .o_addr       (ahb_to_adapter_addr     ), // Not used, we dont verify the read addr.
    .o_data       (ahb_to_adapter_data     ),
    .o_next       (ahb_to_adapter_next     ), // Not used, we expect a single transfer.
    .o_ready      (ahb_to_adapter_ready    )
  );



  picorv32_freeahb_adapter #(.BIG_ENDIAN_AHB(1)) pico_ahb_adapter(
    .clk                  (HCLK               ),
    .resetn  	          (HRESETn    ),
    .enable               (ENABLE),

    // FreeAHB interface
    .freeahb_addr         (adapter_to_ahb_addr),
    .freeahb_next         (ahb_to_adapter_next), // Asserted indicates transfer finished.
    .freeahb_wdata        (adapter_to_ahb_data),
    .freeahb_valid        (adapter_to_ahb_valid),
    .freeahb_size         (adapter_to_ahb_size),
    .freeahb_write        (adapter_to_ahb_write),
    .freeahb_read         (adapter_to_ahb_read),
    .freeahb_min_len      (adapter_to_ahb_min_len),
    .freeahb_cont         (adapter_to_ahb_cont),
    .freeahb_rdata        (ahb_to_adapter_data),
    .freeahb_result_addr  (ahb_to_adapter_addr), // Not used.
    .freeahb_ready        (ahb_to_adapter_ready), 		 // rdata contains valid data.
    .freeahb_lock         (adapter_to_ahb_lock),
    .freeahb_prot         (adapter_to_ahb_prot),


    // Native PicoRV32 memory interface
    .mem_valid            (pico_to_adapter_valid),
    .mem_instr            (pico_to_adapter_instr),
    .mem_ready            (adapter_to_pico_ready),
    .mem_addr             (pico_to_adapter_addr),
    .mem_wdata            (pico_to_adapter_wdata),
    .mem_wstrb            (pico_to_adapter_wstrb),
    .mem_rdata            (adapter_to_pico_rdata)
    );

  picorv32 #(
  //.ENABLE_COUNTERS      (1                   ),
  //.ENABLE_COUNTERS64    (1                   ),
  //.ENABLE_REGS_16_31    (1                   ),
  //.ENABLE_REGS_DUALPORT (1                   ),
  //.LATCHED_MEM_RDATA    (0                   ),
  //.TWO_STAGE_SHIFT      (1                   ),
  //.BARREL_SHIFTER       (0                   ),
  //.TWO_CYCLE_COMPARE    (0                   ),
  //.TWO_CYCLE_ALU        (0                   ),
  .COMPRESSED_ISA       (1                   ),
  //.CATCH_MISALIGN       (1                   ),
  //.CATCH_ILLINSN        (1                   ),
  //.ENABLE_PCPI          (0                   ),
  //.ENABLE_MUL           (1                   ),
  //.ENABLE_FAST_MUL      (0                   ),
  //.ENABLE_DIV           (1                   ),
  //.ENABLE_IRQ           (0                   ),
  //.ENABLE_IRQ_QREGS     (1                   ),
  //.ENABLE_IRQ_TIMER     (1                   ),
  //.ENABLE_TRACE         (0                   ),
  //.REGS_INIT_ZERO       (0                   ),  // DEBUG ONLY
  //.MASKED_IRQ           (32'h 0000_0000      ),
  //.LATCHED_IRQ          (32'h ffff_ffff      ),
  .PROGADDR_RESET       (32'h 4000_0000      ), 
  //.PROGADDR_IRQ         (32'h 4000_0010      ),
  //.STACKADDR            (32'h 4010_0000      )
  ) picorv32_core (
    // Clock, reset, traps
  .clk                  (HCLK                  ),
  .resetn               (HRESETn               ),
  .trap                 (                  ),

    // Memory interface output
  .mem_valid            (pico_to_adapter_valid),
  .mem_addr             (pico_to_adapter_addr ),
  .mem_wdata            (pico_to_adapter_wdata),
  .mem_wstrb            (pico_to_adapter_wstrb),
  .mem_instr            (pico_to_adapter_instr),

    // Memory interface inputs
  .mem_ready            (adapter_to_pico_ready),
  .mem_rdata            (adapter_to_pico_rdata),

    // Memory Look-Ahead Interface (not used)
  .mem_la_read          (),
  .mem_la_write         (),
  .mem_la_addr          (),
  .mem_la_wdata         (),
  .mem_la_wstrb         (),

    // PCPI coprocessor interface (not used)
  .pcpi_valid           (),
  .pcpi_insn            (),
  .pcpi_rs1             (),
  .pcpi_rs2             (),
  .pcpi_wr              (),
  .pcpi_rd              (),
  .pcpi_wait            (),
  .pcpi_ready           (),

    // Interrupt connection (not used)
  .irq                  (HIRQ),
  .eoi                  (), // The interrupts we utilize are pulse-based
							// i.e. they are only held valid one clock cycle
							// and hence does not need to be cleared by
							// the outgoing End Of Interrupt signal.
    // Processor trace output (not used)
  .trace_valid          (),
  .trace_data           ()
  );
endmodule

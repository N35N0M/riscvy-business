/***************************************************************
 * picorv32_to_ahb_master_adapter
   Similar to the provided axi-adapter, but with modifications.
 ***************************************************************/

module picorv32_to_ahb_master_adapter (
	input clk, resetn,

  // AHB master memory interface
  output mem_ahb_valid,
  output mem_ahb_write,
	output mem_ahb_read,
  input mem_ahb_ready,
  output [31:0] mem_ahb_wdata,
  output [3:0] mem_ahb_prot, // We can set instr/data, but hardly any of the other bits since we don't cache anything?
	output 			 mem_ahb_lock;
  input [31:0] mem_ahb_rdata,
  output [31:0] mem_ahb_addr,
  output [2:0]  mem_ahb_size,

	// Native PicoRV32 memory interface
	input         mem_valid,
	input         mem_instr,
	output        mem_ready,
	input  [31:0] mem_addr,
	input  [31:0] mem_wdata,
	input  [ 3:0] mem_wstrb,
	output [31:0] mem_rdata
);

	// This is equivalent to setting values by putting these (without assing) in a always @*
  assign mem_ahb_prot  = mem_instr ? 4'b0000 : 4'b0001; // Cacheable?, bufferable?, privileged?, data?
	assign mem_ahb_lock  = 0'b1; // Always a locked transfer
  assign mem_ahb_valid = mem_valid;
  assign mem_ahb_wdata = mem_data;
  assign mem_ahb_waddr = mem_addr;
  assign mem_ready     = mem_ahb_ready;
  assign mem_rdata     = mem_ahb_rdata;

	// The original FreeAHB uses dedicated write and read signals in combination with valid to
	// detect a start of transfer..
	assign mem_ahb_write <= mem_wstrb == 4'b0000 ? 1'b0 : 1'b1;
	assign mem_ahb_read  <= mem_wstrb == 4'b0000 ? 1'b1 : 1'b0;


  // Determine size of the transfer for the AHB master, which doesn't use WTRB, which AXI does.
  // TODO: A cleaner solution would be to dive into the processor and make it specify a AHB-friendly HSIZE instead.
  //       But at this time, I have just started to write some Verilog, and am not comfortable with going too deep in it yet.
  always @(posedge clk) begin
    if (mem_wstrb == 4'b1111)  //write aligned full word
      mem_ahb_size <= 3'b010;
    if (mem_wstrb == 4'b011)  //write aligned half word
      mem_ahb_size <= 3'b001;
    if (mem_wstrb == 4'b001) begin //write aligned byte
      mem_ahb_size <= 3'b000;
    end else begin // Default case is to always write all 32-bits. TODO: This might not be a good decision. Maybe should not be supported at all.
      mem_ahb_size <= 3'b010;
    end
  end

endmodule

// *****************************************************************************
// picorv32_to_freeahb_adapter
// *****************************************************************************

module picorv32_freeahb_adapter (
  // FreeAHB interface
  output reg			[31:0]		freeahb_wdata,
  output reg								freeahb_valid,
	output reg			[31:0]		freeahb_addr,
	output reg     [2:0]			freeahb_size,
	output reg								freeahb_write,
	output reg								freeahb_read,
	output reg			[31:0]		freeahb_min_len,// Minimum "guaranteed size of burst"
	output reg								freeahb_cont, 			// Continues prev transfer
  output reg			[3:0]			freeahb_prot,
	output reg								freeahb_lock,

	input 								freeahb_next, // Asserted indicates transfer finished.
	input 			[31:0]		freeahb_rdata,
	input       [31:0]    freeahb_result_addr, // Not used.
	input 								freeahb_ready, 				// rdata contains valid data.

	input 								freeahb_clk,
	input 								freeahb_resetn,

	// Native PicoRV32 memory interface
	input         				mem_valid,
	input         				mem_instr,
	output reg       			mem_ready,
	input  			[31:0] 		mem_addr,
	input  			[31:0] 		mem_wdata,
	input  			[3:0] 		mem_wstrb,
	output 			[31:0] 		mem_rdata,

	// Clock and reset passed from the bus.
	output 								pico_clk,
	output 								pico_resetn
);

  assign pico_clk 		=	freeahb_clk;
	assign pico_resetn 	= freeahb_resetn;
	assign mem_rdata 		= freeahb_rdata;


	reg [3:0] write_ctr;	// Used to keep track of which bit in
												// wstrb we are working on.

	always @(posedge freeahb_clk or negedge freeahb_resetn) begin
	  // Idle/reset conditions.
		// We expect that a finished transfer (mem_ready) always lowers mem_valid.
		if (!freeahb_resetn || !mem_valid) begin
			freeahb_valid <= 0;
			mem_ready 		<= 0;
			write_ctr 		<= 0;
		end

		// *************************************************************************
		// READS
		//**************************************************************************
		// READ transfer start
		else if (mem_wstrb == 4'b0000 && !freeahb_valid) begin
			freeahb_wdata 			<= 0;
			freeahb_valid 			<= mem_valid;
			freeahb_addr  			<= mem_addr;
			freeahb_size  			<= 3'b010;
			freeahb_write 			<= 1'b0;
			freeahb_read  			<= 1'b1;
			freeahb_min_len 	  <= 32;
			freeahb_cont				<= 1'b0;
			freeahb_prot				<= mem_instr ? 4'b0000 : 4'b0001;
			freeahb_lock				<= 1'b1;
		end

		// READ transfer complete
		else if (mem_wstrb == 4'b0000 && freeahb_valid && freeahb_ready) begin
			mem_ready <= 1'b1;
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
		else if (mem_wstrb != 4'b0000 && freeahb_next && write_ctr < 4) begin
		  if (mem_wstrb[3-write_ctr] === 1) begin
				case (3-write_ctr)
					3:	begin
								freeahb_wdata 			<= mem_wdata[31:24];
								freeahb_addr  			<= mem_addr;

							end
					2: begin
								freeahb_wdata 			<= mem_wdata[23:16];
								freeahb_addr  			<= mem_addr + 1;

						 end
					1:
						 begin
						 		freeahb_wdata 			<= mem_wdata[15:8];
						 		freeahb_addr  			<= mem_addr + 2;
						 end
					0:
	 					 begin
						 		freeahb_wdata 			<= mem_wdata[7:0];
						 		freeahb_addr  			<= mem_addr + 3;
	 					 end
				endcase

				freeahb_valid 			<= mem_valid;
				freeahb_size  			<= 3'b000; // byte
				freeahb_write 			<= 1'b1;
				freeahb_read  			<= 1'b0;
				freeahb_min_len 		<= 8;
				freeahb_cont				<= 1'b0;	// Byte strobes are not necessarily
																			// sequential. Start new transfer.
				freeahb_prot				<= mem_instr ? 4'b0000 : 4'b0001;
				freeahb_lock				<= 1'b1;  // We always lock to ensure that the
																			// entire write is done noninterrupted.

			end
			write_ctr <= write_ctr + 1;
		end

		// If we couldnt start the next write, it can be because
		// FreeAHB doesnt have the bus. Setting i_write to 1 will do.
		else if (mem_wstrb != 4'b0000 && write_ctr < 4) begin
			freeahb_write <= 1;
		end

		// Write sequence finished
		else if (mem_wstrb != 4'b0000 && freeahb_next && write_ctr == 4)
			mem_ready <= 1'b1;
		end

endmodule

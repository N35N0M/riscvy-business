/*
Copyright (c) 2012-2015, The Regents of the University of California (Regents).
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. Neither the name of the Regents nor the
   names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING
OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF REGENTS HAS
BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED
HEREUNDER IS PROVIDED "AS IS". REGENTS HAS NO OBLIGATION TO PROVIDE
MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
*/

// This testbench was originally located in the PicoRV repo.
// Has been slightly modified to be able to run with a memory offset
// instead of 0x00000000 only.

`timescale 1 ns / 1 ps
`define VERBOSE_MEM
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

    wire mem_valid;
    wire mem_instr;
    reg mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0] mem_wstrb;
    reg  [31:0] mem_rdata;

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


    // Larger memories (1GB) seem to crash VVP.
    //8MB should do for most programs.
    // 0x0000_0000 to 0x0080_0000
    localparam MEM_SIZE   = 1024*1024*256;
    localparam MEM_OFFSET = 32'h 4000_0000;

    `ifdef MEM8BIT
    reg [7:0] memory [0:MEM_SIZE-1];
    initial $readmemh("firmware.hex", memory);

    `else
    reg [31:0] memory [0:MEM_SIZE/4-1];
    initial $readmemh("firmware32.hex", memory);

    `endif

    always @(posedge clk) begin
        mem_ready <= 0;
        if (mem_valid && !mem_ready) begin
            mem_ready <= 1;
            mem_rdata <= 'bx;
            case (1)
            mem_addr == 32'h 8000_0100: begin
                $write("%c", mem_wdata[7:0]);
            end
                (mem_addr - MEM_OFFSET) < MEM_SIZE: begin
                `ifdef MEM8BIT
                    if (|mem_wstrb) begin
                        if (mem_wstrb[0]) memory[mem_addr - MEM_OFFSET + 0] <= mem_wdata[ 7: 0];
                        if (mem_wstrb[1]) memory[mem_addr - MEM_OFFSET + 1] <= mem_wdata[15: 8];
                        if (mem_wstrb[2]) memory[mem_addr - MEM_OFFSET + 2] <= mem_wdata[23:16];
                        if (mem_wstrb[3]) memory[mem_addr - MEM_OFFSET + 3] <= mem_wdata[31:24];
                    end else begin
                        mem_rdata <= {memory[mem_addr - MEM_OFFSET+3], memory[mem_addr - MEM_OFFSET+2], memory[mem_addr - MEM_OFFSET+1], memory[mem_addr - MEM_OFFSET]};
                    end
                `else
                    if (|mem_wstrb) begin
                        if (mem_wstrb[0]) memory[(mem_addr - MEM_OFFSET) >> 2][ 7: 0] <= mem_wdata[ 7: 0];
                        if (mem_wstrb[1]) memory[(mem_addr - MEM_OFFSET) >> 2][15: 8] <= mem_wdata[15: 8];
                        if (mem_wstrb[2]) memory[(mem_addr - MEM_OFFSET) >> 2][23:16] <= mem_wdata[23:16];
                        if (mem_wstrb[3]) memory[(mem_addr - MEM_OFFSET) >> 2][31:24] <= mem_wdata[31:24];
                    end else begin
                        mem_rdata <= memory[(mem_addr - MEM_OFFSET) >> 2];
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
        $dumpfile("testbench.vcd");
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

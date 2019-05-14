// Original testbench by Revanth Kamaraj, https://github.com/krevanth/FreeAHB
// This is a derived version to better suit our needs.

`define X_INJECTION 1

module ahb_master_test;

    parameter DATA_WDT = 32;
    parameter BEAT_WDT = 32;

    // Clock and reset
    bit                     i_hclk;
    bit                     i_hreset_n;

    // AHB signals. Please see spec for more info.
    logic                   i_hgrant;
    logic   [DATA_WDT-1:0]  i_hrdata;
    logic                   i_hready;
    logic   [1:0]           i_hresp;

    logic   [31:0]          o_haddr;
    logic   [2:0]           o_hburst;
    logic   [2:0]           o_hsize;
    logic   [1:0]           o_htrans;
    logic   [DATA_WDT-1:0]  o_hwdata;
    logic                   o_hwrite;
    logic                   o_hbusreq;

    logic   [3:0]           o_hprot;
    logic                   o_hlock;


    // User interface.
    logic                   o_next;     // UI must change only if this is 1.
    logic   [DATA_WDT-1:0]  i_data;     // Data to write. Change on o_next = 1.
    bit                     i_valid;    // Data to write valid. ---""---
    bit     [31:0]          i_addr;     // Base address of burst.
    bit     [2:0]           i_size;     // HSIZE
    bit                     i_write;    // Write to AHB bus.
    bit                     i_read;     // Read from AHB bus.
    bit     [BEAT_WDT-1:0]  i_min_len;  // Minimum guaranteed length of burst.
    bit                     i_cont;     // Current transfer continues previous.
    logic   [DATA_WDT-1:0]  o_data;     // Data got from AHB is presented here.
    logic   [31:0]          o_addr;     // Address to corresponding o_data
    logic                   o_ready;    // Used as o_data valid indicator.

    logic   [3:0]           i_prot;     // HPROT, protection information.
    logic                   i_lock;     // HLOCK, require bus lock.

    logic [DATA_WDT-1:0] hwdata0, hwdata1;

    assign hwdata0 = U_AHB_MASTER.o_hwdata[0];
    assign hwdata1 = U_AHB_MASTER.o_hwdata[1];

    ahb_master      #(.DATA_WDT(DATA_WDT), .BEAT_WDT(BEAT_WDT))
                    U_AHB_MASTER(.*);

    always #10 i_hclk++;

    always @ (posedge i_hclk)
    begin
        if ( o_hbusreq )
            i_hgrant <= 1'd1;
        else
            i_hgrant <= 1'd0;

        i_hready <= $random;// Randomly raise HREADY.
        i_hresp  <= 2'b00;  // AHB Slave, OKAY response, all the time.
                            // Master receives HREADY and OKAY
                            // when transfer is successful.
    end

    bit dav;
    bit [31:0] dat;

    initial
    begin
        $dumpfile("freeahb_tb.vcd");
        $dumpvars;

        i_hgrant <= 1;

        // ********************************************************************
        // SEQUENCE 1: Locked sequence burst transfers with no BUSY states,
        // rand HREADY. This is the original testbench, but without random
        // dav, and with hprot and hlock)
        // ********************************************************************

        i_hreset_n  <= 1'd0;
        d(1);
        i_hreset_n  <= 1'd1;

        // Set IDLE for some time.
        i_read      <= 0;
        i_write     <= 0;

        repeat(10) @(posedge i_hclk);

        // We can change inputs at any time.
        // Starting a write burst.
        i_min_len     <= 42;
        i_write       <= 1'd1;
        i_cont        <= 1'd0; // First txn.
        i_valid       <= 1'd1; // First UI in write burst must have valid data.
        i_data        <= 0;    // First data is 0.
        i_lock        <= 1;    // Lock the bus.
        i_prot        <= 4'b0001; // Data access.

        // Further change requires o_next.
        wait_for_next;

        // Write to the unit as if reading from a FIFO with intermittent
        // FIFO empty conditions shown as dav = 0.
        repeat(100)
        begin: bk1
            dav = 1;         // Blocking assignment
            dat = dat + dav; // Blocking assignment

            i_cont      <= 1'd1;
            i_valid     <= dav;

            // This technique is called x-injection.
            i_data    <= dav ? dat :
            `ifdef X_INJECTION
                32'dx;
            `else
                0;
            `endif

            wait_for_next;
        end

        // Go to IDLE.
        i_read    <= 1'd0;
        i_write   <= 1'd0;
        i_cont    <= 1'd0;


        //*********************************************************************
        // SEQUENCE 2: Sequential burst transfers with BUSY states, rand HREADY
        //*********************************************************************
        i_hreset_n <= 1'd0;
        d(1);
        i_hreset_n <= 1'd1;

        // Set IDLE for some time.
        i_read  <= 0;
        i_write <= 0;

        repeat(20) @(posedge i_hclk);

        // We can change inputs at any time.
        // Starting a write burst.
        i_min_len     <= 42;
        i_write       <= 1'd1;
        i_cont        <= 1'd0; // First txn.
        i_valid       <= 1'd1; // First UI of a write burst must have data.
        i_data        <= 0;    // First data is 0.
        i_lock        <= 1;
        i_prot        <= 4'b0001;   // Data access.

        dat = 0;                    // Clear write data.

        // Further change requires o_next.
        wait_for_next;

        // Write to the unit as if reading from a FIFO with intermittent
        // FIFO empty conditions shown as dav = 0.
        repeat(100)
        begin: bk2
                dav = $random;
                dat = dat + dav;

                i_cont      <= 1'd1;
                i_valid     <= dav;

                // This technique is called x-injection.
                i_data    <= dav ? dat :
                `ifdef X_INJECTION
                        32'dx;
                `else
                        0;
                `endif

                wait_for_next;
        end

        // Go to IDLE.
        i_read    <= 1'd0;
        i_write   <= 1'd0;
        i_cont    <= 1'd0;

        repeat(10) @(posedge i_hclk);

        $finish;
    end

    task wait_for_next;
        d(1);
        while(o_next !== 1)
        begin
            d(1);
        end
    endtask

    task d(int x);
        repeat(x)
        @(posedge i_hclk);
    endtask

endmodule

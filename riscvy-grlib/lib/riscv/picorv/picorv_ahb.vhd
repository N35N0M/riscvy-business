-- This wrapper is a combination of grlib.pdf's chapter 8.3 (but adapted for a master, not a slave),
-- and Xilinx' suggestion for instantiating a Verilog module to a VHDL library.

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library grlib;
use grlib.amba.all;
use grlib.config_types.all;
use grlib.config.all;
use grlib.stdlib.all;
use grlib.devices.all;

entity picorv_grlib_ahb_master is
	generic (master_index	:	integer := 2);
	port (
		rst	  :		in    std_ulogic;
		clk	  :		in    std_ulogic;
        enable :    in    std_ulogic;
		ahbmi	:	  in    ahb_mst_in_type;
		ahbmo	:	  out   ahb_mst_out_type);
end;

architecture pico of picorv_grlib_ahb_master is
	component pico_ahb_master
		port (
			HCLK		:	in  std_ulogic;
			HRESETn :	in  std_ulogic;
            HIRQ    :   in std_logic_vector(31 downto 0); -- TODO: Not quite sure if all 32 IRQs are enabled by default...
			HGRANTx :	in  std_ulogic;
			HREADY 	:	in  std_ulogic;
			HRESP		:	in  std_logic_vector(1 downto 0);
			HRDATA	:	in  std_logic_vector(31 downto 0);

			BUSREQx	:	out std_ulogic;
			HLOCKx	:	out std_ulogic;
			HTRANS	:	out std_logic_vector(1 downto 0);
			HADDR		:	out std_logic_vector(31 downto 0);
			HWRITE	:	out std_ulogic;
			HSIZE		:	out std_logic_vector(2 downto 0);
			HBURST	:	out std_logic_vector(2 downto 0);
			HPROT		:	out std_logic_vector(3 downto 0);
			HWDATA	:	out std_logic_vector(31 downto 0);
            ENABLE  : in std_ulogic);

	end component;

	-- GRLIB Plug&play information --
	constant HCONFIG: ahb_config_type := (
		-- Only the first config word must be defined for masters (all other words are memory areas, and that is not applicable for master(s))
		0 => ahb_device_reg (VENDOR_CONTRIB, CONTRIB_CORE1, 0, 0, 0), -- Note that the free version of GRMON does not allow us to use custom vendors or partids.
		others => X"00000000");

begin
	ahbmo.hconfig 	<= HCONFIG; 
	ahbmo.hindex    <= master_index; 
	ahbmo.hirq 		<= (others => '0'); -- We do not drive any interrupts.

	wrapped_picorv: pico_ahb_master
		port map(
			HCLK 				=> clk,
			HRESETn 			=> rst,
            HIRQ                => ahbmi.hirq,
			HGRANTx				=> ahbmi.hgrant(master_index),
			HREADY				=> ahbmi.hready,
			HRESP					=> ahbmi.hresp,
			HRDATA				=> ahbmi.hrdata,

			BUSREQx				=> ahbmo.hbusreq,
			HLOCKx				=> ahbmo.hlock,
			HTRANS				=> ahbmo.htrans,
			HADDR					=> ahbmo.haddr,
			HWRITE				=> ahbmo.hwrite,
			HSIZE					=> ahbmo.hsize,
			HBURST	 			=> ahbmo.hburst,
			HPROT					=> ahbmo.hprot,
			HWDATA        => ahbmo.hwdata,
            ENABLE        => enable);
            
            
end;

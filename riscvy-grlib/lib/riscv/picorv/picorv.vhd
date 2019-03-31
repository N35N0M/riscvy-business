library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library grlib;
use grlib.amba.all;
use grlib.config_types.all;
use grlib.config.all;
use grlib.stdlib.all;

package picorv is
        component picorv_grlib_ahb_master is
                generic (
                        hindex  :       integer := 0);
                port (
                        rst     :       in std_ulogic;
                        clk     :       in std_ulogic;
                        ahbmi   :       in ahb_mst_in_type;
                        ahbmo   :       out ahb_mst_out_type);
        end component;
end;

-- (c) Copyright 1995-2019 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:ip:processing_system7:5.3
-- IP Revision: 1

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT leon3_zc702_stub_processing_system7_0_0
  PORT (
    USB0_PORT_INDCTL : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    USB0_VBUS_PWRSELECT : OUT STD_LOGIC;
    USB0_VBUS_PWRFAULT : IN STD_LOGIC;
    S_AXI_GP0_ARREADY : OUT STD_LOGIC;
    S_AXI_GP0_AWREADY : OUT STD_LOGIC;
    S_AXI_GP0_BVALID : OUT STD_LOGIC;
    S_AXI_GP0_RLAST : OUT STD_LOGIC;
    S_AXI_GP0_RVALID : OUT STD_LOGIC;
    S_AXI_GP0_WREADY : OUT STD_LOGIC;
    S_AXI_GP0_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_GP0_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_GP0_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_GP0_BID : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    S_AXI_GP0_RID : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    S_AXI_GP0_ACLK : IN STD_LOGIC;
    S_AXI_GP0_ARVALID : IN STD_LOGIC;
    S_AXI_GP0_AWVALID : IN STD_LOGIC;
    S_AXI_GP0_BREADY : IN STD_LOGIC;
    S_AXI_GP0_RREADY : IN STD_LOGIC;
    S_AXI_GP0_WLAST : IN STD_LOGIC;
    S_AXI_GP0_WVALID : IN STD_LOGIC;
    S_AXI_GP0_ARBURST : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_GP0_ARLOCK : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_GP0_ARSIZE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S_AXI_GP0_AWBURST : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_GP0_AWLOCK : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_GP0_AWSIZE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S_AXI_GP0_ARPROT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S_AXI_GP0_AWPROT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S_AXI_GP0_ARADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_GP0_AWADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_GP0_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_GP0_ARCACHE : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S_AXI_GP0_ARLEN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S_AXI_GP0_ARQOS : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S_AXI_GP0_AWCACHE : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S_AXI_GP0_AWLEN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S_AXI_GP0_AWQOS : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S_AXI_GP0_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S_AXI_GP0_ARID : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    S_AXI_GP0_AWID : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    S_AXI_GP0_WID : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    FCLK_CLK0 : OUT STD_LOGIC;
    FCLK_CLK1 : OUT STD_LOGIC;
    FCLK_RESET0_N : OUT STD_LOGIC;
    MIO : INOUT STD_LOGIC_VECTOR(53 DOWNTO 0);
    DDR_CAS_n : INOUT STD_LOGIC;
    DDR_CKE : INOUT STD_LOGIC;
    DDR_Clk_n : INOUT STD_LOGIC;
    DDR_Clk : INOUT STD_LOGIC;
    DDR_CS_n : INOUT STD_LOGIC;
    DDR_DRSTB : INOUT STD_LOGIC;
    DDR_ODT : INOUT STD_LOGIC;
    DDR_RAS_n : INOUT STD_LOGIC;
    DDR_WEB : INOUT STD_LOGIC;
    DDR_BankAddr : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    DDR_Addr : INOUT STD_LOGIC_VECTOR(14 DOWNTO 0);
    DDR_VRN : INOUT STD_LOGIC;
    DDR_VRP : INOUT STD_LOGIC;
    DDR_DM : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    DDR_DQ : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    DDR_DQS_n : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    DDR_DQS : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    PS_SRSTB : INOUT STD_LOGIC;
    PS_CLK : INOUT STD_LOGIC;
    PS_PORB : INOUT STD_LOGIC
  );
END COMPONENT;
ATTRIBUTE SYN_BLACK_BOX : BOOLEAN;
ATTRIBUTE SYN_BLACK_BOX OF leon3_zc702_stub_processing_system7_0_0 : COMPONENT IS TRUE;
ATTRIBUTE BLACK_BOX_PAD_PIN : STRING;
ATTRIBUTE BLACK_BOX_PAD_PIN OF leon3_zc702_stub_processing_system7_0_0 : COMPONENT IS "USB0_PORT_INDCTL[1:0],USB0_VBUS_PWRSELECT,USB0_VBUS_PWRFAULT,S_AXI_GP0_ARREADY,S_AXI_GP0_AWREADY,S_AXI_GP0_BVALID,S_AXI_GP0_RLAST,S_AXI_GP0_RVALID,S_AXI_GP0_WREADY,S_AXI_GP0_BRESP[1:0],S_AXI_GP0_RRESP[1:0],S_AXI_GP0_RDATA[31:0],S_AXI_GP0_BID[5:0],S_AXI_GP0_RID[5:0],S_AXI_GP0_ACLK,S_AXI_GP0_ARVALID,S_AXI_GP0_AWVALID,S_AXI_GP0_BREADY,S_AXI_GP0_RREADY,S_AXI_GP0_WLAST,S_AXI_GP0_WVALID,S_AXI_GP0_ARBURST[1:0],S_AXI_GP0_ARLOCK[1:0],S_AXI_GP0_ARSIZE[2:0],S_AXI_GP0_AWBURST[1:0],S_AXI_GP0_AWLOCK[1:0],S_AXI_GP0_AWSIZE[2:0],S_AXI_GP0_ARPROT[2:0],S_AXI_GP0_AWPROT[2:0],S_AXI_GP0_ARADDR[31:0],S_AXI_GP0_AWADDR[31:0],S_AXI_GP0_WDATA[31:0],S_AXI_GP0_ARCACHE[3:0],S_AXI_GP0_ARLEN[3:0],S_AXI_GP0_ARQOS[3:0],S_AXI_GP0_AWCACHE[3:0],S_AXI_GP0_AWLEN[3:0],S_AXI_GP0_AWQOS[3:0],S_AXI_GP0_WSTRB[3:0],S_AXI_GP0_ARID[5:0],S_AXI_GP0_AWID[5:0],S_AXI_GP0_WID[5:0],FCLK_CLK0,FCLK_CLK1,FCLK_RESET0_N,MIO[53:0],DDR_CAS_n,DDR_CKE,DDR_Clk_n,DDR_Clk,DDR_CS_n,DDR_DRSTB,DDR_ODT,DDR_RAS_n,DDR_WEB,DDR_BankAddr[2:0],DDR_Addr[14:0],DDR_VRN,DDR_VRP,DDR_DM[3:0],DDR_DQ[31:0],DDR_DQS_n[3:0],DDR_DQS[3:0],PS_SRSTB,PS_CLK,PS_PORB";

-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : leon3_zc702_stub_processing_system7_0_0
  PORT MAP (
    USB0_PORT_INDCTL => USB0_PORT_INDCTL,
    USB0_VBUS_PWRSELECT => USB0_VBUS_PWRSELECT,
    USB0_VBUS_PWRFAULT => USB0_VBUS_PWRFAULT,
    S_AXI_GP0_ARREADY => S_AXI_GP0_ARREADY,
    S_AXI_GP0_AWREADY => S_AXI_GP0_AWREADY,
    S_AXI_GP0_BVALID => S_AXI_GP0_BVALID,
    S_AXI_GP0_RLAST => S_AXI_GP0_RLAST,
    S_AXI_GP0_RVALID => S_AXI_GP0_RVALID,
    S_AXI_GP0_WREADY => S_AXI_GP0_WREADY,
    S_AXI_GP0_BRESP => S_AXI_GP0_BRESP,
    S_AXI_GP0_RRESP => S_AXI_GP0_RRESP,
    S_AXI_GP0_RDATA => S_AXI_GP0_RDATA,
    S_AXI_GP0_BID => S_AXI_GP0_BID,
    S_AXI_GP0_RID => S_AXI_GP0_RID,
    S_AXI_GP0_ACLK => S_AXI_GP0_ACLK,
    S_AXI_GP0_ARVALID => S_AXI_GP0_ARVALID,
    S_AXI_GP0_AWVALID => S_AXI_GP0_AWVALID,
    S_AXI_GP0_BREADY => S_AXI_GP0_BREADY,
    S_AXI_GP0_RREADY => S_AXI_GP0_RREADY,
    S_AXI_GP0_WLAST => S_AXI_GP0_WLAST,
    S_AXI_GP0_WVALID => S_AXI_GP0_WVALID,
    S_AXI_GP0_ARBURST => S_AXI_GP0_ARBURST,
    S_AXI_GP0_ARLOCK => S_AXI_GP0_ARLOCK,
    S_AXI_GP0_ARSIZE => S_AXI_GP0_ARSIZE,
    S_AXI_GP0_AWBURST => S_AXI_GP0_AWBURST,
    S_AXI_GP0_AWLOCK => S_AXI_GP0_AWLOCK,
    S_AXI_GP0_AWSIZE => S_AXI_GP0_AWSIZE,
    S_AXI_GP0_ARPROT => S_AXI_GP0_ARPROT,
    S_AXI_GP0_AWPROT => S_AXI_GP0_AWPROT,
    S_AXI_GP0_ARADDR => S_AXI_GP0_ARADDR,
    S_AXI_GP0_AWADDR => S_AXI_GP0_AWADDR,
    S_AXI_GP0_WDATA => S_AXI_GP0_WDATA,
    S_AXI_GP0_ARCACHE => S_AXI_GP0_ARCACHE,
    S_AXI_GP0_ARLEN => S_AXI_GP0_ARLEN,
    S_AXI_GP0_ARQOS => S_AXI_GP0_ARQOS,
    S_AXI_GP0_AWCACHE => S_AXI_GP0_AWCACHE,
    S_AXI_GP0_AWLEN => S_AXI_GP0_AWLEN,
    S_AXI_GP0_AWQOS => S_AXI_GP0_AWQOS,
    S_AXI_GP0_WSTRB => S_AXI_GP0_WSTRB,
    S_AXI_GP0_ARID => S_AXI_GP0_ARID,
    S_AXI_GP0_AWID => S_AXI_GP0_AWID,
    S_AXI_GP0_WID => S_AXI_GP0_WID,
    FCLK_CLK0 => FCLK_CLK0,
    FCLK_CLK1 => FCLK_CLK1,
    FCLK_RESET0_N => FCLK_RESET0_N,
    MIO => MIO,
    DDR_CAS_n => DDR_CAS_n,
    DDR_CKE => DDR_CKE,
    DDR_Clk_n => DDR_Clk_n,
    DDR_Clk => DDR_Clk,
    DDR_CS_n => DDR_CS_n,
    DDR_DRSTB => DDR_DRSTB,
    DDR_ODT => DDR_ODT,
    DDR_RAS_n => DDR_RAS_n,
    DDR_WEB => DDR_WEB,
    DDR_BankAddr => DDR_BankAddr,
    DDR_Addr => DDR_Addr,
    DDR_VRN => DDR_VRN,
    DDR_VRP => DDR_VRP,
    DDR_DM => DDR_DM,
    DDR_DQ => DDR_DQ,
    DDR_DQS_n => DDR_DQS_n,
    DDR_DQS => DDR_DQS,
    PS_SRSTB => PS_SRSTB,
    PS_CLK => PS_CLK,
    PS_PORB => PS_PORB
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file leon3_zc702_stub_processing_system7_0_0.vhd when simulating
-- the core, leon3_zc702_stub_processing_system7_0_0. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.


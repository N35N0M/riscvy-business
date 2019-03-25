library IEEE; use IEEE.STD_LOGIC_1164.ALL;
library UNISIM; use UNISIM.VCOMPONENTS.ALL; 
entity leon3_zc702_stub is
  port (
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FCLK_CLK0 : out STD_LOGIC;
    FCLK_CLK1 : out STD_LOGIC;
    FCLK_RESET0_N : out STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    S_AXI_GP0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_arready : out STD_LOGIC;
    S_AXI_GP0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_arvalid : in STD_LOGIC;
    S_AXI_GP0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_awready : out STD_LOGIC;
    S_AXI_GP0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_awvalid : in STD_LOGIC;
    S_AXI_GP0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_bready : in STD_LOGIC;
    S_AXI_GP0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_bvalid : out STD_LOGIC;
    S_AXI_GP0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_rlast : out STD_LOGIC;
    S_AXI_GP0_rready : in STD_LOGIC;
    S_AXI_GP0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_rvalid : out STD_LOGIC;
    S_AXI_GP0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_wlast : in STD_LOGIC;
    S_AXI_GP0_wready : out STD_LOGIC;
    S_AXI_GP0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_wvalid : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of leon3_zc702_stub : entity is "leon3_zc702_stub,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0}";
end leon3_zc702_stub;

architecture STRUCTURE of leon3_zc702_stub is
  component leon3_zc702_stub_processing_system7_0_0 is
  port (
    USB0_PORT_INDCTL : out STD_LOGIC_VECTOR ( 1 downto 0 );
    USB0_VBUS_PWRSELECT : out STD_LOGIC;
    USB0_VBUS_PWRFAULT : in STD_LOGIC;
    S_AXI_GP0_ARREADY : out STD_LOGIC;
    S_AXI_GP0_AWREADY : out STD_LOGIC;
    S_AXI_GP0_BVALID : out STD_LOGIC;
    S_AXI_GP0_RLAST : out STD_LOGIC;
    S_AXI_GP0_RVALID : out STD_LOGIC;
    S_AXI_GP0_WREADY : out STD_LOGIC;
    S_AXI_GP0_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_BID : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_RID : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_ACLK : in STD_LOGIC;
    S_AXI_GP0_ARVALID : in STD_LOGIC;
    S_AXI_GP0_AWVALID : in STD_LOGIC;
    S_AXI_GP0_BREADY : in STD_LOGIC;
    S_AXI_GP0_RREADY : in STD_LOGIC;
    S_AXI_GP0_WLAST : in STD_LOGIC;
    S_AXI_GP0_WVALID : in STD_LOGIC;
    S_AXI_GP0_ARBURST : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_ARLOCK : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_ARSIZE : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_AWBURST : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_AWLOCK : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_AWSIZE : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_ARPROT : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_AWPROT : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_ARADDR : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_AWADDR : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_ARCACHE : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_ARLEN : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_ARQOS : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_AWCACHE : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_AWLEN : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_AWQOS : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_ARID : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_AWID : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_WID : in STD_LOGIC_VECTOR ( 5 downto 0 );
    FCLK_CLK0 : out STD_LOGIC;
    FCLK_CLK1 : out STD_LOGIC;
    FCLK_RESET0_N : out STD_LOGIC;
    MIO : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    DDR_CAS_n : inout STD_LOGIC;
    DDR_CKE : inout STD_LOGIC;
    DDR_Clk_n : inout STD_LOGIC;
    DDR_Clk : inout STD_LOGIC;
    DDR_CS_n : inout STD_LOGIC;
    DDR_DRSTB : inout STD_LOGIC;
    DDR_ODT : inout STD_LOGIC;
    DDR_RAS_n : inout STD_LOGIC;
    DDR_WEB : inout STD_LOGIC;
    DDR_BankAddr : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_Addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_VRN : inout STD_LOGIC;
    DDR_VRP : inout STD_LOGIC;
    DDR_DM : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_DQ : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_DQS_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_DQS : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    PS_SRSTB : inout STD_LOGIC;
    PS_CLK : inout STD_LOGIC;
    PS_PORB : inout STD_LOGIC
  );
  end component leon3_zc702_stub_processing_system7_0_0;
  signal GND_1 : STD_LOGIC;
  signal S_AXI_GP0_1_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal S_AXI_GP0_1_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal S_AXI_GP0_1_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal S_AXI_GP0_1_ARID : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal S_AXI_GP0_1_ARLEN : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal S_AXI_GP0_1_ARLOCK : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal S_AXI_GP0_1_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S_AXI_GP0_1_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal S_AXI_GP0_1_ARREADY : STD_LOGIC;
  signal S_AXI_GP0_1_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S_AXI_GP0_1_ARVALID : STD_LOGIC;
  signal S_AXI_GP0_1_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal S_AXI_GP0_1_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal S_AXI_GP0_1_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal S_AXI_GP0_1_AWID : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal S_AXI_GP0_1_AWLEN : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal S_AXI_GP0_1_AWLOCK : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal S_AXI_GP0_1_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S_AXI_GP0_1_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal S_AXI_GP0_1_AWREADY : STD_LOGIC;
  signal S_AXI_GP0_1_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal S_AXI_GP0_1_AWVALID : STD_LOGIC;
  signal S_AXI_GP0_1_BID : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal S_AXI_GP0_1_BREADY : STD_LOGIC;
  signal S_AXI_GP0_1_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal S_AXI_GP0_1_BVALID : STD_LOGIC;
  signal S_AXI_GP0_1_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal S_AXI_GP0_1_RID : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal S_AXI_GP0_1_RLAST : STD_LOGIC;
  signal S_AXI_GP0_1_RREADY : STD_LOGIC;
  signal S_AXI_GP0_1_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal S_AXI_GP0_1_RVALID : STD_LOGIC;
  signal S_AXI_GP0_1_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal S_AXI_GP0_1_WID : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal S_AXI_GP0_1_WLAST : STD_LOGIC;
  signal S_AXI_GP0_1_WREADY : STD_LOGIC;
  signal S_AXI_GP0_1_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal S_AXI_GP0_1_WVALID : STD_LOGIC;
  signal processing_system7_0_DDR_ADDR : STD_LOGIC_VECTOR ( 14 downto 0 );
  signal processing_system7_0_DDR_BA : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal processing_system7_0_DDR_CAS_N : STD_LOGIC;
  signal processing_system7_0_DDR_CKE : STD_LOGIC;
  signal processing_system7_0_DDR_CK_N : STD_LOGIC;
  signal processing_system7_0_DDR_CK_P : STD_LOGIC;
  signal processing_system7_0_DDR_CS_N : STD_LOGIC;
  signal processing_system7_0_DDR_DM : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_DDR_DQ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal processing_system7_0_DDR_DQS_N : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_DDR_DQS_P : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_DDR_ODT : STD_LOGIC;
  signal processing_system7_0_DDR_RAS_N : STD_LOGIC;
  signal processing_system7_0_DDR_RESET_N : STD_LOGIC;
  signal processing_system7_0_DDR_WE_N : STD_LOGIC;
  signal processing_system7_0_FCLK_CLK0 : STD_LOGIC;
  signal processing_system7_0_FCLK_CLK1 : STD_LOGIC;
  signal processing_system7_0_FCLK_RESET0_N : STD_LOGIC;
  signal processing_system7_0_FIXED_IO_DDR_VRN : STD_LOGIC;
  signal processing_system7_0_FIXED_IO_DDR_VRP : STD_LOGIC;
  signal processing_system7_0_FIXED_IO_MIO : STD_LOGIC_VECTOR ( 53 downto 0 );
  signal processing_system7_0_FIXED_IO_PS_CLK : STD_LOGIC;
  signal processing_system7_0_FIXED_IO_PS_PORB : STD_LOGIC;
  signal processing_system7_0_FIXED_IO_PS_SRSTB : STD_LOGIC;
  signal NLW_processing_system7_0_USB0_VBUS_PWRSELECT_UNCONNECTED : STD_LOGIC;
  signal NLW_processing_system7_0_USB0_PORT_INDCTL_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
begin
  FCLK_CLK0 <= processing_system7_0_FCLK_CLK0;
  FCLK_CLK1 <= processing_system7_0_FCLK_CLK1;
  FCLK_RESET0_N <= processing_system7_0_FCLK_RESET0_N;
  S_AXI_GP0_1_ARADDR(31 downto 0) <= S_AXI_GP0_araddr(31 downto 0);
  S_AXI_GP0_1_ARBURST(1 downto 0) <= S_AXI_GP0_arburst(1 downto 0);
  S_AXI_GP0_1_ARCACHE(3 downto 0) <= S_AXI_GP0_arcache(3 downto 0);
  S_AXI_GP0_1_ARID(5 downto 0) <= S_AXI_GP0_arid(5 downto 0);
  S_AXI_GP0_1_ARLEN(3 downto 0) <= S_AXI_GP0_arlen(3 downto 0);
  S_AXI_GP0_1_ARLOCK(1 downto 0) <= S_AXI_GP0_arlock(1 downto 0);
  S_AXI_GP0_1_ARPROT(2 downto 0) <= S_AXI_GP0_arprot(2 downto 0);
  S_AXI_GP0_1_ARQOS(3 downto 0) <= S_AXI_GP0_arqos(3 downto 0);
  S_AXI_GP0_1_ARSIZE(2 downto 0) <= S_AXI_GP0_arsize(2 downto 0);
  S_AXI_GP0_1_ARVALID <= S_AXI_GP0_arvalid;
  S_AXI_GP0_1_AWADDR(31 downto 0) <= S_AXI_GP0_awaddr(31 downto 0);
  S_AXI_GP0_1_AWBURST(1 downto 0) <= S_AXI_GP0_awburst(1 downto 0);
  S_AXI_GP0_1_AWCACHE(3 downto 0) <= S_AXI_GP0_awcache(3 downto 0);
  S_AXI_GP0_1_AWID(5 downto 0) <= S_AXI_GP0_awid(5 downto 0);
  S_AXI_GP0_1_AWLEN(3 downto 0) <= S_AXI_GP0_awlen(3 downto 0);
  S_AXI_GP0_1_AWLOCK(1 downto 0) <= S_AXI_GP0_awlock(1 downto 0);
  S_AXI_GP0_1_AWPROT(2 downto 0) <= S_AXI_GP0_awprot(2 downto 0);
  S_AXI_GP0_1_AWQOS(3 downto 0) <= S_AXI_GP0_awqos(3 downto 0);
  S_AXI_GP0_1_AWSIZE(2 downto 0) <= S_AXI_GP0_awsize(2 downto 0);
  S_AXI_GP0_1_AWVALID <= S_AXI_GP0_awvalid;
  S_AXI_GP0_1_BREADY <= S_AXI_GP0_bready;
  S_AXI_GP0_1_RREADY <= S_AXI_GP0_rready;
  S_AXI_GP0_1_WDATA(31 downto 0) <= S_AXI_GP0_wdata(31 downto 0);
  S_AXI_GP0_1_WID(5 downto 0) <= S_AXI_GP0_wid(5 downto 0);
  S_AXI_GP0_1_WLAST <= S_AXI_GP0_wlast;
  S_AXI_GP0_1_WSTRB(3 downto 0) <= S_AXI_GP0_wstrb(3 downto 0);
  S_AXI_GP0_1_WVALID <= S_AXI_GP0_wvalid;
  S_AXI_GP0_arready <= S_AXI_GP0_1_ARREADY;
  S_AXI_GP0_awready <= S_AXI_GP0_1_AWREADY;
  S_AXI_GP0_bid(5 downto 0) <= S_AXI_GP0_1_BID(5 downto 0);
  S_AXI_GP0_bresp(1 downto 0) <= S_AXI_GP0_1_BRESP(1 downto 0);
  S_AXI_GP0_bvalid <= S_AXI_GP0_1_BVALID;
  S_AXI_GP0_rdata(31 downto 0) <= S_AXI_GP0_1_RDATA(31 downto 0);
  S_AXI_GP0_rid(5 downto 0) <= S_AXI_GP0_1_RID(5 downto 0);
  S_AXI_GP0_rlast <= S_AXI_GP0_1_RLAST;
  S_AXI_GP0_rresp(1 downto 0) <= S_AXI_GP0_1_RRESP(1 downto 0);
  S_AXI_GP0_rvalid <= S_AXI_GP0_1_RVALID;
  S_AXI_GP0_wready <= S_AXI_GP0_1_WREADY;
GND: unisim.vcomponents.GND
    port map (
      G => GND_1
    );
processing_system7_0: component leon3_zc702_stub_processing_system7_0_0
    port map (
      DDR_Addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_BankAddr(2 downto 0) => DDR_ba(2 downto 0),
      DDR_CAS_n => DDR_cas_n,
      DDR_CKE => DDR_cke,
      DDR_CS_n => DDR_cs_n,
      DDR_Clk => DDR_ck_p,
      DDR_Clk_n => DDR_ck_n,
      DDR_DM(3 downto 0) => DDR_dm(3 downto 0),
      DDR_DQ(31 downto 0) => DDR_dq(31 downto 0),
      DDR_DQS(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_DQS_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_DRSTB => DDR_reset_n,
      DDR_ODT => DDR_odt,
      DDR_RAS_n => DDR_ras_n,
      DDR_VRN => FIXED_IO_ddr_vrn,
      DDR_VRP => FIXED_IO_ddr_vrp,
      DDR_WEB => DDR_we_n,
      FCLK_CLK0 => processing_system7_0_FCLK_CLK0,
      FCLK_CLK1 => processing_system7_0_FCLK_CLK1,
      FCLK_RESET0_N => processing_system7_0_FCLK_RESET0_N,
      MIO(53 downto 0) => FIXED_IO_mio(53 downto 0),
      PS_CLK => FIXED_IO_ps_clk,
      PS_PORB => FIXED_IO_ps_porb,
      PS_SRSTB => FIXED_IO_ps_srstb,
      S_AXI_GP0_ACLK => processing_system7_0_FCLK_CLK0,
      S_AXI_GP0_ARADDR(31 downto 0) => S_AXI_GP0_1_ARADDR(31 downto 0),
      S_AXI_GP0_ARBURST(1 downto 0) => S_AXI_GP0_1_ARBURST(1 downto 0),
      S_AXI_GP0_ARCACHE(3 downto 0) => S_AXI_GP0_1_ARCACHE(3 downto 0),
      S_AXI_GP0_ARID(5 downto 0) => S_AXI_GP0_1_ARID(5 downto 0),
      S_AXI_GP0_ARLEN(3 downto 0) => S_AXI_GP0_1_ARLEN(3 downto 0),
      S_AXI_GP0_ARLOCK(1 downto 0) => S_AXI_GP0_1_ARLOCK(1 downto 0),
      S_AXI_GP0_ARPROT(2 downto 0) => S_AXI_GP0_1_ARPROT(2 downto 0),
      S_AXI_GP0_ARQOS(3 downto 0) => S_AXI_GP0_1_ARQOS(3 downto 0),
      S_AXI_GP0_ARREADY => S_AXI_GP0_1_ARREADY,
      S_AXI_GP0_ARSIZE(2 downto 0) => S_AXI_GP0_1_ARSIZE(2 downto 0),
      S_AXI_GP0_ARVALID => S_AXI_GP0_1_ARVALID,
      S_AXI_GP0_AWADDR(31 downto 0) => S_AXI_GP0_1_AWADDR(31 downto 0),
      S_AXI_GP0_AWBURST(1 downto 0) => S_AXI_GP0_1_AWBURST(1 downto 0),
      S_AXI_GP0_AWCACHE(3 downto 0) => S_AXI_GP0_1_AWCACHE(3 downto 0),
      S_AXI_GP0_AWID(5 downto 0) => S_AXI_GP0_1_AWID(5 downto 0),
      S_AXI_GP0_AWLEN(3 downto 0) => S_AXI_GP0_1_AWLEN(3 downto 0),
      S_AXI_GP0_AWLOCK(1 downto 0) => S_AXI_GP0_1_AWLOCK(1 downto 0),
      S_AXI_GP0_AWPROT(2 downto 0) => S_AXI_GP0_1_AWPROT(2 downto 0),
      S_AXI_GP0_AWQOS(3 downto 0) => S_AXI_GP0_1_AWQOS(3 downto 0),
      S_AXI_GP0_AWREADY => S_AXI_GP0_1_AWREADY,
      S_AXI_GP0_AWSIZE(2 downto 0) => S_AXI_GP0_1_AWSIZE(2 downto 0),
      S_AXI_GP0_AWVALID => S_AXI_GP0_1_AWVALID,
      S_AXI_GP0_BID(5 downto 0) => S_AXI_GP0_1_BID(5 downto 0),
      S_AXI_GP0_BREADY => S_AXI_GP0_1_BREADY,
      S_AXI_GP0_BRESP(1 downto 0) => S_AXI_GP0_1_BRESP(1 downto 0),
      S_AXI_GP0_BVALID => S_AXI_GP0_1_BVALID,
      S_AXI_GP0_RDATA(31 downto 0) => S_AXI_GP0_1_RDATA(31 downto 0),
      S_AXI_GP0_RID(5 downto 0) => S_AXI_GP0_1_RID(5 downto 0),
      S_AXI_GP0_RLAST => S_AXI_GP0_1_RLAST,
      S_AXI_GP0_RREADY => S_AXI_GP0_1_RREADY,
      S_AXI_GP0_RRESP(1 downto 0) => S_AXI_GP0_1_RRESP(1 downto 0),
      S_AXI_GP0_RVALID => S_AXI_GP0_1_RVALID,
      S_AXI_GP0_WDATA(31 downto 0) => S_AXI_GP0_1_WDATA(31 downto 0),
      S_AXI_GP0_WID(5 downto 0) => S_AXI_GP0_1_WID(5 downto 0),
      S_AXI_GP0_WLAST => S_AXI_GP0_1_WLAST,
      S_AXI_GP0_WREADY => S_AXI_GP0_1_WREADY,
      S_AXI_GP0_WSTRB(3 downto 0) => S_AXI_GP0_1_WSTRB(3 downto 0),
      S_AXI_GP0_WVALID => S_AXI_GP0_1_WVALID,
      USB0_PORT_INDCTL(1 downto 0) => NLW_processing_system7_0_USB0_PORT_INDCTL_UNCONNECTED(1 downto 0),
      USB0_VBUS_PWRFAULT => GND_1,
      USB0_VBUS_PWRSELECT => NLW_processing_system7_0_USB0_VBUS_PWRSELECT_UNCONNECTED
    );
end STRUCTURE;

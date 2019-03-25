library IEEE; use IEEE.STD_LOGIC_1164.ALL;
library UNISIM; use UNISIM.VCOMPONENTS.ALL; 
entity leon3_zc702_stub_wrapper is
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
end leon3_zc702_stub_wrapper;

architecture STRUCTURE of leon3_zc702_stub_wrapper is
  component leon3_zc702_stub is
  port (
    FCLK_CLK0 : out STD_LOGIC;
    FCLK_CLK1 : out STD_LOGIC;
    FCLK_RESET0_N : out STD_LOGIC;
    S_AXI_GP0_arready : out STD_LOGIC;
    S_AXI_GP0_awready : out STD_LOGIC;
    S_AXI_GP0_bvalid : out STD_LOGIC;
    S_AXI_GP0_rlast : out STD_LOGIC;
    S_AXI_GP0_rvalid : out STD_LOGIC;
    S_AXI_GP0_wready : out STD_LOGIC;
    S_AXI_GP0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_arvalid : in STD_LOGIC;
    S_AXI_GP0_awvalid : in STD_LOGIC;
    S_AXI_GP0_bready : in STD_LOGIC;
    S_AXI_GP0_rready : in STD_LOGIC;
    S_AXI_GP0_wlast : in STD_LOGIC;
    S_AXI_GP0_wvalid : in STD_LOGIC;
    S_AXI_GP0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC
  );
  end component leon3_zc702_stub;
begin
leon3_zc702_stub_i: component leon3_zc702_stub
    port map (
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      FCLK_CLK0 => FCLK_CLK0,
      FCLK_CLK1 => FCLK_CLK1,
      FCLK_RESET0_N => FCLK_RESET0_N,
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      S_AXI_GP0_araddr(31 downto 0) => S_AXI_GP0_araddr(31 downto 0),
      S_AXI_GP0_arburst(1 downto 0) => S_AXI_GP0_arburst(1 downto 0),
      S_AXI_GP0_arcache(3 downto 0) => S_AXI_GP0_arcache(3 downto 0),
      S_AXI_GP0_arid(5 downto 0) => S_AXI_GP0_arid(5 downto 0),
      S_AXI_GP0_arlen(3 downto 0) => S_AXI_GP0_arlen(3 downto 0),
      S_AXI_GP0_arlock(1 downto 0) => S_AXI_GP0_arlock(1 downto 0),
      S_AXI_GP0_arprot(2 downto 0) => S_AXI_GP0_arprot(2 downto 0),
      S_AXI_GP0_arqos(3 downto 0) => S_AXI_GP0_arqos(3 downto 0),
      S_AXI_GP0_arready => S_AXI_GP0_arready,
      S_AXI_GP0_arsize(2 downto 0) => S_AXI_GP0_arsize(2 downto 0),
      S_AXI_GP0_arvalid => S_AXI_GP0_arvalid,
      S_AXI_GP0_awaddr(31 downto 0) => S_AXI_GP0_awaddr(31 downto 0),
      S_AXI_GP0_awburst(1 downto 0) => S_AXI_GP0_awburst(1 downto 0),
      S_AXI_GP0_awcache(3 downto 0) => S_AXI_GP0_awcache(3 downto 0),
      S_AXI_GP0_awid(5 downto 0) => S_AXI_GP0_awid(5 downto 0),
      S_AXI_GP0_awlen(3 downto 0) => S_AXI_GP0_awlen(3 downto 0),
      S_AXI_GP0_awlock(1 downto 0) => S_AXI_GP0_awlock(1 downto 0),
      S_AXI_GP0_awprot(2 downto 0) => S_AXI_GP0_awprot(2 downto 0),
      S_AXI_GP0_awqos(3 downto 0) => S_AXI_GP0_awqos(3 downto 0),
      S_AXI_GP0_awready => S_AXI_GP0_awready,
      S_AXI_GP0_awsize(2 downto 0) => S_AXI_GP0_awsize(2 downto 0),
      S_AXI_GP0_awvalid => S_AXI_GP0_awvalid,
      S_AXI_GP0_bid(5 downto 0) => S_AXI_GP0_bid(5 downto 0),
      S_AXI_GP0_bready => S_AXI_GP0_bready,
      S_AXI_GP0_bresp(1 downto 0) => S_AXI_GP0_bresp(1 downto 0),
      S_AXI_GP0_bvalid => S_AXI_GP0_bvalid,
      S_AXI_GP0_rdata(31 downto 0) => S_AXI_GP0_rdata(31 downto 0),
      S_AXI_GP0_rid(5 downto 0) => S_AXI_GP0_rid(5 downto 0),
      S_AXI_GP0_rlast => S_AXI_GP0_rlast,
      S_AXI_GP0_rready => S_AXI_GP0_rready,
      S_AXI_GP0_rresp(1 downto 0) => S_AXI_GP0_rresp(1 downto 0),
      S_AXI_GP0_rvalid => S_AXI_GP0_rvalid,
      S_AXI_GP0_wdata(31 downto 0) => S_AXI_GP0_wdata(31 downto 0),
      S_AXI_GP0_wid(5 downto 0) => S_AXI_GP0_wid(5 downto 0),
      S_AXI_GP0_wlast => S_AXI_GP0_wlast,
      S_AXI_GP0_wready => S_AXI_GP0_wready,
      S_AXI_GP0_wstrb(3 downto 0) => S_AXI_GP0_wstrb(3 downto 0),
      S_AXI_GP0_wvalid => S_AXI_GP0_wvalid
    );
end STRUCTURE;

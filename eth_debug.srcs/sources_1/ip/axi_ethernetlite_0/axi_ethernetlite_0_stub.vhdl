-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
-- Date        : Fri Mar 25 21:04:03 2022
-- Host        : dillon-arch running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub
--               /home/dillon/git/eth_debug/eth_debug.srcs/sources_1/ip/axi_ethernetlite_0/axi_ethernetlite_0_stub.vhdl
-- Design      : axi_ethernetlite_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity axi_ethernetlite_0 is
  Port ( 
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    ip2intc_irpt : out STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    phy_tx_clk : in STD_LOGIC;
    phy_rx_clk : in STD_LOGIC;
    phy_crs : in STD_LOGIC;
    phy_dv : in STD_LOGIC;
    phy_rx_data : in STD_LOGIC_VECTOR ( 3 downto 0 );
    phy_col : in STD_LOGIC;
    phy_rx_er : in STD_LOGIC;
    phy_rst_n : out STD_LOGIC;
    phy_tx_en : out STD_LOGIC;
    phy_tx_data : out STD_LOGIC_VECTOR ( 3 downto 0 )
  );

end axi_ethernetlite_0;

architecture stub of axi_ethernetlite_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "s_axi_aclk,s_axi_aresetn,ip2intc_irpt,s_axi_awaddr[12:0],s_axi_awvalid,s_axi_awready,s_axi_wdata[31:0],s_axi_wstrb[3:0],s_axi_wvalid,s_axi_wready,s_axi_bresp[1:0],s_axi_bvalid,s_axi_bready,s_axi_araddr[12:0],s_axi_arvalid,s_axi_arready,s_axi_rdata[31:0],s_axi_rresp[1:0],s_axi_rvalid,s_axi_rready,phy_tx_clk,phy_rx_clk,phy_crs,phy_dv,phy_rx_data[3:0],phy_col,phy_rx_er,phy_rst_n,phy_tx_en,phy_tx_data[3:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "axi_ethernetlite,Vivado 2021.2";
begin
end;
